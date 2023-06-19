from zad8testy import runtests
from heapq import heappush, heappop


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

    elems = []
    MAX = M*N
    pos = 1
    fuel = oil[0]
    touched = 1

    while pos != len(oils):
        fuel = fuel+oils[pos-1]-oils[pos]

        if fuel < 0:
            fuel += MAX - heappop(elems)
            touched += 1

        heappush(elems, MAX - oil[oils[pos]])
        pos += 1

    while fuel < 0:
        fuel += MAX - heappop(elems)
        touched += 1

    return touched


runtests(plan, all_tests=True)
