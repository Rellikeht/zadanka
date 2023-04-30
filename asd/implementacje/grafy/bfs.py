from queue import Queue as Q


# Nie testowany kod
# Za prosty na testowanie :)

def BFSVisit(G, start):
    distance = [-1 for _ in G]
    parent = [-1 for _ in G]
    q = Q()

    distance[start] = 0
    parent[start] = None
    q.put(start)

    while not q.empty():
        cv = q.get()

        for v in G[cv]:
            if distance[v] == -1:
                distance[v] = distance[cv]+1
                parent[v] = cv
                q.put(v)

    return distance, parent


# Na liście sąsiedztwa
def shortestPath(G, start, end):
    distance = [-1 for _ in G]
    parent = [-1 for _ in G]
    path = []

    def BFSFind(G):
        q = Q()

        distance[start] = 0
        parent[start] = None
        q.put(start)

        while not q.empty():
            cv = q.get()

            for v in G[cv]:
                if distance[v] == -1:
                    distance[v] = distance[cv]+1
                    parent[v] = cv
                    if v == end:
                        break
                    q.put(v)

    BFSFind(G)
    v = end

    if distance[v] != -1:
        path = [0 for _ in range(distance[v]+1)]
        for i in range(distance[v], -1, -1):
            path[i] = v
            v = parent[v]

    return path
