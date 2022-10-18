
# MyPQ.jl
"""
    MyPQ

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-13
Notes:

TODO: 
* add increase key/prio functionality and BenchMarks
* Test key/prio increase func
* Benchmark 
* IMRaD


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

## short utils and wrappers
* capacity
* popmin!
* popmax!

## base overload methods
* push!
* pop! 
* first

## functions and methods
* build_minmax_pq! - 2 methods
* heapify! - 3 methods
* heapsort!
* swim! - 3 methods

# todo
## List/Tree based - AVL? Balanced BST?
* ...extract_max
* ...increase_key

"""
module MyPQ

import Base: length, isempty, isless, isequal, show, size, iterate
import Base: minimum, maximum, push!, pop!, first, resize!

include("MyPQ_types.jl") # includes types and outer constructs
include("MyPQ_utils.jl") # includes all functions for linkedlists

include("MyQueues.jl")
using .MyQueues

# for export
export MaxVectorPQ, MinVectorPQ # constructors (Static Vectors)
export MaxDynamicPQ, MinDynamicPQ # constructors (Dynamic Vectors)
export VectorPQNode # constructor (Dynamic Vector Node)
export TreePQ, BTNode # constructors (Tree and tree nodes)
export heapsort!, popmin!, popmax! # methods
export remove!, add! # NOTTESTEDDDDD
export push!, minimum, maximum # base overload for export

# for unittesting
export hparent, lchild, rchild, capacityleft # utilitys for testing
export pop!, length, isempty, isless, show, size # base overload for testing

end # module