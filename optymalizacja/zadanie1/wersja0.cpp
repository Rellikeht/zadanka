#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char MIN_PRINT = 32;
const char MAX_PRINT = 126;
const char LOWERCASE = 32;

static inline void copy_word(
    string &buffer, long long &output_pos, long long &word_length
) {
  if (word_length == 0) {
    return;
  }
  const long long word_start = output_pos - 2 * word_length - 2;
  bool equal = true;

  if (word_start >= 0) {
    long long i = word_start, j = output_pos - word_length - 1;
    for (; i < word_start + word_length; i++) {
      if (buffer[i] != buffer[j]) {
        equal = false;
        break;
      }
      j++;
    }
    if (equal) {
      output_pos -= word_length + 1;
    }
  }
  word_length = 0;
}

static inline void remove_duplicates(string &input) {
  long long input_pos = 0, output_pos = 0, word_length = 0;
  bool space = false;

  while (input_pos < input.size()) {
    switch (input[input_pos]) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      copy_word(input, output_pos, word_length);
      if (!space) {
        input[output_pos] = ' ';
        space = true;
        output_pos++;
      }
      input_pos++;
      continue;

    case '.':
    case ',':
    case ':':
    case ';':
      input[output_pos] = ',';
      input_pos++;
      output_pos++;
      word_length++;
      space = false;
      continue;
    }

    if (input[input_pos] < MIN_PRINT ||
        input[input_pos] > MAX_PRINT) {
      input_pos++;
      continue;
    }
    space = false;
    word_length++;
    input[output_pos] = input[input_pos];
    if (input[input_pos] >= 'A' && input[input_pos] <= 'Z') {
      input[output_pos] |= LOWERCASE;
    }
    input_pos++;
    output_pos++;
  }

  input.resize(output_pos);
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
  remove_duplicates(work_input);

  for (int i = 0; i < RUNS; i++) {
    work_input = input;
    auto start_time = high_resolution_clock::now();
    remove_duplicates(work_input);
    auto end_time = high_resolution_clock::now();
    elapsed_time +=
        duration_cast<microseconds>(end_time - start_time).count();
  }
  elapsed_time /= RUNS;

  cout << "Time elapsed: " << elapsed_time << "μs\n";
  cout << work_input << "\n";
  return 0;
}
