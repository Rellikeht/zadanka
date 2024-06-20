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

### Zadanie

Tematem zadania będzie obliczanie metodą Monte Carlo całki funkcji:

1)$~x^2 + x + 1$,

2)$~\sqrt{1-x^2}$ oraz

3)$~\frac{1}{\sqrt{x}}$ w przedziale $(0,1)$.

Proszę dla tych funkcji:

- Napisać funkcję liczącą całkę metodą "hit-and-miss".
  Czy będzie ona dobrze działać dla funkcji $\frac{1}{\sqrt{x}}$?
- Policzyć całkę przy użyciu napisanej funkcji.
  Jak zmienia się błąd wraz ze wzrostem liczby prób?
- Policzyć wartość całki korzystając ze wzoru prostokątów dla dokładności
  (1e-3, 1e-4, 1e-5 i 1e-6). Porównać czas obliczenia całki metodą Monte Carlo
  i przy pomocy wzoru prostokątów dla tej samej dokładności, narysować wykres.
  Zinterpretować wyniki.
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
    const density = 1e-12

    md""""""
end

# ╔═╡ fb9b5fd0-5d25-43c1-9383-8ac6cf771e9c


# ╔═╡ 1191a4cf-c4bf-4794-b5ab-e7141f64072f


# ╔═╡ 222bf176-8deb-4a4d-b689-84b23a6b795b


# ╔═╡ 0aff3077-43cf-459a-a08f-33af9039ccdf


# ╔═╡ 8bb68cc5-7471-4bd9-b8c4-7b8d8fc6f8a9


# ╔═╡ 3093d499-d439-4985-af10-e6a8b76d1cae


# ╔═╡ d90b0c39-86e4-4184-9ccb-0cc1be9e349c
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 0386e840-5488-4dfe-b188-935f2ef38dbe
md"""
### Zadanie 1
"""

# ╔═╡ f88979f6-ef69-4c3b-94bc-b70375f49999
md"""
##### Podatwowe definicje
"""

# ╔═╡ 56093540-8ec9-4d73-b27a-0627eaca40de
begin
    const default_shots = Int(1e4)
    const default_h = 1e-4
    const ranges = [(1, 3), (-1, 1), (0, 1)]

    const f1(x::IntOrFloat)::Float64 = x^2 + x + 1
    const f2(x::IntOrFloat)::Float64 = sqrt(1 - x^2)
    const f3(x::IntOrFloat)::Float64 = 1 / sqrt(x)
    const F1(x::IntOrFloat)::Float64 = x^3 / 3 + x^2 / 2 + x
    const F2(x::IntOrFloat)::Float64 = asin(x) / 2 + x * sqrt(1 - x^2) / 2
    const F3(x::IntOrFloat)::Float64 = 2 * sqrt(x)

    _ = (f -> f(1)).([f1, f2, f3, F1, F2, F3])
    md""""""
end

# ╔═╡ 034237b6-a5b9-45b2-bd73-23477af3d7a1
md"""
##### Funkcje pomocnicze
"""

# ╔═╡ 6a0d27d6-6c5b-4df3-bb4b-fc3bdd05eb6b
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 0d708f23-dd99-4410-a2ee-4607f25f04f3
md"""
##### Funkcje główne
"""

# ╔═╡ 21c800fb-332d-4158-96d8-6488c88d750d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 4a7ad428-bc9d-413e-a485-a6a4a6b38fb9
md"""
Metoda hit and miss nie będzie działała dobrze dla funkcji $\frac{1}{\sqrt{x}}$.
Jej wykres został pokazany poniżej. Z jej przebiegu można się spodziewać mocno
zaniżonych wyników. Również ciężko oszacować wysokość prostokąta w którym zostanie
przeprowadzona ta metoda.
"""

# ╔═╡ 16571954-ea7e-45d5-8585-29b560a45fbe
let
    r = FRange(1e-4:1e-4:10)
    lines(r, (x -> 1 / sqrt(x)).(r))
end

# ╔═╡ e14bd22e-b9f1-4ab1-890e-84f96d6da583
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 39f1b869-22fc-4142-8ee6-3688374778df
md"""
##### Błąd bezwzględny metody hit-and-miss
"""

# ╔═╡ d31a31fb-9aad-4400-822d-4c25b6e586cc
md"""
Oś y to wartość błędu, Oś x to ilość punktów w metodzie hit-and-miss
Jak widać wartości dość wolno i niejednostajnie zbiegają do 0.
"""

# ╔═╡ 67e8fc13-0645-40a2-94ec-b10ee358781a
md"""
##### Błąd bezwzględny dla metody prostokątów
"""

# ╔═╡ 9ee15064-c1ac-46b9-b9b7-302b0da73429
md"""
Oś x to odwrotność szerokości prostokąta
"""

