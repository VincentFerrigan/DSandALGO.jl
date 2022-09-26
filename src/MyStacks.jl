# MyStacks.jl
module MyStacks
include("MyLL.jl")
import .MyLL

export ListStack, StaticStack, DynamicStack, pop!, push!, peek, stacksize,
stackceiling, resizestack!

# types 
abstract type MyStack end
abstract type MyVectorStack <: MyStack end
abstract type MyListStack <: MyStack end

mutable struct StaticStack <: MyVectorStack
	items::Vector{Int}
	head::Int
	function StaticStack(stackcapacity = 4)
		new(Vector{Int}(undef, stackcapacity), 0)
		# or fill the vector with 0 
	end
end

mutable struct DynamicStack <: MyVectorStack
	items::Vector{Int}
	head::Int
	function DynamicStack(stackcapacity = 4)
		new(Vector{Int}(undef, stackcapacity), 0)
		# or fill the vector with 0 
	end
end

mutable struct SinglyLLStack <: MyListStack
	items::MyLL.SinglyLinkedList
	head::Int
	function SinglyLLStack()
		new(MyLL.SinglyLinkedList(), 0)
	end
end

# utils

"""
push!(stack::MyVectorStack, item::Int)
stack item
"""
function push!(stack::MyVectorStack, item::Int)
	if stack.head == stackceiling(stack) && isa(stack, StaticStack)
		@show("Hold your horses, the stack is full")
		return
	elseif stack.head == stackceiling(stack) && isa(stack, DynamicStack)
		resizestack!(stack, *(stackceiling(stack), 2))
	end
    stack.head += 1
	stack.items[stack.head] = item
	#show("pushed item $item. The new head is now $(stack.head)")
	stack
end


function push!(stack::MyListStack, item::Int)
	stack.head += 1
	MyLL.pushfirst!(stack.items, item)
end


"""
pop!(stack::MyVectorStack)
returns and removes the item from the top of stack
"""
function pop!(stack::MyVectorStack)
	if isa(stack, DynamicStack) &&
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

function pop!(stack::MyListStack)
	if stack.head == 0
		#show("You got nothing")
	else
		item = MyLL.popfirst!(stack.items)
		stack.head -= 1 # Behövs detta för mina lists? har ju length på dem redan. list.n
		return item
	end
end

"""
peek(stack::MyVectorStack)
returns the item from the top of stack
"""
function peek(stack::MyVectorStack)
	if stack.head == 0
		#show("Nothing to see here")
	else
		item = stack.items[stack.head]
		#show("Peek a Boo, you got $item")
		return item
	end
end

function peek(stack::MyListStack)
	if stack.head == 0
		#show("Nothing to see here")
	else
		return MyLL.peek(stack.items)
	end
end

"""
stacksize(stack::MyStack)
returns the lenght of the stack a.k.a head or stack pointer
"""
function stacksize(stack::MyStack)
	return stack.head
end

"""
max(stack::MyStack)
returns the stack max. 
"""
function stackceiling(stack::MyVectorStack)
	return size(stack.items)[1]
end

function resizestack!(stack::DynamicStack, newsize::Int)
	temp = Vector{Int}(undef, newsize)
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