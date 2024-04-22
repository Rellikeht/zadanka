CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

SRC = main.c
EXE = main
TESTS = ./tests.sh

.PHONY: all clean exe

exe: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)

all: clean exe tests

clean:
	rm -rf *.o *.so *.a $(EXE)

tests: exe $(TESTS)
	@ echo
	@ $(TESTS)
