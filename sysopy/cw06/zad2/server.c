#include <stdlib.h>
#include "common.c"

#define WIDTH = 0.0001
static inline double f(double x) { return 4 / (x * x + 1); }

int createPipes() {
    int err = 0;
    err = mkfifo(INPUT_PIPE, S_IRWXU);
    if (err != 0) {
        perror("input pipe creation");
        return 1;
    }

    err = mkfifo(OUTPUT_PIPE, S_IRWXU);
    if (err != 0) {
        perror("output pipe creation");
        err = unlink(INPUT_PIPE);
        if (err != 0) {
            perror("input pipe destruction");
        }
        return 1;
    }

    return 0;
}

int destroyPipes() {
    int err = 0, errb = 0;
    err = unlink(INPUT_PIPE);
    if (err != 0) {
        perror("input pipe destruction");
        errb  = 1;
    }
    err = unlink(OUTPUT_PIPE);
    if (err != 0) {
        perror("output pipe destruction");
        errb += 1;
    }
    return errb;
}

int main(int argc, char *argv[]) {
    int err = 0, bytes = 0;
    pipes ps = {0};
    double sum = 0, a = 0, b = 0;
    errno = 0;

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

    err = createPipes();
    if (err != 0) {
        destroyPipes();
        return 1;
    }

    ps = openPipes();
    if (ps.error != 0) {
        return 1;
    }

    bytes = read(ps.input, &a, sizeof(a));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny, a: ");
        perror("input pipe read");
        return 1;
    }
    bytes = read(ps.input, &b, sizeof(b));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny, b: ");
        perror("input pipe read");
        return 1;
    }

    while (a < b) {
        sum += f(a + w2) * width;
        a += width;
    }

    bytes = write(ps.output, &sum, sizeof(sum));
    if (bytes == -1) {
        fprintf(stderr, "Proces główny: ");
        perror("output pipe write");
        return 1;
    }

    err = closePipes(&ps);
    return destroyPipes() + 4*err;
}
