### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ e70f5821-2fc8-46cf-8664-8742ca09d18d
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Maxima
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
    ###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)
    \

    # Zestaw 6 - Całkowanie numeryczne II
    ## Zadania
    ### Obliczyć przybliżoną wartość całki:

    $\int^{\infty}_{-\infty} e^{-x^2} cos(x) dx$

    a) przy pomocy złożonych kwadratur (prostokątów, trapezów, Simpsona),
    \
    b) przy pomocy całkowania adaptacyjnego,
    \
    c) przy pomocy kwadratury Gaussa-Hermite’a, obliczając wartości węzłów i wag.

    Porównać wydajność dla zadanej dokładności.
    """
end

# ╔═╡ fef31c85-2127-4698-92d5-d2dc75d4fa09
begin
    const c1 = "#00ff00"
    const c2 = "#0040eedd"
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

# ╔═╡ 2d4deefa-170d-4d2b-9a97-809918204f66
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 0e483074-383a-4339-a093-b01d00c18a1f
begin
    md"""
    ##### Podstawowe definicje:
    """
end

# ╔═╡ db1d7c61-3611-4551-909d-c6a99205d96a
begin
    # Domyślne wartości h i n
    const defaultH = 0.001
    const defaultE = 0.001
    # Funkcja dana w zadaniu
    function f(x::Float64)::Float64
        ℯ^(-(x)^2) * cos(x)
    end
    # Rzeczywista wartość całki
    const real_value = 1 / ℯ^(1 / 4) * sqrt(π)
    md"""
    """
end

# ╔═╡ fd9fd26d-9ed2-4c46-aea5-10fefecaadac
md"""
##### Wykres funkcji:
"""

# ╔═╡ 44c4d57a-6a42-4179-9989-b974bf70f36f
begin
    const fxmax = 6.0
    const frange = -fxmax:0.0001:fxmax
    fig1 = Figure(size=(1920, 960))
    lines(fig1[1, 1], frange, f.(frange), color=:green, linewidth=4)
    fig1
end

# ╔═╡ bd84b137-eae9-4cdb-a4d4-e0a4a4d86428
md"""
#### a) Kwadratury złożone:
"""

# ╔═╡ 8bf3502b-2c23-42cf-95a5-1cd10ec3d120
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 223a5351-1aef-4459-a232-e9a675a805d8
md"""
##### Funkcje pomocnicze:
"""

# ╔═╡ 3efc0478-bc1c-4923-867e-0cebfad60438
begin

    # Funkcja sprawdzająca, czy wartości bezwzględne wszystkich
    # wartości funkcji wokół danego punktu są mniejsze od zadanego ε
    # Sprawdzane punkty zostały wybrane arbitralnie ze względu na trudność
    # rygorystycznego ich wyboru i brak dostępnych algorytmów
    function smallerNB(
        f::F,
        x::Float64,
        ε::Float64=defaultE,
        h::Float64=defaultH,
    )::Bool where {F<:Function}
        result = false
        @simd for i in -6:3:6
            result = result || abs(f(x+h*i)) > ε
        end
        return result
    end

    # Wyszukiwanie połówkowe punktu po którym już nie opłaca
    # się dodawać elementów w kwadraturach elementarnych
    function find(
        f::F,
        ε::Float64=defaultE,
        h::Float64=defaultH,
        start::Float64=1 / defaultE
    )::Float64 where {F<:Function}
        a::Float64 = 0
        b::Float64 = start
        mid::Float64 = 0
        while smallerNB(f, b, ε, h)
            b *= 2
        end
        while b - a > h
            mid = (a + b) / 2
            if smallerNB(f, mid, ε, h)
                a = mid
            else
                b = mid
            end
        end
        return mid
    end

    # Wymuszenie prekompilacji
    begin
        _ = smallerNB(f, 0.1, 0.1, 1.0)
        _ = smallerNB(f, 0.0001, 0.0001, 1.0)
        _ = find(f, 0.1, 0.1)
        _ = find(f, 0.0001, 0.0001)
    end
    md""""""
end

# ╔═╡ 899f6c28-3530-4e73-9eac-631369e4db0f
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ c86223c6-b58a-4b14-8bb3-8b45edbe83cd
md"""
##### Metoda prostokątów:
"""

# ╔═╡ 5a841f9c-da34-43db-99a2-1950b97a17b9
begin
    function rectangle(
        f::F,
        ε::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        result::Float64 = 0
        xend::Float64 = find(f, ε, h, 1 / ε)
        rng::StepRangeLen{Float64,Float64,Float64,Int} = h/2:h:xend
        @simd for x in rng
            result += f(x)
        end
        xend = find(x -> f(-x), ε, h, 1 / ε)
        rng = -h/2:-h:-xend
        @simd for x in rng
            result += f(x)
        end
        return result * h
    end
    begin
        _ = rectangle(f, 0.1, 0.1)
        _ = rectangle(f, 0.001, 0.001)
    end
    md"""
    """
end

# ╔═╡ 6c29d1c6-97f6-490b-a7d3-fee1093baf9d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ dad8cf32-192a-4b41-8710-0057da974040
md"""
##### Metoda trapezów:
"""

# ╔═╡ 84d611fa-4fb9-4f5b-981c-9b14d843f462
begin
    function trapezoidal(
        f::F,
        ε::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        result::Float64 = f(0.0)
        xend::Float64 = find(f, ε, h, 1 / ε)
        rng::StepRangeLen{Float64,Float64,Float64,Int} = h:h:xend-h
        @simd for x in rng
            result += f(x)
        end
        result += f(xend) / 2
        xend = find(x -> f(-x), ε, h, 1 / ε)
        rng = -h:-h:-xend+h
        @simd for x in rng
            result += f(x)
        end
        result += f(-xend) / 2
        return result * h
    end
    begin
        _ = trapezoidal(f, 0.1, 0.1)
        _ = trapezoidal(f, 0.001, 0.001)
    end
    md"""
    """
end

# ╔═╡ 73355c0c-f657-426e-8604-be02503803cb
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 1615b1ae-d213-4ca4-903c-b71b80926020
md"""
##### Metoda simpsona:
"""

# ╔═╡ a9c6cc22-7309-4909-a0f5-a1bfbff76ccc
begin
    # Wzór simpsona
    function simpson(
        f::F,
        ε::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        result::Float64 = 0
        xend::Float64 = find(f, ε, h, 1 / ε)
        rng::StepRangeLen{Float64,Float64,Float64,Int} = h:2*h:xend
        @simd for x in rng
            result += f(x)
        end
        xend = find(x -> f(-x), ε, h, 1 / ε)
        rng = -h:-2*h:-xend
        @simd for x in rng
            result += f(x)
        end
        return 2 * (trapezoidal(f, ε, h) + result * h) / 3
    end

    begin
        _ = simpson(f, 0.1, 0.1)
        _ = simpson(f, 0.001, 0.001)
    end
    md"""
    """
end

# ╔═╡ b0449a53-aac0-4fb7-8821-a7d688645424
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 3028f296-e137-4693-9105-4772f68fb5e3
md"""
##### Porównanie dla kilku wartości paremetrów:
"""

# ╔═╡ 54e9f71a-8823-4513-8040-c89000593d0c
@time md"""
metoda|ε|h|wartość|błąd
:-:|:-:|:-:|:-:|:-:
||||
prostokątów|1e-2|1e-2|$(rectangle(f,1e-2,1e-2))|$(abs(rectangle(f,1e-2,1e-2)-real_value))
trapezów|1e-2|1e-2|$(trapezoidal(f,1e-2,1e-2))|$(abs(trapezoidal(f,1e-2,1e-2)-real_value))
simpsona|1e-2|1e-2|$(simpson(f,1e-2,1e-2))|$(abs(simpson(f,1e-2,1e-2)-real_value))
||||
||||
prostokątów|1e-3|1e-3|$(rectangle(f,1e-3,1e-3))|$(abs(rectangle(f,1e-3,1e-3)-real_value))
trapezów|1e-3|1e-3|$(trapezoidal(f,1e-3,1e-3))|$(abs(trapezoidal(f,1e-3,1e-3)-real_value))
simpsona|1e-3|1e-3|$(simpson(f,1e-3,1e-3))|$(abs(simpson(f,1e-3,1e-3)-real_value))
||||
||||
prostokątów|1e-4|1e-4|$(rectangle(f,1e-4,1e-4))|$(abs(rectangle(f,1e-4,1e-4)-real_value))
trapezów|1e-4|1e-4|$(trapezoidal(f,1e-4,1e-4))|$(abs(trapezoidal(f,1e-4,1e-4)-real_value))
simpsona|1e-4|1e-4|$(simpson(f,1e-4,1e-4))|$(abs(simpson(f,1e-4,1e-4)-real_value))
||||
||||
prostokątów|1e-5|1e-5|$(rectangle(f,1e-5,1e-5))|$(abs(rectangle(f,1e-5,1e-5)-real_value))
trapezów|1e-5|1e-5|$(trapezoidal(f,1e-5,1e-5))|$(abs(trapezoidal(f,1e-5,1e-5)-real_value))
simpsona|1e-5|1e-5|$(simpson(f,1e-5,1e-5))|$(abs(simpson(f,1e-5,1e-5)-real_value))
||||
||||
prostokątów|1e-6|1e-6|$(rectangle(f,1e-6,1e-6))|$(abs(rectangle(f,1e-6,1e-6)-real_value))
trapezów|1e-6|1e-6|$(trapezoidal(f,1e-6,1e-6))|$(abs(trapezoidal(f,1e-6,1e-6)-real_value))
simpsona|1e-6|1e-6|$(simpson(f,1e-6,1e-6))|$(abs(simpson(f,1e-6,1e-6)-real_value))
||||
||||
"""

# ╔═╡ def75434-3c62-4199-b589-e042c69ed6db
md"""
#### b) Całkowanie adaptacyjne
##### Kod:
"""

# ╔═╡ cd238a0b-de24-4f7f-8da8-7605e33c10fc
begin
    function romberg(
        f::F,
        ε::Float64=defaultE
    )::Float64 where {F<:Function}
        fsubst(x::Float64)::Float64 = f(tan(x))/cos(x)^2
        # -ε i +ε, żeby uniknąć dzielenia przez cos(±π/2) = 0
        a::Float64 = -π/2+ε
        b::Float64 = π/2-ε
        i::Int = 1
        h::Float64 = (b-a)/2
        previous::Float64 = (fsubst(a)+fsubst(b))*h
        result::Float64 = fsubst((a+b)/2)*h/2 + previous/2
        while abs(result-previous) > ε
            previous = result
            result = 0
            i += 1
            h = (b-a)/2^i
            @simd for j in 1:2:2^i-1
                result += f(a+h*j)
            end
            result = result*h+previous/2
        end
        return result
    end

    begin
        _ = romberg(f, 0.1)
        _ = romberg(f, 0.001)
    end
    md"""
    """
end

# ╔═╡ 71e383f8-40e8-4b50-b5a8-96fba94cae04
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ f4ef0ca6-dabc-4e5d-aa3b-d2d8ac6cdf66
@time md"""
##### Uzasadnienie:
Używam algorytmu Romberga \
Aby mógł on zadziałać dokonałem podstawienia:

