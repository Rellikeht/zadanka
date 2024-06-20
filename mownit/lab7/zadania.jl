### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ 81861ade-01b2-11ef-091d-c3a30fd43713
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using Tables
    using MarkdownTables
    # using DataFrames
    using HypertextLiteral
    using BenchmarkTools
    # using Maxima
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
##### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)

# Zestaw 7 - Całkowanie numeryczne II

##### 1. Napisz iteracje wg metody Newtona do rozwiązywania każdego z następujących równań nieliniowych:

###### (a) $~ x~cos(x) = 1$

###### (b) $~ x^3 - 5x - 6 = 0$

###### (c) $~ e^{-x} = x^2-1$

##### 2.
**(a)** $~$ Pokaż, że iteracyjna metoda

$x_{k+1} = \frac{x_{k-1} f(x_k) - x_k f(x_{k-1})}{f(x_k) - f(x_{k-1})}$
matematycznie jest równoważna z metodą siecznych przy rozwiązywaniu skalarnego nieliniowego równania f (x) = 0.

**(b)**
Jeśli zrealizujemy obliczenia w  arytmetyce zmiennoprzecinkowej o skończonej
precyzji, jakie zalety i wady ma wzór podany w podpunkcie **(a)**,
w porównaniu ze wzorem dla metody siecznych podanym poniżej?

$x_{k+1} = x_k - f(x_k) \frac{x_{k-1} - x_k}{f(x_k) - f(x_{k-1})}$
     
##### 3. Zapisz iteracje Newtona do rozwiązywania następującego układu równań nieliniowych.
$x_1^2 + x_1 x_2^3 = 9$
$3 x_1^2 x_2 - x_2^3 = 4$
    """
end

# ╔═╡ b7f66438-5605-4f89-93fe-c155a03d5e8d
begin
    const FR = StepRangeLen{Float64,Float64,Float64,Int}
    const c1 = "#ff6600"
    const c2 = "#0000a8d8"
    const c3 = "#ff0000cf"

    const rw = 1e-4
    const ts = 45
    const plx = 1920
    const ply = 1080

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

# ╔═╡ 75f858e7-1a08-4ddb-81b9-2ba46c560e41
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ b635b624-b737-45eb-95b7-08e703443e48
md"""
### Zadanie 1
"""

# ╔═╡ c957a2b2-8625-457d-a4d2-97524a7992ba
begin
    const f1a(x::Float64)::Float64 = x * cos(x) - 1
    const f1b(x::Float64)::Float64 = x^3 - 5 * x - 6
    const f1c(x::Float64)::Float64 = ℯ^-x - x^2 + 1
    _ = (f -> f(1.0)).([f1a, f1b, f1c])
    md""""""
end

# ╔═╡ 080cff80-2db5-44d3-99ec-e31485863ffa
md"""
#### Wykresy zadanych funkcji:
"""

# ╔═╡ 54168436-d03d-4789-b586-be048a09fa10
begin
    const r1s = [-12:rw:12, -2.2:rw:3.1, -2.6:rw:3]
    const lbs1 = ["x cos(x) - 1", "x^3 - 5x - 6", "e^-x - x^2 + 1"]
    const f1s = Dict('a' => f1a, 'b' => f1b, 'c' => f1c)

    fig1 = [Figure(size=(plx, ply)) for i in 1:3]
    axs1 = [Axis(fig1[i][1, 1], title=lbs1[i], titlesize=ts) for i in 1:3]
    for i in 1:3
        # TODO zeros ?
        lines!(
            axs1[i],
            r1s[i],
            f1s["abc"[i]].(r1s[i]),
            linewidth=3,
            color=c2
        )
        lines!(
            axs1[i],
            r1s[i],
            zeros(length(r1s[i])),
            linewidth=2,
            color=c3,
            linestyle=:dash
        )
    end
    fig1[1]
end

# ╔═╡ a2a72509-5ef4-455e-9ab7-87956f1ed377
fig1[2]

# ╔═╡ 72eeb48d-848b-4c8a-92b4-cf6d1d61bc0f
fig1[3]

# ╔═╡ a97a8acb-d981-468f-a0bf-6141d1836ea6
md"""
#### Kod:
"""

# ╔═╡ caa437a0-edea-4cd8-a5b6-bf28029f74ec
begin
    const defaulth = 1e-6
    function diff(
        f::F,
        x::Float64,
        h::Float64=defaulth
    )::Float64 where {F<:Function}
        (f(x + h) - f(x - h)) / (2 * h)
    end
    function newtonIter(
        f::F,
        x::Float64,
        h::Float64=defaulth
    )::Float64 where {F<:Function}
        x - f(x) / diff(f, x)
    end
    begin
        _ = diff(f1a, 1.0)
        _ = newtonIter(f1b, 1.0)
    end
    md""""""
end

# ╔═╡ 56b5e747-5aef-444c-9124-4d95b1bdd0c4
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ b3f7d921-17c2-47d4-a99d-745ef60e90c1
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ f8d60886-e045-4e8d-a498-2ed0dd078c76
md"""
### Zadanie 2
"""

# ╔═╡ 013736d1-b85d-4821-b252-c76fce4b10b5
md"""
#### a)

