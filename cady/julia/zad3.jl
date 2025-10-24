using GLMakie
using FileIO
using Observables
using Colors

using Makie: AbstractAxis
import Base: abs

const DEFAULT_INDICATOR = (default=true,)
const DEFAULT_ACCURACY = 200
const DEFAULT_DEGREE = 2
const DEFAULT_PLANE_ACCURACY = (DEFAULT_ACCURACY, DEFAULT_ACCURACY)
const DEFAULT_PLANE_DEGREE = (DEFAULT_DEGREE, DEFAULT_DEGREE)

GLMakie.activate!(framerate=60)

abstract type AbstractParametric end
abstract type AbstractLine{R<:Real,N} <: AbstractParametric end
abstract type AbstractPlane{R<:Real} <: AbstractParametric end

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

function Base.abs(color::AbstractRGB)
    sqrt(sum((color.r, color.g, color.b) .^ 2))
end

function get_value(o::Observable{T} where {T})
    return o[]
end

function get_value(r::Ref{T} where {T})
    return r[]
end

function get_value(v)
    return v
end

function normalize(arr::AbstractArray)
    result = abs.(arr)
    return result ./ maximum(result)
end

function fig_and_ax(
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    dimentions::Integer=2,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = nothing
    if dimentions == 2
        ax = Axis(fig[1, 1])
    elseif dimentions == 3
        ax = Axis3(fig[1, 1])
    elseif dimentions < 2
        error("Cannot draw in dimention lower than 2")
    else
        error("Cannot draw in dimention higher than 3")
    end
    return (fig, ax)
end

function background!(ax::Axis, img::AbstractMatrix{<:Real})
    imgp = image!(ax, img)
    translate!(imgp, 0, 0, -10)
    return imgp
end

function keep_alike!(
    arr::Union{Observable{<:AbstractVector{T}},AbstractVector{T}},
    target::Union{Observable{<:AbstractVector{T}},AbstractVector{T}},
    value::Union{T,Nothing}=nothing;
    replace::Bool=true,
) where {T}
    if arr isa Observable
        arr = arr[]
    end
    if target isa Observable
        target = target[]
    end
    if value === nothing
        value = zero(T)
    end
    target_len = length(target)
    if length(arr) != target_len
        resize!(arr, target_len)
        if replace
            fill!(arr, value)
        end
    end
    if !replace
        arr .= target
        arr .+= value
    end
    arr
end

#= }}}=#

#= kwargs and colors {{{=#

function color_range_observable(points::Observable{<:AbstractVecOrMat})
    range = Observable(eachindex(points[]))
    on(points) do _
        range[] = eachindex(points[])
    end
    return range
end

function color_range_observable(range::Observable{AbstractUnitRange})
    return range
end

function color_range_observable(range::AbstractUnitRange)
    return range
end

function color_range_observable(points::AbstractVecOrMat)
    return eachindex(points)
end

function default_kwargs(
    type::Symbol,
    kwargs::Union{Dict,NamedTuple,Nothing},
    base::Union{
        AbstractUnitRange,
        AbstractVecOrMat,
        Observable{<:Union{AbstractUnitRange,AbstractVecOrMat}}
    }
)
    range = color_range_observable(base)
    if kwargs === nothing
        return Dict()
    elseif kwargs != DEFAULT_INDICATOR
        return Dict((
            k => if v === :auto
                range
            else
                v
            end
            for (k, v) in pairs(kwargs)
        ))
    end
    if type == :plot
        return Dict(
            :linewidth => 4,
            :colormap => :viridis,
            :color => range,
        )
    elseif type == :scatter
        return Dict(
            :colormap => :viridis,
            :color => range,
            :markersize => 15,
            :strokewidth => 0,
        )
    elseif type == :plot_3d
        return Dict(
            :linewidth => 3,
        )
    elseif type == :scatter_3d
        return Dict(
            :colormap => :viridis,
            :color => range,
            :markersize => 10,
            :strokewidth => 0,
        )
    elseif type == :contour_3d
        levels = 20
        return Dict(
            :colormap => :viridis,
            :linewidth => 3,
            # TODO how to set this here properly
            # :color => 1:levels,
            :levels => levels,
        )
    else
        error("No default args defined for: $(type)")
    end
end

# function default_scatter_color

#= }}}=#

#= splines {{{=#

#= definitions {{{=#

struct Spline{R<:Real,N} <: AbstractLine{R,N}
    accuracy::Observable{<:Integer}
    degree::Observable{<:Integer}
    knots::Observable{<:AbstractVector{R}}
    points::NTuple{N,Observable{<:AbstractVector{R}}}
    line::NTuple{N,Observable{<:AbstractVector{R}}}
    ts::Observable{<:AbstractVector{R}}
end

function Spline(
    positions::AbstractVector{<:Union{Point{N,R},NTuple{N,R}}} where {N,R<:Real};
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
    lazy::Bool=false,
)
    return Spline(
        tuple_of_vectors(positions);
        knots,
        accuracy,
        degree,
        lazy,
    )
end

function Spline(
    positions::NTuple{N,AbstractVector{R}} where {N,R<:Real};
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
    lazy::Bool=false,
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
        Observable(Vector{R}(undef, accuracy)),
    )
    if !lazy
        on(spline.accuracy) do _
            adjust_sizes!(spline)
            calc_points!(spline)
        end
        on(spline.degree) do _
            adjust_knots!(spline)
            calc_points!(spline)
        end
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

function Spline(
    positions::AbstractVector{<:Real}...;
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
    lazy::Bool=false,
)
    return Spline(positions; knots, accuracy, degree, lazy)
end

function Spline(
    dimentions::Integer=2;
    type::Type=Float64,
    knots::Union{Nothing,AbstractVector{<:Real}}=nothing,
    accuracy::Integer=DEFAULT_ACCURACY,
    degree::Integer=DEFAULT_DEGREE,
    lazy::Bool=false,
)
    positions = tuple((type.(0:degree) for dim in 1:dimentions)...)
    return Spline(positions; knots, accuracy, degree, lazy)
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

function adjust_sizes!(
    spline::Spline
)
    (vec -> resize!(vec[], spline.accuracy[])).(spline.line)
    adjust_ts!(spline.ts, spline.accuracy, spline.knots)
end

function adjust_ts!(
    ts::AbstractVector{<:Real},
    accuracy::Integer,
    knots::AbstractVector{<:Real},
)
    resize!(ts, accuracy)
    ts_size = maximum(knots)
    step = ts_size / (accuracy - 1)
    ts .= 0:step:ts_size
end

function adjust_ts!(
    ts::Union{Observable{<:AbstractVector{<:Real}},AbstractVector{<:Real}},
    accuracy::Union{Integer,Observable{<:Integer}},
    knots::Union{Observable{<:AbstractVector{<:Real}},AbstractVector{<:Real}},
)
    adjust_ts!(
        get_value(ts),
        get_value(accuracy),
        get_value(knots),
    )
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
    @views @inbounds for dim in eachindex(spline.line)
        line, points, ts = spline.line[dim][], spline.points[dim][], spline.ts[]
        fill!(line, zero(typeof(spline).parameters[1]))
        line[begin] += points[begin]
        for i in eachindex(points)
            line .+= points[i] * calc_point.((spline,), i, ts)
        end
        # TODO proper knots handling
        # currently there is not proper support for duplicated knots
        adjusted_end = length(spline.knots[]) - spline.degree[] - 1
        for i in length(points)+1:adjusted_end
            line .+= points[end] * calc_point.((spline,), i, ts)
        end
    end
    notify(spline.line[begin])
end

#= }}}=#

#= operations {{{=#

function rotate!(
    spline::Spline{<:Real,2},
    angle::Real,
    around::NTuple{2,<:Real}=(0.0, 0.0),
)
    for dim in [1, 2]
        spline.points[dim][] .-= around[dim]
    end
    oldx, oldy = deepcopy.((x -> x[]).(spline.points[1:2]))
    spline.points[1][] .= oldx .* cos.(angle) - oldy .* sin.(angle)
    spline.points[2][] .= oldx .* sin.(angle) + oldy .* cos.(angle)
    for dim in [1, 2]
        spline.points[dim][] .-= around[dim]
    end
    notify(spline.points[begin])
end

# TODO proper 3d rotations

function rotate_around_z!(
    spline::Spline{<:Real,3},
    angle::Real,
    ax::NTuple{2,<:Real},
)
    for dim in [1, 2]
        spline.points[dim][] .-= ax[dim]
    end
    oldx, oldy = deepcopy.((x -> x[]).(spline.points[1:2]))
    spline.points[1][] .= oldx .* cos.(angle) - oldy .* sin.(angle)
    spline.points[2][] .= oldx .* sin.(angle) + oldy .* cos.(angle)
    for dim in [1, 2]
        spline.points[dim][] .+= ax[dim]
    end
    notify(spline.points[begin])
end

#= }}}=#

#= drawings {{{=#

function draw_splines(
    xs::Vector{R},
    degree::Integer=DEFAULT_DEGREE,
    accuracy::Integer=DEFAULT_ACCURACY;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
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
        lines!(ax, range, values; default_kwargs(:plot, plot_kwargs, range)...)
    end
    return fig
end

#= }}}=#

#= }}}=#

#= spline plane {{{=#

#= definitions {{{=#

struct SplinePlane{R<:Real} <: AbstractPlane{R}
    "heights of plane (coefficients of a matrix; can be set by user)"
    coeffs::Observable{<:AbstractMatrix{R}}
    "size of output plane (can be set by user)"
    accuracy::Observable{<:NTuple{2,Integer}}
    "degrees of respective splines (can be set by user)"
    degree::Observable{<:NTuple{2,Integer}}
    "knots in x and y"
    knots::NTuple{2,AbstractVector{R}}
    "parameter for calculating splines in x an dy"
    ts::NTuple{2,Observable{<:AbstractVector{R}}}
    "temporary spline in x"
    xspline::AbstractVector{R}
    "temporary splines in y"
    ysplines::Ref{<:AbstractMatrix{R}}
    "temporary array for plane"
    temp_plane::Ref{<:AbstractMatrix{R}}
    "calculated plane"
    plane::Observable{<:AbstractMatrix{R}}
end

function SplinePlane(
    coeffs::AbstractMatrix{<:Real};
    accuracy::NTuple{2,Integer}=DEFAULT_PLANE_ACCURACY,
    degree::NTuple{2,Integer}=DEFAULT_PLANE_DEGREE,
)
    R = typeof(coeffs).parameters[1]
    plane = SplinePlane(
        Observable(coeffs),
        Observable(accuracy),
        Observable(degree),
        tuple((Vector{R}(undef, 0) for _ in 1:2)...),
        tuple((Observable(Vector{R}(undef, 0)) for _ in 1:2)...),
        Vector{R}(undef, accuracy[2]),
        Ref(Matrix{R}(undef, accuracy)),
        Ref(Matrix{R}(undef, accuracy)),
        Observable(Matrix{R}(undef, accuracy)),
    )
    calc_points!(plane)
    for obs in [
        plane.coeffs,
        plane.accuracy,
        plane.degree,
    ]
        on(obs) do _
            calc_points!(plane)
        end
    end
    return plane
end

#= }}}=#

#= calculations {{{=#

function calc_points!(plane::SplinePlane{R}) where {R<:Real}
    yacc, xacc = plane.accuracy[]
    ydeg, xdeg = plane.degree[]
    sy, sx = size(plane.coeffs[])

    resize!.(plane.knots, size(plane.coeffs[]) .+ plane.degree[] .+ 1)
    get_knots!.(plane.knots, R.(size(plane.coeffs[])), plane.degree[])
    adjust_ts!.(plane.ts, plane.accuracy[], plane.knots)
    if size(plane.plane[]) != (yacc, xacc)
        plane.plane[] = zeros((yacc, xacc))
    else
        fill!(plane.plane[], zero(R))
    end
    resize!(plane.xspline, xacc)
    for collection in [
        plane.ysplines,
        plane.temp_plane,
        plane.plane,
    ]
        if size(collection[]) != (yacc, xacc)
            collection[] = Matrix{R}(undef, (yacc, xacc))
        end
    end

    coeffs, ysplines = plane.coeffs[], plane.ysplines[]
    temp_plane, output = plane.temp_plane[], plane.plane[]
    ts = (o -> o[]).(plane.ts)
    @inbounds @views for x in 1:sx
        ysplines[:, x] .= calc_point.((plane.knots[1],), ydeg, x, ts[1])
    end
    @inbounds for y in 1:sy
        plane.xspline .= calc_point.((plane.knots[2],), xdeg, y, ts[2])
        if y == 1
            plane.xspline[begin] = 1
        end
        @views for x in 1:sx
            transpose(temp_plane) .= plane.xspline
            if x == 1
                ysplines[begin, x] = 1
            end
            temp_plane .*= ysplines[:, x]
            temp_plane .*= coeffs[y, x]
            if x == 1
                ysplines[begin, x] = 0
            end
            output .+= temp_plane
        end
        if y == 1
            plane.xspline[begin] = 0
        end
    end
    notify(plane.plane)
end

#= }}}=#

#= operations {{{=#

# TODO rotations

#= }}}=#

#= }}}=#

#= demos {{{=#

struct Demo
    # TODO multiple of that ???
    object::AbstractParametric
    fig::Figure
    ax::AbstractAxis
    plot::AbstractPlot
    scatter::Union{Scatter,Nothing}
    moving::Observable{Union{Int,Nothing}}
end

function Makie.display(demo::Demo)
    display(demo.fig)
end

#= constructors {{{=#

function register_actions!(demo::Demo)
    deregister_interaction!(demo.ax, :rectanglezoom)
    on(
        on_mouse_button(demo),
        events(demo.ax).mousebutton,
        priority=5
    )
    on(
        on_mouse_position(demo),
        events(demo.ax).mouseposition,
        priority=5
    )
end

function Demo!(
    ax::Axis,
    line::AbstractLine;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1,2),
)
    plt = lines!(
        ax,
        line.line[dims[1]],
        line.line[dims[2]];
        (default_kwargs(:plot, plot_kwargs, line.line[begin]))...
    )
    sct = scatter!(
        ax,
        line.points[dims[1]],
        line.points[dims[2]];
        (default_kwargs(:scatter, scatter_kwargs, line.points[begin]))...
    )
    moving = Observable(nothing)
    object = Demo(
        line,
        ax.parent,
        ax,
        plt,
        sct,
        moving,
    )
    register_actions!(object)
    return object
end

function Demo(
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1,2),
)
    return Demo!(
        fig_and_ax(fig_kwargs)[2],
        line;
        scatter_kwargs,
        plot_kwargs,
        dims,
    )
