# using DSandALGO
using Test
using Revise

include("../src/RPN.jl")
using .RPN

# @testset "DSandALGO.jl" begin
#     # Write your tests here.
# end

pwd() 

@testset "fileToRpn" begin
    hp35 = HP35(:STATICSTACK)
    file = "test/input/test1.txt"
    @test readexpressions_linebyline(file, hp35) == 101
end