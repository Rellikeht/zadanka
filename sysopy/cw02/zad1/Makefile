CC = gcc
CFLAGS = -Wall -O0 -g
LDFLAGS = -Wall -O0

STATIC = libcollatz.a
DYNAMIC = libcollatz.so
SRC = collatz.c
OBJECT = collatz.o

TEST = main.c
TEST_DYN = main_dyn.c
TEST_STAT = main_stat
TEST_SHR = main_shr

.PHONY: all static dynamic clean test test_static test_dynamic test_shared

all: static dynamic test

clean:
	rm -rf *.o *.so *.a main_*

obj:
	$(CC) $(CFLAGS) -c $(SRC)

dynamic: obj
	$(CC) $(LDFLAGS) -fPIC -shared $(OBJECT) -o $(DYNAMIC)

static: obj
	ar crs $(STATIC) $(OBJECT)

test_static: clean static
	gcc $(LDFLAGS) $(TEST) -o $(TEST_STAT) -L. -lcollatz

test_shared: clean dynamic
	gcc $(LDFLAGS) $(TEST) -o $(TEST_SHR) -L. -lcollatz -Wl,-rpath=`pwd`

test_dynamic: clean dynamic
	gcc $(LDFLAGS) $(TEST_DYN) -o $(TEST_SHR) -L. -lcollatz -Wl,-rpath=`pwd`

test: test_dynamic test_static test_shared
