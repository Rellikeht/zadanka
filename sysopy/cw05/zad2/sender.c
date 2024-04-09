#include "errors.c"
#include <limits.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

const char *my_name = "sender";
int err = 0;
union sigval val = {0};
long catcher_pid = 0;

void receiveConfirmation(int sig, siginfo_t *info, void *context) {
  if (catcher_pid == info->si_pid) {
    printf("%s: Odebrano SIGUSR1 od catchera\n", my_name);
  } else {
    eprint("Odebrano SIGUSR1 od innego procesu!\n");
    err = 1;
  }
}

int main(int argc, char *argv[]) {
  char *invalid = 0;
  long sig_type = 0;
  sigset_t usr1mask = {0};
  struct sigaction receive = {0};

  err = sigemptyset(&usr1mask);
  if (err != 0) {
    errp();
    return 1;
  }
  err = sigaddset(&usr1mask, SIGUSR1);
  if (err != 0) {
    errp();
    return 1;
  }
  if (argc != 3) {
    eprint("Zła ilość argumentów\n");
    return 1;
  }

  catcher_pid = strtol(argv[1], &invalid, 10);
  if (catcher_pid == LONG_MIN || catcher_pid == LONG_MAX || *invalid != 0) {
    eprint("Błąd przy konwersji pidu catchera (argv[1])\n");
    return 1;
  } else if (catcher_pid < 2) {
    /* 2 bo 1 to init, więc catcher nie może mieć takiego pid */
    eprint("pid catchera (argv[1]) musi być większy od 1\n");
    return 1;
  }

  sig_type = strtol(argv[2], &invalid, 10);
  if (sig_type == LONG_MIN || sig_type == LONG_MAX || *invalid != 0) {
    eprint("Błąd przy konwersji trybu pracy (argv[2])\n");
    return 1;
  } else if (sig_type < 1 || sig_type > 3) {
    eprint("Niepoprawny tryb pracy: %li\n", sig_type);
    return 1;
  }

  receive.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = receiveConfirmation;
  err = sigfillset(&receive.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

  err = kill(catcher_pid, SIGUSR1);
  if (err != 0) {
    errp();
    return 2;
  }

  err = sigsuspend(&usr1mask);
  if (err != 0) {
    errp();
    return 3;
  }

  val.sival_int = sig_type;
  err = sigqueue(catcher_pid, SIGUSR1, val);
  if (err != 0) {
    errp();
    return 4;
  }

  return 0;
}
