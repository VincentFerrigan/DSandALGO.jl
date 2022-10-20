# MyTires_types.jl
# Types for MyTires module in MyTires.jl

mutable struct WordNode
    key::String
    next::Union{WordNode, Nothing}
end

mutable struct TrieNode
    words::Union{WordNode, Nothing} # list of words or a collection of words?
    next::Vector{Union{Nothing, TrieNode}}

    TrieNode() = new(nothing, Vector{Union{Nothing, TrieNode}}(nothing, 9))
end

mutable struct Trie
    root::Union{TrieNode, Nothing}
    Trie() = new(TrieNode())
end
