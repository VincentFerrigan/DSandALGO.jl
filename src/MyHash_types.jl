# MyHash_types.jl
# Types for MyHash module in MyHash.jl

abstract type HashTable{K,T} end

mutable struct Node{K,T}
    key::K
    entry::T
    next::Union{Node{K,T}, Nothing}
    size # length of list from current node
end

struct Datum{K,T}
    key::K
    entry::T
end

mutable struct Buckets{K,T} <: HashTable{K,T}
    data::Vector{Union{Nothing, Node{K,T}}}
    mod

    (Buckets{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Node{K,T}}}(nothing, m),
          m))
end

mutable struct LinearProbHashTable{K,T} <: HashTable{K,T}
    data::Vector{Union{Nothing, Datum{K,T}}}
    mod
    n # amt of entries

    (LinearProbHashTable{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Datum{K,T}}}(nothing, m),
          m, 
          0))
end

# Outer constructs