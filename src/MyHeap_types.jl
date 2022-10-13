# MyHeap_types.jl
# Types for MyHeap module in MyHeap.jl

abstract type MyAbstractHeap{T} end
abstract type MyVectorHeap{T} <: MyAbstractHeap{T} end
abstract type MyListHeap{T} <: MyAbstractHeap{T} end

mutable struct MaxHeapVector{T} <: MyVectorHeap{T}
    heaptree::Vector{T}
    heapsize
    # inner constructors
    # MaxHeapVector{T}() where {T} = new{T}(Vector{T}())
    MaxHeapVector{T}() where {T} = new(Vector{T}(), 0)

    function MaxHeapVector{T}(v::Vector{T}) where {T}
        newheap = new(v, length(v))
        build_max_heap!(newheap)
        return newheap
    end
end

# outerconstruct
MaxHeapVector(v::Vector{T}) where {T} = MaxHeapVector{T}(v)

