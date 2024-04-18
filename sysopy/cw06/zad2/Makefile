CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

CSRC = client.c
CEXE = client
SSRC = server.c
SEXE = server

.PHONY: all clean exe

all: clean exe

clean:
	rm -rf *.o *.so *.a $(SEXE) $(CEXE)

exe: $(CSRC) $(SSRC)
	$(CC) $(CFLAGS) $(SSRC) -o $(SEXE)
	$(CC) $(CFLAGS) $(CSRC) -o $(CEXE)
