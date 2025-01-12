const AbstractVecOrSet{T} = Union{AbstractVector{T},AbstractSet{T}}
const Connections = Dict{Int,Set{Int}}

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
                    name => begin
                        result = Set()
                        sizehint!(result, div(length(non_commuting), 2))
                        result
                    end for name in names
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

struct Graph
    labels::Dict{Int,String}
    connections::Dict{Int,Set{Int}}
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
        key => begin
            vec::Vector{AbstractMarker} = []
            sizehint!(vec, length(word))
            vec
        end for key in monoid.names
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

function foata(
    monoid::Monoid,
    diekert_graph::Graph
)::Vector{Vector{String}}
    connections::Connections = deepcopy(diekert_graph.connections)
    parts::Vector{Vector{String}} = []
    while length(connections) > 0
        push!(parts, map(entrances!(connections)) do e
            diekert_graph.labels[e]
        end)
    end
    return parts
end

function entrances!(
    connections::Connections
)::Vector{Int}
    result::Vector{Int} = []
    nonfree::Set{Int} = Set()
    for k in sort(collect(keys(connections)))
        union!(nonfree, connections[k])
        if k in nonfree
            continue
        end
        push!(result, k)
    end
    for k in result
        delete!(connections, k)
    end
    return result
end

function foata_part_string(part::AbstractVector{S}) where {S<:AbstractString}
    "(" * join(part, " ") * ")"
end

function foata_string(
    monoid::Monoid,
    word::Union{AbstractVector{S},Graph}
)::String where {S<:AbstractString}
    fvect::Vector{Vector{String}} = foata(monoid, word)
    return join(map(foata_part_string, fvect), "")
end

# https://cs.stackexchange.com/a/29133
function reduce!(graph::Graph)
    for (id, neighbours) in graph.connections
        for neighbour in neighbours
            reduce!(graph, id, neighbour)
        end
    end
end

function reduce!(graph::Graph, id::Int, start::Int)
    for neighbour in graph.connections[start]
        delete!(graph.connections[id], neighbour)
        reduce!(graph, id, neighbour)
    end
end

function gen_sigma(
    A::AbstractVecOrSet{S}
)::Dict{String,Set{String}} where {S<:AbstractString}
    result::Dict{String,Set{String}} = Dict()
    sizehint!(result, length(A))
    for e in A
        push!(result, e => Set())
        sizehint!(result[e], length(A))
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
    IorD::AbstractVector{NTuple{2,S2}}
)::Dict{String,Set{String}} where {S1<:AbstractString,S2<:AbstractString}
    result::Dict{String,Set{String}} = gen_sigma(A)
    for (f, s) in IorD
        delete!(result[f], s)
    end
    return result
end

function invert_commutation(
    A::AbstractVecOrSet{S1},
    IorD::AbstractSet{NTuple{2,S2}}
)::Dict{String,Set{String}} where {S1<:AbstractString,S2<:AbstractString}
    result::Dict{String,Set{String}} = Dict()
    sizehint!(result, length(A))
    for e1 in A
        push!(result, e1 => Set())
        sizehint!(result[e1], length(A))
        for e2 in A
            if !((e1, e2) in IorD)
                push!(result[e1], e2)
            end
        end
    end
    return result
end

function invert_commutation(
    A::AbstractVecOrSet{S1},
    IorD::AbstractDict{S2,<:AbstractSet{S3}}
)::Dict{String,Set{String}} where {
    S1<:AbstractString,S2<:AbstractString,S3<:AbstractString
}
    result::Dict{String,Set{String}} = Dict()
    sizehint!(result, length(A)^2 - length(IorD) + 1)
    for e1 in A
        push!(result, e1 => Set())
        sizehint!(result[e1], length(A))
        for e2 in A
            if !(e2 in IorD[e1])
                push!(result[e1], e2)
            end
        end
    end
    return result
end

function invert_commutation(monoid::Monoid)::Dict{String,Set{String}}
    invert_commutation(monoid.names, monoid.non_commuting)
end

function almost_diekert(
    monoid::Monoid,
    word::AbstractVector{S}
)::Graph where {S<:AbstractString}
    result::Graph = Graph(Dict(), Dict())
    sizehint!(result.labels, length(word))
    sizehint!(result.connections, length(word))
    D::Dict{String,Set{String}} = invert_commutation(monoid)
    id::Int = 0
    for part in word
        push!(result.labels, id => part)
        push!(result.connections, id => Set())
        sizehint!(result.connections[id], length(word) - id)
        id += 1
    end
    for i in 0:id-1
        for j in i+1:id-1
            if result.labels[j] in D[result.labels[i]]
                push!(result.connections[i], j)
            end
        end
    end
    return result
