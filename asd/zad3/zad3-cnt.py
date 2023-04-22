#!/bin/env python
from zad3testy import runtests

# 30 jebanych sekund


def strong_string(T):
    csorted = [[] for _ in range(len(max(T, key=len))+1)]
    for i in T:
        csorted[len(i)].append(i)
    maxcount = 1

    for i in range(len(csorted)):
        if len(csorted[i]) <= maxcount:
            continue
        for j in range(len(csorted[i])):
            c = 1
            for k in range(j+1, len(csorted[i])):
                c += csorted[i][j] == csorted[i][k] or \
                        csorted[i][j] == csorted[i][k][::-1]
            if maxcount < c:
                maxcount = c

    return maxcount


# # zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
