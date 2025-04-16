#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char LOWERCASE = 32;

static inline void change_chars(string &input) {
  auto input_it = input.begin(), output_it = input.begin();
  const auto end = input.end();
  bool space = false, capital = false;

  while (input_it != end) {
    switch (*input_it) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
      if (!space) {
        *output_it = ' ';
        space = true;
        output_it++;
      }
      break;

    case '.':
    case ',':
    case ':':
    case ';':
    case '!':
    case '?':
      *output_it = ',';
      output_it++;
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
      *output_it = *input_it;
      space = false;
      if (capital) {
        *output_it |= LOWERCASE;
        capital = false;
      }
      output_it++;
      break;
    default:
      break;
    }
    input_it++;
  }

  input.resize(output_it - input.begin());
}

static inline void deduplicate_words(string &input) {
  if (input.size() < 2) {
    return;
  }
  auto input_it = input.begin(), output_it = input.begin();
  const auto begin = input.begin(), end = input.end();
  long long word_length = 0;
  auto cur_word = begin, prev_word = begin;
  bool duplicate = false;

  while (input_it != end) {
    if (*input_it == ' ') {
      input_it++;
      break;
    }
    input_it++;
    output_it++;
  }

  while (input_it != end) {
    if (*input_it == ' ') {
      prev_word = output_it - word_length - 1;
      cur_word = input_it - word_length - 1;

      if (cur_word < begin) {
        cur_word++;
        while (cur_word <= input_it) {
          output_it++;
          *output_it = *cur_word;
          cur_word++;
        }
      } else {

        duplicate = true;
        while (cur_word < input_it - 1) {
          if (*prev_word != *cur_word) {
            duplicate = false;
            break;
          }
          prev_word++;
          cur_word++;
        }
        if (!duplicate) {
          for (cur_word = input_it - word_length;
               cur_word <= input_it;
               cur_word++) {
            output_it++;
            *output_it = *cur_word;
          }
        }
      }

      word_length = 0;
    } else {
      word_length++;
    }
    input_it++;
  }

  input.resize(output_it - input.begin());
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
