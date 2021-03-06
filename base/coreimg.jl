# This file is a part of Julia. License is MIT: http://julialang.org/license

Main.Core.eval(Main.Core, :(baremodule Inference
using Core: Intrinsics, arrayref, arrayset, arraysize, _expr,
            _apply, typeassert, apply_type, svec
ccall(:jl_set_istopmod, Void, (Bool,), false)

eval(x) = Core.eval(Inference,x)
eval(m,x) = Core.eval(m,x)

include = Core.include

# simple print definitions for debugging.
show(x::ANY) = ccall(:jl_static_show, Void, (Ptr{Void}, Any),
                     Intrinsics.pointerref(Intrinsics.cglobal(:jl_uv_stdout,Ptr{Void}),1), x)
print(x::ANY) = show(x)
println(x::ANY) = ccall(:jl_, Void, (Any,), x) # includes a newline
print(a::ANY...) = for x=a; print(x); end

# Doc macro shim.
macro doc(str, def) Expr(:escape, def) end

## Load essential files and libraries
include("essentials.jl")
include("generator.jl")
include("reflection.jl")
include("options.jl")

# core operations & types
typealias Cint Int32
typealias Csize_t UInt
include("promotion.jl")
include("tuple.jl")
include("range.jl")
include("expr.jl")
include("error.jl")

# core numeric operations & types
include("bool.jl")
include("number.jl")
include("int.jl")
include("operators.jl")
include("pointer.jl")
const checked_add = +
const checked_sub = -
(::Type{T}){T}(arg) = convert(T, arg)::T

# core array operations
include("abstractarray.jl")
include("array.jl")

#TODO: eliminate Dict from inference
include("hashing.jl")
include("nofloat_hashing.jl")

# map-reduce operators
macro simd(forloop)
    esc(forloop)
end
include("functors.jl")
include("reduce.jl")

## core structures
include("intset.jl")
include("dict.jl")
include("iterator.jl")

# compiler
include("inference.jl")

end # baremodule Inference
))
