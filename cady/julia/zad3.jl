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

abstract type AbstractParametric end
abstract type AbstractLine{R<:Real,N} <: AbstractParametric end
abstract type AbstractPlane{R<:Real} <: AbstractParametric end

GLMakie.activate!(framerate=60)

#= helpers {{{=#

#= general {{{=#

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

function get_value(o::Observable)
    return o[]
end

function get_value(r::Ref)
    return r[]
end

function get_value(v)
    return v
end

function normalize(arr::AbstractArray)
    result = abs.(arr)
    return result ./ maximum(result)
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

#= plotting {{{=#

function fig_and_ax(
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    dimentions::Integer=2,
)
    fig = Figure(; default_kwargs(:figure, fig_kwargs)...)
    if dimentions == 2
        ax = Axis(fig[1, 1]; default_kwargs(:axis, ax_kwargs)...)
    elseif dimentions == 3
        ax = Axis3(fig[1, 1]; default_kwargs(:axis_3d, ax_kwargs)...)
    elseif dimentions < 2
        error("Cannot draw in dimention lower than 2")
    else
        error("Cannot draw in dimention higher than 3")
    end
    return fig, ax
end

function background!(ax::Axis, img::AbstractMatrix{<:Real})
    imgp = image!(ax, img)
    translate!(imgp, 0, 0, -10)
    return imgp
end

function add_plots!(
    ax::Union{Axis,Axis3},
    line::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N},
    points::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    ptype, stype = (typeof(ax) == Axis3) ? (:plot_3d, :scatter_3d) : (:plot, :scatter)
    plt = lines!(ax, line...; (default_kwargs(ptype, plot_kwargs, line[begin]))...)
    sct = scatter!(ax, points...; (default_kwargs(stype, scatter_kwargs, points[begin]))...)
    return plt, sct
end

# TODO generalize
function add_plots!(
    ax::Axis,
    line::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N},
    points::NTuple{N,Observable{<:AbstractVector{<:Real}}} where {N},
    dims::NTuple{2,Integer};
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    plt = lines!(
        ax,
        line[dims[1]],
        line[dims[2]];
        (default_kwargs(:plot, plot_kwargs, line[begin]))...
    )
    sct = scatter!(
        ax,
        points[dims[1]],
        points[dims[2]];
        (default_kwargs(:scatter, scatter_kwargs, points[begin]))...
    )
    return plt, sct
end

function add_plots!(
    ax::Union{Axis,Axis3},
    line::AbstractLine{<:Real,N} where {N},
    dims::Union{NTuple{2,Integer},Nothing}=nothing;
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    if dims === nothing
        return add_plots!(ax, line.line, line.points; scatter_kwargs, plot_kwargs)
    else
        return add_plots!(ax, line.line, line.points, dims; scatter_kwargs, plot_kwargs)
    end
end

#= }}}=#

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
        Observable{<:Union{AbstractUnitRange,AbstractVecOrMat}},
        Nothing,
    }=nothing
)
    range = nothing
    if base !== nothing
        range = color_range_observable(base)
    end
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
    if type === :plot
        return Dict(
            :linewidth => 4,
            :colormap => :viridis,
            :color => range,
        )
    elseif type === :scatter
        return Dict(
            :colormap => :viridis,
            :color => range,
            :markersize => 15,
            :strokewidth => 0,
        )
    elseif type === :plot_3d
        return Dict(
            :colormap => :thermal,
            # TODO how to set this
            # :color => range,
        )
    elseif type === :scatter_3d
        return Dict(
            :colormap => :viridis,
            :color => range,
            :markersize => 10,
            :strokewidth => 0,
        )
    elseif type === :contour_3d
        levels = 20
        return Dict(
            :colormap => :viridis,
            :linewidth => 3,
            # TODO how to set this
            # :color => 1:levels,
            :levels => levels,
        )
    elseif type === :wireframe
        return Dict(
            :color => :blue,
            # :colormap => :viridis,
            # :color => range,
            :linewidth => 2,
        )
    elseif type === :figure || type === :axis || type === :axis_3d
        return Dict()
    else
        error("No default args defined for: $(type)")
    end
end

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
    on(spline.points[begin]) do _
        # TODO detect size change and adjust only then
        # adjust_knots!(spline)
        adjust_sizes!(spline)
        calc_points!(spline)
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
    xs::AbstractVector{<:Real},
    degree::Integer,
)
    return [fill(xs[begin], degree); xs; fill(xs[end], degree)]
end

function get_knots!(
    knots::AbstractVector{<:Real},
    length::Real,
    degree::Integer,
)
    @views fill!(knots[begin:begin+degree], 0)
    knots[begin+degree+1:end-degree] = 1:length-degree
    @views fill!(knots[end-degree+1:end], length - degree)
end

