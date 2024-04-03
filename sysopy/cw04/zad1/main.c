#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

/* #include <sys/stat.h> */
/* #include <sys/types.h> */

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err, amount, i;
  pid_t parent_pid, child_pid;
  doOrErr(1, argc < 2, "Należy podać ilość procesów\n");
  amount = atoi(argv[1]);
  doOrErr(2, amount == 0, "Należy podać liczbę > 0\n");

  parent_pid = getpid();
  for (i = 0; i < amount; i++) {
    child_pid = fork();
    doOrErr(3, child_pid == -1, "Nie udało się wykonać fork(), errno: %i\n",
            errno);
    if (child_pid == 0) {
      printf("rodzic: %i , dziecko: %i\n", (int)parent_pid, (int)getpid());
      return 0;
    }
  }

  while (wait(0) != -1) {
  };
  printf("Całkowita ilość procesów potomnych: %i\n", amount);
  return 0;
}
