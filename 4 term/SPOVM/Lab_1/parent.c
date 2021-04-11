#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main()
{
    fprintf(stdout, "Parent process is running...\n");
    int status;
    pid_t pid;
    pid = fork();
    if(pid == -1) {
        fprintf(stdout, "Error - %d\n", errno);
    }
    if(pid == 0) {
        execve("./child", NULL, NULL);
    }
    wait(&status);
    fprintf(stdout,"Child process exited with code %d\n", status);
    fprintf(stdout,"Parent process is running...\n");
    exit(0);
}
