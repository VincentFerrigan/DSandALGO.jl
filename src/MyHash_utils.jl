# MyHash_utils.jl
# Utils for MyHash module in MyHash.jl

## Base overload utils
isempty(node::Union{Node{K,T}, Nothing}) where {K,T} = begin
    isa(node, Nothing) ? true : false end

isequal(a::Node{K,T}, b::Node{K,T}) where {K,T} = a.key == b.key
isequal(a::Node{K,T}, key::K) where {K,T} = a.key == key
isequal(key::K, b::Node{K,T}) where {K,T} = key == b.key

size(node::Union{Nothing, BTNode{K,T}}) where {K,V} = begin
    isa(node, Nothing) ? 0 : node.size end

## Short utils and wrappers
m(b::Buckets) -> b.mod
hashing(key, m) -> hashingByDivision(key, m)

## Base overload methods
function pushfirst!(
    node::Union{Nothing, Node{K,T}}, 
    key::K, 
    entry::T) where {K,T}

    (isempty(node) ? Node(key, entry, nothing, 1)
    : Node(key, entry, node, size(node) + 1))
end

## functions and methods
"""
    hashingByDivision(key::T, m) -> mod1(key, m)
Taking m to be a prime not too close to a power of 2 is recommended
To help avoid pathological cases, the choice of m is important. In particular, m
a power of 2 is usually avoided since, in a binary computer, taking the
remainder modulo a power of 2 means simply discarding some high-order bits.
"""
function hashingByDivision(key::Integer, m) # or where T <: Int
    mod1(key, m)
end

""" 
    add!()

Adds an entry without checking for duplicates
"""
function add!(
    b::Buckets{T},
    key::K,
    entry::T
    ) where {T,K}

    h_value = hasing(key, m(b))
    b.data[h_value] = pushfirst!(b.data[h_value], key, entry)
end