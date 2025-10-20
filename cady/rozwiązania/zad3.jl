using GLMakie
using FileIO
using Observables
using Makie: AbstractAxis

const DEFAULT_ACCURACY = 100
const DEFAULT_DEGREE = 2

# const DEFAULT_PLOT_KWARGS = Dict(
#     :linewidth => 4
# )
# const DEFAULT_SCATTER_KWARGS = Dict(
#     :color => :red,
#     :markersize => 15
# )

const DEFAULT_PLOT_KWARGS = Dict(
    :linewidth => 4,
    :colormap => :viridis,
    :color => 1:100,
)
const DEFAULT_SCATTER_KWARGS = Dict(
    :colormap => :viridis,
    :color => 1:100,
    :markersize => 15
)

GLMakie.activate!(framerate=60)

abstract type AbstractParametric end
abstract type AbstractLine <: AbstractParametric end
abstract type AbstractPlane <: AbstractParametric end

#= helpers {{{=#

function tuple_of_vectors(
    data::Union{
        AbstractVector{<:Union{Point{N,<:Real},NTuple{N,Real}}},
        Nothing
    }=nothing
) where {N}
    if data === nothing
        new_data::NTuple{N,Vector{Float64}} = tuple(([] for _ in 1:N)...)
    else
        R = typeof(data).parameters[1].parameters[2]
        new_data = tuple(
            (Vector{R}(undef, length(data)) for _ in 1:N)...
        )
        for i in eachindex(data)
            for j in 1:N
                new_data[j][i] = data[i][j]
            end
        end
    end
    return new_data
end

#= }}}=#

#= splines {{{=#

#= definitions {{{=#

struct Spline{R<:Real,N} <: AbstractLine
    accuracy::Observable{<:Integer}
    degree::Observable{<:Integer}
    knots::Observable{<:AbstractVector{R}}
    points::NTuple{N,Observable{<:AbstractVector{R}}}
    line::NTuple{N,Observable{<:AbstractVector{R}}}
    ts::AbstractVector{R}
end

function Spline(
    positions::AbstractVector{<:Union{Point{N,R},NTuple{N,R}}} where {N,R<:Real};
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
)
    return Spline(
        tuple_of_vectors(positions);
        knots,
        accuracy,
        degree,
    )
end

function Spline(
    positions::NTuple{N,AbstractVector{R}} where {N,R<:Real};
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
)
    R = typeof(positions).parameters[1].parameters[1]
    if knots === nothing
        knots = Vector{R}(undef, 0)
    end
    # TODO checks
    spline = Spline(
        Observable(accuracy),
        Observable(degree),
        Observable(deepcopy(knots)),
        Observable.(deepcopy(positions)),
        tuple((
            Observable(Vector{R}(undef, accuracy)) for _ in 1:length(positions)
        )...),
        Vector{R}(undef, accuracy),
    )
    on(spline.accuracy) do _
        adjust_sizes!(spline)
        calc_points!(spline)
    end
    on(spline.degree) do _
        adjust_knots!(spline)
        calc_points!(spline)
    end
    # TODO changing (and checking) knots
    on(_ -> calc_points!(spline), spline.knots)
    for dim in eachindex(spline.points)
        on(spline.points[dim]) do _
            # TODO detect size change and adjust only then
            adjust_knots!(spline)
            adjust_sizes!(spline)
            calc_points!(spline)
        end
    end
    if length(knots) == 0
        adjust_knots!(spline)
    end
    adjust_sizes!(spline)
    calc_points!(spline)
    return spline
end

function get_knots(
    xs::AbstractVector{R},
    degree::Integer,
) where {R<:Real}
    return [fill(xs[begin], degree); xs; fill(xs[end], degree)]
end

function get_knots!(
    knots::AbstractVector{R},
    length::R,
    degree::Integer,
) where {R<:Real}
    @views fill!(knots[begin:begin+degree], 0)
    knots[begin+degree+1:end-degree] = 1:length-degree
    @views fill!(knots[end-degree+1:end], length - degree)
