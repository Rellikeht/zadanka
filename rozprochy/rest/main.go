package main

import (
	"bufio"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"regexp"
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
	JOKE_ADDR      = "https://v2.jokeapi.dev/joke/Any"
	JOKE_BLACKLIST = "nsfw,religious,political,racist,sexist,explicit"
)

var (
	resources = make(map[string]string)
)

func processJoke(title string) string {
	reg, _ := regexp.Compile("[a-zA-Z-]+")
	matches := reg.FindAllString(title, -1)
	return matches[len(matches)-1]
}

func xkcd(number int) error {
	address := fmt.Sprintf("https://xkcd.com/%d/info.0.json", number)
	response, err := http.Get(address)
	if err != nil {
		return err
	}
	var content any
	reader := bufio.NewReader(response.Body)
	bytes, err := io.ReadAll(reader)
	if err != nil {
		return err
	}
	err = json.Unmarshal([]byte(bytes), &content)
	if err != nil {
		return err
	}
	data := content.(map[string]any)
	resources["comic-img"] = data["img"].(string)
	resources["comic-alt"] = data["safe_title"].(string)
	resources["joke"] = processJoke(data["title"].(string))
	return nil
}

func joke(contains string) (string, error) {
	endpoint, err := url.Parse(JOKE_ADDR)
	if err != nil {
		return "", err
	}
	params := url.Values{}
	params.Set("blacklistFlags", JOKE_BLACKLIST)
	params.Set("contains", contains)
	endpoint.RawQuery = params.Encode()
	response, err := http.Get(endpoint.String())
	if err != nil {
		return "", err
	}
	reader := bufio.NewReader(response.Body)
	bytes, err := io.ReadAll(reader)
	if err != nil {
		return "", err
	}
	var content any
	err = json.Unmarshal(bytes, &content)
	if err != nil {
		return "", err
	}
	data := content.(map[string]any)
	if data["error"].(bool) {
		return "", errors.New("API error")
	}
	if data["type"].(string) == "single" {
		return data["joke"].(string), nil
	}
	joke := fmt.Sprintf("%s\n\n%s", data["setup"].(string), data["delivery"].(string))
	return joke, nil
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

	// fmt.Println(joke("joke"))
}
