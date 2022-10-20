# MyHash.jl
"""
    MyHash

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-18
Notes:

# TODO: 
* Do Benchmarks in acc with hash.pdf 
    note: Created a draft bench jlfile in folder ../benchmarks/. Continue there
    purpose: Can be performed in repl instead of notebook
* test the search attemts. Compare the two collision resolution types
* Do linearprobing without resizing!!!!!! It has to give warning instead of resizeing I guess
ISSUE: Vad händer ifall den kommer till sista index? Börjar den då om?
* IMRaD

Contains:
# Types
* Buckets :> HashTable
* DynamicLinearProbHT :> LinearProbHashTable :> HashTable
* StaticLinearProbHT :> LinearProbHashTable :> HashTable # TODO. Its the one without resize
* Node
* Datum

# Utils
## Base overload utils
* isempty 
* isequal - three methods 
* size

## Short utils and wrappers
* m - two methods
* hashing - wrapper
* hashingByDivision

## Base overload methods
* get - two methods
* pushfirst!
* insert! - two methods

## functions and methods
* resize!
* search - two methods

## For testing and data
* searchattempts - two methods
* getcollisiondata
"""

module MyHash

import Base: isempty, isequal, size
import Base: pushfirst!, insert!, get

include("MyHash_types.jl")
include("MyHash_utils.jl")

export ClosedAddressingHT, DynamicOpenAddressingHT, StaticOpenAddressingHT # Constructors
export Node, Datum # Node constructor (for unit testing)
export insert!, get # base overload method
export searchattempts, getcollisiondata, hashing # for testing and benchmark data

end # module