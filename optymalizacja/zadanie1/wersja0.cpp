#include <iostream>
using namespace std;

const char MIN_PRINT = 32;
const char MAX_PRINT = 126;
const char LOWERCASE = 32;

static inline void copy_word(
    string &buffer,
    size_t &output_pos,
    size_t &word_length,
    size_t &space_between
) {
  if (word_length == 0) {
    return;
  }

  // Version with duplicates separated by whitespace
  if (space_between == 0) {
    word_length = 0;
    return;
  }

  const long long word_start =
      output_pos - space_between - 2 * word_length;
  bool equal = true;

  if (word_start >= 0) {
    size_t i = word_start, j = output_pos - word_length;
    for (; i < word_start + word_length; i++) {
      if (buffer[i] != buffer[j]) {
        equal = false;
        break;
      }
      j++;
    }
    if (equal) {
      output_pos -= word_length + space_between;
    }
  }
  space_between = 0;
  word_length = 0;
}

int main() {
  string input, tmp;
  while (cin >> tmp) {
    input += tmp + "\n";
  }

  size_t input_pos = 0, output_pos = 0, word_length = 0,
         space_between = 0;
  bool space = false;

  while (input_pos < input.size()) {
    switch (input[input_pos]) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      copy_word(input, output_pos, word_length, space_between);
      if (!space) {
        input[output_pos] = ' ';
        space = true;
        output_pos++;
        space_between++;
      }
      input_pos++;
      continue;
    case '.':
    case ',':
    case ':':
    case ';':
      copy_word(input, output_pos, word_length, space_between);
      input[output_pos] = ',';
      input_pos++;
      output_pos++;
      // Version with duplicates separated by whitespace or
      // punctuation
      // space_between++;
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

  cerr << input_pos << ' ' << output_pos << "\n";
  input.resize(output_pos);
  cout << input << "\n";
  return 0;
}
