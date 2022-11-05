# MyLL_utils.jl
# Utils for MyLL module in MyLL.jl

# Utils
function isless(a::MyAbstractNode, b::MyAbstractNode) 
    isless(a.data, b.data)
end
function isequal(a::MyAbstractNode, b::MyAbstractNode) 
    isequal(a.data, b.data)
end

length(ll::MyAbstractLinkedList{T}) where {T} = ll.n

function isempty(ll::MyAbstractLinkedList{T}) where {T} 
    ll.head === nothing ? true : false
end

# # TODO
# # Krockade en del. Vet inte riktigt varför
function show(io::IO, ll::MyAbstractLinkedList)
    print("(")
    for node in ll
        print(node.data, " ")
    end
    print(")")
end

function show(io::IO, node::MyAbstractNode{T}) where {T}
    print(" Type: ", typeof(node), " Data: ", node.data)
end

# Hur använda på bästa sätt? Går det att använda för findtail?
function iterate(
    ll::MyAbstractLinkedList{T}, 
    node::Union{MyLinkedListNode{T}, Nothing} = ll.head
    ) where {T}

    node === nothing ? nothing : (node, node.next)
end

function pushfirst!(
    sll::Union{SinglyLinkedList{T}, ISinglyLinkedList{T}}, 
    node::SingleNode{T}
    ) where {T} 

    if isempty(sll)
        sll.head = node
        sll isa ISinglyLinkedList && (sll.tail = node)
    else
        oldhead = sll.head
        node.next = oldhead
        sll.head = node
    end
    sll.n += 1
    return sll
end

function pushfirst!(
    dll::Union{DoublyLinkedList{T}, IDoublyLinkedList{T}}, 
    node::DoubleNode{T}
    ) where {T}

    node.previous = nothing # just in case
    if isempty(dll)
        dll.head = node
        dll isa IDoublyLinkedList && (dll.tail = node)
    else
        oldhead = dll.head
        node.next = oldhead
        oldhead.previous = node
        dll.head = node
    end
    dll.n += 1
    return dll
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
        newtail = SingleNode{T}(item, nothing)
        oldtail.next = newtail
        isll.tail = newtail

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

"""
    remove!(
        sll::Union{SinglyLinkedList{T}, ISinglyLinkedList{T}}, 
        node::SingleNode{T}
        ) where {T}

Removes links, i.e. references, to the given node from previous node
and to next node from given node. 
Linkes previous node to the next.
Returns xxxxxx or throws an error if xxxx. 
"""
function remove!(
    sll::Union{SinglyLinkedList{T}, ISinglyLinkedList{T}}, 
    node::SingleNode{T}
    ) where {T}

    previousnode = findnode_withnext(sll, node)
    nextnode = node.next
    (previousnode isa Nothing  # link prev with next
    || (previousnode.next = nextnode))
    (sll.head == node          # update head if nec
      && (sll.head = nextnode))
    (sll isa ISinglyLinkedList # update tail link if nec
      && sll.tail == node
      && (sll.tail = previousnode))
    node.next = nothing        # nullify removed node
    sll.n -=1                  # update list count
end

"""
    remove!(
        dll::Union{DoublyLinkedList{T}, IDoublyLinkedList{T}}, 
        node::SingleNode{T}
        ) where {T}

Removes links, i.e. references, to the given node from previous node
and to next node from given node. 
Linkes previous node to the next.
Returns xxxxxx or throws an error if xxxx. 
"""
function remove!(
    dll::Union{DoublyLinkedList{T}, IDoublyLinkedList{T}}, 
    node::DoubleNode{T}
    ) where {T}

    previousnode = node.previous # could be nothing
    nextnode = node.next         # could be nothing
    (nextnode isa Nothing        # link next with prev
      || (nextnode.previous = previousnode))
    (previousnode isa Nothing    # link prev with next
      || (previousnode.next = nextnode))
    (dll.head == node            # update head if nec
      && (dll.head = nextnode))
    (dll isa IDoublyLinkedList   # update tail link if nec
      && dll.node == node
      && (dll.tail = previousnode))
    node.next = nothing          # nullify removed node
    node.previous = nothing
    dll.n -=1                    # update list count
end

"""
    popfirst!(ll:MyAbstractLinkedList)

Removes the item from the beginning of the list
# Arguments
- `ll::MyAbstractLinkedList` : List of type SinglyLinkedList and DoublyLinkedList
"""
function popfirst!(ll::MyAbstractLinkedList{T}) where T
    ll.n == 0  &&  throw(ArgumentError("List is empty"))

    data = ll.head.data
    node = ll.head
    remove!(ll, node)
    return data
