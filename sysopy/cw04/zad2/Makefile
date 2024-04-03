CC = gcc
CFLAGS = -O1 -std=c89 -g -Wall -Wno-variadic-macros -pedantic -Werror
LDFLAGS = -O0 -Wall -pedantic

SRC = main.c
EXE = main

.PHONY: all clean obj exe

all: clean obj exe

clean:
	rm -rf *.o *.so *.a $(EXE)

obj: $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(EXE).o

exe: obj
	$(CC) $(CFLAGS) $(EXE).o -o $(EXE)
