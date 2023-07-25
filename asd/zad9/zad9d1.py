from zad9testy import runtests
from sys import setrecursionlimit
setrecursionlimit(int(1E6))


def min_cost(O, C, T, L):
    LAST = len(O)-1
    MAX = 0
    for i in C:
        MAX += i

    # STOPS = list(zip(*sorted(zip(O, C))))
    STOPS = sorted(zip(O, C))
    START = T-STOPS[0][0]
    cur_min_cost = MAX

    without_memo = {}
    with_memo = {}

    def goWithoutAdditional(left, position, cur_cost):
        nonlocal cur_min_cost

        if cur_cost > cur_min_cost:
            return MAX
        if left < 0:
            return MAX
        if position > LAST:
            if cur_cost < cur_min_cost:
                cur_min_cost = cur_cost
            return 0

        state = (left, position)
        if state in without_memo:
            return without_memo[state]

        new_pos = position + 1
        if position == LAST:
            distance = L - STOPS[position][0]
        else:
            distance = STOPS[new_pos][0] - STOPS[position][0]
        cur_stop = STOPS[position][1]

        m1 = goWithoutAdditional(left-distance, new_pos, cur_cost)
        m2 = cur_stop + \
            goWithoutAdditional(T-distance, new_pos, cur_cost+cur_stop)

        result = m1 if m1 < m2 else m2
        without_memo[state] = result
        return result

    def goWithAdditional(left, position, cur_cost):
        nonlocal cur_min_cost

        if cur_cost > cur_min_cost:
            return MAX

        if position > LAST:
            if left < 0:
                return MAX
            if cur_cost < cur_min_cost:
                cur_min_cost = cur_cost
            return 0

        if left < 0:
            return goWithoutAdditional(T+left, position, cur_cost)

        state = (left, position)
        if state in with_memo:
            return with_memo[state]

        new_pos = position + 1
        if position == LAST:
            distance = L - STOPS[position][0]
        else:
            distance = STOPS[new_pos][0] - STOPS[position][0]
        cur_stop = STOPS[position][1]

        m1 = goWithAdditional(left-distance, new_pos, cur_cost)
        m2 = cur_stop + \
            goWithAdditional(T-distance, new_pos, cur_cost + cur_stop)
        result = m1 if m1 < m2 else m2

        without = goWithoutAdditional(T+left, position, cur_cost)
        result = without if without < result else result
        with_memo[state] = result
        return result

    return goWithAdditional(START, 0, 0)


runtests(min_cost, all_tests=True)
