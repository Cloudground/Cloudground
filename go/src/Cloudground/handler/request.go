package handler

import (
	"net/http"
	"encoding/json"
	"errors"
	"fmt"
	"reflect"
)

func decodeRequest(r *http.Request, request interface{}) error {
	if r.Body == nil {
		return errors.New("invalid request")
	}

	fmt.Printf("Decoding request %s\n", reflect.TypeOf(request).Name())

	err := json.NewDecoder(r.Body).Decode(&request)
	if err != nil {
		return err
	}

	return nil
}