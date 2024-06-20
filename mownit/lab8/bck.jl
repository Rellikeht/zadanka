### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 7a3181e2-0793-11ef-3ce1-b5de7460754d
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    # using Tables
    # using MarkdownTables
    # using DataFrames
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

###### 1.     Jako parametr pobiera rozmiar układu równań n
###### 2.     Generuje macierz układu A(nxn) i wektor wyrazów wolnych b(n)
###### 3.     Rozwiązuje układ równań Ax=b na trzy sposoby:

- a. poprzez  dekompozycję LU macierzy A: A=LU;
- b. poprzez odwrócenie macierzy A: x=A-1 b, sprawdzić czy AA-1=I i A-1A=I (macierz jednostkowa)
- c. poprzez dekompozycję QR macierzy A: A=QR.

###### 4.     Sprawdzić poprawność rozwiązania (tj., czy Ax=b)
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

# ╔═╡ b671c29a-c0c4-4ed2-8faa-f02f5d41a9a3
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 66259794-6e43-4032-ad15-84edf480bc16
begin
    import Base: rand
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

# ╔═╡ fe98ca74-b169-4258-b23a-560e3d1ea0f2
begin
    # Podpunkt 2
    struct generateSystem{T} end
    function generateSystem{T}(
        n::Int,
    )::Tuple{Matrix{T},Vector{T}} where {T}
        if T != Float64 && T != Rational{Int}
            throw(ErrorException("Niepoprawny typ liczb w układzie równań"))
        end
        (rand(T, (n, n)), rand(T, n))
    end
    function generateSystem(n::Int)::Tuple{Matrix{Float64},Vector{Float64}}
        return generateSystem{Float64}(n)
    end

    # Podpunkt 3a
    function solveLU(
        A::Matrix{Float64},
        b::AbstractArray{Float64,1}
    )::Vector{Float64}
        L::Matrix{Float64}, U::Matrix{Float64} = lu(A, NoPivot())
        y::Vector{Float64} = L \ b
        return U \ y
    end
    function solveLU(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{Rational{Int}} where {T<:Union{Int,Rational{Int}}}
        L::Matrix{Rational{Int}}, U::Matrix{Rational{Int}} = lu(A, NoPivot())
        y::Vector{Rational{Int}} = L \ b
        return U \ y
    end
        # L::LowerTriangular{T}, U::UpperTriangular{T} = lu(A, NoPivot())
        # return U \ (L \ b)
        # y::Vector{T} = L \ b
        # return U \ y

    # Podpunkt 3b
    function solveSystem(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{Union{Float64,Rational{Int}}} where
    {T<:Union{Int,Float64,Rational{Int}}}
        A \ b
    end

    # Podpunkt 3c
    function solveQR(
        A::Matrix{T},
        b::AbstractArray{T,1}
    )::Vector{Float64} where {T<:Union{Int,Float64}}
        Q::Matrix{Float64}, R::Matrix{Float64} = qr(A, NoPivot())
        y::Vector{Float64} = transpose(Q) * b
        return R \ y
    end
        # Q::Matrix{T}, R::Matrix{T} = qr(A, NoPivot())
        # Q, R = qr(A, NoPivot())
        # Q, R = qr(A)
        # return inv(factorize(R)) * transpose(Q) * b
        # return factorize(R) \ (transpose(Q) * b)

    # function solveQR(
    #     A::Matrix{Float64},
    #     b::AbstractArray{Float64,1}
    # )::Vector{Float64}
    # function solveQR(
    #     A::Matrix{T},
    #     b::AbstractArray{T,1}
    # )::Vector{Rational{Int}} where {T<:Union{Int,Rational{Int}}}
    #     ar::Matrix{Rational{Int}} = Rational{Int}.(A)
    #     Q::Matrix{Rational{Int}}, R::Matrix{Rational{Int}} = qr(ar)
    #     y::Vector{Rational{Int}} = transpose(Q) * b
    #     println(Q)
    #     println(R)
    #     println(y)
    #     return R \ y
    # end

    @time begin
        _ = 1 // 2 + 3 // 4 * 5 // 6
        _ = generateSystem(1)
        _ = generateSystem{Rational{Int}}(1)
        for f in [solveSystem, solveLU, solveQR]
            _ = f([1 2; 3 4], [5, 6])
            # _ = f([1//1 2//1; 3//1 4//1], [5 // 1, 6 // 1])
            _ = f([1.0 2.0; 3.0 4.0], [5.0, 6.0])
        end
        _ = solveSystem([1//1 2//1; 3//1 4//1], [5 // 1, 6 // 1])
        _ = solveLU([1//1 2//1; 3//1 4//1], [5 // 1, 6 // 1])
    end

    md""""""
end

# ╔═╡ 89b1f13a-56ee-4142-92ec-1a9b4a18dba6
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 61b5a320-4492-4795-a4c1-f4393bdf032f
begin
    # Podpunkt 4
    function testSystem(n::Int)
        A::Matrix{Float64}, b::Vector{Float64} = generateSystem{Float64}(n)
        s1::Vector{Float64} = solveLU(A, b)
        s2::Vector{Float64} = solveSystem(A, b)
        s3::Vector{Float64} = solveQR(A, b)

        # TODO
        return ()
    end

        # ranges::Union{Vector{FRange},FRange}=default_floatr
        # if isa(ranges, Vector{FRange})
        #     if length(sizes) != length(ranges)
        #         throw(
        #             ErrorException(
        #                 "Zła ilość zakresów lub wielkości układu"
        #             )
        #         )
        #     end
        # end


    @time begin
        _ = testSystem(1)
    end
    md"""
    """
end

# ╔═╡ f675a366-7e13-4e89-b3e7-81259e4f5eb5
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 7f1ba504-0f95-44e9-a69e-7be8b9bc505b
md"""
### Bibliografia:
- wykład
- linki pomocnicze do zadania
"""

# ╔═╡ Cell order:
# ╟─7a3181e2-0793-11ef-3ce1-b5de7460754d
# ╟─31849fb0-ca26-4923-8bb0-9737e3fea5e3
# ╟─b671c29a-c0c4-4ed2-8faa-f02f5d41a9a3
# ╠═66259794-6e43-4032-ad15-84edf480bc16
# ╠═fe98ca74-b169-4258-b23a-560e3d1ea0f2
# ╟─89b1f13a-56ee-4142-92ec-1a9b4a18dba6
# ╠═61b5a320-4492-4795-a4c1-f4393bdf032f
# ╟─f675a366-7e13-4e89-b3e7-81259e4f5eb5
# ╟─7f1ba504-0f95-44e9-a69e-7be8b9bc505b
