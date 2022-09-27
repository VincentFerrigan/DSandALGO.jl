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
- pushfirst!
- popfirst!
- push!
- pop! #TODO : tests
- popitem! # TODO
- removeitem!
- append!
- peekfirst
- iterate
- findtail
- findnode_withnext: tests
- findfirst: tests
- sllistfromvector
- dllistfromvector
"""
module MyLL

import Base: isempty, pushfirst!, popfirst!, length, append!, push!, pop!, show, findfirst
export SinglyLinkedList, DoublyLinkedList,
append!, pushfirst!, popfirst!, pop!, push!, peekfirst, 
sllistfromvector, dllistfromvector, isempty, findtail, removeitem!

# Types
abstract type MyAbstractNode{T} end
abstract type MyLinkedListNode{T} <: MyAbstractNode{T} end
abstract type MyAbstractLinkedList{T} end
abstract type MyBasicLinkedList{T} <: MyAbstractLinkedList{T} end
abstract type MyImprovedLinkedList{T} <: MyAbstractLinkedList{T} end
# abstract type MyAbstractTree{T} end

mutable struct SingleNode{T} <: MyLinkedListNode{T}
    data::T
    next::Union{SingleNode{T}, Nothing}
end

mutable struct DoubleNode{T} <: MyLinkedListNode{T}
    data::T
    previous::Union{DoubleNode{T}, Nothing}
    next::Union{DoubleNode{T}, Nothing}
end

mutable struct BinaryTreeNode{T} <:MyAbstractNode{T}
    key # Vad ska det vara?
    value::T
    left::Union{BinaryTreeNode{T}, Nothing}
    right::Union{BinaryTreeNode{T}, Nothing}
end

mutable struct SinglyLinkedList{T} <: MyBasicLinkedList{T}
    head::Union{Nothing, SingleNode{T}}
    n::Int
end

mutable struct DoublyLinkedList{T} <: MyBasicLinkedList{T}
    head::Union{Nothing, DoubleNode{T}}
    n::Int64
end

# mutable struct BinaryTree{T} <: MyAbstractTree
#     head::Union{Nothing, BinaryTreeNode{T}}
#     # depth::Int
# end

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

# utils
length(ll::MyAbstractLinkedList{T}) where {T} = ll.n

function isempty(ll::MyBasicLinkedList{T}) where {T} 
    ll.head === nothing ? true : false
end

# # TODO
# # Krockade en del. Vet inte riktigt varför
# function show(io::IO, ll::MyAbstractLinkedList)
#     for data in ll
#         print(data, " ")
#     end
# end

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

function pushfirst!(dll::DoublyLinkedList{T}, item::T) where {T}
    if isempty(dll)
        dll.head = DoubleNode{T}(item, nothing, nothing)
    else
        oldhead = dll.head
        newhead = DoubleNode{T}(item, nothing, oldhead)
        oldhead.previous = newhead
        dll.head = newhead
    end
    dll.n += 1
    return dll
end


"""
    popfirst!(ll:MyAbstractLinkedList)

Removes removes the item from the beginning of the list
# Arguments
- `ll::MyAbstractLinkedList` : List of type SinglyLinkedList and DoublyLinkedList
"""
function popfirst!(ll::MyBasicLinkedList{T}) where T
    ll.n == 0  &&  throw(ArgumentError("List is empty"))

    item = ll.head.data
    oldhead = ll.head
    ll.head = oldhead.next
    ll.n -= 1
    if ll.n == 0 
        ll.head = nothing 
    elseif isa(ll, DoublyLinkedList)
        ll.head.previous = nothing
    end
    return item
end

function push!(sll::SinglyLinkedList{T}, item::T) where {T}
    if isempty(sll)
        sll.head = SingleNode{T}(item, nothing)
    else
        oldtail = findtail(sll) 
        oldtail.next = SingleNode{T}(item, nothing)
    end
    sll.n += 1
    return sll # alt. skriv utan retur
end

function push!(dll::DoublyLinkedList{T}, item::T) where {T}
    if isempty(dll)
        dll.head = DoubleNode{T}(item, nothing, nothing)
    else
        oldtail = findtail(dll)
        newtail = DoubleNode{T}(item, oldtail, nothing)
        oldtail.next = newtail
    end
    dll.n += 1
    return dll
end

# # TODO: tests
function pop!(ll::MyBasicLinkedList{T}) where {T}
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    oldtail = findtail(ll)
    item = oldtail.data
    if isa(ll, DoublyLinkedList)
        newtail = oldtail.previous
        newtail.next = nothing
    elseif isa(ll, SinglyLinkedList)
        newtail = findnode_withnext(ll, oldtail)
        @assert newtail !== nothing
        newtail.next = nothing
    end
    ll.n -= 1
    if ll.n == 0 ll.head = nothing end
    return item
end

"""
    removeitem!(ll::MyBasicLinkedList{T}, item::T)

