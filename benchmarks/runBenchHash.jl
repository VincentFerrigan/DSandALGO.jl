# runBenchHash.jl

using Revise
# using BenchmarkTools
# using DataFrames
# using DataFramesMeta
# using Plots
# using Random
# using Unitful
# using Formatting
# using Latexify

include("../src/Zip.jl")
include("../src/SearchingAlgo.jl")
include("../src/MyHash.jl")

using .Zip
using .SearchingAlgo
using .MyHash

fname = "test/input/postnummer.csv"
v_stringkey = Vector{Union{ZipNode{String}, Nothing}}(nothing, 9675)
v_intkey = Vector{Union{ZipNode{Int64}, Nothing}}(nothing, 9675)
v_directaddressing = Vector{Union{ZipNode{Int64}, Nothing}}(nothing, 99999)

open(fname, "r") do fh
    i = 1
    for line in eachline(fh)
        row = split(line, ",")
        v_stringkey[i] = ZipNode{String}(row[1], row[2], row[3])
        i += 1
    end
end

open(fname, "r") do fh
    j = 1
    for line ∈ eachline(fh)
        row = split(line, ",")
        code = tryparse(Int, replace(row[1], " " => ""))
        pop = tryparse(Int, row[3])
        isa(code, Nothing) && throw(ArgumentError("$code is not a valid zip code"))
        isa(pop, Nothing) && throw(ArgumentError("$pop is not a valid population number"))
        v_intkey[j] = ZipNode{Int64}(code, row[2], pop)
        j += 1
    end
end

# direct addressing
for node in v_intkey
    v_directaddressing[node.code] = node
end

"""
    smallbench(n)
A small benchmark function. 
Returns a tuple containg 
- 
- 
- 
-
-
-

# Arguments
- `n`: 
"""
function smallbench(n)
    # firstString = ”111 15” (1)
    # lastString = ”994 99” (9675)
    # firstInt = 11115
    # lastInt = 99499

    key_int = v_intkey[n]
    key_string = v_stringkey[n]

    # Linear search
    t_ls_int = @benchmark SearchingAlgo.linear_search(v_intkey, $key_int)
    t_ls_string = @benchmark SearchingAlgo.linear_search(v_stringkey, $key_string)

    # Binary search
    t_bs_int = @benchmark SearchingAlgo.binary_search(v_intkey, $key_int)
    t_bs_string = @benchmakr SearchingAlgo.binary_search(v_stringkey, $key_string)

    # Direct addressing
    t_da = @benchmakr v_directaddressing[$key_int]

    return (n, t_ls_int, t_ls_string, t_bs_int, t_bs_string, t_da)
end

function createaplot(filename::String)
    # follow previous notbooks.
    # bench
    # dataframe
    # data transformation
    # plot
    # save plot
    filepath = pwd()
    savefig(tree_fig2,filepath*"/output/"*filename")
end