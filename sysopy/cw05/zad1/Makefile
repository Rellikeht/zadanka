CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Werror
LDFLAGS = -O2 -Wall

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
