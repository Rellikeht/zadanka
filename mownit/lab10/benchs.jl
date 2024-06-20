### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ b919e02a-1a85-11ef-2bbd-414ba5ac617e
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

	md""""""
end

# ╔═╡ 7134f6c0-b50b-4d56-9260-7437d1038844
begin
    const FRange = StepRangeLen{Float64,Float64,Float64,Int}
    const IntOrFloat = Union{Int,Float64}

    md""""""
end

# ╔═╡ 5a31e5d4-98af-4ba3-9bc2-693da261131a
begin
	PLX = 1920
	PLY = 1080
	ticksize = 27
	labelsize = 34

	md""""""
end

# ╔═╡ 670ec5b7-f0b9-4554-bf04-6bbc74c2abdd


# ╔═╡ 3f71aa84-087a-4bc5-8c0b-e43e314ab7eb
begin
	const x01 = 0
    const y01 = 0.0
    const xend1 = 5

    const default_step1 = 1e-4
    const default_r1::FRange = y01:default_step1:xend1

    function eq1(x::IntOrFloat, y::IntOrFloat)::Float64
        sin(x) * cos(x) - y * cos(x)
    end
    function exact1(x::IntOrFloat)::Float64
        exp(-sin(x)) + sin(x) - 1
    end

    _ = eq1(1, 1)
    _ = eq1(0.5, 0.5)
    _ = exact1(0.5)
    md""""""
end

# ╔═╡ 50fd42b0-7f04-4d7d-80f1-3b5af15a690f
begin
    function solve(
		method::F1,
        f::F2,
        step::Float64,
        xstart::IntOrFloat,
        xend::IntOrFloat,
        y0::T,
    )::Vector{T} where {F1<:Function, F2<:Function, T}
        values::Vector{T} = zeros(T, Int(round((xend - xstart) / step))+1)
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

# ╔═╡ 72a0d216-2240-4951-8ab0-a222e69102fa
begin
    function eulerStep(
        f::F,
        x::IntOrFloat,
        y::IntOrFloat,
        step::Float64=default_step1
    )::Float64 where {F<:Function}
        y + step * f(x, y)
    end

    _ = eulerStep(eq1, 0.5, 0.5)
    _ = eulerStep(eq1, 1, 1)

    _ = solve(eulerStep, eq1, 1e-1, 0.0, 0.5, 0.5)
    _ = solve(eulerStep, eq1, 1e-1, 0, 1, 1.0)

    md""""""
end

# ╔═╡ 59e138d8-e4aa-47e3-81e3-bf51c9532f90
begin
    function nosimdSolve(
		method::F1,
        f::F2,
        step::Float64,
        xstart::IntOrFloat,
        xend::IntOrFloat,
        y0::T,
    )::Vector{T} where {F1<:Function, F2<:Function, T}
        values::Vector{T} = zeros(T, Int(round((xend - xstart) / step)) + 1)
        values[1] = y0
        x::Float64 = xstart
        for i in 2:length(values)
            x += step
            values[i] = method(f, x, values[i-1], step)
        end
        return values
    end
	
    _ = nosimdSolve(eulerStep, eq1, 1e-1, 0.0, 0.5, 0.5)
    _ = nosimdSolve(eulerStep, eq1, 1e-1, 0, 1, 1.0)

	md""""""
end

# ╔═╡ 6f00a9ee-5a5d-4791-93cc-ff996bf47708


