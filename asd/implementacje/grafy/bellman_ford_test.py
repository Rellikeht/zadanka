#!/usr/bin/env python
from bellman_ford import shortestPath  # , INF

G = [[(1, -4), (2, 5)],                      # 0
     [(0, 4), (2, 11), (3, 9), (4, 7)],     # 1
     [(0, 5), (1, -11), (4, 3)],             # 2
     [(1, 9), (4, 13), (5, -2)],             # 3
     [(1, 7), (2, 3), (3, 13), (5, 6)],     # 4
     [(3, -2), (4, 6)],                      # 5
     ]

for i in range(1, len(G)):
    print(shortestPath(G, 0, i))
