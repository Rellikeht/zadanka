package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
)

const (
	COMIC_INSIDE = `
<head>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div id="response">
    <img id="comic" src="%s" alt="%s">
    <div id="joke">%s</div>
  <div>
</body>
`
	JOKE_ADDR = "https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&contains=%s"
)

var (
	resources = make(map[string]string)
)

func xkcd(number int) error {
	address := fmt.Sprintf("https://xkcd.com/%d/info.0.json", number)
	response, err := http.Get(address)
	if err != nil {
		return err
	}
	var content any
	reader := bufio.NewReader(response.Body)
	bytes, _ := reader.ReadString('\n')
	err = json.Unmarshal([]byte(bytes), &content)
	if err != nil {
		return err
	}
	data := content.(map[string]any)
	resources["comic-img"] = data["img"].(string)
	resources["comic-alt"] = data["safe_title"].(string)
	resources["joke"] = "TODO"
	return nil
}

func joke(contains string) (string, error) {
	address := fmt.Sprintf(JOKE_ADDR, contains)
	response, err := http.Get(address)
	if err != nil {
		return "", err
	}
	var content any
	reader := bufio.NewReader(response.Body)
	bytes, _ := reader.ReadString('\n')
	fmt.Println(bytes)
	err = json.Unmarshal([]byte(bytes), &content)
	if err != nil {
		return "", err
	}
	data := content.(map[string]any)
	_ = data
	return "FUNNY JOKE HERE", nil
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
	resources["joke"], err = joke(resources["joke"])
	if err != nil {
		log.Println(err)
		return
	}

	response := fmt.Sprintf(
		COMIC_INSIDE,
		resources["comic-img"],
		resources["comic-alt"],
		resources["joke"],
	)
	writer.Write([]byte(response))
}

func main() {
	mux := http.NewServeMux()
	mux.Handle("/", http.FileServer(http.Dir("./static")))
	mux.HandleFunc("/get-comic", handleComic)
	err := http.ListenAndServe(":9009", mux)
	if err != nil {
		log.Fatal(err)
	}
}
