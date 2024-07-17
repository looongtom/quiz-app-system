package main

import (
	"fmt"
	"github.com/joho/godotenv"
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
	"oath-authorize-gitlab/routes"
)

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalln("Error getting env, %v", err)
	}
	router := httprouter.New()

	//USER
	router.POST("/auth/login", routes.Login)
	router.POST("/auth/register", routes.Register)
	router.GET("/auth/me", routes.GetProfile)
	router.GET("/search/user-by-username", routes.GetByUserName)
	router.POST("/auth/logout", routes.Logout)
	router.POST("/auth/checkAuthor", routes.CheckAuth)
	router.POST("/auth/register-oauth", routes.RegisterOAuth)
	router.POST("/auth/change-password", routes.ChangePassword)
	router.POST("/auth/change-password-first-time", routes.ChangePasswordFirstTime)

	//OAUTH
	router.GET("/login-oauth", routes.HandleMain)
	router.GET("/login", routes.HandleGoogleLogin)
	router.GET("/callback", routes.HandleGoogleCallback)
	//router.GET("/register", routes.RegisterForm)

	//QUESTION
	router.GET("/api/v1/question/get-question-by-quiz", routes.GetQuestionByQuiz)
	router.POST("/api/v1/question/save-question", routes.SaveQuestion)
	router.POST("/api/v1/question/save-many-question", routes.SaveListQuestion)
	router.POST("/api/v1/question/update-question", routes.UpdateQuestion)
	router.GET("/api/v1/question/get-question-by-id", routes.GetQuestionById)

	//QUIZ
	router.GET("/api/v1/quiz/get-all-quiz", routes.GetAllQuiz)
	router.POST("/api/v1/quiz/save-quiz", routes.SaveQuiz)
	router.GET("/api/v1/quiz/search-quiz", routes.SearchQuiz)
	router.GET("/api/v1/quiz/get-by-id", routes.SearchQuiz)

	//ANSWER
	router.POST("/api/v1/answer/save-answer", routes.SaveAnswer)
	router.POST("/api/v1/answer/update-list-answer", routes.SaveAnswer)

	//SCORE
	router.POST("/api/v1/score/save-score", routes.SaveScore)
	router.GET("/api/v1/score/get-score-by-quiz", routes.GetScoreByQuiz)
	router.GET("/api/v1/score/get-score-by-user", routes.GetScoreByUser)
	router.GET("/api/v1/score/search-score-by-user", routes.GetScoreByUser)
	router.GET("/api/v1/score/search-score-by-quiz", routes.GetScoreByUser)

	//UPLOAD FILE QUESTION
	router.POST("/api/v1/file/upload", routes.UploadFile)
	router.POST("/api/v1/file/upload-preview", routes.UploadFile)

	fmt.Println("Listening to port 8000")
	log.Fatal(http.ListenAndServe(":8000", addCorsHeaders(router)))

}

// Middleware để thêm CORS headers
func addCorsHeaders(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Cho phép tất cả các origin
		w.Header().Set("Access-Control-Allow-Origin", "*")
		// Các headers được phép
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		// Phương thức được phép
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS,DELETE")

		// Nếu phương thức là OPTIONS, không cần xử lý tiếp
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		// Chuyển tiếp yêu cầu đến handler tiếp theo
		handler.ServeHTTP(w, r)
	})
}
