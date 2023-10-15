#define _POSIX_C_SOURCE 200809L
#include <pthread.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <limits.h>

long int convertToLong(char* str);
int compareInt(const void* number1, const void* number2);
static void* executeThread(void* arg);

struct thread_info {       
    pthread_t           id;  
    int                 number;
    char**              address;
    int                 thread_size;
    int*                block_size;
    int*                flag;
    pthread_barrier_t*  barrier1;
    pthread_barrier_t*  barrier2;
};

int main(int argc, char *argv[]) {
    int status;
    long int pages_number = 1;
    long int threads_number = 10;

    if (argc < 2 || argc > 4) {
        fprintf(stderr, "ERROR: Correct format: file_name [threads_number] [pages_number]\n");
        exit(0);
    }

    if (argc > 2) {
        threads_number = convertToLong(argv[2]);
    }
    if (argc > 3) {
        pages_number = convertToLong(argv[3]);
    }

    int page_size = sysconf(_SC_PAGE_SIZE);
    int thread_size = pages_number * page_size;
    int block_size = thread_size * threads_number;

    int file_descriptor = open(argv[1], O_RDWR);
    if (file_descriptor == -1)  {
        printf("ERROR: Wrong file name\n");
        exit(0);
    }

    struct stat file_stat;
    if (fstat(file_descriptor, &file_stat) == -1) {
        printf("ERROR: fstat\n");
        exit(0);
    }

    pthread_barrier_t barrier1;
    pthread_barrier_t barrier2;
    status = pthread_barrier_init(&barrier1, NULL, threads_number  + 1);
    if (status != 0) {
        printf("ERROR: Init barrier1\n");
        exit(0);
    }
    status = pthread_barrier_init(&barrier2, NULL, threads_number  + 1);
    if (status != 0) {
        printf("ERROR: Init barrier2\n");
        exit(0);
    }

    int blocks_size = 0;
    int flag = 0;
    char* address;
    struct thread_info *info;
    info = calloc(threads_number, sizeof(struct thread_info));
    if (info == NULL) {
        printf("ERROR: calloc\n");
        exit(0);
    }

    for (int i = 0; i < threads_number; ++i) {
        info[i].number = i + 1;
        info[i].address = &address;
        info[i].thread_size = thread_size;
        info[i].block_size = &blocks_size;
        info[i].flag = &flag;
        info[i].barrier1 = &barrier1;
        info[i].barrier2 = &barrier2;

        status = pthread_create(&info[i].id, NULL, &executeThread, &info[i]);
        if (status != 0) {
            printf("ERROR: pthread_create\n");
            exit(0);
        }
    }

    off_t offset = 0;
    off_t remaining_size = file_stat.st_size;
    int count = 0;
    while (remaining_size > 0) {
        if (remaining_size > block_size) {
            blocks_size = block_size;
        } else {
            blocks_size = remaining_size;
        }
       
        address = mmap(NULL, blocks_size, PROT_READ | PROT_WRITE, MAP_SHARED, file_descriptor, offset);
    
        if (address == MAP_FAILED) {
            printf("ERROR: mmap\n");
            exit(0);
        }
        offset += block_size;
        remaining_size -= block_size;

        if (remaining_size <= 0)
            flag = 1;

        status = pthread_barrier_wait(&barrier1);
        if (status != 0 && status != PTHREAD_BARRIER_SERIAL_THREAD) {
            printf("ERROR: barrier_wait (barrier1)\n");
            exit(0);
        }

        status = pthread_barrier_wait(&barrier2);
        if (status != 0 && status != PTHREAD_BARRIER_SERIAL_THREAD) {
            printf("ERROR: barrier_wait (barrier2)\n");
            exit(0);
        }

        status = msync(address, blocks_size, MS_SYNC);
        if (status == -1) {
            printf("ERROR: msync\n");
            exit(0);
        }

        status = munmap(address, blocks_size);
        if (status == -1) {
            printf("ERROR: munmap\n");
            exit(0);
        }

        ++count;
        if (count == 500) {
            count = 0;
            float processed_value = (float)(file_stat.st_size - remaining_size) / file_stat.st_size * 100;
            if (processed_value > 100.00f)
                processed_value = 100.00f;
            fprintf(stdout, "processed %.3f%%\n", processed_value);
        }
    }

    fprintf(stdout, "processed %.3f%%\n", 100.000f);

    pthread_barrier_destroy(&barrier1);
    if (status != 0) {
        printf("ERROR: barrier_destroy (barrier1)\n");
        exit(0);
    }
    pthread_barrier_destroy(&barrier2);
    if (status != 0) {
        printf("ERROR: barrier_destroy (barrier2)\n");
        exit(0);
    }
    
    status = close(file_descriptor);
    if (status == -1) {
        printf("ERROR: Unable to close the file!\n");
        exit(0);
    }

     exit(0);
}

long int convertToLong(char* str) {
    char* endptr;
    errno = 0;
    long int result = strtol(str, &endptr, 10);
    if (endptr == str) {
        fprintf(stderr, "ERROR: Wrong number!\n");
        exit(0);
    }
    return result;
} 

int compareInt(const void* number1, const void* number2) {
    uint32_t arg1 = *(const uint32_t*)number1;
    uint32_t  arg2 = *(const uint32_t*)number2;
 
    if (arg1 > arg2) return 1;
    if (arg1 < arg2) return -1;
    return 0;
}

static void* executeThread(void* arg) {
    int status;
    struct thread_info* info = arg;

    while (!(*info->flag)) {
        status = pthread_barrier_wait(info->barrier1);
        if (status != 0 && status != PTHREAD_BARRIER_SERIAL_THREAD) {
            fprintf(stderr, "ERROR: barrier_wait (barrier1)\n");
            exit(0);
        }

        int start = (info->number - 1) * info->thread_size;
        if (start >= *info->block_size) {
            status = pthread_barrier_wait(info->barrier2);
            if (status != 0 && status != PTHREAD_BARRIER_SERIAL_THREAD) {
                fprintf(stderr, "ERROR: barrier_wait (barrier2)\n");
                exit(0);
            }
            pthread_exit(0);
        }

        int size;
        if ((*info->block_size - start) > info->thread_size)
            size = info->thread_size;
        else {
            size = *info->block_size - start;
        }
        size = size - (size % sizeof(uint32_t));

        qsort(*info->address + start, size / sizeof(uint32_t),
              sizeof(uint32_t), compareInt);

        status = pthread_barrier_wait(info->barrier2);
        if (status != 0 && status != PTHREAD_BARRIER_SERIAL_THREAD) {
            fprintf(stderr, "ERROR: barrier_wait (barrier2)\n");
            exit(0);
        }
    }

    pthread_exit(0);
}