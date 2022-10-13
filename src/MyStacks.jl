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

## TODO: 
- restructure into _types and _utils
"""
module MyStacks
include("MyLL.jl")
import .MyLL

import Base: pop!, push!, peek, isempty

include("MyStacks_types.jl") # includes types
include("MyStacks_utils.jl") # includes all functions 

export SinglyLLStack, StaticStack, DynamicStack, pop!, push!, peek, stacksize
export stackceiling, resizestack!, isempty

end # module