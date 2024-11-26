from matplotlib import pyplot as plt


def getData(file):
    data = []
    with open(file, "r") as f:
        data = list(
            map(lambda s: list(map(int, s[:-1].split(" "))), f.readlines())
        )
    return data


fair_gets = getData("app/get_times_fair.txt")
notfair_gets = getData("app/get_times_notfair.txt")
fair_puts = getData("app/put_times_fair.txt")
notfair_puts = getData("app/put_times_notfair.txt")

f, ax = plt.subplots(2, 2, figsize=(20, 20))
color = "#06f"

ax[0, 0].plot(fair_gets, color=color)
ax[0, 1].plot(notfair_gets, color=color)
ax[1, 0].plot(fair_puts, color=color)
ax[1, 1].plot(notfair_puts, color=color)

ax[0, 0].set_title("Fair version get times")
ax[0, 1].set_title("Not fair version get times")
ax[1, 0].set_title("Fair version put times")
ax[1, 1].set_title("Not fair version put times")

f.savefig("plots/plot.png")

# f, ax = plt.subplots(1, 2, figsize=(20, 8))

# ax[0].plot(fair_gets, linestyle="dotted")
# ax[1].plot(notfair_gets, linestyle="dotted", color="#f00")
# ax[0].plot(fair_puts, linestyle="dotted")
# ax[1].plot(notfair_puts, linestyle="dotted", alpha=0.5, color="#0f0")

# ax[0].set_title("Fair version get times")
# ax[1].set_title("Not fair version get times")
# ax[0].set_title("Fair version put times")
# ax[1].set_title("Not fair version put times")
