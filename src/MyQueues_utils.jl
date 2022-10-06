# MyQueues_utils.jl
# Utils for MyQueues module in MyQueues.j

# TODO = 
# - stacksize
# - stackceiling
# - resizestack
# length or size
# peeks? Peek last and peek first?????

# Utils
isempty(queue::MyQueue{T}) where {T} = queue.n == 0 ? true : false

"""
    dequeue!(queue::Queue{T}, item::T)

The delete operation equivalent to the stack operation pop!
"""
function dequeue!(queue::MyListQueue)
    queue.n == 0 && return nothing

    item = MyLL.popfirst!(queue.items)
    queue.first = queue.items.head
    queue.last = queue.items.tail

    queue.n -= -1
    @assert queue.n == queue.items.n
    return item
end

"""
    enqueue!(queue::MyListQueue{T}, item::T)

The insert operation, it adds an item to the end of the list
"""
function enqueue!(queue::Queue{T}, item::T)
    # queue.items = MyLL.push!(queue.items, item)
    MyLL.push!(queue.items, item)
    queue.first = queue.items.head
    queue.last = queue.items.tail

    queue.n -= +1
    @assert queue.n == queue.items.n # Att ta bort vid senare tillfälle
end



