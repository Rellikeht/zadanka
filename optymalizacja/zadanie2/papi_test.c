#include <papi.h>
#include <stdio.h>
#include <stdlib.h>

#define handle_error(retval)                                       \
  {                                                                \
    fprintf(                                                       \
        stderr,                                                    \
        "Error %d %s:line %d: \n",                                 \
        retval,                                                    \
        __FILE__,                                                  \
        __LINE__                                                   \
    );                                                             \
    exit(retval);                                                  \
  }

int main() {
  PAPI_library_init(PAPI_VER_CURRENT);

  // int Events[2] = {PAPI_TOT_CYC, PAPI_TOT_INS};
  // int num_hwentrs = 0;

  /* Initialize the PAPI library and get the number of

  counters available */

  // if ((num_hwentrs = PAPI_num_hwctrs()) <= PAPI_OK)
  //   handle_error(1);

  printf("This system has %d available counters.", PAPI_num_cmp_hwctrs(0));

  // if (nun_hwentrs > 2)
  // num_hwentrs = 2;

  /* Start counting events */
  // if (PAPI_start counters (Events, num_hwentrs) L= BAPI_OK)
  // handle_error(1);

  return 0;
}
