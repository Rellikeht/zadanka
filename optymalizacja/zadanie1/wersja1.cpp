#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char LOWERCASE = 32;

static inline string change_chars(string input) {
  long long input_pos = 0, output_pos = 0;
  bool space = false, capital = false;
  string result;
  result.resize(input.size());

  while (input_pos < (long long)input.size()) {
    switch (input[input_pos]) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      if (!space) {
        result[output_pos] = ' ';
        space = true;
        output_pos++;
      }
      break;

    case '.':
    case ',':
    case ':':
    case ';':
    case '!':
    case '?':
      result[output_pos] = ',';
      output_pos++;
      space = false;
      break;

    case 'A' ... 'Z':
      capital = true;
      // fallthrough
    case '"' ... '+':
    case '-':
    case '/':
    case '@':
    case '0' ... '9':
    case '<' ... '>':
    case 'a' ... 'z':
    case '[' ... '`':
    case '{' ... '~':
      result[output_pos] = input[input_pos];
      space = false;
      if (capital) {
        result[output_pos] |= LOWERCASE;
        capital = false;
      }
      output_pos++;
      break;
    default:
      break;
    }
    input_pos++;
  }

  result.resize(output_pos);
  return result;
}

static inline string deduplicate_words(string input) {
  string result = input;

  if (result.size() < 2) {
    return result;
  }

  long long input_pos = 0, output_pos = 0;
  long long word_length = 0, prev_word = 0, cur_word = 0;
  bool duplicate = false;

  while (input_pos < (long long)input.size()) {
    if (input[input_pos] == ' ') {
      input_pos++;
      break;
    }
    input_pos++;
    output_pos++;
  }

  while (input_pos < (long long)input.size()) {
    if (input[input_pos] == ' ') {
      prev_word = output_pos - word_length - 1;
      cur_word = input_pos - word_length - 1;

      if (prev_word < 0) {
        while (cur_word < input_pos) {
          output_pos++;
          result[output_pos] = input[cur_word];
          cur_word++;
        }
      } else {

        duplicate = true;
        while (cur_word < input_pos - 1) {
          if (result[prev_word] != input[cur_word]) {
            duplicate = false;
            break;
          }
          prev_word++;
          cur_word++;
        }
        if (!duplicate) {
          for (cur_word = input_pos - word_length;
               cur_word <= input_pos;
               cur_word++) {
            output_pos++;
            result[output_pos] = input[cur_word];
          }
        }
      }

      word_length = 0;
    } else {
      word_length++;
    }
    input_pos++;
  }

  result.resize(output_pos);
  return result;
}

static inline string transform(string input) {
  return deduplicate_words(change_chars(input));
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
  string output = transform(input);

  for (int i = 0; i < RUNS; i++) {
    auto start_time = high_resolution_clock::now();
    output = transform(input);
    auto end_time = high_resolution_clock::now();
    elapsed_time +=
        duration_cast<microseconds>(end_time - start_time).count();
  }
  elapsed_time /= RUNS;

  cout << "Time elapsed: " << elapsed_time << "μs\n";
  /* cout << output << "\n"; */
  return 0;
}
