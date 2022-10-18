# runHashTests.jl

using Test
using Revise

include("../src/Zip.jl")
include("../src/SearchingAlgo.jl")
include("../src/MyHash.jl")

using .Zip
using .SearchingAlgo
using .MyHash

# TODO:
# * test buckets in acc with hash.pdf

@testset "read first lines from file" begin
    fname = "test/input/postnummer.csv"
    vector = []
    vector2 = []
    open(fname, "r") do fh
        for line in eachline(fh)
            row = split(line, ",")
            push!(vector, ZipNode{String}(row[1], row[2], row[3]))
        end
    end
    println(vector[1])

    open(fname, "r") do fh
        for line ∈ eachline(fh)
            row = split(line, ",")
            code = tryparse(Int, replace(row[1], " " => ""))
            pop = tryparse(Int, row[3])
            isa(code, Nothing) && throw(ArgumentError("$code is not a valid zip code"))
            isa(pop, Nothing) && throw(ArgumentError("$pop is not a valid population number"))
            push!(vector2, ZipNode{Int64}(code, row[2], pop))
        end
    end
    # Comparing values (<, >, isequal, <=, >=)
    @test isequal(vector2[2], 11120)
    @test isequal(vector2[1], 11115)
    @test vector2[2] > vector2[1]
    @test vector2[1] < vector2[2]

    @test vector2[2] >= vector2[1]
    @test vector2[1] <= vector2[2]
    @test vector2[1] >= vector2[1]
    @test vector2[1] != vector2[2]
    
    @test isequal(vector[1], "111 15")
    @test isequal(vector[2], "111 20")
    @test isequal(vector[1], "111 15")
    @test vector[2] > vector[1]
    @test vector[1] < vector[2]
    @test vector[2] >= vector[1]
    @test vector[1] <= vector[2]
    @test !(vector[1] > vector[2])

    # Linear search
    il = SearchingAlgo.linear_search(vector2, 12431)
    println(vector2[il])
    jl = SearchingAlgo.linear_search(vector, "124 31")
    println(vector[jl])

    # binary search
    ib = SearchingAlgo.binary_search(vector2, 12050)
    println(vector2[ib])
    jb = SearchingAlgo.binary_search(vector, "120 50")
    println(vector[jb])
    @test SearchingAlgo.binary_search(vector, "120") === nothing

    # direct addressing
    directaddressingvector = Vector(undef, 99999)
    for node in vector2
        directaddressingvector[node.code] = node
    end

    println(directaddressingvector[12050])
    println(directaddressingvector[12051])
    @test isequal(directaddressingvector[12431], 12431)
    println(length(directaddressingvector))
    println(length(vector2))
    println(length(vector))
end