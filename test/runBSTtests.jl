# runBSTtests.jl

using Test
using Revise

include("../src/MyBST.jl")

using .MyBST

@testset "Test BTS add and lookup - small set" begin
    testtree = BTree{Int64, String}()
    add!(testtree, 10, "ten")
    @test lookup(testtree, 10) === "ten"

    add!(testtree, 5, "fem") 
    add!(testtree, 5, "five")
    @test lookup(testtree, 5) == "five"
end

@testset "Test BTS add and find" begin

    testtree2 = BTree{Int64, String}()
    add!(testtree2, 2, "två")
    add!(testtree2, 1, "ett")
    add!(testtree2, 3, "tree")
    add!(testtree2, 0, "null")
    add!(testtree2, 0, "noll")
    add!(testtree2, 9, "nio")
    @test lookup(testtree2, 0) == "noll"
    add!(testtree2, 4, "fyra")
    @test lookup(testtree2, 10) === nothing
    @test lookup(testtree2, 4) == "fyra"
end
@testset "vector" begin
    v = [(1, "one"), (2, "two")]
    test = createBST(v)
end

iter_test = BTree{Int64, String}()
add!(iter_test, 3, "tre")
add!(iter_test, 11, "elva")
add!(iter_test, 12, "tolv")
add!(iter_test, 10, "tio")
add!(iter_test, 2, "två")
add!(iter_test, 5, "fem")
add!(iter_test, 1, "ett")
print_tree(iter_test)
for node in iter_test
    println(node)
end
v = [(1, "one"), (2, "two")]
testvectortotree = createBST(v)
print_tree(testvectortotree)
for node in testvectortotree
    println(node)
end