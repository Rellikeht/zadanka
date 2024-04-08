CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Werror
LDFLAGS = -O2 -Wall

.PHONY: all clean

all: clean sender catcher

clean:
	rm -rf *.o *.so *.a $(EXE)

sender:
	$(CC) $(CFLAGS) sender.c -o sender

catcher:
	$(CC) $(CFLAGS) catcher.c -o catcher
