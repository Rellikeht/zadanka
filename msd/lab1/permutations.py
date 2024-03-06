#!/usr/bin/env python
from sys import argv


def nextPerm(n: list[int]) -> bool:
    i = len(n) - 2
    while i >= 0 and n[i] > n[i + 1]:
        i -= 1
    if i < 0:
        return False

    j = len(n) - 1
    while n[j] < n[i]:
        j -= 1

    n[i], n[j] = n[j], n[i]
    k = i + 1
    l = len(n) - 1

    while l > k:
        n[l], n[k] = n[k], n[l]
        k += 1
        l -= 1

    return True


n = 5
if len(argv) > 1:
    n = abs(int(argv[1]))

nums = [i for i in range(1, n + 1)]
print(nums)
while nextPerm(nums):
    print(nums)
