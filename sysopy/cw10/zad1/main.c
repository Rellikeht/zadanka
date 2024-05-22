#include <pthread.h>
#include <semaphore.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define RENIFERS  9
#define RUNS      1
#define UNUSED(x) (void)(x)
#define SECOND    10000

typedef struct {
    int id;
} thread_args;

sem_t *santa_waiting = NULL;
sem_t *renifers_waiting = NULL;
int runs = 0;

int randint(int a, int b) { return (a + rand() % (b - a + 1)); }

void *renifer(void *t_args) {
    thread_args args = *(thread_args *)t_args;
    free(t_args);

    /* sigset_t set = {0}; */
    /* int sig = 0; */

    while (runs < RUNS) {
        int waiting = 0;
        usleep(SECOND * randint(5, 10));

        sem_getvalue(renifers_waiting, &waiting);
        printf(
            "Renifer: czeka %i reniferów na Mikołaja, ID: %i\n",
            waiting,
            args.id
        );

        sem_post(renifers_waiting);
        sem_post(santa_waiting);
        /* if (waiting == RENIFERS - 1) { */
        /*     printf( */
        /*         "Renifer: wybudzam Mikołaja, ID: %i\n",
         * args.id */
        /*     ); */
        /* } */

        sem_wait(renifers_waiting);
        /* usleep(SECOND * randint(1, 2)); */
    }

    return NULL;
}

void *santa(void *t_args) {
    UNUSED(t_args);

    while (runs < RUNS) {
        int waiting = 0;
        while (waiting < RENIFERS) {
            sem_getvalue(renifers_waiting, &waiting);
            sleep(SECOND / 10);
        }

        /* for (int i = 0; i < RENIFERS; i++) { */
        /*     sem_wait(santa_waiting); */
        /* } */

        printf("Mikołaj: budzę się\n");
        printf("Mikołaj: dostarczam zabawki\n");
        usleep(SECOND * randint(1, 2));

        for (int i = 0; i < RENIFERS; i++) {
            sem_post(renifers_waiting);
        }

        printf("Mikołaj: zasypiam\n");
        runs += 1;
    }

    return NULL;
}

int main() {
    pthread_t *threads = NULL;
    thread_args *args = NULL;
    int err;

    srand(time(NULL));

    santa_waiting = malloc(sizeof(sem_t));
    if (santa_waiting == NULL) {
        perror("malloc: ");
        return 1;
    }

    renifers_waiting = malloc(sizeof(sem_t));
    if (renifers_waiting == NULL) {
        perror("malloc: ");
        return 1;
    }

    err = sem_init(santa_waiting, 0, 0);
    if (err != 0) {
        perror("sem_init: ");
        return 1;
    }

    err = sem_init(renifers_waiting, 0, 0);
    if (err != 0) {
        perror("sem_init: ");
        return 1;
    }

    threads = malloc(sizeof(pthread_t) * (RENIFERS + 1));
    if (threads == NULL) {
        perror("malloc: ");
        return 1;
    }

    if (pthread_create(&threads[RENIFERS], NULL, santa, NULL) !=
        0) {
        perror("pthread_create: ");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < RENIFERS; i++) {
        args = malloc(sizeof(thread_args));
        if (args == NULL) {
            perror("malloc: ");
            return 1;
        }
        args->id = i;

        if (pthread_create(&threads[i], NULL, renifer, args) !=
            0) {
            perror("pthread_create: ");
            return EXIT_FAILURE;
        }
    }

    while (runs < RUNS) {
        usleep(SECOND / 10);
    }

    free(threads);
    free(santa_waiting);
    free(renifers_waiting);

    return 0;
}
