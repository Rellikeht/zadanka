### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 308ed8e8-fbf5-11ee-1968-714be3777df4
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
    ###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)
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
    </style>
    """
end

# ╔═╡ e70f5821-2fc8-46cf-8664-8742ca09d18d
md"""
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

# ╔═╡ bd84b137-eae9-4cdb-a4d4-e0a4a4d86428
md"""
##### Kod:
"""

# ╔═╡ 481d2e0e-1e88-4138-b3f4-8291eba0f3b7
# @benchmark find(bf, bc[3], bc[3]) samples=1000 evals=50

# ╔═╡ 96bee331-4c9d-4bd8-b388-1923f18b93b8
begin
    # Domyślne wartości h i n
    const defaultH = 0.001
    const defaultE = 0.001

    # Wzór prostokątów
    function rectangle(
        f::Function,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        x::Float64 = h / 2
        y::Float64 = f(x)
        while y > e
            result += y
            x += h
            y = f(x)
        end
        return 2 * result * h
    end

    # Wzór trapezów
    function trapezoidal(
        f::Function,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64
        x::Float64 = h
        y::Float64 = f(x)
        result::Float64 = y / 2
        while y > e
            result += y
            x += h
            y = f(x)
        end
        return 2 * h * result
    end

    # Wzór simpsona
    function simpson(
        f::Function,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        x::Float64 = h
        y::Float64 = f(x)
        while y > e
            result += y
            x += 2 * h
            y = f(x)
        end
        return 2 * (trapezoidal(f, e, h) + 2 * result * h) / 3
    end

    # Prekompilacja funkcji
    @time begin
        function precompF(x::Float64)::Float64
    1/(ℯ^x^2)
end
        for f in [rectangle, trapezoidal, simpson]
            _ = f(precompF, 0.1, 0.1)
            _ = f(precompF, 0.0001, 0.0001)
        end
        md"""
        """
    end
end

# ╔═╡ a007ec04-33d8-4cad-8a22-5cf013509a68
begin
    function bf(x::Float64)::Float64
        1/(1+x^2)
    end
    
    function r1(
        f::F,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        result::Float64 = 0
        x::Float64 = h / 2
        y::Float64 = f(x)
        while y > e
            result += y
            x += h
            y = f(x)
        end
        return 2 * result * h
    end

    function find(
        f::F,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        a::Float64 = 0
        b::Float64 = 1.0
        y::Float64 = f(b)
        mid::Float64 = 0
        while y > e
            b *= 2
            y = f(b)
        end
        while b-a > h
            mid = (a+b)/2
            y = f(mid)
            if y < e
                b = mid
            else
                a = mid
            end
        end
        return mid
    end

    function r2(
        f::F,
        e::Float64=defaultE,
        h::Float64=defaultH
    )::Float64 where {F<:Function}
        result::Float64 = 0
        xend::Float64 = find(f,e,h)
		# x::Float64 = h/2
		# while x <= xend
		# 	result += f(x)
		# 	x += h
		# end
		rng::StepRangeLen{Float64, Float64, Float64, Int} = (h/2.0):h:xend
        @simd for x in rng
            result += f(x)
        end
        return 2 * result * h
    end

    @time begin
        # _ = bf(1.0)
        # println(find(bf, 0.1, 0.1))
        # println(find(bf, 0.0001, 0.0001))
        # println()
        _ = find(bf, 0.1, 0.1)
        _ = find(bf, 0.0001, 0.0001)
        println(π)

        for f in [r1, r2]
            print(f(bf, 0.1, 0.1))
            print(" ")
            print(f(bf, 0.01, 0.01))
            print(" ")
            print(f(bf, 0.001, 0.001))
            print(" ")
            println(f(bf, 0.0001, 0.0001))
            print(" ")
            println(f(bf, 0.00001, 0.00001))
            print(" ")
            println(f(bf, 0.000001, 0.000001))
        end
    end

    const bc = [1e-2,1e-3,1e-4,1e-5,1e-6]
    # bs = []
 #    c = 0
 #    for i in bc
 #        global c = i
 #        push!(bs, @benchmark r1(bf, c, c))
 #        push!(bs, @benchmark r2(bf, c, c))
 #    end
    # print.(bs)
    md"""
    """
end

# ╔═╡ 1fb5c3a3-28f9-426e-8226-867d0a4e0b88
@benchmark r1(bf, bc[1], bc[1]) samples=1000 evals=50

# ╔═╡ ccb587a4-9df4-433d-ba41-b1fb976ee70a
@benchmark r2(bf, bc[1], bc[1]) samples=1000 evals=50

# ╔═╡ 1bc3c679-7a5f-4d14-a0c5-d8d9475866cb
@benchmark r1(bf, bc[2], bc[2]) samples=1000 evals=50 seconds=120

# ╔═╡ 9dd52312-f203-4b9e-98d8-a3d6367f990c
@benchmark r2(bf, bc[2], bc[2]) samples=1000 evals=50 seconds=120

# ╔═╡ 45434b9b-115e-4d79-968c-41232dd3b16b
@benchmark r1(bf, bc[3], bc[3]) samples=500 evals=50 seconds=120

# ╔═╡ fd51e76f-9b7f-4a85-831f-7ea0b5e37c95
@benchmark r2(bf, bc[3], bc[3]) samples=500 evals=50 seconds=120

# ╔═╡ ea76b663-3fed-45dc-8761-7583fde666b9
begin
    function f(x::Float64)::Float64
        ℯ^(-x^2) * cos(x)
    end
    const real_value = 1/ℯ^(1/4) * sqrt(π)
    const txs = 1:6
    const tvalues = (x -> 1 / 10^x).(txs)
    const fig = Figure(size=(1280, 720))
    const ax = Axis3(
        fig[1, 1],
        aspect=(10.0,10.0,2.0),
        xlabel="ε",
        ylabel="h",
        zlabel="wartość całki"
    )

    surface!(
        ax,
        txs,
        txs,
        [real_value for h in tvalues, e in tvalues],
        ssao=true,
        colormap=:deep,
        alpha=0.7
    )

    surface!(
        ax,
        txs,
        txs,
        [rectangle(f, e, h) for e in tvalues, h in tvalues],
        ssao=true,
        colormap=:darkterrain,
        alpha=0.6
    )

    surface!(
        ax,
        txs,
        txs,
        [trapezoidal(f, e, h) for e in tvalues, h in tvalues],
        ssao=true,
        colormap=:julia,
        alpha=0.6
    )

    surface!(
        ax,
        txs,
        txs,
        [simpson(f, e, h) for e in tvalues, h in tvalues],
        ssao=true,
        colormap=:nord,
        alpha=0.6
    )

    fig
end

# ╔═╡ 6b17eb7d-db27-4abb-9785-e29f5ebb175b
begin
    (real_value, rectangle(f, 0.0001, 0.0001))
end

# ╔═╡ e7228ba3-1e70-4be0-bfac-a700e907bcb2
CairoMakie.available_gradients()

# ╔═╡ c60861c7-e9e3-4fe6-a627-b29e8acaef12
# begin

# 	println("real: ", real_value)
# 	for i in 2:N
# 		#println(xk[i])
# 		println(A[i])
# 		println(i, ": ", gaussHermite(i, f))
# 		println()
# 	end
# end

	# fig3 = Figure(size=(1280,720))
	# ax3 = Axis(fig3[1,1])
	# const r3 = -4:0.001:4
	# #for p in Hf[1:5]
	# #	lines!(fig3[1,1], r3, p.(r3))
	# #end
	# fig3

# ╔═╡ dfae65bc-3640-454f-9b43-4f3b9829484e
# begin
#     # Wzór trapezów
#     function trapezoidal(
#         f::F,
#         ε::Float64=defaultE,
#         h::Float64=defaultH
#     )::Float64 where {F<:Function}
#         x::Float64 = h
#         y::Float64 = f(x)
#         result::Float64 = f(0.0)
#         while y > ε
#             result += y
#             x += h
#             y = f(x)
#         end
# 		result += y/2

#         x = -h
#         y = f(x)
#         while y > ε
#             result += y
#             x -= h
#             y = f(x)
#         end
# 		result += y/2

# 		return h*result
#     end
	
# 	begin
# 		_ = trapezoidal(f, 0.1, 0.1)
# 		_ = trapezoidal(f, 0.001, 0.001)
# 	end
# 	md"""
# 	"""
# end

# ╔═╡ 211b2155-464b-4fc7-a31c-541ce7145f49
# begin
#     # Wzór simpsona
#     function simpson(
#         f::F,
#         ε::Float64=defaultE,
#         h::Float64=defaultH
#     )::Float64 where {F<:Function}
#         result::Float64 = 0
#         x::Float64 = h
#         y::Float64 = f(x)
#         while y > ε
#             result += y
#             x += 2 * h
#             y = f(x)
#         end

# 		x = -h
#         y = f(x)
#         while y > ε
#             result += y
#             x -= 2 * h
#             y = f(x)
#         end

#         return 2 * (trapezoidal(f, ε, h) + result * h) / 3
#     end	

# 	begin
# 		_ = simpson(f, 0.1, 0.1)
# 		_ = simpson(f, 0.001, 0.001)
# 	end
# 	md"""
# 	"""
# end

# ╔═╡ c2e633d9-24d3-4968-b79e-abad0661a141
# begin
#     # Wzór prostokątów
#     function rectangle(
#         f::F,
#         e::Float64=defaultE,
#         h::Float64=defaultH
#     )::Float64 where {F<:Function}
#         result::Float64 = 0
#         x::Float64 = h / 2
#         y::Float64 = f(x)
#         while abs(y) > e
#             result += y
#             x += h
#             y = f(x)
#         end
# 		result += y

# 		x = -h / 2
#         y = f(x)
#         while abs(y) > e
#             result += y
#             x -= h
#             y = f(x)
#         end
# 		result += y

# 		return result*h
#     end

#     # Wzór trapezów
#     function trapezoidal(
#         f::F,
#         e::Float64=defaultE,
#         h::Float64=defaultH
#     )::Float64 where {F<:Function}
#         x::Float64 = h
#         y::Float64 = f(x)
#         result::Float64 = f(0.0)
#         while y > e
#             result += y
#             x += h
#             y = f(x)
#         end
# 		result += y/2

#         x = -h
#         y = f(x)
#         while y > e
#             result += y
#             x -= h
#             y = f(x)
#         end
# 		result += y/2

# 		return h*result
#     end

#     # Wzór simpsona
#     function simpson(
#         f::F,
#         e::Float64=defaultE,
#         h::Float64=defaultH
#     )::Float64 where {F<:Function}
#         result::Float64 = 0
#         x::Float64 = h
#         y::Float64 = f(x)
#         while y > e
#             result += y
#             x += 2 * h
#             y = f(x)
#         end

# 		x = -h
#         y = f(x)
#         while y > e
#             result += y
#             x -= 2 * h
#             y = f(x)
#         end

#         return 2 * (trapezoidal(f, e, h) + result * h) / 3
#     end

#     # Prekompilacja funkcji
#     @time begin
#         function precompF(x::Float64)::Float64
#             1 / (ℯ^x^2)
#         end
#         for f in [rectangle, trapezoidal, simpson]
#             _ = f(precompF, 0.1, 0.1)
#             _ = f(precompF, 0.0001, 0.0001)
#         end
#         md"""
#         """
#     end
# end

# ╔═╡ 7b8cd7d9-c910-4d23-b283-2a392533c4a4
  #   function romberg(
  #       f::F,
  #       ε::Float64=defaultE
  #   )::Float64 where {F<:Function}
  #       fsubst(x::Float64)::Float64 = f(tan(x))/cos(x)^2
		# # -ε i +ε, żeby uniknąć dzielenia przez cos(±π/2) = 0
		# a::Float64 = -π/2+ε
		# b::Float64 = π/2-ε
		# h::Float64 = (b-a)/2
		# previous::Float64 = (fsubst(a)+fsubst(b))*h
  #       result::Float64 = fsubst((a+b)/2)*h + previous/2
		# rng::StepRangeLen{Float64,Float64,Float64,Int} = 0:1:0

		# while abs(result-previous) > ε
		# 	previous = result
		# 	result = 0
		# 	h /= 2
		# 	rng = a+h:2*h:b-h
  #       	@simd for x in rng
  #           	result += f(x)
  #       	end
		# 	result = result*h+previous/2
		# 	println(result, " ", previous)
		# end
		# println()
  #       return result
  #   end


# ╔═╡ a5119717-f29e-428c-adaa-1e2b24fd7313
# begin
#     fig4 = Figure(size=(1920,1080))
#     ax4 = Axis(fig4[1,1])
#     const func4 = x -> cos(x-500)*ℯ^(-(x-500)^2)
#     const r4 = 0.0001:0.0001:3
#     const hr = -5:0.01:5
#     # lines!(r4,tanh.(r4),color=:blue,linewidth=3)
#     lines!(r4,func4.(r4),color=:green,linewidth=3)
#     lines!(r4,(x -> func4(1/x-1)/x^2).(r4),color=:red,linewidth=3)
#     lines!(-r4,(x -> func4(1/x-1)/x^2).(-r4),color=:red,linewidth=3)
#     lines!((_ -> 1).(hr), hr, color=:darkred, linewidth=3, linestyle=:dash)
#     lines!((_ -> -1).(hr), hr, color=:darkred, linewidth=3, linestyle=:dash)
#     fig4
# 	md"""
# 	"""
# end

# ╔═╡ acf987fe-7531-4ade-825d-279290c901a2
# begin
#   fig5 = Figure(size=(1920,1080))
#   ax5 = Axis(fig5[1,1])
#   const func5 = x -> cos(x+2)*ℯ^(-(x+2)^2)
#   const r5 = 0:0.0001:0.8
#   const df5 = x -> 1/(1-x)
#   lines!(r5,df5.(r5),color=:blue,linewidth=3)
#   lines!(r5,func5.(r5),color=:green,linewidth=3)
#   lines!(r5,func5.(df5.(r5)),color=:red,linewidth=3)
#   lines!((_ -> 1).(hr), hr, color=:darkred, linewidth=3, linestyle=:dash)
#   fig5
# end

# ╔═╡ 5ad4c7b9-204b-412b-86c7-45cf1efb9be6
# begin
#     fig6 = Figure(size=(1920,1080))
#     ax6 = Axis(fig6[1,1])
#     const func6 = x -> cos(x+1)*ℯ^(-(x+1)^2)
#     const r6 = -1.5:0.0001:1.5
#     const hr6 = -4:0.01:4
#     lines!(r6,tan.(r6),color=:blue,linewidth=3)
#     # lines!(r6,cos.(r6),color=:blue,linewidth=3)
#     lines!(r6,func6.(r6),color=:green,linewidth=3)
#     lines!(r6,(x -> func6(tan(x))/cos(x)^2).(r6),color=:red,linewidth=3)
#     lines!((_ -> π/2).(hr6), hr6, color=:darkred, linewidth=3, linestyle=:dash)
#     lines!((_ -> -π/2).(hr6), hr6, color=:darkred, linewidth=3, linestyle=:dash)
#     fig6
# 	md"""
# 	"""
# end

# ╔═╡ faeb1f73-4a59-4f9a-b21d-db5045ad0f2a
# begin
#     const txs = 1:6
#     const tvalues = (x -> 1 / 10^x).(txs)
#     const fig = Figure(size=(1280, 720))
#     const ax = Axis3(
#         fig[1, 1],
#         aspect=(10.0, 10.0, 2.0),
#         xlabel="minimalna ",
#         ylabel="szerokość prostokąta (h)",
#         zlabel="wartość całki"
#     )

#     scatter!(
#         ax,
#         txs,
#         txs,
#         [real_value for h in tvalues, e in tvalues],
#         alpha=0.9,
#         markersize=12,
#         color=:red
#     )

#     # surface!(
#     #     ax,
#     #     txs,
#     #     txs,
#     #     [rectangle(f, e, h) for e in tvalues, h in tvalues],
#     #     ssao=true,
#     #     colormap=:darkterrain,
#     #     alpha=0.6
#     # )

#     # surface!(
#     #     ax,
#     #     txs,
#     #     txs,
#     #     [trapezoidal(f, e, h) for e in tvalues, h in tvalues],
#     #     ssao=true,
#     #     colormap=:julia,
#     #     alpha=0.6
#     # )

#     # surface!(
#     #     ax,
#     #     txs,
#     #     txs,
#     #     [simpson(f, e, h) for e in tvalues, h in tvalues],
#     #     ssao=true,
#     #     colormap=:nord,
#     #     alpha=0.6
#     # )

#     fig
#     md"""
#     """
# end

# ╔═╡ 1e04b8ef-0586-4309-b9de-f0a239193bd0
# begin
#     function pwz(n::Int)
#         lines!(fig3[1, 1], r3, Hf[n].(r3))
#         scatter!(fig3[1, 1], xk[n], zeros(length(xk[n])), color=:red, markersize=20)
#     end
# end

# ╔═╡ Cell order:
# ╟─308ed8e8-fbf5-11ee-1968-714be3777df4
# ╟─fef31c85-2127-4698-92d5-d2dc75d4fa09
# ╟─e70f5821-2fc8-46cf-8664-8742ca09d18d
# ╟─bd84b137-eae9-4cdb-a4d4-e0a4a4d86428
# ╠═a007ec04-33d8-4cad-8a22-5cf013509a68
# ╠═481d2e0e-1e88-4138-b3f4-8291eba0f3b7
# ╠═1fb5c3a3-28f9-426e-8226-867d0a4e0b88
# ╠═ccb587a4-9df4-433d-ba41-b1fb976ee70a
# ╠═1bc3c679-7a5f-4d14-a0c5-d8d9475866cb
# ╠═9dd52312-f203-4b9e-98d8-a3d6367f990c
# ╠═45434b9b-115e-4d79-968c-41232dd3b16b
# ╠═fd51e76f-9b7f-4a85-831f-7ea0b5e37c95
# ╠═96bee331-4c9d-4bd8-b388-1923f18b93b8
# ╟─ea76b663-3fed-45dc-8761-7583fde666b9
# ╠═6b17eb7d-db27-4abb-9785-e29f5ebb175b
# ╠═e7228ba3-1e70-4be0-bfac-a700e907bcb2
# ╟─c60861c7-e9e3-4fe6-a627-b29e8acaef12
# ╟─dfae65bc-3640-454f-9b43-4f3b9829484e
# ╟─211b2155-464b-4fc7-a31c-541ce7145f49
# ╟─c2e633d9-24d3-4968-b79e-abad0661a141
# ╟─7b8cd7d9-c910-4d23-b283-2a392533c4a4
# ╟─a5119717-f29e-428c-adaa-1e2b24fd7313
# ╟─acf987fe-7531-4ade-825d-279290c901a2
# ╟─5ad4c7b9-204b-412b-86c7-45cf1efb9be6
# ╟─faeb1f73-4a59-4f9a-b21d-db5045ad0f2a
# ╠═1e04b8ef-0586-4309-b9de-f0a239193bd0
