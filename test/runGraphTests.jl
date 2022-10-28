# runGraphTests.jl

using Test
using Revise

include("../src/MyGraph.jl")
using .MyGraph

# Global data
fname = "test/input/trains.csv"
graph = Graph{String}(100)
# graph = Graph{String}(541) # 541 taken from graph.pdf instruction
open(fname, "r") do fh
    for line in eachline(fh)
        row = split(line, ",")
        minutes = tryparse(Int, row[3])
        add!(graph, String(row[1]), String(row[2]), minutes) 
    end
end

@testset "rough add! test" begin
    @test true == true
    testgraph = Graph{String}(5)
    add!(testgraph, "Stockholm", "Malmö", 360)
    add!(testgraph, "Stockholm", "Testa", 10)
    for datum in testgraph.adjList.data
        if !isa(datum, Nothing)
            @test datum.entry.head.data.weight == 360
            @test datum.entry.head.next.data.weight == 10
        end
    end
end

@testset "rough get test" begin
end