# include("galois.jl")

function babyGiantStep(
        p::Int, q::Int, a::Int
)
    m::Int = ceil(sqrt(p-1))
    table::Vector{Int} = (i -> powermod(q, i, p)).(0:(m-1))
    r::Int = powermod(q, -m, p)
    k::Int = -1
    b::Int = a
    @simd for j in 0:(m-1)
        i::Union{Int, Nothing} = findfirst(isequal(b), table)
        if !isnothing(i)
            k = j*m + i-1
            return (m, table, r, k)
        end
        b = (b*r)%p
    end
    @assert k > 0
    return (m, table, r, k)
end

let
    p = 7
    q = 3
    a = 4

    m = 3
    tablica_testowa = [1,3,2]
    r = 6
    k = 4 #(j = 1, i = 1)

    result = babyGiantStep(p, q, a)
    println(result)
    @assert result == (m, tablica_testowa, r, k)
end

let
    p = 29
    q = 8
    a = 10

    m = 6
    tablica_testowa = [1,8,6,19,7,27]
    r = 9
    k = 17 #(j = 2, i = 5)

    result = babyGiantStep(p, q, a)
    println(result)
    @assert result == (m, tablica_testowa, r, k)
end

let
    p = 113
    q = 76
    a = 84

    m = 11
    tablica_testowa = [1,76,13,84,56,75,50,71,85,19,88]
    r = 70
    k = 3 #(j = 0, i = 3)

    result = babyGiantStep(p, q, a)
    println(result)
    @assert result == (m, tablica_testowa, r, k)
end

function primitiveRoot(p::Int, q::Int)
    powers::Set{Int} = Set()
    n::Int = q
    @simd for i in 1:(p-1)
        n = (n*q)%p
        if n in powers
            return false
        end
        push!(powers, n)
    end
    return true
end

function diffieHellman(p::Int, q::Int, m::Int, n::Int)
    @assert m > 0
    @assert m < p
    @assert n > 0
    @assert n < p
    @assert primitiveRoot(p, q)
    x, y = powermod(q, n, p), powermod(q, m, p)
    ak, bk = powermod(y, n, p), powermod(x, m, p)
    @assert ak == bk
    return (n, m, x, y, ak)
end

function diffieHellman(p::Int, q::Int)
    diffieHellman(p, q, rand(1:(p-1)), rand(1:(p-1)))
end

function attack(p::Int, q::Int, a::Int, b::Int)
    n::Int, m::Int, x::Int, y::Int, k::Int = diffieHellman(p, q, a, b)
    println((n, m, x, y, k))
    _, _, _, gn = babyGiantStep(p, q, x)
    _, _, _, gm = babyGiantStep(p, q, y)
    println((gn, gm))
    @assert gn == n
    @assert gm == m 
end

let
    @time attack(7, 5, 2, 3)
    @time attack(23, 10, 11, 12)
end

begin
    @time attack(101, 2, 69, 63)
    @time attack(2^19-1, 3, 420, 421)
end

using Primes

function genPrimitveRoot(p::Int)
    q::Int = 2
    while !primitiveRoot(p, q)
        q += 1
    end
    return q
end

begin
    genPrimitveRoot(23)
    genPrimitveRoot(101)
    genPrimitveRoot(2^19-1)
end

let
    p::Int = nextprime(2^20+1)
    @time attack(p, 5, 12345, 6789)
end

let
    @time p::Int = nextprime(2^21+1)
    @time q::Int = genPrimitveRoot(p)
    @time attack(p, q, 12345, 6789)
end

let
    @time p::Int = nextprime(2^22+1)
    @time q::Int = genPrimitveRoot(p)
    @time attack(p, q, 12345, 6789)
end

let
    @time p::Int = nextprime(2^25+1)
    @time q::Int = genPrimitveRoot(p)
    @time attack(p, q, 12345, 6789)
end

let
    @time p::Int = nextprime(2^26+1)
    @time q::Int = genPrimitveRoot(p)
    @time attack(p, q, 12345, 6789)
end

let
    p::Int = 2^31-1
    @time attack(p, genPrimitveRoot(p), 2^10, 2^16)
end
