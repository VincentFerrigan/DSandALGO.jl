# MyV.jl
"""
    MyV

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
- appendvectors!
- createrandomvector
"""
module MyV
using Random

export appendvectors!, createrandomvector

function appendvectors!(firstvector, secondvector)

    newsize = length(firstvector) + length(secondvector)
    newvector = Vector{Int}(undef, newsize) 

    for i = 1:length(newvector)
        for item in firstvector
            newvector[i] = item
        end
        for item in secondvector
            newvector[i] = item
        end
    end
    firstvector = newvector
    return firstvector
end 

"""
    createrandomvector(k, n)

Creates a vector of size `k`, with random values from 1 to `n`
"""
function createrandomvector(k, n)
    v = Vector{Int64}(undef, k)
    rand!(v, 1:n)
    v
end



end # module