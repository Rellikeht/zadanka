from zad7testy import runtests


def maze_from_start(L):
    N = len(L)
    END = (N-1, N-1)
    MOVES = ((-1, 0), (1, 0), (0, 1))
    # visited = [[False for _ in i] for i in L]

    # def helper(L, pos, a):
    def helper(L, pos, last, a):
        if pos == END:
            return a

        mx = []
        for m in MOVES:
            next = (pos[0] + m[0], pos[1] + m[1])

            if next[0] <= END[0] and next[1] <= END[1] and \
                    next[0] >= 0 and \
                    next != last and \
                    L[next[0]][next[1]] != '#':
                # not visited[next[0]][next[1]] and \

                # visited[pos[0]][pos[1]] = True
                # mx.append(helper(L, next, a+1))
                # visited[pos[0]][pos[1]] = False
                mx.append(helper(L, next, pos, a+1))

        if len(mx) > 0:
            return max(mx)
        return 0

    return helper(L, (0, 0), (-1, -1), 0)


def maze_from_start_memo(L):
    N = len(L)
    END = (N-1, N-1)
    MOVES = ((-1, 0), (1, 0), (0, 1))
    score = [[0 for _ in i] for i in L]

    # def helper(L, pos, a):
    def helper(L, pos, last, a):
        if pos == END:
            return a

        mx = []
        for m in MOVES:
            next = (pos[0] + m[0], pos[1] + m[1])

            if next != last and \
                    next[0] <= END[0] and next[1] <= END[1] and \
                    next[0] >= 0 and \
                    score[next[0]][next[1]] <= a and \
                    L[next[0]][next[1]] != '#':

                score[pos[0]][pos[1]] = a
                mx.append(helper(L, next, pos, a+1))

        if len(mx) > 0:
            return max(mx)
        return 0

    return helper(L, (0, 0), (-1, -1), 0)


def maze_from_end(L):
    N = len(L)
    START = (0, 0)
    END = (N-1, N-1)
    MOVES = ((-1, 0), (1, 0), (0, -1))

    def helper(L, pos, last, a):
        if pos == START:
            return a

        mx = []
        for m in MOVES:
            next = (pos[0] + m[0], pos[1] + m[1])

            if next != last and \
                    next[0] <= END[0] and next[1] <= END[1] and \
                    next[0] >= START[0] and next[1] >= START[1] and \
                    L[next[0]][next[1]] != '#':

                mx.append(helper(L, next, pos, a+1))

        if len(mx) > 0:
            return max(mx)
        return 0

    return helper(L, END, (N, N), 0)


def maze_from_end_memo(L):
    N = len(L)
    START = (0, 0)
    END = (N-1, N-1)
    MOVES = ((-1, 0), (1, 0), (0, -1))
    score = [[0 for _ in i] for i in L]

    def helper(L, pos, last, a):
        if pos == START:
            return a

        mx = []
        for m in MOVES:
            next = (pos[0] + m[0], pos[1] + m[1])

            if next != last and \
                    next[0] <= END[0] and next[1] <= END[1] and \
                    next[0] >= START[0] and next[1] >= START[1] and \
                    score[next[0]][next[1]] <= a and \
                    L[next[0]][next[1]] != '#':

                score[pos[0]][pos[1]] = a
                mx.append(helper(L, next, pos, a+1))

        if len(mx) > 0:
            return max(mx)
        return 0

    return helper(L, END, (N, N), 0)


maze = maze_from_start_memo

# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(maze, all_tests=False)
