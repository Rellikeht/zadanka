#include "errors.h"
#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFSIZE 2048
const char *my_name = "catcher";
char command[BUFSIZE] = {0};
int err = 0, err2 = 0, requests = 0;
union sigval val = {0};
pid_t my_pid = 0;
bool running = true;

void resend(int sig, siginfo_t *info, void *context) {
  printf("%s: Odebrano SIGUSR1\n", my_name);
  err2 = kill(info->si_pid, SIGUSR1);
}

void work(int sig, siginfo_t *info, void *context) {
  /* printf("%s: Ciągle praca, brak zabawy...\n", my_name); */
  requests++;
  switch (info->si_value.sival_int) {
  case 1:
    for (int i = 0; i < 100; i++)
      printf("%s: %i\n", my_name, i);
    break;
  case 2:
    printf("%s: Otrzymał już %i żądań\n", my_name, requests);
    break;
  case 3:
    running = false;
    break;
  default:
    err2 = 1;
    break;
  }
}

int main(int argc, char *argv[]) {
  sigset_t usr1mask = {0};
  struct sigaction receive = {0}, action = {0};
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

  receive.sa_flags = SA_SIGINFO;
  receive.sa_sigaction = resend;
  receive.sa_mask = usr1mask;
  action.sa_flags = SA_SIGINFO;
  action.sa_sigaction = work;
  action.sa_mask = usr1mask;

  my_pid = getpid();
  printf("%s: PID = %i\n", my_name, my_pid);
  sprintf(command, "echo -n %i | xclip -i -selection clipboard", my_pid);
  system(command);

  while (running) {
    err = sigaction(SIGUSR1, &receive, NULL);
    if (err != 0) {
      errp();
      return 2;
    }

    err = sigsuspend(&usr1mask);
    if (err2 != 0) {
      errp();
      return 3;
    }
    if (err != -1 && errno != EINTR) {
      errp();
      return 4;
    }

    err = sigaction(SIGUSR1, &action, NULL);
    if (err != 0) {
      errp();
      return 5;
    }

    err = sigsuspend(&usr1mask);
    if (err2 != 0) {
      errp();
      return 6;
    }
    if (err != -1 && errno != EINTR) {
      errp();
      return 7;
    }
  }

  return 0;
}
