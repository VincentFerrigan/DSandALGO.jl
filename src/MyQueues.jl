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
- length
- isempty
- queuecapacity
- enqueue! Two mehtods
- dequeue! Two mehtods
- resizequeue!
"""

module MyQueues
include("MyLL.jl")
import .MyLL

import Base: isempty, length 

include("MyQueues_types.jl") # includes types
include("MyQueues_utils.jl") # includes all functions 

export SLQueue, DynamicQueue, dequeue!, enqueue!, isempty

end # Module


