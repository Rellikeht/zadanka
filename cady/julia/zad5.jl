include("zad3.jl")

using GLMakie
using FileIO
using Observables
using Colors

using SparseArrays # this is in base already
using LinearAlgebra

const SparseFactorization = SparseArrays.UMFPACK.UmfpackLU
const DEFAULT_BITMAP_ELEMENTS = (50, 50)
const DEFAULT_BITMAP_DEGREE = (2, 2)
const X, Y = 2, 1

GLMakie.activate!(framerate=60)

function bitmap_terrain(
    bitmap::String;
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    bitmap_terrain(abs(load(bitmap)); elements, degree)
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:Real};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    # TODO
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:AbstractRGB};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    # R = typeof(bitmap).parameters[1]
    R = Float64
    prec = @. 2 * (elements + degree) + 1

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
    FR = zeros(ns)
    FG = deepcopy(FR)
    FB = deepcopy(FR)
    red = (c -> c.r).(bitmap)
    green = (c -> c.g).(bitmap)
    blue = (c -> c.b).(bitmap)
    splines = zeros.(degree .+ 1, ns, elements .+ 1)
    GRAY = Matrix{R}(undef, prec) # coeffs

    for D in [Y, X]
        for e in 1:elements[D]
            low, high = dofs_on_element(knot_vector[D], degree[D], e)
            bounds = element_boundary(knot_vector[D], degree[D], e)
            qp = quad_points(bounds..., degree[D] + 1)
            # qw = quad_weights(bounds..., degree[D] + 1)
            for bi in low:high
                splines[D][:, bi, e] = calc_point.(
                    (knot_vector[D],),
                    (degree[D],),
                    (bi,),
                    qp,
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
            qp = quad_points(ex_bound_l, ex_bound_h, degree[dim] + 1)
            qw = quad_weights(ex_bound_l, ex_bound_h, degree[dim] + 1)
            for bi in xl:xh
                for bk in xl:xh
                    for iq in 1:length(qp)
                        A[dim][bk, bi] += qw[iq] * J *
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
        qpx = quad_points(ex_bound_l, ex_bound_h, degree[X] + 1)
        qwx = quad_weights(ex_bound_l, ex_bound_h, degree[X] + 1)
        for ey in 1:elements[Y]
            yl, yh = dofs_on_element(knot_vector[Y], degree[Y], ey)
            ey_bound_l, ey_bound_h = element_boundary(
                knot_vector[Y],
                degree[Y],
                ey,
            )
            qpy = quad_points(ey_bound_l, ey_bound_h, degree[Y] + 1)
            qwy = quad_weights(ey_bound_l, ey_bound_h, degree[Y] + 1)
            J = (ex_bound_h - ex_bound_l) * (ey_bound_h - ey_bound_l)
            for bk in xl:xh
                for bl in yl:yh
                    for iqx in eachindex(qpx)
                        for iqy in eachindex(qpy)
                            fun = splines[X][iqx, bk, ex] *
                                  splines[X][iqy, bl, ey]
                            color_ids = res.(size(bitmap), (a -> a[begin]).((qpy[iqy], qpx[iqx])))
                            FR[bl, bk] += fun * qwx[iqx] * qwy[iqy] * J * red[color_ids...]
                            FG[bl, bk] += fun * qwx[iqx] * qwy[iqy] * J * green[color_ids...]
                            FB[bl, bk] += fun * qwx[iqx] * qwy[iqy] * J * blue[color_ids...]
                        end
                    end
                end
            end
        end
    end

    RR, GG, BB = solve_direction(A[X], FR, FG, FB)
    RR, GG, BB = solve_direction(
        A[Y],
        transpose(RR),
        transpose(GG),
        transpose(BB),
    )
    RR, GG, BB = transpose.((RR, GG, BB))
    if ns == prec
        GRAY .= gray.(RR, GG, BB)
    else
        for i in 1:size(GRAY)[X]
            for j in 1:size(GRAY)[Y]
                i1 = ((j, i) .- 1) ./ floor.(prec ./ ns)
                i1 = Int.(floor.(i1) .+ 1)
                i1 = (((a, b) -> minimum((a, b)))).(i1, ns)
                GRAY[j, i] = gray((a -> a[i1...]).((RR, GG, BB))...)
            end
        end
    end
    GRAY .*= 255
    return GRAY

    # result = Matrix{R}(undef, prec) # Z
    # temp = Matrix{R}(undef, prec)
    # # TODO too much .+1
    # xspline = Vector{R}(undef, prec[X] + 1)
    # ysplines = Matrix{R}(undef, prec .+ 1)
    # ts = Vector{R}.(undef, prec)
    # ts = adjust_ts!.(ts, prec, knot_vector)
    # # TODO is this correct
    # adjust_knots!.(knot_vector, prec .+ 1, degree)
    # get_knots!.(knot_vector, degree)
    #
    # # TODO how to do this
    # update_plane!(
    #     result,
    #     GRAY,
    #     xspline,
    #     ysplines,
    #     temp,
    #     ts,
    #     knot_vector,
    #     degree,
    # )
    # return result
end

function solve_direction(
    A::AbstractSparseMatrix,
    FR,
    FG,
    FB,
)
    R = typeof(A).parameters[1]
    F = lu(A)
    RR = zeros(R, size(FR))
    GG = zeros(R, size(FG))
    BB = zeros(R, size(FB))
    for i in 1:size(FR)[2]
        RR[:, i] = solveRHS(F, FR[:, i])
        GG[:, i] = solveRHS(F, FG[:, i])
        BB[:, i] = solveRHS(F, FB[:, i])
    end
    return RR, GG, BB
end

function solveRHS(
    input::Factorization,
    b::AbstractVector{<:Real},
)
    Q, U, L, P = input.q |> diagm, input.U, input.L, input.p |> diagm
    return transpose(Q) \ (U \ (L \ (P * b)))
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
    return (0, degree) .+
           first_dof_on_element(knot_vector, degree, elem_number)
end

function first_dof_on_element(
    knot_vector::AbstractVector{<:Real},
    degree::Integer,
    elem_number::Integer,
)
    low, _ = element_boundary(knot_vector, degree, elem_number)
    return findlast(x -> x == low, knot_vector) - degree
end

# % Finds lower and higher boundary of element
# function [low,high]=element_boundary(knot_vector,p,elem_number)
#   initial = knot_vector(1);
#   kvsize = size(knot_vector,2);
#   k = 0;
#   low=0;
#   high=0;
#   for i=1:kvsize
#     if (knot_vector(i) ~= initial)
#       initial = knot_vector(i);
#       k = k+1;
#     end
#     if (k == elem_number)
#       low = knot_vector(i-1);
#       high = knot_vector(i);
#       return;
#     end
#   end
# end

function element_boundary(
    knots::AbstractVector{<:Real},
    degree::Integer,
    number::Integer,
)
    # TODO do this for general case with loops
    # k = degree+1
    # initial = knot_vector[k]
    # for i in k:length(knots)
    #     if knot_vector[i] != initial
    #         k, initial = k+1, knot_vector[i]
    #     end
    # end
    return knots[[number + degree, number + degree + 1]]
end

function quad_points(
    a::R,
    b::R,
    k::Integer,
) where {R<:Real}
    POINTS = [
        R.([0]),
        R.([-1, 1]) ./ R(3),
        [-1, 0, 1] .* sqrt(R(3) / R(5)),
        [-1, -1, 1, 1] .* sqrt.(
            R(3) .- [1, -1, -1, 1] .*
                    R(2) .* sqrt(R(6) / R(5))
        ) / R(7),
        [-1, -1, 0, 1, 1] .* sqrt.(
            R(5) .- [1, -1, 0, 1, -1] .* sqrt(R(10) / R(7))
        )
    ]
    if !(k in eachindex(POINTS))
        k = maximum(eachindex(POINTS))
    end
    return @. 0.5 * (a * (1 - POINTS[k]) + b * (POINTS[k] + 1))
end

function quad_weights(
    _::R,
    _::R,
    k::Integer,
) where {R<:Real}
    WEIGHTS = [
        R.([2]),
        R.([1, 1]),
        R.([5, 8, 5]) ./ R(9),
        R(18) .+ [-1, 1, 1, -1] .* sqrt(R(30)) ./ R(36),
        (
            R.([322, 322, 512, 322, 322]) .+
            R(13) .* [-1, 1, 0, 1, -1] .* sqrt(R(70))
        ) ./ R(900)
    ]
    if !(k in eachindex(WEIGHTS))
        k = maximum(eachindex(WEIGHTS))
    end
    return WEIGHTS[k]
end

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
