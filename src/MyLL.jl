# MyLL.jl
module MyLL

import Base: isempty, pushfirst!, popfirst!, length, append!, push!, pop!, show
export SinglyLinkedList, 
append!, pushfirst!, popfirst!, peekfirst, listfromvector, isempty, findtail

# Types
abstract type MyAbstractNode{T} end
abstract type MyAbstractLinkedList{T} end
abstract type MyImprovedLinkedList{T} end

mutable struct SingleNode{T} <: MyAbstractNode{T}
    data::T
    next::Union{SingleNode{T}, Nothing}
end

mutable struct DoubleNode{T} <: MyAbstractNode{T}
    data::T
    previous::Union{DoubleNode{T}, Nothing}
    next::Union{DoubleNode{T}, Nothing}
end

mutable struct BinaryTreeNode{T} <:MyAbstractNode{T}
    key
    value::T
    left::Union{BinaryTreeNode{T}, Nothing}
    right::Union{BinaryTreeNode{T}, Nothing}
end

mutable struct SinglyLinkedList{T} <: MyAbstractLinkedList{T}
    head::Union{Nothing, SingleNode{T}}
    n::Int
end

mutable struct DoublyLinkedList{T} <: MyAbstractLinkedList{T}
    head::Union{Nothing, DoubleNode{T}}
    n::Int
end

mutable struct BinaryTree{T}
    head::Union{Nothing, BinaryTreeNode{T}}
    # depth::Int
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
DoublyLinkedList{T}() where {T} = DoublyLinkedList(nothing, 0)
IDoublyLinkedList{T}() where {T} = IDoublyLinkedList(nothing, nothing, 0) # if with tail
ISinglyLinkedList{T}() where {T} = ISinglyLinkedList(nothing, nothing, 0) # if with tail

# utils
length(ll::MyAbstractLinkedList{T}) where {T} = ll.n

function isempty(ll::MyAbstractLinkedList{T}) where {T} 
    ll.head === nothing ? true : false
end

function pushfirst!(sll::SinglyLinkedList{T}, item::T) where {T} ## how to do if items...
    if isempty(sll)
        sll.head = SingleNode{T}(item, nothing)
    else
        oldhead = sll.head
        newhead = SingleNode{T}(item, oldhead)
        sll.head = newhead
    end
    sll.n += 1
    return sll
end


function popfirst!(ll::MyAbstractLinkedList{T}) where T
    ll.n == 0  &&  throw(ArgumentError("List is empty"))

    item = ll.head.data
    oldhead = ll.head
    ll.head = oldhead.next
    ll.n -= 1
    if ll.n == 0 ll.head = nothing end
    return item
end


function push!(sll::SinglyLinkedList{T}, item::T) where {T}
    if isempty(sll)
        sll.head = SingleNode{T}(item, nothing)
    else
        tail = findtail(sll) 
        tail.next = SingleNode{T}(item, nothing)
    end
    sll.n += 1
    return sll # alt. skriv utan retur
end


# Hur använda på bästa sätt? Går det att använda för findtail?
function iterate(sll::MyAbstractLinkedList{T}, 
    node::Union{MyAbstractNode{T}, Nothing} = sll.head) where {T}
    node === nothing ? nothing : (node.data, node.next)
end

# # Krockade en del. Vet inte riktigt varför
# function show(io::IO, ll::MyAbstractLinkedList)
#     for data in ll
#         print(data, " ")
#     end
# end

function findtail(ll::MyAbstractLinkedList)
    # short-curcuit condition
    isempty(ll) && throw(BoundsError())

    node = ll.head
    while node.next !== nothing
        node = node.next
    end
    return node
end

function append!(firstlist::SinglyLinkedList, secondlist::SinglyLinkedList)
    if isempty(firstlist)
        firstlist.head = secondlist.head
    else
        tail = findtail(firstlist)
        tail.next = secondlist.head
    end
    firstlist.n += secondlist.n
    firstlist
end

function peekfirst(ll::MyAbstractLinkedList)
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    item = ll.head.data
    return item
end

# Som en pushfirst!(list::SingleLinkedList, iter...)
function listfromvector(vector::Vector{T}) where {T}
    # short-circuit return conditions
    length(vector) == 0 && return SinglyLinkedListA{T}()
    # length(vector) == 1 && return SinglyLinkedList(vector[1])

    newlist = SinglyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    i = length(vector)
    while i > 0 
        pushfirst!(newlist, vector[i])
        i -= 1
    end
    return newlist
end
end # module