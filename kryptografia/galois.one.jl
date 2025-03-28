import Base: +, -, *, ^, zero
using Polynomials
__revise_mode__ = :eval

# Integer ring

struct Zn{N}
    x::Int
    function Zn(x::Int, N::Int)
        new{N}((x + N) % N)
    end
    function Zn{N}(x::Int) where {N}
        Zn(x, N)
    end
end

macro ZnOp(name, func=name)
    a, b, N = esc.([:a, :b, :N])
    op = esc(name)
    func = esc(func)
    return quote
        function $op($a::Zn{$N}, $b::Int) where {$N}
            Zn{$N}(($func)($a.x, b))
        end
        function $op($a::Int, $b::Zn{$N}) where {$N}
            ($func)(b, a)
        end
        function $op($a::Zn{$N}, $b::Zn{$N}) where {$N}
            Zn{$N}(($func)($a.x, $b.x))
        end
    end
end
# @macroexpand @ZnOp +

@ZnOp(+)
@ZnOp(-)
@ZnOp(*)
@ZnOp(^, (x, y) -> powermod(x, y, N))

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

# Polynomial ring

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
    function ZnW{N}(x::Poly, W::Vector{Int}) where {N}
        ZnW(x, N, Poly(W))
    end
    function ZnW{N}(x::Vector{Int}, W::Poly) where {N}
        ZnW(Poly(x), N, W)
    end
end

macro ZnWOp(name)
    a, b, N = esc.([:a, :b, :N])
    op = esc(name)
    return quote
        function $op($a::ZnW{$N}, $b::ZnW{$N}) where {$N}
            println($a)
            println($b)
            @assert a.W == b.W
            ZnW{$N}(($op)($a.x, $b.x), $a.W)
        end
        function $op($a::ZnW{$N}, $b::Int) where {$N}
            ZnW{$N}(($op)($a.x, $b), $a.W)
        end
        function $op($a::Int, $b::ZnW{$N}) where {$N}
            ($op)(b, a)
        end
    end
end
# @macroexpand @ZnWOp +

@ZnWOp(+)
@ZnWOp(-)
@ZnWOp(*)

function Base.zero(::Type{ZnW{N}}) where {N}
    return ZnW{N}(zero(Poly), one(Poly))
end

function Base.zero(::ZnW{N}) where {N}
    return ZnW{N}(zero(Poly), one(Poly))
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
    zero(ZnW{17})
end
