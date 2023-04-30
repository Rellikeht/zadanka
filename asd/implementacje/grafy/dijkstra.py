# from queue import PriorityQueue as PQ
from heapq import heappop, heappush
INF = float("inf")


def dijkstra(G, start):
    q = []
    distance = [INF for _ in G]
    parent = [-1 for _ in G]

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
                heappush(q, (ndist, vn))

    return distance, parent


# Algorytm dla listy zawierającej pary [sąsiad, odległość od niego]
def shortestPath(G, start, end):
    distance = [INF for _ in G]
    parent = [-1 for _ in G]
    path = []

    def dijkstra(G):
        # q = PQ()
        q = []

        distance[start] = 0
        parent[start] = None
        # q.put((0, start))
        heappush(q, (0, start))

        # while not q.empty():
        while len(q) > 0:
            # cdist, cv = q.get()
            cdist, cv = heappop(q)

            for vn, vdist in G[cv]:
                ndist = cdist + vdist
                if distance[vn] > ndist:
                    distance[vn] = ndist
                    parent[vn] = cv
                    if vn == end:
                        break
                    # q.put((ndist, vn))
                    heappush(q, (ndist, vn))

    dijkstra(G)
    v = end

    if distance[v] != INF:
        while v is not None:
            path.append(v)
            v = parent[v]
        path.reverse()

    return path, distance[end]
