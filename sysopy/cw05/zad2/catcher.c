#include "errors.c"
#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFSIZE 2048
const char *my_name = "catcher";
char command[BUFSIZE] = {0};
int err = 0, err2 = 0;
union sigval val = {0};
pid_t sender_pid = 0, my_pid = 0;
bool running = true;

void resend(int sig, siginfo_t *info, void *context) {
  printf("%s: Odebrano SIGUSR1\n", my_name);
  err2 = kill(info->si_pid, SIGUSR1);
  printf("%s: Wysłano SIGUSR1\n", my_name);
}

void work(int sig, siginfo_t *info, void *context) {
  printf("%s: Ciągle praca, brak zabawy...\n", my_name);
  switch (info->si_value.sival_int) {
  case 1:
    break;
  case 2:
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
  /* receive.sa_mask = usr1mask; */
  err = sigemptyset(&receive.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

  action.sa_flags = SA_SIGINFO;
  action.sa_sigaction = work;
  /* action.sa_mask = usr1mask; */
  err = sigemptyset(&action.sa_mask);
  if (err != 0) {
    errp();
    return 1;
  }

  my_pid = getpid();
  printf("%s: PID = %i\n", my_name, my_pid);
  sprintf(command, "echo -n %i | xclip -i -selection clipboard", my_pid);
  system(command);

  /* while (running) { */
  err = sigaction(SIGUSR1, &receive, NULL);
  if (err != 0) {
    errp();
    return 2;
  }
  printf("%s: receive\n", my_name);

  err = sigsuspend(&usr1mask);
  if (err2 != 0) {
    errp();
    return 3;
  }
  if (err != -1 && errno != EINTR) {
    errp();
    return 4;
  }
  printf("%s: suspend\n", my_name);

  err = sigaction(SIGUSR1, &action, NULL);
  if (err != 0) {
    errp();
    return 5;
  }

  err = usleep(10000);
  if (err != 0) {
    errp();
    return 5;
  }
  printf("%s: action\n", my_name);

  err = sigsuspend(&usr1mask);
  if (err2 != 0) {
    errp();
    return 6;
  }
  if (err != -1 && errno != EINTR) {
    errp();
    return 7;
  }
  printf("%s: suspend 2\n", my_name);
  /* } */

  return 0;
}
