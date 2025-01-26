include("galois.jl")
__revise_mode__ = :eval

const TestN = 17
const TestW = (1, 0, 0, 0, 1)

function gen_key_data(
    k::N1, n::N2, w::NTuple{M,N3}
)::Tuple{Matrix{ZnW},Vector{ZnW},Vector{ZnW}} where
{N1<:Integer,N2<:Integer,N3<:Integer,M}
    (
        rand(ZnW{n,w}, k, k),
        # TODO distribution
        rand(ZnW{n,w}, k, k),
        rand(ZnW{n,w}, k, k)
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
    m::Polynomial{I,:x},
    r::AbstractVector{ZnW{N,W}},
    e1::AbstractVector{ZnW{N,W}},
    e2::ZnW{N,W},
)::Tuple{Vector{ZnW{N,W}},ZnW{N,W}} where {N,W,I<:Integer}
    u::Vector{ZnW{N,W}} = transpose(A) * r + e1
    v::Vector{ZnW{N,W}} = transpose(t) * r + e2 # TODO what the fuck
    return ([], Poly([]))
end

# TODO k
function encrypt(
    A::AbstractMatrix{ZnW{N,W}},
    t::AbstractVector{ZnW{N,W}},
    m::Polynomial{I,:x}
)::Tuple{Vector{Poly},Poly} where {N,W,I<:Integer}
    r::Vector{Poly} = Poly(rand(-1:1, 2))
    e1::Vector{Poly} = Poly(rand(-1:1, 2))
    e2::Poly = Poly(rand(-1:1))
    u::Vector{Poly} = transpose(A) * r + e1
    # TODO
    return ([], Poly([]))
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
    m = Poly([1, 1, 0, 1])
end

# TODO k
function decrypt(
    u::AbstractVector{Poly},
    v::Poly,
    s::AbstractVector{ZnW{N,W}}
)::Poly where {N,W}
    # TODO
    return Poly([])
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
