# Zip_types.jl
# Types for Zip module in Zip.jl

struct ZipNode{K}
    code::K
    name
    population
end