include("galois.jl")
import Base: zero
__revise_mode__ = :eval

const N = 17
const W = (1, 0, 0, 0, 1)

# Because fucking matmul doesn't work without this
Base.zero(::Type{ZnW{N,W}}) where {N,W} = ZnW{N,W}(zero(Poly))
Base.zero(::ZnW{N,W}) where {N,W} = ZnW{N,W}(zero(Poly))

function key_gen(
    A::AbstractMatrix{ZnW{N,W}},
    s::NTuple{2,ZnW{N,W}},
    e::NTuple{2,ZnW{N,W}},
)::Tuple{Matrix{ZnW{N,W}},Vector{ZnW{N,W}},NTuple{2,ZnW{N,W}}} where {N,W}
    return (A, A * [s[1]; s[2]] + [e[1]; e[2]], s)
end

function key_gen_test()
    A = [
        ZnW{N}([11, 16, 16, 6], W) ZnW{N}([3, 6, 4, 9], W);
        ZnW{N}([1, 10, 3, 5], W) ZnW{N}([15, 9, 1, 6], W)
    ]
    s = (
        ZnW{N}([0, 1, -1, -1], W),
        ZnW{N}([0, -1, 0, -1], W),
    )
    e = (
        ZnW{N}([0, 0, 1], W),
        ZnW{N}([0, -1, 1], W),
    )
    (_, t, _) = key_gen(A, s, e)
    @assert t == [
        ZnW{N,W}([7, 0, 15, 16]),
        ZnW{N,W}([6, 11, 12, 10])
    ]
end

function encrypt(
    A::AbstractMatrix{ZnW{N,W}},
    t::AbstractVector{ZnW{N,W}},
    m::Polynomial{<:Integer,:x}
)::Tuple{Vector{Poly},Poly} where {N,W}
    # TODO
end

function decrypt(u::AbstractVector{Poly},v::Poly)::Poly
    # TODO
end
