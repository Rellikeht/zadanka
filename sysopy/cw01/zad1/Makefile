CC = gcc
CFLAGS = -Wall -O2 -g
OUT = countdown
SRC = countdown.c

.PHONY: all clean countdown

all: countdown

countdown:
	$(CC) $(CFLAGS) $(SRC) -o $(OUT)

clean:
	rm -rf $(OUT)
