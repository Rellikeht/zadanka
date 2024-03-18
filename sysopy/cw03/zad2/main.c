#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <sys/stat.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err = 0;
  const char *name = NULL;
  DIR *dir = NULL;
  struct dirent *entry = NULL;
  struct stat s = {0};
  long long sum = 0;

  if (argc < 2)
    name = ".";
  else
    name = argv[1];

  dir = opendir(name);
  doOrErr(2, dir == NULL, "opendir się nie powiodło: %i\n", errno);
  do {
    entry = readdir(dir);
  } while (entry != NULL);
  doOrErr(3, errno != 0, "readdir się nie powiodło: %i\n", errno);

  printf("Sumaryczny rozmiar: %lli\n", sum);
  return 0;
}