function get_knots!(
    knots::AbstractVector{<:Real},
    degree::Integer,
)
    len = length(knots) - degree - 1
    @views fill!(knots[begin:begin+degree], 0)
    knots[begin+degree+1:end-degree] = 1:len-degree
    @views fill!(knots[end-degree+1:end], len - degree)
end

function adjust_knots!(
    knots::AbstractVector{<:Real},
    points::Integer,
    degree::Integer,
)
    resize!(
        knots,
        points + degree + 1
    )
    get_knots!(
        knots,
        points,
        degree
    )
end

function adjust_knots!(
    knots::AbstractVector{<:Real},
    points::AbstractVector{<:Real},
    degree::Integer,
)
    adjust_knots!(knots, length(points), degree)
end

function adjust_knots!(spline::Spline)
    adjust_knots!(
        spline.knots[],
        spline.points[begin][],
        spline.degree[],
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
    ts::AbstractVector{<:Real},
    accuracy::Integer,
    ends::NTuple{2,Real},
)
    resize!(ts, accuracy)
    step = ends[2] / (accuracy - 1)
    ts .= 0:step:ends[1]
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
        0 # left ?
    else
        left * (x - knots[index]) / tmp
    end
    tmp = knots[index+degree+1] - knots[index+1]
    right = calc_point(knots, degree - 1, index + 1, x)
    right = if tmp == 0
        0 # right ?
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

function calc_points!(
    degree::Integer,
    knots::AbstractVector{<:Real},
    points::NTuple{N,Observable{<:AbstractVector{<:Real}}} where N,
    ts::AbstractVector{<:Real},
    line::NTuple{N,Observable{<:AbstractVector{<:Real}}} where N,
)
    @views @inbounds for dim in eachindex(line)
        calc_points!(
            degree,
            knots,
            points[dim][],
            ts,
            line[dim][],
        )
    end
end

function calc_points!(
    degree::Integer,
    knots::AbstractVector{<:Real},
    points::AbstractVector{<:Real},
    ts::AbstractVector{<:Real},
    line::AbstractVector{<:Real},
)
    @views @inbounds begin
        line, points, ts = line, points, ts
        fill!(line, zero(typeof(line).parameters[1]))
        line[begin] += points[begin]
        j = 1
        adjusted_end = length(knots) - degree - 1
        for i in 1:adjusted_end
            line .+= points[j] * calc_point.((knots,), degree, i, ts)
            knot = i + degree
            if knot >= adjusted_end ||
                knots[knot] != knots[knot+1]
                j += 1
            end
        end
    end
end

function calc_points!(spline::Spline)
    calc_points!(
        spline.degree[],
        spline.knots[],
        spline.points,
        spline.ts[],
        spline.line,
    )
    notify.(spline.line)
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
    notify.(spline.points)
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
    notify.(spline.points)
end

#= }}}=#

#= drawings {{{=#

