# MyHeap_utils.jl
# Utils for MyHeap module in MyHeap.jl

# Heap arithmatic
lchild = i -> <<(i, 1)
rchild = i -> +(<<(i, 1), 1)
hparent = i -> >>(i, 1)

# utils
length(h::MyVectorHeap) = h.heapsize

""" 
    build_max_heap!(v::Vector, n = length(v))
    
# or should i build it as a constructor???
"""
function build_max_heap!(
    h::MyVectorHeap{T},
    v::Vector{T} = h.heaptree, 
    n = length(v)
    ) where {T}

    for i = ÷(n, 2):-1:1
        max_heapify!(h, i)
    end
    return v
end

function max_heapify!(
    h::MyVectorHeap{T}, 
    i,
    v::Vector{T} = h.heaptree
    ) where {T}

    l = lchild(i)
    r = rchild(i)

    largest = i
    l <= length(h) && v[l] > v[i] && (largest = l)
    r <= length(h) && v[r] > v[largest] && (largest = r)

    if largest != i
        v[i], v[largest] = v[largest], v[i]
        max_heapify!(h, largest)
    end
    # # alt (får ej att funka)
    # (largest == i
    #   || ((v[i], v[largest] = v[largest], v[i])
    #     && (return max_heapify(h, largest))))
end

function heapsort!(v::Vector{T}, n = length(v)) where {T}
    # heap = MaxHeapVector{T}(v)
    heap = MaxHeapVector(v)
    for i = n:-1:2
        v[1], v[i]  = v[i], v[1]
        heap.heapsize -= 1
        max_heapify!(heap, 1)
    end
end

# function max_heapify2(v::Vector, i)
#     l = lchild(i)
#     r = rhild(i)
#     largest = 0

#     ((l <= length(v) && v[l] > v[i]) # if
#     && (largest = l)                
#     || (largest = i))

#     (r >= length(v) && v[r] > v[largest]) && (largest = l)

#     (largest == i
#     || (v[i], v[largest] = v[largest], v[i]
#         && max_heapify(v, largest)))
# end
