package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
	"strconv"
	"strings"
)

type MsgType int

const (
	TCP MsgType = iota
	UDP
)

type Message = struct {
	sender   string
	content  *string
	connType MsgType
}

type UserInfo = struct {
	nick       string
	udpAddress string
	messages   chan<- Message
}

type User = struct {
	udpAddress string
	messages   chan<- Message
}

func ParseUDPAddr(message string) (net.UDPAddr, error) {
	parts := strings.Split(message, ":")
	ipPart := strings.Join(parts[:(len(parts)-1)], ":")
	ip := net.ParseIP(ipPart)
	if ip == nil {
		return net.UDPAddr{}, &net.ParseError{
			Type: "IP",
			Text: "Invalid IP address",
		}
	}
	port, err := strconv.Atoi(parts[len(parts)-1])
	if err != nil {
		return net.UDPAddr{}, err
	}
	return net.UDPAddr{
		IP:   net.ParseIP(parts[0]),
		Port: port,
		Zone: "",
	}, nil
}

func UdpConnHandler(
	conn *net.UDPConn,
	messages chan<- Message,
) {
	buffer := make([]byte, 4096)
	for {
		length, address, err := conn.ReadFromUDP(buffer)
		if err != nil {
			log.Fatal(err)
		}
		message := string(buffer[:length])
		addressString := address.String()
		messages <- Message{addressString, &message, UDP}
	}
}

func UserManagement(
	userIn <-chan UserInfo,
	userOut <-chan string,
	tcpMessages <-chan Message,
	udpMessages <-chan Message,
) {
	users := make(map[string]User)
	addresses := make(map[string]string)

	for {
		select {
		case user := <-userIn:
			users[user.nick] = User{user.udpAddress, user.messages}
			addresses[user.udpAddress] = user.nick
			fmt.Fprintln(os.Stderr, user.nick+" dołączył")
		case nick := <-userOut:
			user := users[nick]
			delete(addresses, user.udpAddress)
			delete(users, nick)
			fmt.Fprintln(os.Stderr, nick+" wyszedł")
		case message := <-tcpMessages:
			for nick, user := range users {
				if message.sender != nick {
					user.messages <- message
				}
			}
		case message := <-udpMessages:
			sender := addresses[message.sender]
			message.sender = sender
			for nick, user := range users {
				if message.sender != nick {
					user.messages <- message
				}
			}
		}
	}
}

func ServeUser(
	serverUdpSocket *net.UDPConn,
	clientSocket net.Conn,
	userIn chan<- UserInfo,
	userOut chan<- string,
	tcpMessages chan<- Message,
) {
	reader := bufio.NewReader(clientSocket)

	// Pierwsza wiadomość wysłana przez klienta to jego nick
	nick, err := reader.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}
	// Druga to adres udp
	udpAddressRepr, err := reader.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}

	// Obsługa dołączenia klienta
	nick = nick[:len(nick)-1]
	messageChannel := make(chan Message)
	udpAddressRepr = udpAddressRepr[:len(udpAddressRepr)-1]
	udpAddress, err := ParseUDPAddr(udpAddressRepr)
	if err != nil {
		log.Fatal(err)
	}
	userIn <- UserInfo{nick, udpAddressRepr, messageChannel}
	clientSocket.Write([]byte("Dołączyłeś do serwera\n"))

	// Obsluga wyjścia klienta
	defer func() { userOut <- nick }()

	// Dodatkowy wątek do przesyłania wiadomości do
	// klienta
	go func() {
		for message := range messageChannel {
			content := []byte(message.sender + ": " + *message.content)
			switch message.connType {
			case TCP:
				clientSocket.Write(content)
			case UDP:
				serverUdpSocket.WriteToUDP(
					content,
					&udpAddress,
				)
			}
		}
	}()

	// odczytywanie wiadomości wysłanych przez klienta
	// i przesyłanie innym
	for {
		message, err := reader.ReadString('\n')
		if err != nil {
			return
		}
		tcpMessages <- Message{nick, &message, TCP}
	}
}

func main() {
	IP := net.ParseIP("localhost")
	PORT := 9009

	serverTcpSocket, err := net.ListenTCP(
		"tcp",
		&net.TCPAddr{IP: IP, Port: PORT, Zone: ""},
	)
	if err != nil {
		log.Fatal(err)
	}
	serverUdpSocket, err := net.ListenUDP(
		"udp",
		&net.UDPAddr{IP: IP, Port: PORT, Zone: ""},
	)
	if err != nil {
		log.Fatal(err)
	}

	userIn := make(chan UserInfo)
	userOut := make(chan string)
	tcpMessages := make(chan Message)
	udpMessages := make(chan Message)

	// Wątek obsługujący połączenie UDP
	go UdpConnHandler(serverUdpSocket, udpMessages)

	// wątek zarządzający użytkownikami i przesyłający dalej wiadomości
	go UserManagement(userIn, userOut, tcpMessages, udpMessages)

	// obsługa dołączających klientów
	for {
		clientSocket, err := serverTcpSocket.Accept()
		if err != nil {
			log.Fatal(err)
		}

		// Wątek do obsługi połączenia z nowym klientem
		go ServeUser(
			serverUdpSocket,
			clientSocket,
			userIn,
			userOut,
			tcpMessages,
		)
	}
}
