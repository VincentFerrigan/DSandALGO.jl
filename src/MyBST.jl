# MyBST.jl
"""
    MyBST

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
# Types
- BSTree{T} <: MyBinaryTree{T} <: MyAbstractTree{T} # BinarySearchTree
- BTNode{T} <:MyAbstractTreeNode{T} #BinaryTreeNode
# Outer constructs
- BST{T}()
# utils
- isempty
- push!
- findfirst
"""
module MyBST

import Base: isempty, push!, findfirst!

include("MyBST_types.jl")
include("MyBST_utils.jl")

# include("SortingAlgo.jl")
# import .SortingAlgo # or using insertionsort?

# export
    
end # end module