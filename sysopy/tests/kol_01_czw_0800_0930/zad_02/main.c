#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void sighandler(int sig, siginfo_t *info, void *ctx) {}

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
    // zdefiniuj obsluge SIGUSR1 w taki sposob aby proces
    // potomny wydrukowal
    // na konsole przekazana przez rodzica wraz
    // z sygnalem SIGUSR1 wartosc
    sigset_t mask = {0};
    err = sigfillset(&mask) | sigdelset(&mask, SIGUSR1);
    if (err != 0) {
      perror("mask");
      return 1;
    }
    action.sa_mask = mask;
    action.sa_flags = SA_SIGINFO;
    err = sigaction(SIGUSR1, &action, NULL);
    if (err != 0) {
      perror("sigaction()");
      return 1;
    }

  } else {
    // wyslij do procesu potomnego sygnal przekazany jako argv[2]
    // wraz z wartoscia przekazana jako argv[1]
    int sig = atoi(argv[2]);
    if (sig < 1) {
      return 1;
    }
    sigval_t val = {0};
    val.sival_int = atoi(argv[1]);
    if (sig == 0) {
      return 1;
    }
    err = sigqueue(child, sig, val);
  }

  return 0;
}
