#include "errors.c"
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

const char *my_name = "catcher";
int err = 0;
union sigval val = {0};
pid_t sender_pid = 0;
bool running = true;

void resend(int sig, siginfo_t *info, void *context) {
  err = sigqueue(info->si_pid, SIGUSR1, val);
  printf("%s: Odebrano SIGUSR1\n", my_name);
}

void work(int sig, siginfo_t *info, void *context) {
  if (info->si_value.sival_int == 3)
    running = false;
  printf("%s: Doing the hard work\n", my_name);
}

int main(int argc, char *argv[]) {
  /* void *previous = NULL; */
  sigset_t usr1mask = {0};
  struct sigaction receive = {0}, action = {0};
  //
  receive.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = resend;
  err = sigfillset(&receive.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

  action.sa_flags = SA_SIGINFO;
  action.sa_sigaction = work;
  err = sigfillset(&action.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

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

  while (running) {
    err = sigaction(SIGUSR1, &receive, NULL);
    if (err != 0) {
      errp();
      return 2;
    }
    err = pause();
    if (err != 0) {
      errp();
      return 2;
    }

    err = sigaction(SIGUSR1, &action, NULL);
    if (err != 0) {
      errp();
      return 3;
    }
    err = pause();
    if (err != 0) {
      errp();
      return 3;
    }
  }

  return 0;
}
