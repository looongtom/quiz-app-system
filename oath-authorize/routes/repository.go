package routes

import (
	"context"
	"fmt"
	"github.com/asaskevich/govalidator"
	"github.com/julienschmidt/httprouter"
	"go.mongodb.org/mongo-driver/bson"
	"log"
	"net/http"
	"oath-authorize-gitlab/auth"
	db "oath-authorize-gitlab/database"
	"oath-authorize-gitlab/models"
	"oath-authorize-gitlab/utils"
	"os"
	"regexp"
	"strings"
	"time"
)

func init() {
	govalidator.TagMap["email"] = govalidator.Validator(func(str string) bool {
		return strings.HasSuffix(str, "@gmail.com") || strings.HasSuffix(str, "@yahoo.com")
	})

	govalidator.TagMap["password"] = govalidator.Validator(func(str string) bool {
		if len(str) < 8 {
			return false
		}
		hasUpper := regexp.MustCompile(`[A-Z]`).MatchString
		if !hasUpper(str) {
			return false
		}
		hasSpecial := regexp.MustCompile(`[^a-zA-Z0-9\s]`).MatchString
		if !hasSpecial(str) {
			return false
		}
		return true
	})
}

func RegisterOAuth(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	username := r.PostFormValue("username")
	email := r.PostFormValue("email")
	password := r.PostFormValue("password")
	roles := r.PostFormValue("roles")

	// Now you have the form values, you can process them as needed
	// For example, you can print them
	fmt.Println("Username: ", username)
	fmt.Println("Email: ", email)
	fmt.Println("Password: ", password)
	fmt.Println("Roles: ", roles)

	// After processing the form data, you can send a response back to the client
	utils.JSON(w, 200, "Form submitted successfully", nil)

}

func Register(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	username := r.PostFormValue("username")
	email := r.PostFormValue("email")
	password := r.PostFormValue("password")
	roles := r.PostFormValue("roles")

	if govalidator.IsNull(email) || govalidator.IsNull(password) {
		utils.JSON(w, 400, "Data can not empty", nil)
		return
	}

	if !govalidator.IsEmail(email) || !govalidator.TagMap["email"](email) {
		utils.JSON(w, 400, "Email is invalid", nil)
		return
	}

	if !govalidator.TagMap["password"](password) {
		utils.JSON(w, 400, "Password must contain at least 8 digits, using upper case and special character", nil)
		return
	}

	if govalidator.IsNull(username) || govalidator.IsNull(email) || govalidator.IsNull(password) {
		utils.JSON(w, 400, "Data can not empty", nil)
		return
	}

	if !govalidator.IsEmail(email) {
		utils.JSON(w, 400, "Email is invalid", nil)
		return
	}

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	createTable := `
		CREATE TABLE IF NOT EXISTS userinfo (
			id SERIAL PRIMARY KEY,
            username VARCHAR(255) NOT NULL ,
            email VARCHAR(255) NOT NULL,
            password VARCHAR(255) NOT NULL,
		    roles VARCHAR(255) NOT NULL 
		);
	`
	_, err = collectionPostgres.Exec(createTable)

	if err != nil {
		utils.JSON(w, 500, "Failed to create users table", nil)
		log.Println(err)
		return
	}

	var result models.User
	errFindUsername := collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE username=$1", username).Scan(&result.ID, &result.Username, &result.Email, &result.Password, &result.Roles)
	errFindEmail := collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE email=$1", email).Scan(&result.ID, &result.Username, &result.Email, &result.Password, &result.Roles)

	if errFindUsername == nil || errFindEmail == nil {
		utils.JSON(w, 400, "Username or Email already exists", nil)
		return
	}

	password, err = models.Hash(password)

	if err != nil {
		utils.JSON(w, 500, "Register has failed", nil)
		return
	}

	newUser := models.User{Username: username, Email: email, Password: password, Roles: roles}

	_, errs := collectionPostgres.Exec("INSERT INTO userinfo (username, email, password,roles) VALUES ($1, $2, $3,$4)", newUser.Username, newUser.Email, newUser.Password, newUser.Roles)

	if errs != nil {
		utils.JSON(w, 500, "Register has failed", errs)
		return
	}

	utils.JSON(w, 201, "Register Succesfully", newUser)
}

