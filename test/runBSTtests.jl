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

# TO TEST: diffrent types of iterators: DFS (preorder, inorder, postorder) and BFS
tree = BTree{Int64, String}()
add!(tree, 4, "Tree-Root ROOT")
add!(tree, 2, "L-Subtree Root PARENT")
add!(tree, 6, "R-Subtree Root PARENT")
add!(tree, 1, "L-Subtree L-child LEAF")
add!(tree, 3, "L-Subtree R-child LEAF")
add!(tree, 5, "R-Subtree L-child LEAF")
add!(tree, 7, "R-Subtree R-child LEAF")

println("preorder")
add!(tree, 4, "One")
add!(tree, 2, "two")
add!(tree, 1, "three")
add!(tree, 3, "four")
add!(tree, 6, "five")
add!(tree, 5, "six")
add!(tree, 7, "Seven")

println("BredthFirst")
add!(tree, 4, "Kanada-Guld")
add!(tree, 2, "Kanada-Final")
add!(tree, 6, "Sverige-Final")
add!(tree, 1, "Kanada-Semifinal")
add!(tree, 3, "USA-Seminfinal")
add!(tree, 5, "Australien-Semifinal")
add!(tree, 7, "Sverige-Semifinal")
for node in tree
    println(node)
end