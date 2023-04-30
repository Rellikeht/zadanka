#!/usr/bin/env python
from dijkstra import shortestPath, dijkstra  # , INF

G = [[(1, 4), (2, 5)],                      # 0
     [(0, 4), (2, 11), (3, 9), (4, 7)],     # 1
     [(0, 5), (1, 11), (4, 3)],             # 2
     [(1, 9), (4, 13), (5, 2)],             # 3
     [(1, 7), (2, 3), (3, 13), (5, 6)],     # 4
     [(3, 2), (4, 6)],                      # 5
     ]


for i in range(1, len(G)):
    print(shortestPath(G, 0, i))

print()
G = [[(1, 2)], [(0, 1)], [], [(3, 3)]]
print(dijkstra(G, 1))
print(dijkstra(G, 2))

for i in range(1, len(G)):
    print(shortestPath(G, 0, i))