$x = tan(u)$

$dx = \frac{1}{cos(u)^2} du$

$\int^{\infty}_{-\infty} f(x) dx =
\int^{\frac{\pi}{2}}_{-\frac{\pi}{2}} \frac{f(tan(u))}{cos(u)^2} du$

##### Wyniki:
Rzeczywista wartość całki: $~~$**$(real_value)**

ε|wartość całki|błąd
:-:|:-:|:-:
1e-1|$(romberg(f,1e-1))|$(abs(romberg(f,1e-1)-real_value))
1e-2|$(romberg(f,1e-2))|$(abs(romberg(f,1e-2)-real_value))
1e-3|$(romberg(f,1e-3))|$(abs(romberg(f,1e-3)-real_value))
1e-4|$(romberg(f,1e-4))|$(abs(romberg(f,1e-4)-real_value))
1e-5|$(romberg(f,1e-5))|$(abs(romberg(f,1e-5)-real_value))
1e-6|$(romberg(f,1e-6))|$(abs(romberg(f,1e-6)-real_value))
"""
# 1e-7|$(romberg(f,1e-7))|$(abs(romberg(f,1e-7)-real_value))

# ╔═╡ 493b30a1-7b4e-41d7-8c62-e86537411833


# ╔═╡ 7380883e-5d53-46ba-a671-eb4526bfd728


# ╔═╡ 46c2ea57-a6af-4b5f-adf4-de7781c226de
md"""
#### c) Całka Gaussa-Hermite'a
##### Kod:
"""

# ╔═╡ 43c8d52f-f8b7-4490-b83b-9664f917ba2d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 0b6f5bf3-1027-4908-8cd8-d8515b691600
begin
    # Funkcja zwracająca wielomian będący pochodną danego
    function diff(p::Vector{Int})::Vector{Int}
        d::Vector{Int} = Vector(undef, max(length(p) - 1, 0))
        for i in length(p):-1:2
            d[i-1] = (i - 1) * p[i]
        end
        return d
    end

    # Funkcja generująca następny wielomian Hermite'a
    function nextH(p::Vector{Int})::Vector{Int}
        n::Vector{Int} = zeros(length(p) + 1)
        d::Vector{Int} = diff(p)
        for i in eachindex(p)
            n[i+1] = p[i] * (-2)
        end
        for i in eachindex(d)
            n[i] += d[i]
        end
        return n
    end

    # Funkcja generująca n pierwszych wielomianów Hermite'a
    function getHs(n::Int)::Vector{Vector{Int}}
        H::Vector{Vector{Int}} = Vector(undef, n)
        H[1] = [1]
        for i in 2:n
            H[i] = nextH(H[i-1])
        end
        return H
    end

    # Funkcja zamieniająca współczynniki wielomianu w funkcję
    function ptof(p::Vector{Int})::Function
        return (x::Float64) -> begin
            res::Float64 = p[end]
            for i in length(p)-1:-1:1
                res = res*x+p[i]
            end
            res
        end::Float64
    end

    # Funkcja zamieniająca wielomian na ciąg znaków, który będzie go reprezentował
    function polyToString(p::Vector{Int})::String
        if length(p) == 0
            return ""
        elseif length(p) == 1
            return string(p[1])
        end

        s::String = p[1] == 0 ? "" : string(p[1])
        for i in 2:length(p)
            if p[i] != 0
                if p[i] > 0
                    s *= "+"
                end
                s *= string(p[i]) * "*x^" * string(i - 1)
            end
        end
        return s
    end

    # Funkcja znajdująca zera wielomianu używając programu Maxima
    function getZeros(p::Vector{Int})::Vector{Float64}
        sol::Expr = mcall(Meta.parse("allroots(" * polyToString(p) * ")"))
        (x -> real(eval(x.args[2]))).(sol.args)
    end

    # Prekompilacja
    begin
        _ = diff([1, 2, 3])
        _ = nextH([1])
        _ = getHs(2)
        _ = ptof([1, 2])
        _ = mcall(:(solve(x^2 - 1, x)))
        _ = polyToString([1, 0, 2])
        _ = getZeros([1, 2])
    end

    # Do obliczeń przyjąłem wielomiany do 10 stopnia
    const N = 11
    const H = getHs(N)
    const Hf = ptof.(H)
    const xk = getZeros.(H)

    # Funkcja znajdująca współczynniki kwadratury dla (n-1)-tego stopnia
    function Ak(n::Int)::Vector{Float64}
        a::Vector{Float64} = Vector(undef, length(xk[n]))
        for i in eachindex(xk[n])
            a[i] = (sqrt(π) * 2^(n - 2) * factorial(n - 1))
            a[i] /= ((n - 1)^2 * Hf[n-1](xk[n][i])^2)
        end
        return a
    end
    _ = Ak(2)
    const A = cat([zeros(0)], Ak.(2:N), dims=1)

    # Funkcja licząca całkę danej funkcji kwadraturą Gaussa-Hermite'a n-tego stopnia
    # (od -∞ do +∞)
    function gaussHermite(n::Int, f::F)::Float64 where {F<:Function}
        result::Float64 = 0
        n += 1
        for i in eachindex(xk[n])
            result += f(xk[n][i]) * A[n][i] * ℯ^(xk[n][i]^2)
        end
        return result
    end
    _ = gaussHermite(1, x -> x)
    md""""""
end


# ╔═╡ c68b16b9-2ae0-4382-a80d-0330a66a71b4
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 3566d4ab-c6d2-4ff9-bc2a-9a2a8820bad9
md"""
Rzeczywista wartość całki: **$(real_value)**
###### Wyniki kwadratury dla poszczególnych N (ilości węzłów): 
N|wartość całki|błąd
|:-:|:-:|:-:|
2|$(gaussHermite(2, f))|$(abs(gaussHermite(2, f)-real_value))
4|$(gaussHermite(4, f))|$(abs(gaussHermite(4, f)-real_value))
6|$(gaussHermite(6, f))|$(abs(gaussHermite(6, f)-real_value))
8|$(gaussHermite(8, f))|$(abs(gaussHermite(8, f)-real_value))
10|$(gaussHermite(10, f))|$(abs(gaussHermite(10, f)-real_value))