end

function diekert(
    monoid::Monoid,
    word::AbstractVector{S}
)::Graph where {S<:AbstractString}
    result::Graph = almost_diekert(monoid, word)
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

function generate_pngs(names::Vector{String})
    for name in names
        open(replace(name, r"\.[^.]*$" => ".png"), "w") do file
            run(pipeline(`dot -Tpng $name`, stdout=file))
        end
    end
end

function printSnow(
    io::IO,
    snow::Dict{S,<:AbstractVector{M}}
) where {S<:AbstractString,M<:AbstractMarker}
    names::Vector{String} = snow |> keys |> collect
    for name in sort(names)
        print(io, "$name | ")
        layer::String =
            map(snow[name]) do m
                if m isa Marker
                    return "*"
                else
                    return name
                end
            end |> join
        print(io, "$layer")
        println(io)
        # println(io, "let it snow")
    end
end

function printSnow(
    snow::Dict{S,<:AbstractVector{M}}
) where {S<:AbstractString,M<:AbstractMarker}
    printSnow(stdout, snow)
end

function foata_printing(
    io::IO,
    monoid::Monoid,
    word::AbstractVector{S}
)::String where {S<:AbstractString}
    result::String = ""
    snow::Dict{String,Vector{AbstractMarker}} = Dict([
        key => begin
            vec::Vector{AbstractMarker} = []
            sizehint!(vec, length(word))
            vec
        end for key in monoid.names
    ])
    println(io, "Snowing:")

    for l1 in Iterators.reverse(word)
        printSnow(io, snow)
        println(io)
        push!(snow[l1], Letter())
        for (l2, layer) in snow
            if l2 == l1 || l2 in monoid.non_commuting[l1]
                continue
            end
            push!(layer, Marker())
        end
    end

    printSnow(io, snow)
    println(io)
    println(io, "Removing:")
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
        for l1 in part
            for (l2, layer) in snow
                if l2 == l1 || l2 in monoid.non_commuting[l1]
                    continue
                end
                pop!(layer)
            end
        end
        part_str::String = foata_part_string(part)
        result *= part_str
        println(io)
        printSnow(io, snow)
        println(io, part_str)
    end

    println(io)
    return result
end

function foata_printing(
    monoid::Monoid,
    word::AbstractVector{S}
)::String where {S<:AbstractString}
    foata_printing(stdout, monoid, word)
end

function pretty_commutation(D::Dict{String,Set{String}})::String
    result::String = "D = {"
    for k in D |> keys |> collect |> sort
        for v in D[k] |> collect |> sort
            result *= "($k, $v), "
        end
    end
    result = result[begin:end-2]
    return result * "}"
end

function generate_png(names::Vector{S}) where {S<:AbstractString}
    foreach(generate_png, names)
end

function generate_png(name::AbstractString)
    open(replace(name, r"\.[^.]*$" => ".png"), "w") do file
        run(pipeline(`dot -Tpng $name`, stdout=file))
    end
end

let
    A = ["a", "b", "c", "d"]
    I = [("a", "d"), ("d", "a"), ("b", "c"), ("c", "b")]
    w = split("baadcb", "")
    monoid = Monoid(A, I)
    D = invert_commutation(A, I)
    println(pretty_commutation(D))
    println()
    println(foata_string(monoid, w))
    println()
    dgraph = diekert(monoid, w)
    println(foata_string(monoid, dgraph))
    fname = "ex1.dot"
    open(fname, "w") do f
        write(f, to_dot(dgraph))
    end
    generate_png(fname)
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
    D = invert_commutation(A, I)
    println(pretty_commutation(D))
    println()
    println(foata_string(monoid, w))
    println()
    dgraph = diekert(monoid, w)
    println(foata_string(monoid, dgraph))
    fname = "ex2.dot"
    open(fname, "w") do f
        write(f, to_dot(dgraph))
    end
    generate_png(fname)
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
    open("snowing", "w") do file
        result = foata_printing(file, monoid, w)
        println(file, "Result:")
        println(file, result)
    end
    diekert = almost_diekert(monoid, w)
    open("ex2_unoptimized.dot", "w") do f
        write(f, to_dot(diekert))
    end
    reduce!(diekert)
    open("ex2.dot", "w") do f
        write(f, to_dot(diekert))
    end
end
