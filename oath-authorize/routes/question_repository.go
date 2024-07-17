package routes

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"oath-authorize-gitlab/auth"
	db "oath-authorize-gitlab/database"
	"oath-authorize-gitlab/models"
	"oath-authorize-gitlab/utils"
)

func GetQuestionByQuiz(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")
	requestParam := r.URL.Query()

	tokenString := r.Header.Get("Authorization")
	userName, err := auth.GetSubjectFromToken(tokenString)
	collectionPostgres, err := db.ConnectPostgres()
	if err != nil {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
		return
	}

	var result models.User
	err = collectionPostgres.QueryRow("SELECT id,email,roles,username FROM userinfo WHERE username=$1", userName).Scan(&result.ID, &result.Email, &result.Roles, &result.Username)

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

	//get quizId from request param
	quizId := requestParam.Get("quizId")
	if quizId == "" {
		utils.JSONFromSpringBoot(w, 400, "quizId is required", nil)
		return
	}

	//GET QUIZ PRIVACY
	var privacyQuiz string
	collectionPostgresQuiz, err := db.ConnectPostgresQuiz()
	if err != nil {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
		return
	}
	err = collectionPostgresQuiz.QueryRow("SELECT privacy FROM quizzes WHERE id=$1", quizId).Scan(&privacyQuiz)
	if err != nil {
		utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
		return
	}
	if privacyQuiz == "1" {
		//CHECK USER PERMISSION IF QUIZ IS PRIVATE
		collectionPostgresPermissionQuiz, err := db.ConnectPostgresPermissionQuiz()
		if err != nil {
			utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
			return
		}
		var checkCount string
		err = collectionPostgresPermissionQuiz.QueryRow("SELECT count(1) FROM permissions_quiz where quiz_id=$1 and user_id=$2", quizId, result.ID).Scan(&checkCount)
		if err != nil {
			utils.JSONFromSpringBoot(w, 500, "Internal Server Error", nil)
			return
		}
		fmt.Println("checkCount: " + checkCount)
		if checkCount == "0" {
			utils.JSONFromSpringBoot(w, 403, "User does not have permission to do this quiz", nil)
			return
		}
	}

	//get the path from the request
	path := r.URL.Path
	redirectURL := "http://localhost:8080" + path

	isFirstParam := true
	for key, values := range requestParam {
		for _, value := range values {
			// Append the key and value as a query parameter to the redirect URL
			if isFirstParam {
				redirectURL += fmt.Sprintf("?%s=%s", key, value)
				isFirstParam = false
			} else {
				redirectURL += fmt.Sprintf("&%s=%s", key, value)
			}
		}
	}

	//redirect to another URL

	http.Redirect(w, r, redirectURL, http.StatusSeeOther)
}

func SaveQuestion(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	PostRequest(w, r, p)

}
func SaveListQuestion(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	PostRequest(w, r, p)
}

func UpdateQuestion(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	PostRequest(w, r, p)
}

func GetQuestionById(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	GetRequest(w, r, p)
}