Możemy przekształcić ten wzór, aby był w postaci bardziej
zbliżonej do metody siecznych.
Metoda siecznych jest zdefiniowana rekurencyjnie jako:

$x_{k+1} = x_k - \frac{f(x_k) (x_k - x_{k-1})}{f(x_k) - f(x_{k-1})}$

Porównując oba wzory, zauważamy, że różnią się jedynie
w wyrażeniu w nawiasie mianownika.

$x_{k+1} = \frac{x_{k-1} f(x_k) - x_k f(x_{k-1})}{f(x_k) - f(x_{k-1})}$

Teraz, odjęcie i dodanie $x_k f(x_{k-1})$:

$x_{k+1} = x_k + \frac{
x_{k-1} f(x_k) - x_k f(x_{k-1}) + x_k f(x_{k-1}) - x_k f(x_{k-1})}{
f(x_k) - f(x_{k-1})
}$

Teraz grupujemy wyrażenia:

$x_{k+1} = x_k + \frac{
x_{k-1} f(x_k) - x_k f(x_{k-1})}{
f(x_k) - f(x_{k-1})} +
\frac{x_k f(x_{k-1}) - x_k f(x_{k-1})}{f(x_k) - f(x_{k-1})}$

Ostatecznie otrzymujemy:

$x_{k+1} = x_k - \frac{f(x_k) (x_k - x_{k-1})}{f(x_k) - f(x_{k-1})}$

To jest dokładnie wzór dla metody siecznych.
"""

# ╔═╡ 79577d23-0b51-4509-a17b-dee63e9e4a98
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 8254a75b-6c53-4b24-8ad9-5b7bf9aa0468
md"""
#### b)
Wartości numeryczne obliczane w arytmetyce zmiennoprzecinkowej o
skończonej precyzji mogą wprowadzać pewne różnice w zachowaniu
się obu metod, a więc warto rozważyć zarówno zalety,
jak i wady każdego z tych wzorów w kontekście numerycznego
rozwiązywania równań nieliniowych.

##### Zalety:

1. **Szybsza zbieżność:** Wzór podany w podpunkcie (a) może
zbiegać do pierwiastka równania nieliniowego szybciej niż
metoda siecznych, ponieważ używa średniej wartości funkcji
na dwóch ostatnich punktach jako punktu startowego dla kolejnej iteracji.
   
2. **Stabilność numeryczna:** W niektórych przypadkach,
szczególnie gdy różnica między $f(x_k)$ i $f(x_{k-1})$ jest
bliska zeru, ten wzór może być bardziej stabilny numerycznie,
ponieważ unika dzielenia przez bardzo małą wartość
(co może prowadzić do utraty cyfr znaczących i błędów zaokrągleń).

##### Wady:

1. **Wymaga dwóch punktów startowych:** W przeciwieństwie do
metody siecznych, która wymaga tylko jednego punktu startowego
$x_k$ oraz wartości funkcji w dwóch ostatnich punktach $f(x_k)$ i
$f(x_{k-1})$, wzór podany w podpunkcie (a) wymaga dwóch punktów
startowych $x_{k-1}$ i $x_k$ oraz wartości funkcji w tych punktach.

