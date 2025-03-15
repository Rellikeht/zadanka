package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

const (
	ADDRESS           = "localhost:9009"
	MULTICAST_ADDRESS = "224.0.0.0:9010"
	BUFFER_SIZE       = 2 << 13
)

func HandleConnection(conn net.Conn, messages chan<- *string) {
	reader := bufio.NewReaderSize(conn, BUFFER_SIZE)
	for {
		message, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}
		messages <- &message
	}
}

func HandleMulticastConnection(conn *net.UDPConn, addr net.Addr, messages chan<- *string) {
	buffer := make([]byte, BUFFER_SIZE)
	for {
		n, sender, err := conn.ReadFromUDP(buffer)
		if err != nil {
			log.Fatal(err)
		}
		if addr.String() == sender.String() {
			continue
		}
		message := string(buffer[:n])
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

	multicastAddr, err := net.ResolveUDPAddr("udp", MULTICAST_ADDRESS)
	if err != nil {
		log.Fatal(err)
	}
	// socket do odbierania wiadomości multicastowo
	multicastRConn, err := net.ListenMulticastUDP("udp", nil, multicastAddr)
	if err != nil {
		log.Fatal(err)
	}
	err = multicastRConn.SetReadBuffer(BUFFER_SIZE)
	if err != nil {
		log.Fatal(err)
	}
	// socket do wysyłania wiadomości multicastowo
	multicastWConn, err := net.DialUDP("udp", nil, multicastAddr)
	if err != nil {
		log.Fatal(err)
	}
	err = multicastWConn.SetWriteBuffer(BUFFER_SIZE)
	if err != nil {
		log.Fatal(err)
	}

	// powiadamianie serwera o swoim nicku w pierwszej
	// wiadomości i adresie udp w drugiej
	nick := os.Args[1]
	fmt.Fprintf(tcpConn, nick+"\n")
	fmt.Fprintf(
		tcpConn, udpConn.LocalAddr().String()+"\n",
	)

	tcpMessages := make(chan *string)
	udpMessages := make(chan *string)
	multicastMessages := make(chan *string)

	// wątki pomocnicze do odbierania wiadomości
	go HandleConnection(tcpConn, tcpMessages)
	go HandleConnection(udpConn, udpMessages)
	go HandleMulticastConnection(
		multicastRConn,
		multicastWConn.LocalAddr(),
		multicastMessages,
	)

	// wątek obsługujący (wypisujący) otrzymane wiadomości
	go func() {
		writer := bufio.NewWriter(os.Stdout)
		for {
			select {
			case message := <-tcpMessages:
				_, err = fmt.Fprint(writer, *message)
			case message := <-udpMessages:
				_, err = fmt.Fprint(writer, *message)
			case message := <-multicastMessages:
				_, err = fmt.Fprint(writer, *message)
			}
			if err != nil {
				log.Fatal(err)
			}
			err := writer.Flush()
			if err != nil {
				log.Fatal(err)
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
			case "/U ":
				_, err = fmt.Fprint(udpConn, text[3:])
				if err != nil {
					log.Fatal(err)
				}
				continue
			case "/M ":
				_, err = fmt.Fprint(multicastWConn, nick+": "+text[3:])
				if err != nil {
					log.Fatal(err)
				}
				continue
			}
		}
		_, err = fmt.Fprint(tcpConn, text)
		if err != nil {
			log.Fatal(err)
		}
	}
}
