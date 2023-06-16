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
    amount = 0
    # TODO max value optimization ?

    for i in range(M):
        oil[i] = getOil(T, i, visited)

    def least(pos, touched, fuel):
        if pos >= M-1:
            if fuel < 0:
                return M
            return touched

        if fuel <= 0 and oil[pos] == 0:
            return M

        m1 = least(pos+1, touched, fuel-1);
        m2 = least(pos+1, touched+1, fuel+oil[pos]-1)
        return min(m1, m2)

    return least(0, 0, 0)


runtests(plan, all_tests=True)
