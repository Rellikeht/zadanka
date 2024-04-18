#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

static inline double f(double x) { return 4 / (x * x + 1); }

#define WIDTH = 0.0001

int main(int argc, char *argv[]) {
    // ZMIENNE
    errno = 0;
    int err = 0, bytes = 0;
    double sum = 0, a = 0, b = 0;
    int input[2], output[2];
    pid_t child = 0;

    // ARGUMENTY
    if (argc != 2) {
        fprintf(stderr, "Liczba argumentów powinna wynosić 1\n");
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

    // PIPY
    err = pipe(input);
    if (err != 0) {
        perror("input pipe()");
        return 1;
    }
    err = pipe(output);
    if (err != 0) {
        perror("output pipe()");
        return 1;
    }

    // PODPROCES
    child = fork();
    if (child == -1) {
        perror("fork()");
        return 1;
    }

    if (child == 0) {
        err = close(input[1]);
        if (err == -1) {
            fprintf(stderr, "Proces potomny, wejście (nadmiarowe): ");
            perror("close()");
            return 1;
        }
        err = close(output[0]);
        if (err == -1) {
            fprintf(stderr, "Proces potomny, wyjście (nadmiarowe): ");
            perror("close()");
            return 1;
        }

        // ODBIERANIE
        bytes = read(input[0], &a, sizeof(sum));
        if (bytes == -1) {
            fprintf(stderr, "Proces potomny, a: ");
            perror("read()");
            return 1;
        }
        bytes = read(input[0], &b, sizeof(sum));
        if (bytes == -1) {
            fprintf(stderr, "Proces potomny, b: ");
            perror("read()");
            return 1;
        }

        // CAŁKA
        while (a < b) {
            sum += f(a + w2) * width;
            a += width;
        }

        // ZAPIS
        bytes = write(output[1], &sum, sizeof(sum));
        if (bytes == -1) {
            fprintf(stderr, "Proces potomny: ");
            perror("read()");
            return 1;
        }

        err = close(input[0]);
        if (err == -1) {
            fprintf(stderr, "Proces potomny, wejście: ");
            perror("close()");
            return 1;
        }
        err = close(output[1]);
        if (err == -1) {
            fprintf(stderr, "Proces potomny, wyjście: ");
            perror("close()");
            return 1;
        }
        return 0;
    }

    err = close(input[0]);
    if (err == -1) {
        fprintf(stderr, "Proces głowny, wejście (nadmiarowe): ");
        perror("close()");
        return 1;
    }
    err = close(output[1]);
    if (err == -1) {
        fprintf(stderr, "Proces głowny, wyjście (nadmiarowe): ");
        perror("close()");
        return 1;
    }

    // WEJŚCIE
    err = scanf("%lf %lf", &a, &b);
    if (err == EOF) {
    } else if (err < 2) {
        if (errno == 0)
            fprintf(stderr, "Niepoprawne dane wejściowe\n");
        else
            perror("scanf()");
        return 1;
    }

    // WYSYŁANIE
    bytes = write(input[1], &a, sizeof(sum));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny, a: ");
        perror("write()");
        return 1;
    }
    bytes = write(input[1], &b, sizeof(sum));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny, b: ");
        perror("write()");
        return 1;
    }

    // ODCZYT
    bytes = read(output[0], &sum, sizeof(sum));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny: ");
        perror("read()");
        return 1;
    }

    err = close(input[1]);
    if (err == -1) {
        fprintf(stderr, "Proces głowny, wejście (nadmiarowe): ");
        perror("close()");
        return 1;
    }
    err = close(output[0]);
    if (err == -1) {
        fprintf(stderr, "Proces głowny, wyjście (nadmiarowe): ");
        perror("close()");
        return 1;
    }

    printf("Obliczona wartość całki: %.015f\n", sum);
    return 0;
}
