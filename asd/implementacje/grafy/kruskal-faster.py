from queue import deque

# TO RACZEJ NIE DZIAŁA


def hasCycle(G):
    visited = [False for _ in G]
    vs = deque()

    for u in range(len(G)):
        if len(G[u]) == 0 or visited[u]:
            continue
        # vs.append(u)
        vs.append((u, None))

        while len(vs) > 0:
            # v = vs.pop()
            v, p = vs.pop()
            if visited[v]:
                return True

            visited[v] = True
            for u in G[v]:
                # vs.append(u[0])
                if u[0] != p:
                    vs.append((u[0], v))

    return False


def kruskal(G):
    edges = []
    tree = [[] for _ in G]

    for v in range(len(G)):
        for u in range(len(G[v])):
            if v < G[v][u][0]:
                edges.append((G[v][u][1], v, G[v][u][0]))

    # Reverse for maximal weights
    edges.sort()

    for (w, v, u) in edges:
        tree[v].append((u, w))
        # tree[u].append((v, w))

        print(tree)
        if hasCycle(tree):
            print("cycle")
            tree[v].pop(-1)
            # tree[u].pop(-1)

    return tree

# [[], [], [(3, 1)], [(2, 1)], []]
# [[(1, 2)], [(0, 2)], [(3, 1)], [(2, 1)], []]
# [[(1, 2), (2, 2)], [(0, 2)], [(3, 1), (0, 2)], [(2, 1)], []]
# [[(1, 2), (2, 2), (4, 3)], [(0, 2)], [(3, 1), (0, 2)], [(2, 1)], [(0, 3)]]
# [[(1, 2), (2, 2), (4, 3)], [(0, 2), (4, 5)], [(3, 1), (0, 2)], [(2, 1)], [(0, 3), (1, 5)]]
# cycle
# [[(1, 2), (2, 2), (4, 3)], [(0, 2), (3, 6)], [(3, 1), (0, 2)], [(2, 1), (1, 6)], [(0, 3)]]
# cycle
# [[(1, 2), (2, 2), (4, 3)], [(0, 2)], [(3, 1), (0, 2)], [(2, 1)], [(0, 3)]]
