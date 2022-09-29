# MyBST_utils.jl
# Utils for MyBST module in MyBST.jl

# Utils
function isempty(tree::BSTree{T}) where {T}
    tree.root === nothing ? true : false
end

"""
    push!(tree::BSTree{T}, item::T)

Inserts item in Binary Search Tree
Returns reference to node containing item or `nothing` if item already exists. 
# Arguments
- `tree::BSTree{T}` : xxxxx
- `item::T` : xxxx
"""
function push!(tree::BSTree{T}, item::T) where {T}
    if isempty(tree)
        tree.root = BTNode{T}(item, nothing, nothing)
    else
        push!(tree.root, item)
    end
end

"""
    push!(node::BTNode{T}, item::T)

Inserts item in Binary Tree
Returns reference to node containing item or `nothing` if item already exists. 
# Arguments
- `node::BSNode{T}` : xxxxx
- `item::T` : xxxx
"""
function push!(node::BTNode{T}, item::T) where {T}
    if item == node.data
        return nothing
    elseif item < node.data
        if node.left === nothing 
            node.left = BTNode{T}(item, nothing, nothing)
        else 
            push!(node.left, item) 
        end
    else
        if node.right === nothing 
            node.right = BTNode{T}(nothing, nothing)
        else 
            push!(node.right, item) 
        end
    end
end

"""
    findfirst(tree::BStree{T}, item::T)

Finds the first occurrence of item in given tree, returns node.
Returns nothing if no such item is found
"""
function findfirst(tree::BStree{T}, item::T)
    isempty(tree) && return nothing # or throw exeption??
    findfirst(tree.root, item)
end

function findfirst(node::BSNode{T}, item::T) where {T}
    if item == node.data return node
    elseif item < node.data
        node.left === nothing && return nothing
        findfirst(node.left, item)
    else
        node.right === nothing && return nothing
        findfirst(node.right, item)
    end
end


function createBST(v::Vector{T} where {T})
    length(v) == 0 && BSTree{T}()

    # sort list with some your sorting algorithms??
    # I suggest insertionsort if the vector is already partially sorted

    bst = BSTree{T}()
    for item ∈ v
        push!(bst, item)
    end

    return bst
end

# function isleaf()
