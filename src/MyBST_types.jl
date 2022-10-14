# MyBST_types.jl
# Types for MyBST module in MyBST.jl

# Types
abstract type MyAbstractTree{K, V} end
abstract type MyBinaryTree{K, V} <: MyAbstractTree{K, V} end
abstract type MyAbstractTreeNode{K, V} end

mutable struct BTNode{K, V} <:MyAbstractTreeNode{K, V} #BinaryTreeNode
    key::K
    value::V
    left::Union{BTNode{K, V}, Nothing}
    right::Union{BTNode{K, V}, Nothing}
    n::Int64 # Size/length of the subtree
end

mutable struct BTree{K, V} <: MyBinaryTree{K, V} # BinaryTree
    root::Union{Nothing, BTNode{K, V}}
    # depth::Int
end

# Outer constructs
BTree{K, V}() where {K, V} = BTree{K, V}(nothing)
# BTree{T}() where {T} = BTree{T}(nothing, 0)