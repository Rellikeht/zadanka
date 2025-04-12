#include <iostream>
using namespace std;

const char LOWERCASE = 32;

int main() {
  string input, tmp;
  while (cin >> tmp) {
    input += tmp + "\n";
  }

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

  cerr << input_pos << ' ' << output_pos << "\n";
  input.resize(output_pos);
  cout << input << "\n";
  return 0;
}
