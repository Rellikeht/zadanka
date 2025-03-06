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
	fmt.Fprintf(conn, os.Args[1]+"\n")

	go func() {
		reader := bufio.NewReader(conn)
		for {
			message, _ := reader.ReadString('\n')
			fmt.Print(message)
		}
	}()

	reader := bufio.NewReader(os.Stdin)
	for {
		text, _ := reader.ReadString('\n')
		fmt.Fprint(conn, text)
	}
}
