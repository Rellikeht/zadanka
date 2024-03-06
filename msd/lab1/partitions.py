#!/usr/bin/env python
from sys import argv


n = 5
if len(argv) > 1:
    n = abs(int(argv[1]))

part = [n] + [0 for _ in range(0, n - 1)]

k = 1
print(k, part)
while part[0] > 1:
    p = k - 1
    while part[p] == 1:
        p -= 1

    part[p] -= 1
    s = k - p

    while s > 0:
        if s >= part[p]:
            part[p + 1] = part[p]
        else:
            part[p + 1] = s

        s -= part[p + 1]
        p += 1

    k = p + 1
    print(k, part)

# k = 1
# print(k, part)
# while part[0] > 1:
#     p = k - 1
#     while part[p] == 1:
#         p -= 1
#     part[p] -= 1
#     s = k - p
#     while s > 0:
#         if s >= part[p]:
#             part[p + 1] = part[p]
#         else:
#             part[p + 1] = s
#         s = s - part[p + 1]
#         p += 1
#     k = p + 1
#     print(k, part)

# def nextPart(parts: list[int]) -> bool:
#     n = len(parts)
#     if parts[n - 1] == 1:
#         return False

#     return True

# print(nums)
# while nextPart(nums):
#     print(nums)