Jak widać jest to bardzo dokładna i wydajna metoda
"""

# ╔═╡ 68209a5f-2574-49c3-923f-8f68f14f21e1
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ e7228ba3-1e70-4be0-bfac-a700e907bcb2
md"""
#### Porównanie wydajności:
Jak widać po przykładach wykonań funkcji kwadratury elementarne potrzebują
dużo mocy obliczeniowej, a kwadratury Gaussa sprawdzają się bardzo dobrze.
 \

### Wnioski:
- Dostosowanie kwadratur elementarnych do całkowania nieograniczonych zakresów
  jest trudną sztuką
- Kwadratury Gaussa znowu okazują się bardzo efektywnym i wydajnym sposobem na
  liczenie całek, ale w tym przypadku nie działają zawsze
- Podczas szukania informacji potrzebnych do zadania oraz tworzenia i testowania 
  algorytmów uświadomiłem sobie jak trudnym i wręcz nierozwiązywalnym w ogólnym
  wypadku jest problem całkowania w nieskończonym przedziale. Stosunkowo łatwo jest
  wymyślić takie warunki, w których każdy z dostępnych algorytmów zawodzi:
  + Zera funkcji poważne utrudniające ograniczenie zakersu całkowania do kwadratur
    elementarnych
  + Położenie obszarów funkcji odpowiadających za znaczną część ostatecznego wyniku
    poza okolicami zera utrudniające użycie kwadratur Gaussa i podstawień 
    algebraicznych zamieniających zakres na skończony
