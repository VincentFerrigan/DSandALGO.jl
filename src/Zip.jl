# Zip.jl
"""
    Zip

Author: Vincent Ferrigan, ferrigan@kth.se
Date: 2022-10-17
Notes:

Contains:
# Types
* Zip ??
* ZipNode
# Utils
## Base overload utils
* isless
* isequal
* show
"""

module Zip

import Base: isless, isequal, show

include("Zip_types.jl")
include("Zip_utils.jl")

export ZipNode # Constructor (Zip node)
export isless, isequal, show # base overload for unittesting

end # Module