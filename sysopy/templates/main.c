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

  if (argc < 2)
    name = ".";
  else
    name = argv[1];

  return 0;
}
