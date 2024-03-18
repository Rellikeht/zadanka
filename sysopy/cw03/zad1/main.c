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

  doOrErr(1, argc < 2, "Należy podać nazwę pliku\n");
  doOrErr(2, ferror(file), "Problem przy odczycie pliku %s: %i\n", fname, err);
  /* fflush !!! */

#ifdef BYTE_BY_BYTE
  /* sus */
  doOrErr(2, fseek(file, -1, SEEK_END),
          "Problem z przesuwaniem wskaźnika: %i\n", errno);
  int c;

  do {
    c = fgetc(file);
    doOrErr(3, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);
    putchar(c);
  } while (fseek(file, -2, SEEK_CUR) == 0);
  /* doOrErr(4, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);
   */

#else
#define BSIZE 1024
  char in[BSIZE + 1] = {0};
  char out[BSIZE + 1] = {0};
  int amount = 0, i;
  doOrErr(2, fseek(file, -BSIZE, SEEK_END),
          "Problem z przesuwaniem wskaźnika: %i\n", errno);

  do {
    /* TODO Errs */
    amount = fread(in, sizeof(char), BSIZE, file);
    /* doOrErr(3, ferror(file), "Problem z odczytem pliku %s: %i\n", fname,
     * err); */
    for (i = 0; i < amount; i++)
      out[i] = in[i];
    /*   out[amount - i] = in[i]; */
    fwrite(out, sizeof(char), amount, stdout);
    fseek(file, -2 * amount, SEEK_CUR);
  } while (ftell(file) >= BSIZE);
  /* doOrErr(4, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);
   */

#endif

  fclose(file);
  return 0;
}
