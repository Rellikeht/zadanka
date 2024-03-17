#include <errno.h>
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
  /* fpos_t *pos; */

  doOrErr(1, argc < 2, "Należy podać nazwę pliku\n");
  doOrErr(2, ferror(file), "Problem przy odczycie pliku %s: %i\n", fname, err);
  doOrErr(2, fseek(file, -1, SEEK_END),
          "Problem z przesuwaniem wskaźnika: %i\n", errno);

  /* fflush !!! */

#ifdef BYTE_BY_BYTE
  int c;
  do {
    c = fgetc(file);
    doOrErr(3, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);
    putchar(c);
  } while (fseek(file, -2, SEEK_CUR) == 0);
  doOrErr(4, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);

#else

#endif

  fclose(file);
  return 0;
}
