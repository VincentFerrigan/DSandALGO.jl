# MyHash_types.jl
# Types for MyHash module in MyHash.jl

mutable struct Buckets{T}
    data::Vector{Union{Nothing, T}}
    mod

    (Buckets{T}(m::Int) where {T} = 
        new{T}(
            Vector{Union{Nothing, T}}(nothing, m),
            m))
end

mutable struct Node{K, T}
    key::K
    entry::T
    next::Node{K, T}
    size # length of list from current node
end