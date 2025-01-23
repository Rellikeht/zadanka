using Polynomials

struct TupPar{T}
    a::Int
end

const t1 = tuple(1:10...)
const t2 = tuple(1:100...)
const t3 = tuple(1:1000...)
const t4 = tuple(1:10000...)

function add(a::TupPar{T}, b::TupPar{T}) where {T}
    a.a + b.a
end

function addT(a::TupPar{T}, b::TupPar{T}) where {T}
    a.a * sum(T) + b.a
end

const p1 = Polynomial(t1)
const p2 = Polynomial(t2)
const p3 = Polynomial(t3)
const p4 = Polynomial(t4)