\

### Bibliografia:
- `https://mathworld.wolfram.com/Hermite-GaussQuadrature.html`
- `https://home.agh.edu.pl/~chwiej/mn/wyk/calkowanie_22_23.pdf`
- wykład
- materiały pomocnicze do zadań
"""

# ╔═╡ Cell order:
# ╟─e70f5821-2fc8-46cf-8664-8742ca09d18d
# ╟─fef31c85-2127-4698-92d5-d2dc75d4fa09
# ╟─2d4deefa-170d-4d2b-9a97-809918204f66
# ╟─0e483074-383a-4339-a093-b01d00c18a1f
# ╠═db1d7c61-3611-4551-909d-c6a99205d96a
# ╟─fd9fd26d-9ed2-4c46-aea5-10fefecaadac
# ╟─44c4d57a-6a42-4179-9989-b974bf70f36f
# ╟─bd84b137-eae9-4cdb-a4d4-e0a4a4d86428
# ╟─8bf3502b-2c23-42cf-95a5-1cd10ec3d120
# ╟─223a5351-1aef-4459-a232-e9a675a805d8
# ╠═3efc0478-bc1c-4923-867e-0cebfad60438
# ╟─899f6c28-3530-4e73-9eac-631369e4db0f
# ╟─c86223c6-b58a-4b14-8bb3-8b45edbe83cd
# ╠═5a841f9c-da34-43db-99a2-1950b97a17b9
# ╟─6c29d1c6-97f6-490b-a7d3-fee1093baf9d
# ╟─dad8cf32-192a-4b41-8710-0057da974040
# ╠═84d611fa-4fb9-4f5b-981c-9b14d843f462
# ╟─73355c0c-f657-426e-8604-be02503803cb
# ╟─1615b1ae-d213-4ca4-903c-b71b80926020
# ╠═a9c6cc22-7309-4909-a0f5-a1bfbff76ccc
# ╟─b0449a53-aac0-4fb7-8821-a7d688645424
# ╟─3028f296-e137-4693-9105-4772f68fb5e3
# ╟─54e9f71a-8823-4513-8040-c89000593d0c
# ╟─def75434-3c62-4199-b589-e042c69ed6db
# ╠═cd238a0b-de24-4f7f-8da8-7605e33c10fc
# ╟─71e383f8-40e8-4b50-b5a8-96fba94cae04
# ╟─f4ef0ca6-dabc-4e5d-aa3b-d2d8ac6cdf66
# ╟─493b30a1-7b4e-41d7-8c62-e86537411833
# ╟─7380883e-5d53-46ba-a671-eb4526bfd728
# ╟─46c2ea57-a6af-4b5f-adf4-de7781c226de
# ╟─43c8d52f-f8b7-4490-b83b-9664f917ba2d
# ╠═0b6f5bf3-1027-4908-8cd8-d8515b691600
# ╟─c68b16b9-2ae0-4382-a80d-0330a66a71b4
# ╟─3566d4ab-c6d2-4ff9-bc2a-9a2a8820bad9
# ╟─68209a5f-2574-49c3-923f-8f68f14f21e1
# ╟─e7228ba3-1e70-4be0-bfac-a700e907bcb2
