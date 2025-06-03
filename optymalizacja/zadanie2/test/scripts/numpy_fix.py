from numpy.linalg import inv
import numpy as np

N = int(input())

lns = []
for _ in range(N):
    ln = list(map(float, input().split()))
    lns.append(ln)
A = np.matrix(np.array(lns, dtype=np.double))

input()
# ln = [float(input()) for _ in range(N)]
ln = list(map(float, input().split()))
B = np.array(ln, dtype=np.double)

input()
# ln = [float(input()) for _ in range(N)]
ln = list(map(float, input().split()))
C = np.array(ln, dtype=np.double)

# print(A, B, C)
sol = inv(A).dot(B)
sol = np.array(sol)[0]

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
