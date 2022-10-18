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
# * test buckets in acc with hash.pdf - done
# * test linear probing in acc with hash.pdf - have to create them first

fname = "test/input/postnummer.csv"
v_stringkey = Vector{Union{ZipNode{String}, Nothing}}(nothing, 9675)
v_intkey = Vector{Union{ZipNode{Int64}, Nothing}}(nothing, 9675)
v_directaddressing = Vector{Union{ZipNode{Int64}, Nothing}}(nothing, 99999)


@testset "read first lines from file" begin
    open(fname, "r") do fh
        i = 1
        for line in eachline(fh)
            row = split(line, ",")
            v_stringkey[i] = ZipNode{String}(row[1], row[2], row[3])
            i += 1
        end
    end

    open(fname, "r") do fh
        j = 1
        for line ∈ eachline(fh)
            row = split(line, ",")
            code = tryparse(Int, replace(row[1], " " => ""))
            pop = tryparse(Int, row[3])
            isa(code, Nothing) && throw(ArgumentError("$code is not a valid zip code"))
            isa(pop, Nothing) && throw(ArgumentError("$pop is not a valid population number"))
            v_intkey[j] = ZipNode{Int64}(code, row[2], pop)
            j += 1
        end
    end

    # direct addressing
    for node in v_intkey
        v_directaddressing[node.code] = node
    end

    # Comparing values (<, >, isequal, <=, >=)
    @test isequal(v_intkey[2], 11120)
    @test isequal(v_intkey[1], 11115)
    @test v_intkey[2] > v_intkey[1]
    @test v_intkey[1] < v_intkey[2]

    @test v_intkey[2] >= v_intkey[1]
    @test v_intkey[1] <= v_intkey[2]
    @test v_intkey[1] >= v_intkey[1]
    @test v_intkey[1] != v_intkey[2]
    
    @test isequal(v_stringkey[1], "111 15")
    @test isequal(v_stringkey[2], "111 20")
    @test isequal(v_stringkey[1], "111 15")
    @test v_stringkey[2] > v_stringkey[1]
    @test v_stringkey[1] < v_stringkey[2]
    @test v_stringkey[2] >= v_stringkey[1]
    @test v_stringkey[1] <= v_stringkey[2]
    @test !(v_stringkey[1] > v_stringkey[2])

    # Linear search
    il = SearchingAlgo.linear_search(v_intkey, 12431)
    @test contains(v_intkey[il].name, "BANDHAGEN")
    jl = SearchingAlgo.linear_search(v_stringkey, "124 31")
    @test contains(v_stringkey[jl].name, "BANDHAGEN")

    # Binary search
    ib = SearchingAlgo.binary_search(v_intkey, 12050)
    @test v_intkey[ib].population == 954
    jb = SearchingAlgo.binary_search(v_stringkey, "120 50")
    @test v_stringkey[jb].population == "954"
    @test SearchingAlgo.binary_search(v_stringkey, "120") isa Nothing

    # Direct addressing
    @test isequal(v_directaddressing[12431], 12431)
end

println()

@testset "Buckets get and insert!" begin
    m = 10000
    h_table = Buckets{Int64, ZipNode{Int64}}(m)

    # testnode = Node{Int64, ZipNode{Int64}}(key, zipcode, nothing, 1)
    # insert!(h_table, key, zipcode)

    for node ∈ v_intkey # alternativt läser in på nytt
        insert!(h_table, node.code, node)
    end

    zipcode = v_intkey[100]
    key = zipcode.code
    got = get(h_table, key)
    @test isequal(got, key)
    @test got.population == zipcode.population
    bandis = 12431
    gotbandis = get(h_table, bandis)
    @test contains(gotbandis.name, "BANDHAGEN")
    println("The population of ", rstrip(gotbandis.name), " is ", gotbandis.population)
    α = //(getfield(h_table, :mod), length(v_intkey))
    postnummer = 12431
    collisions = MyHash.getchainsize(h_table, postnummer)
    println("With a loadfactor of α ", α, " zipcode ", postnummer, " got ", collisions, " collisions")
end

# testprints
println()
println("TESTPRINTS")
println(v_intkey[1])
println(v_stringkey[1])
println(v_directaddressing[12050])

# Length
println()
println("LENGTHS")
println(length(v_stringkey))
println(length(v_intkey))
println(length(v_directaddressing))