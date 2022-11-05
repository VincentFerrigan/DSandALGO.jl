using Revise
using StatsBase
using BenchmarkTools

include("../src/MyPQ.jl")
include("../src/MyLL.jl")

import .MyPQ
import .MyLL

function smallbenchable(n, k)
    vector = sample(1:n, k, replace = false)

    lazyAdd = @benchmarkable for item ∈ v MyLL.pushfirst!(lazyPQ, item) end evals = 1 setup = begin
        v = copy($vector)
        lazyPQ = MyLL.DoublyLinkedList{Int64}()
    end

    eagerAdd = @benchmarkable for item ∈ v MyLL.insert_desc_list!(eagerPQ, item) end evals = 1 setup = begin
        v = copy($vector)
        eagerPQ = MyLL.DoublyLinkedList{Int64}() 
    end

    treeAdd = @benchmarkable for item ∈ v MyPQ.add!(treePQ, item, item) end evals = 1 setup = begin
        v = copy($vector)
        treePQ = MyPQ.TreePQ{Int64,Int64}()
    end

    heapAdd = @benchmarkable for item ∈ v MyPQ.push!(minVectorPQ, item) end evals = 1 (setup = begin
        v = copy($vector)
        minVectorPQ = MyPQ.MinVectorPQ{Int64}(length(v))
    end)

    treePop = @benchmarkable (for i = 1:(length($vector)) MyPQ.remove!(treePQ2) end) evals = 1 (setup = begin
        v = copy($vector)
        treePQ2 = MyPQ.TreePQ{Int64, Int64}()
        foreach(x -> MyPQ.add!(treePQ2, x, x), v)
    end)

    heapPop = @benchmarkable (for i = 1:(length($vector)) MyPQ.popmin!(minVectorPQ2) end) evals = 1 (setup = begin
        v = copy($vector)
        minVectorPQ2 = MyPQ.MinVectorPQ{Int64}(length(v))
        foreach(x -> MyPQ.push!(minVectorPQ2, x), v)
    end)

    lazyPop = @benchmarkable (for i = 1:(length($vector)) MyLL.removeminimum!(lazyPQ2) end) evals = 1 (setup = begin
        v = copy($vector)
        lazyPQ2 = MyLL.DoublyLinkedList{Int64}()
        foreach(x -> MyLL.pushfirst!(lazyPQ2, x), v)
    end)

    eagerPop = @benchmarkable (for i = 1:(length($vector)) MyLL.popfirst!(eagerPQ2) end) evals = 1 (setup = begin
        v = copy($vector)
        eagerPQ2 = MyLL.DoublyLinkedList{Int64}()
        foreach(x -> MyLL.insert_desc_list!(eagerPQ2, x), v)
    end)

    # tune!(lazyAdd)
    # tune!(eagerAdd)
    # tune!(treeAdd)
    # tune!(heapAdd)
    # tune!(lazyPop)
    # tune!(eagerPop)
    # tune!(treePop)
    # tune!(heapPop)

    m_lazyAdd = median(run(lazyAdd))
    m_eagerAdd = median(run(eagerAdd))
    m_treeAdd = median(run(treeAdd))
    m_heapAdd = median(run(heapAdd))

    m_treePop = median(run(treePop))
    m_heapPop = median(run(heapPop))
    m_lazyPop = median(run(lazyPop))
    m_eagerPop = median(run(eagerPop))

    return (m_lazyAdd, m_eagerAdd, m_treeAdd, m_heapAdd, m_lazyPop, m_eagerPop, m_treePop, m_heapPop)
end