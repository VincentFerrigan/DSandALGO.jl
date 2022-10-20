# MyTires_utils.jl
# Utils for MyTires module in MyTires.jl

isequal(a::WordNode, b::String) = isequal(a.key, b)
isequal(a::String, b::WordNode) = isequal(a, b.key)
    
function get(trie::Trie, key::String)
    println("first get")
    get(trie.root, key, 1)
end

function get(node::Union{Nothing, TrieNode}, key::String, d)
    isa(node, Nothing) && return Nothing
    if isequal(d, sizeof(key))
        println("last get ") # borde TrieNode ha en nyckel?
        return node.words
    else
        h_value = mapchar2int(key[d])
        if h_value == 9 d += 1 end
        println("middle get: ", h_value)
        get(node.next[h_value], key, d+1)
    end
end

function get(trie::Trie, key::Int)
    # do something
end

function get(node::Union{Nothing, TrieNode}, key::Int, d)
    # do something
end

function pushfirst!(
    node::Union{Nothing, WordNode},
    key::String)
    return WordNode(key, node)
end


function add!(trie::Trie, key::String)
    println("first add")
    add!(trie.root, key, 1)
end

function add!(node::Union{Nothing, TrieNode}, key::String, d)
    isa(node, Nothing) && (node = TrieNode()) #tror jag?
    if isequal(d, sizeof(key))
        println("last add")
        node.words = pushfirst!(node.words, key)
    else
        println("middle add: ", key[d])
        h_value = mapchar2int(key[d])
        if h_value == 9 d += 1 end
        node.next[h_value] = add!(node.next[h_value], key, d+1)
    end
    return node
end


function mapchar2int(c::Char)
    (isequal(c, 'a') || isequal(c, 'b') || isequal(c, 'c')) && return 1
    (isequal(c, 'd') || isequal(c, 'e') || isequal(c, 'f')) && return 2
    (isequal(c, 'g') || isequal(c, 'h') || isequal(c, 'i')) && return 3
    (isequal(c, 'j') || isequal(c, 'k') || isequal(c, 'l')) && return 4
    (isequal(c, 'm') || isequal(c, 'n') || isequal(c, 'o')) && return 5
    (isequal(c, 'p') || isequal(c, 'r') || isequal(c, 's')) && return 6
    (isequal(c, 't') || isequal(c, 'u') || isequal(c, 'v')) && return 7
    (isequal(c, 'x') || isequal(c, 'y') || isequal(c, 'z')) && return 8
    (isequal(c, 'å') || isequal(c, 'ä') || isequal(c, 'ö')) && return 9
    return nothing
end