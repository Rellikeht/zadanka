#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    errno = 0;
    char *invalid = NULL;
    int err = 0;

    int i = 0;
    pid_t child = 0;
    double sum = 0;

    if (argc != 3) {
        fprintf(stderr, "Liczba argumentów powinna wynosić 3\n");
        return 1;
    }

    const double width = strtod(argv[2], NULL);
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
        fprintf(stderr, "Ilość procesów (argv[1]) musi być większa od 0\n");
        return 1;
    }

    // TODO pipe

    for (i = 0; i < processes; i++) {
        child = fork();
        if (child == -1) {
            perror("fork()");
            return 1;
        }
        if (child != 0) {
            // parent
            continue;
        }
    }

    return 0;
}
