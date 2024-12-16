import Base: +, -, *, ^
using Polynomials

# Zadanie 1

struct Zn{N}
    x::Int
    function Zn(x::Int, N::Int)
        new{N}((x + N) % N)
    end
    function Zn{N}(x::Int) where {N}
        Zn(x, N)
    end
end

function +(a::Zn{N}, b::Int) where {N}
    Zn{N}(a.x + b)
end
function +(a::Int, b::Zn{N}) where {N}
    b + a
end
function +(a::Zn{N}, b::Zn{N}) where {N}
    Zn{N}(a.x + b.x)
end

function -(a::Zn{N}, b::Int) where {N}
    Zn{N}(a.x - b)
end
function -(a::Int, b::Zn{N}) where {N}
    b - a
end
function -(a::Zn{N}, b::Zn{N}) where {N}
    Zn{N}(a.x - b.x)
end

function *(a::Zn{N}, b::Int) where {N}
    Zn{N}(a.x * b)
end
function *(a::Int, b::Zn{N}) where {N}
    b * a
end
function *(a::Zn{N}, b::Zn{N}) where {N}
    Zn{N}(a.x * b.x)
end

function ^(a::Zn{N}, b::Int) where {N}
    Zn{N}(powermod(a.x, b, N))
end
function ^(a::Int, b::Zn{N}) where {N}
    Zn{N}(powermod(a.x, b, N))
end
function ^(a::Zn{N}, b::Zn{N}) where {N}
    Zn{N}(powermod(a.x, b, N))
end

let
    x = Zn(2, 7)
    y = Zn(10, 7)
    z = Zn(14, 7)
    #2 3 0
    println(x, " ", y, " ", z)
    for e in [x + z, x * y, x^y, 6 + x, x + 6, 4 * y, y * 4]
        println(e)
    end
    #2 6 1 1 1 5 5
end

# Zadanie 2

const Poly = Polynomial{Int,:x}
struct ZnW{N}
    x::Poly
    W::Poly
    function ZnW(x::Poly, N::Int, W::Poly)
        new{N}(map(y -> (y + N * abs(y)) % N, x % W), W)
    end
    function ZnW(x::Vector{Int}, N::Int, W::Vector{Int})
        ZnW(Poly(x), N, Poly(W))
    end
    function ZnW{N}(x::Poly, W::Poly) where {N}
        ZnW(x, N, W)
    end
    function ZnW{N}(x::Vector{Int}, W::Vector{Int}) where {N}
        ZnW(Poly(x), N, Poly(W))
    end
end

function +(a::ZnW{N}, b::ZnW{N}) where {N}
    @assert a.W == b.W
    ZnW{N}(a.x + b.x, a.W)
end
function -(a::ZnW{N}, b::ZnW{N}) where {N}
    @assert a.W == b.W
    ZnW{N}(a.x - b.x, a.W)
end
function *(a::ZnW{N}, b::ZnW{N}) where {N}
    @assert a.W == b.W
    ZnW{N}(a.x * b.x, a.W)
end

function *(a::ZnW{N}, b::Int) where {N}
    ZnW{N}(a.x * b, a.W)
end
function *(a::Int, b::ZnW{N}) where {N}
    b * a
end

let
    x1 = reverse([7, 0, 0, 14, 0, 0, 0])
    x2 = reverse([24, 0, -5, -7, 13])
    x3 = reverse([23, -3, 1, 35, 0, 4])
    W = [1, 0, 0, 0, 1]
    zw1 = ZnW(x1, 17, W)
    zw2 = ZnW(x2, 17, W)
    zw3 = ZnW(x3, 17, W)
    println(zw1)
    println(zw2)
    println(zw3)
    println()
    println(zw1 + zw2)
    println(zw1 * zw2)
    println(6 * zw3)
    println(zw3 * 5)
    println(zw2 - zw3)
end
