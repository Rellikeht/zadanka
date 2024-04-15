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
      //  zamknij deskryptor do zapisu i wykonaj program sort na filename1
      //  w przypadku błędu zwróć 3

      err = close(fd[1]);
      if (err != 0) {
        perror("close()");
        return 3;
      }
      err = sprintf(command, "sort %s", filename1);
      if (err < 0) {
        perror("sprintf()");
        return 3;
      }
      err = system(command);
      if (err != 0) {
        if (errno == 0)
          fprintf(stderr, "system() returned code %i\n", err);
        else
          perror("system()");
        return 3;
      }

      //  koniec
    } else {
      close(fd[0]);
    }
  } else if (argc == 3) {
    char *filename1 = argv[1];
    char *filename2 = argv[2];
    int fd[2];
    //  otwórz plik filename2 z prawami dostępu rwxr--r--,
    //  jeśli plik istnieje otwórz go i usuń jego zawartość

    //  koniec
    pipe(fd);
    pid_t pid = fork();
    if (pid == 0) {
      //  zamknij deskryptor do zapisu,
      //  przekieruj deskryptor standardowego wyjścia na deskryptor pliku
      //  filename2 i zamknij plik, wykonaj program sort na filename1 w
      //  przypadku błędu zwróć 3.

      //  koniec
    } else {
      close(fd[0]);
    }
  } else
    printf("Wrong number of args! \n");

  return 0;
}
