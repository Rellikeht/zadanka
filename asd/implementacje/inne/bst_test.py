#!/usr/bin/env python
from bst import BST
from random import shuffle
from copy import deepcopy

t = BST(key=6, data=420)
L = [4, 3, 1, 8, 5, 2, 7, 0]

w = BST(key=20, data=None)
W = [17, 19, 5, 18, 30, 27, 35, 40, 50, 100, 37]

for n in L:
    t.insert(n, n)
    t.print()
    print()

t.print()
print()

for n in W:
    w.insert(n, n)

w.print()

print("=" * 60)
print()

RL = deepcopy(L)
shuffle(RL)

for n in RL:
    t.remove(n)

    print(n)
    t.print()
    print()

RW = deepcopy(W)
shuffle(RW)

for n in RW:
    w.remove(n)

    print(n)
    w.print()
    print()
