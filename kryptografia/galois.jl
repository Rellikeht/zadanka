using Polynomials
using Random
import Base: +, -, *, ^, ==, rand, zero
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
const Polys::Dict = Dict()
function get_poly(w::NTuple{M,I})::Poly where {M,I<:Integer}
    if !haskey(Polys, w)
        Polys[w] = Poly(w)
    end
    return Polys[w]
end

const PolyContainers{M,I} = Union{Vector{I},NTuple{M,I}}
struct ZnW{N,W}
    x::Poly
    function ZnW{N,W}(x::Poly) where {N,W}
        w::Poly = get_poly(W)
        new{N,W}(map(y -> (y + N * abs(y)) % N, x % w))
    end
    function ZnW{N,W}(x::PolyContainers{M,I}) where {N,W,M,I}
        ZnW{N,W}(Poly(x))
    end

    function ZnW{N}(x::Poly, w::Poly) where {N}
        ZnW{N,tuple(w...)}(x)
    end
    function ZnW{N}(x::PolyContainers{M,I}, w::Poly) where {N,M,I<:Integer}
        ZnW{N,tuple(w...)}(Poly(x))
    end
    function ZnW{N}(x::T, w::PolyContainers{M,I}) where {N,M,I<:Integer,T}
        ZnW{N,tuple(w...)}(x)
    end

    function ZnW(x::Poly, n::N, w::Poly) where {N<:Integer}
        ZnW{n,tuple(w...)}(x)
    end
    function ZnW(
        x::PolyContainers{M,I},
        n::N,
        w::Poly
    ) where {M,I<:Integer,N<:Integer}
        ZnW{n,tuple(w...)}(Poly(x))
    end
    function ZnW(
        x::T,
        n::N,
        w::PolyContainers{M,I}
    ) where {M,I<:Integer,N<:Integer,T}
        ZnW{n,tuple(w...)}(Poly(x))
    end
end

macro ZnWOp(name)
    a, b, N, W = esc.([:a, :b, :N, :W])
    op = esc(name)
    return quote
        function $op($a::ZnW{$N,$W}, $b::ZnW{$N,$W}) where {$N,$W}
            ZnW{$N,$W}(($op)($a.x, $b.x))
        end
        function $op($a::ZnW{$N,$W}, $b::Int) where {$N,$W}
            ZnW{$N,$W}(($op)($a.x, $b))
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

function (==)(a::ZnW{N,W}, b::ZnW{N,W})::Bool where {N,W}
    return a.x == b.x
end

# Because fucking matmul doesn't work without this
Base.zero(::Type{ZnW{N,W}}) where {N,W} = ZnW{N,W}(zero(Poly))
Base.zero(::ZnW{N,W}) where {N,W} = ZnW{N,W}(zero(Poly))

function rand(::Type{ZnW{N,W}}) where {N,W}
    ZnW{N,W}(Poly(rand(0:N-1, length(W) - 1)))
end
function rand(rng::AbstractRNG, ::Type{ZnW{N,W}}) where {N,W}
    ZnW{N,W}(Poly(rand(rng, 0:N-1, length(W) - 1)))
end

function rand(type::Type{ZnW{N,W}}, dims::M...) where {N,W,M<:Integer}
    # why there isn't function to create array
    # using function for element
    # result = Array{type,length(dims)}(undef, dims...)
    result = zeros(type, dims...)
    map!(result, result) do _
        rand(type)
    end
    return result
end
function rand(
    rng::AbstractRNG, type::Type{ZnW{N,W}}, dims::M...
) where {N,W,M<:Integer}
    result = zeros(type, dims...)
    map!(result, result) do _
        rand(rng, type)
    end
    return result
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
    @assert zw1 == zw1
    @assert zw1 != zw2
end
