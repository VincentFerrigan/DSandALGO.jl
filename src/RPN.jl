# RPN.jl
module RPN

include("./MyStacks.jl")
include("./RPNTypes.jl")
include("./RPNUtils.jl")
import .MyStacks

export HP35, SET_OF_STATIC_TYPES, run, peek, stacksize, readexpressions_linebyline

function readexpressions_linebyline(filename, hp35::HP35)
	open(filename, "r") do f
		for line in eachline(f)
			number = tryparse(Int, "$line")
			if typeof(number) != Nothing
				runcalculator(hp35, number)
			else
				runcalculator(hp35, "$line" )
			end
		end
	end
	return peek(hp35)
end

end # module