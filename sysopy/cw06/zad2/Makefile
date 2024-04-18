CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

SRC = main.c
EXE = main

.PHONY: all clean exe

all: clean exe

clean:
	rm -rf *.o *.so *.a $(EXE)

exe: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)
