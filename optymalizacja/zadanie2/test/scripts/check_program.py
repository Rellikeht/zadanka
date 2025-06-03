from numpy.linalg import inv
import numpy as np
import subprocess as sp
from sys import argv, stdin
from os import path

if len(argv) < 2:
    print("Give exec to test")
    exit(1)
elif len(argv) == 2:
    file = stdin
else:
    file = open(argv[2])


def test() -> int:
    raw = [file.readline()]
    N = int(raw[0])

    lns = []
    for _ in range(N):
        line = file.readline()
        raw.append(line)
        ln = list(map(float, line.split()))
        lns.append(ln)
    A = np.matrix(np.array(lns, dtype=np.double))

    raw.append(file.readline())
    line = file.readline()
    raw.append(line)
    ln = list(map(float, line.split()))
    B = np.array(ln, dtype=np.double)

    file.readline()
    ln = list(map(float, file.readline().split()))
    C = np.array(ln, dtype=np.double)

    np_sol = inv(A).dot(B)
    np_sol = np.array(np_sol)[0]

    pipe = sp.Popen(
        [path.abspath(argv[1])],
        stdin=sp.PIPE,
        stdout=sp.PIPE,
        stderr=sp.STDOUT,
    )

    raw_input = "\n".join(raw) + "\n"
    raw_output = pipe.communicate(input=raw_input.encode("utf8"))[0].decode(
        "utf8"
    )
    sol = list(map(float, raw_output.split()))

    if all(np_sol == sol):
        print(f"{argv[1]} gives similar result to numpy!")
        return 0

    print(f"{argv[1]} output differs from numpy")
    print(f"{argv[1]} solution:")
    for e in sol:
        print(e, end=" ")
    print()

    print("Numpy solution:")
    for e in np_sol:
        print(e, end=" ")
    print()

    print("Proper solution:")
    for e in C:
        print(e, end=" ")
    print()

    return 1


code = test()
file.close()
exit(code)
