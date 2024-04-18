#include <errno.h>
#include <stdio.h>

int main() {
    int err = 0, bytes = 0;
    double result = 0, a = 0, b = 0;
    errno = 0;

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

    printf("Obliczona wartość całki: %.015f\n", result);
    return 0;
}
