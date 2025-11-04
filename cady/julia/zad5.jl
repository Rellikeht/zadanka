include("zad3.jl")

using GLMakie
using FileIO
using Observables
using Colors

using SparseArrays
using LinearAlgebra

const SparseFactorization = SparseArrays.UMFPACK.UmfpackLU
const DEFAULT_BITMAP_ELEMENTS = (50, 50)
const DEFAULT_BITMAP_DEGREE = (2, 2)

GLMakie.activate!(framerate=60)

# toplevel definitions {{{

function bitmap_terrain(
    bitmap::String;
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    bitmap_terrain(transpose(abs(load(bitmap))); elements, degree)
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:Real};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    R = typeof(bitmap).parameters[1]
    knot_vector = get_knots.((e -> (R(0):R(e)) ./ R(e)).(elements), degree)
    ns = ((ks, d) -> length(ks) - d - 1).(knot_vector, degree)
    A = (s -> sparse(R, I, s, s)).(ns)
    F = zeros(ns)
    splines = zeros.(degree .+ 1, ns, elements .+ 1)
    return bitmap_terrain(
        bitmap,
        elements,
        degree,
        knot_vector,
        A,
        F,
        splines,
    )
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:AbstractRGB};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    R = Float64
    knot_vector = get_knots.((e -> (R(0):R(e)) ./ R(e)).(elements), degree)
    ns = ((ks, d) -> length(ks) - d - 1).(knot_vector, degree)
    F = zeros(ns)
    splines = zeros.(degree .+ 1, ns, elements .+ 1)
    red = (c -> c.r |> R).(bitmap)
    green = (c -> c.g |> R).(bitmap)
    blue = (c -> c.b |> R).(bitmap)
    result = [
        Matrix{R}(undef, (0, 0)) for _ in 1:3
    ]
    for (i, color) in enumerate([red, green, blue])
        A = (s -> sparse(R, I, s, s)).(ns)
        fill!(F, R(0))
        fill!.(splines, R(0))
        result[i] = bitmap_terrain(
            color,
            elements,
            degree,
            knot_vector,
            A,
            F,
            splines,
        )
    end
    return tuple(result...)
end

#  }}}

# main calculations {{{

function bitmap_terrain(
    bitmap::AbstractMatrix{<:Real},
    elements::NTuple{2,Integer},
    degree::NTuple{2,Integer},
    knot_vector::NTuple{2,AbstractVector{<:Real}},
    A::NTuple{2,AbstractSparseMatrix},
    F::AbstractMatrix,
    splines::NTuple{2,AbstractArray{<:Real}},
)
    R = typeof(bitmap).parameters[1]
    # wtf that does besides 
    # prec = @. 2 * (elements + degree) + 1
    precision = elements .+ degree
    ns = ((ks, d) -> length(ks) - d - 1).(knot_vector, degree)
    qw = quad_weights.(R, degree .+ 1)
    qcoeffsp = quad_points.(R, degree .+ 1)
    qp = Vector{R}.(undef, length.(qcoeffsp))
    bounds = Vector{NTuple{2,R}}.(undef, elements)

    @inbounds @views for D in [Y, X]
        for e in 1:elements[D]
            low, high = dofs_on_element(knot_vector[D], degree[D], e)
            bounds[D][e] = element_boundary(knot_vector[D], degree[D], e)
            quad_points!(qp[D], bounds[D][e]..., qcoeffsp[D])
            for bi in low:high
                splines[D][:, bi, e] = calc_point.(
                    (knot_vector[D],),
                    (degree[D],),
                    (bi,),
                    qp[D],
                )
            end
        end
    end

    @inbounds @views for dim in [Y, X]
        for el in 1:elements[dim]
            xl, xh = dofs_on_element(knot_vector[dim], degree[dim], el)
            ex_bound_l, ex_bound_h = bounds[dim][el]
            J = ex_bound_h - ex_bound_l
            for bi in xl:xh
                for bk in xl:xh
                    for iq in 1:length(qw)
                        A[dim][bk, bi] += J * qw[dim][iq] *
                                          splines[dim][iq, bi, el] *
                                          splines[dim][iq, bk, el]
                    end
                end
            end
        end
    end

    @inbounds @views for ex in 1:elements[X]
        xl, xh = dofs_on_element(knot_vector[X], degree[X], ex)
        ex_bound_l, ex_bound_h = bounds[X][ex]
        quad_points!(qp[X], ex_bound_l, ex_bound_h, qcoeffsp[X])
        for ey in 1:elements[Y]
            yl, yh = dofs_on_element(knot_vector[Y], degree[Y], ey)
            ey_bound_l, ey_bound_h = bounds[Y][ey]
            quad_points!(qp[Y], ey_bound_l, ey_bound_h, qcoeffsp[Y])
            J = (ex_bound_h - ex_bound_l) * (ey_bound_h - ey_bound_l)
            for bk in xl:xh
                for bl in yl:yh
                    for iqx in eachindex(qp[X])
                        for iqy in eachindex(qp[Y])
                            fun = splines[X][iqx, bk, ex] *
                                  splines[X][iqy, bl, ey]
                            ids = res.(size(bitmap), (a -> a[begin]).((qp[X][iqx], qp[Y][iqy])))
                            F[bl, bk] += fun * qw[X][iqx] * qw[Y][iqy] * J * bitmap[ids...]
                        end
                    end
                end
            end
        end
    end

    solve_direction!(F, A[X], F)
    solve_direction!(transpose(F), A[Y], transpose(F))
    if ns == precision
        result = F
    else
        result = Matrix{R}(undef, precision)
        # TODO does this work?
        @views for i in 1:size(result)[X]
            for j in 1:size(result)[Y]
                i1 = ((j, i) .- 1) ./ floor.(precision ./ ns)
                i1 = Int.(floor.(i1) .+ 1)
                i1 = (((a, b) -> minimum((a, b)))).(i1, ns)
                result[j, i] = F[i1...]
            end
        end
    end
    # TODO why is height lost
    result .*= maximum(bitmap) / maximum(result)
    return result
