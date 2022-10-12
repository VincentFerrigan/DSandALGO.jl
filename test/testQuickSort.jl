using Test
using Revise

include("../src/SortingAlgo.jl")
include("../src/MyV.jl")
include("../src/MyLL.jl")

using .SortingAlgo
using .MyV

@testset "QuickSort a vector" begin
    v = createrandomvector(9, 10)
    println("before")
    println(v)
    quicksort!(v)
    println("after")
    println(v)
    v2 = createrandomvector(9, 10)
    println("before")
    println(v2)
    randomized_quicksort!(v2)
    println("after")
    println(v2)
end

@testset "QuickSort a lists" begin
    v = createrandomvector(10, 10)
    l = isllistfromvector(v)
    println("before")
    println(v)
    println(l)
    quicksort!(v)
    quicksort!(l)
    println("after")
    println(v)
    println(l)
end