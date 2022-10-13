
using Test
using Revise

include("../src/MyHeap.jl")

using .MyHeap

@testset "build a heap" begin
    @test true == true
    @test rchild(2) == 5
    @test lchild(2) == 4
    @test hparent(2) == 1
    @test rchild(3) == 7
    @test lchild(3) == 6
    @test hparent(3) == 1
end

v = [16,14,10,8,7,9,3,2,4,1]
v2 = [16,14,10,8,100,7,9,3,2,4,1]

heap = MaxHeapVector(v)

println(v)
println(heap.heaptree)
heapsort!(heap.heaptree)
println(heap.heaptree)

println("")
println(v2)
heap2 = MaxHeapVector(v2)
println(heap2.heaptree)

heapsort!(heap2.heaptree)
println(heap2.heaptree)