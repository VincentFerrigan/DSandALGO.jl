# MyHash_types.jl
# Types for MyHash module in MyHash.jl

abstract type HashTable{K,T} end
abstract type OpenAddressHT{K,T} <: HashTable{K,T} end

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

"""
    ClosedAddressHT{K,T}
Collision resolution by chaining.
Each slot of the vector contains a reference to a singly-linked list containing
key-value pairs with the same hash value
"""
mutable struct ClosedAddressHT{K,T} <: HashTable{K,T}
    data::Vector{Union{Nothing, Node{K,T}}}
    mod # slot-size
    n # amt of entries

    (ClosedAddressHT{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Node{K,T}}}(nothing, m),
          m,
          0))
end

"""
    DynamicOpenAddressHT{K,T}
Collision resolution by linear probing.
"""
mutable struct DynamicOpenAddressHT{K,T} <: OpenAddressHT{K,T}
    data::Vector{Union{Nothing, Datum{K,T}}}
    mod # slot-size
    n # amt of entries

    (DynamicOpenAddressHT{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Datum{K,T}}}(nothing, m),
          m, 
          0))
end

"""
    StaticOpenAddressHT{K,T}
Collision resolution by linear probing.
"""
mutable struct StaticOpenAddressHT{K,T} <: OpenAddressHT{K,T}
    data::Vector{Union{Nothing, Datum{K,T}}}
    mod # slot-size
    n # amt of entries

    (StaticOpenAddressHT{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Datum{K,T}}}(nothing, m),
          m, 
          0))
end

# Outer constructs