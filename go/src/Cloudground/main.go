package main

import (
	"fmt"
	"net/http"
	"Cloudground/handler"
)

const httpPort = 8090

func main() {
	fmt.Printf("Sever starting to listen on port %d ...\n", httpPort)

	http.HandleFunc("/status", handler.HandleStatusRequest)
	http.HandleFunc("/sum", handler.HandleSumRequest)

	if err := http.ListenAndServe(fmt.Sprintf(":%d", httpPort), nil); err != nil {
		panic(err)
	}

	fmt.Printf("Server stopped\n")
}
