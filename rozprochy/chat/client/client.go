package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Podaj nick")
		os.Exit(1)
	}

	conn, err := net.Dial("tcp", "localhost:9009")
	if err != nil {
		log.Fatal(err)
	}
	// powiadamianie serwera o swoim nicku w pierwszej
	// wiadomości
	fmt.Fprintf(conn, os.Args[1]+"\n")

	// wątek obsługujący wypisywanie wiadomości od serwera
	// na standardowe wyjście
	go func() {
		reader := bufio.NewReader(conn)
		for {
			message, err := reader.ReadString('\n')
			if err != nil {
				return
			}
			fmt.Print(message)
		}
	}()

	// wysyłanie do serwera tekstu ze standardowego wejścia
	reader := bufio.NewReader(os.Stdin)
	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			return
		}
		fmt.Fprint(conn, text)
	}
}
