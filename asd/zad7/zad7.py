from zad7testy import runtests


def maze(L):
    N = len(L)
    E = len(L)-1

    dtab = [[-1 if L[i][j] == '#' else 0 for i in range(N)]
            for j in range(N)]
    utab = [[-1 if L[i][j] == '#' else 0 for i in range(N)]
            for j in range(N)]

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
        utab[x][y] = v
        return v

    def down(x, y):
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
        dtab[x][y] = v
        return v

    dtab[E][E] = 1
    v = down(0, 0)
    if v == -1:
        return v
    return v-1


runtests(maze, all_tests=True)
