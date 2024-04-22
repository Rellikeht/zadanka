#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define TRUEVAL 3.141592653589793

static inline double f(double x) { return 4 / (x * x + 1); }

int main(int argc, char *argv[]) {
    errno = 0;
    char *invalid = NULL;
    int err = 0, i = 0, bytes = 0;
    pid_t child = 0;
    double sum = 0, a = 0, b = 0;

    if (argc != 3) {
        fprintf(stderr, "Liczba argumentów powinna wynosić 2\n");
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
    const double w2 = width / 2;

    const long processes = strtol(argv[2], &invalid, 10);
    if (processes == LONG_MIN || processes == LONG_MAX || *invalid != 0) {
        fprintf(stderr, "Błąd przy konwersji argv[2] (ilości procesów)\n");
        return 1;
    } else if (processes < 1) {
        fprintf(stderr, "Ilość procesów (argv[2]) musi być większa od 0\n");
        return 1;
    }
    int pipes[processes][2];

    for (i = 0; i < processes; i++) {
        a = b;
        b = (double)(i + 1) / (double)processes;

        err = pipe(pipes[i]);
        if (err != 0) {
            perror("pipe()");
            return 1;
        }

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

        a += w2;
        while (a < b) {
            sum += f(a) * width;
            a += width;
        }

        bytes = write(pipes[i][1], &sum, sizeof(sum));
        if (bytes == -1) {
            fprintf(stderr, "Child %i: ", i);
            perror("write()");
            return 1;
        }

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
                perror("wait()");
                return 1;
            }
            break;
        }
    }

    for (i = 0; i < processes; i++) {
        bytes = read(pipes[i][0], &a, sizeof(sum));
        if (bytes == -1) {
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

        sum += a;
    }

    printf("Obliczona wartość całki:   %.015f\n", sum);
    printf("Rzeczywista wartość całki: %.015f\n", TRUEVAL);
    return 0;
}
