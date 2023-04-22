#!/bin/env python
from zad3testy import runtests


# 340 sekund...
# niektóre przekraczają czas


def strong_string(T):
    maxcount = 0
    for i in range(0, len(T)):
        c = 1
        for j in range(i+1, len(T)):
            if len(T[i]) == len(T[j]):
                c += T[i] == T[j] or T[i] == T[j][::-1]
        if c > maxcount:
            maxcount = c
    return maxcount


# # zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
