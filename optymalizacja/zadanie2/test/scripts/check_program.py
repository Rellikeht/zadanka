from numpy.linalg import inv
import subprocess as sp
from sys import argv, stdin
from os import path

if len(argv) < 2:
    print("Give exec to test")
    exit(1)
elif len(argv) == 2:
    FNAME = "stdin"
    file = stdin
else:
    FNAME = argv[2]
    file = open(argv[2])


def test() -> int:
    raw = [file.readline()]
    N = int(raw[0])
    for _ in range(N):
        raw.append(file.readline())

    file.readline()
    raw.append(file.readline())
    file.readline()
    C = list(map(float, file.readline().split()))

    print(f"Testing {FNAME}")
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

    if all(C[i] == sol[i] for i in range(N)):
        print(f"{argv[1]} gives correct result!")
        return 0

    print(f"{argv[1]} output differs from correct result")
    print("Program solution:")
    for e in sol:
        print(e, end=" ")
    print()

    print("Correct solution:")
    for e in C:
        print(e, end=" ")
    print()

    return 1


code = test()
file.close()
exit(code)
