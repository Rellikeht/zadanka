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
    m = M
    tab = [[0 for _ in range(M)] for _ in range(M)]

    for i in range(M):
        oil[i] = getOil(T, i, visited)
        if oil[i] != 0:
            oils.append(i)
    if oils[-1] != M-1:
        oils.append(M-1)

    def least(pos, touched, fuel):
        nonlocal m
        if touched > m or fuel < 0:
            return M

        if pos == len(oils)-1:
            if touched < m:
                m = touched
            return touched

        nf = fuel-oils[pos+1]+oils[pos]
        m1 = least(pos+1, touched, nf);
        m2 = least(pos+1, touched+1, nf+oil[oils[pos]])
        #return min(m1, m2)

    least(0, 0, 0)
    return m


runtests(plan, all_tests=True)
