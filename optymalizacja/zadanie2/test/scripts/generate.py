#!/usr/bin/env python3
import sys
import numpy as np


def generate_cyclic_tridiagonal(n):
    A = np.zeros((n, n))
    np.fill_diagonal(A, 4)

    for i in range(n - 1):
        A[i, i + 1] = -1
    for i in range(1, n):
        A[i, i - 1] = -1

    A[0, n - 1] = -1
    A[n - 1, 0] = -1
    return A


def solve_system(A, x_true):
    return np.dot(A, x_true)


def print_matrix_format(A, b, x):
    n = len(A)
    print(n)

    for i in range(n):
        row_str = " ".join(
            str(int(val)) if val == int(val) else str(val) for val in A[i]
        )
        print(row_str)

    print()
    print(
        " ".join(
            map(str, [int(val) if val == int(val) else val for val in b])
        )
    )

    print()
    print(
        " ".join(
            map(str, [int(val) if val == int(val) else val for val in x])
        )
    )


if len(sys.argv) > 1:
    n = int(sys.argv[1])
else:
    n = 100

A = generate_cyclic_tridiagonal(n)
x_true = np.ones(n)
b = solve_system(A, x_true)
print_matrix_format(A, b, x_true)