2. **Potencjalne problemy z dzieleniem przez zero:** Wzór podany w
podpunkcie (a) może być podatny na problemy związane z dzieleniem
przez zero, szczególnie gdy $f(x_k) - f(x_{k-1})$ jest bliskie zeru.
"""

# ╔═╡ 62638356-ad29-43f8-ae12-c1dad745cda8
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ ca86fb5c-f453-4d09-a849-5c4ee2fa8cc4
md"""
### Zadanie 3
"""

# ╔═╡ 3ffc4be0-2275-42c8-9359-b52f5e2b10b4
begin
    function f3a(x1::Float64, x2::Float64)::Float64
        x1 * (x1 + x2^3) - 9
    end
    function f3b(x1::Float64, x2::Float64)::Float64
        x2 * (3 * x1^2 - x2^2) - 4
    end
    begin
        _ = f3a(1.0, 1.0)
        _ = f3b(1.0, 1.0)
    end
    md""""""
end

# ╔═╡ fdeb76d5-1be8-4c5f-bc91-47bfa631641f
md"""
#### Wykresy:
"""

# ╔═╡ 967fd409-dd18-4cf7-8845-4be75fb77d92
begin
    const r3c::FR = -5.0:0.01:5.0
    fig3 = Figure(size=(plx, plx))
    ax3c = Axis(
        fig3[1, 1],
        # title="Punkty spełniające równania na płaszczyźnie",
        # titlesize=ts,
    )
    contour!(
        ax3c,
        r3c,
        r3c,
        [f3a(i, j) for i in r3c, j in r3c],
        linewidth=2,
        color=c1,
        levels=[0]
    )
    contour!(
        ax3c,
        r3c,
        r3c,
        [f3b(i, j) for i in r3c, j in r3c],
        linewidth=2,
        color=c2,
        levels=[0]
    )
	fig3
end

# ╔═╡ 60eede8f-f1f7-406c-bfcd-dfa61a17b1e1
begin
    const r3x::FR = -2.5:0.02:2.5
    const r3y::FR = -2.5:0.02:2.5

    function f3(r3x::FR=r3x, r3y::FR=r3y)::Figure
        fig3 = Figure(size=(plx, 2.6 * ply))

        ax3a = Axis3(
            fig3[1, 1],
            title="Równanie 1",
            titlesize=ts,
            azimuth=0.6π,
            elevation=0.1π
        )
        surface!(
            ax3a,
            r3x,
            r3y,
            [f3a(i, j) for i in r3x, j in r3y],
            linewidth=3,
            colormap=:Reds,
            alpha=0.8
        )

        ax3b = Axis3(
            fig3[2, 1],
            title="Równanie 2",
            titlesize=ts,
            azimuth=0.6π,
            elevation=0.1π
        )
        surface!(
            ax3b,
            r3x,
            r3y,
            [f3b(i, j) for i in r3x, j in r3y],
            linewidth=3,
            colormap=:deep,
            alpha=0.85
        )
        fig3
    end
    f3()
end

# ╔═╡ c910b0c6-6331-43f1-8866-55537f4bacf0
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ e59bcdc2-8cb9-450f-9b0f-41aa80f822a7
md"""
#### Kod:
"""

# ╔═╡ f65c3539-be9f-4c48-bf3a-eab9abfeabaf
begin
    function diff(
        f::F,
        arg::Int,
        x1::Float64,
        x2::Float64,
        h::Float64=defaulth
    )::Float64 where {F<:Function}
        if arg == 1
            return (f(x1 + h, x2) - f(x1 - h, x2)) / (2 * h)
        else
            return (f(x1, x2 + h) - f(x1, x2 - h)) / (2 * h)
        end
    end
    function newtonIter(
        f1::F1,
        f2::F2,
        x1::Float64,
        x2::Float64,
        h::Float64=defaulth
    )::Tuple{Float64,Float64} where {F1<:Function,F2<:Function}
        (x1, x2) .+ ((
            -f1(x1, x2) * diff(f2, 2, x1, x2) + f2(x1, x2) * diff(f1, 2, x1, x2),
            -f2(x1, x2) * diff(f1, 1, x1, x2) + f1(x1, x2) * diff(f2, 1, x1, x2)
        ) ./ (
            diff(f1, 1, x1, x2) * diff(f2, 2, x1, x2)
            -
            diff(f1, 2, x1, x2) * diff(f2, 1, x1, x2)
        ))
    end
    begin
        _ = diff(f3a, 1, 1.0, 1.0)
        _ = newtonIter(f3a, f3b, 1.0, 1.0)
    end
    md""""""
end

# ╔═╡ c3454e69-3ca0-45a7-82c9-5f6b26f2ee05
begin
    const x1s = Dict('a' => -5.0, 'b' => 2.0, 'c' => 1.5)
    const i1s = Dict('a' => 6, 'b' => 6, 'c' => 6)
    function rnd(v::Vector{Float64})::Vector{Float64}
        map(x -> round(x, digits=8), v)
    end
    _ = rnd([1.2])

    xn::Float64 = 0
    t1 = [
        begin
            global xn = x1s[p]
            mktable(
                ["n", "x_n", "f(x_n)"],
                vcat([vcat(
                        Vector{Any}([0]),
                        Vector{Any}(rnd([xn, f1s[p](xn)]))
                    )], [
                        begin
                            global xn = newtonIter(f1s[p], xn)
                            vcat(
                                Vector{Any}([i]),
                                Vector{Any}(rnd([xn, f1s[p](xn)]))
                            )
                        end for i in 1:i1s[p]
                    ]))
        end for p in "abc"
    ]

    t1i::Int = 0
    md"""
