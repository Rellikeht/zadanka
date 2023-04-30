from random import randint


# Wolne, ale z własnym porównaniem
def qsort_func(T, start, end, comp=int.__lt__):
    if end <= start:
        return

    rnd = randint(start, end)
    T[rnd], T[start] = T[start], T[rnd]
    pivot = start
    i, j = start+1, end

    while i < j:
        while comp(T[i], T[pivot]) and i < j:
            i += 1
        while not comp(T[j], T[pivot]) and i < j:
            j -= 1
        T[i], T[j] = T[j], T[i]

    if not comp(T[pivot], T[i]):
        T[i], T[pivot] = T[pivot], T[i]
    if i-1-start > 0:
        qsort_func(T, start, i-1)
    if end-i > 0:
        qsort_func(T, i, end)


# Względnie szybka wersja
def qsort_rec(T, start, end):
    if end <= start:
        return

    rnd = randint(start, end)
    T[rnd], T[start] = T[start], T[rnd]
    pivot = start
    i, j = start+1, end

    while i < j:
        while T[i] <= T[pivot] and i < j:
            i += 1
        while T[j] > T[pivot] and i < j:
            j -= 1
        T[i], T[j] = T[j], T[i]

    if T[pivot] > T[i]:
        T[i], T[pivot] = T[pivot], T[i]

    # ify minimalnie skracają
    if i-1-start > 0:
        qsort_rec(T, start, i-1)
    if end-i > 0:
        qsort_rec(T, i, end)


# praktycznie w ogóle nie szybszy,
# trochę (ale też nie bardzo dużo) pamięci mniej
# proste benchmarki pokazują 9%
def qsort_iter(T, start, end):
    bounds = [(start, end)]

    while len(bounds) > 0:
        start, end = bounds.pop()
        if end <= start:
            continue

        rnd = randint(start, end)
        T[rnd], T[start] = T[start], T[rnd]
        pivot = start
        i, j = start+1, end

        X = T[pivot]
        while i < j:
            while T[i] <= X and i < j:
                i += 1
            while T[j] > X and i < j:
                j -= 1
            T[i], T[j] = T[j], T[i]
        if X > T[i]:
            T[i], T[pivot] = X, T[i]

        # ify minimalnie skracają
        if i-1-start > 0:
            bounds.append((start, i-1))
        if end-i > 0:
            bounds.append((i, end))


# podział z wykładu, podobno lepszy
def qsort_lect(T, start, end):
    bounds = [(start, end)]

    while len(bounds) > 0:
        start, end = bounds.pop()
        if end <= start:
            continue

        rnd = randint(start, end)
        T[rnd], T[start] = T[start], T[rnd]
        i, pivot = start-1, start
        X = T[pivot]

        for j in range(start, end):
            if T[j] <= X:
                i += 1
                T[i], T[j] = T[j], T[i]

        T[i], T[i+1] = T[i+1], T[i]
        i += 1

        if i-1-start > 0:
            bounds.append((start, i-1))
        if end-i+1 > 0:
            bounds.append((i+1, end))


qsort = qsort_lect
