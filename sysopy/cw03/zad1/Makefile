CC = gcc
CFLAGS = -O0 -std=c89 -g -Wall -Werror
LDFLAGS = -O0 -Wall

SRC = main.c
BBB = bytes
BLK = blocks
BENCH_OUT = pomiar_zad_2.txt

.PHONY: all clean obj exe byte-test block-test test bench

all: clean obj exe

clean:
	rm -rf *.o *.so *.a $(BBB) $(BLK) *.test *.diff 1* 5* pomiar*

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

test: byte-test block-test

bench: clean exe
	echo > $(BENCH_OUT)
	./bench.sh ./$(BLK) $(BENCH_OUT)
	echo ================================================== \
		>> $(BENCH_OUT)
	echo >> $(BENCH_OUT)
	./bench.sh ./$(BBB) $(BENCH_OUT)
	bat $(BENCH_OUT)

