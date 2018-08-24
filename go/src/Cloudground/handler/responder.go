package handler

import (
	"net/http"
	"encoding/json"
)

func respondWithJson(w http.ResponseWriter, response interface{}) error {
	w.Header().Set("Content-Type", "application/json")
	return json.NewEncoder(w).Encode(response)
}