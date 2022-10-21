# runT9Tests.jl

using Test
using Revise

include("../src/MyTries.jl")
using .MyTries

# Global data
fname = "test/input/kelly.txt"
ordlista = Trie()
open(fname, "r") do fh
    for line in eachline(fh)
        add!(ordlista, line)
    end
end

@testset "simple" begin
    ordlista2 = Trie()
    ord = "hjälp"
    ord2 = "sök"
    ord3 = "japansktoffel"
    ord4 = "japan"
    ord5 = "tro"
    ord6 = "troende"
    ord7 = "t"
    ord8 = "trög"
    ord9 = "död"
    strNbr = "34946"
    add!(ordlista2, ord)
    add!(ordlista2, ord2)
    add!(ordlista2, ord3)
    add!(ordlista2, ord4)
    add!(ordlista2, ord5)
    add!(ordlista2, ord6)
    add!(ordlista2, ord7)
    add!(ordlista2, ord8)
    add!(ordlista2, ord9)
    gotStr = get(ordlista2, ord)
    gotStrNbr = get(ordlista2, strNbr)
    @test isequal(mapchar2int(ord[1]),3)
    @test isequal(mapchar2int(ord[2]),4)
    @test isequal(mapchar2int(ord[3]),9)
    @test isequal(mapchar2int(ord[5]),4)
    @test isequal(mapchar2int(ord[6]),6)
    @test sizeof(ord) == length(ord)+1
    @test isequal(gotStr, ord)
    @test isequal(gotStrNbr, ord)
    println(gotStrNbr)
    # println(ordlista)
end
@testset "Slå upp ord" begin
    got = get(ordlista, "9")
    for words in got
        println(words)
    end
end