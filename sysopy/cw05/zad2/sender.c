#include "errors.h"
#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

const char *my_name = "sender";
int err = 0, err2 = 0;
union sigval val = {0};
pid_t catcher_pid = 0;

void receiveConfirmation(int sig, siginfo_t *info, void *context) {
  if (catcher_pid == info->si_pid) {
    printf("%s: Odebrano SIGUSR1 od catchera\n", my_name);
  } else {
    eprint("Odebrano SIGUSR1 od innego procesu!\n");
    err2 = 1;
  }
}

int main(int argc, char *argv[]) {
  char *invalid = 0;
  long sig_type = 0;
  sigset_t usr1mask = {0};
  long pid_tmp = 0;
  struct sigaction receive = {0};
  errno = 0;

  err = sigfillset(&usr1mask);
  if (err != 0) {
    errp();
    return 1;
  }
  err = sigdelset(&usr1mask, SIGUSR1);
  if (err != 0) {
    errp();
    return 1;
  }
  err = sigdelset(&usr1mask, SIGINT);
  if (err != 0) {
    errp();
    return 1;
  }

  if (argc != 3) {
    eprint("Zła ilość argumentów\n");
    return 1;
  }

  pid_tmp = strtol(argv[1], &invalid, 10);
  if (pid_tmp == LONG_MIN || pid_tmp == LONG_MAX || *invalid != 0) {
    eprint("Błąd przy konwersji pidu catchera (argv[1])\n");
    return 1;
  } else if (pid_tmp < 2) {
    /* 2 bo 1 to init, więc catcher nie może mieć takiego pid */
    eprint("pid catchera (argv[1]) musi być większy od 1\n");
    return 1;
  }
  catcher_pid = pid_tmp;

  sig_type = strtol(argv[2], &invalid, 10);
  if (sig_type == LONG_MIN || sig_type == LONG_MAX || *invalid != 0) {
    eprint("Błąd przy konwersji trybu pracy (argv[2])\n");
    return 1;
  } else if (sig_type < 1 || sig_type > 3) {
    eprint("Niepoprawny tryb pracy: %li\n", sig_type);
    return 1;
  }
  val.sival_int = sig_type;

  receive.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = receiveConfirmation;
  err = sigfillset(&receive.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

  err = sigaction(SIGUSR1, &receive, NULL);
  if (err != 0) {
    errp();
    return 2;
  }

  err = kill(catcher_pid, SIGUSR1);
  if (err != 0) {
    errp();
    return 3;
  }

  err = sigsuspend(&usr1mask);
  if (err != -1 && errno != EINTR) {
    errp();
    return 4;
  }
  if (err2 != 0) {
    errp();
    return 5;
  }

  err = sigqueue(catcher_pid, SIGUSR1, val);
  if (err != 0) {
    errp();
    return 6;
  }

  return 0;
}
