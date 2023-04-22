#!/bin/env python
from quicksort import qsort, qsort_iter
from random import randint

N = 2*10**6
A, B = -10**9, 10**9
# N = 10**2
# A, B = -10**3, 10**3
#for i in range(30):
T = [randint(A, B) for _ in range(N)]
qsort(T, 0, len(T)-1)
#print(T)
