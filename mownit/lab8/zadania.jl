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
    using LinearAlgebra

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
##### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)

# Zestaw 8: Układy równań – metody bezpośrednie

###    Napisz program, który:

###### 1.     Jako parametr pobiera rozmiar układu równań $n$
###### 2.     Generuje macierz układu $A_{(nxn)}$ i wektor wyrazów wolnych $b_{(n)}$
###### 3.     Rozwiązuje układ równań $~A x = b~$ na trzy sposoby:

- a. poprzez  dekompozycję LU macierzy A: $A = L U$
- b. poprzez odwrócenie macierzy A: $x=A^{-1}b$, sprawdzić czy $A A^{-1}=I$ i $A^{-1}A=I$ (macierz jednostkowa)
- c. poprzez dekompozycję QR macierzy A: $A=QR$.

###### 4.     Sprawdzić poprawność rozwiązania (tj., czy $Ax=b$)
###### 5.     Zmierzyć całkowity czas rozwiązania układu.
###### 6.     Porównać czasy z trzech sposobów: poprzez dekompozycję LU, poprzez odwrócenie macierzy i poprzez dekompozycję QR 

#### Zadanie domowe:
Narysuj wykres zależności całkowitego czasu rozwiązywania układu
(LU, QR, odwrócenie macierzy) od rozmiaru układu równań.
Wykonaj pomiary dla 5 wartości z przedziału od 10 do 100.

