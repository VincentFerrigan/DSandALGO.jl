
using Test
using Revise

include("../src/MyPQ.jl")

using .MyPQ

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

v = [16,14,10,18,7,9,3,2,4,1]
v2 = [16,14,10,18,7,9,3,2,4,1]
v3 = [16,14,10,8,100,7,9,3,2,4,1]

println("v: ", v)
println("v2: ", v2)

heap = MaxVectorPQ(v)
println("heap(v) ", heap.pq)
heapsort!(v2)
println("heapsorted v2: ", v2)

println("")
println("v3: ", v3)
heap3 = MaxVectorPQ(v3)
println("heap(v3)", heap3.pq)

heapsort!(heap3.pq)
println("heapsorted heap(v3): ", heap3.pq)

println("")
test = [6,140,10,8,100,7,9,3,2,4,11]
test2 = [6,140,10,8,100,7,9,3,2,4,11]
println("test v: ", test)
heapmin = MinVectorPQ(test)
println("heapmin of v: ", heapmin.pq)
