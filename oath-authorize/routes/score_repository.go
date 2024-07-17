package routes

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

func SaveScore(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	PostRequest(w, r, p)
}

func GetScoreByQuiz(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	GetRequest(w, r, p)
}

func GetScoreByUser(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	GetRequest(w, r, p)

}
