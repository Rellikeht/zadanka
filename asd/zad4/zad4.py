#!/usr/bin/env python
from zad4testy import runtests
from queue import deque


def shortest_path(G, s, t):
    visited = [False for _ in range(len(G))]
    vs = deque()
    cp = None
    path = []

    visited[s] = True
    for v in G[s]:
        visited[v] = True
        vs.append([s, v])

    while len(vs) > 0:
        cp = vs.popleft()
        last = cp[-1]

        if last == t:
            for i in range(1, len(cp)):
                path.append([cp[i-1], cp[i]])
            break

        for v in G[last]:
            if not visited[v]:
                np = cp.copy()
                visited[v] = True
                np.append(v)
                vs.append(np)

    return path


#def shortest_path(G, s, t):
#    distance = [-1 for _ in range(len(G))]
#    parent = [-1 for _ in range(len(G))]
#    vs = deque()
#
#    distance[s] = 0
#    parent[s] = None
#    vs.append(s)
#
#    while len(vs) > 0:
#        cur = vs.popleft()
#        for v in G[cur]:
#            if distance[v] == -1:
#                distance[v] = distance[cur] + 1
#                parent[v] = cur
#                vs.append(v)
#
#    if distance[t] == -1:
#        return []
#
#    v = t
#    i = distance[t]
#    path = [[] for _ in range(i)]
#
#    while parent[v] is not None:
#        i -= 1
#        path[i] = [parent[v], v]
#        v = parent[v]
#
#    return path


def without_edge(G, e):
    without = G.copy()
    without[e[0]].remove(e[1])
    without[e[1]].remove(e[0])
    return without


def longer(G, s, t):
    slen = shortest_path(G, s, t)
    print(slen)

    for e in slen:
        sp = shortest_path(without_edge(G, e), s, t)
        if len(sp) > len(slen) or len(sp) == 0:
            return e
    return None


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(longer, all_tests=True)
