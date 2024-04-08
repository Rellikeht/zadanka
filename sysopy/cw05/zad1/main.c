#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define arg(opt) strcmp(argv[1], opt) == 0

void handler(int wtf) { printf("Dzielnie zwalczam SIGUSR1\n"); }

int main(int argc, char *argv[]) {
  int err = 0;
  void *previous = NULL;
  struct sigaction act;

  if (argc != 2) {
    fprintf(stderr, "Zła ilość argumentów\n");
    return 1;
  }

  if (arg("none")) {
  } else if (arg("ignore")) {
    previous = signal(SIGUSR1, SIG_IGN);
    if (previous == SIG_ERR) {
      fprintf(stderr, "Problem w signal(): %i\n", errno);
      return 2;
    }

  } else if (arg("handler")) {
    previous = signal(SIGUSR1, handler);
    if (previous == SIG_ERR) {
      fprintf(stderr, "Problem w signal(): %i\n", errno);
      return 2;
    }

  } else if (arg("mask")) {
    printf("Maskuję sygnał\n");
    act.sa_handler = handler;
    err = sigfillset(&act.sa_mask);
    if (err != 0) {
      fprintf(stderr, "Problem w sigfillset(): %i\n", errno);
      return 3;
    }
    act.sa_flags = 0;
    err = sigaction(SIGUSR1, &act, NULL);
    if (err != 0) {
      fprintf(stderr, "Problem w sigaction(): %i\n", errno);
      return 3;
    }

  } else {
    fprintf(stderr, "Zła nazwa opcji: %s\n", argv[1]);
    return 1;
  }
  raise(SIGUSR1);

  return 0;
}
