using Primes

function primitiveRootOrig(p::Int, q::Int)
    powers::Set{Int} = Set()
    n::Int = q
    for _ in 1:(p-1)
        n = (n * q) % p
        if n in powers
            return false
        end
        push!(powers, n)
    end
    return true
end

function primitiveRoot(p::Int, q::Int)
    powers::Set{Int} = Set(1:(p-1))
    n::Int = q
    for _ in 1:(p-1)
        n = (n * q) % p
        if !(n in powers)
            return false
        end
        delete!(powers, n)
    end
    return true
end

function primRootBench(f::F, maxq::Int=1000) where {F<:Function}
    primes::Vector{Int} =
        [
            nextprime(10)
            nextprime(100)
            nextprime(1000)
        ]
    for p in primes
        f(p, 5)
        f(p, 500)
    end

    primes = [
        nextprime(2^20)
        # nextprime(2^21)
        # nextprime(2^22)
        # nextprime(2^23)
    ]
    @time for p in primes
        for q in 1:maxq
            f(p, q)
        end
    end
end

primRootBench(primitiveRootOrig, 10)
primRootBench(primitiveRoot, 10)

function reusingPrimeRoot(powers::Set{Int}, p::Int, q::Int)
    n::Int = q
    result::Bool = true
    for _ in 1:(p-1)
        n = (n * q) % p
        if n in powers
            result = false
            break
        end
        push!(powers, n)
    end
    empty!(powers)
    return result
end

function reusingPrimeRootBench(f::F, maxq::Int=1000) where {F<:Function}
    primes::Vector{Int} =
        [
            nextprime(10)
            nextprime(100)
            nextprime(1000)
        ]
    powers::Set{Int} = Set()
    for p in primes
        f(powers, p, 5)
        f(powers, p, 500)
    end
    primes = [
        nextprime(2^20)
        # nextprime(2^21)
        # nextprime(2^22)
        # nextprime(2^23)
    ]
    @time for p in primes
        for q in 1:maxq
            f(powers, p, q)
        end
    end
end

primRootBench(primitiveRootOrig, 100)
reusingPrimeRootBench(reusingPrimeRoot, 100)

primRootBench(primitiveRootOrig, 20)
reusingPrimeRootBench(reusingPrimeRoot, 20)

function prepare(powers::Set{Int}, p::Int)
    if length(powers) > 2 * p / 3
        for i in 0:(p-1)
            push!(powers, i)
        end
    else
        empty!(powers)
    end
end

function reusingPrimitiveRootForward(powers::Set{Int}, p::Int, q::Int)
    n::Int = q
    for _ in 1:(p-1)
        n = (n * q) % p
        if n in powers
            prepare(powers, p)
            return false
        end
        push!(powers, n)
    end
    return true
end

function reusingPrimitiveRootBackward(powers::Set{Int}, p::Int, q::Int)
    n::Int = q
    for _ in 1:(p-1)
        n = (n * q) % p
        if !(n in powers)
            prepare(powers, p)
            return false
        end
        delete!(powers, n)
    end
    return true
end

function multiReusingPrimitiveRoot(powers::Set{Int}, p::Int, q::Int)
    if length(powers) == p
        reusingPrimitiveRootBackward(powers, p, q)
    else
        prepare(powers, p)
        reusingPrimitiveRootForward(powers, p, q)
    end
end

reusingPrimeRootBench(reusingPrimeRoot, 20)
reusingPrimeRootBench(multiReusingPrimitiveRoot, 20)

reusingPrimeRootBench(multiReusingPrimitiveRoot, 100)
GC.gc()
reusingPrimeRootBench(reusingPrimeRoot, 100)

function genPrimitveRootOrig(p::Int)
    q::Int = 2
    while !primitiveRootOrig(p, q)
        q += 1
    end
    return q
end

function genPrimitveRootReuse(p::Int)
    q::Int = 2
    powers::Set{Int} = Set()
    while !reusingPrimeRoot(powers, p, q)
        q += 1
    end
    return q
end

function genPrimitveRootExternal(powers::Set{Int}, p::Int)
    q::Int = 2
    while !reusingPrimeRoot(powers, p, q)
        q += 1
    end
    return q
end

let
    pp::Vector{Int} = [
        nextprime(10),
        nextprime(100),
        nextprime(1000),
    ]
    ps::Vector{Int} = [
        nextprime(1000),
        nextprime(10^6),
        nextprime(2^20),
        nextprime(2^21),
        nextprime(2^22),
        nextprime(2^23),
        nextprime(2^24),
        nextprime(2^25),
    ]
    powers::Set{Int} = Set()

    for p in pp
        genPrimitveRootOrig(p)
        genPrimitveRootReuse(p)
        genPrimitveRootExternal(powers, p)
    end
    GC.gc()
    @time for p in ps
        genPrimitveRootOrig(p)
    end
    GC.gc()
    @time for p in ps
        genPrimitveRootReuse(p)
    end
    GC.gc()
    @time for p in ps
        genPrimitveRootExternal(powers, p)
    end
end

let
    ps::Vector{Int} = [
        nextprime(100),
        nextprime(500),
        nextprime(1000),
        nextprime(10^6),
        nextprime(2^20),
        nextprime(2^21),
        nextprime(2^22),
        nextprime(2^23),
        nextprime(2^24),
    ]
    powers::Set{Int} = Set()
    for p in ps
        @assert genPrimitveRootOrig(p) == genPrimitveRootExternal(powers, p)
    end
end

using BenchmarkTools

# p::Int = nextprime(1000)
# p::Int = nextprime(10^6)
# p::Int = nextprime(2^20)
# p::Int = nextprime(2^21)
# p::Int = nextprime(2^22)
p::Int = nextprime(2^23)
# p::Int = nextprime(2^24)
# p::Int = nextprime(2^25)
powers::Set{Int} = Set()
samples::Int = 100
evals::Int = 2
seconds::Int = 240

GC.gc()
@benchmark genPrimitveRootOrig($p) samples=samples evals=evals seconds=seconds
GC.gc()
@benchmark genPrimitveRootReuse($p) samples=samples evals=evals seconds=seconds
GC.gc()
@benchmark genPrimitveRootExternal($powers, $p) samples=samples evals=evals seconds=seconds
