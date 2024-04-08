#include <errno.h>
#include <stdio.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err = 0;
  char *name;
  doOrErr(1, argc != 2, "Zła ilość argumentów\n");

  return 0;
}
