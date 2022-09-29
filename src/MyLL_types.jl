# MyLL_types.jl
# Types for MyLL module in MyLL.jl

# Types
abstract type MyAbstractNode{T} end
abstract type MyLinkedListNode{T} <: MyAbstractNode{T} end
abstract type MyAbstractLinkedList{T} end
abstract type MyBasicLinkedList{T} <: MyAbstractLinkedList{T} end
abstract type MyImprovedLinkedList{T} <: MyAbstractLinkedList{T} end

mutable struct SingleNode{T} <: MyLinkedListNode{T}
    data::T
    next::Union{SingleNode{T}, Nothing}
end

mutable struct DoubleNode{T} <: MyLinkedListNode{T}
    data::T
    previous::Union{DoubleNode{T}, Nothing}
    next::Union{DoubleNode{T}, Nothing}
end

mutable struct SinglyLinkedList{T} <: MyBasicLinkedList{T}
    head::Union{Nothing, SingleNode{T}}
    n::Int64
end

mutable struct DoublyLinkedList{T} <: MyBasicLinkedList{T}
    head::Union{Nothing, DoubleNode{T}}
    n::Int64
end

"""
Improved SinglyLinkedList
With head and Tail
"""
mutable struct ISinglyLinkedList{T} <: MyImprovedLinkedList{T}
    head::Union{Nothing, SingleNode{T}}
    tail::Union{Nothing, SingleNode{T}} # if with tail
    n::Int
end

"""
Improved DoublyLinkedList
With head and Tail
"""
mutable struct IDoublyLinkedList{T} <: MyImprovedLinkedList{T}
    head::Union{Nothing, DoubleNode{T}}
    tail::Union{Nothing, SingleNode{T}} # if with tail
    n::Int
end

# Outer constructs
SinglyLinkedList{T}() where {T} = SinglyLinkedList{T}(nothing, 0)
DoublyLinkedList{T}() where {T} = DoublyLinkedList{T}(nothing, 0)
IDoublyLinkedList{T}() where {T} = IDoublyLinkedList{T}(nothing, nothing, 0) # if with tail
ISinglyLinkedList{T}() where {T} = ISinglyLinkedList{T}(nothing, nothing, 0) # if with tail