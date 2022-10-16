# MyPQ_types.jl
# Types for MyPQ module in MyPQ.jl

# Heap
abstract type MyAbstractHeap{T} end
abstract type MyVectorPQ{T} <: MyAbstractHeap{T} end
abstract type MyListPQ{T} <: MyAbstractHeap{T} end


mutable struct MaxVectorPQ{T} <: MyVectorPQ{T}
    pq
    size

    (MaxVectorPQ{T}(n::Integer) where {T} =
      new{T}(Vector{Union{Nothing, T}}(nothing, n), 0))

    function MaxVectorPQ{T}(v::Vector{T}) where {T}
        h = new(v, length(v))
        build_minmax_pq!(h)
    end
end

mutable struct MinVectorPQ{T} <: MyVectorPQ{T}
    pq
    size

    (MinVectorPQ{T}(n::Integer) where {T} =
      new{T}(Vector{Union{Nothing, T}}(nothing, n), 0))

    function MinVectorPQ{T}(v::Vector{T}) where {T}
        h = new(v, length(v))
        build_minmax_pq!(h)
    end
end

mutable struct MaxDynamicPQ{T} <: MyVectorPQ{T}
    pq::Vector{Union{Nothing, T}} # or items?
    first
    last
    size # n?

    (MaxDynamicPQ{T}(capacity = 4) where {T} =
      new{T}(
        Vector{Union{Nothing, T}}(nothing, capacity), 
        1, 
        1, 
        0))
end

# outerconstruct
MaxVectorPQ(v::Vector{T}) where {T} = MaxVectorPQ{T}(v)
MinVectorPQ(v::Vector{T}) where {T} = MinVectorPQ{T}(v)

# Nodes
## Use BTNode for lists
mutable struct VectorPQNode{K,V}
    key::K
    value::V
end