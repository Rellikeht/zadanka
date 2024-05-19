#include "grid.h"
#include <locale.h>
#include <ncurses.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

typedef struct {
    char *foreground;
    char *background;
    int start;
    int end;
} thread_args;

void *thread_comp(void *t_args) {
    thread_args args = *(thread_args *)t_args;
    sigset_t set = {0};
    int sig = 0;
    char *tmp = NULL;

    free(t_args);
    sigemptyset(&set);
    sigaddset(&set, SIGUSR1);

    if (pthread_sigmask(SIG_BLOCK, &set, NULL) != 0) {
        fprintf(stderr, "Nie udało się ustawić maski\n");
        exit(EXIT_FAILURE);
    }

    while (true) {
        if (sigwait(&set, &sig) != 0) {
            fprintf(stderr, "sigwait failed\n");
            continue;
        }

        if (sig != SIGUSR1) {
            continue;
        }

        update_subgrid(
            args.foreground,
            args.background,
            args.start,
            args.end
        );

        tmp = args.foreground;
        args.foreground = args.background;
        args.background = tmp;
    }

    return NULL;
}

int main(int argc, char const *argv[]) {
    int n_threads = 0;
    pthread_t *threads = NULL;
    thread_args *args = NULL;
    char *foreground = NULL, *background = NULL;

    if (argc != 2) {
        fprintf(stderr, "Należy podać ilość wątków\n");
        return EXIT_FAILURE;
    }

    n_threads = atoi(argv[1]);
    if (n_threads < 1 || n_threads > GRID_HEIGHT * GRID_WIDTH) {
        fprintf(stderr, "Nieprawidłowa ilość wątków\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));
    setlocale(LC_CTYPE, "");
    initscr(); // Start curses mode

    foreground = create_grid();
    background = create_grid();
    init_grid(foreground);

    threads = malloc(sizeof(pthread_t) * n_threads);
    for (int i = 0; i < n_threads; i++) {
        args = malloc(sizeof(thread_args));
        args->foreground = foreground;
        args->background = background;
        args->start =
            i * (GRID_WIDTH * GRID_HEIGHT) / n_threads;
        if (i == n_threads - 1) {
            args->end = GRID_WIDTH * GRID_HEIGHT;
        } else {
            args->end = (i + 1) * (GRID_WIDTH * GRID_HEIGHT) /
                        n_threads;
        }

        if (pthread_create(
                &threads[i], NULL, thread_comp, args
            ) != 0) {
            perror("pthread_create: ");
            return EXIT_FAILURE;
        }
    }

    while (true) {
        draw_grid(foreground);

        for (int i = 0; i < n_threads; i++) {
            if (pthread_kill(threads[i], SIGUSR1) != 0) {
                fprintf(
                    stderr,
                    "Nie udało się wysłać sygnału do wątku "
                    "%i\n",
                    i
                );
            }
        }

        usleep(500 * 1000);
    }

    free(threads);
    free(args);
    endwin(); // End curses mode
    destroy_grid(foreground);
    destroy_grid(background);

    return 0;
}
