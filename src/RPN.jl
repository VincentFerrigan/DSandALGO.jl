# RPN.jl
"""
	RPN

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-09-27
Notes:

Contains:
# Types 
- HP35 #TODO: Improve according to good design patterns and princles
# Utils
- clean_rpn_stringtovector
- evalrpn
- runcalculator # Three seperate ones, multiple dispatch
- peek
- resetHP35 # TODO
- stacksize
- personalnumbers_lastdigit
- check_personalnumber
- readexpressions_linebyline

"""
module RPN

import .MyStacks
include("./MyStacks.jl")
include("./RPNTypes.jl")
include("./RPNUtils.jl")

export HP35, SET_OF_STATIC_TYPES, run, peek, stacksize
export readexpressions_linebyline, personalnumbers_lastdigit, check_personalnumber

end # module