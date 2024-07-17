package routes

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/julienschmidt/httprouter"
	"io"
	"log"
	"net/http"
	"oath-authorize-gitlab/auth"
	db "oath-authorize-gitlab/database"
	"oath-authorize-gitlab/utils"
	"os"
)

func PostRequest(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")

	// Read the request body
	body, err := io.ReadAll(r.Body)
	if err != nil {
		// handle error
	}
	fmt.Println("body: " + string(body))

	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
		return
	}

	var result string
	err = collectionPostgres.QueryRow("SELECT roles FROM userinfo WHERE username=$1", userName).Scan(&result)

	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSONFromSpringBoot(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSONFromSpringBoot(w, 401, "Invalid token", nil)
		return
	}
	//get the path from the request
	path := r.URL.Path

	//fmt.Fprint(w, "Welcome "+userName+" with roles: "+result)
	//fmt.Fprint(w, "redirect path: "+"http://localhost:8080"+path)

	//set requestBody for the request and redirect to another URL
	// Create a new request
	urlQuizServer := os.Getenv("QUIZ_SERVER")
	url := "%s:8080%s"
	formattedURL := fmt.Sprintf(url, urlQuizServer, path)

	req, err := http.NewRequest("POST", formattedURL, bytes.NewBuffer(body))
	if err != nil {
		// handle error
	}

	// Copy the headers
	for name, values := range r.Header {
		for _, value := range values {
			req.Header.Set(name, value)
		}
	}

	// Create a client and execute the request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		// handle error
	}
	if resp.StatusCode == http.StatusOK {
		bodyBytes, err := io.ReadAll(resp.Body)
		if err != nil {
			log.Fatal(err)
		}
		//read bodyBytes as json format
		var result interface{}

		err = json.Unmarshal(bodyBytes, &result)

		//bodyString := string(bodyBytes)
		utils.JSONFromSpringBoot(w, 200, "redirect path: "+"quiz-server:8080"+path, result)
		//return result in json format

	} else {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
	}

	defer resp.Body.Close()

	// Print the response status and body
	//fmt.Fprint(w, "Response status:", resp.Status)
	//utils.JSON(w, 200, "redirect path: "+"http://localhost:8080"+path, resp.Body)

}

func GetRequest(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	requestParam := r.URL.Query()

	fmt.Println(requestParam.Get("userId"))
	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
		return
	}

	var result string
	err = collectionPostgres.QueryRow("SELECT roles FROM userinfo WHERE username=$1", userName).Scan(&result)

	if tokenString == "" {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSONFromSpringBoot(w, 401, "Missing authorization header", nil)
		return
	}
	tokenString = tokenString[len("Bearer "):]

	err = auth.VerifyToken(tokenString)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		utils.JSONFromSpringBoot(w, 401, "Invalid token", nil)
		return
	}
	//get the path from the request
	path := r.URL.Path
	urlQuizServer := os.Getenv("QUIZ_SERVER")
	redirectURL := "%s:8080%s"
	formattedURL := fmt.Sprintf(redirectURL, urlQuizServer, path)

	// if requestParam is emtpy, redirect to the path
	if len(requestParam) == 0 {
		log.Println("redirect to the path: ", formattedURL)
		http.Redirect(w, r, formattedURL, http.StatusSeeOther)
		return
	}

	isFirstParam := true
	for key, values := range requestParam {
		for _, value := range values {
			// Append the key and value as a query parameter to the redirect URL
			if isFirstParam {
				formattedURL += fmt.Sprintf("?%s=%s", key, value)
				isFirstParam = false
			} else {
				formattedURL += fmt.Sprintf("&%s=%s", key, value)
			}
		}
	}

	//fmt.Fprint(w, "Welcome "+userName+" with roles: "+result)
	//fmt.Fprint(w, "redirect path: "+"http://localhost:8080"+path+"?"+keyRequestparam+"="+(requestParam.Get(keyRequestparam)))

	//redirect to another URL

	http.Redirect(w, r, formattedURL, http.StatusSeeOther)
}
