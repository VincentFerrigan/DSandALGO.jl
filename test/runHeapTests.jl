
using Test
using Revise
using StatsBase

include("../src/MyPQ.jl")
include("../src/MyLL.jl")

using .MyPQ
import .MyLL

@testset "heap arithmatic" begin
    @test rchild(2) == 5
    @test lchild(2) == 4
    @test hparent(2) == 1
    @test rchild(3) == 7
    @test lchild(3) == 6
    @test hparent(3) == 1
end

@testset "Build maxheps" begin
    v = [4, 2, 37, 9]
    a = VectorPQNode(70,2)
    b = VectorPQNode(3,2)
    b2 = VectorPQNode(3,2)
    c = VectorPQNode(40,2)
    d = VectorPQNode(1,0)
    e = VectorPQNode(100,3)
    f = VectorPQNode(6,3)
    g = VectorPQNode(10,3)
    @test isless(a, b) == false
    @test isless(b, a) == true
    @test isequal(b, b2) == true
    @test isequal(b, a) == false
    @test isequal(a, a) == true

    maxheap = MaxVectorPQ{VectorPQNode{Int64, Int64}}(10)
    maxheapsimple = MaxVectorPQ(v)
    @test maximum(maxheapsimple) == 37
    @test length(maxheapsimple) == 4
    @test capacityleft(maxheapsimple) == 0
    @test popmax!(maxheapsimple) == 37
    @test maximum(maxheapsimple) == 9
    @test capacityleft(maxheapsimple) == 1
    @test maximum(maxheapsimple) == 9
    push!(maxheapsimple, 100)
    @test popmax!(maxheapsimple) == 100
    push!(maxheapsimple, 100)
    @test maximum(maxheapsimple) == 100
    @test capacityleft(maxheap) == 10
    @test isempty(maxheap) == true
    @test isempty(maxheapsimple) == false
    push!(maxheap, c)
    @test maximum(maxheap) == c
    push!(maxheap, b)
    @test maximum(maxheap) == c
    push!(maxheap, a)
    @test maximum(maxheap) == a
    @test capacityleft(maxheap) == 7
    @test length(maxheap) == 3
    push!(maxheap, d)
    @test maximum(maxheap) == a
    push!(maxheap, e)
    @test maximum(maxheap) == e
end

@testset "Build minheaps" begin
    v = [4, 2, 37, 9]
    a = VectorPQNode(70,2)
    b = VectorPQNode(3,2)
    b2 = VectorPQNode(3,2)
    c = VectorPQNode(40,2)
    d = VectorPQNode(1,0)
    e = VectorPQNode(100,3)
    f = VectorPQNode(6,3)
    g = VectorPQNode(10,3)
    minheap = MinVectorPQ{VectorPQNode{Int64, Int64}}(10)
    minheapsimple = MinVectorPQ(v)
    @test minimum(minheapsimple) == 2
    @test length(minheapsimple) == 4
    @test capacityleft(minheapsimple) == 0
    @test isempty(minheapsimple) == false
    @test capacityleft(minheap) == 10
    @test isempty(minheap) == true
    push!(minheap, c)
    @test minimum(minheap) == c
    push!(minheap, b)
    @test minimum(minheap) == b
    push!(minheap, a)
    @test minimum(minheap) == b
    @test capacityleft(minheap) == 7
    @test length(minheap) == 3
    push!(minheap, d)
    @test minimum(minheap) == d
    push!(minheap, e)
    @test minimum(minheap) == d

    heapsort!(v)
    @test v == [2,4,9,37]
end

