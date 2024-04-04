#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

#define BUFSIZE 1024
int global;

int main(int argc, char *argv[]) {
  int local = 0, err;
  char buf[BUFSIZE + 1] = {0};
  DIR *directory;
  pid_t parent_pid, child_pid, child_exit_pid;
  int child_status, ls_status;
  char *path;

  doOrErr(1, argc != 2, "Zła ilość argumentów\n");
  directory = opendir(argv[1]);

  if (directory == NULL) {
    printf("Zła ścieżka. Używam obecnej zamiast niej.\n");
    path = getcwd(buf, BUFSIZE);
    doOrErr(2, path == NULL, "getcwd() się nie udało, kod błędu: %i\n", errno);
    directory = opendir(path);
    doOrErr(2, directory == NULL,
            "Nie udało się otworzyć obecnej ścieżki, kod błędu: %i\n", errno);
  } else {
    path = argv[1];
  }
  printf("Directory path: %s\n", argv[1]);

  parent_pid = getpid();
  child_pid = fork();
  doOrErr(3, child_pid == -1, "Nie udało się wykonać fork(), kod błędu: %i\n",
          errno);

  if (child_pid > 0) {
    printf("parent process\n");
    printf("parent pid = %i, child's pid = %i\n", parent_pid, child_pid);
    child_exit_pid = waitpid(child_pid, &child_status, 0);
    doOrErr(4, child_exit_pid != child_pid,
            "Problem przy waitpid(), kod błędu: %i\n", errno);
    doOrErr(4, child_status != 0,
            "Proces potomny zakończył się błędem, kod: %i\n", child_status);
    printf("Child exit code: %d\n", child_status);
    printf("parent's local %i, parent's global %i\n", local, global);

  } else {
    printf("child process\n");
    local++;
    global++;
    printf("child pid = %i, parent pid = %i\n", getpid(), parent_pid);
    printf("child's local = %i, child's global = %i\n", local, global);
    /* ls_status = execl("/usr/bin/ls", "ls", path, (char *)NULL); */
    ls_status = execl("/usr/bin/env", "env", "-S", "ls", path, (char *)NULL);
    return ls_status;
  }

  err = closedir(directory);
  doOrErr(5, err != 0, "closedir() się nie udało, kod błędu: %i\n", errno);
  return 0;
}
