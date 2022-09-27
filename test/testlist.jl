using Test
using Revise

include("../src/MyLL.jl")
# include("../src/LinkedListsVsArrays.jl")
# using .LinkedListsVsArrays
using .MyLL
# import .MyLL

# @testset "LinkedListsVsArrays.jl" begin
#     # Write your tests here.
# end

# Also works when the module is imported istead of using using.
# When a function is not exported, then the namespace is most def required when using using

# requires that the module gets included via 'using .ModuleName' e.g. 'using .MySLL'
@testset "SinglyLinkedHamlet" begin
    hamlet = SinglyLinkedList{String}()
    @test isempty(hamlet) == true

    push!(hamlet, "To")
    push!(hamlet, "be")
    push!(hamlet, "or")
    push!(hamlet, "not")
    @test !(isempty(hamlet))
    @test length(hamlet) == 4
    @test popfirst!(hamlet) == "To"
    @test popfirst!(hamlet) == "be"
    @test popfirst!(hamlet) == "or"
    @test popfirst!(hamlet) == "not"
    @test isempty(hamlet) == true
    pushfirst!(hamlet, "not")
    pushfirst!(hamlet, "or")
    pushfirst!(hamlet, "be")
    pushfirst!(hamlet, "To")
    push!(hamlet, "that")
    push!(hamlet, "is")
    push!(hamlet, "the")
    push!(hamlet, "question")
    @test popfirst!(hamlet) == "To"
    @test popfirst!(hamlet) == "be"
    @test popfirst!(hamlet) == "or"
    @test popfirst!(hamlet) == "not"
    @test isempty(hamlet) == false
    @test peekfirst(hamlet) == "that"
    @test findtail(hamlet).data == "question"
    hamlet2 = sllistfromvector(["To", "be", "or", "not", "to", "be", ","])
    @test findtail(hamlet2).data == ","
    append!(hamlet2, hamlet)
    @test peekfirst(hamlet2) == "To"
    @test findtail(hamlet2).data == "question"
    @test length(hamlet2) ==  11
    @test pop!(hamlet2) == "question"
    @test length(hamlet2) ==  10
    @test findtail(hamlet2).data == "the"
    @test removeitem!(hamlet2, "nt") === nothing
    @test removeitem!(hamlet2, "not") === "not"
    @test push!(hamlet2, "question!") == hamlet2
    @test findtail(hamlet2).data == "question!"
    # println(hamlet2)
end

@testset "DoublyLinkedHamlet" begin
    hamlet_d1 = DoublyLinkedList{String}()
    @test isempty(hamlet_d1) == true

    push!(hamlet_d1, "To")
    push!(hamlet_d1, "be")
    push!(hamlet_d1, "or")
    push!(hamlet_d1, "not")
    @test !(isempty(hamlet_d1))
    @test length(hamlet_d1) == 4
    @test popfirst!(hamlet_d1) == "To"
    @test popfirst!(hamlet_d1) == "be"
    @test popfirst!(hamlet_d1) == "or"
    @test popfirst!(hamlet_d1) == "not"
    @test isempty(hamlet_d1) == true
    pushfirst!(hamlet_d1, "not")
    pushfirst!(hamlet_d1, "or")
    pushfirst!(hamlet_d1, "be")
    pushfirst!(hamlet_d1, "To")
    push!(hamlet_d1, "that")
    push!(hamlet_d1, "is")
    push!(hamlet_d1, "the")
    push!(hamlet_d1, "question")
    @test popfirst!(hamlet_d1) == "To"
    @test popfirst!(hamlet_d1) == "be"
    @test popfirst!(hamlet_d1) == "or"
    @test popfirst!(hamlet_d1) == "not"
    @test isempty(hamlet_d1) == false
    @test peekfirst(hamlet_d1) == "that"
    @test findtail(hamlet_d1).data == "question"
    hamlet_d2= dllistfromvector(["To", "be", "or", "not", "to", "be", ","])
    @test findtail(hamlet_d2).data == ","
    append!(hamlet_d2,hamlet_d1)
    @test peekfirst(hamlet_d2) == "To"
    @test findtail(hamlet_d2).data == "question"
    @test length(hamlet_d2) ==  11
    @test pop!(hamlet_d2) == "question"
    @test length(hamlet_d2) ==  10
    @test findtail(hamlet_d2).data == "the"
    @test removeitem!(hamlet_d2, "nt") === nothing
    @test removeitem!(hamlet_d2, "not") === "not"
    @test push!(hamlet_d2, "question!") == hamlet_d2
    @test findtail(hamlet_d2).data == "question!"
    # println(hamlet_d2)
end