end

function calculate_t_obs(
    t_obs::Observable{<:AbstractVector{<:Real}},
    spline::Spline,
)
    len = length(spline.points[begin][]) - 1
    resize!(t_obs[], len + 1)
    t_obs[] .= 0:len
    t_obs[] .*= spline.ts[][end] / len
end

function Demo!(
    ax::Axis,
    spline::Spline{<:Real,1};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    plt = lines!(ax, spline.ts, spline.line[begin]; default_kwargs(:plot, plot_kwargs, spline.line[begin])...)
    R = typeof(spline).parameters[1]
    t_obs::Observable{Vector{R}} = Observable(Vector{R}(undef, 0))
    calculate_t_obs(t_obs, spline)
    on(_ -> calculate_t_obs(t_obs, spline), spline.points[begin])
    sct = scatter!(ax, t_obs, spline.points[begin]; default_kwargs(:scatter, scatter_kwargs, spline.points[begin])...)
    moving = Observable(nothing)
    object = Demo(
        spline,
        ax.parent,
        ax,
        plt,
        sct,
        moving,
    )
    register_actions!(object)
    return object
end

function Demo(
    spline::Spline{<:Real,1};
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return Demo!(
        fig_and_ax(fig_kwargs)[2],
        spline;
        scatter_kwargs,
        plot_kwargs,
    )
end

function Demo!(
    ax::Axis,
    img::AbstractMatrix,
    line::AbstractLine;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1,2),
)
    background!(ax, img)
    return Demo!(ax, line; scatter_kwargs, plot_kwargs, dims)
end

function Demo(
    img::AbstractMatrix,
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1,2),
)
    return Demo!(
        fig_and_ax(fig_kwargs)[2],
        img,
        line;
        scatter_kwargs,
        plot_kwargs,
        dims,
    )
