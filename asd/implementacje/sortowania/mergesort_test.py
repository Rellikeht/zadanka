#!/usr/bin/env python
from mergesort import mergesort
from random import randint

N = 10**6
A, B = -10**9, 10**9
# N = 20 # 10**2
# A, B = -10**3, 10**3
T = [randint(A, B) for _ in range(N)]
T = mergesort(T)
# print(T)
