#include <errno.h>
#include <stdio.h>
#include <unistd.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  /* int err = 0; */
  /* char *name; */
  printf("Catcher: PID = %i\n", getpid());

  return 0;
}
