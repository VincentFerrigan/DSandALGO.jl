# runBSTtests.jl

using Test
using Revise

include("../src/MyBST.jl")
include("../src/MyV.jl")
include("../src/SortingAlgo.jl")

using .MyBST
using .MyV
using .SortingAlgo


@testset "Test BTS add and lookup - small set" begin
    testtree = BTree{Int64, String}()
    add!(testtree, 10, "ten")
    @test lookup(testtree, 10) === "ten"

    add!(testtree, 5, "fem") 
    add!(testtree, 5, "five")
    @test size(testtree) == 2
    @test length(testtree) == 2
    @test lookup(testtree, 5) === "five"
end

@testset "Test BTS add, size, lookup - average set" begin

    testtree2 = BTree{Int64, String}()
    add!(testtree2, 2, "två")
    add!(testtree2, 1, "ett")
    add!(testtree2, 3, "tree")
    add!(testtree2, 0, "null")
    add!(testtree2, 0, "noll")
    add!(testtree2, 9, "nio")
    @test size(testtree2) == 5
    @test length(testtree2) == 5
    @test lookup(testtree2, 0) == "noll"
    add!(testtree2, 4, "fyra")
    @test size(testtree2) == 6
    @test length(testtree2) == 6
    @test lookup(testtree2, 10) === nothing
    @test lookup(testtree2, 4) == "fyra"
end

@testset "from vector to bst" begin
    testvector = createrandomvector(10,100)
    insertionsort!(testvector)
    testbst = createBST(testvector)
    for i in eachindex(testvector)
        @test lookup(testbst, i) == testvector[i]
    end
    @test length(testbst) == length(testvector)
end