package utils

import (
	"encoding/json"
	"net/http"
)

type Response struct {
	Message string      `json:"message"`
	Status  int         `json:"status"`
	Data    interface{} `json:"data"`
}

type ResponseFromSpringBoot struct {
	Message string      `json:"message"`
	Status  int         `json:"status"`
	Data    interface{} `json:"data-from-spring-boot"`
}

func JSON(w http.ResponseWriter, status int, message string, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	response := Response{
		Message: message,
		Status:  status,
		Data:    data,
	}
	json.NewEncoder(w).Encode(response)
}

func JSONFromSpringBoot(w http.ResponseWriter, status int, message string, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	response := ResponseFromSpringBoot{
		Message: message,
		Status:  status,
		Data:    data,
	}
	json.NewEncoder(w).Encode(response)
}
