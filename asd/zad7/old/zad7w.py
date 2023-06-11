from zad7testy import runtests


def maze(L):
    N = len(L)
    E = len(L)-1

    utab = [[-1 for _ in range(N)] for _ in range(N)]

    def up(x, y, a):
        if L[y][x] == '#':
            return -1

        if utab[x][y] >= a:
            return -1
        utab[x][y] = a

        v = -1
        if y > 0:
            v = up(x, y-1, a+1)
        if x < E:
            if x % 2 == 0:
                v = max(v, down(x+1, y, a+1), up(x+1, y, a+1))
            else:
                v = max(v, up(x+1, y, a+1), down(x+1, y, a+1))
        return v

    dtab = [[-1 for _ in range(N)] for _ in range(N)]

    def down(x, y, a):
        if x == E and y == E:
            return a

        if L[y][x] == '#':
            return -1

        if dtab[x][y] >= a:
            return -1
        dtab[x][y] = a

        v = -1
        if y < E:
            v = down(x, y+1, a+1)
        if x < E:
            if x % 2 == 0:
                v = max(v, down(x+1, y, a+1), up(x+1, y, a+1))
            else:
                v = max(v, up(x+1, y, a+1), down(x+1, y, a+1))
        return v

    return down(0, 0, 0)


runtests(maze, all_tests=True)