Do obliczenia pochodnych używam obustronnego ilorazu róznicowego z małym h,
aby metoda była bardziej uniwersalna

#### Iteracje dla wybranych punktów startowych:
##### a)
$(t1[t1i += 1])
##### b)
$(t1[t1i += 1])
##### c)
$(t1[t1i += 1])
    """
end

# ╔═╡ 3ec2ffb5-fbee-46d5-8c69-fcfd08bdae5d
begin
    const i3s = 8
    xyn::Tuple{Float64,Float64} = (1, 1)

    t3 = mktable(
        ["n", "x_n", "y_n", "f1(x_n, y_n)", "f2(x_n, y_n)"],
        vcat([vcat(
                Vector{Any}([0]),
                Vector{Any}(rnd([xyn..., f3a(xyn...), f3b(xyn...)]))
            )], [
                begin
                    global xyn = newtonIter(f3a, f3b, xyn...)
                    vcat(
                        Vector{Any}([i]),
                        Vector{Any}(rnd([xyn..., f3a(xyn...), f3b(xyn...)]))
                    )
                end for i in 1:i3s
            ])
    )

    md"""
#### Iteracja dla wybranego punktu startowego:
$(t3)
    """
end

# ╔═╡ 654364a8-d38e-4be9-b91e-58378ddad27d
md"""
### Bibliografia:
- wykład
- materiały pomocnicze do laboratorium
"""

# ╔═╡ Cell order:
# ╟─81861ade-01b2-11ef-091d-c3a30fd43713
# ╟─b7f66438-5605-4f89-93fe-c155a03d5e8d
# ╟─75f858e7-1a08-4ddb-81b9-2ba46c560e41
# ╟─b635b624-b737-45eb-95b7-08e703443e48
# ╠═c957a2b2-8625-457d-a4d2-97524a7992ba
# ╟─080cff80-2db5-44d3-99ec-e31485863ffa
# ╟─54168436-d03d-4789-b586-be048a09fa10
# ╟─a2a72509-5ef4-455e-9ab7-87956f1ed377
# ╟─72eeb48d-848b-4c8a-92b4-cf6d1d61bc0f
# ╟─a97a8acb-d981-468f-a0bf-6141d1836ea6
# ╠═caa437a0-edea-4cd8-a5b6-bf28029f74ec
# ╟─56b5e747-5aef-444c-9124-4d95b1bdd0c4
# ╟─c3454e69-3ca0-45a7-82c9-5f6b26f2ee05
# ╟─b3f7d921-17c2-47d4-a99d-745ef60e90c1
# ╟─f8d60886-e045-4e8d-a498-2ed0dd078c76
# ╟─013736d1-b85d-4821-b252-c76fce4b10b5
# ╟─79577d23-0b51-4509-a17b-dee63e9e4a98
# ╟─8254a75b-6c53-4b24-8ad9-5b7bf9aa0468
# ╟─62638356-ad29-43f8-ae12-c1dad745cda8
# ╟─ca86fb5c-f453-4d09-a849-5c4ee2fa8cc4
# ╠═3ffc4be0-2275-42c8-9359-b52f5e2b10b4
# ╟─fdeb76d5-1be8-4c5f-bc91-47bfa631641f
# ╟─967fd409-dd18-4cf7-8845-4be75fb77d92
# ╟─60eede8f-f1f7-406c-bfcd-dfa61a17b1e1
# ╟─c910b0c6-6331-43f1-8866-55537f4bacf0
# ╟─e59bcdc2-8cb9-450f-9b0f-41aa80f822a7
# ╠═f65c3539-be9f-4c48-bf3a-eab9abfeabaf
# ╟─3ec2ffb5-fbee-46d5-8c69-fcfd08bdae5d
# ╟─654364a8-d38e-4be9-b91e-58378ddad27d