Removes the first occurrence of item in given list. 
Returns nothing if no such item is found.
# TODO
- what if previous or next are nothings?
- test
"""
function removeitem!(ll::MyBasicLinkedList{T}, item::T) where {T}
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    node = findfirst(ll, item)
    if isa(node, Nothing)
        return nothing
    elseif isa(ll, DoublyLinkedList)
        previousnode = node.previous
        nextnode = node.next
        previousnode.next = nextnode
        nextnode.previous = previousnode
        # finish? Do test. Is the above correct? 
    elseif isa(ll, SinglyLinkedList)
        previousnode = findnode_withnext(ll, node)
        nextnode = node.next
        previousnode.next = nextnode
    end
    ll.n -= 1
    if ll.n == 0 ll.head = nothing end

    return item
end

function append!(firstlist::SinglyLinkedList, secondlist::SinglyLinkedList)
    if isempty(firstlist)
        firstlist.head = secondlist.head
    else
        oldtail = findtail(firstlist)
        oldtail.next = secondlist.head
    end
    firstlist.n += secondlist.n
    firstlist
end
function append!(firstlist::DoublyLinkedList, secondlist::DoublyLinkedList)
    if isempty(firstlist)
        firstlist.head = secondlist.head
    else
        oldtail = findtail(firstlist)
        oldhead = secondlist.head
        oldhead.previous = oldtail
        oldtail.next = oldhead
    end
    firstlist.n += secondlist.n
    firstlist
end

function peekfirst(ll::MyAbstractLinkedList)
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    item = ll.head.data
    return item
end

# Hur använda på bästa sätt? Går det att använda för findtail?
function iterate(ll::MyAbstractLinkedList{T}, 
    node::Union{MyLinkedListNode{T}, Nothing} = sll.head) where {T}
    if isa(ll, SinglyLinkedList) 
        node === nothing ? nothing : (node.data, node.next)
    elseif isa(ll, DoublyLinkedList)
        node === nothing ? nothing : (node.data, node.previous, node.next)
    end
    return node
end


function findtail(ll::MyBasicLinkedList{T}) where {T}
    # short-curcuit condition
    isempty(ll) && throw(BoundsError())

    node = ll.head
    while node.next !== nothing
        node = node.next
    end
    return node
end

# # TODO: tests
function findnode_withnext(ll::MyAbstractLinkedList{T}, 
    nextnode::MyLinkedListNode{T}) where {T}

    # short-curcuit condition
    isempty(ll) && throw(BoundsError())

    node = ll.head
    while node.next !== nextnode
        if node.next !== nothing
            node = node.next
        else
            return nothing
        end
    end
    return node
end

# # TODO: tests
"""
    findtnode_withitem(ll::MyAbstractLinkedList{T}, item::T)

Finds the first occurrence of item in given list, returns node.
Returns nothing if no such item is found
"""
function findfirst(ll::MyAbstractLinkedList{T}, item::T) where {T}
    # short-curcuit condition
    isempty(ll) && throw(BoundsError())

    node = ll.head
    while node.data != item
        if node.next !== nothing
            node = node.next
        else
            return nothing
        end
    end
    return node
end

# Ska göras om
# Som en pushfirst!(list::SinglyLinkedList, iter...)
function sllistfromvector(vector::Vector{T}) where {T}
    # short-circuit return conditions
    length(vector) == 0 && return SinglyLinkedList{T}()
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

# Ska göras om
# Som en pushfirst!(list::SinglyLinkedList, iter...)
function dllistfromvector(vector::Vector{T}) where {T}
    # short-circuit return conditions
    length(vector) == 0 && return DoublyLinkedList{T}()
    # length(vector) == 1 && return DoublyLinkedList(vector[1])

    newlist = DoublyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    i = length(vector)
    while i > 0 
        pushfirst!(newlist, vector[i])
        i -= 1
    end
    return newlist
end

end # module