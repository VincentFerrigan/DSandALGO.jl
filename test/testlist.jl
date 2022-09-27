using Test
using Revise

include("../src/MyLL.jl")
include("../src/MyV.jl")
# include("../src/LinkedListsVsArrays.jl")
# using .LinkedListsVsArrays
using .MyLL
using .MyV
# import .MyLL

# @testset "LinkedListsVsArrays.jl" begin
#     # Write your tests here.
# end

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
    println(hamlet2)
    hs2size = length(hamlet2)
    @test popat!(hamlet2, 3) == "or"
    println(hamlet2)
    @test length(hamlet2) == hs2size - 1
    @test popat!(hamlet2, length(hamlet2)) == "question!"
    println(hamlet2)

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
    println(hamlet_d2)
    hd2size = length(hamlet_d2)
    @test popat!(hamlet_d2, 2) == "be"
    println(hamlet_d2)
    @test length(hamlet_d2) == hd2size - 1
    @test popat!(hamlet_d2, 1) == "To"
    @test length(hamlet_d2) == hd2size - 2
    println(hamlet_d2)
end

@testset "Help-utilities for Benchmarking and testing" begin
    @test isa(createrandom_dllist(10), DoublyLinkedList) == true
    @test isa(createrandom_sllist(10), SinglyLinkedList) == true
    @test length(createrandom_dllist(10)) == 10
end

k = 100 # k operations
n = 10  # list of n elements

sequence_vector = createrandomvector(k, n)
singlylinked_list = createrandom_sllist(n)
doublylinked_list = createrandom_dllist(n)

@time begin
    for i in eachindex(sequence_vector)
        pushfirst!(singlylinked_list, popat!(singlylinked_list, sequence_vector[i]))
    end
end

