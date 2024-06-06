CC = gcc
CFLAGS = -Wall -Wextra -O2

all: client server

client:
	$(CC) $(CFLAGS) client.c -o client

server:
	$(CC) $(CFLAGS) server.c -o server
	
clean:
	rm -rf client server
