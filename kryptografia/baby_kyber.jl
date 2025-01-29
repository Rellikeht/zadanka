include("galois.jl")
using Random
__revise_mode__ = :eval

const TestN = 17
const TestW = (1, 0, 0, 0, 1)
const TestZnW = ZnW{TestN,TestW}
B1::Vector{Int} = [1, -1, 0, 0, 0, 0, 0, 0, 0, 0]
# B1::Vector{Int} = [1, -1, 1, -1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

function nz_rand(rng::AbstractRNG, t::T, dims::Int...) where {T}
    result = rand(rng, t, dims...)
    while allequal(iszero, result)
        rand!(rng, result, t)
    end
    return result
end

function nz_rand(t::T, dims::Int...) where {T}
    result = rand(t, dims...)
    while allequal(iszero, result)
        rand!(result, t)
    end
    return result
end

function key_gen(
    k::N1, N::N2, W::NTuple{M,N3}
)::Tuple{Matrix{ZnW{N,W}},Vector{ZnW{N,W}},Vector{ZnW{N,W}}} where
{N1<:Integer,N2<:Integer,N3<:Integer,M}
    n::Int = length(W) - 1
    A = rand(ZnW{N,W}, k, k)
    s = ZnW{N,W}.((_ -> nz_rand(B1, n)).(1:k))
    return A, key_gen(A, s, ZnW{N,W}.((_ -> nz_rand(B1, n)).(1:k))), s
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
        TestZnW([11, 16, 16, 6]) TestZnW([3, 6, 4, 9]);
        TestZnW([1, 10, 3, 5]) TestZnW([15, 9, 1, 6])
    ]
    s = [
        TestZnW([0, 1, -1, -1]),
        TestZnW([0, -1, 0, -1]),
    ]
    e = [
        TestZnW([0, 0, 1]),
        TestZnW([0, -1, 1]),
    ]
    t = key_gen(A, s, e)
    @assert t == [
        TestZnW([7, 0, 15, 16]),
        TestZnW([6, 11, 12, 10])
    ]
end

function div2(N::Int)::Int
    return div(N + 1, 2)
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
    v::ZnW{N,W} = (permutedims(t)*r)[1] + e2 + div2(N) * m
    return (u, v)
end

function encrypt(
    A::AbstractMatrix{ZnW{N,W}},
    t::AbstractVector{ZnW{N,W}},
    m::ZnW{N,W}
)::Tuple{Vector{ZnW{N,W}},ZnW{N,W}} where {N,W}
    k::Int = size(t)[1]
    n::Int = length(W) - 1
    r::Vector{ZnW{N,W}} = ZnW{N,W}.((_ -> nz_rand(B1, n)).(1:k))
    e1::Vector{ZnW{N,W}} = ZnW{N,W}.((_ -> nz_rand(B1, n)).(1:k))
    e2::ZnW{N,W} = ZnW{N,W}(nz_rand(B1, n))
    return encrypt(A, t, m, r, e1, e2)
end

function encrypt_test()
    A = [
        TestZnW([11, 16, 16, 6]) TestZnW([3, 6, 4, 9]);
        TestZnW([1, 10, 3, 5]) TestZnW([15, 9, 1, 6])
    ]
    s = [
        TestZnW([0, 1, -1, -1]),
        TestZnW([0, -1, 0, -1]),
    ]
    e = [
        TestZnW([0, 0, 1]),
        TestZnW([0, -1, 1]),
    ]
    t = key_gen(A, s, e)
    r = [
        TestZnW([0, 0, 1, -1]),
        TestZnW([-1, 0, 1, 1]),
    ]
    e1 = [
        TestZnW([0, 1, 1]),
        TestZnW([0, 0, 1]),
    ]
    e2 = TestZnW([0, 0, -1, -1])
    m = TestZnW([1, 1, 0, 1])
    result = encrypt(A, t, m, r, e1, e2)
    @assert result == ([
            TestZnW([3, 10, 11, 11]),
            TestZnW([11, 13, 4, 4]),
        ],
        TestZnW([16, 9, 6, 8]),
    )
end

function threshold(N::Int, x::Int)::Int
    return Int((N + x - div2(div2(N))) % N < div(N, 2))
    # return if abs(x - div2(N)) < min(x, N - x)
    #     1
    # else
    #     0
    # end
end

function threshold(N::Int, p::Poly)::Poly
    threshold.(N, p.coeffs)
end

function decrypt(
    u::AbstractVector{ZnW{N,W}},
    v::ZnW{N,W},
    s::AbstractVector{ZnW{N,W}}
)::ZnW{N,W} where {N,W}
    result::ZnW{N,W} = v - (permutedims(s)*u)[1]
    return ZnW{N,W}(threshold(N, result.x))
end

function decrypt_test()
    s = [
        TestZnW([0, 1, -1, -1]),
        TestZnW([0, -1, 0, -1]),
    ]
    u = [
        TestZnW([3, 10, 11, 11]),
        TestZnW([11, 13, 4, 4]),
    ]
    v = TestZnW([16, 9, 6, 8])
    result = decrypt(u, v, s)
    println(result)
    @assert result == TestZnW([1, 1, 0, 1])
end

function test(amount::N=1000) where {N<:Integer}
    success::Int = 0
    for _ in 1:amount
        A, t, s = key_gen(2, TestN, TestW)
        m = TestZnW(rand(RandomDevice(), Bool, 4))
        u, v = encrypt(A, t, m)
        decrypted = decrypt(u, v, s)
        # println(m.x.coeffs, " -> ", decrypted.x.coeffs)
        success += Int(decrypted == m)
    end
    println("Success rate: $(success / amount * 100)")
end
