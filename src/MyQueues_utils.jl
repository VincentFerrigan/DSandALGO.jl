# MyQueues_utils.jl
# Utils for MyQueues module in MyQueues.j

# TODO = 
# - stacksize
# - stackceiling
# - resizestack
# length or size
# peeks? Peek last and peek first?????

# Utils
length(q::MyQueue{T}) where {T} = return q.n
isempty(q::MyQueue{T}) where {T} = q.n == 0 ? true : false
# isempty(q::MyVectorQueue{T}) where {T} = q.first == q.last ? true : false
queuecapacity(q::MyVectorQueue) where {T} = return size(q.items)[1] # only for vector based

# For vector queues
## Initaially the first == last == 1
## q is empty when first == last and n = 0 i.e. nbr of slots taken
## q is full when first == last + 1 or (first == 1 and last == queuecapacity) or when n == queuecapacity
### issue: HOW TO RESIZE? HOW TO TEST PRECONDITIONS
## 

"""
    enqueue!(queue::MyListQueue{T}, item::T)

The insert operation, it adds an item to the end of the list
"""
function enqueue!(queue::SLQueue{T}, item::T) where {T}
    MyLL.push!(queue.items, item)
    queue.first = queue.items.head
    queue.last = queue.items.tail

    queue.n += 1
    @assert queue.n == MyLL.length(queue.items)
    # what should get returned???
end


# For vector queues
## Initaially the first == last == 1
## q is empty when first == last == 1
## q is full when first == last + 1 or (first == 1 and last == size)
## 
function enqueue!(queue::DynamicQueue{T}, item::T) where {T}
    if length(queue) == queuecapacity(queue) 
        resizequeue!(queue, *(queuecapacity(queue), 2))
    end

    queue.items[queue.last] = item
    if queue.last == queuecapacity(queue)
        queue.last = 1
    else
        queue.last += 1
    end
    queue.n += 1
end

"""
    dequeue!(queue::Queue{T}, item::T)

The delete operation equivalent to the stack operation pop!
"""
function dequeue!(queue::SLQueue) where {T}
    queue.n == 0 && return nothing

    item = MyLL.popfirst!(queue.items)
    queue.first = queue.items.head
    queue.last = queue.items.tail

    queue.n -= 1
    @assert queue.n == MyLL.length(queue.items)
    return item
end

function dequeue!(queue::DynamicQueue{T}) where {T}
    if (length(queue) > 0 && 
        length(queue) == ÷(queuecapacity(queue), 4)
        )
        resizequeue!(queue, ÷(queuecapacity(queue), 2))
    end

    item = queue.items[queue.first] 
    queue.items[queue.first] = nothing
    if queue.first == queuecapacity(queue)
        queue.first = 1
    else
        queue.first += 1
    end
    queue.n -= 1
    return item
end

# For vector queues
## Initaially the first == last == 1
## q is empty when first == last and n = 0 i.e. nbr of slots taken
## q is full when first == last + 1 or (first == 1 and last == queuecapacity) or
## when n == queuecapacity
## Mod is done through mod1 since julia uses 1 based indexing
function resizequeue!(queue::DynamicQueue{T}, newsize::Int) where {T}
	temp = Array{Union{Nothing, T}}(nothing, newsize)

    for i = 1:length(queue)
        pos = mod1((queue.first + i - 1), queuecapacity(queue))
        temp[i] = queue.items[pos]
    end

	queue.items = temp
    queue.first = 1
    queue.last = queue.first + queue.n
	return
end