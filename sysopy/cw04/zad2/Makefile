CXX = gcc
CFLAGS = -Wall -Wextra -Wuninitialized -g

.PHONY: all clean

all: clean run

run: 
	${CXX} -c ${CFLAGS} main.c
	${CXX} ${CFLAGS} -o main main.o

clean:
	rm -fr main
	rm -fr main.o