
# MyPQ.jl
"""
    MyPQ

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-13
Notes:

Contains:
# Types
* MaxVectorPQ{T} <: MyVectorPQ{T} <: MyAbstractHeap{T}
* MinVectorPQ{T} <: MyVectorPQ{T} <: MyAbstractHeap{T}
* MyListPQ{T} <: MyAbstractHeap{T} # not done yet
* VectorPQNode{K, V}
# Utils



## Heap arithmatic
* hparent
* lchild
* rchild
## Base overload utils
* length
* isempty
* isless
* isequal
* show
* minimum
* maximum

# short utils and wrappers
* capacity
* popmin!
* popmax!

# base overload methods
* pop! # not yet tested
* push!
* first

# functions and methods
* build_minmax_pq! - 2 methods
* heapify! - 2 methods
* heapsort!
* swim! - 2 methods

# todo
## List/Tree based - AVL? Balanced BST?
* ...extract_max
* ...increase_key

"""
module MyPQ

import Base: length, isempty, isless, isequal, show
import Base: minimum, maximum, push!, pop!, first

# include("MyBST.jl")
include("MyPQ_types.jl") # includes types and outer constructs
include("MyPQ_utils.jl") # includes all functions for linkedlists

# using .MyBST
# for export
export MaxVectorPQ, MinVectorPQ, VectorPQNode # constructors
export heapsort!, popmin!, popmax! # methods
export push!, minimum, maximum # base overload for export

# for unittesting
export hparent, lchild, rchild, capacity # utilitys for testing
export pop!, length, isempty, isless, show # base overload for testing

end # module