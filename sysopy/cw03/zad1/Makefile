CC = gcc
CFLAGS = -O0 -std=c89 -g -Wall -Werror
LDFLAGS = -O0 -Wall

SRC = main.c
BBB = bbb
BLK = blk

.PHONY: all clean bbb blk obj exe byte-test block-test

all: clean obj exe

clean:
	rm -rf *.o *.so *.a $(BBB) $(BLK) *.test *.diff

obj: $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(BLK).o
	$(CC) $(CFLAGS) -c $(SRC) -DBYTE_BY_BYTE -o $(BBB).o

exe: obj
	$(CC) $(CFLAGS) $(BLK).o -o $(BLK)
	$(CC) $(CFLAGS) $(BBB).o -o $(BBB)

byte-test: clean exe
	./test.sh ./$(BBB) Makefile
	./test.sh ./$(BBB) main.c

block-test: clean exe
	./test.sh ./$(BLK) Makefile
	./test.sh ./$(BLK) main.c
