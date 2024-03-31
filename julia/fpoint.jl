using GLMakie

r = -10:0.001:10
linewidth = 2.5
markersize = 16
color = "#000000"
scolor = "#00ff00"

# f = x -> x^2 / 3 - 3
f = x -> x^2 / 4 - 3
function fpoint(f, sx, iter=100)
    fig = Figure()
    Axis(fig[1, 1], limits=(r[begin], r[end], r[begin], r[end]))
    slx = Slider(fig[2, 1], range=r, startvalue=sx)
    fp = lift(slx.value) do x
        Point2f(x, f(x))
    end
    scatter!(fig[1, 1], fp, markersize=markersize, color=scolor)
    lines!(fig[1, 1], r, f.(r), linewidth=linewidth)
    lines!(fig[1, 1], r, r, linewidth=linewidth)
    for _ = 1:iter
        pfp = fp
        fp = lift(fp) do p
            Point2f(p.data[2], f(p.data[2]))
        end
        scatter!(fig[1, 1], fp, markersize=markersize, color=scolor)
        xp = lift(fp) do p
            Point2f(p.data[1], p.data[1])
        end
        scatter!(fig[1, 1], xp, markersize=markersize, color=scolor)
        axs = lift(p -> [p.data[1]], pfp)
        ays = lift(p -> [p.data[2]], pfp)
        axl = lift(p -> [p.data[2] - p.data[1]], pfp)
        arrows!(fig[1, 1], axs, ays, axl, [0], linewidth=1.5, color=color)
        arrows!(fig[1, 1], axs, axs, [0], axl, linewidth=1.5, color=color)
    end
    return fig
end
@time fig = fpoint(f, -2)
