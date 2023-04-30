from math import log2

# Poniżej miliona elementów quicksort może być lepszy

N = 16
# N = 1000 robi dużo lepszą robotę
# N = 100, może trochę więcej bije quicksorta
# N = 10000 już nie ma znaczenia, przynajminej
# przy danych do 10**9


# Zwraca listę, żeby nie przepisywać
# Ogólne, wolne z dzieleniem
def radix(T: list[int]) -> list[int]:
    copy = [0 for _ in range(len(T))]
    counts = [0 for _ in range(N)]

    ITERS = int(log2(max(max(T), -min(T)))/log2(N))+1
    for i in range(ITERS):
        for j in range(len(counts)):
            counts[j] = 0  # lepsze
        for j in T:
            counts[(j//(N**i)) % N] += 1
        for j in range(1, len(counts)):
            counts[j] += counts[j-1]

        for j in range(len(T)-1, -1, -1):
            ind = (T[j]//(N**i)) % N
            counts[ind] -= 1
            copy[counts[ind]] = T[j]
        T, copy = copy, T

    counts = [0, 0]
    for j in T:
        counts[0 if j < 0 else 1] += 1
    counts[1] += counts[0]
    for j in range(len(T)-1, -1, -1):
        ind = 0 if T[j] < 0 else 1
        counts[ind] -= 1
        copy[counts[ind]] = T[j]

    return copy


# 8 wystarczy
# stała nadal spora
M = 4
POW = 2**M


# Zwraca listę, żeby nie przepisywać
# głupia optymalizacja
def radixP2(T: list[int]) -> list[int]:
    copy = [0 for _ in range(len(T))]
    counts = [0 for _ in range(POW)]
    ITERS = int(log2(max(max(T), -min(T)))/M)+1

    for i in range(ITERS):
        for j in range(len(counts)):
            counts[j] = 0
        for j in T:
            counts[(j >> (i*M)) % POW] += 1
        for j in range(1, len(counts)):
            counts[j] += counts[j-1]

        for j in range(len(T)-1, -1, -1):
            ind = (T[j] >> (i*M)) % POW
            counts[ind] -= 1
            copy[counts[ind]] = T[j]
        T, copy = copy, T

    counts = [0, 0]
    for j in T:
        counts[0 if j < 0 else 1] += 1
    counts[1] += counts[0]
    for j in range(len(T)-1, -1, -1):
        ind = 0 if T[j] < 0 else 1
        counts[ind] -= 1
        copy[counts[ind]] = T[j]

    return copy
