# MyGraph.jl
"""
    MyGraph

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-28
Notes:

# TODO:
* lookup or similar 
* BFS
* DFS
* iterate
* pretty printing (show)
* Dijkstra's algorithm

# Open Issues
* Positive infinity is a floating value in Julia, `Inf`. 
  Should I use it in my data structure for shortest paths?
  Does that mean that weight also have to be of type float?

Contains:
# Types
* Edge
* Graph # will have to rename it to UndirWeightedGraph :> Graph
* 

# Utils
## Base overload utils/methods
* isequal
* isless
* add!

## Functions/Methods
* either
* other
* weight

"""
module MyGraph

import Base: isequal, isless 

include("MyLL.jl")
include("MyHash.jl")
using .MyLL                         # or should I not?
using .MyHash                       # or should I import instead?

include("MyGraph_types.jl")
include("MyGraph_utils.jl")

# for export
export Edge, Graph # constructors
export add! # methods

# For unittesting
# export # constructors
# export 
end # module