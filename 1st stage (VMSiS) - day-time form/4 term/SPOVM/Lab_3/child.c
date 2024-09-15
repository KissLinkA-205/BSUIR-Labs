#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>

static int signal1 = 0;
static int signal2 = 0;
static int signal3 = 0;

void check_signal(int sig){
	if(sig == SIGALRM){
        signal1 = 1;
    }
    if(sig == SIGUSR1){
        signal2 = 1;
    }
    if(sig == SIGUSR2){
        signal3 = 1;
    }
}

int main() {
fprintf(stdout, "CHILD: Child process is running...\n");

    FILE *file;
    if ((file = tmpfile()) == NULL) {
        perror("CHILD: File wasn't created!\n");
        exit(errno);
    }

    int clock = 0;
    struct sigaction signal_struct;

    signal_struct.sa_handler = check_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
     if (sigaction(SIGALRM, &signal_struct, NULL) == -1) {
        perror("CHILD: Error in sigaction (SIGALRM)!\n");
        exit(errno);
    } 

    signal_struct.sa_handler = check_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGUSR1, &signal_struct, NULL) == -1) {
        perror("CHILD: Error in sigaction (SIGUSR1)!\n");
        exit(errno);
    } 

    signal_struct.sa_handler = check_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGUSR2, &signal_struct, NULL) == -1) {
        perror("CHILD: Error in sigaction (SIGUSR2)!\n");
        exit(errno);
    } 

	signal_struct.sa_handler = SIG_IGN;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGINT, &signal_struct, NULL) == -1) {
        perror("CHILD: Error in sigaction (SIGINT)!\n");
        exit(errno);
    } 

    while(signal3 != 1) {
		alarm(1);
		while(signal1 != 1) {
            pause();
        }
		fprintf(file, "%d seconds passed\n", clock);
		clock++;
		signal1 = 0; 
        if(signal2 == 1){
            printf("%d\n", clock);
            signal2 = 0;
        }
	}
    
	alarm(0);
    printf("CHILD: Child process ended...\n");
    fclose(file);
    exit(0);

    return 0;
}