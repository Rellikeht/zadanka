/* #include <stdio.h> */

int collatz_conjecture(int input) {
    if (input%2 == 0) return input/2;
    return 3*input+1;
}

int test_collatz_convergence(int input, int max_iter) {
    int i = 0;
    int num = input;
    while (i < max_iter && num != 1) {
        num = collatz_conjecture(num);
        /* fprintf(stderr, "%d %d\n", i, num); */
        i++;
    }
    if (num == 1) return 1;
    return -1;
}