end

#= }}}=#

#= static demos {{{=#

function add_plots!(
    ax::Union{Axis,Axis3},
    lines::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N},
    points::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    ptype, stype = (typeof(ax) == Axis3) ? (:plot_3d, :scatter_3d) : (:plot, :scatter)
    plt = lines!(ax, lines...; (default_kwargs(ptype, plot_kwargs, lines[begin]))...)
    sct = scatter!(ax, points...; (default_kwargs(stype, scatter_kwargs, points[begin]))...)
end


function StaticDemo!(
    ax::Union{Axis,Axis3},
    line::AbstractLine;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return StaticDemo!(ax, line; scatter_kwargs, plot_kwargs)
end

function StaticDemo!(
    ax::Union{Axis,Axis3},
    line::AbstractLine;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing},
    plot_kwargs::Union{Dict,NamedTuple,Nothing},
)
    add_plots!(ax, line.lines, line.points; scatter_kwargs, plot_kwargs)
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
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_type::Symbol=:contour
)
    if plot_type == :lines
        plt = lines!(
            ax,
            plane.ts...,
            plane.plane;
            default_kwargs(:plot_3d, plot_kwargs, plane.ts[begin])...
        )
    elseif plot_type == :contour
        plt = contour3d!(
            ax,
            plane.ts...,
            plane.plane;
            default_kwargs(:contour_3d, plot_kwargs, plane.ts[begin])...
        )
    elseif plot_type == :scatter
        plt = scatter!(
            ax,
            plane.ts...,
            plane.plane;
            (default_kwargs(:scatter_3d, plot_kwargs, plane.ts[begin]))...
        )
    else
        error("Unsupported plot type: $(plot_type)")
    end
    moving = Observable(nothing)
    object = Demo(
        plane,
        ax.parent,
        ax,
        plt,
        nothing,
        moving,
    )
    return object
