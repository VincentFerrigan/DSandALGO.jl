# Zip_utils.jl
# Utils for Zip module in Zip.jl

isless(a::ZipNode{K}, b::ZipNode{K}) where {K} = a.code < b.code
isless(a::ZipNode{K}, key::K) where {K} = a.code < key
isless(key::K, b::ZipNode{K}) where {K} = key < b.code

isequal(a::ZipNode{K}, b::ZipNode{K}) where {K} = a.code == b.code
isequal(a::ZipNode{K}, key::K) where {K} = a.code == key
isequal(key::K, b::ZipNode{K}) where {K} = key == b.code

show(io::IO, z::ZipNode) = print(z.code, "  ", rstrip(z.name), " (", z.population, ") ")