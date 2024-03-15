CC = gcc
CFLAGS = -Wall -O2 -g -pedantic -Werror
LDFLAGS = -Wall -O2

SRC = main.c
BBB = bbb
BLK = blk

.PHONY: all clean bbb blk obj exe

all: clean obj exe

clean:
	rm -rf *.o *.so *.a $(BBB) $(BLK)

obj: $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(BLK).o
	$(CC) $(CFLAGS) -c $(SRC) -DBYTE_BY_BYTE -o $(BBB).o

exe: clean
	$(CC) $(CFLAGS) $(BLK).o -o $(BLK)
	$(CC) $(CFLAGS) $(BBB).o -o $(BBB)

# dynamic: obj
#	$(CC) $(LDFLAGS) -fPIC -shared $(OBJECT) -o $(DYNAMIC)

# static: obj
#	ar crs $(STATIC) $(OBJECT)

# test_static: $(TEST) clean static
#	$(CC) $(CFLAGS) -c $(TEST)
#	gcc $(LDFLAGS) $(TESTO) -o $(TEST_STAT) -L. -lcollatz

# test_shared: $(TEST) dynamic
#	$(CC) $(CFLAGS) -c $(TEST)
#	gcc $(LDFLAGS) $(TESTO) -o $(TEST_SHR) -L. -lcollatz -Wl,-rpath=`pwd`

# test_dynamic: $(TEST) dynamic
#	$(CC) $(CFLAGS) -Ddynlib -c $(TEST)
#	gcc $(LDFLAGS) $(TESTO) -o $(TEST_DYN) -L. -lcollatz -Wl,-rpath=`pwd`
