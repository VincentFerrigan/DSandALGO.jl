# SortingAlgo.jl
"""
    SortingAlgo


Author: Vincent Ferrigan, <ferrigan@kth.se>
Date: 2022-10-12
Notes: Sorting algorithms for vectors

Contains:
- sectionsort!
- insertionsort!
- mergesort!
- merge!
"""
#=
ID1021Algorithm.jl
- Julia version: 1.8.0
- Author: Vincent Ferrigan <ferrigan@kth.se>
- Course: Algorithms and data structures ID1021
- Assignment: Sorting an array 
- Date: 2022-09-16
- Version: 0.2
=#

module SortingAlgo

using Random

include("MyLL.jl")
import .MyLL: ISinglyLinkedList, SingleNode, isllistfromvector

export selectionsort!, insertionsort!, mergesort!
export quicksort!, randomized_quicksort!, quicksortLIST!, isllistfromvector

# utils

# By section sort I assume the instructor means selection sort

""" 
    sectionsort!(v::Vector)

Sorts a vector with the section sort algorithm;
Repeatedly searches remaining items to find the smallest element and moves it to
the correct location

# Arguments
- v:Vector
""" 
function sectionsort!(v::Vector)
    N = length(v)

    # short-circuit pre-conditionals.
    N > 1 || throw(ArgumentError("Vector $v has less than 2 elements"))

    # swap v[i] with the smallest item in v[i+1:N]
    for i = 1:(N - 1)
        # search for the index of the smallest element in v[i+1:N]
        min_index = i
        for j = (i + 1):N
            if v[j] < v[min_index]  min_index = j end
        end
        # swap the elements if their indices differ
        if min_index != i  
            v[i], v[min_index] = v[min_index], v[i] 
        end
    end
end

"""
    insertionsort!(v::Vector)
    Insertion sorts the vector v
    i.e. transfers one element at a time to the partially sorted vector
"""

function insertionsort!(v::Vector)
    N = length(v)

    # short-circuit pre-conditionals.
    N > 1 || throw(ArgumentError("Vector $v has less than 2 elements"))
    # or short-circuit return condition
    # length(v) < 2 && return

    for i = 2:N
        j = i
        while j > 1  &&  v[j] < v[j - 1]
            v[j], v[j - 1] = v[j - 1], v[j]
            j -= 1
        end
    end
end

function mergesort!(v::Vector, bottom = 1, top = length(v)) 
    # short-circuit return condition
    top <= bottom  &&  return

    middle = ÷(bottom + top, 2)
    mergesort!(v, bottom, middle)  # Sort bottom half
    mergesort!(v, middle + 1, top) # Sort top half
    merge!(v, bottom, middle, top) # Merge results
end

function merge!(v::Vector, bottom, middle, top)
    i = bottom          # bottom index
    j = middle + 1      # top index

    # Copy vector v to a temperary one
    tempv = Vector(undef, top)
    for k = bottom:top
         tempv[k] = v[k]
    end

    for k = bottom:top
        if i > middle               # if the bottom vector is done
            v[k] = tempv[j]
            j += 1
        elseif j > top              # if the top vector is done
            v[k] = tempv[i]
            i += 1

        # Sort by putting the smallest element in place
        elseif tempv[j] < tempv[i]  # pick the top if its smaller 
            v[k] = tempv[j]
            j += 1
        else
            v[k] = tempv[i]         # else pick the bottom if its smaller
            i += 1
        end
    end
end

"""
    quicksort(v::Vector, p, r)

## Divide:
by partitioning v[p:r] into two subarrays 
* v[p:q-1] (low side) and
* v[q + 1:r] (high side)
Compute the index q of the pivot
## Concquer
by calling quicksort recursively to sort each of the subarrays
"""
function quicksort!(v::Vector, p=1, r=length(v))
    if p < r
        q = partition!(v, p, r)    
        quicksort!(v, p, (q - 1))
        quicksort!(v, (q + 1), r)
    end
end

"""
    partition(v::Vector, p, r)

"""
function partition!(v::Vector, p, r)
    pivot = v[r]    # the pivot
    i = p - 1   # highest index into the low side
    for j = p:r-1
        if v[j] <= pivot
            i += 1
            v[i], v[j] = v[j], v[i] # swap
        end
    end
    v[i + 1], v[r] = v[r], v[i + 1] # swaps pivot so that it lies between the two sides of the partition 
    return i + 1
end

function quicksort!(list::ISinglyLinkedList)
    quicksort!(list.head, list.tail)
end

function quicksort!(p::SingleNode, r::SingleNode)
    p == r && return 
    q = partition!(p, r)
    !isa(q, Nothing) && !isa(q.next, Nothing) && quicksort!(q.next, r)
    !isa(q, Nothing) && p != q && quicksort!(p, q)
end

function partition!(p::SingleNode, r::SingleNode)
    pivot = p
    front = p
    while !isa(front, Nothing) && front != r
        if front.data < r.data
            pivot = p
            p.data, front.data = front.data, p.data
            p = p.next
        end
        front = front.next
    end
    p.data, r.data = r.data, p.data
    return pivot
end

function randomized_quicksort!(v::Vector, p=1, r=length(v))
    if p < r
        q = randomized_partition!(v, p, r)    
        randomized_quicksort!(v, p, (q-1))
        randomized_quicksort!(v, (q + 1), r)
    end
end

function randomized_partition!(v::Vector, p, r)
    i = rand(p:r)
    v[r], v[i] = v[i], v[r]
    return partition!(v, p, r)
end

end # module