#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err, amount;
  doOrErr(1, argc < 2, "Należy podać ilość procesów\n");
  amount = atoi(argv[1]);
  doOrErr(2, amount == 0, "Należy podać liczbę > 0\n");

  // Tu koniec
  pid_t parent_pid = getpid();

  for (int i = 0; i < amount; i++) {
    pid_t child_pid;
    child_pid = fork();
    if (child_pid == 0) {
      printf("Parent: %d   Child: %d\n", (int)parent_pid, (int)getpid());
      return 1;
    } else if (child_pid < 0) {
      printf("Creation of child process was unsuccessful.\n");
    }
  }

  while (wait(0) != -1) {
  };
  printf("Total number of child processes: %d\n", amount);
  return 0;
}
