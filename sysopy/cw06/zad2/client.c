#include <unistd.h>
#include "common.c"

int main() {
    int err = 0, bytes = 0;
    pipes ps = {0};
    double sum = 0, a = 0, b = 0;
    errno = 0;

    err = scanf("%lf %lf", &a, &b);
    if (err == EOF) {
    } else if (err < 2) {
        if (errno == 0)
            fprintf(stderr, "Niepoprawne dane wejściowe\n");
        else
            perror("scanf()");
        return 1;
    }

    ps = openPipes();
    if (ps.error != 0) {
        return 1;
    }

    printf("Opened\n");
    bytes = write(ps.input, &a, sizeof(a));
    if (bytes == -1) {
        /* fprintf(stderr, "Proces główny, a: "); */
        perror("input pipe write");
        return 1;
    }
    bytes = write(ps.input, &b, sizeof(b));
    if (bytes == -1) {
        /* fprintf(stderr, "Proces główny, b: "); */
        perror("input pipe write");
        return 1;
    }

    printf("Written\n");
    bytes = read(ps.output, &sum, sizeof(sum));
    if (bytes == -1) {
        /* fprintf(stderr, "Proces główny: "); */
        perror("output pipe read");
        return 1;
    }

    printf("Obliczona wartość całki: %.015f\n", sum);
    return closePipes(&ps);
}
