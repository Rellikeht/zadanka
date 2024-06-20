### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 42b9be8a-f679-11ee-39a2-11193876cb5f
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="svg")
    
    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
    ###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)
    """
end

# ╔═╡ 80ae333e-6f67-4a13-accb-5681198de0fa
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
    </style>
    """
end

# ╔═╡ 8218993e-b216-4868-8d8b-b32ffb9771ae
md"""
## Zadanie 1
Obliczyć $I = \int^1_0 \frac{1}{1+x} dx$ wg wzoru prostokątów, trapezów i wzoru Simpsona (zwykłego i złożonego $n=3, 5$). Porównać wyniki i błędy.
"""

# ╔═╡ c61772cd-e7be-4eaf-a7a2-f63b37708161
begin
    const defaultH = 0.001
    const defaultN = 1000

    # Wzór prostokątów
    function rectangles(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        @simd for i in a:h:b
            result += f(i)
        end
        return result*h
    end
    function rectangles(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        rectangles(f,a,b,(b-a)/n)
    end

    # Wzór trapezów
    function trapezoidal(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        return rectangles(f,a,b,h)-(f(a)+f(b))*h/2
    end
    function trapezoidal(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        trapezoidal(f,a,b,(b-a)/n)
    end

    # Wzór simpsona
    function simpson(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        @simd for i in a:h:b-h
            result += f(i+h/2)
        end
        return trapezoidal(f, a, b, h)/3 + result*h*2/3
    end
    function simpson(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        simpson(f,a,b,(b-a)/n)
    end

    # Lekkie obliczeniowo wywołania wymuszające prekompilację funkcji
    const precompH = 0.001
    const precompN = 1000
    const precompF = x -> x^2
    const precompA = 1.0
    const precompB = 2.0
    for f in [rectangles, trapezoidal, simpson]
        _ = f(precompF, precompA, precompB, precompH)
        _ = f(precompF, precompA, precompB, precompN)
    end
    md"""
    """
end

# ╔═╡ 147fb8a8-e0dc-4267-9083-445de5e13bf6
md"""
W powyższych funkcjach korzystam z faktu, że h jest stałe,
więc mnożenie przez nie można wyciągnąć przed całkę i wykonać je raz
jednocześnie zmniejszając ilość mnożeń i błędów z nimi związanych

W metodzie trapezów wykorzystałem obserwację, że po rozwinięciu
wzór jest taki sam jak w metodzie prostokątów pomniejszonej o
$\frac{1}{2} f(a) \cdot h + \frac{1}{2} f(b) \cdot h$

W metodzie simpsona dzięki przemienności mnożenia mogłem wyciągnąć skrajne
wyrazy we wzorze i zauważyć, że jest to wynik metody trapezów podzielony przez 3
"""

# ╔═╡ 3d1946ab-3555-49e8-b601-5ee351e9b3c8
begin
    const f(x) = 1/(1+x)
    const true_value = log(2)
    const n = 10^8

    println("Właściwa wartość: $(true_value)")
    print("Prostokąty: ")
    @time println(rectangles(f, 0, 1, n))
    print("Trapezy: ")
    @time println(trapezoidal(f, 0, 1, n))
    print("Simpson: ")
    @time println(simpson(f, 0, 1, n))
end

# ╔═╡ 6b767df9-3df8-4af2-9772-3ca3d7a2f650
begin
    const benchN = 10^6
    md"""
    """
end

# ╔═╡ 7b6809ed-e21f-40d6-9fb6-b9eec88b1125
#@benchmark rectangles(f,0,1,benchN)

# ╔═╡ 85a56410-8739-43c8-a013-ce7b7e32c7c5
#@benchmark trapezoidal(f, 0, 1, benchN)

# ╔═╡ e57b4e8d-43e1-4450-89fd-8e00851cef8f
#@benchmark simpson(f, 0, 1, benchN)

# ╔═╡ e4091f31-5a98-433f-890e-ca586a8a35bf
begin
    function brectangles(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        return sum(f.(a:h:b))*h
    end
    function brectangles(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        brectangles(f,a,b,(b-a)/n)
    end
    _ = brectangles(precompF, precompA, precompB, precompH)
    _ = brectangles(precompF, precompA, precompB, precompN)
    #println(brectangles(f,0,1,benchN))
    #@benchmark brectangles(f,0,1,benchN)
    md"""
    """
end

# ╔═╡ 7579be63-1671-4b9f-9bf3-cf4dd1c1069a
begin
    up = 2
    down = 0

    const r3 = down:0.01:up
    p3 = Figure(size=(1920, 1080))
    ax3 = Axis(p3[1, 1])
    lines!(p3[1, 1], r3, up.-r3, color=c1, label="|sin x|", linewidth=lw)
    lines!(p3[1, 1], r3, r3, color=c2, label="S(x)", linewidth=lw, linestyle=:dash)
    axislegend(ax3, labelsize=50)
    p3
end

# ╔═╡ 5c74f413-9003-429d-91eb-4fe41fccbe30
begin

    legendre_coeffs = Vector{Vector{Float64}}(undef, points)
    for i in eachindex(legendre_coeffs)
        legendre_coeffs[i] = zeros(points+1)
    end
    legendre_coeffs[1][1] = 1
    legendre_coeffs[2][2] = 1
 
    legendre_polynomials = ""
    for i in eachindex(legendre_coeffs)
        legendre_polynomials *= "P_$(i-1) ="
        for j in eachindex(legendre_coeffs[i])
            c = legendre_coeffs[i][j]
            if c != 0
                global legendre_polynomials
                legendre_polynomials *= " "
                legendre_polynomials *= string(c)
                if j > 1
                    legendre_polynomials *= "x^"
                    legendre_polynomials *= string(j-1)
                end
            end
        end
        global legendre_polynomials *= " \\ \n"
    end

md"""
# Zadanie 2
Obliczyć całkę $I = \int_{-1}^1 \frac{1}{1+x^2} dx$ korzystając z wielomianów ortogonalnych (np. Czebyszewa) dla $n=8$.
"""
end

# ╔═╡ 8aa2cb8b-2ff2-4522-927f-2f0fd4afac7e
begin
    const defaultGLQN = 10^6

    function polyString(coeffs::Vector{Float64})::String
        i::Int = 1
        while i <= length(coeffs) && coeffs[i] == 0
            i += 1
        end
        if i > length(coeffs)
            return "0"
        end

        result::String = ""
        if i == 1
            result *= "$(coeffs[i])"
        else
            result *= "$(coeffs[i])x^$(i-1)"
        end
        i += 1

        while true
            while i <= length(coeffs) && coeffs[i] == 0
                i += 1
            end
            if i > length(coeffs)
                break
            end
            if coeffs[i] < 0
                result *= " -$(-coeffs[i])"
            else
                result *= " +$(coeffs[i])"
            end
            result *= "x^$(i-1)"
            i += 1
        end
        return result
    end

    function polyString(coeffs::Vector{Rational{Int}})::String
        i::Int = 1
        while i <= length(coeffs) && coeffs[i] == 0
            i += 1
        end
        if i > length(coeffs)
            return "0"
        end

        result::String = "("
        if i == 1
            result *= "$(coeffs[i]))"
        else
            result *= "$(coeffs[i]))x^$(i-1)"
        end
        i += 1

        while true
            while i <= length(coeffs) && coeffs[i] == 0
                i += 1
            end
            if i > length(coeffs)
                break
            end
            if coeffs[i] < 0
                result *= " - ($(-coeffs[i])"
            else
                result *= " + ($(coeffs[i])"
            end
            result *= ")x^$(i-1)"
            i += 1
        end
        return result
    end

    function legCoeffs(n::Int)::Vector{Vector{Rational{Int}}}
        legendre_coeffs = Vector{Vector{Rational{Int}}}(undef, n)
        legendre_coeffs[1] = zeros(n + 1)
        legendre_coeffs[1][1] = 1
        legendre_coeffs[2] = zeros(n + 1)
        legendre_coeffs[2][2] = 1

        for i in 3:n
            c = deepcopy(legendre_coeffs[i-1])
            @simd for j in length(c):-1:2
                c[j] = c[j-1] * (2 * i - 3) / (i - 1)
            end
            c[1] = 0
            @simd for j in eachindex(c)
                c[j] += legendre_coeffs[i-2][j] * (i - 2) / (i - 1)
            end
            legendre_coeffs[i] = c
        end
        return legendre_coeffs
    end

    const legendre_points = 8
    precompP3 = legCoeffs(3)
    const legendre_coeffs = legCoeffs(legendre_points)

    function leg(d::Int, x::Float64)::Float64
        result::Float64 = legendre_coeffs[d][1]
        pow::Float64 = 1
        @simd for i in 2:d+1
            pow *= x
            result += pow*legendre_coeffs[d][i]
        end
        return result
    end
    function leg(d::Int, x::Int)::Float64
        leg(d, Float64(x))
    end
    _ = leg(2, 1)

    function glQuadC(f::Function, n::Int)::Vector{Float64}
        c = Vector{Float64}(undef, n)
        @simd for i in 1:n
            c[i] = simpson(x -> f(x)*leg(i, x), -1, 1, defaultGLQN)
            c[i] /= simpson(x -> leg(i, x)^2, -1, 1, defaultGLQN)
        end
        return c
    end

    _ = f2(3.0)
    _ = glQuadC(f2, 1)
    const gauss_coeffs = glQuadC(f2, legendre_points)
    const icoeffs = let cs::Vector{Float64} = [0]
        push!(cs, sum((gauss_coeffs.*legendre_coeffs))...)
        cs
    end
    @simd for i in 3:length(icoeffs)
        icoeffs[i] /= (i-1)
    end
    myint2 = sum(icoeffs)
    @simd for i in eachindex(icoeffs)
        global myint2 += (-1)^(i)*icoeffs[i]
    end

    # for p in eachindex(legendre_coeffs)
    #   println("P_$(p-1) = $(polyString(legendre_coeffs[p]))")
    # end
    md"""
    """
end

# ╔═╡ 3f67e1c5-a958-4050-b8e3-06ea5f972278
md"""
# Zadanie Domowe 1
Obliczyć całkę $\int_0^1 \frac{1}{1+x2} dx$ korzystając ze wzoru prostokątów dla $h=0.1$ oraz metody całkowania adaptacyjnego.
"""

# ╔═╡ 0a9ee599-89f7-4aef-8807-66aec6e1552b
md"""
# Zadanie Domowe 2
Metodą Gaussa obliczyć następującą całkę $\int^1_0 \frac{1}{x+3} dx$ dla $n=4$. Oszacować resztę kwadratury.
"""

# ╔═╡ Cell order:
# ╟─42b9be8a-f679-11ee-39a2-11193876cb5f
# ╟─80ae333e-6f67-4a13-accb-5681198de0fa
# ╟─8218993e-b216-4868-8d8b-b32ffb9771ae
# ╠═c61772cd-e7be-4eaf-a7a2-f63b37708161
# ╟─147fb8a8-e0dc-4267-9083-445de5e13bf6
# ╠═3d1946ab-3555-49e8-b601-5ee351e9b3c8
# ╟─6b767df9-3df8-4af2-9772-3ca3d7a2f650
# ╟─7b6809ed-e21f-40d6-9fb6-b9eec88b1125
# ╟─85a56410-8739-43c8-a013-ce7b7e32c7c5
# ╟─e57b4e8d-43e1-4450-89fd-8e00851cef8f
# ╟─e4091f31-5a98-433f-890e-ca586a8a35bf
# ╠═7579be63-1671-4b9f-9bf3-cf4dd1c1069a
# ╟─5c74f413-9003-429d-91eb-4fe41fccbe30
# ╟─8aa2cb8b-2ff2-4522-927f-2f0fd4afac7e
# ╟─3f67e1c5-a958-4050-b8e3-06ea5f972278
# ╟─0a9ee599-89f7-4aef-8807-66aec6e1552b
