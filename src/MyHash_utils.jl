# MyHash_utils.jl
# Utils for MyHash module in MyHash.jl

## Base overload utils
isempty(node::Union{Nothing, Node{K,T}}) where {K,T} = begin
    isa(node, Nothing) ? true : false end

isequal(a::Node{K,T}, b::Node{K,T}) where {K,T} = a.key == b.key
isequal(a::Node{K,T}, key::K) where {K,T} = a.key == key
isequal(key::K, b::Node{K,T}) where {K,T} = key == b.key

size(node::Union{Nothing, Node{K,T}}) where {K,T} = begin
    isa(node, Nothing) ? 0 : node.size end

## Short utils and wrappers
m = (b::Buckets) -> b.mod
hashing = (key, m) -> hashingByDivision(key, m)
getchainsize = (b, key) -> size(b.data[hashing(key, m(b))])

## Base overload method (wrapper)
"""
    get(b::Buckets{K,T}, key::K)::Union{Nothing, T}
Wrapper
"""
get(b::Buckets{K,T}, key::K) where {K, T} = begin
    node = search(b, key)
    return isa(node, Nothing) ? nothing : return node.entry
end

## Base overload methods
function pushfirst!(
    node::Union{Nothing, Node{K,T}}, 
    key::K, 
    entry::T) where {K,T}

    if isa(node, Nothing)
        return Node(key, entry, nothing, 1)
    else
        return Node(key, entry, node, (node.size + 1))
    end
    # (return isa(node, Nothing)
    # ? node(key, entry, nothing, 1) 
    # : Node(key, entry, node, size(node) + 1))
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
    insert!(b::Buckets{K,T}, key::K, entry::T)::Node{K,T}

Adds an entry without checking for duplicates
"""
function insert!(
    b::Buckets{K,T},
    key::K,
    entry::T
    ) where {K,T}

    h_value = hashing(key, m(b))
    b.data[h_value] = pushfirst!(b.data[h_value], key, entry)
    # (b.data[h_value] = 
    #   pushfirst!(b.data[hashing(key, m(b))], key, entry))
end

"""
    search(b::Buckets{K,T}, key::K)::Union{Nothing, Node{K,T}}

# OpenIssue: 
* Should it return entry or node?? If you return a node you could use wrappers.
One that returns the size of the chained nodes and one get
"""
function search(b::Buckets{K,T}, key::K) where {K,T}
    h_value = hashing(key, m(b))
    node = b.data[h_value]

    while !isa(node, Nothing)
        if isequal(node, key)
            return node
        else
            node = node.next
        end
    end
    return node
end