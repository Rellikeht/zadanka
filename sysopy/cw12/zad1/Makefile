CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

.PHONY: all clean exe

all: clean exe

exe: 
	${CXX} -c ${CFLAGS} client.c
	${CXX} -c ${CFLAGS} server.c
	${CXX} ${CFLAGS} -o client client.o -lm -pthread
	${CXX} ${CFLAGS} -o server server.o -lm

clean:
	rm -fr client
	rm -fr server
	rm -fr *.o
