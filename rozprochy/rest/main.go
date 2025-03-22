package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
)

var (
	comic_img string
	resources = make(map[string]string)
)

func handleResource(name string) func(writer http.ResponseWriter, request *http.Request) {
	return func(writer http.ResponseWriter, request *http.Request) {
		writer.Write([]byte(resources[name]))
	}
}

func xkcd(number int) error {
	address := fmt.Sprintf("https://xkcd.com/%d/info.0.json", number)
	response, err := http.Get(address)
	if err != nil {
		return err
	}

	var (
		content any
		// bytes []byte
	)
	reader := bufio.NewReader(response.Body)
	bytes, _ := reader.ReadString('\n')
	// if err != nil {
	//   log.Println(err)
	//   return err
	// }
	err = json.Unmarshal([]byte(bytes), &content)
	if err != nil {
		return err
	}

	data := content.(map[string]any)
	comic_img = data["img"].(string)
	resources["comic-alt"] = data["alt"].(string)

	return nil
}

func joke(contains string) error {
	// https://v2.jokeapi.dev/joke/Any?
	// blacklistFlags=nsfw,religious,political,racist,sexist&contains=%s
	return nil
}

func handleComic(writer http.ResponseWriter, request *http.Request) {
	id, err := strconv.Atoi(request.URL.Query().Get("xkcd-id"))
	if err != nil {
		log.Println(err)
		return
	}
	err = xkcd(id)
	if err != nil {
		log.Println(err)
		return
	}
	err = joke(resources["joke"])
	if err != nil {
		log.Println(err)
		return
	}
	http.Redirect(writer, request, "/comic.html", http.StatusSeeOther)
}

func main() {
	mux := http.NewServeMux()

	mux.Handle("/", http.FileServer(http.Dir("./static")))
	mux.HandleFunc("/get-comic", handleComic)
	mux.HandleFunc("/comic-img",
		func(writer http.ResponseWriter, request *http.Request) {
			http.Redirect(writer, request, comic_img, http.StatusSeeOther)
		})
	for _, name := range []string{"comic-alt", "joke"} {
		mux.HandleFunc("/"+name, handleResource(name))
	}

	err := http.ListenAndServe(":9009", mux)
	if err != nil {
		log.Fatal(err)
	}
}
