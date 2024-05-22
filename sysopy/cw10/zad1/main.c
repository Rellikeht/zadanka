#include <errno.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define RENIFERS 9

typedef struct {
} thread_args;

void *renifer(void *t_args) {
    thread_args args = *(thread_args *)t_args;
    sigset_t set = {0};
    int sig = 0;

    return NULL;
}

void *santa(void *t_args) {
    thread_args args = *(thread_args *)t_args;
    sigset_t set = {0};
    int sig = 0;

    return NULL;
}

int main() {
    int err = 0;
    pthread_t *threads = NULL;
    thread_args *args = NULL;

    threads = malloc(sizeof(pthread_t) * (RENIFERS + 1));

    if (pthread_create(&threads[RENIFERS], NULL, santa, NULL) !=
        0) {
        perror("pthread_create: ");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < RENIFERS; i++) {
        args = malloc(sizeof(thread_args));

        if (pthread_create(&threads[i], NULL, renifer, args) !=
            0) {
            perror("pthread_create: ");
            return EXIT_FAILURE;
        }
    }

    free(threads);
    printf("Hello World\n");

    return 0;
}
