# MyLL_utils.jl
# Utils for MyLL module in MyLL.jl

# Utils
length(ll::MyBasicLinkedList{T}) where {T} = ll.n

function isempty(ll::MyAbstractLinkedList{T}) where {T} 
    ll.head === nothing ? true : false
end

# # TODO
# # Krockade en del. Vet inte riktigt varför
function show(io::IO, ll::MyAbstractLinkedList)
    for data in ll
        print(data, " ")
    end
end

# Hur använda på bästa sätt? Går det att använda för findtail?
function iterate(
    ll::MyBasicLinkedList{T}, 
    node::Union{MyLinkedListNode{T}, Nothing} = ll.head
    ) where {T}

    node === nothing ? nothing : (node.data, node.next)
end

function pushfirst!(
    sll::Union{SinglyLinkedList{T}, ISinglyLinkedList{T}}, 
    item::T
    ) where {T} ## how to do if items...

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

function pushfirst!(
    dll::Union{DoublyLinkedList{T}, IDoublyLinkedList{T}}, 
    item::T
    ) where {T}

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

Removes the item from the beginning of the list
# Arguments
- `ll::MyAbstractLinkedList` : List of type SinglyLinkedList and DoublyLinkedList
"""
function popfirst!(ll::MyAbstractLinkedList{T}) where T
    ll.n == 0  &&  throw(ArgumentError("List is empty"))

    item = ll.head.data
    oldhead = ll.head
    ll.head = oldhead.next
    ll.n -= 1
    if ll.n == 0 
        ll.head = nothing
        if isa(ill, MyImprovedLinkedList) 
            ll.head = ll.tail = nothing
        end
    elseif isa(ll, DoublyLinkedList) || isa(ll, IDoublyLinkedList)
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

function push!(isll::ISinglyLinkedList{T}, item::T) where {T}
    if isempty(isll)
        isll.head = isll.tail = SingleNode{T}(item, nothing)
    else
        oldtail = isll.tail
        oldtail.next = SingleNode{T}(item, nothing)
    end
    isll.n += 1
    return isll
end

function push!(idll::IDoublyLinkedList{T}, item::T) where {T}
    if isempty(idll)
        idll.head = idll.tail = DoubleNode{T}(item, nothing, nothing)
    else
        oldtail = idll.tail
        newtail = DoubleNode{T}(item, oldtail, nothing)
        oldtail.next = newtail 
    end
    idll.n += 1
    return idll
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

function pop!(ill::MyImprovedLinkedList)
    ill.n == 0  &&  throw(ArgumentError("List is empty"))
    oldtail = ill.tail
    item = oldtail.data
    if isa(ill, IDoublyLinkedList)
        newtail = oldtail.previous
        newtail.next = nothing
    elseif isa(ill, ISinglyLinkedList)
        newtail = findnode_withnext(ill, oldtail)
        @assert newtail !== nothing
        newtail.next = nothing
    end
    ll.n -= 1
    if ill.n == 0 ill.head = nothing end
    return item
end

"""
    popat!(dll::DoublyLinkedList{T}, position::Int64)

Removes item at given position in the list. 
Returns data of item or throws an error if position exceeds length of list. 
"""
function popat!(
    dll::Union{DoublyLinkedList{T}, IDoublyLinkedList{T}},
    position::Int64
    ) where {T}

    dll.n == 0  &&  throw(ArgumentError("List is empty"))
    position <= dll.n ||
    throw(ArgumentError("Position $position exceed list length of $(dll.n)"))

    if position == 1
        return popfirst!(dll)
    elseif position == dll.n
        return pop!(dll)
    end

    node = dll.head
    counter = 1
    while counter < position 
        counter += 1
        if node.next !== nothing 
            node = node.next
        end 
    end

    previousnode = node.previous
    nextnode = node.next
    previousnode.next = nextnode
    nextnode.previous = previousnode
    # finish? Do test. Is the above correct? 

    dll.n -= 1
    if dll.n == 0 dll.head = nothing end
    return node.data
end

"""
    popat!(sll::SinglyLinkedList{T}, position::Int64)

Removes item at given position in the list. 
Returns data of item or throws an error if position exceeds length of list. 
"""
function popat!(
    sll::Union{SinglyLinkedList{T}, ISinglyLinkedList{T}}, 
    position::Int64
    ) where {T}

    sll.n == 0  &&  throw(ArgumentError("List is empty"))

    (position <= sll.n || 
    throw(ArgumentError(
        "Position $position exceed list length of $(sll.n)"
        ))
    )


    if position == 1
        return popfirst!(sll)
    elseif position == sll.n
        return pop!(sll)
    end

    node = sll.head
    counter = 1
    while counter < position 
        counter += 1
        if node.next !== nothing 
            node = node.next
        end 
    end

    previousnode = findnode_withnext(sll, node)
    nextnode = node.next
    previousnode.next = nextnode

    sll.n -= 1
    if sll.n == 0 sll.head = nothing end
    return node.data
end

"""
    removeitem!(ll::MyBasicLinkedList{T}, item::T)

Removes the first occurrence of item in given list. 
Returns data of item or `nothing` if no such item is found.
# TODO
- what if previous or next are nothings?
- test
"""
function removeitem!(ll::MyAbstractLinkedList{T}, item::T) where {T}
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    node = findfirst(ll, item)
    if isa(node, Nothing)
        return nothing
    elseif isa(ll, DoublyLinkedList) || isa(ll, IDoublyLinkedList)
        previousnode = node.previous
        nextnode = node.next
        previousnode.next = nextnode
        nextnode.previous = previousnode
        # finish? Do test. Is the above correct? 
    elseif isa(ll, SinglyLinkedList) || isa(ll, ISinglyLinkedList)
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

function findtail(ll::MyAbstractLinkedList{T}) where {T}
    # short-curcuit condition
    isempty(ll) && throw(BoundsError())

    node = ll.head
    while node.next !== nothing
        node = node.next
    end
    return node
end

# # TODO: tests
"""
    findnode_withnext(ll::MyAbstractLinkedList{T}, nextnode::MyLinkedListNode{T})

Finds the node in the given list that contains the given nextnode, returns node.
Returns nothing if no such node is found
"""
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
    findfirst(ll::MyAbstractLinkedList{T}, item::T)

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

# Benchmarking utils

# Bör göras om som en push! eller pushfirst!(list::SinglyLinkedList, iter...)
function sllistfromvector(v::Vector{T}) where {T}
    # short-circuit return conditions
    length(v) == 0 && return SinglyLinkedList{T}()

    newsll = SinglyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    i = length(v)
    while i > 0 
        pushfirst!(newsll, v[i])
        i -= 1
    end
    return newsll
end

# Bör göras om som en push! eller pushfirst!(list::DoublyLinkedList, iter...)
function dllistfromvector(v::Vector{T}) where {T}
    # short-circuit return conditions
    length(v) == 0 && return DoublyLinkedList{T}()

    newdll = DoublyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    i = length(v)
    while i > 0 
        pushfirst!(newdll, v[i])
        i -= 1
    end
    return newdll
end

function createrandom_sllist(size)
    v = Vector{Int64}(undef, size)
    rand!(v, 1:10*size)
    sll = sllistfromvector(v)
    return sll 
end

function createrandom_dllist(size)
    v = Vector{Int64}(undef, size)
    rand!(v, 1:10*size)
    dll = dllistfromvector(v) ## Har dessa previous?
    return dll 
end