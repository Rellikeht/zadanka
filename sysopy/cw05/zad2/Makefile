CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Werror
LDFLAGS = -O2 -Wall

.PHONY: all clean

all: clean sender catcher

clean:
	rm -rf *.o *.so *.a sender catcher

sender: sender.c errors.c
	$(CC) $(CFLAGS) sender.c -o sender

catcher: sender.c errors.c
	$(CC) $(CFLAGS) catcher.c -o catcher
