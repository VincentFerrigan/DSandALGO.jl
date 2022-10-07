# MyQueues_types.jl
# Types for MyQueues module in MyQueues.jl


# types
abstract type MyQueue{T} end
abstract type MyVectorQueue{T} <: MyQueue{T} end
abstract type MyListQueue{T} <: MyQueue{T} end

mutable struct SLQueue{T} <: MyListQueue{T}
    items::MyLL.ISinglyLinkedList{T}
    first
    last
    n
    function SLQueue{T}() where {T}
        isll = MyLL.ISinglyLinkedList{T}()
        new(isll, isll.head, isll.tail, isll.n)
    end
end

mutable struct DynamicQueue{T} <: MyVectorQueue{T}
    items::Array{Union{Nothing, T}}
    first::Int
    last::Int
    n::Int # number of slots used, not equal to last
    function DynamicQueue{T}(queuecapacity = 4) where {T}
        new(Array{Union{Nothing, T}}(nothing, queuecapacity), 1, 1, 0)
    end
end