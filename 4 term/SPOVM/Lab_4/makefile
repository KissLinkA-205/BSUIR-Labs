CC = gcc

CFLAGS = -W -Wall -Wextra -pthread -std=c11 -o

.PHONY: all
all: start

start:	main.c	
	$(CC) $(CFLAGS) main main.c
	
clean:
	rm -rf *.o start
