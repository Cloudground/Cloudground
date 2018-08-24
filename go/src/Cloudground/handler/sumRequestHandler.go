package handler

import (
	"net/http"
)

type SumRequest struct {
	Operand1 uint32
	Operand2 uint32
}

type SumResponse struct {
	Sum uint32
}

func HandleSumRequest(w http.ResponseWriter, r *http.Request) {
	var request SumRequest
	if err := decodeRequest(r, &request); err != nil {
		http.Error(w, err.Error(), 400)
	}

	respondWithJson(w, SumResponse{
		Sum: request.Operand1 + request.Operand2,
	})
}
