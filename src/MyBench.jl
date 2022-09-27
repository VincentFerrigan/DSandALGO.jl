# BenchFun.jl
"""
	BenchFun

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes: utils for benchmarking. TODO: Improve

Contains:
- timeappend # List vs Vector
"""
module MyBench
include("MyLL.jl")
include("MyV.jl")
using .MyLL
using .MyV

using Random
export timeappend

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
    
            if typeofstruct == :SLLISTS
                firstlist = MyLL.sllistfromvector(firstvector)
                secondlist = MyLL.sllistfromvector(secondvector)
                t_0 = time_ns()
                MyLL.append!(firstlist, secondlist)
                t_total += (time_ns() - t_0)
            elseif typeofstruct == :DLLISTS
                firstlist = MyLL.dllistfromvector(firstvector)
                secondlist = MyLL.dllistfromvector(secondvector)
                t_0 = time_ns()
                MyLL.append!(firstlist, secondlist)
                t_total += (time_ns() - t_0)
            elseif typeofstruct == :VECTORS
                t_0 = time_ns()
                MyV.appendvectors!(firstvector, secondvector)
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

# # help utils for bench utils
# function createrandom_sllists(size)
#     vector = Vector{Int}(undef, size)
#     rand!(vector, 1:10*size)
#     list = MyLL.sllistfromvector(vector)
#     return list 
# end

# function createrandom_dllists(size)
#     vector = Vector{Int}(undef, size)
#     rand!(vector, 1:10*size)
#     list = MyLL.dllistfromvector(vector) ## Har dessa previous?
#     return list 
# end

# function createtworandom_sllists(firstsize, secondsize)
#     firstvector = Vector{Int}(undef, firstsize)
#     secondvector = Vector{Int}(undef, secondsize)
#     rand!(firstvector, 1:10*firstsize)
#     rand!(secondvector, 1:10*secondsize)

#     firstlist = MyLL.sllistfromvector(firstvector)
#     secondlist = MyLL.sllistfromvector(secondvector)
#     return firstlist, secondlist
# end

# function createtworandom_dllists(firstsize, secondsize)
#     firstvector = Vector{Int}(undef, firstsize)
#     secondvector = Vector{Int}(undef, secondsize)
#     rand!(firstvector, 1:10*firstsize)
#     rand!(secondvector, 1:10*secondsize)

#     firstlist = MyLL.dllistfromvector(firstvector)
#     secondlist = MyLL.dllistfromvector(secondvector)
#     return firstlist, secondlist
# end

end # module