#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <stddef.h>
#include <errno.h>
#include <pthread.h>

static int clock_counter = 0;
static int exit_code = 1;
static int signal1 = 0;
static int signal2 = 0;
static int alarm_clock = 1;

void alarm_signal(int sig) {
	if(sig == SIGALRM) {
        printf(".\n");
        clock_counter++;
        alarm_clock = 0;
    }
    if(sig == SIGINT) {
	    exit_code = 0;
    }
}

void check_signal(int sig){
    if(sig == SIGUSR1){
        signal1 = 1;
    }
    if(sig == SIGUSR2){
        signal2 = 1;
    }
}

void* child_function() {
    fprintf(stdout, "CHILD: Child process is running...\n");

    FILE *file;
    if ((file = tmpfile()) == NULL) {
        perror("CHILD: File wasn't created!\n");
        exit(errno);
    }

    struct sigaction signal_struct;
    int error_thread;
    sigset_t signal_set;

    sigemptyset(&signal_set);
    sigaddset(&signal_set, SIGALRM);
    sigaddset(&signal_set, SIGINT);

    error_thread = pthread_sigmask(SIG_BLOCK, &signal_set, NULL);
    if (error_thread != 0) {
        printf("CHILD: Error in thread_sigmask\n");
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

    while (signal2 != 1) {
        fputc('.', file);

        if (signal1 == 1) {
            printf("%d symbols in temp file\n", clock_counter);
            signal1 = 0;
        }
	}

    if (fclose(file) == EOF) {
        printf("CHILD: File wasn't close!\n");
        exit(errno);
    }

    printf("CHILD: Child process ended...\n");
    pthread_exit(0);
} 

int main() {
    fprintf(stdout, "PARENT: Parent process is running...\n");

    int status;
    int flag = 5;
    struct sigaction signal_struct;
    pthread_t pthread;

    if (pthread_create(&pthread, NULL, child_function, NULL) == 0) {
        printf("PARENT: Сhild process is started by the parent...\n");
    } else {
        printf("PARENT: Error in pthread_create\n");
        exit(errno);
    }

    signal_struct.sa_handler = alarm_signal;
	sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGALRM, &signal_struct, 0) == -1) {
        printf("PARENT: Error in sigaction (SIGALRM)!\n");
        exit(errno);
    }

    signal_struct.sa_handler = alarm_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    if (sigaction(SIGINT, &signal_struct, 0) == -1) {
        printf("PARENT: Error in sigaction (SIGINT)!\n");
        exit(errno);
    }

    int error_thread;
    sigset_t signal_set;
    sigemptyset(&signal_set);
    sigaddset(&signal_set, SIGUSR1);
    sigaddset(&signal_set, SIGUSR2);

    error_thread = pthread_sigmask(SIG_BLOCK, &signal_set, NULL);
    if (error_thread != 0) {
        printf("PARENT: Error in thread_sigmask\n");
        exit(errno);
    }

    while(exit_code) {
        flag = 5; 
        while(flag) {
            flag--;
            alarm(1);
            while(alarm_clock != 0) {
                pause();
            }
            alarm_clock = 1;
            if(exit_code == 0) {
                flag = 0;
            }
        }
        if (pthread_kill(pthread, SIGUSR1) !=0 ) {
            printf("PARENT: Error in pthread_kill (SIGUSR1)\n");
            exit(errno);
        }
    }

    alarm(0);
    if (pthread_kill(pthread, SIGUSR2) != 0) {
        printf("PARENT: Error in pthread_kill (SIGUSR2)\n");
        exit(errno);
    }

    int child_code;
    void* child_code_addres = &child_code;

    error_thread = pthread_join(pthread, &child_code_addres);
    if (error_thread != 0) {
        printf("PARENT: Error in pthread_join\n\n");
        exit(errno);
    }

    wait(&status);
    printf("PARENT: Parent process ended...\n");
    printf("Exit status - %d\n", status);
    exit(0);
}