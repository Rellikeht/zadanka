#!/bin/env python3

def minN(T):
    i = 0
    j = len(T)
    while j-i > 1:
        #while i < j:
        m = (i+j)//2
        if T[m] > m:
            j = m
        else:
            i = m

    if T[i] == i:
        return j
    return i

tab = [0,1,2,4,6,7]
#tab = [0,1,2,3,4,5,7]
print(minN(tab))
