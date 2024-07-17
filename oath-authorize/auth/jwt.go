package auth

import (
	"context"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"go.mongodb.org/mongo-driver/bson"
	db "oath-authorize-gitlab/database"
	"os"
	"time"
)

var secretKey = []byte("5367566B59703373367639792F423F4528482B4D6251655468576D5A71347437")
var header = map[string]interface{}{
	"typ": "JWT",
	"alg": "HS256",
}

func Create(username string) (string, error) {
	claims := &jwt.StandardClaims{
		Subject:   username,
		IssuedAt:  time.Now().Unix(),
		ExpiresAt: time.Now().Add(60 * time.Minute).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	//token.Header = header

	return token.SignedString(secretKey)
}
func VerifyToken(tokenString string) error {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil {
		return err
	}

	if !token.Valid {
		return fmt.Errorf("invalid token")
	}

	collection := db.ConnectMongo(os.Getenv("TokenBlackListCollectionMongo"))
	var result bson.M
	err = collection.FindOne(context.TODO(), bson.M{"token": tokenString}).Decode(&result)
	if err == nil {
		return fmt.Errorf("token has been blacklisted")
	}

	return nil
}
func GetSubjectFromToken(tokenString string) (string, error) {
	if tokenString == "" {
		return "", fmt.Errorf("missing authorization header")
	}
	tokenString = tokenString[len("Bearer "):]

	token, err := jwt.ParseWithClaims(tokenString, &jwt.StandardClaims{}, func(token *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil {
		return "", err
	}

	if claims, ok := token.Claims.(*jwt.StandardClaims); ok && token.Valid {
		return claims.Subject, nil
	} else {
		return "", fmt.Errorf("invalid token")
	}
}
