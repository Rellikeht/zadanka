#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char **argv) {
  int err = 0;
  char command[4096] = {0};
  errno = 0;

  if (argc == 2) {
    char *filename1 = argv[1];
    int fd[2];
    pipe(fd);
    pid_t pid = fork();
    if (pid == 0) {
      //  zamknij deskryptor do zapisu
      err = close(fd[1]);
      if (err != 0) {
        perror("close()");
        return 3;
      }

      //  i wykonaj program sort na filename1
      err = sprintf(command, "sort %s", filename1);
      if (err < 0) {
        perror("sprintf()");
        return 3;
      }
      err = 0;

      err = system(command);
      if (err != 0) {
        if (errno == 0)
          fprintf(stderr, "system() returned code %i\n", err);
        else
          perror("system()");
        return 3;
      }
      //  w przypadku błędu zwróć 3

      //  koniec
    } else {
      err = close(fd[0]);
      if (err != 0) {
        perror("close()");
        return 3;
      }
    }
  } else if (argc == 3) {
    char *filename1 = argv[1];
    char *filename2 = argv[2];
    int fd[2];
    //  otwórz plik filename2 z prawami dostępu rwxr--r--,
    //  jeśli plik istnieje otwórz go i usuń jego zawartość
    int f2 = open(filename2, O_CREAT | O_TRUNC,
                  S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IROTH);
    if (f2 < 0) {
      perror("open()");
      return 1;
    }

    //  koniec
    pipe(fd);
    pid_t pid = fork();
    if (pid == 0) {
      //  zamknij deskryptor do zapisu,
      err = close(fd[1]);
      if (err != 0) {
        perror("close()");
        return 1;
      }

      //  przekieruj deskryptor standardowego wyjścia na deskryptor pliku
      //  filename2
      int save = dup(f2);
      if (dup2(fileno(stdout), f2) == -1) {
        perror("cannot redirect stdout");
        return 3;
      }

      // i zamknij plik,
      err = close(f2);
      if (err != 0) {
        perror("close()");
        return 3;
      }

      //  wykonaj program sort na filename1 w
      err = sprintf(command, "sort %s", filename1);
      if (err < 0) {
        perror("sprintf()");
        return 3;
      }
      err = 0;

      err = system(command);
      if (err != 0) {
        if (errno == 0)
          fprintf(stderr, "system() returned code %i\n", err);
        else
          perror("system()");
        return 3;
      }

      if (fflush(stdout) != 0) {
        perror("fflush()");
        return 3;
      }

      if (close(save) != 0) {
        perror("fflush()");
        return 3;
      }

      //  w przypadku błędu zwróć 3
      //  koniec
    } else {
      close(fd[0]);
    }
  } else
    printf("Wrong number of args! \n");

  return 0;
}

/* if (access(filename2, F_OK) == 0) { */
/*   err = chmod(filename2, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP |
 * S_IROTH); */
/*   if (err != 0) { */
/*     perror("chmod()"); */
/*     return 1; */
/*   } */
/* } */

/* f2 = fopen(filename2, "w"); */
/* if (f2 == NULL) { */
/*   perror("fopen()"); */
/*   return 1; */
/* } */
