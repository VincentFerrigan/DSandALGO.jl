# runT9Tests.jl

using Test
using Revise

include("../src/MyTries.jl")
using .MyTries

@testset "simple" begin
    ordlista = Trie()
    println(ordlista)
    ord = "hjälp"
    add!(ordlista, ord)
    got = get(ordlista, ord)
    @test isequal(mapchar2int(ord[1]),3)
    @test isequal(mapchar2int(ord[2]),4)
    @test isequal(mapchar2int(ord[3]),9)
    @test isequal(mapchar2int(ord[5]),4)
    @test isequal(mapchar2int(ord[6]),6)
    @test sizeof(ord) == length(ord)+1
    @test isequal(got, ord)
end