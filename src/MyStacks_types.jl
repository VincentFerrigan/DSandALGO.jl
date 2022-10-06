
# MyStacks_types.jl
# Types for MyStacks module in MyStacks.jl

# Types
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