function draw_splines(
    xs::Union{AbstractVector{<:Real},Nothing}=nothing,
    degree_or_knots::Union{Integer,AbstractVector{<:Real}}=DEFAULT_DEGREE,
    accuracy::Integer=DEFAULT_ACCURACY;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    fig = Figure(; default_kwargs(:figure, fig_kwargs)...)
    ax = Axis(fig[1, 1]; default_kwargs(:axis, ax_kwargs)...)
    if degree_or_knots isa AbstractVector
        degree = 0
        for e in degree_or_knots[begin+1:end]
            if e != degree_or_knots[begin]
                break
            end
            degree += 1
        end
        knots = degree_or_knots
    else
        if xs === nothing
            error("Incorrect values")
        end
        degree = degree_or_knots
        knots = get_knots(xs, degree_or_knots)
    end
    step = (maximum(knots) - minimum(knots)) / (accuracy - 1)
    range = minimum(knots):step:maximum(knots)
    for i in 1:length(knots)-degree-1
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
    coeffs::Union{AbstractMatrix{<:Real},Observable{AbstractMatrix{<:Real}}};
    accuracy::NTuple{2,Integer}=DEFAULT_PLANE_ACCURACY,
    degree::NTuple{2,Integer}=DEFAULT_PLANE_DEGREE,
)
    R = typeof(coeffs).parameters[1]
    if accuracy < size(coeffs)
        error("Not enough output to fit coefficients")
    end
    if coeffs isa AbstractMatrix
        coeffs = Observable(coeffs)
    end
    plane = SplinePlane(
        coeffs,
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

function update_plane!(
    plane::AbstractMatrix{R},
    coeffs::AbstractMatrix{R},
    xspline::AbstractVector{R},
    ysplines::AbstractMatrix{R},
    temp_plane::AbstractMatrix{R},
    ts::NTuple{2,AbstractVector{R}},
    knots::NTuple{2,AbstractVector{R}},
    degree::NTuple{2,Real},
) where {R}
    sy, sx = size(coeffs)
    ydeg, xdeg = degree
    @inbounds @views for x in 1:sx
        ysplines[:, x] .= calc_point.((knots[1],), ydeg, x, ts[1])
    end
    @inbounds for y in 1:sy
        xspline .= calc_point.((knots[2],), xdeg, y, ts[2])
        if y == 1
            xspline[begin] = 1
        end
        for x in 1:sx
            if coeffs[y, x] == 0
                continue
            end
            transpose(temp_plane) .= xspline
            if x == 1
                ysplines[begin, x] = 1
            end
            # numerically unstable
            (@view ysplines[:, x]) .*= coeffs[y, x]
            @views temp_plane .*= ysplines[:, x]
            (@view ysplines[:, x]) ./= coeffs[y, x]
            # more numerically stable but slower
            # temp_plane .*= ysplines[:, x]
            # temp_plane .*= coeffs[y, x]
            if x == 1
                ysplines[begin, x] = 0
            end
            plane .+= temp_plane
        end
        if y == 1
            xspline[begin] = 0
        end
    end
end

function calc_points!(plane::SplinePlane)
    R = typeof(plane).parameters[1]
    yacc, xacc = plane.accuracy[]
    ydeg, xdeg = plane.degree[]
    sy, sx = size(plane.coeffs[])
    resize!.(plane.knots, (sx, sy) .+ plane.degree[] .+ 1)
    get_knots!.(plane.knots, R.((sx, sy)), plane.degree[])
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
    update_plane!(
        plane.plane[],
        plane.coeffs[],
        plane.xspline,
        plane.ysplines[],
        plane.temp_plane[],
        (o -> o[]).(plane.ts),
        plane.knots,
        (ydeg, xdeg),
    )
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
    dims::NTuple{2,Integer}=(1, 2),
)
    plt, sct = add_plots!(ax, line, dims; scatter_kwargs, plot_kwargs)
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
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1, 2),
)
    return Demo!(
        fig_and_ax(fig_kwargs, ax_kwargs)[2],
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
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return Demo!(
        fig_and_ax(fig_kwargs, ax_kwargs)[2],
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
    dims::NTuple{2,Integer}=(1, 2),
)
    background!(ax, img)
    return Demo!(ax, line; scatter_kwargs, plot_kwargs, dims)
end

function Demo(
    img::AbstractMatrix,
    line::AbstractLine;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    dims::NTuple{2,Integer}=(1, 2),
)
    return Demo!(
        fig_and_ax(fig_kwargs, ax_kwargs)[2],
        img,
        line;
        scatter_kwargs,
        plot_kwargs,
        dims,
    )
end

#= }}}=#

#= static demos {{{=#

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
    plt, sct = add_plots!(ax, line; scatter_kwargs, plot_kwargs)
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
    plot_type::Symbol=:surface
)
    if plot_type == :surface
        plt = surface!(
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
    elseif plot_type == :wireframe
        plt = wireframe!(
            ax,
            plane.ts...,
            plane.plane;
            default_kwargs(:wireframe, plot_kwargs, plane.plane)...
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
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return StaticDemo!(
        fig_and_ax(fig_kwargs, ax_kwargs, length(line.points))[2],
        line;
        scatter_kwargs,
        plot_kwargs
    )
end

function StaticDemo(
    plane::AbstractPlane;
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_type::Symbol=:contour,
)
    return StaticDemo!(
        fig_and_ax(fig_kwargs, ax_kwargs, 3)[2],
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
    fig_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plane_plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_type::Symbol=:surface,
    plane_dim::Symbol=:z,
    move::Real=0.0,
)
    demo = StaticDemo(
        plane;
        fig_kwargs,
        plot_kwargs=plane_plot_kwargs,
        plot_type,
    )
    ax = Axis(demo.fig[1, 2]; default_kwargs(:axis, ax_kwargs)...)
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
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    fig = Figure(; (fig_kwargs === nothing ? Dict() : fig_kwargs)...)
    ax = Axis3(fig[1, 1]; default_kwargs(:axis_3d, ax_kwargs)...)
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
    ax_kwargs::Union{Dict,NamedTuple,Nothing}=nothing,
    scatter_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
    plot_kwargs::Union{Dict,NamedTuple,Nothing}=DEFAULT_INDICATOR,
)
    return EditablePlaneDemo(
        SplinePlane(coeffs; degree, accuracy);
        fig_kwargs,
        ax_kwargs,
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
                        notify.(obj.object.points)
                        return Consume(true)
                    end
                elseif Keyboard.a in events(obj.fig).keyboardstate
                    # Add marker
                    if mouseover(obj.ax, obj.ax.elements[:background])
                        pos = mouseposition(obj.ax)
                        for j in eachindex(obj.object.points)
                            push!(obj.object.points[j][], pos[j+dim_fix])
                        end
                        notify.(obj.object.points)
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
                    notify.(obj.object.points)
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
        notify.(obj.object.points)
        return Consume(true)
    end
end

#= }}}=#

#= }}}=#
