package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
)

// fetches random joke
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

	mux.Handle("/", http.FileServer(http.Dir("./static")))

	err := http.ListenAndServe(":9009", mux)
	if err != nil {
		log.Fatal(err)
	}
}
