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
    int start; // inclusive
    int end;   // exclusive
} thread_args;

void *thread_comp(void *t_args) {
    /* thread_args args = *(thread_args *)t_args; */
    sigset_t set;
    sigemptyset(&set);
    sigaddset(&set, SIGUSR1);

    if (pthread_sigmask(SIG_BLOCK, &set, NULL) != 0) {
        fprintf(stderr, "Nie udało się ustawić maski\n");
        exit(EXIT_FAILURE);
    }

    /*     while (true) { */
    /*         int sig; */
    /*         if (sigwait(&set, &sig) != 0) { */
    /*             fprintf(stderr, "sigwait failed\n"); */
    /*             continue; */
    /*         } */

    /*         if (sig != SIGUSR1) { */
    /*             continue; */
    /*         } */

    /*         update_subgrid( */
    /*             args.foreground, */
    /*             args.background, */
    /*             args.start, */
    /*             args.end */
    /*         ); */

    /*         char *tmp = args.foreground; */
    /*         args.foreground = args.background; */
    /*         args.background = tmp; */
    /*     } */

    return NULL;
}

bool running = true;
void sigint_handler(int ignored) {
    running = false;
    /* endwin(); // End curses mode */
}

int main(int argc, char const *argv[]) {
    int n_threads = 0;
    pthread_t *threads = NULL;
    thread_args *args = NULL;
    char *foreground = NULL, *background = NULL, *tmp = NULL;

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
    signal(SIGINT, sigint_handler);

    foreground = create_grid();
    background = create_grid();
    init_grid(foreground);

    threads = malloc(sizeof(pthread_t) * n_threads);
    args = malloc(sizeof(thread_args) * n_threads);
    for (long i = 0; i < n_threads; i++) {
        (&args[i])->foreground = foreground;
        (&args[i])->background = background;
        (&args[i])->start =
            i * (GRID_WIDTH * GRID_HEIGHT) / n_threads;
        if (i == n_threads - 1) {
            (&args[i])->end = GRID_WIDTH * GRID_HEIGHT;
        } else {
            (&args[i])->end = (i + 1) *
                              (GRID_WIDTH * GRID_HEIGHT) /
                              n_threads;
        }

        if (pthread_create(
                &threads[i], NULL, thread_comp, args
            ) != 0) {
            perror("pthread_create: ");
            return EXIT_FAILURE;
        }
    }

    while (running) {
        draw_grid(foreground);
        usleep(500 * 1000);

        // Step simulation
        update_grid(foreground, background);
        tmp = foreground;
        foreground = background;
        background = tmp;
    }

    free(threads);
    free(args);
    endwin(); // End curses mode
    destroy_grid(foreground);
    destroy_grid(background);

    return 0;
}
