#!/usr/bin/env python
from bst import BST

L = [4, 3, 1, 8, 5, 2, 7, 0]
t = BST(key=6, data=420)

for n in L:
    t.insert(n, n)
    t.print()
    print()

#for n in L:
#    t.remove(n)

t.print()
