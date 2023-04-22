#!/bin/env python
from zad3testy import runtests

# 1.92


def strong_string(T):
    csorted = [[] for _ in range(len(max(T, key=len)))]
    for i in T:
        csorted[len(i)-1].append(i)
    maxcount = 1

    for i in csorted:
        if len(i) <= maxcount:
            continue
        newg = 1
        groups = [(i[0], i[0][::-1])]
        lens = [1]

        for j in range(1, len(i)):
            cgroup = 0
            while cgroup < newg:
                if groups[cgroup][0] == i[j] or groups[cgroup][1] == i[j]:
                    lens[cgroup] += 1
                    break
                cgroup += 1

            else:
                groups.append((i[j], i[j][::-1]))
                lens.append(1)
                newg += 1

        for j in range(len(lens)):
            if lens[j] > maxcount:
                maxcount = lens[j]

    return maxcount


# # zmien all_tests na True zeby uruchomic wszystkie testy
runtests(strong_string, all_tests=True)
