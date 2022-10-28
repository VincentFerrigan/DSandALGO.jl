# MyGraph.jl
"""
    MyGraph

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-18
Notes:

# TODO:
* ...

Contains:
# Types
* 
* 

# Utils
## Base overload utils/methods
* 

## Functions/Methods
* 
* 

"""
module MyGraph

import Base: isequal, isless 

include("MyLL.jl")
include("MyHash.jl")
using .MyLL                         # or should i not?
using .MyHash                       # or should I import?

include("MyGraph_types.jl")
include("MyGraph_utils.jl")

# for export
export Edge, Graph # constructors
export add! # methods

# For unittesting
# export # constructors
# export 
end # module