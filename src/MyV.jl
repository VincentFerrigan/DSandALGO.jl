# MyV.jl
"""
    MyV

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
- appendvectors!
"""
module MyV

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

end # module