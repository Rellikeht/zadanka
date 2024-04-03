#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

/* #include<sys/stat.h> */
/* #include<sys/types.h> */

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

  doOrErr(1, argc != 2, "Zła ilość procesów\n");
  directory = opendir(argv[1]);

  if (directory == NULL) {
    printf("Zła ścieżka. Używam obecnej zamiast niej.\n");
    path = getcwd(buf, BUFSIZE);
    doOrErr(2, path == NULL, "getcwd() się nie udało, kod błędu: %i\n", errno);
    directory = opendir(path);
    doOrErr(3, directory == NULL,
            "Nie udało się otworzyć obecnej ścieżki, kod błędu: %i\n", errno);
  } else {
    strncpy(buf, argv[1], BUFSIZE);
  }
  printf("Directory path: %s\n", argv[1]);

  parent_pid = getpid();
  child_pid = fork();
  doOrErr(4, child_pid == -1, "Nie udało się wykonać fork(), kod błędu: %i\n",
          errno);

  if (child_pid > 0) {
    printf("Rodzic: \n");
    printf("pid rodzica: %i, pid dziecka: = %i\n", parent_pid, child_pid);
    child_exit_pid = waitpid(child_pid, &child_status, 0);
    doOrErr(5, child_exit_pid != child_pid,
            "Problem przy waitpid(), kod błędu: %i\n", errno);
    doOrErr(6, child_status != 0, "Proces potomny zakończył się z kodem %i\n",
            child_status);
    printf("Kod wyjściowy procesu potomnego: %d\n", child_status);
    printf("local rodzica to %i, global rodzica to %i\n", local, global);

  } else {
    printf("Proces potomny:\n");
    local++;
    global++;
    printf("pid procesu potomnego = %i, pid rodzica = %i\n", getpid(),
           parent_pid);
    printf("local procesu potomnego to %i, global procesu potomnego to %i\n",
           local, global);
    // Tu coś nie gra
    /* ls_status = execl("/usr/bin/ls", "ls", path, NULL); */
    ls_status = execl("/usr/bin/ls", path, NULL);
    return ls_status;
  }

  closedir(directory);
  return 0;
}
