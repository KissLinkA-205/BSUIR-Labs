CC = gcc

CFLAGS = -c -W -Wall -Wextra

.PHONY:all
all: start

start:	main.o	
	$(CC) main.o -o main

main.o: main.c
	$(CC) $(CFLAGS) main.c
	
clean:
	rm -rf *.o main
