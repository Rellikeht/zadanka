from zad8testy import runtests
from functools import cache


def getOil(T, i, visited):
    if T[0][i] == 0:
        return 0

    N = len(T)
    M = len(T[0])
    oil = 0

    def fields(T, x, y):
        nonlocal oil
        if x < 0 or x >= N or y < 0 or y >= M or \
                visited[x][y] or T[x][y] == 0:
            return

        oil += T[x][y]
        visited[x][y] = True

        fields(T, x+1, y)
        fields(T, x-1, y)
        fields(T, x, y+1)
        fields(T, x, y-1)

    fields(T, 0, i)
    return oil


def plan(T):
    N = len(T)
    M = len(T[0])

    oil = [0 for _ in range(M)]
    visited = [[False for _ in range(M)] for _ in range(N)]

    oils = []

    for i in range(M):
        oil[i] = getOil(T, i, visited)
        if oil[i] != 0:
            oils.append(i)
    if oils[-1] != M-1:
        oils.append(M-1)

    tab = [[None for _ in range(M+1)] for _ in oils];

    def least(pos, fuel):

        if fuel < 0:
            return M

        if fuel >= M-1-oils[pos]:
            return 0

        if tab[pos][fuel] is not None:
            return tab[pos][fuel]

        npos = pos+1
        new = fuel-oils[npos]+oils[pos]
        v1 = least(npos, new)
        v2 = 1+least(npos, new+oil[oils[pos]])

        tab[pos][fuel] = v1 if v1 < v2 else v2
        return tab[pos][fuel]

    return least(0, 0)


runtests(plan, all_tests=True)
