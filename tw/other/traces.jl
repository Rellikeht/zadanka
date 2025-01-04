const AbstractVecOrSet{T} = Union{AbstractVector{T},AbstractSet{T}}

struct Monoid
    names::Set{String}
    non_commuting::Dict{String,Set{String}}
    Monoid(
        names::AbstractVecOrSet{S1},
        non_commuting::AbstractVector{<:Union{NTuple{2,S2},Pair{S2,S2}}}
    ) where {S1<:AbstractString,S2<:AbstractString} =
        begin
            result = new(
                Set(names),
                Dict([
                    name => Set() for name in names
                ])
            )
            for (f, s) in non_commuting
                push!(result.non_commuting[f], s)
            end
            result
        end
    Monoid(
        names::AbstractVecOrSet{S1},
        non_commuting::Dict{String,Set{String}},
    ) where {S1<:AbstractString} =
        new(
            Set(names),
            non_commuting
        )
end

abstract type AbstractMarker end
struct Marker <: AbstractMarker end
struct Letter <: AbstractMarker end

function foata(
    monoid::Monoid,
    word::AbstractVector{S}
)::Vector{Vector{String}} where {S<:AbstractString}
    result::Vector{Vector{String}} = []
    snow::Dict{String,Vector{AbstractMarker}} = Dict([
        key => [] for key in monoid.names
    ])
    for l1 in Iterators.reverse(word)
        push!(snow[l1], Letter())
        for (l2, layer) in snow
            if l2 == l1 || l2 in monoid.non_commuting[l1]
                continue
            end
            push!(layer, Marker())
        end
    end
    left::Int = length(word)
    while left > 0
        part::Vector{String} = []
        for (letter, layer) in snow
            if length(layer) > 0 && layer[end] isa Letter
                left -= 1
                push!(part, letter)
                pop!(layer)
            end
        end
        push!(result, part)
        for l1 in part
            for (l2, layer) in snow
                if l2 == l1 || l2 in monoid.non_commuting[l1]
                    continue
                end
                pop!(layer)
            end
        end
    end
    return result
end

function foata_string(
    monoid::Monoid,
    word::AbstractVector{S}
)::String where {S<:AbstractString}
    fvect::Vector{Vector{String}} = foata(monoid, word)
    return join(
        map(fvect) do v
            "(" * join(v, " ") * ")"
        end,
        ""
    )
end

struct Graph
    labels::Dict{Int,String}
    connections::Dict{Int,Set{Int}}
end

function reduce!(graph::Graph, id::Int, start::Int)
    for neighbour in graph.connections[start]
        delete!(graph.connections[id], neighbour)
        reduce!(graph, id, neighbour)
    end
end

function reduce!(graph::Graph)
    for (id, neighbours) in graph.connections
        for neighbour in neighbours
            reduce!(graph, id, neighbour)
        end
    end
end

function gen_sigma(
    A::AbstractVecOrSet{S}
)::Dict{String,Set{String}} where {S<:AbstractString}
    result::Dict{String,Set{String}} = Dict()
    for e in A
        push!(result, e => Set())
    end
    for e1 in A
        for e2 in A
            push!(result[e1], e2)
            push!(result[e2], e1)
        end
    end
    return result
end

function invert_commutation(
    A::AbstractVecOrSet{S1},
    IorD::AbstractVecOrSet{NTuple{2,S2}}
)::Dict{String,Set{String}} where {S1<:AbstractString,S2<:AbstractString}
    result::Dict{String,Set{String}} = gen_sigma(A)
    for (f, s) in IorD
        delete!(result[f], s)
    end
    return result
end

function invert_commutation(
    A::AbstractVecOrSet{S1},
    IorD::AbstractDict{S2,<:AbstractSet{S3}}
)::Dict{String,Set{String}} where {
    S1<:AbstractString,S2<:AbstractString,S3<:AbstractString
}
    result::Dict{String,Set{String}} = gen_sigma(A)
    for (f, s) in IorD
        setdiff!(result[f], s)
    end
    return result
end


function invert_commutation(monoid::Monoid)::Dict{String,Set{String}}
    invert_commutation(monoid.names, monoid.non_commuting)
end

function diekert(
    monoid::Monoid,
    word::AbstractVector{S}
)::Graph where {S<:AbstractString}
    result::Graph = Graph(Dict(), Dict())
    D::Dict{String,Set{String}} = invert_commutation(monoid)
    id::Int = 0
    for part in word
        push!(result.labels, id => part)
        push!(result.connections, id => Set())
        id += 1
    end
    for i in 0:id-1
        for j in i+1:id-1
            if result.labels[j] in D[result.labels[i]]
                push!(result.connections[i], j)
            end
        end
    end
    reduce!(result)
    return result
end

function to_dot(graph::Graph)::String
    result::String = "digraph g {\n"
    for (from, tos) in graph.connections
        for to in tos
            result *= "$from -> $to\n"
        end
    end
    result *= "\n"
    for (id, name) in graph.labels
        result *= "$id[label=$name]\n"
    end
    return result * "}\n"
end

let
    A = ["a", "b", "c", "d"]
    I = [("a", "d"), ("d", "a"), ("b", "c"), ("c", "b")]
    w = split("baadcb", "")
    monoid = Monoid(A, I)
    println(foata_string(monoid, w))
    open("ex1.dot", "w") do f
        write(f, to_dot(diekert(monoid, w)))
    end
end

let
    A = ["a", "b", "c", "d", "e", "f"]
    I = [
        ("a", "d"),
        ("d", "a"),
        ("b", "e"),
        ("e", "b"),
        ("c", "d"),
        ("d", "c"),
        ("c", "f"),
        ("f", "c"),
    ]
    w = split("acdcfbbe", "")
    monoid = Monoid(A, I)
    println(foata_string(monoid, w))
    open("ex2.dot", "w") do f
        write(f, to_dot(diekert(monoid, w)))
    end
end

let
    A = ["pić", "jeść", "spać"]
    I = [
        ("pić", "jeść")
    ]
    w = ["pić", "jeść", "spać", "pić", "jeść", "spać"]
    monoid = Monoid(A, I)
    println(foata_string(monoid, w))
end

function generate_pngs(names::Vector{String})
    for name in names
        open(replace(name, r"\.[^.]*$" => ".png"), "w") do file
            run(pipeline(`dot -Tpng $name`, stdout=file))
        end
    end
end
