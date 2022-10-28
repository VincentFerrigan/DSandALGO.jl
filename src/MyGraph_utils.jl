# MyGraph_utils.jl
# Utils for MyGraph module in MyGraph.jl


isequal(a::Edge, b::Edge) = a.weight == b.weight
isless(a::Edge, b::Edge) = a.weight < b.weight

either(e::Edge) = return e.v
other(e::Edge, other) = begin
    if other == e.v return e.w
    elseif other == v.w return e.v
    else # throw exeption
    end
end

weight(e::Edge) = return e.weight

"""
    add!(g::Graph{K}, v::K, w::K, weight)

# TODO: 
* Kräver att hash klarar av nycklar som är strängar. 
  Lägg till en hashingmetod för stränknycklar
# Notes:
* ett annat sätt vore att skriva om MyLL.Push! så att den skapar en lista ifall
  den inte finns
"""
function add!(
    g::Graph{K}, 
    v::K, 
    w::K, 
    weight
    ) where {K}
    e = Edge{K}(v, w, weight)

    elist = MyHash.get(g.adjList, v)
    if isa(elist, Nothing)
        new_elist = ISinglyLinkedList{Edge{K}}()
        MyLL.push!(new_elist, e)
        MyHash.insert!(g.adjList, v, new_elist)
    else
        MyLL.push!(elist, e)
    end
end