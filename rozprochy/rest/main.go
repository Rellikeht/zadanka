package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
)

func randomJoke() {
	resp, err := http.Get("https://official-joke-api.appspot.com/jokes/random")
	if err != nil {
		log.Fatal(err)
	}
	reader := bufio.NewReader(resp.Body)
	fmt.Println(reader.ReadString('\n'))
}

func main() {
	mux := http.NewServeMux()
	mux.Handle("/", http.FileServer(http.Dir("./")))
	http.ListenAndServe(":9009", mux)
}