Uwaga: można się posłużyć funkcjami z biblioteki numerycznej dla danego języka programowania.
    """
end

# ╔═╡ 31849fb0-ca26-4923-8bb0-9737e3fea5e3
begin
    const FRange = StepRangeLen{Float64,Float64,Float64,Int}
    const c1 = "#ff6600"
    const c2 = "#0000a8d8"
    const c3 = "#ff0000cf"

    const titlesize = 45
    const labelsize = 34
    const ticksize = 27

    # const rw = 1e-4
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

# ╔═╡ 736cadf2-ab44-4d96-a3ba-530b08efade7


# ╔═╡ b671c29a-c0c4-4ed2-8faa-f02f5d41a9a3
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 4a81158b-aa5a-47d9-844f-e7aa6fbab2f0
md"""
#### Funkcje pomocnicze
"""

# ╔═╡ 66259794-6e43-4032-ad15-84edf480bc16
begin
    import Base: rand, convert
    function rand(
        ::Type{Rational{T}},
        n::Int
    )::Vector{Rational{T}} where {T<:Integer}
        result::Vector{Rational{T}} = zeros(Rational{T}, n)
        @simd for i in eachindex(result)
            result[i] = rand(T)
        end
        return result
    end
    function rand(
        ::Type{Rational{T}},
        dims::Tuple{Vararg{Int,N}} where {N}
    )::Matrix{Rational{T}} where {T<:Integer}
        result::Matrix{Rational{T}} = zeros(Rational{T}, dims)
        @simd for i in eachindex(result)
            result[i] = rand(T)
        end
        return result
    end

    begin
        _ = rand(Rational{Int}, 1)
        _ = rand(Rational{Int}, (1, 2))
    end

    md""""""
end

# ╔═╡ d59d65a9-32a5-48c7-8f97-3c8846823765
md"""
#### Generacja układów równań
"""

# ╔═╡ 49480f90-176d-403b-85fa-9fee46a0bc6d
begin
    const min_r = -10000
    const max_r = 10000
    const default_intr = min_r:1:max_r
    const default_floatr::FRange = min_r:0.0001:max_r
    const default_ratr = min_r:1//10000:max_r

    function generateSystem(
        n::Int,
        r::Union{StepRangeLen{T,R,S,L},StepRange{T,T}}=default_floatr
    )::Tuple{Matrix{T},Vector{T}} where
    {T<:Union{Int,Float64,Rational{Int}},R,S,L<:Int}
        (rand(r, (n, n)), rand(r, n))
    end

    md""""""
end

# ╔═╡ 1e164969-34da-4050-a1af-8f662c2a5cc7
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ e8078ba9-c9e9-43f4-b9c6-d6f1c0b6747c
md"""
#### Rozwiązywanie układów równań
"""

# ╔═╡ fe98ca74-b169-4258-b23a-560e3d1ea0f2
begin
    const RatT = Rational{Int}

    # Podpunkt 3a
    function solveLU(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        lu(A) \ b
    end
    function solveLU(
        s::Tuple{Matrix{T},AbstractArray{T,1}}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        solveLU(s...)
    end

    # Podpunkt 3b
    function solveSystem(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        inv(A) * b
    end
    function solveSystem(
        s::Tuple{Matrix{T},AbstractArray{T,1}}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        solveSystem(s...)
    end

    # Podpunkt 3c
    function solveQR(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        qr(A) \ b
    end
    function solveQR(
        s::Tuple{Matrix{T},AbstractArray{T,1}}
    )::Vector{T} where {T<:Union{Float64,RatT}}
        solveQR(s...)
    end

    begin # Prekompilacja
        _ = generateSystem.(1, [default_intr, default_floatr, default_ratr])
        for f in [solveSystem, solveLU, solveQR]
            _ = f(([1.0 2.0; 3.0 4.0], [5.0, 6.0]))
            _ = f([1//1 2//1; 3//1 4//1], [5 // 1, 6 // 1])
        end
    end

    md""""""
end

# ╔═╡ 89b1f13a-56ee-4142-92ec-1a9b4a18dba6
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ d7dd587b-4931-49de-8448-94692c28f40e
md"""
#### Sprawdzenie poprawności dla wybranych rozmiarów
"""

# ╔═╡ 61b5a320-4492-4795-a4c1-f4393bdf032f
begin
    const defaultTol = 8

    # Funkcja rzuca wyjątek, gdy któreś rozwiązanie nie będzie się zgadzało
    function testSystem(n::Int, tol::Int=defaultTol)
        A::Matrix{Float64}, b::Vector{Float64} = generateSystem(n)
        s1::Vector{Float64} = round.(solveLU(A, b), sigdigits=tol)
        s2::Vector{Float64} = round.(solveSystem(A, b), sigdigits=tol)
        s3::Vector{Float64} = round.(solveQR(A, b), sigdigits=tol)
        if s1 != s2 || s2 != s3
            throw(ErrorException("Wyniki 3 metod różnią się"))
        end
    end
    @time begin
        testSystem(1)
    end

    # Sprawdzenie dla różnych wielkości układu
    @time begin
        for s in [3, 5, 10, 20, 50, 100]
            for i in 1:5
                testSystem(s)
            end
        end
    end

    md"""
    """
end

# ╔═╡ f675a366-7e13-4e89-b3e7-81259e4f5eb5
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 805276e4-53ce-4efc-89c6-749f025b32d6
md"""
#### Porównanie wydajności
"""

# ╔═╡ 1a444078-c962-4fe0-96e4-e0c02f0ce73c
begin
    const s1size = 20
    const s1 = generateSystem(s1size)
    const s2size = 50
    const s2 = generateSystem(s2size)

    md""""""
end

# ╔═╡ 6b9f72f3-3d40-4a2c-96a4-e1e23c409b2f
md"""
##### Dla układu równań o wielkości $(s1size):
"""

# ╔═╡ 8de6e1d1-411f-4fc9-8cfc-d0fe7a4793e8
md"""
###### Metoda LU
"""

# ╔═╡ b216b0e3-f6cf-42af-ac42-a1b2cf08c378
@benchmark solveLU(s1...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ 86e2dfe9-4f6f-4b07-828f-69becf571db3
md"""
###### Odwracanie macierzy
"""

# ╔═╡ 4fef6103-f6ab-48de-9612-0f93fc11e615
@benchmark solveSystem(s1...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ e60f7c34-b844-4d03-ae01-88491828f6c2
md"""
###### Metoda QR
"""

# ╔═╡ 8af97ec4-e363-455e-8b6d-47640882f023
@benchmark solveQR(s1...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ bd2995bd-a7d7-4f43-986c-1f074f6e2bb0
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ ecf2f707-1f04-407b-ac75-6d8191f3f34d
md"""
##### Dla układu równań o wielkości $(s2size):
"""

# ╔═╡ 65992756-21af-4c84-952f-46d64620be60
md"""
###### Metoda LU
"""

# ╔═╡ 50261e51-da2d-4a15-acb0-6557637f305b
@benchmark solveLU(s2...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ 0f04ef11-b9d1-4021-93aa-ca0b5663d377
md"""
###### Odwracanie macierzy
"""

# ╔═╡ 9e8fbb8f-1d3e-4a5a-869d-2f13af81012b
@benchmark solveSystem(s2...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ 6c41438d-d99d-44f9-b916-7cd478a59f25
md"""
###### Metoda QR
"""

# ╔═╡ 5d29d704-be99-47a6-851b-faa250adf1f9
@benchmark solveQR(s2...) seconds = 30 samples = 1000 evals = 50

# ╔═╡ 0c8786a3-d8f1-459e-8017-a08e51e5f407
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 1548119e-afaf-44b8-98b9-173c35b2bf73
md"""
#### Zadanie domowe
"""

# ╔═╡ 925611e5-39a0-44b9-97e5-11dc59a6dc3a
md"""
##### Dla typu zmiennoprzecinkowego
"""

# ╔═╡ 83225e37-4265-43f2-b709-e4e93d14ed2c
begin
    const solve_runs = 100
    const size_values = [10,20,40,60,80,100]
	const big_values = [100, 200, 500, 700, 1000]
    const fdesc = Dict(
        string(nameof(solveSystem)) => "Odwracanie macierzy",
        string(nameof(solveLU)) => "Dekompozycja LU",
        string(nameof(solveQR)) => "Dekompozycja QR",
    )

    function solveTimes(
        f::F,
        s::Vector{Tuple{Matrix{Float64},Vector{Float64}}}
    )::Vector{Float64} where {F<:Function}
        results::Vector{Float64} = zeros(length(s))
        for i in eachindex(results)
            for _ in 1:solve_runs
                results[i] += @elapsed f(s[i])
            end
            results[i] /= solve_runs
            # results[i] = @elapsed f(s[i])
            # results[i] = @belapsed $f($s[$i]) samples = solve_runs evals = 1
        end
        return results
    end

    function plotTimes(
        fs::Vector{F},
        sizes::Vector{Int},
        range::Union{FRange,StepRange}=default_floatr
    )::Figure where {F<:Function}
        systems::Vector{Tuple{Matrix{Float64},Vector{Float64}}} =
            (s -> generateSystem(s, range)).(sizes)

        fig = Figure(size=(plx, ply))
        ax = Axis(
            fig[1, 1],
            xlabel="Wielkość układu",
            ylabel="Średni czas potrzebny na rozwiązanie [s]",
            xlabelsize=labelsize,
            ylabelsize=labelsize,
            xticklabelsize=ticksize,
            yticklabelsize=ticksize,
            # xticksize=50.0,
            # yticksize=10.0,
        )

        for i in eachindex(fs)
            times = solveTimes(fs[i], systems)
            lines!(
                ax,
                sizes,
                times,
                label=fdesc[string(nameof(fs[i]))]
            )
            scatter!(
                ax,
                sizes,
                times,
                markersize=15,
                color=:red
            )
        end
        axislegend(ax, labelsize=labelsize, position=:rb)
        return fig
    end

    let
        _ = solveTimes(solveSystem, [generateSystem(1)])
        _ = plotTimes([solveSystem, solveLU], [1, 2])
    end

    @time plotTimes([solveLU, solveSystem, solveQR], size_values)
end

# ╔═╡ 4f789f66-4554-4c95-9345-b7786e3b023b
begin
    @time plotTimes([solveLU, solveSystem, solveQR], big_values, default_floatr)
end

# ╔═╡ 43ee76ab-0869-4a95-b91a-69ab1faaf237
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ fdc835ec-3d86-4e02-b6c2-126350f2965f
md"""
##### Dla typu wymiernego
"""

# ╔═╡ a71c166a-4d32-4028-8c2d-7310c413c816
begin
    @time plotTimes([solveLU, solveSystem, solveQR], size_values, default_ratr)
end

# ╔═╡ 81778d93-cfb3-41e5-8506-efc237159d9c
begin
    @time plotTimes([solveLU, solveSystem, solveQR], big_values, default_ratr)
end

# ╔═╡ 9dac1e02-1dd2-4d75-9d6f-447faef2228d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 7f1ba504-0f95-44e9-a69e-7be8b9bc505b
md"""
### Wnioski:
- typ zmiennoprzecinkowy i wymierny radzi sobie równie dobrze,
  przynajmniej w testach, które wykonałem
