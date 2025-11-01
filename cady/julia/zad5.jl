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
    knot_vector = tuple((
        [
            zeros(R, degree[dim]);
            [R(i) for i in 0:elements[dim]];
            fill(R(elements[dim]), degree[dim])
        ] ./ elements[dim]
        for dim in [Y, X]
    )...)
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
    knot_vector = tuple((
        [
            zeros(R, degree[dim]);
            [R(i) for i in 0:elements[dim]];
            fill(R(elements[dim]), degree[dim])
        ] ./ elements[dim]
        for dim in [Y, X]
    )...)
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
    prec = @. 2 * (elements + degree) + 1
    ns = ((ks, d) -> length(ks) - d - 1).(knot_vector, degree)
    qw = quad_weights.(R, degree .+ 1)
    qcoeffsp = quad_points.(R, degree .+ 1)
    qp = Vector{R}.(undef, length.(qcoeffsp))

    for D in [Y, X]
        for e in 1:elements[D]
            low, high = dofs_on_element(knot_vector[D], degree[D], e)
            bounds = element_boundary(knot_vector[D], degree[D], e)
            quad_points!(qp[D], bounds..., qcoeffsp[D])
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

    for dim in [Y, X]
        for el in 1:elements[dim]
            xl, xh = dofs_on_element(knot_vector[dim], degree[dim], el)
            ex_bound_l, ex_bound_h = element_boundary(
                knot_vector[dim],
                degree[dim],
                el,
            )
            J = ex_bound_h - ex_bound_l
            for bi in xl:xh
                for bk in xl:xh
                    for iq in 1:length(qw)
                        A[dim][bk, bi] += qw[dim][iq] * J *
                                          splines[dim][iq, bi, el] *
                                          splines[dim][iq, bk, el]
                    end
                end
            end
        end
    end

    for ex in 1:elements[X]
        xl, xh = dofs_on_element(knot_vector[X], degree[X], ex)
        ex_bound_l, ex_bound_h = element_boundary(
            knot_vector[X],
            degree[X],
            ex,
        )
        quad_points!(qp[X], ex_bound_l, ex_bound_h, qcoeffsp[X])
        for ey in 1:elements[Y]
            yl, yh = dofs_on_element(knot_vector[Y], degree[Y], ey)
            ey_bound_l, ey_bound_h = element_boundary(
                knot_vector[Y],
                degree[Y],
                ey,
            )
            quad_points!(qp[Y], ey_bound_l, ey_bound_h, qcoeffsp[Y])
            J = (ex_bound_h - ex_bound_l) * (ey_bound_h - ey_bound_l)
            for bk in xl:xh
                for bl in yl:yh
                    for iqx in eachindex(qp[X])
                        for iqy in eachindex(qp[Y])
                            fun = splines[X][iqx, bk, ex] *
                                  splines[X][iqy, bl, ey]
                            ids = res.(size(bitmap), (a -> a[begin]).((qp[X][iqy], qp[Y][iqx])))
                            F[bl, bk] += fun * qw[X][iqx] * qw[Y][iqy] * J * bitmap[ids...]
                        end
                    end
                end
            end
        end
    end

    F = solve_direction(A[X], F)
    F = transpose(F)
    F = solve_direction(A[Y], F)
    F = transpose(F)
    if ns == prec
        result = deepcopy(F)
    else
        result = Matrix{R}(undef, prec)
        for i in 1:size(result)[X]
            for j in 1:size(result)[Y]
                i1 = ((j, i) .- 1) ./ floor.(prec ./ ns)
                i1 = Int.(floor.(i1) .+ 1)
                i1 = (((a, b) -> minimum((a, b)))).(i1, ns)
                result[j, i] = F[i1...]
            end
        end
    end
    result .*= 255
    return result
end

#  }}}

# helpers {{{

function solve_direction(
    A::AbstractSparseMatrix,
    F::AbstractMatrix,
)
    R = typeof(A).parameters[1]
    fact = lu(A)
    Q, U, L, P = diagm(fact.q), fact.U, fact.L, diagm(fact.p)
    result = zeros(R, size(F))
    for i in 1:size(F)[1]
        result[i, :] = transpose(Q) \ (U \ (L \ (P * F[i, :])))
    end
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

# colors {{{

function gray(color...)
    return my_gray(color...)
end

function my_gray(color::AbstractRGB)
    return abs(color) / sqrt(3.0)
end

function my_gray(color::NTuple{3,Real})
    return sqrt(sum(color .^ 2)) / sqrt(3.0)
end

function my_gray(color::Real...)
    my_gray(color)
end

function orig_gray(color::AbstractRGB)
    return typeof(color)(
        1.0 - 0.3 * color.r - 0.59 * color.g - 0.11 * color.b
    )
end

function orig_gray(color::NTuple{3,Real})
    return typeof(color)(
        1.0 - 0.3 * color[1] - 0.59 * color[2] - 0.11 * color[3]
    )
end

function orig_gray(color::Real...)
    orig_gray(color)
end

#  }}}
