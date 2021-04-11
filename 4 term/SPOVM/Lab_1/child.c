#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main()
{
    fprintf(stdout, "Child process is running...\n");
    fprintf(stdout,"Enter the symbol ('q'): ");
    while(getc(stdin) != 'q');
    exit(0);
}
