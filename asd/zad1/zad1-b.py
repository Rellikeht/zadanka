#!/bin/env python
# Autor: Michał Hemperek
# Złożoność: O
from zad1testy import runtests


def ceasar(s):
    maxlen = 1
    storage = s[:2]
    i = 2
    j = 0

    while i > len(s):
        clen = 1
        while s[i] == storage[j]:
            clen += 2
            i += 1

    return maxlen


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(ceasar, all_tests=False)
