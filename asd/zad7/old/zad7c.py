from zad7testy import runtests


def maze(L):
    E = len(L)-1
    mscore = 0

    def up(x, y, a):
        if y < 0:
            return -1
        if L[y][x] == '#':
            return -1
        if y+(E-x)*E+a < mscore:
            return -1

        return max(
                up(x, y-1, a+1),
                right(x+1, y, a+1)
                )

    def down(x, y, a):
        nonlocal mscore
        if x == E and y == E:
            if mscore < a:
                mscore = a
            return a

        if y > E:
            return -1
        if L[y][x] == '#':
            return -1
        if E-y+(E-x)*E+a < mscore:
            return -1

        return max(
                down(x, y+1, a+1),
                right(x+1, y, a+1)
                )

    def right(x, y, a):
        nonlocal mscore
        if x == E and y == E:
            if mscore < a:
                mscore = a
            return a

        if x > E:
            return -1
        if L[y][x] == '#':
            return -1

        return max(
                up(x, y-1, a+1),
                right(x+1, y, a+1),
                down(x, y+1, a+1)
                )

    return max(
            down(0, 0, 0),
            right(0, 0, 0)
            )


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(maze, all_tests=False)