@testset "Build DynamicMaxHeps" begin
    a = VectorPQNode(70,2)
    b = VectorPQNode(3,2)
    b2 = VectorPQNode(3,2)
    c = VectorPQNode(40,2)
    d = VectorPQNode(1,0)
    e = VectorPQNode(100,3)
    f = VectorPQNode(6,3)
    g = VectorPQNode(1001,3)

    dynamicmaxheap = MaxDynamicPQ{VectorPQNode{Int64, Int64}}()
    @test capacityleft(dynamicmaxheap) == 4
    @test isempty(dynamicmaxheap) == true
    push!(dynamicmaxheap, c)
    @test maximum(dynamicmaxheap) == c
    push!(dynamicmaxheap, b)
    @test maximum(dynamicmaxheap) == c
    push!(dynamicmaxheap, a)
    @test maximum(dynamicmaxheap) == a
    @test capacityleft(dynamicmaxheap) == 1
    @test length(dynamicmaxheap) == 3
    push!(dynamicmaxheap, d)
    @test maximum(dynamicmaxheap) == a
    @test capacityleft(dynamicmaxheap) == 0
    # här är du!!!!!! Nu ska du test resize, har du skrivit den än?
    push!(dynamicmaxheap, e)
    @test maximum(dynamicmaxheap) == e
    @test capacityleft(dynamicmaxheap) == 3
    @test popmax!(dynamicmaxheap) == e
    @test popmax!(dynamicmaxheap) == a
    @test maximum(dynamicmaxheap) == c
    push!(dynamicmaxheap, g)
    @test maximum(dynamicmaxheap) == g

end

@testset "Build DynamicMinHeps" begin
    a = VectorPQNode(70,2)
    b = VectorPQNode(3,2)
    b2 = VectorPQNode(3,2)
    c = VectorPQNode(40,2)
    d = VectorPQNode(1,0)
    e = VectorPQNode(100,3)
    f = VectorPQNode(6,3)
    g = VectorPQNode(1001,3)

    dynamicminheap = MinDynamicPQ{VectorPQNode{Int64, Int64}}()
    @test capacityleft(dynamicminheap) == 4
    @test isempty(dynamicminheap) == true
    push!(dynamicminheap, c)
    @test minimum(dynamicminheap) == c
    push!(dynamicminheap, b)
    @test minimum(dynamicminheap) == b
    push!(dynamicminheap, a)
    @test minimum(dynamicminheap) == b
    @test capacityleft(dynamicminheap) == 1
    @test length(dynamicminheap) == 3
    push!(dynamicminheap, d)
    @test minimum(dynamicminheap) == d
    @test capacityleft(dynamicminheap) == 0
    # # här är du!!!!!! Nu ska du test resize, har du skrivit den än?
    push!(dynamicminheap, e)
    @test minimum(dynamicminheap) == d
    @test capacityleft(dynamicminheap) == 3
    @test popmin!(dynamicminheap) == d
    @test popmin!(dynamicminheap) == b
    @test minimum(dynamicminheap) == c
    push!(dynamicminheap, g)
    @test minimum(dynamicminheap) == c

end

@testset "Build TreePQ" begin
    treepq = TreePQ{Int64,String}()
    add!(treepq, 3, "tre")
    @test minimum(treepq).key == 3
    add!(treepq, 4, "fyra")
    @test minimum(treepq).key == 3
    add!(treepq, 2, "två")
    @test minimum(treepq).key == 2
    add!(treepq, 7, "sju")
    @test minimum(treepq).key == 2
    add!(treepq, 5, "fem")
    @test minimum(treepq).key == 2
    add!(treepq, 1, "ett")
    @test minimum(treepq).key == 1
    add!(treepq, 6, "sex")
    @test minimum(treepq).key == 1
    add!(treepq, 8, "åtta")
    @test minimum(treepq).key == 1
    add!(treepq, 9, "nio")
    @test minimum(treepq).key == 1
    add!(treepq, 10, "tio")
    add!(treepq, 11, "elva")
    add!(treepq, 12, "tolv")

    # println("TESTBFS")
    # for node in treepq
    #     println(node)
    # end
    # println("TESTPRINT")
    # MyPQ.print_tree(treepq)

    println("remove top")
    @test minimum(treepq).key == 1
    remove!(treepq)
    @test minimum(treepq).key == 2
    remove!(treepq)
    @test minimum(treepq).key == 3
    remove!(treepq)
    @test minimum(treepq).key == 4
    remove!(treepq)
    @test minimum(treepq).key == 5
    remove!(treepq)

    # println("TESTBFS")
    # for node in treepq
    #     println(node)
    # end
    # println("TESTPRINT")
    # MyPQ.print_tree(treepq)

    @test minimum(treepq).key == 6
    remove!(treepq)
    @test minimum(treepq).key == 7
    remove!(treepq)
    @test minimum(treepq).key == 8
    remove!(treepq)
    @test minimum(treepq).key == 9
    remove!(treepq)
    @test minimum(treepq).key == 10
    remove!(treepq)
    @test minimum(treepq).key == 11
    remove!(treepq)
    @test minimum(treepq).key == 12
    remove!(treepq)
    @test minimum(treepq) === nothing
