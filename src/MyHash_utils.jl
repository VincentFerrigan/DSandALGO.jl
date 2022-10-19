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

    if isa(node, Nothing)
        return Node(key, entry, nothing, 1)
    else
        return Node(key, entry, node, (node.size + 1))
    end
    # (return isa(node, Nothing)
    # ? node(key, entry, nothing, 1) 
    # : Node(key, entry, node, size(node) + 1))
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

# Create a insert! for StaticLinearProbHT <: LinearProbHashTable
"""
    insert!(lpht::StaticLinearProbHT{K,T}, key::K, entry::T)::Datum{K,T}

Adds an entry. Duplicates are overwritten.
ISSUE: Vad händer ifall den kommer till sista index? Börjar den då om?
"""
function insert!(
    lpht::StaticLinearProbHT{K,T}, 
    key::K,
    entry::T
    ) where {K,T}

    # has to always leave one slot "empty" (i.e. nothing)
    lpht.n == (m(lpht) - 1) && throw(ArgumentError("Full hashtable"))

    i = hashing(key, m(lpht))
    while !isa(lpht.data[i], Nothing)
        if isequal(lpht.data[i], key)
            lpht.data[i].entry = entry
        end
        # (isequal(lpht.data[i], key)
        #   && (lpht.data[i].entry = entry))
        i += 1
    end
    lpht.data[i] = Datum(key, entry)
    lpht.n += 1
end

"""
    insert!(lpht::DynamicLinearProbHT{K,T}, key::K, entry::T)::Datum{K,T}

Adds an entry. Duplicates are overwritten.
"""
function insert!(
    lpht::DynamicLinearProbHT{K,T}, 
    key::K,
    entry::T
    ) where {K,T}

    if lpht.n > ÷(m(lpht), 2) # load factor α
        resize!(lpht, *(m(lpht), 2), typeof(key), typeof(entry))
    end

    i = hashing(key, m(lpht))
    while !isa(lpht.data[i], Nothing)
        if isequal(lpht.data[i], key)
            lpht.data[i].entry = entry
        end
        # (isequal(lpht.data[i], key)
        #   && (lpht.data[i].entry = entry))
        i += 1
    end
    lpht.data[i] = Datum(key, entry)
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

    attempts = 0
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

    attempts = 0
    i = hashing(key, m(lpht))
    while !isa(lpht.data[i], Nothing)
        attempts += 1
        if isequal(lpht.data[i], key) 
            return lpht.data[i], attempts
        else
            i += 1
        end
    end
    @assert i == hashing(key, m(lpht)) + attempts

    return nothing, attempts
end

## For testing and data
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
"""
function getcollisiondata(b, key)
    hashvalue = hashing(key, m(b))
    chainsize = size(b.data[hashvalue])
    return hashvalue, chainsize
end