# ╔═╡ 4415b524-c08b-4e5b-9b2d-86edfc674dab
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ e50a8f63-7961-456b-8606-d21d4fa59150
md"""
##### Czas wykonania
"""

# ╔═╡ 5eaab83e-abbd-4466-909b-7164ab31db97
md"""
Oś x to dokładność, oś y to czas wykonania (w sekundach)
"""

# ╔═╡ 2d1aaa37-954c-48bb-8f91-410bc414bfe1


# ╔═╡ 7f1ba504-0f95-44e9-a69e-7be8b9bc505b
md"""
### Wnioski:
- metoda hit-and-miss jest mało wydajna, zwłaszcza kiedy równie łatwo jest użyć
  innych metod

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

# ╔═╡ 03e535ce-f955-4a78-a216-58b5651a829c
begin
    function findYBounds(
        f::F,
        a::IntOrFloat,
        b::IntOrFloat,
        shots::Int=default_shots / 10,
    )::Tuple{Float64,Float64} where {F<:Function}
        minY::Float64, maxY::Float64 = 0, 0
        @simd for i in 1:shots
            x = rand(FRange(a:density:b))
            y = f(x)
            if y > -Inf && y < minY
                minY = y
            elseif y < Inf && y > maxY
                maxY = y
            end
        end
        return (minY, maxY)
    end
    _ = findYBounds(f1, 0, 1, 5)

    md""""""
end

# ╔═╡ c8b6c5aa-46b4-4f4e-ace1-cba2cfd84cc2
begin
    function monteCarlo(
        f::F,
        a::IntOrFloat,
        b::IntOrFloat,
        shots::Int=default_shots,
    )::Float64 where {F<:Function}
        minY::Float64, maxY::Float64 = findYBounds(
            f,
            a,
            b,
            Int(round(shots / max(10 * log10(shots), 1))),
        )
        hits::Int = 0

        @simd for i in 1:shots
            x = rand(a:density:b)
            v = f(x)
            if v >= 0
                y = rand(0:density:maxY)
                if y < v
                    hits += 1
                end
            else
                y = rand(minY:density:0)
                if y > v
                    hits -= 1
                end
            end
        end
        return (b - a) * (maxY - minY) * hits / shots
    end
    _ = monteCarlo(f2, 0, 1, 5)

    function rectangle(
        f::F,
        a::IntOrFloat,
        b::IntOrFloat,
        h::Float64=default_h
    )::Float64 where {F<:Function}
        result::Float64 = 0
        @simd for x in FRange(a:h:b)
            result += f(x)
        end
        return result * h
    end
    _ = rectangle(f1, 0, 1, 0.2)
    _ = rectangle(f3, 0, 1, 0.01)

    md""""""
end

# ╔═╡ 73d55171-7d18-4e4f-b8dd-e21dfc0a94f7
let
    shots::Vector{Int} = [
        1e2, 3e2,
        1e3, 3e3,
        1e4, 3e4,
        1e5, 3e5,
        1e6, 3e6,
        #1e7, 3e7,
    ]

    functions = [(f1, F1), (f2, F2), (f3, F3)]
    colors = [:blue, :red, :green]
    names = ["funkcja 1)", "funkcja 2)", "funkcja 3)"]

    fig = Figure(size=(1280, 720))
    ax = Axis(
        fig[1, 1],
        xscale=log10,
    )

    @simd for i in eachindex(functions)
        lines!(
            ax,
            shots,
            (s -> abs(
                monteCarlo(
                    functions[i][1],
                    ranges[i][1],
                    ranges[i][2],
                    s
                ) - functions[i][2](ranges[i][2])
                +
                functions[i][2](ranges[i][1])
            )).(shots),
            color=colors[i],
            label=names[i],
        )
    end

    axislegend(ax, position=:rt)
    fig
end

# ╔═╡ 59f2f77c-93ee-4c0f-876d-c1ae0ffa883d
let
    widths::Vector{Int} = [
        1e2, 1e3, 1e4, 1e5, 1e6,
    ]

    functions = [(f1, F1), (f2, F2), (f3, F3)]
    colors = [:blue, :red, :green]
    names = ["funkcja 1)", "funkcja 2)", "funkcja 3)"]

    fig = Figure(size=(1280, 720))
    ax = Axis(
        fig[1, 1],
        xscale=log10,
    )

    @simd for i in eachindex(functions)
        lines!(
            ax,
            widths,
            (w -> abs(
                rectangle(
                    functions[i][1],
                    ranges[i][1],
                    ranges[i][2],
                    1 / w
                ) - functions[i][2](ranges[i][2])
                +
                functions[i][2](ranges[i][1])
            )).(widths),
            color=colors[i],
            label=names[i],
        )
    end

    axislegend(ax, position=:rt)
    fig
end

# ╔═╡ c69d7a7c-f844-47b3-b68e-5ee0bf0d2438
let
    runs = 100

    shots::Vector{Int} = [
        1e2, 3e2,
        1e3, 3e3,
        1e4, 3e4,
        1e5, 3e5,
        1e6, 3e6,
		1e7, 3e7
    ]

    # functions = [(f1, F1), (f2, F2), (f3, F3)]
    functions = [(f1, F1)]
    colors = [
        (:darkblue, :lightblue),
        (:darkred, :red),
        (:green, :lightgreen),
    ]
    names = [
        ("hit-and-miss, funkcja 1", "prostokąty funkcja 1"),
        ("hit-and-miss, funkcja 2", "prostokąty funkcja 2"),
        ("hit-and-miss, funkcja 3", "prostokąty funkcja 3"),
    ]

    fig = Figure(size=(1280, 720))
    ax = Axis(
        fig[1, 1],
        xscale=log10,
		yscale=log10,
    )

    for i in eachindex(functions)
        mtime = zeros(length(shots))
        rtime = zeros(length(shots))

        @simd for j in eachindex(shots)
            mtime[j] = @elapsed for _ in runs
                monteCarlo(
                    functions[i][1], ranges[i][1], ranges[i][2], shots[j]
                )
            end
            mtime[j] /= runs
            rtime[j] = @elapsed for _ in runs
                rectangle(
                    functions[i][1], ranges[i][1], ranges[i][2], 1/shots[j]
                )
            end
            rtime[j] /= runs
        end

        lines!(ax, shots, mtime, color=colors[i][1], label=names[i][1])
        lines!(ax, shots, rtime, color=colors[i][2], label=names[i][2])
    end

    axislegend(ax, position=:rb)
    fig
end

# ╔═╡ Cell order:
# ╟─7a3181e2-0793-11ef-3ce1-b5de7460754d
# ╟─dd0cde71-e753-4272-aee0-5c4bd040b2bb
# ╠═51472295-095f-49b9-a173-3e39e9073932
# ╟─fb9b5fd0-5d25-43c1-9383-8ac6cf771e9c
# ╟─1191a4cf-c4bf-4794-b5ab-e7141f64072f
# ╟─222bf176-8deb-4a4d-b689-84b23a6b795b
# ╟─0aff3077-43cf-459a-a08f-33af9039ccdf
# ╟─8bb68cc5-7471-4bd9-b8c4-7b8d8fc6f8a9
# ╟─3093d499-d439-4985-af10-e6a8b76d1cae
# ╟─d90b0c39-86e4-4184-9ccb-0cc1be9e349c
# ╟─0386e840-5488-4dfe-b188-935f2ef38dbe
# ╟─f88979f6-ef69-4c3b-94bc-b70375f49999
# ╠═56093540-8ec9-4d73-b27a-0627eaca40de
# ╟─034237b6-a5b9-45b2-bd73-23477af3d7a1
# ╠═03e535ce-f955-4a78-a216-58b5651a829c
# ╟─6a0d27d6-6c5b-4df3-bb4b-fc3bdd05eb6b
# ╟─0d708f23-dd99-4410-a2ee-4607f25f04f3
# ╠═c8b6c5aa-46b4-4f4e-ace1-cba2cfd84cc2
# ╟─21c800fb-332d-4158-96d8-6488c88d750d
# ╟─4a7ad428-bc9d-413e-a485-a6a4a6b38fb9
# ╟─16571954-ea7e-45d5-8585-29b560a45fbe
# ╟─e14bd22e-b9f1-4ab1-890e-84f96d6da583
# ╟─39f1b869-22fc-4142-8ee6-3688374778df
# ╟─73d55171-7d18-4e4f-b8dd-e21dfc0a94f7
# ╟─d31a31fb-9aad-4400-822d-4c25b6e586cc
# ╟─67e8fc13-0645-40a2-94ec-b10ee358781a
# ╟─59f2f77c-93ee-4c0f-876d-c1ae0ffa883d
# ╟─9ee15064-c1ac-46b9-b9b7-302b0da73429
# ╟─4415b524-c08b-4e5b-9b2d-86edfc674dab
# ╟─e50a8f63-7961-456b-8606-d21d4fa59150
# ╟─c69d7a7c-f844-47b3-b68e-5ee0bf0d2438
# ╟─5eaab83e-abbd-4466-909b-7164ab31db97
# ╟─2d1aaa37-954c-48bb-8f91-410bc414bfe1
# ╟─7f1ba504-0f95-44e9-a69e-7be8b9bc505b
# ╟─736cadf2-ab44-4d96-a3ba-530b08efade7
# ╟─31849fb0-ca26-4923-8bb0-9737e3fea5e3
