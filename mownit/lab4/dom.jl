### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ cb90eab9-6a3d-47c6-9d57-b5aedfb758f6
begin
	using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using Dates
    using LinearAlgebra
    using CairoMakie
    CairoMakie.activate!(type="svg")
	
    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
    ###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)
    """
end

# ╔═╡ ede459c9-0efa-4da7-985c-d38461ea4d81
begin
    const c1 = "#ff6600"
    const c2 = "#0000a8d8"
    const c3 = "#ff0000"
    const lw = 4
    const ms = 24
    @htl """
    <style>
    pluto-cell {
        display: flex;
        flex-direction: column;
    }
    pluto-cell pluto-output {
        order: 1;
    }
    pluto-cell pluto-runarea {
        bottom: -17px;
    }
    </style>
    """
end

# ╔═╡ bbd404d4-f425-11ee-0b05-5f39b4928ccd
md"""
## Zadanie 1
"""

# ╔═╡ 6730d502-ad31-4f1a-b9c0-a76dc576bebb
# Funkcja zwracająca współczynniki wielomianu aproksymującego
function coeffs(xs::Vector{Float64}, ys::Vector{Float64})::Vector{Float64}
    # m oznacza liczbę punktów
    m = length(xs)
    # S jak w notatkach
    S(k) = sum(xs .^ k)
    # T jak w notatkach
    T(k) = sum((xs .^ k) .* ys)
    # Współczynniki S po lewej stronie równań
    A = vcat((i -> [S(i) S(i + 1) S(i + 2)]).(0:2)...)
    # T po prawej stronie równań
    B = T.(0:2)
    # Rozwiązanie
    return A \ B
end

# ╔═╡ f4ff3e62-d8c0-4a74-b467-5e766a7732e2
md"""
##### Przykład dla $sin(x)$:
"""

# ╔═╡ b6a9aaa2-49b1-46f2-bbc1-da44c48d2d7b
begin
    # Funkcja wagowa
    const w(x) = 1
    # Funkcja pomocnicza do wygenerowania punktów
    const f1(x) = sin(x)
    # Punkty do aproksymacji
    const xs = pi * (0:0.05:1)
    const ys = f1.(xs)
    # Współczynniki wielomianu aproksymującego
    const c = coeffs(Vector(xs), ys)
    # Funkcja aproksymująca
    function approx(x::Float64)::Float64
        sum((i -> c[i+1] * x^i).(0:2))
    end

    # Zakres wykresu
    const r1 = -pi/2:0.01:3pi/2
    # Wykres
    p1 = Figure(size=(1920, 1080))
    ax1 = Axis(p1[1, 1])
    lines!(p1[1, 1], r1, f1.(r1), color=c1, label="sin(x)", linewidth=lw)
    scatter!(p1[1, 1], xs, ys, color=c3, label="punkty użyte do aproksymacji", markersize=ms)
    lines!(p1[1, 1], r1, approx.(r1), color=c2, label="funkcja aproksymująca", linewidth=4, linestyle=:dash)
    axislegend(ax1, labelsize=40, position=:rb)
    p1
end

# ╔═╡ 7ac78172-b519-4ff4-a13f-e9e6cc3374d4


# ╔═╡ 9403533a-78e7-4fda-bf1d-c96048a6bd14
md"""
## Zadanie 2
"""

# ╔═╡ ea103a1d-8fd2-4dc9-bb1d-e23c3ee29de5
begin
    # Zadana funkcja
    function f(x::Float64)::Float64
        1 - x^2
    end

    # Zadane punkty
    const xi = (i -> i / 2 - 1).(0:4)
    # Wartość funkcji w tych punktach
    const yi = f.(xi)

    # Wypisanie
    for i in eachindex(xi)
        println("x$(i): $(xi[i]),\tf(x$(i)): $(yi[i])")
    end
end


# ╔═╡ c5801846-c091-48ea-baa1-af7c4776f41c
md"""
**Wielomiany Grama stopnia $3$:**

$P_{0,4} (x) = 1$
$P_{1,4} (x) = −x$
$P_{2,4} (x) = 2x^2 − 1$
$P_{3,4} (x) = -\frac{20}{3}x^3 + \frac{17}{3}x$
Wielomiany te są ortogonalne, więc

$a_n = \frac{\sum_{i=0}^{n} P_{n,4}(x_i)y_i}{\sum_{i=0}^{n} P_{n,4}^2(x_i)}$
$a_0 = \frac{1}{2}$
$a_1 = 0$
$a_2 = -\frac{1}{2}$
$a_3 = 0$
Po podstawieniu:

