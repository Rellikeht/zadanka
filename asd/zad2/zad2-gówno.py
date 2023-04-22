# Autor: Michał Hemperek
# Złożoność: O(n^2)

from zad2testy import runtests


def snow(S):
    total = 0
    m = 1
    c = 0

    while m != 0:
        m = 0
        mi = 0

        for i in range(len(S)):
            if S[i] > m:
                mi = i
                m = S[i]

        if m > c:
            S[mi] = 0
            total += m - c
            c += 1
        else:
            m = 0

    return total


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(snow, all_tests=True)
