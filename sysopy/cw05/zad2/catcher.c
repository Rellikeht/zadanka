#include "errors.c"
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

const char *my_name = "catcher";
int err = 0;
union sigval val = {0};
pid_t sender_pid = 0;

void resend(int sig, siginfo_t *info, void *context) {
  err = 0;
  err = sigqueue(sender_pid, SIGUSR1, val);
}

void work(int sig, siginfo_t *info, void *context) {}

int main(int argc, char *argv[]) {
  void *previous = NULL;
  sigset_t usr1mask = {0};
  struct sigaction receive = {0}, action = {0};
  receive.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = resend;

  action.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = work;

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

  printf("%s: PID = %i\n", my_name, getpid());
  while (true) {
    err = sigaction(SIGUSR1, &receive, NULL);
    /* TODO ???? */
    if (err != 0) {
      errp();
      return 2;
    }
  }

  return 0;
}
