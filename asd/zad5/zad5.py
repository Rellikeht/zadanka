#!/usr/bin/env python
from zad5testy import runtests
from heapq import heappop, heappush
INF = float("inf")


def spacetravel(n, E, S, a, b):
    G = [[] for _ in range(n)]

    for i in S:
        for j in S:
            G[i].append((j, 0))

    for i, j, t in E:
        G[i].append((j, t))
        G[j].append((i, t))

    distance = [INF for _ in G]
    parent = [-1 for _ in G]
    q = []

    distance[a] = 0
    parent[a] = None
    heappush(q, (0, a))

    while len(q) > 0:
        cdist, cv = heappop(q)

        for vn, vdist in G[cv]:
            ndist = cdist + vdist
            if distance[vn] > ndist:
                distance[vn] = ndist
                parent[vn] = cv
                heappush(q, (ndist, vn))

    if distance[b] == INF:
        return None
    return distance[b]


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(spacetravel, all_tests=True)