func Login(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")

	username := r.PostFormValue("username")
	password := r.PostFormValue("password")
	if govalidator.IsNull(username) || govalidator.IsNull(password) {
		utils.JSON(w, 400, "Data can not empty", nil)
		return
	}
	username = models.Santize(username)
	password = models.Santize(password)

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	//find user in postgres sql
	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE username=$1", username).Scan(&result.ID, &result.Username, &result.Email, &result.Password, &result.Roles)

	fmt.Println("user login:")
	fmt.Println(result)

	if err != nil {
		utils.JSON(w, 400, "Username or Password incorrect", nil)
		return
	}

	hashedPassword := fmt.Sprintf("%v", result.Password)
	err = models.CheckPasswordHash(hashedPassword, password)

	if err != nil {
		utils.JSON(w, 401, "Username or Password incorrect", nil)
		return
	}

	token, errCreate := auth.Create(username)
	if errCreate != nil {
		fmt.Println("errCreate")
		fmt.Println(errCreate)

		fmt.Println("token")
		fmt.Println(token)
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

	response := map[string]string{"token": token}

	utils.JSON(w, 200, "create token successfully", response)

}

func GetProfile(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Invalid token", nil)
		return
	}

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,username,email,roles FROM userinfo WHERE username=$1", userName).Scan(&result.ID, &result.Username, &result.Email, &result.Roles)

	utils.JSON(w, 200, "success", result)
}
func GetByUserName(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}
	//get request param named "username"
	username := r.URL.Query().Get("username")

	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,username,email,roles FROM userinfo WHERE username=$1", username).Scan(&result.ID, &result.Username, &result.Email, &result.Roles)

	utils.JSON(w, 200, "success", result)
}

func ChangePassword(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Invalid token", nil)
		return
	}

	oldPassword := r.PostFormValue("oldPassword")
	newPassword := r.PostFormValue("newPassword")
	if govalidator.IsNull(oldPassword) || govalidator.IsNull(newPassword) {
		utils.JSON(w, 400, "Data can not empty", nil)
		return
	}

	oldPassword = models.Santize(oldPassword)
	newPassword = models.Santize(newPassword)

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE username=$1", userName).Scan(&result.ID, &result.Username, &result.Email, &result.Password, &result.Roles)

	if err != nil {
		utils.JSON(w, 400, "Username or Password incorrect", nil)
		return
	}

	hashedPassword := fmt.Sprintf("%v", result.Password)
	err = models.CheckPasswordHash(hashedPassword, oldPassword)

	if err != nil {
		utils.JSON(w, 401, "Username or Password incorrect", nil)
		return
	}

	newPassword, err = models.Hash(newPassword)

	if err != nil {
		utils.JSON(w, 500, "Register has failed", nil)
		return
	}

	_, errs := collectionPostgres.Exec("UPDATE userinfo SET password=$1 WHERE id=$2", newPassword, result.ID)

	if errs != nil {
		utils.JSON(w, 500, "Change password has failed", errs)
		return
	}

	utils.JSON(w, 200, "Change password successfully", nil)

}

func ChangePasswordFirstTime(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Invalid token", nil)
		return
	}

	newPassword := r.PostFormValue("newPassword")
	if govalidator.IsNull(newPassword) {
		utils.JSON(w, 400, "Data can not empty", nil)
		return
	}

	newPassword = models.Santize(newPassword)

	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,username,email,password,roles FROM userinfo WHERE username=$1", userName).Scan(&result.ID, &result.Username, &result.Email, &result.Password, &result.Roles)

	if err != nil {
		utils.JSON(w, 400, "Username or Password incorrect", nil)
		return
	}

	newPassword, err = models.Hash(newPassword)

	if err != nil {
		utils.JSON(w, 500, "Register has failed", nil)
		return
	}

	_, errs := collectionPostgres.Exec("UPDATE userinfo SET password=$1 WHERE id=$2", newPassword, result.ID)

	if errs != nil {
		utils.JSON(w, 500, "Change password has failed", errs)
		return
	}

	utils.JSON(w, 200, "Change password successfully", nil)
}

func CheckAuth(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSON(w, 500, "Internal Server Error", nil)
		return
	}

	var result string
	err = collectionPostgres.QueryRow("SELECT roles FROM userinfo WHERE username=$1", userName).Scan(&result)

	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Invalid token", nil)
		return
	}
	utils.JSON(w, 200, "Invalid token", "Welcome "+userName+" with roles: "+result)

}

func Logout(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSON(w, 401, "Missing authorization header", nil)
		return
	}

	//userName, err := auth.GetSubjectFromToken(tokenString)
	tokenString = tokenString[len("Bearer "):]

	// Connect to the token collection
	collection := db.ConnectMongo(os.Getenv("TokenBlackListCollectionMongo"))

	_, err := collection.InsertOne(context.TODO(), bson.M{
		"token":          tokenString,
		"blacklisted_at": time.Now(),
	})

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		utils.JSON(w, 500, "Error during logout", nil)

		return
	}

	w.WriteHeader(http.StatusOK)
	utils.JSON(w, 200, "Logout successful", nil)
}
