# MyPQ_types.jl
# Types for MyPQ module in MyPQ.jl

# Heap
abstract type MyAbstractHeap{T} end
abstract type MyVectorPQ{T} <: MyAbstractHeap{T} end
abstract type MyDynamicPQ{T} <: MyVectorPQ{T} end
abstract type MyTreePQ{K,V} end


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

mutable struct MaxDynamicPQ{T} <: MyDynamicPQ{T}
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

mutable struct MinDynamicPQ{T} <: MyDynamicPQ{T}
    pq::Vector{Union{Nothing, T}} # or items?
    first
    last
    size # n?

    (MinDynamicPQ{T}(capacity = 4) where {T} =
      new{T}(
        Vector{Union{Nothing, T}}(nothing, capacity), 
        1, 
        1, 
        0))
end

# Nodes
## Use BTNode for lists
abstract type MyNode{K,V} end

mutable struct VectorPQNode{K,V} <: MyNode{K,V}
    key::K
    value::V
end

mutable struct BTNode{K,V} <: MyNode{K,V}
    key::K
    value::V
    left::Union{BTNode{K, V}, Nothing}
    right::Union{BTNode{K, V}, Nothing}
    size
end

mutable struct TreePQ{K,V} <: MyTreePQ{K,V}
    root::Union{Nothing, BTNode{K,V}}
    TreePQ{K,V}() where {K,V} = new{K,V}(nothing)
    # hieght or length?
end

# outerconstruct
MaxVectorPQ(v::Vector{T}) where {T} = MaxVectorPQ{T}(v)
MinVectorPQ(v::Vector{T}) where {T} = MinVectorPQ{T}(v)