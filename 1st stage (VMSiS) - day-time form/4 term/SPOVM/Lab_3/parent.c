#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>

static int clock = 1;
static int exit_code = 1;

void alarm_signal(int sig) {
	if(sig == SIGALRM) {
        printf(".\n");
        clock = 0;
    }
    if(sig == SIGINT) {
	exit_code = 0;
    }
}

int main(int argc, char **argv) {
    int status;
    int flag = 5;
    pid_t pid;
	struct sigaction signal_struct;

    fprintf(stdout, "PARENT: Parent process is running...\n");

    signal_struct.sa_handler = alarm_signal;
	sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGALRM, &signal_struct, NULL) == -1) {
        perror("PARENT: Error in sigaction (SIGALRM)!\n");
        exit(errno);
    } 
    signal_struct.sa_handler = alarm_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
     if (sigaction(SIGINT, &signal_struct, NULL) == -1) {
        perror("PARENT: Error in sigaction (SIGINT)!\n");
        exit(errno);
    } 

	fprintf(stdout, "PARENT: Сhild process is started by the parent...\n");

    if ((pid = fork()) == -1) {
        perror("PARENT: Error in fork\n");
        exit(errno);
    }
	if (pid == 0) {
        if (execve("./child", argv, NULL) == -1) {
            perror("PARENT: Error in execve\n");
            exit(errno);
        }
    }

	while(exit_code) {
        flag = 5; 
        while(flag) {
            flag--;
            alarm(1);
            while(clock != 0) {
                pause();
            }
            clock = 1;
            if(exit_code == 0) {
                flag = 0;
            }
        }
        kill(pid, SIGUSR1);
    }

    alarm(0);
    kill(pid, SIGUSR2);
    wait(&status);
    printf("PARENT: Parent process ended...\n");
    printf("Exit status - %d\n", status);

    return argc;
}