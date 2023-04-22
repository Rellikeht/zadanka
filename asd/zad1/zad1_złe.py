#!/bin/env python
# Autor: Michał Hemperek
# Złożoność: 

from zad1testy import runtests


def ceasar(s):
    maxlen = 1
    i = 1
    while i <= len(s) - 1: #(1+maxlen)//2:
        j = 1
        clen = 1
        while i-j >= 0 and i+j < len(s):
            if s[i-j] != s[i+j]:
                if clen > maxlen:
                    maxlen = clen
                break
            j += 1
            clen += 2
        else:
            if clen > maxlen:
                maxlen = clen
        i += (clen+1)//2 if clen < 5 else clen//4
    return maxlen

print(ceasar(input()))

# zmien all_tests na True zeby uruchomic wszystkie testy
#runtests(ceasar, all_tests=True)
