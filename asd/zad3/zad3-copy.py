#!/bin/env python
from zad3testy import runtests

# 38 sekund, chujnia


def strong_string(T):
    maxcount = 1

    while len(T) != 0:
        sl = len(T[0])
        cur = [T[0]]
        rest = []

        for i in T[1:]:
            if len(i) == sl:
                cur.append(i)
            else:
                rest.append(i)

        if len(cur) > maxcount:
            for i in range(len(cur)):
                c = 1
                for j in range(i+1, len(cur)):
                    if len(cur[i]) == len(cur[j]):
                        c += cur[i] == cur[j] or cur[i] == cur[j][::-1]
                if c > maxcount:
                    maxcount = c

        T = rest

    return maxcount


# # zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
