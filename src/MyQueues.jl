# MyQueues.jl
"""
	MyQueues

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-06
Notes:

Contains:
# Types
- SLQueue <: MyListQueue <: MyQueue
- DynamicQueue <: MyVectorQueue <: MyQueue
# Utils
- isempty
- dequeue! (only one method: MyListQueue)
- enqueue! (currently only one method for MyListQueue)

## TODO: 
- dequeue for MyVectorQueue
- enqueue for MyVectorQueue
- stacksize
- stackceiling
- resizestack
- length or size
- peeks? Peek last and peek first?????
"""

module MyQueues
include("MyLL.jl")
import .MyLL

import Base: isempty, size, length # size or length or both????

include("MyQueues_types.jl") # includes types
include("MyQueues_utils.jl") # includes all functions 

export SLQueue, DynamicQueue,
dequeue!, enqueue!, isempty

end # Module


