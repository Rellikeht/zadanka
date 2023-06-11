from zad7testy import runtests


def maze(L):
    N = len(L)
    E = len(L)-1

    dtab = [[-1 if L[i][j] == '#' else 0 for i in range(N)] for j in range(N)]
    utab = [[-1 if L[i][j] == '#' else 0 for i in range(N)] for j in range(N)]

    def up(x, y):
        if utab[x][y] != 0:
            return utab[x][y]

        v = -1
        if y > 0:
            v = up(x, y-1)
        if x < E:
            v2 = down(x+1, y)
            if v2 > v:
                v = v2
            v2 = up(x+1, y)
            if v2 > v:
                v = v2

        if v > -1:
            v += 1
        return v

    def down(x, y):
        if x == E and y == E:
            return 0

        if dtab[x][y] != 0:
            return dtab[x][y]

        v = -1
        if y < E:
            v = down(x, y+1)
        if x < E:
            v2 = down(x+1, y)
            if v2 > v:
                v = v2
            v2 = up(x+1, y)
            if v2 > v:
                v = v2

        if v > -1:
            v += 1
        return v

    for i in range(E, -1, -1):
        for j in range(E, -1, -1):
            dtab[i][j] = down(i, j)
            utab[i][j] = up(i, j)

    return max(dtab[0][0], utab[0][0])


runtests(maze, all_tests=True)
