#include <errno.h>
#include <stdio.h>

#define doOrErr(code, op, args...)                                             \
  err = op;                                                                    \
  if (err) {                                                                   \
    fprintf(stderr, args);                                                     \
    return code;                                                               \
  }

#define transfer(amount)                                                       \
  fread(in, sizeof(char), amount, file);                                       \
  doOrErr(121, ferror(file), "Problem przy odczycie pliku %s: %i\n", fname,    \
          err);                                                                \
  for (i = 0; i < amount; i++)                                                 \
    out[i] = in[amount - i - 1];                                               \
  doOrErr(144, fwrite(out, sizeof(char), amount, stdout) != amount,            \
          "fwrite zapisało mniej bajtów niż miało: %i\n", errno);              \
  doOrErr(169, fflush(stdout), "Problem przy wypisywaniu: %i\n", errno);

int main(int argc, char *argv[]) {
  int err;
  const char *fname;
  FILE *file;

  doOrErr(1, argc < 2, "Należy podać nazwę pliku\n");
  fname = argv[1];
  file = fopen(fname, "r");
  doOrErr(2, ferror(file), "Problem przy odczycie pliku %s: %i\n", fname, err);

#ifdef BYTE_BY_BYTE
  doOrErr(2, fseek(file, -1, SEEK_END),
          "Problem z przesuwaniem wskaźnika: %i\n", errno);
  int c;

  do {
    c = fgetc(file);
    doOrErr(3, ferror(file), "Problem z odczytem pliku %s: %i\n", fname, err);
    putchar(c);
  } while (fseek(file, -2, SEEK_CUR) == 0);

#else
#define BSIZE 1024
  char in[BSIZE + 1] = {0};
  char out[BSIZE + 1] = {0};
  int i, amount;

  doOrErr(2, fseek(file, -1, SEEK_END),
          "Problem z przesuwaniem wskaźnika: %i\n", errno);

  while (ftell(file) >= BSIZE) {
    doOrErr(3, fseek(file, -BSIZE, SEEK_CUR),
            "Problem z przesuwaniem wskaźnika: %i\n", errno);
    transfer(BSIZE);
    doOrErr(4, fseek(file, -BSIZE, SEEK_CUR),
            "Problem z przesuwaniem wskaźnika: %i\n", errno);
  }

  amount = ftell(file) + 1;
  doOrErr(5, fseek(file, 0, SEEK_SET), "Problem z przesuwaniem wskaźnika: %i\n",
          errno);
  transfer(amount);

#endif

  fclose(file);
  return 0;
}
