# MyLL.jl
"""
    MyLL

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
# Types
- SingleNode <: MyLinkedListNode <: MyAbstractNode 
- DoubleNode <: MyLinkedListNode <: MyAbstractNode
- BinaryTreeNode <: MyAbstractNode
- SinglyLinkedList <: MyBasicLinkedList <: MyAbstractLinkedList
- DoublyLinkedList <: MyBasicLinkedList <: MyAbstractLinkedList
- BinaryTree{T} <: MyAbstractTree # TODO
- ISinglyLinkedList <: MyImprovedLinkedList <: MyAbstractLinkedList
- IDoublyLinkedList <: MyImprovedLinkedList <: MyAbstractLinkedList
# Outer constructs
- SinglyLinkedList{T}()
- DoublyLinkedList{T}()
- IDoublyLinkedList{T}()
- ISinglyLinkedList{T}() 
# utils
- length
- isempty
- show #TODO
- iterate
- pushfirst!
- popfirst!
- push!
- pop! #TODO : tests
- popitem! # TODO
- removeitem!
- append!
- peekfirst
- findtail
- findnode_withnext: tests
- findfirst: tests
- sllistfromvector
- dllistfromvector
- createrandom_sllists # Utils for benchmarking
- createrandom_sllists # Utils for benchmarking

"""
module MyLL

using Random # for creating random lists/vectors

import Base: isempty, pushfirst!, popfirst!, length
import Base: append!, push!, pop!, show, findfirst

include("MyLLTypes.jl") # includes types and outer constructs
include("MyLLUtils.jl") # includes all functions for linkedlists

export SinglyLinkedList, DoublyLinkedList,
append!, pushfirst!, popfirst!, pop!, push!, peekfirst, 
isempty, findtail, removeitem!,
sllistfromvector, dllistfromvector, 
createrandom_sllists, createrandom_dllists

end # module