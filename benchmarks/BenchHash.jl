# BenchHash.jl

# using Revise
using BenchmarkTools
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

# Global data
fname = "benchmarks/input/postnummer.csv"
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
Returns a tuple containg the following @benchmark for
- LinearSearch integer key
- LinearSearch string key
- BinarySearch integer key
- BinarySearch string key
- DirectAdressing integer key

# Arguments
- `n`: index number
"""
function smallbench(n)
    key_int = v_intkey[n].code
    key_string = v_stringkey[n].code

    # Linear search
    t_ls_int = @benchmark SearchingAlgo.linear_search(v_intkey, $key_int)
    t_ls_string = @benchmark SearchingAlgo.linear_search(v_stringkey, $key_string)

    # Binary search
    t_bs_int = @benchmark SearchingAlgo.binary_search(v_intkey, $key_int)
    t_bs_string = @benchmark SearchingAlgo.binary_search(v_stringkey, $key_string)

    # Direct addressing
    t_da = @benchmark v_directaddressing[$key_int]

    return (t_ls_int, t_ls_string, t_bs_int, t_bs_string, t_da)
end

function smallbenchable(n)
    key_int = v_intkey[n].code
    key_string = v_stringkey[n].code

    # Linear search
    lis = @benchmarkable SearchingAlgo.linear_search(v_intkey, $key_int)
    lss = @benchmarkable SearchingAlgo.linear_search(v_stringkey, $key_string)

    # Binary search
    bis = @benchmarkable SearchingAlgo.binary_search(v_intkey, $key_int)
    bss = @benchmarkable SearchingAlgo.binary_search(v_stringkey, $key_string)

    # Direct addressing
    da = @benchmarkable v_directaddressing[$key_int]
    
    tune!(lis)
    tune!(lss)
    tune!(bis)
    tune!(bss)
    tune!(da)

    median_lis = median(run(lis))
    median_lss = median(run(lss))
    median_bis = median(run(bis))
    median_bss = median(run(bss))
    median_da = median(run(da))

    return (median_lis, median_lss, median_bis, median_bss, median_da)
end

""" 
    collisions(m)

For now it returns three collision data
If correct, the first and fourth should display the same info. 
I.e. nbr of collisions per hashvalue, where hashvalue is the index of the vector
and the value its nbr of collisions. 
The second and fitht collects the nbr of keys per collision (nbr of collision as index
and nrb o keys per that collision). They too should display the same info. 
The third is the nbr of unfilled slots.

Note that 1 means zero collisions while 2 means 1 collision! 
That is n equals n-1 collisions
"""
function collisions(m)
    h_table = hashtables(m)[1]
    return collisiondata(h_table)
end

function collisiondata(hashtable::ClosedAddressHT)
    colperhashvalue = fill(0, hashtable.mod)
    colperhashvalueDC = fill(0, hashtable.mod)
    nbrofkeyspercol = fill(0, 30)
    nbrofkeyspercolDC = fill(0, 30)
    for zipnode ∈ v_intkey
        hashvalue, col = getcollisiondata(hashtable, zipnode.code)
        colperhashvalue[hashvalue] = col
        colperhashvalueDC[hashing(zipnode.code, hashtable.mod)] += 1
        nbrofkeyspercol[col] += 1
    end

    nbrofnothings = 0
    for node ∈ hashtable.data
        if isa(node, Nothing)
            nbrofnothings += 1
        else
            nbrofkeyspercolDC[node.size] += node.size
        end
    end
    return colperhashvalue, nbrofkeyspercol, nbrofnothings, colperhashvalueDC, nbrofkeyspercolDC
end

function hashtables(m)
    caht = ClosedAddressHT{Int64, ZipNode{Int64}}(m)
    static_oaht = StaticOpenAddressHT{Int64, ZipNode{Int64}}(m)
    dynamic_oaht = DynamicOpenAddressHT{Int64, ZipNode{Int64}}(m)

    for zipnode ∈ v_intkey # alternativt läser in på nytt
        insert!(caht, zipnode.code, zipnode)
        insert!(dynamic_oaht, zipnode.code, zipnode)
        length(v_intkey) < m && insert!(static_oaht, zipnode.code, zipnode)
    end
    return caht, static_oaht, dynamic_oaht
end

function attemptdata(hashtable)
    nbrofkeysperattempt = fill(0,10000)
    (isa(hashtable, StaticOpenAddressHT) 
      && length(v_intkey) >= length(hashtable.data) 
      && return nbrofkeysperattempt)

    for zipnode ∈ v_intkey
        nbrofkeysperattempt[searchattempts(
            hashtable, zipnode.code)[2]] += 1
    end
    return nbrofkeysperattempt
end

function attempts(m)
    ca, static, dynamic = hashtables(m)
    return attemptdata(ca), attemptdata(static), attemptdata(dynamic)
end
        
"""
Do some statistics on linear probing --how many
element you need to look at before finding the one that you’re looking for.
Try with an increasing size of the array and compare the results with the
original solution (buckets)

It has to be without resizeing! 

Vidare skriver han
A slightly more efficient (but take care) version of the bucket implementation
is to use the array it self without indirection to separate buckets. The trick
is to start with the hashed index and then move forward in the array to
find the right entry. The lookup procedure would stop as soon as it finds a
empty slot and the hope is that this should not take too long. This is true
if the array is sufficiently large for example twice as large as needed. If the
array is too tight the risk is of course that hundred of elements needs to be
examined (and what will happen if the array is full?)
"""
function dosomestatisticsforlinearprobing()
    # do something
end

function createaplot(filename::String)
    # follow previous notbooks.
    # bench
    # dataframe
    # data transformation
    # plot
    # save plot
    # filepath = pwd()
    # savefig(tree_fig2,filepath*"/output/"*filename")
end