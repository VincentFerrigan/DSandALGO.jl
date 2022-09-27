# BenchFun.jl
"""
	BenchFun

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes: utils for benchmarking. TODO: Improve

Contains:
- createrandomlists
- createtworandomlists
- timeappend
"""
module BenchFun
include("MyLL.jl")
include("MyV.jl")
import .MyLL
import .MyV

using Random
export createrandomlists, createtworandomlists, timeappend

function createrandomlists(size)
    vector = Vector{Int}(undef, size)
    rand!(vector, 1:10*size)
    list = MyLL.listfromvector(vector)
    return list 
end

function createtworandomlists(firstsize, secondsize)
    firstvector = Vector{Int}(undef, firstsize)
    secondvector = Vector{Int}(undef, secondsize)
    rand!(firstvector, 1:10*firstsize)
    rand!(secondvector, 1:10*secondsize)

    firstlist = MyLL.listfromvector(firstvector)
    secondlist = MyLL.listfromvector(secondvector)
    return firstlist, secondlist
end

function timeappend(typeofstruct::Symbol, isfirstfixed::Bool = true, 
    fixedsize = 10, start = 10, stop = 100, 
    rounds = 1, isdoublestep::Bool = false)

    times = Vector{Float64}(undef, 0) # Time
    first_n = Vector{Int}(undef, 0)    # N range
    second_n = Vector{Int}(undef, 0)    # N range
    n = start

    firstsize = 0
    secondsize = 0

    while n <= stop
        t_total = 0
        if isfirstfixed == true
            firstsize = fixedsize
            secondsize = n
        else
            firstsize = n
            secondsize = fixedsize
        end

        for round ∈ rounds

            firstvector = Vector{Int}(undef, firstsize)
            secondvector = Vector{Int}(undef, secondsize)
            rand!(firstvector, 1:10*firstsize)
            rand!(secondvector, 1:10*secondsize)
    
            if typeofstruct == :LISTS
                firstlist = MyLL.listfromvector(firstvector)
                secondlist = MyLL.listfromvector(secondvector)
                t_0 = time_ns()
                MyLL.append!(firstlist, secondlist)
                t_total += (time_ns() - t_0)
            else
                t_0 = time_ns()
                V.appendvectors!(firstvector, secondvector)
                t_total += (time_ns() - t_0)
            end
        end
        push!(times, /(Int(t_total), (rounds * 1000* 1000))) # milliseconds
        push!(first_n, firstsize)
        push!(second_n, secondsize)
        isdoublestep == true ? n *= 2 : n += start 
    end
    return first_n, second_n, times
end
end # module