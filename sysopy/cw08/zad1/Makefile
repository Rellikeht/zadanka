CXX = gcc
CFLAGS = -O2 -std=gnu99 -g -Wall -Wextra -Werror -Wno-variadic-macros

.PHONY: all clean

all: clean run

run: 
	$(CXX) -c $(CFLAGS) user.c
	$(CXX) -c $(CFLAGS) printers.c
	$(CXX) $(CFLAGS) -o user user.o -lm
	$(CXX) $(CFLAGS) -o printers printers.o -lm

clean:
	rm -fr user
	rm -fr printers
	rm -fr *.o
	