end

function pop!(ll::MyAbstractLinkedList{T}) where {T}
    ll.n == 0  &&  throw(ArgumentError("List is empty"))
    oldtail = findtail(ll)
    remove!(ll, oldtail)

    return oldtail.data
end

"""
    popat!(ll::MyAbstractLinkedList{T}, position::Int64)
    # popat!(sll::SinglyLinkedList{T}, position::Int64)

Removes item at given position in the list. 
Returns data of item or throws an error if position exceeds length of list. 
"""
function popat!(
    ll::MyAbstractLinkedList,
    position::Int64
    ) where {T}

    ll.n == 0 && throw(ArgumentError("List is empty"))

    (position <= ll.n || 
    throw(ArgumentError(
        "Position $position exceed list length of $(sll.n)"
        ))
    )

    if position == 1
        return popfirst!(ll)
    elseif position == ll.n
        return pop!(ll)
    end

    node = ll.head
    counter = 1
    while counter < position 
        counter += 1
        node.next isa Nothing || (node = node.next)
    end
    remove!(ll, node)
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
    else
        remove!(ll, node)
    end
    @assert node.data == item
    return node.data
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

"""
    findnode_withnext(
        ll::MyAbstractLinkedList{T}, 
        nextnode::MyLinkedListNode{T}
        ) where {T}

Finds the node in the given list that contains the given nextnode, returns node.
Returns nothing if no such node is found
"""
function findnode_withnext(
    ll::MyAbstractLinkedList{T}, 
    nextnode::MyLinkedListNode{T}
    ) where {T}
    # short-curcuit (error and return) conditions
    isempty(ll) && throw(BoundsError()) 
    nextnode == ll.head && return nothing

    # find next
    node = ll.head 
    while node.next !== nextnode
        (node.next isa Nothing ? 
          (return nothing) : (node = node.next))
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
# Bör göras om som en push! eller pushfirst!(list::DoublyLinkedList, iter...)
function idllistfromvector(v::Vector{T}) where {T}
    # short-circuit return conditions
    length(v) == 0 && return IDoublyLinkedList{T}()

    newidll = IDoublyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    i = length(v)
    while i > 0 
        push!(newidll, v[i])
        i -= 1
    end
    return newidll
end 

# Bör göras om som en push! eller pushfirst!(list::SinglyLinkedList, iter...)
function isllistfromvector(v::Vector{T}) where {T}
    # short-circuit return conditions
    length(v) == 0 && return ISinglyLinkedList{T}()

    newisll = ISinglyLinkedList{T}()
    
    # Bör finnas ett bättre sätt. Typ mha av iterate grejen
    for i = 1:length(v)
        push!(newisll, v[i])
    end
    return newisll
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

"""
    findminimum(list::MyAbstractLinkedList{T})::node
    Returns the minimum item in an unordered list
"""
function findminimum(list::MyAbstractLinkedList{T}) where {T}
    list.n == 0 && throw(ArgumentError("List is empty"))

    min = list.head
    for node ∈ list
        if isless(node, min) 
            min = node
        end
    end
    return min
end

"""
    removeminimum!(list::MyAbstractLinkedList{T})::node
    Returns and removes the minimum item in an unordered list
"""

function removeminimum!(list::MyAbstractLinkedList{T}) where {T}
    list.n == 0 && throw(ArgumentError("List is empty"))
    min = findminimum(list)
    remove!(list, min)
    return min
end

"""
    inserts item in a list in descending order.
    note: Ska kolla om node isless och node next isless
"""
function insert_desc_list!(list::MyAbstractLinkedList{T}, item::T) where {T}
    isa(list, DoublyLinkedList) || throw(ArgumentError("For now, only for DLL"))
    isempty(list) && (return pushfirst!(list, item))
    isless(item, peekfirst(list)) && (return pushfirst!(list, item))

    for node ∈ list
        if isless(node.data, item) && (isa(node.next, Nothing) || isless(item, node.next.data))
            previousnode = node
            nextnode = node.next
            newnode = DoubleNode{T}(item, previousnode, nextnode)
            previousnode.next = newnode
            isa(nextnode, Nothing) || (nextnode.previous = newnode)
            list.n +=1
        end
    end
end