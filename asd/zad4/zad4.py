#!/usr/bin/env python
from zad4testy import runtests
from queue import Queue


#def shortest_path(G, s, t):
#    visited = [False for _ in range(len(G))]
#    vs = Queue()
#    cp = None
#    path = []
#
#    visited[s] = True
#    for v in G[s]:
#        visited[v] = True
#        vs.put([s, v])
#
#    while vs.qsize() > 0:
#        cp = vs.get()
#        last = cp[-1]
#
#        if last == t:
#            for i in range(1, len(cp)):
#                path.append([cp[i-1], cp[i]])
#            break
#
#        for v in G[last]:
#            if not visited[v]:
#                np = cp.copy()
#                visited[v] = True
#                np.append(v)
#                vs.put(np)
#
#    return path


def shortest_path(G, s, t):
    visited = [False for _ in range(len(G))]
    distance = [-1 for _ in range(len(G))]
    parent = [-1 for _ in range(len(G))]
    vs = Queue()

    visited[s] = True
    distance[s] = 0
    vs.put(s)

    while vs.qsize() > 0:
        cur = vs.get()
        for v in G[cur]:
            if not visited[v]:
                visited[v] = True
                distance[v] = distance[cur] + 1
                vs.put(v)

    v = t
    path =


def without_edge(G, e):
    without = G.copy()
    without[e[0]].remove(e[1])
    without[e[1]].remove(e[0])
    return without


def longer(G, s, t):
    slen = shortest_path(G, s, t)

    for e in slen:
        sp = shortest_path(without_edge(G, e), s, t)
        if len(sp) > len(slen) or len(sp) == 0:
            return e
    return None


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(longer, all_tests=True)
