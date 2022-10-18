# MyHash_types.jl
# Types for MyHash module in MyHash.jl

mutable struct Node{K,T}
    key::K
    entry::T
    next::Union{Node{K,T}, Nothing}
    size # length of list from current node
end

mutable struct Buckets{K,T}
    data::Vector{Union{Nothing, Node{K,T}}}
    mod

    (Buckets{K,T}(m::Int) where {K,T} = 
      new{K,T}(
          Vector{Union{Nothing, Node{K,T}}}(nothing, m),
          m))
end

# Outer constructs
# Buckets(m) = 