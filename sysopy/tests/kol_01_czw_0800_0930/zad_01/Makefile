CC = gcc
CFLAGS = -Wall -O0 -g -Werror
LDFLAGS = -Wall -O0

LIB_SRC = bibl1.c
LIB = libbibl.so

SRC = zad1.c
OBJECT = zad1.o
OUT = zad1

.PHONY: all shared clean exe

all: shared exe

clean:
	rm -rf *.o *.so bin lib

shared:
	mkdir -p lib/
	$(CC) $(LDFLAGS) -fPIC -shared $(LIB_SRC) -o lib/$(LIB)

exe: $(SRC)
	mkdir -p bin/
	LD_LIBRARY_PATH=./lib
	$(CC) $(CFLAGS) -L. -lbibl -Wl,-rpath=`pwd` $(SRC) -o bin/$(OUT)
