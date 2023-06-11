from zad7testy import runtests


def maze(L):
    N = len(L)
    E = len(L)-1

    utab = [[-1 for _ in range(N)] for _ in range(N)]

    def up(x, y, a):
        if y < 0:
            return -1
        if L[y][x] == '#':
            return -1

        if utab[x][y] >= a:
            return -1
        utab[x][y] = a

        return max(
                up(x, y-1, a+1),
                right(x+1, y, a+1)
                )

    dtab = [[-1 for _ in range(N)] for _ in range(N)]

    def down(x, y, a):
        if x == E and y == E:
            return a
        if y > E:
            return -1
        if L[y][x] == '#':
            return -1

        if dtab[x][y] >= a:
            return -1
        dtab[x][y] = a

        return max(
                down(x, y+1, a+1),
                right(x+1, y, a+1)
                )

    def right(x, y, a):
        if x == E and y == E:
            return a
        if x > E:
            return -1
        if L[y][x] == '#':
            return -1

        return max(
                down(x, y+1, a+1),
                up(x, y-1, a+1),
                right(x+1, y, a+1),
                )

    return max(
            down(0, 0, 0),
            right(0, 0, 0)
            )


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(maze, all_tests=False)