end

function adjust_knots!(spline::Spline)
    R = typeof(spline).parameters[1]
    resize!(
        spline.knots[],
        length(spline.points[begin][]) + spline.degree[] + 1
    )
    get_knots!(
        spline.knots[],
        R(length(spline.points[begin][])),
        spline.degree[]
    )
end

function adjust_sizes!(spline::Spline)
    (vec -> resize!(vec[], spline.accuracy[])).(spline.line)
    resize!(spline.ts, spline.accuracy[])
    ts_size = maximum(spline.knots[])
    step = ts_size / (spline.accuracy[] - 1)
    spline.ts .= 0:step:ts_size
    notify(spline.line[begin])
end

#= }}}=#

#= calculations {{{=#

function calc_point(
    knots::AbstractVector{R},
    degree::Integer,
    index::Integer,
    x::R,
) where {R<:Real}
    if degree == 0
        if x <= knots[index] || x > knots[index+1]
            return 0
        end
        return 1
    end
    tmp = knots[index+degree] - knots[index]
    left = calc_point(knots, degree - 1, index, x)
    left = if tmp == 0
        left
    else
        left * (x - knots[index]) / tmp
    end
    tmp = knots[index+degree+1] - knots[index+1]
    right = calc_point(knots, degree - 1, index + 1, x)
    right = if tmp == 0
        right
    else
        right * (knots[index+degree+1] - x) / tmp
    end
    return right + left
end

function calc_point(
    spline::Spline,
    index::Integer,
    x::Real,
)
    return calc_point(spline.knots[], spline.degree[], index, x)
end

function calc_points!(spline::Spline)
    for dim in eachindex(spline.line)
        fill!(spline.line[dim][], zero(typeof(spline).parameters[1]))
        spline.line[dim][][begin] += spline.points[dim][][begin]
        for i in eachindex(spline.points[begin][])
            spline.line[dim][] .+=
                spline.points[dim][][i] *
                calc_point.((spline,), i, spline.ts)
        end
        # no even slighest clue why this works, but this works
        adjusted_end = length(spline.knots[]) - spline.degree[] - 1
        for i in length(spline.points[begin][])+1:adjusted_end
            spline.line[dim][] .+=
                spline.points[dim][][end] *
                calc_point.((spline,), i, spline.ts)
        end
    end
    notify(spline.line[begin])
end

#= }}}=#

#= drawings {{{=#

function draw_splines(
    xs::Vector{R},
    degree::Integer=DEFAULT_DEGREE,
    accuracy::Integer=DEFAULT_ACCURACY;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
) where {R<:Real}
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = Axis(fig[1, 1])
    step = (maximum(xs) - minimum(xs)) / (accuracy - 1)
    range = minimum(xs):step:maximum(xs)
    knots = get_knots(xs, degree)
    for i in 1:length(xs)+degree-1
        values = calc_point.((knots,), degree, i, range)
        if i == 1
            values[begin] += 1
        end
        lines!(ax, range, values; (plot_kwargs === nothing ? Dict() : plot_kwargs)...)
    end
    return fig
end

#= }}}=#

#= }}}=#

#= spline plane {{{=#

#= definitions {{{=#

struct SplinePlane{R<:Real} <: AbstractPlane
    xline::Observable{Spline{R,2}}
    yline::Observable{Spline{R,2}}
    coeffs::Observable{<:AbstractMatrix{R}}
    plane::Observable{<:AbstractMatrix{R}}
end

function SplinePlane(
    xs::AbstractVector{R},
    ys::AbstractVector{R},
    coeffs::Union{AbstractMatrix{R},Nothing}=nothing;
    xaccuracy::Integer=DEFAULT_ACCURACY,
    xdegree::Integer=DEFAULT_DEGREE,
    yaccuracy::Integer=DEFAULT_ACCURACY,
    ydegree::Integer=DEFAULT_DEGREE,
) where {R<:Real}
    return SplinePlane(
        (xs, ys),
        coeffs;
        xaccuracy,
        xdegree,
        yaccuracy,
        ydegree,
    )
