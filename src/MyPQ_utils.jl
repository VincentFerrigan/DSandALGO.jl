# MyPQ_utils.jl
# Utils for MyPQ module in MyPQ.jl

# Heap arithmatic
""" hparent(k) = ``k -> ⌊k/2⌋`` """
hparent = k -> >>(k, 1)
""" lchild(k) = ``k -> 2*k``"""
lchild = k -> <<(k, 1)
""" rchild(k) = ``k -> 2*k+1``"""
rchild = k -> +(<<(k, 1), 1)

# base overload utils
length(h::MyVectorPQ) = h.size
isempty(h::MyVectorPQ) = h.size == 0 ? true : false
isless(a::VectorPQNode, b::VectorPQNode) = a.key < b.key 
isequal(a::VectorPQNode, b::VectorPQNode) = a.key == b.key
show(n::VectorPQNode) = print("[", n.key, " => ", n.value, "]")
minimum(h::MinVectorPQ) = first(h)
maximum(h::MaxVectorPQ) = first(h)

# other utils
capacity(h::MyVectorPQ) = length(h.pq) - length(h)

# wrappers
popmin!(h::MinVectorPQ) = pop!(h)
popmax!(h::MaxVectorPQ) = pop!(h)

# base overload methods
"""
    pop! (h::MyVectorPQ{T}, size = length(h)) where {T}

Returns top. (i) switches top with the end of the heap, 
(ii) decrements size of heap, (iii) restore heap condition
"""
function pop!(h::MyVectorPQ{T}, size = length(h)) where {T}
    item = first(h)
    h.pq[1], h.pq[size] = h.pq[size], h.pq[1]
    h.size -= 1
    heapify!(h, 1)
    return item
end

""" 
    push!(h::MyVectorPQ{T}, key::T) where {T}
(i) increments size of heap, (ii) adds new key at the end
(ii) Swim the key up through the heap to restore the heap condition
"""
function push!(h::MyVectorPQ{T}, key::T) where {T}
    capacity(h) > 0 || throw(ArgumentError("No capacity left"))
    keypos = length(h) + 1
    h.size += 1
    h.pq[keypos] = key
    swim!(h, keypos)
end

"""
    will be wrapped by minimum (for minheaps) and maximum for maxheaps
"""
function first(h::MyVectorPQ{T}) where {T}
    isempty(h) && nothing
    return h.pq[1]
end

# Function and methods
""" 
    build_maxpq!(v::Vector, n = length(v))
    
# or should i build it as a constructor???
"""
function build_minmax_pq!(
    h::MaxVectorPQ{T},
    n = length(h)
    ) where {T}

    for k = ÷(n, 2):-1:1
        heapify!(h, k)
    end
    return h
end

""" 
    build_minmax_pq!(v::Vector, n = length(v))
    
# or should i build it as a constructor???
"""
function build_minmax_pq!(
    h::MinVectorPQ{T},
    n = length(h)
    ) where {T}

    for keypos = ÷(n, 2):-1:1
        heapify!(h, keypos)
    end
    return h
end
""" 
    heapify!(h::MaxVectorPQ{T}, keypos, size = length(h))

Recursive Top Down Reheapify (sink). 
Switch ``keypos`` to ``parent``?
"""
function heapify!( # same as sink?
    h::MaxVectorPQ{T}, 
    keypos, 
    size = length(h)
    ) where {T}
    left = lchild(keypos) # 2 * keypos
    right = rchild(keypos) # 2 * keypos + 1

    largest = keypos
    (left <= size   # parent < left child ?
      && (isless(h.pq[largest], h.pq[left]))
      && (largest = left))

    (right <= size  # parent < right child ?
      && (isless(h.pq[largest], h.pq[right]))
      && (largest = right))

    # sink parent if children are larger
    if largest != keypos
        h.pq[keypos], h.pq[largest] = h.pq[largest], h.pq[keypos]
        return heapify!(h, largest)
    end
end

""" 
    heapify!(h::MinVectorPQ{T}, keypos, size = length(h))

Recursive Top Down Reheapify (sink). 
Switch ``keypos`` to ``parent``?
# Är detta något jag kommer använda?? Och hur?
"""
function heapify!( # same as sink?
    h::MinVectorPQ{T}, 
    keypos,
    size = length(h)
    ) where {T}
    left = lchild(keypos) # 2 * k
    right = rchild(keypos) # 2 * k + 1

    smallest = keypos
    (left <= size   # parent > left child ?
      && (isless(h.pq[left], h.pq[smallest]))
      && (smallest = left))
    
    (right <= size  # parent > right child ?
      && (isless(h.pq[right], h.pq[smallest]))
      && (smallest = right))

    # sink parent if children are smaller
    if smallest != keypos
        h.pq[keypos], h.pq[smallest] = h.pq[smallest], h.pq[keypos]
        return heapify!(h, smallest)
    end
end

"""
    heapsort!(v::Vector{T}, n = length(v)) where {T}
# Sorterar i växande ordning
"""
function heapsort!(v::Vector{T}, n = length(v)) where {T}
    heap = MaxVectorPQ(v)
    for keypos = n:-1:2
        v[1], v[keypos]  = v[keypos], v[1]
        heap.size -= 1
        heapify!(heap, 1)
    end
end

"""
    swim!(h::MaxVectorPQ{T}, keypos) where{T}

Bottom up for max heap
"""
function swim!(h::MaxVectorPQ{T}, keypos) where{T}
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= 1 && isless(h.pq[parent], h.pq[keypos])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        return swim!(h, parent)
    end
end

"""
    swim!(h::MinVectorPQ{T}, keypos) where{T}

Bottom up for min heaps
"""
function swim!(h::MinVectorPQ{T}, keypos) where{T}
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= 1 && isless(h.pq[keypos], h.pq[parent])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        return swim!(h, parent)
    end
end
