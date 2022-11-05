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
isempty(tree::TreePQ) = isempty(tree.root)
isempty(node::Union{BTNode{K, V}, Nothing}) where {K,V} = begin
    isa(node, Nothing) ? true : false end
isempty(h::MyVectorPQ) = h.size == 0 ? true : false

length(h::MyVectorPQ) = h.size
size(tree::TreePQ) = size(tree.root)
size(node::Union{Nothing, BTNode{K, V}}) where {K,V} = begin 
    isa(node, Nothing) ? 0 : node.size end

isless(a::VectorPQNode, b::VectorPQNode) = a.key < b.key 
isless(a::BTNode, b::BTNode) = a.key < b.key 

isequal(a::VectorPQNode, b::VectorPQNode) = a.key == b.key
isequal(a::BTNode, b::BTNode) = a.key == b.key

show(io::IO, n::VectorPQNode) = print("[", n.key, " => ", n.value, "]")
function show(io::IO, node::BTNode{K,V}) where {K,V}
    print("[", node.key, " => ", node.value, " (", node.size, ")", "]")
end

minimum(h::MinVectorPQ) = first(h)
minimum(h::TreePQ) = first(h)
minimum(h::MinDynamicPQ) = first(h)

maximum(h::MaxVectorPQ) = first(h)
maximum(h::MaxDynamicPQ) = first(h)

# other utils
capacity(h::MyVectorPQ) = length(h.pq)
capacityleft(h::MyVectorPQ) = capacity(h) - length(h)

# wrappers
popmin!(h::MinVectorPQ) = pop!(h)
popmin!(h::MinDynamicPQ) = pop!(h)
popmax!(h::MaxVectorPQ) = pop!(h)
popmax!(h::MaxDynamicPQ) = pop!(h)

function iterate(tree::TreePQ{K,V}) where {K, V} #BFS
    isempty(tree) && return nothing
    node = tree.root
    queue = DynamicQueue{Union{BTNode{K, V}, Nothing}}()
    !isa(node.left, Nothing) && enqueue!(queue, node.left)
    !isa(node.right, Nothing) && enqueue!(queue, node.right)
    return node, queue
end

function iterate(_::TreePQ{K, V}, queue) where {K,V} # BFS
    node = dequeue!(queue)
    isa(node, Nothing) && return nothing
    !isa(node.left, Nothing) && enqueue!(queue, node.left)
    !isa(node.right, Nothing) && enqueue!(queue, node.right)
    return node, queue 
end

# base overload methods
""" 
    push!(h::MyVectorPQ{T}, key::T) where {T}
(i) increments size of heap, (ii) adds new key at the end
(ii) Swim the key up through the heap to restore the heap condition
"""
function push!(h::MyVectorPQ{T}, key::T) where {T}
    capacityleft(h) > 0 || throw(ArgumentError("No capacity left"))
    keypos = length(h) + 1
    h.size += 1
    h.pq[keypos] = key
    # swim!(h, keypos)
    swim!(h, keypos, 1) # FOR BENCH
end

function push!(h::MyDynamicPQ, key::T) where {T}
    (length(h)  == capacity(h) #  or capacityleft(h) > 0 || resize!(h, *....)
      && resize!(h, *(capacity(h), 2)))

    keypos = h.last
    h.pq[keypos] = key
    if h.last == capacity(h) # behövs detta? Ska ju ändock inte köra kö grejen. Eller?
        h.last = 1
    else
        h.last += 1
    end
    h.size += 1
    # swim!(h, keypos)
    swim!(h, keypos, 1) # FOR BENCH
end

