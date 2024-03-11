CC = gcc
CFLAGS = -Wall -O0 -g -pedantic -Werror
LDFLAGS = -Wall -O0

STATIC = libcollatz.a
DYNAMIC = libcollatz.so
SRC = collatz.c
OBJECT = collatz.o

TEST = main.c
TESTO = main.o
TEST_DYN = main_dyn
TEST_STAT = main_stat
TEST_SHR = main_shr

.PHONY: all static dynamic clean test test_static test_dynamic test_shared

all: static dynamic test

clean:
	rm -rf *.o *.so *.a $(TEST_STAT) $(TEST_SHR) $(TEST_DYN)

obj: $(SRC)
	$(CC) $(CFLAGS) -c $(SRC)

dynamic: obj
	$(CC) $(LDFLAGS) -fPIC -shared $(OBJECT) -o $(DYNAMIC)

static: obj
	ar crs $(STATIC) $(OBJECT)

test_static: $(TEST) clean static
	$(CC) $(CFLAGS) -c $(TEST)
	gcc $(LDFLAGS) $(TESTO) -o $(TEST_STAT) -L. -lcollatz

test_shared: $(TEST) dynamic
	$(CC) $(CFLAGS) -c $(TEST)
	gcc $(LDFLAGS) $(TESTO) -o $(TEST_SHR) -L. -lcollatz -Wl,-rpath=`pwd`

test_dynamic: $(TEST) dynamic
	$(CC) $(CFLAGS) -Ddynlib -c $(TEST)
	gcc $(LDFLAGS) $(TESTO) -o $(TEST_DYN) -L. -lcollatz -Wl,-rpath=`pwd`

test: clean test_static test_dynamic test_shared
