from numpy.linalg import solve
import numpy as np

N = int(input())
DTYPE = np.float64

lns = []
for _ in range(N):
    ln = list(map(float, input().split()))
    lns.append(ln)
A = np.matrix(np.array(lns, dtype=DTYPE))

input()
# ln = [float(input()) for _ in range(N)]
ln = list(map(float, input().split()))
B = np.array(ln, dtype=DTYPE)

input()
# ln = [float(input()) for _ in range(N)]
ln = list(map(float, input().split()))
C = np.array(ln, dtype=DTYPE)

# print(A, B, C)
sol = solve(A, B)
sol = np.array(sol)

# print(sol)
# print(C)
if not all(C == sol):
    print("Calculated solution:")
    for e in sol:
        print(e, end=" ")
    print()

    print("Proper solution:")
    for e in C:
        print(e, end=" ")
    print()

    exit(1)
