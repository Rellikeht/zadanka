#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }
#define arg(opt) strcmp(argv[1], opt) == 0

int main(int argc, char *argv[]) {
  int err = 0;
  doOrErr(1, argc != 2, "Zła ilość argumentów\n");

  if (arg("none")) {
  } else if (arg("ignore")) {
    /* todo */
    signal(SIGUSR1, SIG_IGN);
  } else if (arg("handler")) {
    /* todo */
  } else if (arg("mask")) {
    /* todo */
  } else {
    doOrErr(1, true, "Zła nazwa opcji: %s\n", argv[1]);
  }

  return 0;
}
