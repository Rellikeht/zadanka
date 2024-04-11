CC = gcc
CFLAGS = -O0 -std=c89 -g -Wall -Wextra -Werror -Wno-variadic-macros
# gnu99
LDFLAGS = -O0 -Wall

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
