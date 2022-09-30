# MyBST_utils.jl
# Utils for MyBST module in MyBST.jl

# Utils

"""
    add!(node::BTtree{K, V}, key::K, value::V)

Adds a new node (leaf) to the BTree that maps given key to value.
If given key already present, the value that is maped to it gets updated,
with given value.

Returns the reference to the new/updated node

# Open Issues:
## Should key and value come in pairs, as in tuples? Should method
## return ref to tree instead of updated/newly created node?

# Arguments
- `node::BTtree{K, V}` : xxxxx
- `key::K` : xxxx
- `value::V` : xxxx
"""
function add!(tree::BTree{K,V}, key::K, value::V) where {K,V}
    if isempty(tree)
        tree.root = BTNode{K,V}(key, value, nothing, nothing)
    else
        add!(tree.root, key, value)
    end
end

"""
    add!(node::BTNode{K, V}, key::K, value::V)

Adds a new node (leaf) to the BTree of given `node`. 
The new node maps given key to value. If given key already present, the value
that is maped to it gets updated. 
Returns the reference to the new/updated node 

# Arguments
- `node::BTNode{K, V}` : xxxxx
- `key::K` : xxxx
- `value::V` : xxxx
"""
function add!(node::BTNode{K,V}, key::K, value::V) where {K,V}
    if key == node.key
        node.value = value
    elseif key < node.key
        if node.left === nothing
            node.left = BTNode{K,V}(key, value, nothing, nothing)
        else
            add!(node.left, key, value)
        end
    else
        if node.right === nothing
            node.right = BTNode{K,V}(key, value, nothing, nothing)
        else
            add!(node.right, key, value)
        end
    end
end

"""
    lookup(tree::BTree{K, V}, key::K)

Find and return the `value`` associated to given `key`.
The method will return `nothing` if `key`` is not found.
"""
function lookup(tree::BTree{K,V}, key::K) where {K,V}
    isempty(tree) && return nothing # or throw exeption??
    lookup(tree.root, key)
end

function lookup(node::BTNode{K,V}, key::K) where {K,V}
    if key == node.key
        return node.value
    elseif key < node.key
        node.left === nothing && return nothing
        lookup(node.left, key)
    else
        node.right === nothing && return nothing
        lookup(node.right, key)
    end
end

function iterate(tree::BTree{K, V}) where {K, V}
    node = tree.root
    node === nothing ? nothing : (node, push!(SinglyLLStack{BTNode{K, V}}(), node))
end

function iterate(_::BTree{K, V}, stack) where {K, V}
    node = MyStacks.peek(stack)
    if node === nothing 
        # println("nothing")
        return nothing
    elseif node.left !== nothing
        # println("go left")
        return (node.left, MyStacks.push!(stack, node.left))
    else
        # println("LEAF!, Backtrack with pop")
        while node !== nothing
            if node.right !== nothing
                # println("go right after pop and push right")
                MyStacks.pop!(stack)
                return (node.right, MyStacks.push!(stack, node.right))
            elseif node.left !== nothing
                # println("pop! elseifleft")
                MyStacks.pop!(stack)
                node =  MyStacks.peek(stack) 
            else
                # println("LEAF!, Backtrack with popelse")
                MyStacks.pop!(stack)
                node =  MyStacks.peek(stack) 
            end
        end
        # println("nothing after pop")
        return nothing
    end
end

function isempty(tree::BTree{K,V}) where {K,V}
    tree.root === nothing ? true : false
end

function show(io::IO, node::BTNode{K,V}) where {K,V}
    print(" key: ", node.key, " => value: ", node.value)
end

function print_tree(tree::BTree{K, V}, node::Union{BTNode{K, V}, Nothing} = tree.root) where {K, V}
    node === nothing && println("---<empty>---") && return
    println("ROOT")
    print_tree(node, 0)
    println("DONE")
end

function print_tabs(numtabs::Int64)
    for i = 1:numtabs
        print("  ")
    end
end

function print_tree(node::Union{BTNode{K,V},Nothing}, level::Int64) where {K,V}
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

## vet inte riktigt. En vector av tuples vore något!? Hur beskriva detta?
function createBST(v::Vector{Tuple{K, V}}) where {K, V}
    # length(v) == 0 && BTree{K, V}()
    length(v) == 0 && return nothing

    # sort list with some your sorting algorithms??
    # I suggest insertionsort if the vector is already partially sorted

    bst = BTree{K, V}()
    # bst = BTree{T}()
    for item ∈ v
        add!(bst, item[1], item[2])
    end
    return bst
end