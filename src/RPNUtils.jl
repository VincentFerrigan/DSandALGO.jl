# Utils for RPN module

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

function evalrpn(hp35::HP35)
	while hp35.ip < length(hp35.rpn)
		hp35.ip += 1
		token = hp35.rpn[hp35.ip]
		x = 0
		y = 0
		if match(hp35.rxOperands, "$token") != nothing 
			MyStacks.push!(hp35.stack, parse(Int, "$token"))
		elseif match(hp35.rxOperators, "$token") != nothing
		    if token == '*' && (hp35.ip + 1) <= length(hp35.rpn) && hp35.rpn[hp35.ip + 1] == '\''
			    y = MyStacks.pop!(hp35.stack)
            else
			    y = MyStacks.pop!(hp35.stack)
			    x = MyStacks.pop!(hp35.stack)
            end
		end
		
        if token == '*'
		    if (hp35.ip + 1) <= length(hp35.rpn) && hp35.rpn[hp35.ip + 1] == '\''
			    res = *(y,2)
			    if res > 9 
                    MyStacks.push!(hp35.stack, +(%(res,10),div(res,10)))
			    else 
                    MyStacks.push!(hp35.stack, res)
                end
            else
                MyStacks.push!(hp35.stack, *(x,y)) 
            end
		elseif token == '+' MyStacks.push!(hp35.stack, +(x,y))
		elseif token == '-' MyStacks.push!(hp35.stack, -(x,y))
		elseif token == '/' MyStacks.push!(hp35.stack, div(x,y))
		elseif token == '%' MyStacks.push!(hp35.stack, %(x,y))
        elseif token == '\'' 
            continue
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

function personalnumbers_lastdigit(hp35::HP35, pnbr_without_lastdigit)
    1 <= ÷(pnbr_without_lastdigit, 10^8) < 10 || 
    throw(ArgumentError("Only nine digits allowed"))

    runcalculator(hp35, 10)
    pnbr = pnbr_without_lastdigit
    for n = 8:-1:0
        runcalculator(hp35, div(pnbr, 10^n))
        iseven(n) && runcalculator(hp35, "*'")
        pnbr = %(pnbr, 10^n)
    end
    runcalculator(hp35, "+"^8)
    runcalculator(hp35, 10)
    runcalculator(hp35, "%")
    runcalculator(hp35, "-")
    runcalculator(hp35)
end

function check_personalnumber(hp35::HP35, pnbr)
    1<= ÷(pnbr, 10^9) < 10 || 
    throw(ArgumentError("Only ten digit personal number allowed"))

    return %(pnbr, 10) == personalnumbers_lastdigit(hp35, div(pnbr, 10))
end

# nr = 810222055
# println(10)
# for n = 8:-1:0
#     # println(nr)
#     println(div(nr, 10^n))
#     iseven(n) && println("*'")
#     nr = %(nr, 10^n)
# end
# println("+"^8)
# println(10)
# println("%-")
# "*'"    