# ╔═╡ 81b8b69d-4446-40e3-a1da-31326d900919
@benchmark nosimdSolve(eulerStep, eq1, 1e-4, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ 11ad88a1-03f6-419c-9a4b-cf9188ff3252
@benchmark solve(eulerStep, eq1, 1e-4, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ 1fab7062-90e8-4dbe-99a5-ec4b2804d658


# ╔═╡ ffc3ace8-b473-46bd-a5bd-1c8ba61ff40a
@benchmark nosimdSolve(eulerStep, eq1, 1e-3, 0.0, 10.0, 0.5) samples=1000

# ╔═╡ 9e99078e-d878-4eb6-8e28-a480d441b0a3
@benchmark solve(eulerStep, eq1, 1e-3, 0.0, 10.0, 0.5) samples=1000

# ╔═╡ 2bd31c4d-81a4-4a35-8a3a-d69081d66641


# ╔═╡ f30eeaf5-92af-4508-a110-6ea5a70c18c2
begin
    # Rzędu 4
    function rungeKuttaStep(
        f::F,
        x::IntOrFloat,
        y::T,
        step::Float64
    )::T where {F<:Function, T}
        k1::Float64 = f(x, y)
        k2::Float64 = f(x + step / 2, y + (step / 2) * k1)
        k3::Float64 = f(x + step / 2, y + (step / 2) * k2)
        k4::Float64 = f(x + step, y + step * k3)
        return y + (step / 6) * (k1 + 2 * k2 + 2 * k3 + k4)
    end

    _ = rungeKuttaStep(eq1, 0.0, 0.5, 0.5)
    _ = rungeKuttaStep(eq1, 1, 1.0, 0.1)

    md""""""
end

# ╔═╡ 4c356bb1-9112-4ff0-9f16-6a4d3ceaef4e


# ╔═╡ 2035451f-cede-46df-87a5-d34ba567dad1
@benchmark solve(eulerStep, eq1, 1e-3, 0.0, 10.0, 0.5) samples=1000

# ╔═╡ 94f91bca-1d52-45b0-9e6b-83497d880dd2
@benchmark solve(rungeKuttaStep, eq1, 1e-3, 0.0, 10.0, 0.5) samples=1000

# ╔═╡ e16d4727-575d-4349-9b21-cdd84e8ddf2a


# ╔═╡ 8eee3bdc-25b6-4542-b6e1-e051dd456ea1
@benchmark solve(eulerStep, eq1, 1e-4, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ 5c8f66dc-3414-4bae-a42b-ce9a5b44697f
@benchmark solve(rungeKuttaStep, eq1, 1e-4, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ d52faaa5-f923-4497-b4af-7c1a6b4a9821


# ╔═╡ 6a2b7e71-cc63-465d-b936-8ebe29ee8177
begin
	estep = 1e-4
	md""""""
end

# ╔═╡ e5e6b042-dfce-4475-8abc-99c542221b62
begin
	rkstep = 2.5*estep
	md""""""
end

# ╔═╡ 65a2d80f-1dd5-4f0a-9b1d-c690b577e9dd


# ╔═╡ 9e54d31c-bbe6-4330-a7f8-7626f9994e38
@benchmark solve(eulerStep, eq1, estep, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ 4f2495c2-56bb-4ea1-81a1-66494b6cf67b
@benchmark solve(rungeKuttaStep, eq1, rkstep, 0.0, 1.0, 0.5) samples=1000

# ╔═╡ 8925b1f3-ff8f-439c-954e-07da585d6586


# ╔═╡ b2f66381-cfbb-4e3d-8453-0c1a0d537b89
begin
	euler_range = x01:estep:xend1
	rk_range = x01:rkstep:xend1

	euler_sol = solve(eulerStep, eq1, estep, x01, xend1, y01)
	rk_sol = solve(rungeKuttaStep, eq1, rkstep, x01, xend1, y01)
	if length(rk_range) != length(rk_sol)
		rk_range = x01:rkstep:xend1+rkstep
	end

	euler_abs = abs.(euler_sol .- exact1.(euler_range))
	rk_abs = abs.(rk_sol .- exact1.(rk_range))

	md""""""
end

# ╔═╡ a9c73f6c-2a43-42c7-ae65-15a499c41091
let
    fig::Figure = Figure(size=(PLX, PLY))

    ax::Axis = Axis(
        fig[1, 1],
        xticklabelsize=ticksize,
        yticklabelsize=ticksize,
    )

    lines!(
        ax,
        euler_range,
		euler_abs,
        # linestyle=:solid,
        color="#0066ff",
        linewidth=4,
        label="Metoda Eulera, krok=" * string(estep)
    )

    lines!(
        ax,
        rk_range,
		rk_abs,
        #   linestyle=:solid,
        color="#ff00ff",
        linewidth=2,
        label="Metoda Rungego-Kutty, krok=" * string(rkstep)
    )

    axislegend(ax, labelsize=labelsize, position=:lt)
    fig
end

# ╔═╡ Cell order:
# ╠═b919e02a-1a85-11ef-2bbd-414ba5ac617e
# ╠═7134f6c0-b50b-4d56-9260-7437d1038844
# ╠═5a31e5d4-98af-4ba3-9bc2-693da261131a
# ╟─670ec5b7-f0b9-4554-bf04-6bbc74c2abdd
# ╠═3f71aa84-087a-4bc5-8c0b-e43e314ab7eb
# ╠═50fd42b0-7f04-4d7d-80f1-3b5af15a690f
# ╠═72a0d216-2240-4951-8ab0-a222e69102fa
# ╠═59e138d8-e4aa-47e3-81e3-bf51c9532f90
# ╟─6f00a9ee-5a5d-4791-93cc-ff996bf47708
# ╠═81b8b69d-4446-40e3-a1da-31326d900919
# ╠═11ad88a1-03f6-419c-9a4b-cf9188ff3252
# ╟─1fab7062-90e8-4dbe-99a5-ec4b2804d658
# ╠═ffc3ace8-b473-46bd-a5bd-1c8ba61ff40a
# ╠═9e99078e-d878-4eb6-8e28-a480d441b0a3
# ╟─2bd31c4d-81a4-4a35-8a3a-d69081d66641
# ╠═f30eeaf5-92af-4508-a110-6ea5a70c18c2
# ╟─4c356bb1-9112-4ff0-9f16-6a4d3ceaef4e
# ╠═2035451f-cede-46df-87a5-d34ba567dad1
# ╠═94f91bca-1d52-45b0-9e6b-83497d880dd2
# ╟─e16d4727-575d-4349-9b21-cdd84e8ddf2a
# ╠═8eee3bdc-25b6-4542-b6e1-e051dd456ea1
# ╠═5c8f66dc-3414-4bae-a42b-ce9a5b44697f
# ╟─d52faaa5-f923-4497-b4af-7c1a6b4a9821
# ╠═6a2b7e71-cc63-465d-b936-8ebe29ee8177
# ╠═e5e6b042-dfce-4475-8abc-99c542221b62
# ╟─65a2d80f-1dd5-4f0a-9b1d-c690b577e9dd
# ╠═9e54d31c-bbe6-4330-a7f8-7626f9994e38
# ╠═4f2495c2-56bb-4ea1-81a1-66494b6cf67b
# ╟─8925b1f3-ff8f-439c-954e-07da585d6586
# ╠═b2f66381-cfbb-4e3d-8453-0c1a0d537b89
# ╠═a9c73f6c-2a43-42c7-ae65-15a499c41091
