# Zip.jl
"""
    Zip

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-17
Notes: Works with SearchingAlgo (linear_search and binary_search, see
runHashTests.jl). 

# Todo:
* see MyHash.jl

Contains:
# Types
* Zip ??
* ZipNode
# Utils
## Base overload utils
* isless - 3 methods
* isequal - 3 methods
* show
"""

module Zip

import Base: isless, isequal, show

include("Zip_types.jl")
include("Zip_utils.jl")

export ZipNode # Constructor (Zip node)
export isless, isequal, show # base overload for unittesting

end # Module