""" 
    push!(tree::TreePQ{K,V}, incr::Int)::Int

    Decreases the roots prio by incrementing its key. 
    Cheaper than removing and then adding back the root. 
    * The method increments key of the root element and
    * then swaps the value from either the left or right branch depending on key value
      (see remove??)
    * Lastly it should return the depth the operation needs to go down 
      (what does this exactly mean?) HOW?

    # depth::Int = 0 # Som parameter. Avvakta tills du gjort klart grunden. 
    Sen ser du om det vore bättre att använda size för att erhålla depth. Eller?
"""
function push!(
    tree::TreePQ{K,V},
    incr::Int
    ) where {K,V}

    isa(tree.root, Nothing) && throw(ArgumentError("Empty tree"))
    key = tree.root + incr
    value = tree.value
    # add!(remove!(tree), key, value)
    add!(remove!(tree), key, value, 1) # FOR BENCH
end

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

function pop!(h::MyDynamicPQ{T}, size = length(h)) where {T}
    (length(h) > 0 
      && length(h) == ÷(capacity(h), 4)
      && resize!(h, ÷(h, 2)))

    item = first(h)
    h.pq[h.first], h.pq[h.last-1] = h.pq[h.last-1], h.pq[h.first]
    # nullifierar vi sista positionen då du pop!:at?

    h.size -= 1
    h.last -= 1
    heapify!(h, h.first)
    return item
end

"""
    will be wrapped by minimum (for minheaps) and maximum for maxheaps
"""
function first(h::MyVectorPQ{T}) where {T}
    isempty(h) && nothing
    return h.pq[1]
end

function first(h::MyDynamicPQ{T}) where {T}
    isempty(h) && nothing
    return h.pq[h.first]
end

function first(t::TreePQ)
    isempty(t) && nothing
    return t.root
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
    h::Union{MaxVectorPQ{T}, MaxDynamicPQ{T}},
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
    h::Union{MinVectorPQ{T}, MinDynamicPQ{T}},
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
# function swim!(h::MaxVectorPQ{T}, keypos) where{T}
function swim!(h::MaxVectorPQ{T}, keypos, depth) where{T} # FOR BENCH
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= 1 && isless(h.pq[parent], h.pq[keypos])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        # return swim!(h, parent)
        return swim!(h, parent, depth + 1) # FOR BENCH
    end
end

"""
    swim!(h::MinVectorPQ{T}, keypos) where{T}

Bottom up for min heaps
"""
# function swim!(h::MinVectorPQ{T}, keypos) where{T}
function swim!(h::MinVectorPQ{T}, keypos, depth) where{T} # FOR BENCH
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= 1 && isless(h.pq[keypos], h.pq[parent])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        # return swim!(h, parent)
        return swim!(h, parent, depth + 1) # FOR BENCH
    end
end

"""
    swim!(h::MaxDynamicPQ{T}, keypos) where{T}

Bottom up for max heap
"""
# function swim!(h::MaxDynamicPQ{T}, keypos) where{T}
function swim!(h::MaxDynamicPQ{T}, keypos, depth) where{T} # FOR BENCH
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= h.first && isless(h.pq[parent], h.pq[keypos])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        # return swim!(h, parent)
        return swim!(h, parent, depth + 1) # FOR BENCH
    end
end

# function swim!(h::MinDynamicPQ{T}, keypos) where{T}
function swim!(h::MinDynamicPQ{T}, keypos, depth) where{T} # FOR BENCH
    parent = hparent(keypos) # ⌊keypos/2⌋

    if parent >= h.first && isless(h.pq[keypos], h.pq[parent])
        h.pq[keypos], h.pq[parent] = h.pq[parent], h.pq[keypos]
        # return swim!(h, parent)
        return swim!(h, parent, depth +1) # FOR BENCH
    end
end

function resize!(h::MyDynamicPQ{T}, newsize) where {T}
	temp = Array{Union{Nothing, T}}(nothing, newsize)

    for i = 1:length(h)
        pos = mod1((h.first + i - 1), capacity(h))
        temp[i] = h.pq[pos]
    end

	h.pq = temp
    h.first = 1
    h.last = h.first + h.size
	return
end

