# MyGraph_types.jl
# Types for MyGraph module in MyGraph.jl

struct Edge{K}
    v::K # or should this be ref to the datum nodes instead of string?
    w::K
    weight

    (Edge{K}(v::K, w::K, weight) where {K} = 
    new{K}(
        v, w, weight # or should i "get" refs to the actual datum-node?
        ))
end

mutable struct Graph{K}
# mutable struct Graph{K,T}
    # v # number of vertices
    # e # number of edges
    adjList::DynamicOpenAddressHT{K, MyLL.ISinglyLinkedList{Edge{K}}}
    # adjList::DynamicOpenAddressHT{K, ISinglyLinkedList{T}}

    (Graph{K}(m) where {K} = 
    new{K}(
        DynamicOpenAddressHT{K, MyLL.ISinglyLinkedList{Edge{K}}}(m)
        ))
    # (Graph{K,T}(m) where {K,T} = 
    # new{K}(
    #     DynamicOpenAddressHT{K, ISinglyLinkedList{T}}(m)
    #     ))
end