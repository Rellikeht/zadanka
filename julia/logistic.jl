# using CairoMakie
# CairoMakie.activate!(type="svg")
# nope

using GLMakie
GLMakie.activate!(framerate=120.0)

trials::Int = 200000
places::Int = 10
function iter(x::Float64, lambda::Float64)
    lambda * (x - x * x)
end
function logistic(lambda::Int=1)
    logistic(Float64(lambda))
end
function logistic(lambda::Float64=1.0, x::Float64=0.5)::Set{Float64}
    nums = Set{Float64}()
    if x <= 0 || x >= 4 || lambda <= 0 || lambda >= 4
        return nums
    end
    for _ = 1:trials
        x = round(iter(x, lambda), digits=places)
        # x = iter(x, lambda)
    end
    if lambda < 3.0
        push!(nums, x)
        return nums
    end
    while !(x in nums)
        push!(nums, x)
        x = round(iter(x, lambda), digits=places)
    end
    return nums
end

I = Int
trials::I = 200000
places::I = 9
iconst::I = 10^places
function iterI(x::I, lambda::I)
    div(lambda * (x - div(x * x, iconst)), iconst)
end
function logisticI(lambda::Float64)::Set{Float64}
    logisticI(I(round(lambda * iconst, digits=0)))
end
function logisticI(lambda::I=iconst)::Set{Float64}
    x::I = div(iconst, 3)
    if lambda <= 0 || lambda >= 4 * iconst
        return Set{Float64}()
    end
    nums = Set{I}()
    for _ = 1:trials
        x = iterI(x, lambda)
    end
    if lambda < 3 * iconst
        push!(nums, x)
    else
        while !(x in nums)
            push!(nums, x)
            x = iterI(x, lambda)
        end
    end
    return Set{Float64}((x -> x / iconst).(nums))
end

@time logisticI(iconst)
@time logisticI(iconst)
using Base.Threads

r = 0:0.001:4
function lplot()
    fig = Figure()
    lengths = Dict{Float64,Int}()
    geti(x) = Int(length(r) * (x - r[begin]) / (r[end] - r[begin]))
    Axis(fig[1, 1], limits=(0, 4, -0.5, 1.5))
    (x -> begin
        ys = collect(logisticI(x))
        xs = (_ -> x).(ys)
        push!(lengths, x => length(ys))
        scatter!(fig[1, 1], xs, ys, markersize=2, color="#000000")
    end
    ).(r)
    # @threads don't work here :(
    # for x in r
    #     ys = collect(logisticI(x))
    #     xs = (_ -> x).(ys)
    #     push!(lengths, x => length(ys))
    #     scatter!(fig[1, 1], xs, ys, markersize=2.2, color="#000000")
    # end

    slx = SliderGrid(fig[2, 1],
        (range=r,
            startvalue=3,
            format=x -> "x: $(x), points: $(lengths[x])"
        )
    ).sliders[1]
    fp1 = lift(slx.value) do x
        [x, x]
    end
    fp2 = lift(slx.value) do _
        [0, 1]
    end
    lines!(fig[1, 1], fp1, fp2)
    return fig
end

@time f = lplot()
# @time save("logistic.svg", f)
