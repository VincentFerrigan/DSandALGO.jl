# MyBST.jl
"""
    MyBST

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
# Types
- BTNode{K, V} <:MyAbstractTreeNode{T} #BinaryTreeNode
- BTree{K, V} <: MyBinaryTree{T} <: MyAbstractTree{T} # BinaryTree
# Outer constructs
- BTree{K, V}()
# utils
- add! - 2 methods
- lookup - 2 methods
- iterate - 3 methods
- isempty
- show - 2 methods
- print_tabs
- print_tree - 2 methods
- createBST # OSÄKER KRING
"""
module MyBST

import Base: isempty, show, iterate

include("MyStacks.jl")
using .MyStacks

include("MyBST_types.jl")
include("MyBST_utils.jl")

# include("SortingAlgo.jl")
# import .SortingAlgo # or using insertionsort?
export BTree, BTNode, isempty, show, iterate, 
add!, lookup, createBST, print_tree, print_tabs

end # end module