$F (x) = 0.5 · 1 − 0.5(2x^2 − 1) = −x^2 + 1$
Czyli wielomian aproksymujący jest równoważny funkcji
"""

# ╔═╡ db32f2e7-e7bf-4308-94f7-7248034d209c
begin
    const r2 = min(xi...)-0.5:0.01:max(xi...)+0.5
    p2 = Figure(size=(1920, 1080))
    ax2 = Axis(p2[1, 1])
    lines!(p2[1, 1], r2, f.(r2), color=c1, label="f(x)", linewidth=lw)
    scatter!(p2[1, 1], xi, yi, color=c3, label="xi", markersize=ms)
    lines!(p2[1, 1], r2, f.(r2), color=c2, label="F(x)", linewidth=lw, linestyle=:dash)
    axislegend(ax2, labelsize=50)
    p2
end

# ╔═╡ 6eb45e7d-2bcc-4066-9753-7ba9fa5d780f


# ╔═╡ abeefd5d-a53c-4251-8769-ba13fa6ce76d
md"""
## Zadanie 3
"""

# ╔═╡ ed7a28c6-ebe2-4070-aef4-86bc7b4e3eac
md"""
Funkcja $|sin~x|$ spełnia warunki Dirichleta na podanym przedziale.
Ponieważ funkcja jest parzysta, można ją rozwinąć w szereg cosinusów:

$
a_n = \frac{1}{\pi} \int_{-\pi}^{\pi} |sin~x| ~cos(nx) ~dx
= \frac{−2(cos(πn) + 1)}{π(n^2 − 1)} 
= \frac{−2((−1)^n + 1)}{π(n^2 − 1)}$


dla $n > 1$ oraz $a_1 = 0$, \
dla pozostałych nieparzystych $n$: $a_n = 0$,  bo $(−1)^n + 1 = 0$ \
Dla parzystych $n$ wzór można skrócić do: $a_n = \frac{-4}{π(n^2 − 1)}$
"""

# ╔═╡ a422efe0-2f98-468d-976f-d8530718135e
begin
    # Początek zakresu
    const down = -pi
    # Koniec zakresu
    const up = pi
    # |sin x|
    function g(x::Float64)::Float64
        abs(sin(x))
    end

    # Wzór na poszczególne a
    function a(n::UInt)::Float64
        -4 / (pi * (n * n - 1))
    end

    const a_0 = 2 / pi
    # Lista n, dla których będą liczone a
    const ns = UInt.(2:2:8)
    # Lista a_n
    const a_n = a.(ns)

    # Funkcja aproksymująca
    function S(x::Float64)::Float64
        a_0 + sum(a_n .* cos.(ns * x))
    end

    # Wykres
    const r3 = down:0.01:up
    p3 = Figure(size=(1920, 720))
    ax3 = Axis(p3[1, 1])
    lines!(p3[1, 1], r3, g.(r3), color=c1, label="|sin x|", linewidth=lw)
    lines!(p3[1, 1], r3, S.(r3), color=c2, label="S(x)", linewidth=lw, linestyle=:dash)
    axislegend(ax3, labelsize=50)
    p3
end

# ╔═╡ f6f88f95-eaf9-45d0-bc5f-65af43486f55


# ╔═╡ 3117853b-dc47-4057-ae0c-28f572ad4b88
md""" \

### Bibliografia:
- http://home.agh.edu.pl/~funika/mownit/lab4/aproksymacja.pdf
- http://home.agh.edu.pl/~funika/mownit/lab4/wielomianygrama.pdf
- https://pl.wikipedia.org/wiki/Szereg_Fouriera
- wykład
"""

# ╔═╡ Cell order:
# ╟─cb90eab9-6a3d-47c6-9d57-b5aedfb758f6
# ╟─ede459c9-0efa-4da7-985c-d38461ea4d81
# ╟─bbd404d4-f425-11ee-0b05-5f39b4928ccd
# ╠═6730d502-ad31-4f1a-b9c0-a76dc576bebb
# ╟─f4ff3e62-d8c0-4a74-b467-5e766a7732e2
# ╟─b6a9aaa2-49b1-46f2-bbc1-da44c48d2d7b
# ╟─7ac78172-b519-4ff4-a13f-e9e6cc3374d4
# ╟─9403533a-78e7-4fda-bf1d-c96048a6bd14
# ╠═ea103a1d-8fd2-4dc9-bb1d-e23c3ee29de5
# ╟─c5801846-c091-48ea-baa1-af7c4776f41c
# ╟─db32f2e7-e7bf-4308-94f7-7248034d209c
# ╟─6eb45e7d-2bcc-4066-9753-7ba9fa5d780f
# ╟─abeefd5d-a53c-4251-8769-ba13fa6ce76d
# ╟─ed7a28c6-ebe2-4070-aef4-86bc7b4e3eac
# ╠═a422efe0-2f98-468d-976f-d8530718135e
# ╟─f6f88f95-eaf9-45d0-bc5f-65af43486f55
# ╟─3117853b-dc47-4057-ae0c-28f572ad4b88
