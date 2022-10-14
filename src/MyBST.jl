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
- isempty - 2 methods
- size - 2 methods
- add! - 2 methods
- lookup - 2 methods
- iterate - 2 methods
- show # should I also add one for tree?
- print_tabs # help function for print_tree
- print_tree - 2 methods
- createBST # unsure # should this even be here? Maybe just as benchfunction???

"""
module MyBST

using Random # for createBST
import Base: isempty, show, iterate, size, length, isequal, isless

include("MyStacks.jl")
using .MyStacks
include("MyQueues.jl")
using .MyQueues

include("MyBST_types.jl")
include("MyBST_utils.jl")

# include("SortingAlgo.jl")
# import .SortingAlgo # or using insertionsort?
export BTree, BTNode

# base overload
export isempty, show, iterate, size, length, isequal, isless
export add!, lookup, createBST, print_tree, binary_search

end # end module