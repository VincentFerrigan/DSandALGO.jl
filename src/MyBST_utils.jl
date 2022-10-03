# MyBST_utils.jl
# Utils for MyBST module in MyBST.jl

# Utils

isempty(tree::BTree{K, V}) where {K, V} = isempty(tree.root)

isempty(node::Union{BTNode{K, V}, Nothing}) where {K,V} = node === nothing ? true : false

size(tree::BTree{K, V}) where {K, V} = size(tree.root)

size(node::Union{BTNode{K, V}, Nothing}) where {K,V} = isempty(node) ? 0 : node.n

"""
    add!(node::BTtree{K, V}, key::K, value::V)

Adds a new node (leaf) to the BTree that maps given key to value.
If given key already present, the value that is maped to it gets updated,
with given value.
aka put!()

Returns the reference to the new/updated node

# Open Issues:
## Should key and value come in pairs, as in tuples? 
## Will method return ref to tree instead of updated/newly created node?

# Arguments
- `node::BTtree{K, V}` : xxxxx
- `key::K` : xxxx
- `value::V` : xxxx
"""
function add!(tree::BTree{K, V}, key::K, value::V) where {K,V} # aka put!()
    tree.root = add!(tree.root, key, value)
    tree
end

"""
    add!(node::BTNode{K, V}, key::K, value::V)

Adds a new node (leaf) to the BTree of given `node`. 
The new node maps/associates given key to value. If given key already present, the value
that is maped/associated to it gets updated. 
aka put!()

Returns the reference to the new/updated node 

# Arguments
- `node::BTNode{K, V}` : xxxxx
- `key::K` : xxxx
- `value::V` : xxxx
"""
function add!(
    node::Union{BTNode{K, V}, Nothing}, 
    key::K, 
    value::V
    ) where {K,V}

    if isempty(node) 
        return BTNode{K, V}(key, value, nothing, nothing, 1)
    end

    if key < node.key
        node.left = add!(node.left, key, value)
    elseif key > node.key
        node.right= add!(node.right, key, value)
    else
        node.value = value
    end

    node.n = size(node.left) + size(node.right) + 1
    return node
end

"""
    lookup(tree::BTree{K, V}, key::K)

Find and return the `value`` associated to given `key`.
The method will return `nothing` if `key`` is not found.
aka get()
"""
lookup(tree::BTree{K,V}, key::K) where {K,V} = lookup(tree.root, key)

function lookup(node::Union{BTNode{K, V}, Nothing}, key::K) where {K,V}
    isempty(node) && return nothing

    if key < node.key
        lookup(node.left, key)
    elseif key > node.key
        lookup(node.right, key)
    else
        return node.value
    end
end

function iterate(tree::BTree{K,V}) where {K,V}
    node = tree.root
    (node === nothing ? 
    nothing : 
    (node, push!(SinglyLLStack{BTNode{K, V}}(), node))
        )
end

function iterate(_::BTree{K,V}, stack) where {K,V}
    node = MyStacks.peek(stack)
    isempty(node) && return nothing

    if !(isempty(node.left)) # if node is not nothing i.e. node !== nothing
        return (node.left, MyStacks.push!(stack, node.left))
    else
        while !(isempty(node)) # or !(isempty(node)) instead of while node !== nothing
            if !(isempty(node.right)) # istead of if node.right !== nothing
                MyStacks.pop!(stack)
                return (node.right, MyStacks.push!(stack, node.right))
            else
                MyStacks.pop!(stack)
                node = MyStacks.peek(stack)
            end
        end
        return nothing
    end
end

function show(io::IO, node::BTNode{K,V}) where {K,V}
    print(" key: ", node.key, " => value: ", node.value)
end

function print_tabs(numtabs::Int64)
    for i = 1:numtabs
        print("  ")
    end
end

function print_tree(tree::BTree{K,V}, 
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

# should this even be here? Maybe just as benchfunction???
function createBST(v::Vector{V}) where V
    # length(v) == 0 && BTree{K, V}()
    length(v) == 0 && return nothing

    # sort list with some your sorting algorithms??
    # I suggest insertionsort if the vector is already partially sorted
    keys = Vector(1:length(v))
    shuffle!(keys)

    bst = BTree{eltype(keys), V}()

    for key ∈ keys
        add!(bst, key, v[key])
    end
    return bst
end

## vet inte riktigt. En vector av tuples vore något!? Hur beskriva detta?
function createBST(v::Vector{Tuple{K, V}}) where {K, V}
    # length(v) == 0 && BTree{K, V}()
    length(v) == 0 && return nothing

    # sort list with some your sorting algorithms??
    # I suggest insertionsort if the vector is already partially sorted

    bst = BTree{K,V}()
    for item ∈ v
        add!(bst, item[1], item[2])
    end
    return bst
end