# using CairoMakie
# CairoMakie.activate!(type="svg")

using GLMakie
r = -5:0.001:5

function plt(f)
    fig = Figure()
    plot(fig[1,1], r, f.(r))
    plot!(fig[1,1], r, r)
    return fig
end

linewidth = 2.5
markersize = 16
color = "#000000"
scolor = "#00ff00"

f = x -> x^2/3 - 3
function fpoint(f, x, iter=100)
    y = f(x)
    fig = Figure()
    lines(fig[1,1], r, f.(r), linewidth=linewidth)
    lines!(fig[1,1], r, r, linewidth=linewidth)
    scatter!(fig[1,1], [x], [y], markersize=markersize, color=scolor)
    for _ = 1:iter
        px = x
        py = f(px)
        x = y
        y = f(x)
        scatter!(fig[1,1], [x], [y], markersize=markersize, color=scolor)
        scatter!(fig[1,1], [x], [x], markersize=markersize, color=scolor)
        arrows!(fig[1,1], [ px ],[ py ], [ py-px ],[ 0 ], linewidth=1.5, color=color)
        arrows!(fig[1,1], [ x ],[ x ], [ 0 ],[ y-x ], linewidth=1.5, color=color)
    end
    return fig
end
@time fig = fpoint(f, -2)

