CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros -Wno-error=unused-parameter
LDFLAGS = -O2 -Wall

CSRC = client.c
CEXE = client
SSRC = server.c
SEXE = server

.PHONY: all clean exe

all: clean exe

clean:
	rm -rf *.o *.so *.a $(SEXE) $(CEXE)

client: $(CSRC)
	$(CC) $(CFLAGS) $(CSRC) -o $(CEXE)

server:$(SSRC)
	$(CC) $(CFLAGS) $(SSRC) -o $(SEXE)

exe: client server
