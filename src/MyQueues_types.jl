# MyQueues_types.jl
# Types for MyQueues module in MyQueues.jl


# types
abstract type MyQueue{T} end
abstract type MyVectorQueue{T} <: MyQueue{T} end
abstract type MyListQueue{T} <: MyQueue end

mutable struct SLQueue{T} <: MyListQueue
    items::MyLL.ISinglyLinkedList{T}
    first
    last
    n
    function SLQueue{T}() where {T}
        isll = MyLL.ISinglyLinkedList{T}()
        new(isll, isll.head, isll.tail, isll.n)
end

mutable struct DynamicQueue{T} <: MyListQueue
    items::Vector{T}
    first::Int
    last::Int
    n::Int
end