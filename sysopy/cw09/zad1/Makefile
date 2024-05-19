CC = gcc
CFLAGS = -Wall -Wextra -std=gnu99

all: clean life
	
life: grid.c life.c
	$(CC) $(CFLAGS) grid.c life.c -o life -lncursesw
	
clean:
	rm -f life
