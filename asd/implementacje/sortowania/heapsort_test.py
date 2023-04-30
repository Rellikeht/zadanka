#!/usr/bin/env python
from heapsort import heapsort
from random import randint

N = 10**6
A, B = -10**9, 10**9
T = [randint(A, B) for _ in range(N)]
heapsort(T)
print(T)
