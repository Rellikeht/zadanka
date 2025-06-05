#include <array>
#include <chrono>
#include <cmath>
#include <iostream>
#include <papi.h>
#include <stdexcept>
#include <vector>

using namespace std;
using namespace chrono;

/* PAPI macro helpers definitions */
#define NUM_EVENT 2
#define THRESHOLD 100000
#define ERROR_RETURN(retval)                                       \
  {                                                                \
    fprintf(                                                       \
        stderr,                                                    \
        "Error %d %s:line %d: \n",                                 \
        retval,                                                    \
        __FILE__,                                                  \
        __LINE__                                                   \
    );                                                             \
    quick_exit(retval);                                            \
  }

#define SOLVE(A, b) gaussianElimination((A).data(), (b).data(), size)

#define IDX(A, w, i, j) A[(i) * (w) + (j)]

void gaussianElimination(double *A, double *b, size_t n) {
    std::vector<size_t> colIndex(n);
    size_t *col_index = colIndex.data();
    for (size_t i = 0; i < n; ++i) {
        col_index[i] = i;
    }

    for (size_t k = 0; k < n - 1; ++k) {
        double maxVal = 0.0;
        size_t iMax = k, jMax = k;
        for (size_t i = k; i < n; ++i) {
            for (size_t j = k; j < n; ++j) {
                double aij = std::abs(IDX(A, n, i, j));
                if (aij > maxVal) {
                    maxVal = aij;
                    iMax = i;
                    jMax = j;
                }
            }
        }

        if (maxVal == 0.0) {
            throw std::runtime_error("Matrix is singular (zero pivot encountered).");
        }

        if (iMax != k) {
            for (size_t j = 0; j < n; ++j) {
                std::swap(IDX(A, n, k, j), IDX(A, n, iMax, j));
            }
            std::swap(b[k], b[iMax]);
        }

        if (jMax != k) {
            for (size_t i = 0; i < n; ++i) {
                std::swap(IDX(A, n, i, k), IDX(A, n, i, jMax));
            }
            std::swap(col_index[k], colIndex[jMax]);
        }

        double pivot = IDX(A, n, k, k);
        for (size_t i = k + 1; i < n; ++i) {
            double factor = IDX(A, n, i, k) / pivot;
            for (size_t j = k; j < n; ++j) {
                IDX(A, n, i, j) -= factor * IDX(A, n, k, j);
            }
            b[i] -= factor * b[k];
        }
    }

    if (IDX(A, n, n - 1, n - 1) == 0.0) {
        throw std::runtime_error("Matrix is singular (zero pivot encountered).");
    }

    std::vector<double> y(n, 0.0);
    for (int i = int(n) - 1; i >= 0; --i) {
        double sum = b[i];
        for (size_t j = i + 1; j < n; ++j) {
            sum -= IDX(A, n, i, j) * y[j];
        }
        y[i] = sum / IDX(A, n, i, i);
    }

    for (size_t i = 0; i < n; ++i) {
        b[col_index[i]] = y[i];
    }
}

int main(int argc, char **argv) {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cout.tie(nullptr);

  size_t size, i, j;
  cin >> size;
  vector<double> A;
  vector<double> b;

  A.resize(size*size);
  for (i = 0; i < size; i++) {
    for (j = 0; j < size; j++) {
      cin >> IDX(A, size, i, j);
    }
  }

  b.resize(size);
  for (i = 0; i < size; i++) {
    cin >> b[i];
  }

  if (argc < 2) {
    SOLVE(A, b);
    for (i = 0; i < size; ++i) {
      cout << b[i] << " ";
    }
    cout << "\n";
    return 0;
  }

  int retval = 0;
  const int choice = stoi(argv[1]);

  switch (choice) {
  case 0: {
    /* PAPI FLOPS variables */
    float real_time, proc_time, mflops;
    long long flpops;
    float ireal_time, iproc_time, imflops;
    long long iflpops;

    retval = PAPI_flops_rate(
        PAPI_FP_OPS, &ireal_time, &iproc_time, &iflpops, &imflops
    );
    if (retval < PAPI_OK) {
      printf("Could not initialise PAPI_flops \n");
      printf("Your platform may not support floating point "
             "operation event.\n");
      printf("retval: %d\n", retval);
      quick_exit(1);
    }

    SOLVE(A, b);
    retval = PAPI_flops_rate(
        PAPI_FP_OPS, &real_time, &proc_time, &flpops, &mflops
    );
    if (retval < PAPI_OK) {
      printf("retval: %d\n", retval);
      quick_exit(1);
    }

    printf("Real_time: %f\n", real_time);
    printf("Proc_time: %f\n", proc_time);
    printf("flpops: %lld\n", flpops);
    printf("MFLOPS: %f\n", mflops);
    break;
  }

  case 1: {
    /* PAPI counters variables */
    int EventSet = PAPI_NULL;
    /* must be initialized to PAPI_NULL before calling
     * PAPI_create_event*/
    array<int, NUM_EVENT> event_codes = {
        PAPI_TOT_INS, PAPI_TOT_CYC
    };
    array<char, PAPI_MAX_STR_LEN> errstring;
    array<long long, NUM_EVENT> values;

    retval = PAPI_library_init(PAPI_VER_CURRENT);
    if (retval != PAPI_VER_CURRENT) {
      fprintf(stderr, "Error: %s\n", errstring.data());
      quick_exit(1);
    }
    /* Creating event set */
    retval = PAPI_create_eventset(&EventSet);
    if (retval != PAPI_OK) {
      ERROR_RETURN(retval);
    }
    /* Add the array of events PAPI_TOT_INS and PAPI_TOT_CYC to the
     * eventset */
    retval =
        PAPI_add_events(EventSet, event_codes.data(), NUM_EVENT);
    if (retval != PAPI_OK) {
      ERROR_RETURN(retval);
    }
    /* Start counting */
    retval = PAPI_start(EventSet);
    if (retval != PAPI_OK) {
      ERROR_RETURN(retval);
    }

    SOLVE(A, b);
    retval = PAPI_stop(EventSet, values.data());
    if (retval != PAPI_OK) {
      ERROR_RETURN(retval);
    }
    printf("The total instructions executed: %lld\n", values[0]);
    printf("Total cycles: %lld\n", values[1]);
    break;
  }

  default:
    long long elapsed_time = 0;
    auto tmpA = A;
    auto tmpb = b;
    for (i = 0; i < (size_t)choice; i++) {
      auto start_time = high_resolution_clock::now();
      SOLVE(A, b);
      auto end_time = high_resolution_clock::now();
      elapsed_time +=
          duration_cast<microseconds>(end_time - start_time)
              .count();
      b = tmpb;
      A = tmpA;
    }
    elapsed_time /= choice;
    cout << "Time elapsed: " << elapsed_time << "μs\n";
    break;
  }

  return 0;
}