end

function StaticDemo(
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return StaticDemo!(
        fig_and_ax(fig_kwargs, length(line.points))[2],
        line;
        scatter_kwargs,
        plot_kwargs
    )
end

function StaticDemo(
    plane::AbstractPlane;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_type::Symbol=:contour,
)
    return StaticDemo!(
        fig_and_ax(fig_kwargs, 3)[2],
        plane;
        plot_kwargs,
        plot_type,
    )
end

function StaticDemo!(
    ax::Axis3,
    line::Spline{<:Real,2};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plane_dim::Symbol=:z,
    move::Real=0.0,
    fix::NTuple{2,Real}=(0.0, 0.0),
)
    lines, points = (), ()
    R = typeof(line).parameters[1]
    zero_points, zero_line = Observable.((Vector{R}(), Vector{R}()))
    zero_points = Observables.@map keep_alike!(
        &(zero_points),
        &(line.points[begin]),
        R(move),
    )
    zero_line = Observables.@map keep_alike!(
        &(zero_line),
        &(line.line[begin]),
        R(move),
    )

    fixed_line = Observable.((Vector{R}(), Vector{R}()))
    fixed_points = Observable.((Vector{R}(), Vector{R}()))
    fixed_line = [
        (Observables.@map keep_alike!(
        &(fixed_line[dim]),
        &(line.line[dim]),
        R(fix[dim]);
        replace=false,
    )) for dim in 1:2]
    fixed_points = [
        (Observables.@map keep_alike!(
        &(fixed_points[dim]),
        &(line.points[dim]),
        R(fix[dim]);
        replace=false,
        )) for dim in 1:2]

    if plane_dim == :x
        lines = (zero_line, fixed_line[1], fixed_line[2])
        points = (zero_points, fixed_points[1], fixed_points[2])
    elseif plane_dim == :y
        lines = (fixed_line[1], zero_line, fixed_line[2])
        points = (fixed_points[1], zero_points, fixed_points[2])
    elseif plane_dim == :z
        lines = (fixed_line[1], fixed_line[2], zero_line)
        points = (fixed_points[1], fixed_points[2], zero_points)
    else
        error("Invalid dimention: $(plane_dim)")
    end
    add_plots!(ax, lines, points; scatter_kwargs, plot_kwargs)
    return ax.parent
end

function StaticDemo!(
    demo::Demo,
    line::Spline{<:Real,2};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plane_dim::Symbol=:z,
    move::Real=0.0,
)
    StaticDemo!(demo.ax, line; scatter_kwargs, plot_kwargs, plane_dim, move)
    return demo
end

#= }}}=#

#= other demos {{{=#

function Demo(
    plane::AbstractPlane,
    line::AbstractLine{<:Real,2},
    img::Union{AbstractMatrix{<:Real},Nothing}=nothing;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plane_plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plane_dim::Symbol=:z,
    move::Real=0.0,
)
    demo = StaticDemo(
        plane;
        plot_kwargs=plane_plot_kwargs,
    )
    ax = Axis(demo.fig[1, 2])
    StaticDemo!(
        demo.ax,
        line;
        scatter_kwargs,
        plot_kwargs,
        plane_dim,
        move,
        fix=(-1.0, -1.0),
    )
    Demo!(ax, line; scatter_kwargs, plot_kwargs)
    if img !== nothing
        background!(ax, img)
    end
    return demo
end

function EditablePlaneDemo(
    plane::AbstractPlane;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = Axis3(fig[1, 1])
    # TODO demo with modifiable points in 3d
    # TODO may be better to have points in separate plot
    # axs = (Axis3(fig[1, 1]), Axis3(fig[1, 2]))
    # plane_demo = StaticDemo!(
    #     axs[1],
    #     plane;
    #     scatter_kwargs,
    #     plot_kwargs,
    # )
    # return (plane_demo, )
end

function EditablePlaneDemo(
    coeffs::AbstractMatrix{<:Real};
    degree::NTuple{2,Integer}=DEFAULT_PLANE_DEGREE,
    accuracy::NTuple{2,Integer}=DEFAULT_PLANE_ACCURACY,
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return EditablePlaneDemo(
        SplinePlane(coeffs; degree, accuracy);
        fig_kwargs,
        scatter_kwargs,
        plot_kwargs,
    )
end

#= }}}=#

#= event handlers {{{=#

function on_mouse_button(obj::Demo, dim_fix::Integer=0)
    return function (event)
        if event.button == Mouse.left
            plt, i = pick(obj.fig)
            if event.action == Mouse.press
                if Keyboard.d in events(obj.fig).keyboardstate
                    # Delete marker
                    if plt === obj.scatter
                        for j in eachindex(obj.object.points)
                            deleteat!(obj.object.points[j][], i)
                        end
                        notify(obj.object.points[begin])
                        return Consume(true)
                    end
                elseif Keyboard.a in events(obj.fig).keyboardstate
                    # Add marker
                    if mouseover(obj.ax, obj.ax.elements[:background])
                        pos = mouseposition(obj.ax)
                        for j in eachindex(obj.object.points)
                            push!(obj.object.points[j][], pos[j+dim_fix])
                        end
                        notify(obj.object.points[begin])
                        return Consume(true)
                    end
                end
                # start obj.moving
                if plt === obj.scatter
                    obj.moving[] = i
                    return Consume(true)
                end
            elseif event.action == Mouse.release
                # stop obj.moving
                if obj.moving[] !== nothing
                    pos = mouseposition(obj.ax)
                    for j in eachindex(obj.object.points)
                        obj.object.points[j][][obj.moving[]] = pos[j+dim_fix]
                    end
                    notify(obj.object.points[begin])
                    obj.moving[] = nothing
                    return Consume(true)
                end
            end
        end
        return Consume(false)
    end
end

function on_mouse_position(obj::Demo, dim_fix::Integer=0)
    return function (_)
        if obj.moving[] === nothing
            return Consume(false)
        end
        pos = mouseposition(obj.ax)
        for j in eachindex(obj.object.points)
            obj.object.points[j][][obj.moving[]] = pos[j+dim_fix]
        end
        notify(obj.object.points[begin])
        return Consume(true)
    end
end

#= }}}=#

#= }}}=#
