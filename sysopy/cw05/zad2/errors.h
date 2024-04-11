#include <stdio.h>

#define eprintf(args...) fprintf(stderr, args)

#define eprint(args...)                                                        \
  fprintf(stderr, "%s: ", my_name);                                            \
  eprintf(args)

#define errp()                                                                 \
  fprintf(stderr, "%s: ", my_name);                                            \
  perror("")
