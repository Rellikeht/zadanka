package main

import (
	"bufio"
	"encoding/base64"
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
	imgSync   = make(chan string)
)

func getImg(address string) {
	response, err := http.Get(address)
	if err != nil {
		return
	}
	reader := bufio.NewReader(response.Body)
	bytes, err := io.ReadAll(reader)
	if err != nil {
		return
	}
	image := make([]byte, base64.StdEncoding.EncodedLen(len(bytes)))
	base64.StdEncoding.Encode(image, bytes)
	imgSync <- "data:image/png;base64," + string(image)
}

func getComic(number int) error {
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
	go getImg(data["img"].(string))
	resources["comic-alt"] = data["safe_title"].(string)
	resources["joke"] = data["transcript"].(string) + " " + data["title"].(string)
	return nil
}

func getJoke(
	endpoint *url.URL,
	params url.Values,
	contains string,
) (string, error) {
	params.Set("contains", contains)
	endpoint.RawQuery = params.Encode()
	response, err := http.Get(endpoint.String())
	if err != nil {
		log.Println(err)
		return "", err
	}
	reader := bufio.NewReader(response.Body)
	bytes, err := io.ReadAll(reader)
	if err != nil {
		log.Println(err)
		return "", err
	}
	var content any
	err = json.Unmarshal(bytes, &content)
	if err != nil {
		log.Println(err)
		return "", err
	}
	data := content.(map[string]any)
	if data["error"].(bool) {
		if data["internalError"].(bool) {
			log.Println(data)
		}
		return "", errors.New("API error")
	}
	if data["type"].(string) == "single" {
		return data["joke"].(string), nil
	}
	joke := fmt.Sprintf("%s\n<br>\n%s", data["setup"].(string), data["delivery"].(string))
	return joke, nil
}

func findJoke(title string) (string, error) {
	reg, _ := regexp.Compile("[a-zA-Z-]+")
	matches := reg.FindAllString(title, -1)
	endpoint, err := url.Parse(JOKE_ADDR)
	if err != nil {
		log.Println(err)
		return "", err
	}
	params := url.Values{}
	params.Set("blacklistFlags", JOKE_BLACKLIST)
	for i := len(matches) - 1; i >= 0; i -= 1 {
		joke, err := getJoke(
			endpoint,
			params,
			matches[i],
		)
		if err == nil {
			return joke, nil
		}
	}
	log.Println(title)
	return "It turns out that comic is not funny enough", nil
}

func handleComic(writer http.ResponseWriter, request *http.Request) {
	id, err := strconv.Atoi(request.URL.Query().Get("xkcd-id"))
	if err != nil {
		log.Println(err)
		return
	}
	err = getComic(id)
	if err != nil {
		log.Println(err)
		return
	}
	joke, err := findJoke(resources["joke"])
	if err != nil {
		resources["joke"] = "Something wanted to laugh at you when finding appropriate joke"
	} else {
		resources["joke"] = joke
	}
	resources["comic-img"] = <-imgSync
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