- rozkład qr jest lepszy od odwracania macierzy dopiero dla
  dużych wartości, może to być spowodowane róznorakimi
  optymalizacjami bibliotek albo ich brakiem

### Bibliografia:
- wykład
- linki pomocnicze do zadania
- https://discourse.julialang.org/t/use-qr-factorization-efficiently/8615
- https://www.matecdev.com/posts/julia-efficient-solution-linear-systems.html
"""

# ╔═╡ Cell order:
# ╟─7a3181e2-0793-11ef-3ce1-b5de7460754d
# ╟─31849fb0-ca26-4923-8bb0-9737e3fea5e3
# ╟─736cadf2-ab44-4d96-a3ba-530b08efade7
# ╟─b671c29a-c0c4-4ed2-8faa-f02f5d41a9a3
# ╟─4a81158b-aa5a-47d9-844f-e7aa6fbab2f0
# ╠═66259794-6e43-4032-ad15-84edf480bc16
# ╟─d59d65a9-32a5-48c7-8f97-3c8846823765
# ╠═49480f90-176d-403b-85fa-9fee46a0bc6d
# ╟─1e164969-34da-4050-a1af-8f662c2a5cc7
# ╟─e8078ba9-c9e9-43f4-b9c6-d6f1c0b6747c
# ╠═fe98ca74-b169-4258-b23a-560e3d1ea0f2
# ╟─89b1f13a-56ee-4142-92ec-1a9b4a18dba6
# ╟─d7dd587b-4931-49de-8448-94692c28f40e
# ╠═61b5a320-4492-4795-a4c1-f4393bdf032f
# ╟─f675a366-7e13-4e89-b3e7-81259e4f5eb5
# ╟─805276e4-53ce-4efc-89c6-749f025b32d6
# ╠═1a444078-c962-4fe0-96e4-e0c02f0ce73c
# ╟─6b9f72f3-3d40-4a2c-96a4-e1e23c409b2f
# ╟─8de6e1d1-411f-4fc9-8cfc-d0fe7a4793e8
# ╠═b216b0e3-f6cf-42af-ac42-a1b2cf08c378
# ╟─86e2dfe9-4f6f-4b07-828f-69becf571db3
# ╠═4fef6103-f6ab-48de-9612-0f93fc11e615
# ╟─e60f7c34-b844-4d03-ae01-88491828f6c2
# ╠═8af97ec4-e363-455e-8b6d-47640882f023
# ╟─bd2995bd-a7d7-4f43-986c-1f074f6e2bb0
# ╟─ecf2f707-1f04-407b-ac75-6d8191f3f34d
# ╟─65992756-21af-4c84-952f-46d64620be60
# ╠═50261e51-da2d-4a15-acb0-6557637f305b
# ╟─0f04ef11-b9d1-4021-93aa-ca0b5663d377
# ╠═9e8fbb8f-1d3e-4a5a-869d-2f13af81012b
# ╟─6c41438d-d99d-44f9-b916-7cd478a59f25
# ╠═5d29d704-be99-47a6-851b-faa250adf1f9
# ╟─0c8786a3-d8f1-459e-8017-a08e51e5f407
# ╟─1548119e-afaf-44b8-98b9-173c35b2bf73
# ╟─925611e5-39a0-44b9-97e5-11dc59a6dc3a
# ╟─83225e37-4265-43f2-b709-e4e93d14ed2c
# ╟─4f789f66-4554-4c95-9345-b7786e3b023b
# ╟─43ee76ab-0869-4a95-b91a-69ab1faaf237
# ╟─fdc835ec-3d86-4e02-b6c2-126350f2965f
# ╟─a71c166a-4d32-4028-8c2d-7310c413c816
# ╟─81778d93-cfb3-41e5-8506-efc237159d9c
# ╟─9dac1e02-1dd2-4d75-9d6f-447faef2228d
# ╟─7f1ba504-0f95-44e9-a69e-7be8b9bc505b
