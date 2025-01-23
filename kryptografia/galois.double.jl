import Base: +, -, *, ^
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

# In case above doesn't work
# function ^(a::Zn{N}, b::Int) where {N}
#     Zn{N}(powermod(a.x, b, N))
# end
# function ^(a::Int, b::Zn{N}) where {N}
#     b^a
# end
# function ^(a::Zn{N}, b::Zn{N}) where {N}
#     Zn{N}(powermod(a.x, b.x, N))
# end

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
struct ZnW{N,W}
    x::Poly
    w::Poly
    function ZnW{N,W}(x::Poly, w::Poly) where {N,W}
        new{N,W}(map(y -> (y + N * abs(y)) % N, x % w), w)
    end
    function ZnW(x::Poly, N::Int, w::NTuple{M,Int}) where {M}
        ZnW{N,w}(x, Poly(w))
    end
    function ZnW{N,W}(x::Poly) where {N,W}
        ZnW{N,W}(x, Poly(W))
    end
    function ZnW(
        x::Union{Vector{Int},NTuple{M1,Int}},
        N::Int,
        w::NTuple{M2,Int}
    ) where {M1,M2}
        ZnW{N,w}(x, Poly(w))
    end
    function ZnW(
        x::Union{Vector{Int},NTuple{M,Int}},
        N::Int,
        w::Vector{Int}
    ) where {M}
        ZnW{N,tuple(w...)}(Poly(x), Poly(w))
    end
    function ZnW(x::Poly, N::Int, w::Poly)
        ZnW{N,tuple(w...)}(x, w)
    end
    function ZnW{N}(x::Poly, w::Poly) where {N}
        ZnW{N,tuple(w...)}(x, w)
    end
    function ZnW{N}(
        x::Union{Vector{Int},NTuple{M1,Int}},
        w::NTuple{M2,Int}
    ) where {N,M1,M2}
        ZnW{N,w}(x, w)
    end
    function ZnW{N}(
        x::Union{Vector{Int},NTuple{M,Int}},
        w::Vector{Int}
    ) where {N,M}
        ZnW{N,tuple(w...)}(x, w)
    end
end

macro ZnWOp(name)
    a, b, N, W = esc.([:a, :b, :N, :W])
    op = esc(name)
    return quote
        function $op($a::ZnW{$N,$W}, $b::ZnW{$N,$W}) where {$N,$W}
            ZnW{$N,$W}(($op)($a.x, $b.x), $a.w)
        end
        function $op($a::ZnW{$N,$W}, $b::Int) where {$N,$W}
            ZnW{$N,$W}(($op)($a.x, $b), $a.w)
        end
        function $op($a::Int, $b::ZnW{$N,$W}) where {$N,$W}
            ($op)(b, a)
        end
    end
end
# @macroexpand @ZnWOp +

@ZnWOp(+)
@ZnWOp(-)
@ZnWOp(*)

function Base.zero(::Type{ZnW{N,W}}) where {N,W}
    return ZnW{N,W}(zero(Poly))
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
    zero(ZnW{17,(1, 0, 0, 0, 1)})
end
