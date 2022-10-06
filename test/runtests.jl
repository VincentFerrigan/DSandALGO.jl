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
    hp35_ss = HP35(:STATICSTACK)
    file = "test/input/test1.txt"
    @test readexpressions_linebyline(file, hp35_ss) == 101

end
@testset "check_pnbr" begin
    hp35_ds = HP35(:DYNAMICSTACK)
    hp35_ls = HP35(:LISTSTACK)
    @test personalnumbers_lastdigit(hp35_ds, 810222055) == 8
    @test check_personalnumber(hp35_ds, 8102220558)
    @test personalnumbers_lastdigit(hp35_ls, 810222055) == 8
    @test check_personalnumber(hp35_ls, 8102220558)
end

@testset "check_pnbr_from_file" begin
    hp35_ds2 = HP35(:DYNAMICSTACK)
    hp35_ls2 = HP35(:LISTSTACK)
    file2 = "test/input/personnummertest.txt"
    open(file2, "r") do f
        for line in eachline(f)
            personnummer = tryparse(Int, "$line")
            if typeof(personnummer) != Nothing
                @test check_personalnumber(hp35_ds2, personnummer)
                @test check_personalnumber(hp35_ls2, personnummer)
            else
                throw(ArgumentError("Non a valid personal number"))
            end
        end
    end
end

