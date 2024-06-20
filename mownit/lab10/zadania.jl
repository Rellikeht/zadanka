### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ 7a3181e2-0793-11ef-3ce1-b5de7460754d
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

    #using LinearAlgebra
    # using IterativeSolvers
    # using Symbolics

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)

    md"""
###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)

### Zadanie 1

Dane jest równanie różniczkowe (zagadnienie początkowe):

$y' + y \; cos\,x = sin\,x \; cos\,x$
$y(0) = 0$

Znaleźć rozwiązanie metodą Rungego-Kutty i metodą Eulera.

Porównać otrzymane rozwiązanie z rozwiązaniem dokładnym

$y(x) = e^{-sin\,x} \;+\; sin\,x \;-\; 1$

### Zadanie 2

Dane jest zagadnienie brzegowe:

$y'' + y = x$
$y(0) = 1$
$y(0.5 \pi) = 0.5 \pi - 1$

Znaleźć rozwiązanie metodą strzałów.

Porównać otrzymane rozwiązanie z rozwiązaniem dokładnym

$y(x) = cos\,x \;-\; sin\,x \;+\; x$

    """
end

# ╔═╡ dd0cde71-e753-4272-aee0-5c4bd040b2bb
md"""
###### Definicje pomocnicze:
"""

# ╔═╡ 51472295-095f-49b9-a173-3e39e9073932
begin
    const FRange = StepRangeLen{Float64,Float64,Float64,Int}
    const IntOrFloat = Union{Int,Float64}
    const default_eps = 1e-8

    md""""""
end

# ╔═╡ fb9b5fd0-5d25-43c1-9383-8ac6cf771e9c


# ╔═╡ 1191a4cf-c4bf-4794-b5ab-e7141f64072f


# ╔═╡ d90b0c39-86e4-4184-9ccb-0cc1be9e349c
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 0386e840-5488-4dfe-b188-935f2ef38dbe
md"""
### Zadanie 1
"""

# ╔═╡ cd0ed350-3ec8-4846-92cf-0bbafc8e58ae
md"""
##### Podstawowe definicje
"""

# ╔═╡ 6ab038a8-6812-4a17-b7bb-f0ee115c3dbb
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 432f27ce-f1f1-4a05-8123-91947c8bb75d
md"""
##### Metoda Eulera
"""

# ╔═╡ 76b10bf1-c9e8-4e55-8af6-b3a9b6a2b644
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ cdc79f97-6975-42d2-a589-7ad639db4d50
md"""
##### Metoda Rungego-Kutty
"""

# ╔═╡ 8e90b3d9-ea01-4c0d-8a52-8e8306249848
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 644e4f5c-62ae-4266-8b7a-23e20cd6a846
md"""
##### Rozwiązanie dokładne
"""

# ╔═╡ 81729269-938b-47c9-9658-1739a7f9cb24
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 9f1df2d6-f92c-452a-acf1-f93cee50c6be
md"""
###### Błąd bezwzględny
"""

# ╔═╡ 1038fdcd-5b8b-478a-9e2a-c3f290ccb8fe
md"""
###### Błąd względny
"""

# ╔═╡ 7aec96e4-4d9e-4e96-8609-16475e2c6e45
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ ddacef29-5ade-4db5-9d04-ef0f6bcf582d
md"""
### Zadanie 2
"""

# ╔═╡ 7fa41f5b-f918-4073-a1cb-39a8ff3f267e
md"""
##### Definicje pomocnicze:
"""

# ╔═╡ ef4d2945-9e91-4dd0-b54a-66c2811b8ec3
begin
	# Metoda siecznych potrzebna do znalezienia odpowiedniej wartości początkowej
	# pochodnej w punkcie startowym w metodzie strzałów
    function secantMethod(
        f::F,
        x0::IntOrFloat,
        x1::IntOrFloat,
        eps::Float64=default_eps
    )::Float64 where {F<:Function}
        y0::Float64 = f(x0)
        y1::Float64 = f(x1)
        while abs(y1) > eps
            x0, x1 = x1, x1 - y1 * (x1 - x0) / (y1 - y0)
            y0, y1 = y1, f(x1)
        end
        return x1
    end

    _ = secantMethod(x -> x^2 - 2, 0, 1)
    _ = secantMethod(x -> ℯ^x - 2, 0, 1)

	md""""""
end

# ╔═╡ 06c25a4d-2413-4e42-9a4b-5c3c531524dd
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 00a7213e-cbb6-4729-8a6b-73b05afa6f87
md"""
##### Podstawowe definicje:
"""