end

function SplinePlane(
    positions::AbstractVector{<:Union{Point{2,R},NTuple{2,R}}},
    coeffs::Union{AbstractMatrix{R},Nothing}=nothing;
    xaccuracy::Integer=DEFAULT_ACCURACY,
    xdegree::Integer=DEFAULT_DEGREE,
    yaccuracy::Integer=DEFAULT_ACCURACY,
    ydegree::Integer=DEFAULT_DEGREE,
) where {R<:Real}
    return SplinePlane(
        tuple_of_vectors(positions),
        coeffs;
        xaccuracy,
        xdegree,
        yaccuracy,
        ydegree,
    )
end

function SplinePlane(
    positions::NTuple{2,AbstractVector{R}},
    coeffs::Union{AbstractMatrix{R},Nothing}=nothing;
    xaccuracy::Integer=DEFAULT_ACCURACY,
    xdegree::Integer=DEFAULT_DEGREE,
    yaccuracy::Integer=DEFAULT_ACCURACY,
    ydegree::Integer=DEFAULT_DEGREE,
) where {R<:Real}
    xline = Spline(positions[1]; degree=xdegree, accuracy=xaccuracy)
    yline = Spline(positions[2]; degree=ydegree, accuracy=yaccuracy)
    return SplinePlane((xline, yline), coeffs)
end

function SplinePlane(
    splines::NTuple{2,Spline{<:Real,2}},
    coeffs::Union{AbstractMatrix{<:Real},Nothing}=nothing
)
    plane_dims = (splines[2].accuracy[], splines[1].accuracy[])
    R = typeof(splines[begin]).parameters[1]
    if coeffs === nothing
        coeffs = fill(R(1), plane_dims)
    else
        coeffs = R.(coeffs)
    end
    plane = fill(R(1), plane_dims)
    # TODO checks
    plane = SplinePlane(
        Observable(splines[1]),
        Observable(splines[2]),
        Observable(coeffs),
        Observable(plane),
    )
    # TODO resizing

    on(plane.coeffs) do _
        calc_points!(plane)
    end
    on(plane.xline) do _
        calc_points!(plane)
    end
    on(plane.yline) do _
        calc_points!(plane)
    end
    return plane
end

#= }}}=#

#= calculations {{{=#

function calc_points!(plane::SplinePlane)
    for (y, yv) in enumerate(plane.xline[].line[])
        for (x, xv) in enumerate(plane.xline[].line[])
            plane.plane[][y, x] = xv * yv * plane.coeffs[][y, x]
        end
    end
end

#= }}}=#

#= }}}=#

#= demo {{{=#

struct Demo
    # TODO
    # multiple of that
    object::AbstractParametric
    fig::Figure
    ax::AbstractAxis
    plot::Lines
    scatter::Union{Scatter,Nothing}
    moving::Observable{Union{Int,Nothing}}
end

function Makie.display(demo::Demo)
    display(demo.fig)
end

#= constructors {{{=#

