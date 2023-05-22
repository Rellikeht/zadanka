#!/usr/bin/env python
from zad6testy import runtests
from collections import deque

INF = float("inf")
STARTDIST = INF


def binworker(M):

    # /*
    #  G = U ∪ V ∪ {NIL}
    #  where U and V are the left and right sides of the bipartite graph and
    #  NIL is a special null vertex
    # */

    NIL = len(M)

    H = [[] for _ in M]
    for ms in range(len(M)):
        for m in M[ms]:
            H[m].append(ms)

    q = deque()
    mdist = [STARTDIST for _ in M] + [NIL]

    #  1 function Hopcroft–Karp is
    #  2     for each u in U do
    #  3         Pair_U[u] := NIL
    #  4     for each v in V do
    #  5         Pair_V[v] := NIL
    #  6     matching := 0

    mpair = [NIL for _ in M] + [NIL]
    hpair = [NIL for _ in M] + [NIL]
    matching = 0

    #  1 function BFS() is
    #  2     for each u in U do
    #  3         if Pair_U[u] = NIL then
    #  4             Dist[u] := 0
    #  5             Enqueue(Q, u)
    #  6         else
    #  7             Dist[u] := ∞
    #  8     Dist[NIL] := ∞
    #  9     while Empty(Q) = false do
    # 10         u := Dequeue(Q)
    # 11         if Dist[u] < Dist[NIL] then
    # 12             for each v in Adj[u] do
    # 13                 if Dist[Pair_V[v]] = ∞ then
    # 14                     Dist[Pair_V[v]] := Dist[u] + 1
    # 15                     Enqueue(Q, Pair_V[v])
    # 16     return Dist[NIL] ≠ ∞

    def BFS():
        for m in range(len(M)):
            if mpair[m] == NIL:
                mdist[m] = 0
                q.append(m)
            else:
                mdist[m] = INF

        mdist[NIL] = INF
        while len(q) > 0:

            m = q.popleft()
            if mdist[m] < mdist[NIL]:
                for h in M[m]:
                    if mdist[hpair[h]] == INF:
                        mdist[hpair[h]] = mdist[m] + 1
                        q.append(hpair[h])

        return mdist[NIL] != INF

    #  1 function DFS(u) is
    #  2     if u ≠ NIL then
    #  3         for each v in Adj[u] do
    #  4             if Dist[Pair_V[v]] = Dist[u] + 1 then
    #  5                 if DFS(Pair_V[v]) = true then
    #  6                     Pair_V[v] := u
    #  7                     Pair_U[u] := v
    #  8                     return true
    #  9         Dist[u] := ∞
    # 10         return false
    # 11     return true

    def DFS(m):
        if m != NIL:
            for h in M[m]:
                if mdist[hpair[h]] == mdist[m]+1:
                    if DFS(hpair[h]):
                        hpair[h] = m
                        mpair[m] = h
                        return True

            mdist[m] = INF
            return False
        return True

    #  7     while BFS() = true do
    #  8         for each u in U do
    #  9             if Pair_U[u] = NIL then
    # 10                 if DFS(u) = true then
    # 11                     matching := matching + 1
    # 12     return matching

    while BFS():
        for m in range(len(M)):
            if mpair[m] == NIL:
                if DFS(m):
                    matching += 1

    return matching


runtests(binworker, all_tests=True)
