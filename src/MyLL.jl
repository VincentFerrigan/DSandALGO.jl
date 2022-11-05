# MyLL.jl
"""
    MyLL

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-29
Notes:

Contains:
# Types
- SingleNode <: MyLinkedListNode <: MyAbstractNode 
- DoubleNode <: MyLinkedListNode <: MyAbstractNode
- SinglyLinkedList <: MyBasicLinkedList <: MyAbstractLinkedList
- DoublyLinkedList <: MyBasicLinkedList <: MyAbstractLinkedList
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
- isless
- show #TODO
- iterate
- pushfirst!
- push!
- remove!
- popfirst!
- pop! #TODO : tests
- popitem! # TODO
- removeitem!
- append!
- peekfirst
- findtail
- findnode_withnext: tests
- findfirst: tests
- sllistfromvector # kan göras som en function med flera metoder, då man kan skicka in en lista oavsett typ
- dllistfromvector
- isllistfromvector
- createrandom_sllist # Utils for benchmarking
- createrandom_sllist # Utils for benchmarking

"""
module MyLL

using Random # for creating random lists/vectors

import Base: isempty, pushfirst!, popfirst!, length, isless, isequal
import Base: append!, push!, pop!, popat!, show, findfirst, iterate

include("MyLL_types.jl") # includes types and outer constructs
include("MyLL_utils.jl") # includes all functions for linkedlists

export SinglyLinkedList, DoublyLinkedList
export ISinglyLinkedList, IDoublyLinkedList
export SingleNode, DoubleNode
export append!, pushfirst!, popfirst!, pop!, push!, popat!, remove!, peekfirst
export isempty, length, show, findtail, removeitem!, iterate
export sllistfromvector, dllistfromvector, isllistfromvector, idllistfromvector 
export createrandom_sllist, createrandom_dllist

end # module