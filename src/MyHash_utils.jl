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
m(caht::ClosedAddressHT) = caht.mod
m(oaht::OpenAddressHT) = oaht.mod

function hashing(key::Integer, m) 
    hashingByDivision(key, m)
end

function hashing(key::String, m)
    mod1(hash(key), m)
end

"""
    hashingByDivision(key::T, m) -> mod1(key, m)
Taking m to be a prime not too close to a power of 2 is recommended
To help avoid pathological cases, the choice of m is important. In particular, m
a power of 2 is usually avoided since, in a binary computer, taking the
remainder modulo a power of 2 means simply discarding some high-order bits.
"""
hashingByDivision = (k::Integer, m) -> mod1(k, m)

## Base overload methods
"""
    get(caht::ClosedAddressHT{K,T}, key::K)::Union{Nothing, T}
Wrapper
"""
get(caht::ClosedAddressHT{K,T}, key::K) where {K, T} = begin
    node = search(caht, key)[1]
    return isa(node, Nothing) ? nothing : node.entry
end

get(oaht::OpenAddressHT{K,T}, key::K) where {K, T} = begin
    datum = search(oaht, key)[1]
    return isa(datum, Nothing) ? nothing : datum.entry
end

function pushfirst!(
    node::Union{Nothing, Node{K,T}}, 
    key::K, 
    entry::T) where {K,T}

    return Node(key, entry, node, (size(node) + 1))
end

""" 
    insert!(caht::ClosedAddressHT{K,T}, key::K, entry::T)::Node{K,T}

Adds an entry without checking for duplicates
"""
function insert!(
    caht::ClosedAddressHT{K,T},
    key::K,
    entry::T
    ) where {K,T}

    h_value = hashing(key, m(caht))
    caht.data[h_value] = pushfirst!(caht.data[h_value], key, entry)
    caht.n += 1
end

"""
    insert!(oaht::StaticOpenAddressHT{K,T}, key::K, entry::T)::Datum{K,T}

    α
Adds an entry. Duplicates are overwritten.
"""
function insert!(
    oaht::StaticOpenAddressHT{K,T}, 
    key::K,
    entry::T
    ) where {K,T}

    # load factor close to 1 - has to at least leave one slot "empty" (i.e. a nothing)
    (m(oaht) < oaht.n && throw(ArgumentError(
        "Only one slot left for the static linear probing hashtable")))

    pos = hashing(key, m(oaht))
    while !isa(oaht.data[pos], Nothing)
        if isequal(oaht.data[pos], key)
            oaht.data[pos].entry = entry
        end
        pos = mod1((pos + 1), m(oaht)) # or mod1(pos+1,length(oaht.data))
    end
    oaht.data[pos] = Datum(key, entry)
    oaht.n += 1
end

"""
    insert!(oaht::DynamicOpenAddressHT{K,T}, key::K, entry::T)::Datum{K,T}

Adds an entry. Duplicates are overwritten.
"""
function insert!(
    oaht::DynamicOpenAddressHT{K,T}, 
    key::K,
    entry::T
    ) where {K,T}

    if oaht.n > ÷(m(oaht), 2) # load factor α > 1//2
        resize!(oaht, *(m(oaht), 2), typeof(key), typeof(entry))
    end

    pos = hashing(key, m(oaht))
    while !isa(oaht.data[pos], Nothing)
        if isequal(oaht.data[pos], key)
            oaht.data[pos].entry = entry
        end
        pos = mod1((pos + 1), m(oaht)) # or mod1(pos+1,length(oaht.data))
    end
    oaht.data[pos] = Datum(key, entry)
    oaht.n += 1
end

## functions and methods
function resize!(
    oaht::DynamicOpenAddressHT{K,T},
    capacity,
    ktype::DataType,
    ttype::DataType
    ) where {K,T}

    tempHT = DynamicOpenAddressHT{ktype,ttype}(capacity)
    for datum ∈ oaht.data
        (!isa(datum, Nothing) 
          && insert!(tempHT, datum.key, datum.entry))
    end

    oaht.data = tempHT.data
    oaht.mod = tempHT.mod
end

"""
    search(caht::ClosedAddressHT{K,T}, key::K)::Union{Nothing, Node{K,T}}

# OpenIssue: 
It returns the node and amount of attempts it had to take to find the item

"""
function search(caht::ClosedAddressHT{K,T}, key::K) where {K,T}
    h_value = hashing(key, m(caht))
    node = caht.data[h_value]

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
    oaht::OpenAddressHT{K,T}, 
    key::K
    ) where {K, T}

    attempts = 0 # for Benchmarking
    pos = hashing(key, m(oaht))
    while !isa(oaht.data[pos], Nothing)
        attempts += 1
        if isequal(oaht.data[pos], key) 
            return oaht.data[pos], attempts
        else
            pos = mod1((pos + 1), m(oaht)) # or mod1(pos+1,length(oaht.data))
        end
    end
    @assert pos == mod1(hashing(key, m(oaht)) + attempts, length(oaht.data))
    return nothing, attempts
end

## For testing and benchmark data
searchattempts(caht::ClosedAddressHT{K,T}, key::K) where {K, T} = begin
    node, attempts = search(caht, key)
    return isa(node, Nothing) ? (nothing, attempts) : (node.entry, attempts)
end

searchattempts(oaht::OpenAddressHT{K,T}, key::K) where {K, T} = begin
    datum, attempts = search(oaht, key)
    return isa(datum, Nothing) ? (nothing, attempts) : (datum.entry, attempts)
end

"""
    getcollisiondata(caht, key)

Returns tuple; hash value and the length of the linked list (chain size i.e. nbr of collisions + 1)
If size one, no collision
if size two, 1 collision...
if size n, n-1 collisions
"""
function getcollisiondata(caht::ClosedAddressHT, key)
    hashvalue = hashing(key, m(caht))
    chainsize = size(caht.data[hashvalue])
    return hashvalue, chainsize
end