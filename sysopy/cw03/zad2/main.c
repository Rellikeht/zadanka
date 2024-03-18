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

int main() {
  int err = 0;
  DIR *dir = NULL;
  struct dirent *entry = NULL;
  struct stat s = {0};
  long long sum = 0;

  dir = opendir(".");
  doOrErr(2, dir == NULL, "opendir się nie powiodło: %i\n", errno);
  entry = readdir(dir);
  entry = readdir(dir);

  while ((entry = readdir(dir)) != NULL) {
    doOrErr(3, stat(entry->d_name, &s), "stat się nie powiodło: %i\n", errno);
    if (!S_ISDIR(s.st_mode)) {
      printf("%s: %li\n", entry->d_name, s.st_size);
      sum += s.st_size;
    }
  }

  doOrErr(4, errno != 0, "readdir się nie powiodło: %i\n", errno);
  printf("Sumaryczny rozmiar: %lli\n", sum);
  return 0;
}