# ╔═╡ 7dc19052-3bea-4305-97be-df93968f8b38
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 8e50b8be-8905-404e-adec-c57ee1a73b8d
md"""
#### Metoda strzałów
"""

# ╔═╡ e45a6ef8-ede2-416b-bd63-b57d4554badf
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ a325a8b0-49a8-455e-8366-0f1f86f8f1e6
md"""
#### Rozwiązanie dokładne
"""

# ╔═╡ 9dec8298-a9ad-4940-aafc-fccbe21c3ec5
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 7f1ba504-0f95-44e9-a69e-7be8b9bc505b
md"""
### Wnioski:
- W zadaniu 1 metoda Rungego-Kutty nie dała wiele lepszych wyników pomimo
  wymagania dużo większej ilości obliczeń

### Bibliografia:
- wykład
- materiały pomocnicze do zadania
"""

# ╔═╡ 736cadf2-ab44-4d96-a3ba-530b08efade7
begin
    const c1 = "#ff6600"
    const c2 = "#0000a8d8"
    const c3 = "#ff0000cf"

    const titlesize = 45
    const labelsize = 34
    const ticksize = 27

    # const rw = 1e-4
    const plx = 1920
    const ply = 1080

    const title_size = 45

    md""""""
end

# ╔═╡ 31849fb0-ca26-4923-8bb0-9737e3fea5e3
begin
    function mktable(
        header::Vector{Symbol},
        contents::Vector{Vector{T}}
    )::Markdown.MD where {T}
        tbl::Vector{Vector{Any}} = [header,]
        push!(tbl, contents...)
        Markdown.MD(Markdown.Table(tbl, header))
    end
    function mktable(
        header::Vector{String},
        # contents::Vector{Vector{T}}
        # )::Markdown.MD where {T}
        contents::Vector{Vector{Any}}
    )::Markdown.MD
        tbl::Vector{Vector{Any}} = [header,]
        push!(tbl, contents...)
        Markdown.MD(Markdown.Table(tbl, repeat([:a], length(header))))
    end

    import Base: zero
    function zero(::Type{NTuple{N,T}})::NTuple{N,T} where {N,T}
        Tuple((zero(T) for _ in 1:N))
    end

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
    @media print {
        .pagebreak { 
            //page-break-before:always;
            break-after:always;
            page-break-after:always;
            page-break-inside:avoid
        }
    }
    </style>
    """
end

# ╔═╡ 61186683-5931-4d99-aed7-abd95491f893
begin
    const x01 = 0
    const y01 = 0.0
    const xend1 = 5

    const default_step1 = 1e-4
    const default_r1::FRange = x01:default_step1:xend1

	# Wzór na y'
    function eq1(x::IntOrFloat, y::IntOrFloat)::Float64
        sin(x) * cos(x) - y * cos(x)
    end
    _ = eq1(1, 1)
    _ = eq1(0.5, 0.5)

	# Rozwiązanie dokładne
    function exact1(x::IntOrFloat)::Float64
        exp(-sin(x)) + sin(x) - 1
    end
	_ = exact1(0)
    _ = exact1(0.5)

	# Funkcja rozwiązująca równanie metodą podaną jako pierwszy parametr,
	# który ma reprezentować pojedynczy krok
    function solve(
        method::F1,
        f::F2,
        step::Float64,
        xstart::IntOrFloat,
        xend::IntOrFloat,
        y0::T,
    )::Vector{T} where {F1<:Function,F2<:Function,T}
        values::Vector{T} = map(_ -> zero(T), FRange(xstart:step:xend))
        values[1] = y0
        x::Float64 = xstart
        @simd for i in 2:length(values)
            x += step
            values[i] = method(f, x, values[i-1], step)
        end
        return values
    end

    md""""""
end

# ╔═╡ 1d89b05e-1ecc-47c8-a1c2-9c57d9a5316d
begin
	# Został zaimplementowany pojedynczy krok, reszta odbywa się w funkcji solve
    function eulerStep(
        f::F,
        x::IntOrFloat,
        y::T,
        step::Float64=default_step1
    )::T where {F<:Function,T}
        y .+ step .* f(x, y)
    end

    _ = eulerStep(eq1, 0.5, 0.5)
    _ = eulerStep(eq1, 1, 1.0)

    _ = solve(eulerStep, eq1, 1e-1, 0.0, 0.5, 0.5)
    _ = solve(eulerStep, eq1, 1e-1, 0, 1, 1.0)

    md""""""
end

# ╔═╡ 6b943aa6-5341-4a5a-81c0-3884193bb6af
begin
    const x02 = (0.0, π / 2)
    const y02 = (1.0, π / 2 - 1)
    const xend2 = x02[2]

    const default_step2 = 1e-3
    const default_r2::FRange = x02[1]:default_step2:xend2

	# Funkcja dana w zadaniu, przyjmuje x oraz parę (y, y')
    function f2(x::IntOrFloat, ys::NTuple{2,IntOrFloat})::Float64
        x - ys[1]
    end
    _ = f2(0, (0, 0))
    _ = f2(0.5, (1.5, 2.5))

	# Funkcja dana w zadaniu zapisana jako układ pierwszego rzędu
    function eq2(x::IntOrFloat,ys::NTuple{2,IntOrFloat})::NTuple{2,Float64}
        (ys[2], f2(x, ys))
    end
    _ = eq2(0.0, (0.0, 0.0))
    _ = eq2(0.5, (1.5, 2.5))

	# Rozwiązanie dokładne
    function exact2(x::IntOrFloat)::Float64
        cos(x) - sin(x) + x
    end
    _ = exact2(1)
    _ = exact2(0.5)

	function endpoint(
        method::F1,
        f::F2,
        step::Float64,
        xstart::IntOrFloat,
        xend::IntOrFloat,
        y0::T,
    )::T where {F1<:Function,F2<:Function,T}
        value::T = y0
        x::Float64 = xstart
        while x <= xend
            x += step
            value = method(f, x, value, step)
        end
        return value
    end

	_ = endpoint(eulerStep, f2, 1e-1, x02[1], x02[2], (y02[1], 0.0))
	_ = endpoint(eulerStep, f2, 1e-2, x02[1], x02[2], (y02[1], 1.0))

    md""""""
end

# ╔═╡ d4890b29-c4ba-4cbc-b92d-6c1925ecf1d8
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    steps::Vector{Float64} = [1e-1, 1e-2, 1e-3, 1e-4]
    colors::Vector{Union{RGBf,String}} = [
        "#ff00ff",
        "#0000ff",
        "#00ef80",
        "#ff0000",
    ]
    styles::Vector{Symbol} = [:solid, :dash, :solid, :dot]
    sizes::Vector{Int} = [4, 4, 4, 8]

    for i in eachindex(steps)
        r::FRange = x01:steps[i]:xend1
        lines!(
            ax,
            r,
            solve(eulerStep, eq1, steps[i], x01, xend1, y01),
            linestyle=styles[i],
            color=colors[i],
            linewidth=sizes[i],
            label="krok = " * string(steps[i])
        )
    end

    axislegend(ax, labelsize=labelsize, position=:rb)
    fig
end

# ╔═╡ a6194f3b-e85a-4be7-9998-0fd15093da70
begin
    # Został zaimplementowany wariant rzędu 4
	# Tak jak w poprzednim wypadku zaimplementowany jest tylko pojedynczy krok
    function rungeKuttaStep(
        f::F,
        x::IntOrFloat,
        y::T,
        step::Float64=default_step1
    )::T where {F<:Function,T}
        k1::Float64 = f(x, y)
        k2::Float64 = f(x + step / 2, y .+ (step / 2) .* k1)
        k3::Float64 = f(x + step / 2, y .+ (step / 2) .* k2)
        k4::Float64 = f(x + step, y + step * k3)
        return y .+ (step / 6) .* (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4)
    end

    _ = rungeKuttaStep(eq1, 0.0, 0.5, 0.5)
    _ = rungeKuttaStep(eq1, 1, 1.0, 0.1)

    md""""""
end

# ╔═╡ 51323886-e9f8-4eb8-9532-dd08a2c92d60
let
    fig = Figure(size=(plx, ply))

    ax = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    steps::Vector{Float64} = [1e-1, 1e-2, 1e-3, 1e-4]
    colors::Vector{Union{RGBf,String}} = [
        "#ff00ff",
        "#0000ff",
        "#00ef80",
        "#ff0000",
    ]
    styles::Vector{Symbol} = [:solid, :dash, :solid, :dot]
    sizes::Vector{Int} = [4, 4, 4, 8]

    for i in eachindex(steps)
        r::FRange = x01:steps[i]:xend1
        lines!(
            ax,
            r,
            solve(rungeKuttaStep, eq1, steps[i], x01, xend1, y01),
            linestyle=styles[i],
            color=colors[i],
            linewidth=sizes[i],
            label="krok = " * string(steps[i])
        )
    end

    axislegend(ax, labelsize=labelsize, position=:rb)
    fig
end

# ╔═╡ f8fabb9a-7578-4c23-a869-2db8af5d6919
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    lines!(
        ax,
        default_r1,
        solve(eulerStep, eq1, default_step1, x01, xend1, y01),
        linestyle=:dash,
        color="#00ff00",
        linewidth=5,
        label="Metoda Eulera, krok=" * string(default_step1)
    )

    lines!(
        ax,
        default_r1,
        solve(rungeKuttaStep, eq1, default_step1, x01, xend1, y01),
        linestyle=:dot,
        color="#ff0000",
        linewidth=4,
        label="Metoda Rungego-Kutty, krok=" * string(default_step1)
    )

    lines!(
        ax,
        default_r1,
        exact1.(default_r1),
        linestyle=:solid,
        color="#336699",
        linewidth=3,
        label="Rozwiązanie dokładne"
    )

    axislegend(ax, labelsize=labelsize, position=:lt)
    fig
end

# ╔═╡ 066bb012-2337-459c-8a69-6f52f7e563fb
begin
    exact_ys1 = exact1.(default_r1)

    euler_ys1 = solve(eulerStep, eq1, default_step1, x01, xend1, y01)
    euler_abs1 = abs.(exact_ys1 .- euler_ys1)
    euler_rel1 = euler_abs1 ./ default_r1

    runge_kutta_ys1 = solve(rungeKuttaStep, eq1, default_step1, x01, xend1, y01)
    runge_kutta_abs1 = abs.(exact_ys1 .- runge_kutta_ys1)
    runge_kutta_rel1 = runge_kutta_abs1 ./ default_r1

    md"""
    ##### Porównanie błędów
    """
end

# ╔═╡ 4e75d221-13f7-4397-8005-c9629c87d618
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    lines!(
        ax,
        default_r1,
        euler_abs1,
        # linestyle=:solid,
        color="#0066ff",
        linewidth=4,
        label="Metoda Eulera, krok=" * string(default_step1)
    )

    lines!(
        ax,
        default_r1,
        runge_kutta_abs1,
        #   linestyle=:solid,
        color="#ff00ff",
        linewidth=2,
        label="Metoda Rungego-Kutty, krok=" * string(default_step1)
    )

    axislegend(ax, labelsize=labelsize, position=:lt)
    fig
end

# ╔═╡ 34b5643e-9132-470d-9a9a-be19a37d49bd
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    lines!(
        ax,
        default_r1,
        euler_rel1,
        # linestyle=:solid,
        color="#0066ff",
        linewidth=4,
        label="Metoda Eulera, krok=" * string(default_step1)
    )

    lines!(
        ax,
        default_r1,
        runge_kutta_rel1,
        # linestyle=:solid,
        color="#ff00ff",
        linewidth=4,
        label="Metoda Rungego-Kutty, krok=" * string(default_step1)
    )

    axislegend(ax, labelsize=labelsize, position=:rt)
    fig
end

# ╔═╡ 840a5e30-f9a0-40d0-a8a7-616ddfa50a07
begin
    function shootingMethod(
        f::F,
        xs::NTuple{2,T},
        ys::NTuple{2,T},
        step::Float64=default_step2,
    )::Vector{NTuple{2,T}} where {F<:Function,T}
		guessF(yg::T) = endpoint(eulerStep, f, step, xs..., (ys[1], yg))[1] - ys[2]
		yprime::T = secantMethod(guessF, guessF(-1.0), guessF(1.0))
        return solve(eulerStep, f, step, xs[1], xs[2], (ys[1], yprime))
    end

    _ = shootingMethod((x, ys) -> (ys[2], ys[1] / 2), (0.0, 1.0), (0.0, 2.0))

    md""""""
end

# ╔═╡ c628233d-b885-4e02-a6c4-933a5def8bea
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    steps::Vector{Float64} = [1e-1, 1e-2, 1e-3, 1e-4]
    colors::Vector{Union{RGBf,String}} = [
        "#ff00ff",
        "#0000ff",
        "#00ef80",
        "#ff0000",
    ]
    styles::Vector{Symbol} = [:solid, :dash, :solid, :dot]
    sizes::Vector{Int} = [4, 4, 4, 8]

    for i in eachindex(steps)
        r::FRange = x02[1]:steps[i]:xend2
        lines!(
            ax,
            r,
            map(x -> x[1], shootingMethod(eq2, x02, y02, steps[i])),
            linestyle=styles[i],
            color=colors[i],
            linewidth=sizes[i],
            label="krok = " * string(steps[i])
        )
    end

    axislegend(ax, labelsize=labelsize, position=:rt)
    fig
end

# ╔═╡ ca4aef54-6b14-4849-856a-ebf29b910034
let
    fig::Figure = Figure(size=(plx, ply))

    ax::Axis = Axis(
        fig[1, 1],
        titlesize=title_size,
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    lines!(
        ax,
        default_r2,
        exact2.(default_r2),
        linestyle=:solid,
        color="#66bbff",
        linewidth=5,
        label="Rozwiązanie dokładne"
    )

    lines!(
        ax,
        default_r2,
        map(x -> x[1], shootingMethod(eq2, x02, y02, default_step2)),
        linestyle=:dash,
        color="#ff0000",
        linewidth=3,
        label="krok = " * string(default_step2)
    )

    axislegend(ax, labelsize=labelsize, position=:rt)
    fig
end

# ╔═╡ Cell order:
# ╟─7a3181e2-0793-11ef-3ce1-b5de7460754d
# ╟─dd0cde71-e753-4272-aee0-5c4bd040b2bb
# ╠═51472295-095f-49b9-a173-3e39e9073932
# ╟─fb9b5fd0-5d25-43c1-9383-8ac6cf771e9c
# ╟─1191a4cf-c4bf-4794-b5ab-e7141f64072f
# ╟─d90b0c39-86e4-4184-9ccb-0cc1be9e349c
# ╟─0386e840-5488-4dfe-b188-935f2ef38dbe
# ╟─cd0ed350-3ec8-4846-92cf-0bbafc8e58ae
# ╠═61186683-5931-4d99-aed7-abd95491f893
# ╟─6ab038a8-6812-4a17-b7bb-f0ee115c3dbb
# ╟─432f27ce-f1f1-4a05-8123-91947c8bb75d
# ╠═1d89b05e-1ecc-47c8-a1c2-9c57d9a5316d
# ╟─d4890b29-c4ba-4cbc-b92d-6c1925ecf1d8
# ╟─76b10bf1-c9e8-4e55-8af6-b3a9b6a2b644
# ╟─cdc79f97-6975-42d2-a589-7ad639db4d50
# ╠═a6194f3b-e85a-4be7-9998-0fd15093da70
# ╟─51323886-e9f8-4eb8-9532-dd08a2c92d60
# ╟─8e90b3d9-ea01-4c0d-8a52-8e8306249848
# ╟─644e4f5c-62ae-4266-8b7a-23e20cd6a846
# ╟─f8fabb9a-7578-4c23-a869-2db8af5d6919
# ╟─81729269-938b-47c9-9658-1739a7f9cb24
# ╟─066bb012-2337-459c-8a69-6f52f7e563fb
# ╟─9f1df2d6-f92c-452a-acf1-f93cee50c6be
# ╟─4e75d221-13f7-4397-8005-c9629c87d618
# ╟─1038fdcd-5b8b-478a-9e2a-c3f290ccb8fe
# ╟─34b5643e-9132-470d-9a9a-be19a37d49bd
# ╟─7aec96e4-4d9e-4e96-8609-16475e2c6e45
# ╟─ddacef29-5ade-4db5-9d04-ef0f6bcf582d
# ╟─7fa41f5b-f918-4073-a1cb-39a8ff3f267e
# ╠═ef4d2945-9e91-4dd0-b54a-66c2811b8ec3
# ╟─06c25a4d-2413-4e42-9a4b-5c3c531524dd
# ╟─00a7213e-cbb6-4729-8a6b-73b05afa6f87
# ╠═6b943aa6-5341-4a5a-81c0-3884193bb6af
# ╟─7dc19052-3bea-4305-97be-df93968f8b38
# ╟─8e50b8be-8905-404e-adec-c57ee1a73b8d
# ╠═840a5e30-f9a0-40d0-a8a7-616ddfa50a07
# ╟─c628233d-b885-4e02-a6c4-933a5def8bea
# ╟─e45a6ef8-ede2-416b-bd63-b57d4554badf
# ╟─a325a8b0-49a8-455e-8366-0f1f86f8f1e6
# ╟─ca4aef54-6b14-4849-856a-ebf29b910034
# ╟─9dec8298-a9ad-4940-aafc-fccbe21c3ec5
# ╟─7f1ba504-0f95-44e9-a69e-7be8b9bc505b
# ╟─736cadf2-ab44-4d96-a3ba-530b08efade7
# ╟─31849fb0-ca26-4923-8bb0-9737e3fea5e3
