# runHashTests.jl

using Test
using Revise

include("../benchmarks/BenchHash.jl")

@testset "Testing isequal and isless" begin
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
end

println()

@testset "LinearSearch, BinarySearch, DirectAdressing" begin
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
    h_table = ClosedAddressingHT{Int64, ZipNode{Int64}}(m)

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
    gotbandis2, getbandisattemts = MyHash.searchattempts(h_table, bandis)
    @test contains(gotbandis.name, "BANDHAGEN")
    # println("The population of ", rstrip(gotbandis.name), " is ", gotbandis.population)
    α = //(getfield(h_table, :mod), length(v_intkey))
    postnummer = 12431
    hashvalue, collisions = MyHash.getcollisiondata(h_table, postnummer)
    # println("With a loadfactor of α ", α, " zipcode ", postnummer, " is mapped to a hashvalue of ", hashvalue, " that got ", collisions, " collisions")
    @test isequal(gotbandis, gotbandis2)
    # println("It took ", getbandisattemts, " attempts to get ", gotbandis, "which should be the same as ", gotbandis2, )
end

println()

@testset "DynamicLinearProbHT get and insert!" begin
    m = 1000
    h_table = DynamicOpenAddressingHT{Int64, ZipNode{Int64}}(m)
    # println("mod: ", h_table.mod, " n: ", h_table.n)

    # zipcode = v_intkey[100]
    # key = zipcode.code
    # testnode = Datum{Int64, ZipNode{Int64}}(key, zipcode)
    # insert!(h_table, key, zipcode)
    # got = get(h_table, key)
    # @test isequal(got, key)

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
    gotbandis2, getbandisattemts = MyHash.searchattempts(h_table, bandis)
    @test contains(gotbandis.name, "BANDHAGEN")
    @test isequal(gotbandis, gotbandis2)
    # println("It took ", getbandisattemts, " attempts to get ", gotbandis, "which should be the same as ", gotbandis2, )
    # println("The population of ", rstrip(gotbandis.name), " is ", gotbandis.population)
    # println("mod: ", h_table.mod, " n: ", h_table.n)
end

println()

@testset "StaticLinearProbHT get and insert!" begin
    m = 10000
    h_table = StaticOpenAddressingHT{Int64, ZipNode{Int64}}(m)
    # println("mod: ", h_table.mod, " n: ", h_table.n)

    # zipcode = v_intkey[100]
    # key = zipcode.code
    # testnode = Datum{Int64, ZipNode{Int64}}(key, zipcode)
    # insert!(h_table, key, zipcode)
    # got = get(h_table, key)
    # @test isequal(got, key)

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
    gotbandis2, getbandisattemts = MyHash.searchattempts(h_table, bandis)
    @test contains(gotbandis.name, "BANDHAGEN")
    @test isequal(gotbandis, gotbandis2)
    # println("It took ", getbandisattemts, " attempts to get ", gotbandis, "which should be the same as ", gotbandis2, )
    # println("The population of ", rstrip(gotbandis.name), " is ", gotbandis.population)
    # println("mod: ", h_table.mod, " n: ", h_table.n)
end

@testset "Attempts data" begin
    m = 10000
    ca, static, dynamic = attempts(m)
    @test sum(ca) == length(v_intkey)
    @test sum(static) == length(v_intkey)
    if length(v_intkey) < m 
        @test sum(dynamic) == length(v_intkey)
    else
        @test sum(dynamic) == 0
    end
    
    for i = 1:10
        println("buckets[", i, "]: ", ca[i])
        println("static[", i, "]: ", static[i])
        println("dynamic[", i, "]: ", dynamic[i])
        println()
    end
end

@testset "Collision data" begin
    m = 10000
    ca_coll = collisions(m)

    @test sum(ca_coll[2]) == length(v_intkey)
    
    for i = 1:10
        println("buckets[", i, "]: ", ca_coll[2][i])
        println()
    end
end

@testset "compare attempt with collisiondata" begin
    m = 10000
    caht = hashtables(m)[1]
    ca_collisions = collisiondata(caht)[2]
    ca_attempts = attemptdata(caht)
    
    for i = 1:10
        println("[", i, "] collisions: ", ca_collisions[i], " attempts: ", ca_attempts[i])
    end
end

println()

@testset "Collisions data" begin
end

println()

# # testprints
# println()
# println("TESTPRINTS")
# println(v_intkey[1])
# println(v_stringkey[1])
# println(v_directaddressing[12050])

# # Length
# println()
# println("LENGTHS")
# println(length(v_stringkey))
# println(length(v_intkey))
# println(length(v_directaddressing))