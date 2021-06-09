#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main()
{
    fprintf(stdout, "CHILD: Child process is running...\n");
    fprintf(stdout,"CHILD: Enter the symbol ('q'): ");
    while(getc(stdin) != 'q');
    exit(0);
}
