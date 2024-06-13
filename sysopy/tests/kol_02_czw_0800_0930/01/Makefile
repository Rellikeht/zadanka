CC = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros
LDFLAGS = -O2 -Wall

.PHONY: all clean exe

all: clean exe

clean:
	rm -rf *.o *.so *.a shm_read shm_write

exe: $(SRC)
	$(CC) $(CFLAGS) shm_read.c -o shm_read
	$(CC) $(CFLAGS) shm_write.c -o shm_write
