#!/usr/bin/env -S python
from kruskal import kruskal

G = [
        [(1, 2), (4, 3), (2, 2)],
        [(0, 2), (3, 6), (4, 5)],
        [(3, 1), (0, 2)],
        [(1, 6), (2, 1)],
        [(0, 3), (1, 5)]
    ]

print(kruskal(G))
