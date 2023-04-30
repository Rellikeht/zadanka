def merge(T1, T2):
    T = []
    i, j = 0, 0

    while i < len(T1) and j < len(T2):
        if T1[i] < T2[j]:
            T.append(T1[i])
            i += 1
        else:
            T.append(T2[j])
            j += 1

    while i < len(T1):
        T.append(T1[i])
        i += 1
    while j < len(T2):
        T.append(T2[j])
        j += 1

    return T


def mergesort(T):
    if len(T) < 2:
        return T

    T1 = mergesort(T[:len(T)//2])
    T2 = mergesort(T[len(T)//2:])
    T = []
    i, j = 0, 0

    while i < len(T1) and j < len(T2):
        if T1[i] < T2[j]:
            T.append(T1[i])
            i += 1
        else:
            T.append(T2[j])
            j += 1

    while i < len(T1):
        T.append(T1[i])
        i += 1
    while j < len(T2):
        T.append(T2[j])
        j += 1

    return T
