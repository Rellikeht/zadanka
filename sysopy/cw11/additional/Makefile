CC = gcc
# CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
CFLAGS = -O2 -std=gnu99 -g -Wno-variadic-macros
LDFLAGS = -O2 -Wall

.PHONY: all clean

all: server client

server: server.c
	$(CC) $(CFLAGS) server.c command_utils.c -o server

client: client.c
	$(CC) $(CFLAGS) client.c -o client

clean:
	rm -f server client
