include("zad5.jl")

using GLMakie
using FileIO
using Observables
using Colors

using SparseArrays
using LinearAlgebra

GLMakie.activate!(framerate=60)

const DEFAULT_DT = 0.01
const DEFAULT_ELEMENTS = 100

# definition and setup {{{

struct HeatSimulation{R<:Real}
    M::AbstractSparseMatrix{R}
    F::AbstractVector{R}
    u::Observable{<:AbstractMatrix{R}}
    degree::NTuple{2,Integer}
    elements::NTuple{2,Integer}
    knots::NTuple{2,AbstractVector{R}}
    dt::R
    t::Observable{R}
end

function HeatSimulation(
    initial_state::AbstractMatrix{<:Real};
    dt::Real=DEFAULT_DT,
    degree::NTuple{2,Integer}=DEFAULT_PLANE_DEGREE,
    elements::NTuple{2,Integer}=DEFAULT_ELEMENTS
)
    R = typeof(initial_state).parameters[1]
    knots = ((e, d) -> get_knots(R(0):R(e), d)).(elements, degree)
    ns = get_ns(knots, degree)
    n = ns[1] * ns[2]
    result = HeatSimulation(
        sparse(R, I * R(0), n, n),
        Vector{R}(undef, n),
        Observable(Matrix{R}(undef, ns)),
        degree,
        elements,
        knots,
        dt,
        Observable(R(0)),
    )
    setup!(result)
    return result
end

function setup!(simulation::HeatSimulation)
    R = typeof(simulation).parameters[1]
    simulation.t[] = R(0)
    setup!(
        simulation.M,
        simulation.F,
        simulation.degree,
        simulation.elements,
        simulation.knots,
        simulation.dt,
    )
end

# % Value of 1D element mapping jacobian (size of the element)
# function a = jacobian1d(e, b)
#     a = b.points(e + 2) - b.points(e + 1);
# end
#
# % Value of 2D element mapping jacobian (size of the element)
# function a = jacobian2d(e, bx, by)
#     a = jacobian1d(e(1), bx) * jacobian1d(e(2), by);
# end

function setup!(
    M::AbstractSparseMatrix{R},
    F::AbstractVector{R},
    degree::NTuple{2,Integer},
    elements::NTuple{2,Integer},
    knots::NTuple{2,AbstractVector{R}},
    dt::Real,
) where {R<:Real}
    fill!(M, zero(R))
    dropzeros!(M)
    # TODO reset M
    # TODO reset F and boundaries
    # fill!(F, R(0))
    ns = get_ns(knots, degree)
    points = (n -> ((0:1/n:1))).(elements)
    for i = 1:elements[1], j = 1:elements[2]
        J = jacobian(points, (i, j))
    end
end

function get_ns(
    knots::NTuple{2,AbstractVector{<:Real}},
    degree::NTuple{2,Integer},
)
    return get_ns(length.(knots), degree)
end

function get_ns(
    sizes::NTuple{2,Real},
    degree::NTuple{2,Integer},
)
    return sizes .- degree .- 1
end

function jacobian(
    points::NTuple{2,AbstractVector{<:Real}},
    elements::NTuple{2,Integer}
)
    d = ((p, e) -> p[e+1] - p[e]).(points, elements)
    return d[1] * d[2]
end

#  }}}

# calculations {{{

# TODO should this all be modifying and what way will be the best

function step!(
    simulation::HeatSimulation,
    dt::Union{Real,Nothing}=nothing,
)
    if dt === nothing
        dt = simulation.dt
    end
    step!(
        simulation.M,
        simulation.F,
        simulation.u[],
        simulation.degree,
        simulation.elements,
        simulation.knots,
        dt,
    )
    notify(simulation.u)
    simulation.t[] += dt
    notify(simulation.t)
end

function step!(
    M::AbstractSparseMatrix{R},
    F::AbstractVector{R},
    u::AbstractMatrix{R},
    degree::NTuple{2,Integer},
    elements::NTuple{2,Integer},
    knots::NTuple{2,AbstractVector{R}},
    dt::Real,
) where {R<:Real}
    ns = get_ns(knots, degree)
    points = (n -> ((0:1/n:1))).(elements)
    # TODO
    ldiv!(u, M, F)
end

function step(
    simulation::HeatSimulation,
    dt::Union{Real,Nothing}=nothing,
)
    if dt === nothing
        dt = simulation.dt
    end
    return step(
        simulation.M,
        simulation.F,
        simulation.degree,
        simulation.elements,
        simulation.knots,
        dt,
    )
end

function step(
    M::AbstractSparseMatrix{<:Real},
    F::AbstractVector{<:Real},
    degree::NTuple{2,Integer},
    elements::NTuple{2,Integer},
    knots::NTuple{2,AbstractVector{<:Real}},
    dt::Real,
)
    R = typeof(M).parameters[1]
    result = Matrix{R}(undef, size(M))
    step!(M, F, result, degree, elements, knots, dt)
    return result
end

#  }}}