end

#  }}}

# helpers {{{

function solve_direction!(
    out::AbstractMatrix,
    A::AbstractSparseMatrix,
    F::AbstractMatrix,
)
    fact = lu(A)
    return solve_direction!(out, fact, A, F)
end

function solve_direction!(
    out::AbstractMatrix,
    fact::Union{Factorization,SparseFactorization},
    A::AbstractSparseMatrix,
    F::AbstractMatrix,
)
    R = typeof(A).parameters[1]
    row_in = Vector{R}(undef, size(F, 2))
    row_out = Vector{R}(undef, size(out, 2))
    @views @inbounds for i in 1:size(F)[1]
        row_in .= F[i, :]
        ldiv!(row_out, fact, row_in)
        out[i, :] .= row_out
    end
end

function solve_direction(
    A::AbstractSparseMatrix,
    F::AbstractMatrix,
)
    R = typeof(A).parameters[1]
    fact = lu(A)
    result = Matrix{R}(undef, size(F))
    solve_direction!(result, fact, A, F)
    return result
end

function res(
    img_size::Integer,
    coord::Real,
)
    return floor((img_size - 1) * coord + 1) |> typeof(img_size)
end

function dofs_on_element(
    knot_vector::AbstractVector{<:Real},
    degree::Integer,
    elem_number::Integer,
)
    return (typeof(elem_number)(0), degree) .+
           first_dof_on_element(knot_vector, degree, elem_number)
end

function first_dof_on_element(
    knot_vector::AbstractVector{<:Real},
    degree::Integer,
    elem_number::Integer,
)
    low, _ = element_boundary(knot_vector, degree, elem_number)
    return (findlast(x -> x == low, knot_vector) - degree) |>
           typeof(elem_number)
end

function element_boundary(
    knots::AbstractVector{<:Real},
    degree::I,
    number::I,
) where {I<:Integer}
    # TODO do this for general case with loops
    # k = degree+1
    # initial = knot_vector[k]
    # for i in k:length(knots)
    #     if knot_vector[i] != initial
    #         k, initial = k+1, knot_vector[i]
    #     end
    # end
    return (knots[number+degree], knots[number+degree+1])
end

function get_points(
    ::Type{R},
    ::Val{:points},
) where {R<:Real}
    return (
        [R(0)],
        R.([-1, 1]) ./ R(3),
        [-1, 0, 1] .* sqrt(R(3) / R(5)),
        [-1, -1, 1, 1] .* sqrt.(
            R(3) .- [1, -1, -1, 1] .*
                    R(2) .* sqrt(R(6) / R(5))
        ) ./ R(7),
        [-1, -1, 0, 1, 1] .* sqrt.(
            R(5) .- [1, -1, 0, 1, -1] .* sqrt(R(10) / R(7))
        )
    )
end

function get_points(
    ::Type{R},
    ::Val{:weights},
) where {R<:Real}
    return (
        [R(2)],
        R.([1, 1]),
        R.([5, 8, 5]) ./ R(9),
        R(18) .+ [-1, 1, 1, -1] .* sqrt(R(30)) ./ R(36),
        (
            R.([322, 322, 512, 322, 322]) .+
            R(13) .* [-1, 1, 0, 1, -1] .* sqrt(R(70))
        ) ./ R(900)
    )
end

function quad_points(
    ::Type{R},
    k::Integer,
) where {R<:Real}
    points = get_points(R, Val(:points))
    if !(k in eachindex(points))
        k = maximum(eachindex(points))
    end
    return points[k]
end

function quad_weights(
    ::Type{R},
    k::Integer,
) where {R<:Real}
    weights = get_points(R, Val(:weights))
    if !(k in eachindex(weights))
        k = maximum(eachindex(weights))
    end
    return weights[k]
end

function quad_points!(
    result::AbstractVector{R},
    a::R,
    b::R,
    points::AbstractVector{R},
) where {R<:Real}
    result .= @. 0.5 * (a * (1 - points) + b * (points + 1))
end

function quad_points(
    a::R,
    b::R,
    points::AbstractVector{R},
) where {R<:Real}
    result = Vector{R}(undef, length(points))
    quad_points!(result, a, b, points)
    return result
end

#  }}}
