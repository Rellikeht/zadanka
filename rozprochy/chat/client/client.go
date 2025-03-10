package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

const ADDRESS = "localhost:9009"

func HandleConnection(conn net.Conn, messages chan<- *string) {
	reader := bufio.NewReader(conn)
	for {
		message, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}
		messages <- &message
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Podaj nick")
		os.Exit(1)
	}

	tcpConn, err := net.Dial("tcp", ADDRESS)
	if err != nil {
		log.Fatal(err)
	}
	udpConn, err := net.Dial("udp4", ADDRESS)
	if err != nil {
		log.Fatal(err)
	}

	// powiadamianie serwera o swoim nicku w pierwszej
	// wiadomości i adresie udp w drugiej
	fmt.Fprintf(tcpConn, os.Args[1]+"\n")
	fmt.Fprintf(
		tcpConn, udpConn.LocalAddr().String()+"\n",
	)

	tcpMessages := make(chan *string)
	udpMessages := make(chan *string)

	// wątki pomocnicze do odbierania wiadomości
	go HandleConnection(tcpConn, tcpMessages)
	go HandleConnection(udpConn, udpMessages)
	// wątek wypisujący otrzymane wiadomości
	go func() {
		for {
			select {
			case message := <-tcpMessages:
				fmt.Print(*message)
			case message := <-udpMessages:
				fmt.Print(*message)
			}
		}
	}()

	// wysyłanie do serwera tekstu ze standardowego wejścia
	reader := bufio.NewReader(os.Stdin)
	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			return
		}
		if len(text) > 2 {
			switch text[:3] {
			case "/u ":
				fmt.Fprint(udpConn, text[3:])
				continue
			}
		}
		fmt.Fprint(tcpConn, text)
	}
}
