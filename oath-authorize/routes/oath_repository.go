package routes

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/julienschmidt/httprouter"
	"github.com/lpernett/godotenv"
	"go.mongodb.org/mongo-driver/bson"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"log"
	"net/http"
	"oath-authorize-gitlab/auth"
	db "oath-authorize-gitlab/database"
	"oath-authorize-gitlab/models"
	"oath-authorize-gitlab/utils"
	"os"
	"strings"
	"time"
)

var (
	googleOauthConfig *oauth2.Config
	// TODO: randomize it
	oauthStateString = "pseudo-random"
)

func init() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalln("Error loading .env file")
	}
	fmt.Println("GOOGLE_CLIENT_ID: ", os.Getenv("GOOGLE_CLIENT_ID"))
	fmt.Println("GOOGLE_CLIENT_SECRET: ", os.Getenv("GOOGLE_CLIENT_SECRET"))

	googleOauthConfig = &oauth2.Config{
		RedirectURL:  "http://localhost:8000/callback",
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
}

func HandleMain(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	var htmlIndex = `<html>
<body>
	<a href="/login">Google Log In</a>
</body>
</html>`

	fmt.Fprintf(w, htmlIndex)
}

func RegisterForm(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	tokenString := r.Header.Get("Authorization")

	usernameValue := r.FormValue("username")
	emailValue := r.FormValue("email")

	err := r.ParseForm()
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	// Your existing code...
	var htmlIndex = `<html>
<body>
<p> "` + tokenString + `"</p>
    <form action="/auth/register-oauth" method="post">
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" value="` + usernameValue + `" disabled><br>
        <label for="email">Email:</label><br>
        <input type="text" id="email" name="email" value="` + emailValue + `" disabled><br>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" value="` + "" + `"><br>
        <input type="hidden" id="roles" name="roles" value="` + "ROLE_USER" + `" disabled><br>
        <input type="submit" value="Register">
	</form>
</body>
</html>`

	fmt.Fprintf(w, htmlIndex)

}

func HandleGoogleLogin(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	url := googleOauthConfig.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func GenerateToken(username string) (string, error) {
	token, err := auth.Create(username)
	if err != nil {
		fmt.Println("errCreate")
		fmt.Println(err)
		return "", err
	}
	return token, nil
}

func HandleGoogleCallback(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")

	token, email, username, err := getUserInfo(r.FormValue("state"), r.FormValue("code"))
	if err != nil {
		fmt.Println(err.Error())
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}
	if email == nil || username == nil {
		fmt.Errorf("email or username is nil")
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}
	//result := map[string]interface{}{"token": token, "email": email, "username": username}
	fmt.Println("email: ", *email)

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}
	var user models.User
	errFindEmail := collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE email=$1", email).Scan(&user.ID, &user.Username, &user.Email, &user.Password, &user.Roles)

	if errFindEmail != nil {
		fmt.Println("User does not exist, create new user")
		password := ""
		newUser := models.User{Username: *username, Email: *email, Password: password, Roles: "ROLE_USER"}
		_, errs := collectionPostgres.Exec("INSERT INTO userinfo (username, email, password,roles) VALUES ($1, $2, $3,$4)", newUser.Username, newUser.Email, newUser.Password, newUser.Roles)
		if errs != nil {
			utils.JSON(w, 500, "Register has failed", errs)
			return
		}
	}

	fmt.Println("User already exists, create jwt token")
	accessToken, err := GenerateToken(*username)
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}
	// Connect to MongoDB
	collectionMongo := db.ConnectMongo(os.Getenv("TokenCollectionMongo"))
	newToken := bson.M{"token": token, "user": username, "created_at": time.Now()}
	_, errs := collectionMongo.InsertOne(context.TODO(), newToken)
	if errs != nil {
		utils.JSON(w, 500, "Error create token", nil)
		return
	}
	response := map[string]string{"token": accessToken}

	utils.JSON(w, 200, "create token successfully", response)

}

func getUserInfo(state string, code string) (*string, *string, *string, error) {
	if state != oauthStateString {
		return nil, nil, nil, fmt.Errorf("invalid oauth state")
	}

	token, err := googleOauthConfig.Exchange(oauth2.NoContext, code)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("code exchange failed: %s", err.Error())
	}

	contents, err := auth.CheckTokenOauth(token.AccessToken)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("Invalid token oauth2: %s", err.Error())
	}

	//get email in contents
	var result map[string]interface{}
	err = json.Unmarshal(contents, &result)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("failed to parse user info: %s", err.Error())
	}
	email, ok := result["email"].(string)
	if !ok {
		return nil, nil, nil, fmt.Errorf("email is not a string")
	}
	parts := strings.Split(email, "@")
	if len(parts) < 2 {
		return nil, nil, nil, fmt.Errorf("invalid email format")
	}
	username := parts[0]
	fmt.Println("username: ", username)

	return &token.AccessToken, &email, &username, nil
}
