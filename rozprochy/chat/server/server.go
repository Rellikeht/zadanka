package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

type Message = struct {
	sender  string
	content *string
}

type UserInfo = struct {
	nick     string
	messages chan<- Message
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

	// wątek zarządzający użytkownikami i przesyłający dalej wiadomości
	go func() {
		users := make(map[string]chan<- Message)
		for {
			select {
			case user := <-userIn:
				fmt.Fprintln(os.Stderr, user.nick+" dołączył")
				users[user.nick] = user.messages
			case nick := <-userOut:
				fmt.Fprintln(os.Stderr, nick+" wyszedł")
				delete(users, nick)
			case message := <-messages:
				for receiver, channel := range users {
					if message.sender != receiver {
						channel <- message
					}
				}
			}
		}
	}()

	// obsługa dołączających klientów
	for {
		clientSocket, err := serverSocket.Accept()
		if err != nil {
			log.Fatal(err)
		}

		// Wątek do obsługi połączenia z nowym klientem
		go func() {
			reader := bufio.NewReader(clientSocket)
			// Pierwsza wiadomość wysłana przez klienta to jego
			// nick
			nick, err := reader.ReadString('\n')
			if err != nil {
				log.Fatal(err)
			}
			nick = nick[:len(nick)-1]
			messageChannel := make(chan Message)

			userIn <- UserInfo{nick, messageChannel}
			defer func() { userOut <- nick }()
			clientSocket.Write([]byte("Dołączyłeś\n"))

			// Dodatkowy wątek do przekazywania wiadomości do
			// klienta
			go func() {
				for message := range messageChannel {
					clientSocket.Write([]byte(message.sender + ": " + *message.content))
				}
			}()

			// odczytywanie wiadomości wysłanych przez klienta
			// i przesyłanie innym
			for {
				message, err := reader.ReadString('\n')
				if err != nil {
					return
				}
				messages <- Message{nick, &message}
			}
		}()
	}
}
