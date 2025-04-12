#include <chrono>
#include <iostream>
using namespace std;
using namespace chrono;

const char LOWERCASE = 32;

static inline void remove_duplicates(string &input) {

  size_t input_pos = 0, output_pos = 0;
  bool space = false, capital = false;

  while (input_pos < input.size()) {
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
      input[output_pos] = ',';
      output_pos++;
      space = false;
      break;
    case 'A' ... 'Z':
      capital = true;
    case '!' ... '+':
    case '-':
    case '/':
    case '0' ... '9':
    case '<' ... '@':
    case 'a' ... 'z':
    case '[' ... '`':
    case '{' ... '~':
      input[output_pos] = input[input_pos];
      space = false;
      if (capital) {
        input[output_pos] |= LOWERCASE;
        capital = false;
      }
      output_pos++;
      break;
    default:
      space = false;
    }
    input_pos++;
  }

  // TODO remove duplicates

  input.resize(output_pos);
}

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cout.tie(nullptr);

  string input, tmp;
  while (cin >> tmp) {
    input += tmp + "\n";
  }

  const int RUNS = 10;
  long long elapsed_time = 0;

  for (int i = 1; i < RUNS; i++) {
    auto start_time = high_resolution_clock::now();
    remove_duplicates(input);
    auto end_time = high_resolution_clock::now();
    elapsed_time +=
        duration_cast<microseconds>(end_time - start_time).count();
  }

  cout << "Time elapsed: " << elapsed_time << "μs\n";
  // cout << input << "\n";
  return 0;
}
