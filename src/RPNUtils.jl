# Utils for RPN module

# Outer Constructs

HP35(stacktype::Symbol) = HP35(stacktype, "")

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
			MyStacks.push!(hp35.stack, parse(Int, "$token"))
		elseif match(hp35.rxOperators, "$token") != nothing
			y = MyStacks.pop!(hp35.stack)
			x = MyStacks.pop!(hp35.stack)
		elseif token == '\''
			y = MyStacks.pop!(hp35.stack)
		end
		
		if token == '+' MyStacks.push!(hp35.stack, +(x,y))
		elseif token == '-' MyStacks.push!(hp35.stack, -(x,y))
		elseif token == '*' MyStacks.push!(hp35.stack, *(x,y)) ## lägg till spec logik
		elseif token == '/' MyStacks.push!(hp35.stack, div(x,y))
		elseif token == '%' MyStacks.push!(hp35.stack, %(x,y))
		elseif token =='\''  &&  hp35.rpn[hp35 + 1] == '*'
			res = *(y,2)
			if res > 9 MyStacks.push!(hp35.stack, +(%(res,10),div(res,10)))
			else MyStacks.push!(hp35.stack, res)
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
	MyStacks.peek(hp35.stack) # eller borde jag poppa??
end

function runcalculator(hp35::HP35, operand::Int)
	MyStacks.push!(hp35.stack, operand)
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
	return MyStacks.peek(hp35.stack)
end
"""
    stacksize(hp35::HP35)
	returns the current size of the stack, aka head or stack pointer

"""
function stacksize(hp35::HP35)
	return MyStacks.stacksize(hp35.stack)
end
