#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err, amount;

  doOrErr(1, argc < 2, "Należy podać ilość procesów\n");
  amount = atoi(argv[1]);
  doOrErr(2, amount == 0, "Należy podać liczbę > 0\n");

  printf("argv[1] = \"%s\"\n", argv[1]);
  return 0;
}
