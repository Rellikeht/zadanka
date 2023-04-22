# Autor: Michał Hemperek
# Złożoność: O(n log n)

from zad2testy import runtests


def swap(S, i, j):
    S[i], S[j] = S[j], S[i]


def qsort(S, start, end):
    if end-start < 1:
        return
    elif end-start == 1:
        if S[0] < S[1]:
            swap(S, 0, 1)

    pivot = start
    i, j = start+1, end

    while i < j:
        while S[i] >= S[pivot] and i < j:
            i += 1
        while S[j] < S[pivot] and i < j:
            j -= 1
        swap(S, i, j)

    if S[pivot] < S[i]:
        swap(S, pivot, i)
    qsort(S, start, i-1)
    qsort(S, i, end)


def snow(S):
    qsort(S, 0, len(S)-1)
    total = 0
    for i in range(len(S)):
        if S[i] > i:
            total += S[i] - i
    return total


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(snow, all_tests=True)
