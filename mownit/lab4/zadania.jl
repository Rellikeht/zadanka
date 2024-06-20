using CairoMakie
CairoMakie.activate!(type="svg")

xs = 0:0.001:1
f(x) = 1 + x^3

q1(x) = 9x / 10 + 4 / 5
q2(x) = 3x^2 / 2 - 3x / 5 + 21 / 20

fig = Figure(size=(1920, 1080))
plot(fig[1, 1], xs, f.(xs), color="#0000ff")
plot!(fig[1, 1], xs, q1.(xs), color="#00ff00")
save("wykres1.svg", fig)

fig = Figure(size=(1920, 1080))
plot(fig[1, 1], xs, f.(xs), color="#0000ff")
plot!(fig[1, 1], xs, q2.(xs), color="#00ff00")
save("wykres2.svg", fig)
