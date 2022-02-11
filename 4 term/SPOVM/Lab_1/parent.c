#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main()
{
    fprintf(stdout, "PARENT: Parent process is running...\n");
    int status;
    pid_t pid;
    char **argv = NULL;
    pid = fork();
    if(pid == -1) {
        fprintf(stdout, "PARENT: Error - %d\n", errno);
    }
    if(pid == 0) {
        execve("./child", argv, NULL);
    }
    wait(&status);
    fprintf(stdout,"PARENT: Child process exited with code %d\n", status);
    fprintf(stdout,"PARENT: Parent process is running...\n");
    exit(0);
}
