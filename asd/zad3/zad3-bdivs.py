#!/bin/env python
from zad3testy import runtests

# Minimalnie poniżej 3s


def strong_string(T):
    csorted = [[] for _ in range(len(max(T, key=len))+1)]
    for i in T:
        csorted[len(i)].append(i)
    maxcount = 1

    for i in csorted:
        if len(i) <= maxcount:
            continue
        newg = 1
        groups = [i[0]]
        lens = [1]

        for j in range(1, len(i)):
            cgroup = 0

            while cgroup < newg:
                if groups[cgroup] == i[j] or groups[cgroup] == i[j][::-1]:
                    lens[cgroup] += 1
                    break
                cgroup += 1
            else:
                groups.append(i[j])
                lens.append(1)
                newg += 1

        for j in lens:
            if j > maxcount:
                maxcount = j

    return maxcount


# # zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