# adapt add so that it also returns the depth for bench
function add!(
    tree::TreePQ{K,V},
    key::K,
    value::V
    ) where {K,V}

    # tree.root = add!(tree.root, key, value)
    tree.root, depth = add!(tree.root, key, value, 1) # for bench # FOR BENCH
    # return tree
    return tree, depth # FOR BENCH
end

function add!(
    node::Union{BTNode{K, V}, Nothing},
    key::K,
    # value::V
    value::V, # FOR BENCH
    depth  # FOR BENCH
    ) where {K, V}

    if isa(node, Nothing)
        node = BTNode{K, V}(key, value, nothing, nothing, 1)
        # return node
        return node, depth # FOR BENCH
    end

    if key < node.key
        key, node.key = node.key, key
        value, node.value = node.value, value
    end

    # ska jag bryta ut node.size += 1? Enligt instr kan den göras här.
    # Eller funkar allt bra som det är? I kombination med 
    # `node.size = size(node.left= + size(node.right) + 1`?

    if isa(node.left, Nothing)
        # node.left = add!(node.left, key, value)
        node.left = BTNode{K, V}(key, value, nothing, nothing, 1)
        node.size += 1
        # return node
        return node, depth # FOR BENCH
    elseif isa(node.right, Nothing)
        # node.right = add!(node.right, key, value)
        node.right = BTNode{K, V}(key, value, nothing, nothing, 1)
        node.size += 1
        # return node
        return node, depth # FOR BENCH
    end

    if size(node.left) < 3
        # add!(node.left, key, value)
        add!(node.left, key, value, depth + 1) # FOR BENCH
    elseif size(node.right) < 3
        # add!(node.right, key, value)
        add!(node.right, key, value, depth + 1) # FOR BENCH
    elseif size(node.left) < rchild(size(node.right))
        # add!(node.left, key, value)
        add!(node.left, key, value, depth + 1) # FOR BENCH
    else
        # add!(node.right, key, value)
        add!(node.right, key, value, depth + 1) # FOR BENCH
    end

    node.size = size(node.left) + size(node.right) + 1 # osäker
    # return node
    return node, depth # FOR BENCH
end

# Funkar remove? Vad säger testerna?
function remove!(tree::TreePQ{K,V}) where {K,V}
    node = tree.root
    newnode = remove!(node)
    tree.root = newnode
    return node
end
    
function remove!(
    node::Union{BTNode{K, V}, Nothing}
    ) where {K,V}
    
    isa(node, Nothing) && return nothing
    # node.size == 1 && return node

    if isa(node.left, Nothing)
    #   && node = remove!(node.right)
        node = node.right
        return node
    elseif isa(node.right, Nothing)
        # node = remove!(node.left)
        node = node.left
        return node
    end

    if isless(node.right, node.left)
        node.key = node.right.key
        node.value = node.right.value
        node.right = remove!(node.right)
    else
        node.key = node.left.key
        node.value = node.left.value
        node.left = remove!(node.left)
    end
    node.size -= 1
    return node
    
end


# JUST FOR TESTING
# JUST FOR TESTING
# JUST FOR TESTING

print_tabs(numtabs::Int64) = for i = 1:numtabs print("  ") end

function print_tree(tree::TreePQ{K,V}, 
    node::Union{BTNode{K, V}, Nothing} = tree.root
    ) where {K, V}

    node === nothing && println("---<empty>---") && return
    println("ROOT")
    print_tree(node, 0)
    println("DONE")
end

function print_tree(
    node::Union{BTNode{K,V},Nothing}, 
    level::Int64
    ) where {K,V}

    if node === nothing
        print_tabs(level)
        println("---<empty>---")
        return
    end

    print_tabs(level)
    println(node) # Should work thanks to show

    print_tabs(level)
    println("LEFT")
    print_tree(node.left, (level += 1))

    print_tabs(level)
    println("RIGHT")
    print_tree(node.right, (level += 1))

    print_tabs(level)
    println("LEAF")
end
    