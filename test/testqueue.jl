using Test
using Revise

include("../src/MyQueues.jl")

using .MyQueues

@testset "Queue a list" begin
    ql = MyQueues.SLQueue{String}()
    MyQueues.enqueue!(ql, "Etta")
    MyQueues.enqueue!(ql, "Tvåa")
    MyQueues.enqueue!(ql, "Trea")
    @test ql.first.data == "Etta"
    @test ql.last.data == "Trea"
    @test MyQueues.isempty(ql) == false
    @test MyQueues.dequeue!(ql) == "Etta"
    @test ql.first.data == "Tvåa"
    @test MyQueues.dequeue!(ql) == "Tvåa"
    @test MyQueues.dequeue!(ql) == "Trea"
    @test MyQueues.isempty(ql) == true
end

@testset "Queue in a vector" begin
    qv = MyQueues.DynamicQueue{String}() # not dynamic yet!!
    @test qv.items[1] === nothing
    MyQueues.enqueue!(qv, "Etta")
    MyQueues.enqueue!(qv, "Tvåa")
    MyQueues.enqueue!(qv, "Trea")
    @test qv.items[qv.first] == "Etta"
    println("n:", qv.n, "first: ", qv.first, "last: ", qv.last, "capacity: ", MyQueues.queuecapacity(qv))
    @test qv.items[(qv.first + MyQueues.length(qv) - 1)] == "Trea"
    @test MyQueues.isempty(qv) == false
    @test MyQueues.dequeue!(qv) == "Etta"
    @test qv.items[qv.first] == "Tvåa"
    println("n:", qv.n, "first: ", qv.first, "last: ", qv.last, "capacity: ", MyQueues.queuecapacity(qv))
    @test MyQueues.dequeue!(qv) == "Tvåa"
    @test MyQueues.dequeue!(qv) == "Trea"
    @test MyQueues.isempty(qv) == true
    @test qv.items[1] === nothing
    println("n:", qv.n, "first: ", qv.first, "last: ", qv.last, "capacity: ", MyQueues.queuecapacity(qv))
    MyQueues.enqueue!(qv, "1")
    MyQueues.enqueue!(qv, "2")
    MyQueues.enqueue!(qv, "3")
    MyQueues.enqueue!(qv, "4")
    MyQueues.enqueue!(qv, "5")
    MyQueues.enqueue!(qv, "6")
    MyQueues.enqueue!(qv, "7")
    MyQueues.enqueue!(qv, "8")
    MyQueues.enqueue!(qv, "9")
    MyQueues.enqueue!(qv, "10")
    MyQueues.enqueue!(qv, "11")
    MyQueues.enqueue!(qv, "12")
    MyQueues.enqueue!(qv, "13") # will print please resize since it is not (yet) dynamic
    println("n:", qv.n, "first: ", qv.first, "last: ", qv.last, "capacity: ", MyQueues.queuecapacity(qv))
    @test MyQueues.dequeue!(qv) == "1"
    @test MyQueues.dequeue!(qv) == "2"
    @test qv.items[qv.first] == "3"
    @test qv.items[(qv.first + MyQueues.length(qv) - 1)] == "13"
end