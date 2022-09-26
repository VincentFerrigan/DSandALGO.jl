using Test
using Revise

include("../src/MyLL.jl")
# include("../src/LinkedListsVsArrays.jl")
# using .LinkedListsVsArrays
using .MyLL
# import .MySLL

# @testset "LinkedListsVsArrays.jl" begin
#     # Write your tests here.
# end

# Also works when the module is imported istead of using using.
# When a function is not exported, then the namespace is most def required when using using
@testset "Hamlet" begin
    hamlet = MyLL.SinglyLinkedList{String}()
    @test MyLL.isempty(hamlet) == true

    MyLL.push!(hamlet, "To")
    MyLL.push!(hamlet, "be")
    MySLL.push!(hamlet, "or")
    MySLL.push!(hamlet, "not")
    @test !(MySLL.isempty(hamlet))
    @test MySLL.length(hamlet) == 4
    @test MySLL.popfirst!(hamlet) == "To"
    @test MySLL.popfirst!(hamlet) == "be"
    @test MySLL.popfirst!(hamlet) == "or"
    @test MySLL.popfirst!(hamlet) == "not"
    @test MySLL.isempty(hamlet) == true
    MySLL.pushfirst!(hamlet, "not")
    MySLL.pushfirst!(hamlet, "or")
    MySLL.pushfirst!(hamlet, "be")
    MySLL.pushfirst!(hamlet, "To")
    MySLL.push!(hamlet, "that")
    MySLL.push!(hamlet, "is")
    MySLL.push!(hamlet, "the")
    MySLL.push!(hamlet, "question")
    @test MySLL.popfirst!(hamlet) == "To"
    @test MySLL.popfirst!(hamlet) == "be"
    @test MySLL.popfirst!(hamlet) == "or"
    @test MySLL.popfirst!(hamlet) == "not"
    @test MySLL.isempty(hamlet) == false
    @test MySLL.peekfirst(hamlet) == "that"
    @test MySLL.findtail(hamlet).data == "question"
    hamlet2 = MySLL.listfromvector(["To", "be", "or", "not", "to", "be", ","])
    @test MySLL.findtail(hamlet2).data == ","
    MySLL.append!(hamlet2, hamlet)
    @test MySLL.peekfirst(hamlet2) == "To"
    @test MySLL.findtail(hamlet2).data == "question"
    @test MySLL.length(hamlet2) ==  11
    # Write your tests here.
end

# requires that the module gets included via 'using .ModuleName' e.g. 'using .MySLL'
@testset "HamletWithoutNamespace" begin
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
    hamlet2 = listfromvector(["To", "be", "or", "not", "to", "be", ","])
    @test findtail(hamlet2).data == ","
    append!(hamlet2, hamlet)
    @test peekfirst(hamlet2) == "To"
    @test findtail(hamlet2).data == "question"
    @test length(hamlet2) ==  11
    # Write your tests here.
end