function Demo(
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = Axis(fig[1, 1])
    plt = lines!(ax, line.line...; (plot_kwargs === nothing ? Dict() : plot_kwargs)...)
    sct = scatter!(ax, line.points...; (scatter_kwargs === nothing ? Dict() : scatter_kwargs)...)
    moving = Observable(nothing)
    object = Demo(
        line,
        fig,
        ax,
        plt,
        sct,
        moving,
    )
    deregister_interaction!(ax, :rectanglezoom)
    on(
        on_mouse_button(object),
        events(fig).mousebutton,
        priority=5
    )
    on(
        on_mouse_position(object),
        events(fig).mouseposition,
        priority=5
    )
    return object
end

# TODO
# function Demo(
#     plane::AbstractPlane;
#     fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
#     scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
#     plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
# )
#     fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
#     ax = Axis(fig[1, 1])
# end

#= }}}=#

#= static demo {{{=#

function StaticDemo!(
    ax::Union{Axis,Axis3},
    line::AbstractLine;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
)
    plt = lines!(ax, line.line...; (plot_kwargs === nothing ? Dict() : plot_kwargs)...)
    sct = scatter!(ax, line.points...; (scatter_kwargs === nothing ? Dict() : scatter_kwargs)...)
    moving = Observable(nothing)
    object = Demo(
        line,
        ax.parent,
        ax,
        plt,
        sct,
        moving,
    )
    return object
end

function StaticDemo!(
    ax::Axis3,
    plane::AbstractPlane;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
)
    plt = lines!(
        ax,
        plane.xline[].line,
        plane.yline[].line,
        plane.plane;
        (plot_kwargs === nothing ? Dict() : plot_kwargs)...
    )
    # TODO ???
    # sct = scatter!(
    #     ax,
    #     plane.xline[].line,
    #     plane.yline[].line,
    #     plane.plane;
    #     (scatter_kwargs === nothing ? Dict() : scatter_kwargs)...
    # )
    moving = Observable(nothing)
    object = Demo(
        plane,
        ax.parent,
        ax,
        plt,
        # sct,
        nothing,
        moving,
    )
    return object
end

function StaticDemo(
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = nothing
    if length(line.points) == 2
        ax = Axis(fig[1, 1])
    elseif length(line.points) == 3
        ax = Axis3(fig[1, 1])
    elseif length(line.points) < 2
        error("Cannot draw in dimention lower than 2")
    else
        error("Cannot draw in dimention higher than 3")
    end
    return StaticDemo!(ax, line; scatter_kwargs, plot_kwargs)
end

function StaticDemo(
    plane::AbstractPlane;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_SCATTER_KWARGS,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_PLOT_KWARGS,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = Axis3(fig[1, 1])
    return StaticDemo!(ax, plane; scatter_kwargs, plot_kwargs)
end

#= }}}=#

#= event handlers {{{=#

function on_mouse_button(obj::Demo)
    return function (event)
        if event.button == Mouse.left
            plt, i = pick(obj.ax)
            if event.action == Mouse.press
                if Keyboard.d in events(obj.fig).keyboardstate
                    # Delete marker
                    if plt == obj.scatter
                        deleteat!(obj.object.points[1][], i)
                        deleteat!(obj.object.points[2][], i)
                        notify(obj.object.points[1])
                        return Consume(true)
                    end
                elseif Keyboard.a in events(obj.fig).keyboardstate
                    # Add marker
                    x, y = mouseposition(obj.ax)
                    push!(obj.object.points[1][], x)
                    push!(obj.object.points[2][], y)
                    notify(obj.object.points[1])
                    return Consume(true)
                end
                # start obj.moving
                if plt == obj.scatter
                    obj.moving[] = i
                    return Consume(true)
                end
            elseif event.action == Mouse.release
                # stop obj.moving
                if obj.moving[] !== nothing
                    x, y = mouseposition(obj.ax)
                    obj.object.points[1][][obj.moving[]] = x
                    obj.object.points[2][][obj.moving[]] = y
                    notify(obj.object.points[begin])
                    obj.moving[] = nothing
                    return Consume(true)
                end
            end
        end
        return Consume(false)
    end
end

function on_mouse_position(obj::Demo)
    return function (_)
        if obj.moving[] === nothing
            return Consume(false)
        end
        x, y = mouseposition(obj.ax)
        obj.object.points[1][][obj.moving[]] = x
        obj.object.points[2][][obj.moving[]] = y
        notify(obj.object.points[begin])
        return Consume(true)
    end
end

#= }}}=#

#= }}}=#
