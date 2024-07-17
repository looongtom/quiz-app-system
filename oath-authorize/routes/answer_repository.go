package routes

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

func SaveAnswer(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	PostRequest(w, r, httprouter.Params{})
}
