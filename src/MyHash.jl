# MyHash.jl
"""
    MyHash

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-18
Notes:

# TODO: 
* add Linear probing
* test linear probing
* Do Benchmarks in acc with hash.pdf 
    note: Created a draft bench jlfile in folder ../benchmarks/. Continue there
    purpose: Can be performed in repl instead of notebook
* IMRaD

Contains:
# Types
* Buckets
* Node

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
* get
* insert!

## functions and methods
* hashingByDivision
"""

module MyHash

import Base: isempty, isequal, size
import Base: pushfirst!, insert!, get

include("MyHash_types.jl")
include("MyHash_utils.jl")

export Buckets # Constructors
export Node # Node constructor (for unit testing)
export insert!, get # base overload method

end # module