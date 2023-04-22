#!/bin/env python
from zad3testy import runtests
from random import randint
from sys import setrecursionlimit
setrecursionlimit(100000)


def qsort(T, start, end):
    if end-start < 1:
        return
    elif end-start == 1:
        if T[0] < T[1]:
            T[0], T[1] = T[1], T[0]

    rnd = randint(start, end)
    T[rnd], T[start] = T[start], T[rnd]
    pivot = start
    i, j = start+1, end

    while i < j:
        while T[i] <= T[pivot] and i < j:
            i += 1
        while T[pivot] <= T[j] and i < j:
            j -= 1
        T[i], T[j] = T[j], T[i]

    if T[i] <= T[pivot]:
        T[i], T[pivot] = T[pivot], T[i]
    qsort(T, start, i-1)
    qsort(T, i, end)


def strong_string(T):
    csorted = [[] for _ in range(len(max(T, key=len)))]
    for i in T:
        if i[::-1] < i:
            i = i[::-1]
        csorted[len(i)-1].append(i)
    maxcount = 1

    for i in csorted:
        if len(i) <= maxcount:
            continue
        qsort(i, 0, len(i)-1)
        cmax = 1
        prev = i[0]

        for j in range(1, len(i)):
            if prev == i[j]:
                cmax += 1
            else:
                prev = i[j]
                if cmax > maxcount:
                    maxcount = cmax
                cmax = 1

        if cmax > maxcount:
            maxcount = cmax

    return maxcount


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
