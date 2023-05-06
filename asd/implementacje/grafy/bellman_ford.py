from heapq import heappop, heappush
INF = float("inf")


# Algorytm dla listy zawierającej pary [sąsiad, odległość od niego]
def shortestPath(G, start, end):
    distance = [INF for _ in G]
    parent = [-1 for _ in G]
    path = []

    def bellmanFord(G):
        q = []

        distance[start] = 0
        parent[start] = None
        heappush(q, (0, start))

        while len(q) > 0:
            cdist, cv = heappop(q)

            for vn, vdist in G[cv]:
                ndist = cdist + vdist
                if distance[vn] > ndist:
                    distance[vn] = ndist
                    parent[vn] = cv
                    if vn == end:
                        break
                    heappush(q, (ndist, vn))

    bellmanFord(G)
    v = end

    if distance[v] != INF:
        while v is not None:
            path.append(v)
            v = parent[v]
        path.reverse()

    return path, distance[end]
