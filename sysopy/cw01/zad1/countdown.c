#include <stdio.h>

int main(int argc, char** argv) {
    if (argc > 1) {
        printf("%s\n\n", argv[1]);
    }
    for (int i = 10; i >= 0; i--) printf("%i\n", i);
    return 0;
}
