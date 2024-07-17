package routes

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

func GetAllQuiz(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	GetRequest(w, r, p)
}

func SaveQuiz(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	PostRequest(w, r, p)
}

func SearchQuiz(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	GetRequest(w, r, p)
}
