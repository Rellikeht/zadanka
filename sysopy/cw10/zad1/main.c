#include <pthread.h>
#include <semaphore.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define REINDEERS 9
#define RUNS      4
#define UNUSED(x) (void)(x)
#define SECOND    100000

typedef struct {
    int id;
} thread_args;

sem_t *reindeers_waiting = NULL;
sem_t *santa_waiting = NULL;
pthread_mutex_t *lock = NULL;
int reindeers = 0;
int runs = 0;

int randint(int a, int b) { return (a + rand() % (b - a + 1)); }

void *reindeer(void *t_args) {
    thread_args args = *(thread_args *)t_args;
    free(t_args);

    while (runs < RUNS) {
        usleep(SECOND * randint(5, 10));

        pthread_mutex_lock(lock);
        printf(
            "Renifer: czeka %i reniferów na Mikołaja, ID: "
            "%i\n",
            reindeers,
            args.id
        );
        reindeers += 1;

        if (reindeers == REINDEERS) {
            printf(
                "renifer: wybudzam Mikołaja, ID: %i\n", args.id
            );
        }

        pthread_mutex_unlock(lock);
        sem_post(reindeers_waiting);
        sem_wait(santa_waiting);
    }

    return NULL;
}

void *santa(void *t_args) {
    UNUSED(t_args);

    while (runs < RUNS) {
        for (int i = 0; i < REINDEERS; i++) {
            sem_wait(reindeers_waiting);
        }

        pthread_mutex_lock(lock);
        reindeers = 0;
        pthread_mutex_unlock(lock);

        printf("Mikołaj: budzę się\n");
        printf("Mikołaj: dostarczam zabawki\n");
        usleep(SECOND * randint(1, 2));
        printf("Mikołaj: zasypiam\n");
        runs += 1;

        for (int i = 0; i < REINDEERS; i++) {
            sem_post(santa_waiting);
        }
    }

    return NULL;
}

int main() {
    pthread_t *threads = NULL;
    thread_args *args = NULL;
    int err;

    lock = malloc(sizeof(pthread_mutex_t));
    if (lock == NULL) {
        perror("malloc: ");
        return 1;
    }

    reindeers_waiting = malloc(sizeof(sem_t));
    if (reindeers_waiting == NULL) {
        perror("malloc: ");
        return 1;
    }

    santa_waiting = malloc(sizeof(sem_t));
    if (santa_waiting == NULL) {
        perror("malloc: ");
        return 1;
    }

    err = sem_init(reindeers_waiting, 0, 0);
    if (err != 0) {
        perror("mutex_init: ");
        return 1;
    }

    err = sem_init(santa_waiting, 0, 0);
    if (err != 0) {
        perror("mutex_init: ");
        return 1;
    }

    err = pthread_mutex_init(lock, NULL);
    if (err != 0) {
        perror("mutex_init: ");
        return 1;
    }

    threads = malloc(sizeof(pthread_t) * (REINDEERS + 1));
    if (threads == NULL) {
        perror("malloc: ");
        return 1;
    }

    srand(time(NULL));

    if (pthread_create(
            &threads[REINDEERS], NULL, santa, NULL
        ) != 0) {
        perror("pthread_create: ");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < REINDEERS; i++) {
        args = malloc(sizeof(thread_args));
        if (args == NULL) {
            perror("malloc: ");
            return 1;
        }
        args->id = i;

        if (pthread_create(&threads[i], NULL, reindeer, args) !=
            0) {
            perror("pthread_create: ");
            return EXIT_FAILURE;
        }
    }

    while (runs < RUNS) {
        usleep(SECOND / 10);
    }

    pthread_mutex_destroy(lock);
    free(lock);
    free(reindeers_waiting);
    free(santa_waiting);
    free(threads);

    return 0;
}
