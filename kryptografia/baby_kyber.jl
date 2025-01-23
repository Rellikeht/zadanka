include("galois.jl")
__revise_mode__ = :eval

const N = 17
const W = Polynomial([1, 0, 0, 0, 1])

function key_gen(
    A::Matrix{ZnW{N}},
    s::NTuple{2,ZnW{N}},
    e::NTuple{2,ZnW{N}},
)::Tuple{Matrix{ZnW{N}},NTuple{2,ZnW{N}},NTuple{2,ZnW{N}}} where {N}
    Ap::Matrix{ZnW{N}} = deepcopy(A)
    A *= [s[1]; s[2]] 
    # t::Vector{Int} = A * [s[1]; s[2]] + [e[1] e[2]]
    println(Ap)
    t::Vector{Int} = Ap + [e[1] e[2]]
    return (A, t, s)
end

function key_gen_test1()
    A = [
        ZnW{N}([11, 16, 16, 6], W) ZnW{N}([3, 6, 4, 9], W);
        ZnW{N}([1, 10, 3, 5], W) ZnW{N}([15, 9, 1, 6], W)
    ]
    s = (
        ZnW{N}([0, 1, -1, -1], W),
        ZnW{N}([0, -1, 0, -1], W),
    )
    e = (
        ZnW{N}([0, 0, 1], W),
        ZnW{N}([0, -1, 1], W),
    )
    (_, t, _) = key_gen(A, s, e)
    @assert t == (
        ZnW{N}([7, 0, 15, 16], W),
        ZnW{N}([6, 11, 12, 10], W),
    )
end
