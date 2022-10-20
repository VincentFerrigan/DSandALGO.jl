# MyHash_utils.jl
# Utils for MyHash module in MyHash.jl

## Base overload utils
isempty(node::Union{Nothing, Node{K,T}}) where {K,T} = begin
    isa(node, Nothing) ? true : false end
isempty(datum::Union{Nothing, Datum{K,T}}) where {K,T} = begin
    isa(datum, Nothing) ? true : false end

isequal(a::Node{K,T}, b::Node{K,T}) where {K,T} = a.key == b.key
isequal(a::Node{K,T}, key::K) where {K,T} = a.key == key
isequal(key::K, b::Node{K,T}) where {K,T} = key == b.key

isequal(a::Datum{K,T}, b::Datum{K,T}) where {K,T} = a.key == b.key
isequal(a::Datum{K,T}, key::K) where {K,T} = a.key == key
isequal(key::K, b::Datum{K,T}) where {K,T} = key == b.key

size(node::Union{Nothing, Node{K,T}}) where {K,T} = begin
    isa(node, Nothing) ? 0 : node.size end

## Short utils and wrappers
m(b::Buckets) = b.mod
m(lpht::LinearProbHashTable) = lpht.mod

hashing = (key, m) -> hashingByDivision(key, m)

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

## Base overload methods
"""
    get(b::Buckets{K,T}, key::K)::Union{Nothing, T}
Wrapper
"""
get(b::Buckets{K,T}, key::K) where {K, T} = begin
    node = search(b, key)[1]
    return isa(node, Nothing) ? nothing : node.entry
end

get(lpht::LinearProbHashTable{K,T}, key::K) where {K, T} = begin
    datum = search(lpht, key)[1]
    return isa(datum, Nothing) ? nothing : datum.entry
end

function pushfirst!(
    node::Union{Nothing, Node{K,T}}, 
    key::K, 
    entry::T) where {K,T}

    return Node(key, entry, node, (size(node) + 1))
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
end

"""
    insert!(lpht::LinearProbHashTable{K,T}, key::K, entry::T)::Datum{K,T}

Adds an entry. Duplicates are overwritten.
"""
function insert!(
    lpht::LinearProbHashTable{K,T}, 
    key::K,
    entry::T
    ) where {K,T}

    if isa(lpht, DynamicLinearProbHT) && lpht.n > ÷(m(lpht), 2) # load factor α > 1//2
        resize!(lpht, *(m(lpht), 2), typeof(key), typeof(entry))
    # elseif isa(lpht, StaticLinearProbHT) && lpht.n >= (m(lpht) - 1) # load factor close to 1
    elseif isa(lpht, StaticLinearProbHT) && m(lpht) < lpht.n # load factor close to 1
        # has to at lesat leave one slot "empty" (i.e. a nothing)
        throw(ArgumentError(
            "Only one slot left for the static linear probing hashtable"))
    end

    pos = hashing(key, m(lpht))
    while !isa(lpht.data[pos], Nothing)
        if isequal(lpht.data[pos], key)
            lpht.data[pos].entry = entry
        end
        pos = mod1((pos + 1), m(lpht)) # or mod1(pos+1,length(lpht.data))
    end
    lpht.data[pos] = Datum(key, entry)
    lpht.n += 1
end

## functions and methods
function resize!(
    lpht::DynamicLinearProbHT{K,T},
    capacity,
    ktype::DataType,
    ttype::DataType
    ) where {K,T}

    tempHT = DynamicLinearProbHT{ktype,ttype}(capacity)
    for datum ∈ lpht.data
        (!isa(datum, Nothing) 
          && insert!(tempHT, datum.key, datum.entry))
    end

    lpht.data = tempHT.data
    lpht.mod = tempHT.mod
end

"""
    search(b::Buckets{K,T}, key::K)::Union{Nothing, Node{K,T}}

# OpenIssue: 
It returns the node and amount of attempts it had to take to find the item

"""
function search(b::Buckets{K,T}, key::K) where {K,T}
    h_value = hashing(key, m(b))
    node = b.data[h_value]

    attempts = 0 # for Benchmarking
    while !isa(node, Nothing)
        attempts += 1
        if isequal(node, key)
            return node, attempts
        else
            node = node.next
        end
    end
    return node, attempts
end

function search(
    lpht::LinearProbHashTable{K,T}, 
    key::K
    ) where {K, T}

    attempts = 0 # for Benchmarking
    pos = hashing(key, m(lpht))
    while !isa(lpht.data[pos], Nothing)
        attempts += 1
        if isequal(lpht.data[pos], key) 
            return lpht.data[pos], attempts
        else
            pos = mod1((pos + 1), m(lpht)) # or mod1(pos+1,length(lpht.data))
        end
    end
    @assert pos == mod!(hashing(key, m(lpht)) + attempts, length(lpht.data))
    return nothing, attempts
end

## For testing and benchmark data
searchattempts(b::Buckets{K,T}, key::K) where {K, T} = begin
    node, attempts = search(b, key)
    return isa(node, Nothing) ? (nothing, attempts) : (node.entry, attempts)
end

searchattempts(lpht::LinearProbHashTable{K,T}, key::K) where {K, T} = begin
    datum, attempts = search(lpht, key)
    return isa(datum, Nothing) ? (nothing, attempts) : (datum.entry, attempts)
end

"""
    getcollisiondata(b, key)

Returns tuple; hash value and the bucket size (chain size i.e. nbr of collisions)
If size one, no collision
if size two, 1 collision...
if size n, n-1 collisions
"""
function getcollisiondata(b, key)
    hashvalue = hashing(key, m(b))
    chainsize = size(b.data[hashvalue])
    return hashvalue, chainsize
end