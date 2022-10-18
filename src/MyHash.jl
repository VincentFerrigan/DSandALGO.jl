# MyHash.jl
"""
    MyHash

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-18
Notes:

# TODO: 
* test Buckets in accordance with hash.pdf
* add Linear probing
* Benchmarks
* IMRaD

Contains:
# Types
* 
# Utils
## Base overload utils
* isempty 
* isequal - three methods 
* size

## Short utils and wrappers
* m
* hasing - wrapper

## Base overload methods
* pushfirst!

## functions and methods
* hashingByDivision
* add!
"""

module MyHash

import Base: isempty, isequal, size
import Base: pushfirst!

include("MyHash_types.jl")
include("MyHash_utils.jl")

export Buckets # Constructors
export add!

end # module