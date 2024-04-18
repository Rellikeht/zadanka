#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUFSIZE 20

int main(int argc, char *argv[]) {
    errno = 0;
    char *invalid = NULL;
    char buf[BUFSIZE + 1] = {0};
    int err = 0;

    int i = 0;
    pid_t child = 0;
    double sum = 0, a = 0; //, b = 0;

    if (argc != 3) {
        fprintf(stderr, "Liczba argumentów powinna wynosić 3\n");
        return 1;
    }

    const double width = strtod(argv[1], NULL);
    if (width == 0) {
        fprintf(stderr, "Błąd przy konwersji argv[1] (szerokość prostokąta)\n");
        return 1;
    } else if (width <= 0) {
        fprintf(stderr,
                "Szerokość prostokąta (argv[1]) musi być większa od 0\n");
        return 1;
    }

    const long processes = strtol(argv[2], &invalid, 10);
    if (processes == LONG_MIN || processes == LONG_MAX || *invalid != 0) {
        fprintf(stderr, "Błąd przy konwersji argv[2] (ilości procesów)\n");
        return 1;
    } else if (processes < 1) {
        fprintf(stderr, "Ilość procesów (argv[2]) musi być większa od 0\n");
        return 1;
    }
    int pipes[processes][2];

    // TODO pipe

    for (i = 0; i < processes; i++) {
        err = pipe(pipes[i]);

        child = fork();
        if (child == -1) {
            perror("fork()");
            return 1;
        }

        if (child != 0) {
            err = close(pipes[i][1]);
            if (err == -1) {
                fprintf(stderr, "Parent, write pipe %i: ", i);
                perror("close()");
                return 1;
            }
            continue;
        }

        err = close(pipes[i][0]);
        if (err == -1) {
            fprintf(stderr, "Child, read pipe %i: ", i);
            perror("close()");
            return 1;
        }

        printf("Child %i\n", i);

        err = close(pipes[i][1]);
        if (err == -1) {
            fprintf(stderr, "Child, write pipe %i: ", i);
            perror("close()");
            return 1;
        }
        return 0;
    }

    while (true) {
        if (wait(0) == -1) {
            if (errno != ECHILD) {
                perror("wait()"); // ???
                return 1;
            }
            break;
        }
    }

    for (i = 0; i < processes; i++) {
        err = read(pipes[i][0], buf, BUFSIZE);
        if (err == -1) {
            fprintf(stderr, "Parent, read pipe %i: ", i);
            perror("read()");
            return 1;
        }

        err = close(pipes[i][0]);
        if (err == -1) {
            fprintf(stderr, "Parent, read pipe %i: ", i);
            perror("close()");
            return 1;
        }

        a = strtod(buf, &invalid);
        if (invalid != NULL) {
            fprintf(stderr, "Parent, read pipe %i: Invalid double to parse\n",
                    i);
            return 1;
        }

        sum += a;
    }

    printf("Wartość całki: %lf\n", sum);
    return 0;
}
