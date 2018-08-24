package handler

import (
	"net/http"
	"fmt"
)

type StatusResponse struct {
	Status string `json:"status"`
}

func HandleStatusRequest(w http.ResponseWriter, r *http.Request) {

	fmt.Printf("Received %s\n", "RootRequest")

	respondWithJson(w, StatusResponse{
		Status: "OK",
	})
}
