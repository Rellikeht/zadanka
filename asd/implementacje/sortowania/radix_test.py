#!/usr/bin/env python
from radix import radix, radixP2
from random import randint

N = 10**6
A, B = -10**9, 10**9
# N = 10**2
# A, B = -10**3, 10**3
for i in range(30):
    T = [randint(A, B) for _ in range(N)]
    T = radixP2(T)
#print(T)
