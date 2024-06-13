CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

.PHONY: all clean exe

all: clean exe

exe: 
	${CC} -c ${CFLAGS} client.c
	${CC} -c ${CFLAGS} server.c
	${CC} ${CFLAGS} -o client client.o -lm -pthread
	${CC} ${CFLAGS} -o server server.o -lm

clean:
	rm -fr client
	rm -fr server
	rm -fr *.o
