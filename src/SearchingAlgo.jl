
# SearchingAlgo.jl
"""
    SearchingAlgo.jl


Author: Vincent Ferrigan, <ferrigan@kth.se>
Date: 2022-10-03
Notes: Searching algorithms for vectors

Contains:
- findintersection
- linear_search
- binary_search
- findintersection_optimized
"""

module SearchingAlgo

function find_intersection(firstlist::Vector{T}, 
    secondlist::Vector{T}, search_function::Function) where {T}
    
    intersectionlist = Vector{Number}(undef, 0)

    for key in firstlist
        if search_function(secondlist, key) !== nothing
            push!(intersection, key)  
        end
    end
    return intersectionlist
end

function linear_search(
    vector::Vector{T}, 
    key; 
    first = 1, 
    last = size(vector)[1]
    ) where {T}

    for i in first:last
        if isequal(vector[i], key)
            return i
        end
    end
    return nothing
end
    
function binary_search(
    vector::Vector{T}, 
    value; 
    left = 1, 
    right = size(vector)[1]
    ) where {T} 
    
    while left <= right
        median = Int(floor((left+right)/2))
        if isequal(vector[median], value)
        # if vector[median] == value
            return median 
        elseif vector[median] > value
            right =  median - 1
        else
            left = median + 1
        end
    end
    return nothing
end

function find_intersection_optimized(firstlist::Vector{T}, 
    secondlist::Vector{T}) where {T}
    
    intersectionlist = Vector{Number}(undef, 0)
    i = 1
    j = 1

    while i <= size(firstlist)[1]  &&  j <= size(secondlist)[1]
        if firstlist[i] < secondlist[j]
            i += 1
        elseif firstlist[i] > secondlist[j]
            j += 1
        else
            push!(intersectionlist, firstlist[i])
            i += 1
            j += 1
        end
    end
    return intersectionlist
end
end # module