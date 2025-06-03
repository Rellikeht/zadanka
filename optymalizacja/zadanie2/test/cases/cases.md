1. Small Pivot Elements: Tests handling of very small diagonal
   elements that could cause numerical instability
2. Large Numbers: Uses large numbers that are close together,
   which can cause precision loss during subtraction
3. Hilbert Matrix: A classic ill-conditioned matrix where small
   errors in input lead to large errors in output
4. Mixed Scale Numbers: Combines very large and very small
   numbers, testing the algorithm's ability to handle different
   scales
5. Zero Diagonal: Requires row pivoting since it has zeros on the
   diagonal
6. Fractional Solutions: Results in non-integer solutions to test
   precision of final results
7. Integer Matrix: Simple integer coefficients but still tests
   the basic functionality
E. Nearly Singular Matrix: Contains rows that are almost linearly
   dependent, making the system very sensitive to numerical errors

