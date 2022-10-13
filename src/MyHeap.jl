
# MyHeap.jl
"""
    MyHeap

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-13
Notes:

Contains:
# Types
???
# Outer constructs
??
# utils
* parent
* left
* right
* max_heapify
* min_heapify
* build_max_heap
* build_min_heap
* ...insert
* ...extract_max
* ...increase_key
* ...maximum
* ...minimum

"""
module MyHeap

import Base: length

include("MyHeap_types.jl") # includes types and outer constructs
include("MyHeap_utils.jl") # includes all functions for linkedlists

export MaxHeapVector # constructor
export heapsort! # methods
export length # base overload
export hparent, lchild, rchild # utilitys for testing
# export 
end # module