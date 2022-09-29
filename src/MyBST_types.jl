# MyBST_types.jl
# Types for MyBST module in MyBST.jl

# Types
abstract type MyAbstractTree{T} end
abstract type MyBinaryTree{T} <: MyAbstractTree{T} end
abstract type MyAbstractTreeNode{T} end

mutable struct BSTree{T} <: MyBinaryTree{T} # BinarySearchTree
    root::Union{Nothing, BTNode{T}}
    # depth::Int
end
mutable struct BTNode{T} <:MyAbstractTreeNode{T} #BinaryTreeNode
    data::T
    left::Union{BTNode{T}, Nothing}
    right::Union{BTNode{T}, Nothing}
end


# Outer constructs
BSTree{T}() where {T} = BSTree{T}(nothing)
# BSTree{T}() where {T} = BSTree{T}(nothing, 0)