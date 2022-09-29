# MyStacks.jl
"""
	MyStacks

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
# Types
- StaticStack <: MyVectorStack <: MyStack
- DynamicStack <: MyVectorStack <: MyStack
- SinglyLLStack <: MyListStack <: MyStack
# Utils
- push!
- pop! # two separate (vector and list) #TODO:Merge
- peek # two separate (vector and list) #TODO:Merge
- stacksize
- stackceiling
- resizestack
"""
module MyStacks
include("MyLL.jl")
import .MyLL

import Base: pop!, push!, peek
export SinglyLLStack, StaticStack, DynamicStack, pop!, push!, peek, stacksize,
stackceiling, resizestack!

# types 
abstract type MyStack{T} end
abstract type MyVectorStack{T} <: MyStack{T} end
abstract type MyListStack{T} <: MyStack{T} end

mutable struct StaticStack{T} <: MyVectorStack{T}
	items::Vector{T}
	head::Int
	function StaticStack{T}(stackcapacity = 4) where {T}
		new(Vector{T}(undef, stackcapacity), 0) 
		# or fill the vector with 0 
	end
end

mutable struct DynamicStack{T} <: MyVectorStack{T}
	items::Vector{T}
	head::Int
	function DynamicStack{T}(stackcapacity = 4) where {T}
		new(Vector{T}(undef, stackcapacity), 0) 
		# or fill the vector with 0 
	end
end

mutable struct SinglyLLStack{T} <: MyListStack{T}
	items::MyLL.SinglyLinkedList{T}
	head::Int
	function SinglyLLStack{T}() where {T}
		new(MyLL.SinglyLinkedList{T}(), 0)
	end
end

# utils

"""
	push!(stack::MyVectorStack, item::Int)

Stack item

# Arguments
- `stack::MyStack{T}`
- `item::T`
"""
function push!(stack::MyStack{T}, item::T) where {T}
	if isa(stack, StaticStack{T}) && stack.head == stackceiling(stack)
		@show("Hold your horses, the stack is full")
		return
	elseif isa(stack, DynamicStack{T}) && stack.head == stackceiling(stack)
		resizestack!(stack, *(stackceiling(stack), 2))
	end

    stack.head += 1

	if isa(stack, StaticStack{T}) 
		stack.items[stack.head] = item
	elseif isa(stack, DynamicStack{T}) 
		stack.items[stack.head] = item
	elseif isa(stack, SinglyLLStack{T}) 
		MyLL.pushfirst!(stack.items, item)
	end

	stack
end

"""
pop!(stack::MyVectorStack)
returns and removes the item from the top of stack or nothing if stack is empty
"""
function pop!(stack::MyVectorStack{T}) where {T}

	if isa(stack, DynamicStack{T}) &&
		stack.head > 0 && 
		stack.head == ÷(stackceiling(stack), 4)
		resizestack!(stack, ÷(stackceiling(stack), 2))
	end

	if stack.head == 0 
		#show("You got nothing")
	else
		item = stack.items[stack.head]
		stack.head -= 1
		#show("popped item $item. The new head is now $(stack.head)")
		return item
	end
end

function pop!(stack::MyListStack{T}) where {T}
	if stack.head == 0
		return nothing
	else
		item = MyLL.popfirst!(stack.items)
		stack.head -= 1 # Behövs detta för mina lists? har ju length på dem redan. list.n
		return item
	end
end

"""
	peek(stack::MyVectorStack)
returns the item from the top of stack or nothing if stack is empty
"""
function peek(stack::MyVectorStack{T}) where {T}
	if stack.head == 0
		return nothing
	else
		item = stack.items[stack.head]
		#show("Peek a Boo, you got $item")
		return item
	end
end

function peek(stack::MyListStack{T}) where {T}
	if stack.head == 0
		return nothing
	else
		return MyLL.peekfirst(stack.items)
	end
end

"""
	stacksize(stack::MyStack)
returns the lenght of the stack a.k.a head or stack pointer
"""
function stacksize(stack::MyStack{T}) where {T}
	return stack.head
end

"""
	max(stack::MyStack)
returns the stack max. 
"""
function stackceiling(stack::MyVectorStack)
	return size(stack.items)[1]
end

function resizestack!(stack::DynamicStack{T}, newsize::Int) where {T}
	temp = Vector{T}(undef, newsize)
	for i in 1:stack.head
		temp[i] = stack.items[i]
	end
	stack.items = temp
	return
end

# function push!(stack::StaticStack, item::Int)

# 	if stack.head == stackceiling(stack)
# 		@show("Hold your horses, the stack is full")
#     else
#         stack.head += 1
# 		stack.items[stack.head] = item
# 		#show("pushed item $item. The new head is now $(stack.head)")
# 	end
# end

# function push!(stack::DynamicStack, item::Int)
# 	if stack.head == stackceiling(stack)
# 		resizestack!(stack, *(stackceiling(stack), 2))
#     else
#         stack.head += 1
# 		stack.items[stack.head] = item
# 		#show("pushed item $item. The new head is now $(stack.head)")
# 	end
# end

# function pop!(stack::StaticStack)
# 	if stack.head == 0
# 		#show("You got nothing")
# 	else
# 		item = stack.items[stack.head]
# 		stack.head -= 1
# 		#show("popped item $item. The new head is now $(stack.head)")
# 		return item
# 	end
# end

# function pop!(stack::DynamicStack)
# 	if stack.head > 0  &&  stack.head == div(stackceiling(stack), 4)
# 		resizestack!(stack, div(stackceiling(stack), 2))
# 	end

# 	if stack.head == 0
# 		#show("You got nothing")
# 	else
# 		item = stack.items[stack.head]
# 		stack.head -= 1
# 		#show("popped item $item. The new head is now $(stack.head)")
# 		return item
# 	end
# end

end # module