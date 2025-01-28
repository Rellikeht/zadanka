include("galois.jl")
using Random
__revise_mode__ = :eval

const TestN = 17
const TestW = (1, 0, 0, 0, 1)

function nonzero_rand(range::OrdinalRange, n::Int)
    result::Vector{Int} = rand(range, n)
    while reduce(|, result) == 0
        rand!(result, range)
    end
    return result
end

function gen_key_data(
    k::N1, n::N2, w::NTuple{M,N3}
)::Tuple{Matrix{ZnW},Vector{ZnW},Vector{ZnW}} where
{N1<:Integer,N2<:Integer,N3<:Integer,M}
    (
        rand(ZnW{n,w}, k, k),
        # TODO distribution
        rand(ZnW{n,w}, k),
        rand(ZnW{n,w}, k)
    )
end

function key_gen(
    A::AbstractMatrix{ZnW{N,W}},
    s::AbstractVector{ZnW{N,W}},
    e::AbstractVector{ZnW{N,W}},
)::Vector{ZnW{N,W}} where {N,W}
    return A * s + e
end

function key_gen_test()
    A = [
        ZnW{TestN}([11, 16, 16, 6], TestW) ZnW{TestN}([3, 6, 4, 9], TestW);
        ZnW{TestN}([1, 10, 3, 5], TestW) ZnW{TestN}([15, 9, 1, 6], TestW)
    ]
    s = [
        ZnW{TestN}([0, 1, -1, -1], TestW),
        ZnW{TestN}([0, -1, 0, -1], TestW),
    ]
    e = [
        ZnW{TestN}([0, 0, 1], TestW),
        ZnW{TestN}([0, -1, 1], TestW),
    ]
    t = key_gen(A, s, e)
    @assert t == [
        ZnW{TestN,TestW}([7, 0, 15, 16]),
        ZnW{TestN,TestW}([6, 11, 12, 10])
    ]
end

function encrypt(
    A::AbstractMatrix{ZnW{N,W}},
    t::AbstractVector{ZnW{N,W}},
    m::ZnW{N,W},
    r::AbstractVector{ZnW{N,W}},
    e1::AbstractVector{ZnW{N,W}},
    e2::ZnW{N,W},
)::Tuple{Vector{ZnW{N,W}},ZnW{N,W}} where {N,W}
    u::Vector{ZnW{N,W}} = permutedims(A) * r + e1
    q2::Int = div(N, 2) + 1
    v::ZnW{N,W} = (permutedims(t)*r)[1] + e2 + q2 * m
    return (u, v)
end

# TODO distribution
function encrypt(
    A::AbstractMatrix{ZnW{N,W}},
    t::AbstractVector{ZnW{N,W}},
    m::ZnW{N,W}
)::Tuple{Vector{ZnW{N,W}},ZnW{N,W}} where {N,W}
    k::Int = size(t)
    r::Vector{ZnW{N,W}} = Poly(rand(-1:1, k))
    e1::Vector{ZnW{N,W}} = Poly(rand(-1:1, k))
    e2::ZnW{N,W} = Poly(rand(-1:1))
    return encrypt(A, t, m, r, e1, e2)
end

function encrypt_test()
    A = [
        ZnW{TestN}([11, 16, 16, 6], TestW) ZnW{TestN}([3, 6, 4, 9], TestW);
        ZnW{TestN}([1, 10, 3, 5], TestW) ZnW{TestN}([15, 9, 1, 6], TestW)
    ]
    s = [
        ZnW{TestN}([0, 1, -1, -1], TestW),
        ZnW{TestN}([0, -1, 0, -1], TestW),
    ]
    e = [
        ZnW{TestN}([0, 0, 1], TestW),
        ZnW{TestN}([0, -1, 1], TestW),
    ]
    t = key_gen(A, s, e)
    r = [
        ZnW{TestN}([0, 0, 1, -1], TestW),
        ZnW{TestN}([-1, 0, 1, 1], TestW),
    ]
    e1 = [
        ZnW{TestN}([0, 1, 1], TestW),
        ZnW{TestN}([0, 0, 1], TestW),
    ]
    e2 = ZnW{TestN,TestW}([0, 0, -1, -1])
    m = ZnW{TestN,TestW}([1, 1, 0, 1])
    result = encrypt(A, t, m, r, e1, e2)
    # println(result)
    @assert result == ([
            ZnW{TestN,TestW}([3, 10, 11, 11]),
            ZnW{TestN,TestW}([11, 13, 4, 4]),
        ],
        ZnW{TestN,TestW}([16, 9, 6, 8]),
    )
end

# TODO k
function decrypt(
    u::AbstractVector{ZnW{N,W}},
    v::ZnW{N,W},
    s::AbstractVector{ZnW{N,W}}
)::ZnW{N,W} where {N,W}
    # TODO
    return ZnW{N,W}([])
end

function test(amount::N=1000) where {N<:Integer}
    A = [
        ZnW{TestN}([11, 16, 16, 6], TestW) ZnW{TestN}([3, 6, 4, 9], TestW);
        ZnW{TestN}([1, 10, 3, 5], TestW) ZnW{TestN}([15, 9, 1, 6], TestW)
    ]
    s = [
        ZnW{TestN}([0, 1, -1, -1], TestW),
        ZnW{TestN}([0, -1, 0, -1], TestW),
    ]
    e = [
        ZnW{TestN}([0, 0, 1], TestW),
        ZnW{TestN}([0, -1, 1], TestW),
    ]
    t = key_gen(A, s, e)

    success::Int = 0
    for _ in 1:amount
        m = Polynomial(rand(Bool, 4))
        u, v = encrypt(A, t, m)
        decrypted = decrypt(u, v, s)
        success += decrypted == m
    end
    println("Success rate: $(success / amount)")
end
