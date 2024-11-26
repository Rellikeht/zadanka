from matplotlib import pyplot as plt
from math import log10

fair_data = []
with open("fair.txt", "r") as f:
    fair_data = list(
        map(lambda s: list(map(int, s[:-1].split(" "))), f.readlines())
    )

notfair_data = []
with open("notfair.txt", "r") as f:
    notfair_data = list(
        map(lambda s: list(map(int, s[:-1].split(" "))), f.readlines())
    )


def prepare(l):
    e = [[], [], [], []]
    for n in l:
        e[0].append(log10(n[0]))
        e[1].append(log10(n[1]))
        e[2].append(log10(n[2]))
        e[3].append(log10(n[3]))

    return (e[0], e[1], e[2]), (e[0], e[1], e[3])


fair = prepare(fair_data)
notfair = prepare(notfair_data)

# f, ax = plt.subplots(2, 2, figsize=(18, 18))
f = plt.figure(figsize=(18, 18))

# ax[0, 0].projection = "3d"
# ax[0, 0].bar3d(*fair[0])
ax0 = f.add_subplot(121, projection="3d")
ax0.bar3d(fair[0][0], fair[0][1], 0, 1, 1, fair[0][2])

f.savefig("plot.png")
