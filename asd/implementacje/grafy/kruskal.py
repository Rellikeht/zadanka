from queue import deque


def hasCycle(G):
    visited = [False for _ in G]
    vs = deque()

    for u in range(len(G)):
        if len(G[u]) == 0 or visited[u]:
            continue
        vs.append((u, None))

        while len(vs) > 0:
            v, p = vs.pop()
            if visited[v]:
                return True

            visited[v] = True
            for u in G[v]:
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
        tree[u].append((v, w))

        if hasCycle(tree):
            tree[v].pop(-1)
            tree[u].pop(-1)

    return tree
