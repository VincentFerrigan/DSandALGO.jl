# RPN.jl
module RPN

include("./Stacks.jl")
import .Stacks

export HP35, SET_OF_STATIC_TYPES, run, peek, stacksize


# consts
const SET_OF_STATIC_TYPES = Set([:STATICSTACK, :DYNAMICSTACK])
# :STATICSTACK, 
# :DYNAMICSTACK

# types
mutable struct HP35
	rpn::Vector{Any}
	ip::Int
	stack
	rxOperators::Regex
	rxOperands::Regex
	rxSpec::Regex
	
    HP35(stacktype::Symbol) = HP35(stacktype, "")
    
	function HP35(stacktype::Symbol, expression::String; 
        rxOperators::Regex = r"[\+\-\*\/\%]", 
		rxOperands::Regex = r"[0-9]", 
		rxSpec = r"[\']")

        if stacktype == :DYNAMICSTACK
            new(clean_rpn_stringtovector(expression), 0, 
			Stacks.DynamicStack(), rxOperators, rxOperands, rxSpec)
		elseif stacktype == :STATICSTACK 
            new(clean_rpn_stringtovector(expression), 0, 
			Stacks.StaticStack(), rxOperators, rxOperands, rxSpec)
		elseif stacktype == :LISTSTACK
            new(clean_rpn_stringtovector(expression), 0, 
			Stacks.ListStack(), rxOperators, rxOperands, rxSpec)
		else
			throw(ArgumentError("Unknown Stack Type: $stacktype"))
        end
	end

end # HP35


# utils

function clean_rpn_stringtovector(uncleanrpn::String; 
	rx::Regex = r"[0-9\+\-\*\/\%\']")
	v = Vector{Any}(undef,0)
	for c in uncleanrpn
		if match(rx,"$c") != nothing
			push!(v, c)
		end
	end
	return v
end


# specialarn funkar ej. Den är *' och inte '* FIXA
function evalrpn(hp35::HP35)
	while hp35.ip < size(hp35.rpn)[1]
		hp35.ip += 1
		token = hp35.rpn[hp35.ip]
		x = 0
		y = 0
		if match(hp35.rxOperands, "$token") != nothing 
			Stacks.push!(hp35.stack, parse(Int, "$token"))
		elseif match(hp35.rxOperators, "$token") != nothing
			y = Stacks.pop!(hp35.stack)
			x = Stacks.pop!(hp35.stack)
		elseif token == '\''
			y = Stacks.pop!(hp35.stack)
		end
		
		if token == '+' Stacks.push!(hp35.stack, +(x,y))
		elseif token == '-' Stacks.push!(hp35.stack, -(x,y))
		elseif token == '*' Stacks.push!(hp35.stack, *(x,y)) ## lägg till spec logik
		elseif token == '/' Stacks.push!(hp35.stack, div(x,y))
		elseif token == '%' Stacks.push!(hp35.stack, %(x,y))
		elseif token =='\''  &&  hp35.rpn[hp35 + 1] == '*'
			res = *(y,2)
			if res > 9 Stacks.push!(hp35.stack, +(%(res,10),div(res,10)))
			else Stacks.push!(hp35.stack, res)
			end
			hp35.ip += 1
		end
	end
end

"""
    runcalculator(hp35::HP35)
	Evaluates stored arithmatic instructions and returns the value that is on
	top of the stack
"""
function runcalculator(hp35::HP35)
	evalrpn(hp35)
	Stacks.peek(hp35.stack) # eller borde jag poppa??
end

function runcalculator(hp35::HP35, operand::Int)
	Stacks.push!(hp35.stack, operand)
end

# function resetHP35(hp35::HP35) how to??????
# 	hp35 = HP35("")
# end

function runcalculator(hp35::HP35, expression::String)
	hp35.rpn = clean_rpn_stringtovector(expression)
	hp35.ip = 0
	runcalculator(hp35)
end

function peek(hp35::HP35)
	return Stacks.peek(hp35.stack)
end
"""
    stacksize(hp35::HP35)
	returns the current size of the stack, aka head or stack pointer

"""
function stacksize(hp35::HP35)
	return Stacks.stacksize(hp35.stack)
end


end # module