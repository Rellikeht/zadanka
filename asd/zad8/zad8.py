from zad8testy import runtests


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

    tab = [[None for _ in T[0]] for _ in oils]
    m = M

    def least(pos, fuel, touched):
        nonlocal m

        if fuel < 0:
            return M

        if fuel >= M-1-oils[pos]:
            if touched < m:
                m = touched
            return 0

        if touched > m:
            return M

        if tab[pos][fuel] is not None:
            #mv = touched + tab[pos][fuel]
            #if mv < m:
            #    m = mv
            return tab[pos][fuel]

        npos = pos+1
        new = fuel-oils[npos]+oils[pos]
        v1 = least(npos, new, touched)
        v2 = 1+least(npos, new+oil[oils[pos]], touched+1)

        tab[pos][fuel] = (v1 if v1 < v2 else v2)
        mv = touched + tab[pos][fuel]
        if mv < m:
            m = mv
        return tab[pos][fuel]

    return least(0, 0, 0)


runtests(plan, all_tests=True)
