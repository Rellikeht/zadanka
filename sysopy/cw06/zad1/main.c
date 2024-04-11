#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  char *invalid;
  errno = 0;

  if (argc != 3) {
    fprintf(stderr, "Liczba argumentów powinna wynosić 3\n");
    return 1;
  }

  const double width = strtod(argv[2], NULL);
  if (width == 0) {
    fprintf(stderr, "Błąd przy konwersji argv[1] (szerokość prostokąta)\n");
    return 1;
  } else if (width <= 0) {
    fprintf(stderr, "Szerokość prostokąta (argv[1]) musi być większa od 0\n");
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

  return 0;
}
