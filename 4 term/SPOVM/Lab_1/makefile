CC = gcc

CFLAGS = -c -W -Wall -Wextra

.PHONY:all
all: start

start:	parent.o child.o
	$(CC) parent.o -o parent
	$(CC) child.o -o child
	
parent.o: parent.c
	$(CC) $(CFLAGS) parent.c
	
child.o: child.c
	$(CC) $(CFLAGS) child.c

clean:
	rm -rf *.o parent child	
