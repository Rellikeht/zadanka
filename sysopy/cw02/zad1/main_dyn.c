#include "collatz.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  int num = 7, max_iter = 10;
  if (argc > 1) {
    num = atoi(argv[1]);
    if (num == 0) {
      fprintf(stderr,
              "Jako pierwszy argument podać poprawną liczbę większą od 0\n");
      return 1;
    }
    if (argc > 2) {
      max_iter = atoi(argv[2]);
      if (max_iter == 0) {
        fprintf(stderr,
                "Jako drugi argument podać poprawną liczbę większą od 0\n");
        return 2;
      }
    }
  }

  void *handle = dlopen("libcollatz.so", RTLD_LAZY);
  if (!handle) {
    fprintf(stderr, "Błąd z ładowniem biblioteki\n");
    return 3;
  }

  int (*test_collatz_convergence)(int, int);
  test_collatz_convergence =
      (int (*)(int, int))dlsym(handle, "test_collatz_convergence");

  char *err = dlerror();
  if (err != NULL) {
    fprintf(stderr, "De El Error: %s\n", err);
    return 4;
  }

  printf("%d is ", num);
  if (test_collatz_convergence(num, max_iter) == -1)
    printf("not ");
  printf("collatz convergent in %d steps\n", max_iter);

  dlclose(handle);
}
