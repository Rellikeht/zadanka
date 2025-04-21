#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char LOWERCASE = 32;
const char MIN_PRINT = 32;
const char MAX_PRINT = 126;

static inline void copy_word(
    /* string &buffer, long long &output_pos, long long &word_length
     */
    char *buffer,
    char *output_it,
    long long &word_length
) {
  if (word_length == 0) {
    return;
  }
  /* long long output_pos = buffer - output_it; */
  /* const long long word_start = output_pos - 2 * word_length - 2;
   */
  bool equal = true;
  char *word_start = buffer + word_length;

  /* if (word_start >= 0) { */
  if (word_start <= output_it) {
    /*   long long i = word_start, j = output_pos - word_length - 1;
     */
    /*   for (; i < word_start + word_length; i++) { */
    /*     if (buffer[i] != buffer[j]) { */
    /*       equal = false; */
    /*       break; */
    /*     } */
    /*     j++; */
    /*   } */
    if (equal) {
      output_it -= word_length + 1;
    }
  }
  word_length = 0;
}

static inline void transform(string &input) {
  auto input_it = input.data(), output_it = input_it;
  long long word_length = 0;
  auto *const begin = input.data();
  auto *const end = input.end().base();
  bool space = false;

  while (input_it < end) {
    switch (*input_it) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      /* copy_word(input, output_pos, word_length); */
      copy_word(begin, output_it, word_length);
      if (!space) {
        *output_it = ' ';
        space = true;
        output_it++;
      }
      input_it++;
      continue;

    case '.':
    case ',':
    case ':':
    case ';':
      *output_it = ',';
      input_it++;
      output_it++;
      word_length++;
      space = false;
      continue;
    }

    if (*input_it < MIN_PRINT || *input_it > MAX_PRINT) {
      input_it++;
      continue;
    }
    space = false;
    word_length++;
    *output_it = *input_it;
    if (*input_it >= 'A' && *input_it <= 'Z') {
      *output_it |= LOWERCASE;
    }
    input_it++;
    output_it++;
  }

  input.resize(output_it - begin);
}

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cout.tie(nullptr);

  string input, tmp;
  while (getline(cin, tmp)) {
    input += tmp + "\n";
  }

  const int RUNS = 10;
  long long elapsed_time = 0;
  string work_input = input;
  transform(work_input);

  for (int i = 0; i < RUNS; i++) {
    work_input = input;
    auto start_time = high_resolution_clock::now();
    transform(work_input);
    auto end_time = high_resolution_clock::now();
    elapsed_time +=
        duration_cast<microseconds>(end_time - start_time).count();
  }
  elapsed_time /= RUNS;

  cout << "Time elapsed: " << elapsed_time << "μs\n";
  cout << work_input << "\n";
  return 0;
}
