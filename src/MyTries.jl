# MyTries.jl
"""
    MyTries

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-18
Notes:

# TODO:
* Iterators for TrieNode.words and/or WordNode
* PrettyPrinting for TrieNode.words and/or WordNode
* Add entire "ordlist" from KTH

Contains:
# Types
WordNode
TrieNode
Trie

# Utils
## Base overload utils/methods
* isequal - 2 methods
* get - 4 methods (outer, inner) --- not done for int search yet. Use div and modulo I guess
* pushfirst!

## Functions/Methods
* add! 2 methods (outer, inner)
* mapchar2int

"""
module MyTries

import Base: pushfirst!, get, isequal, iterate, show

include("MyTries_types.jl")
include("MyTries_utils.jl")

# for export
export Trie # constructors
export add!, insert!, get, show, iterate # methods

# For unittesting
export TrieNode, WordNode # constructors
export mapchar2int, isequal 
end # module