#include "collatz.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  int num = 7, max_iter = 10;
  if (argc > 1) {
    num = atoi(argv[1]);
    if (num == 0) {
      fprintf(stderr,
              "Jako pierwszy argument podać poprawną liczbę większą od 0\n");
      return 42;
    }
    if (argc > 2) {
      max_iter = atoi(argv[2]);
      if (max_iter == 0) {
        fprintf(stderr,
                "Jako drugi argument podać poprawną liczbę większą od 0\n");
        return 255;
      }
    }
  }

  printf("%d is ", num);
  if (test_collatz_convergence(num, max_iter) == -1)
    printf("not ");
  printf("collatz convergent in %d steps\n", max_iter);
  return 0;
}
