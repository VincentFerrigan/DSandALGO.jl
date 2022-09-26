# Types for RPN module

# consts
const SET_OF_STATIC_TYPES = Set([:STATICSTACK, :DYNAMICSTACK, :LISTSTACK])
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
			MyStacks.DynamicStack(), rxOperators, rxOperands, rxSpec)
		elseif stacktype == :STATICSTACK 
            new(clean_rpn_stringtovector(expression), 0, 
			MyStacks.StaticStack(), rxOperators, rxOperands, rxSpec)
		elseif stacktype == :LISTSTACK
            new(clean_rpn_stringtovector(expression), 0, 
			MyStacks.SinglyLLStack(), rxOperators, rxOperands, rxSpec)
		else
			throw(ArgumentError("Unknown Stack Type: $stacktype"))
        end
	end

end # HP35
