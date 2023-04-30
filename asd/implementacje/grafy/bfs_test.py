#!/usr/bin/env python
from bfs import BFSVisit, shortestPath

G = [
        [1, 3, 5],  # 0
        [0, 2, 4],  # 1
        [0, 3],	    # 2
        [1, 4, 5],  # 3
        [2, 3, 5],  # 4
        [0, 2, 4],  # 5
    ]

print(BFSVisit(G, 0))
print(shortestPath(G, 1, 5))