end



# v = [16,14,10,18,7,9,3,2,4,1]
# v2 = [16,14,10,18,7,9,3,2,4,1]
# v3 = [16,14,10,8,100,7,9,3,2,4,1]

# println("v: ", v)
# println("v2: ", v2)

# heap = MaxVectorPQ(v)
# println("heap(v) ", heap.pq)
# heapsort!(v2)
# println("heapsorted v2: ", v2)

# println("")
# println("v3: ", v3)
# heap3 = MaxVectorPQ(v3)
# println("heap(v3)", heap3.pq)

# heapsort!(heap3.pq)
# println("heapsorted heap(v3): ", heap3.pq)

# println("")
# test = [6,140,10,8,100,7,9,3,2,4,11]
# test2 = [6,140,10,8,100,7,9,3,2,4,11]
# println("test v: ", test)
# heapmin = MinVectorPQ(test)
# println("heapmin of v: ", heapmin.pq)

@testset "lazyPQ" begin
    lazyPQ = MyLL.DoublyLinkedList{Int}()
    @test MyLL.isempty(lazyPQ)
    MyLL.push!(lazyPQ, 3)
    MyLL.push!(lazyPQ, 5)
    MyLL.push!(lazyPQ, 2)
    MyLL.push!(lazyPQ, 1)
    MyLL.push!(lazyPQ, 4)

    @test MyLL.findminimum(lazyPQ).data == 1
    MyLL.removeminimum!(lazyPQ)
    @test MyLL.findminimum(lazyPQ).data == 2
end

@testset "eagerPQ" begin
    eagerPQ = MyLL.DoublyLinkedList{Int}()
    @test MyLL.isempty(eagerPQ)
    MyLL.insert_desc_list!(eagerPQ, 3)
    MyLL.insert_desc_list!(eagerPQ, 5)
    MyLL.insert_desc_list!(eagerPQ, 2)
    MyLL.insert_desc_list!(eagerPQ, 1)
    MyLL.insert_desc_list!(eagerPQ, 4)

    @test MyLL.peekfirst(eagerPQ) == 1
    MyLL.removeminimum!(eagerPQ)
    @test MyLL.findminimum(eagerPQ).data == 2
    @test MyLL.peekfirst(eagerPQ) == 2
end

@testset "benchtest" begin
    rand64 = sample(1:100, 64, replace = false)
    lazyPQ = MyLL.DoublyLinkedList{Int64}()
    eagerPQ = MyLL.DoublyLinkedList{Int64}()
    treePQ = TreePQ{Int64, Int64}()
    dynamicMinHeapPQ = MinDynamicPQ{Int64}()

    for item ∈ rand64
        MyLL.pushfirst!(lazyPQ, item)
        MyLL.insert_desc_list!(eagerPQ, item)
        add!(treePQ, item, item)
        push!(dynamicMinHeapPQ, item)
    end

     @test MyLL.findminimum(lazyPQ).data == MyLL.peekfirst(eagerPQ)
     @test minimum(treePQ).key == minimum(dynamicMinHeapPQ)
     @test minimum(dynamicMinHeapPQ) == MyLL.peekfirst(eagerPQ)
     @test minimum(treePQ).key == MyLL.findminimum(lazyPQ).data
end