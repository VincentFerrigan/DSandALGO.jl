# MyTires_utils.jl
# Utils for MyTires module in MyTires.jl

isequal(a::WordNode, b::String) = isequal(a.key, b)
isequal(a::String, b::WordNode) = isequal(a, b.key)

iterate(node::WordNode, ::Nothing) = nothing
function iterate(node::WordNode, state::WordNode = node)
    state, state.next
end

show(io::IO, node::WordNode) = print(node.key)
get(trie::Trie, key::String) = get(trie.root, key, 1)
add!(trie::Trie, key::String) = add!(trie.root, key, 1)

function get(node::Union{Nothing, TrieNode}, key::String, d)
    isa(node, Nothing) && return Nothing
    isless(sizeof(key), d) && return node.words

    token = key[d]
    if isdigit(token)
        get(node.next[Int(token - '0')], key, d+1)
    else
        h_value = mapchar2int(key[d])
        if h_value == 9 d += 1 end
        get(node.next[h_value], key, d+1)
    end
end

function pushfirst!(
    node::Union{Nothing, WordNode},
    key::String)
    return WordNode(key, node)
end

function add!(node::Union{Nothing, TrieNode}, key::String, d)
    isa(node, Nothing) && (node = TrieNode())
    if isless(sizeof(key), d)
        node.words = pushfirst!(node.words, key)
    else
        h_value = mapchar2int(key[d])
        # this is just for debugging
        (isa(h_value, Nothing) && throw(
            ArgumentError("Key word: ", key, "includes: ", key[d])))
        
            if h_value == 9 d += 1 end
        if isa(node.next[h_value], Nothing)
            node.next[h_value] = add!(node.next[h_value], key, d+1)
        else
            add!(node.next[h_value], key, d+1)
        end
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
    # NOTE THIS
    println("WTF, what is this: ", c)
    return nothing 
end