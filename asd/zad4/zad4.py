#!/usr/bin/env python
from zad4testy import runtests
from queue import Queue


def shortest_path(G, s, t):
    visited = [False for _ in range(len(G))]
    vs = Queue()
    cp = None

    visited[s] = True
    for v in G[s]:
        visited[v] = True
        vs.put([s, v])

    while True:
        cp = vs.get()
        last = cp[-1]

        if last == t:
            break

        for v in G[last]:
            if not visited[v]:
                np = cp.copy()
                visited[v] = True
                np.append(v)
                vs.put(np)

    path = []
    for i in range(1, len(cp)):
        path.append([cp[i-1], cp[i]])
    return path


def without_edge(G, e):
    without = G.copy()
    without[e[0]].remove(e[1])
    without[e[1]].remove(e[0])
    return without


def longer(G, s, t):
    slen = shortest_path(G, s, t)

    for e in slen:
        if len(shortest_path(without_edge(G, e), s, t)) > len(slen):
            return e
    return None


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(longer, all_tests=True)
