package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

type UserInfo = struct {
	nick   string
	writer *bufio.Writer
}

type Message = struct {
	sender  string
	content string
}

func main() {
	serverSocket, err := net.Listen("tcp", "localhost:9009")
	if err != nil {
		log.Fatal(err)
	}

	// komunikacja z wątkiem do zarządzania
	userIn := make(chan UserInfo)
	userOut := make(chan string)
	messages := make(chan Message)

	// zarządzanie użytkownikami (i przesyłanie dalej wiadomości)
	go func() {
		users := make(map[string]*bufio.Writer)
		for {
			select {
			case user := <-userIn:
				fmt.Fprintln(os.Stderr, user.nick+" dołączył")
				users[user.nick] = user.writer
			case nick := <-userOut:
				fmt.Fprintln(os.Stderr, nick+" wyszedł")
				delete(users, nick)
			case message := <-messages:
				for receiver, writer := range users {
					if message.sender != receiver {
						fmt.Fprintln(os.Stderr, message.sender+" - "+receiver)
						writer.WriteString(message.sender + ": " + message.content)
					}
				}
			}
		}
	}()

	for {
		clientSocket, err := serverSocket.Accept()
		if err != nil {
			log.Fatal(err)
		}

		// Wątek do obsługi połączenia z nowo połączonym klientem
		go func() {
			reader := bufio.NewReader(clientSocket)
			writer := bufio.NewWriter(clientSocket)

			nick, err := reader.ReadString('\n')
			if err != nil {
				log.Fatal(err)
			}
			nick = nick[:len(nick)-1]
			userIn <- UserInfo{nick, writer}
			defer func() { userOut <- nick }()
			writer.WriteString("Dołączyłeś\n")

			for {
				message, err := reader.ReadString('\n')
				if err != nil {
					return
				}
				messages <- Message{nick, message}
				// fmt.Print(nick + ": " + message)
			}
		}()
	}
}
