#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char LOWERCASE = 32;

static inline void change_chars(string &input) {
  long long input_pos = 0, output_pos = 0;
  bool space = false, capital = false;

  while (input_pos < (long long)input.size()) {
    switch (input[input_pos]) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      if (!space) {
        input[output_pos] = ' ';
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
      input[output_pos] = ',';
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
    case '\{' ... '~':
      input[output_pos] = input[input_pos];
      space = false;
      if (capital) {
        input[output_pos] |= LOWERCASE;
        capital = false;
      }
      output_pos++;
      break;
    default:
      break;
    }
    input_pos++;
  }

  input.resize(output_pos);
}

static inline void deduplicate_words(string &input) {
  if (input.size() < 2) {
    return;
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
        cur_word++;
        while (cur_word <= input_pos) {
          output_pos++;
          input[output_pos] = input[cur_word];
          cur_word++;
        }
      } else {

        duplicate = true;
        while (cur_word < input_pos - 1) {
          if (input[prev_word] != input[cur_word]) {
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
            input[output_pos] = input[cur_word];
          }
        }
      }

      word_length = 0;
    } else {
      word_length++;
    }
    input_pos++;
  }

  input.resize(output_pos);
}

static inline void transform(string &input) {
  change_chars(input);
  deduplicate_words(input);
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
  /* cout << work_input << "\n"; */
  return 0;
}
