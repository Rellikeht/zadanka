CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

CSRC = client.c
CEXE = client
SSRC = server.c
SEXE = server

.PHONY: all clean exe

all: clean exe

rmpipes:
	sed -En 's/.*"([^"]*)"$\/\1/p' config.h | xargs -d '\n' rm -f 

clean:
	rm -rf *.o *.so *.a $(SEXE) $(CEXE)

exe: $(CSRC) $(SSRC)
	$(CC) $(CFLAGS) $(SSRC) -o $(SEXE)
	$(CC) $(CFLAGS) $(CSRC) -o $(CEXE)
