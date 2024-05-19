#include "bits/types/siginfo_t.h"
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void handler(int sig, siginfo_t *info, void *context) {}

int main(int argc, char *argv[]) {
  int err = 0;

  if (argc != 3) {
    printf("Not a suitable number of program parameters\n");
    return 1;
  }

  struct sigaction action;
  action.sa_sigaction = &sighandler;

  //..........

  int child = fork();
  if (child == 0) {
    // zablokuj wszystkie sygnaly za wyjatkiem SIGUSR1
    // zdefiniuj obsluge SIGUSR1 w taki sposob zeby proces potomny wydrukowal
    // na konsole przekazana przez rodzica wraz z sygnalem SIGUSR1 wartosc
  } else {
    long sig = 0, data = 0;
    char buf[4096] = {0}, *b = buf;
    sigval_t val;

    data = strtol(argv[1], &b, 10);
    val.sival_int = data;
    sig = strtol(argv[2], &b, 10);
    siginfo_t info = {0};
    err = sigqueue(child, sig, val)

    // wyslij do procesu potomnego sygnal przekazany jako argv[2]
    // wraz z wartoscia przekazana jako argv[1]
  }

  return 0;
}
