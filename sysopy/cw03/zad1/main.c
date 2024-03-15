#include <stdio.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

int main(int argc, char *argv[]) {
  int err;

  char *fname = argv[1];
  FILE *file = fopen(fname, "r");
  fpos_t *pos;

  doOrErr(1, argc < 2, "Należy podać nazwę pliku\n");
  doOrErr(2, ferror(file), "Error reading file %s: %i\n", fname, err);
  /* doOrErr(2, fseek(file, 0, SEEK_END), "Error seeking: %i\n", err); */

  // fflush !!!

  /* #ifdef BYTE_BY_BYTE */
  /* doOrErr(3, fgetpos(file, pos), "Error getting pos: %i\n", err); */
  /* while ((*pos) != SEEK_SET) { */
  /* while ((*pos) != SEEK_END) { */
  /* doOrErr(3, fgetpos(file, pos), "Error getting pos: %i\n", err); */
  /* } */

  int c;
  while (!feof(file)) {
    c = fgetc(file);
    doOrErr(2, ferror(file), "Error reading file %s: %i\n", fname, err);
    putchar(c);
    /* doOrErr(4, ferror(stdout), "Error reading file %s: %i\n", fname, err); */
  }

  /* #else */
  // Dla wersji z blokami może być lepiej użyć open/close/seek
  // są niskopoziomowe, lepiej nie
  /* #endif */

  fclose(file);
  return 0;
}
