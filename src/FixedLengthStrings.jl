__precompile__()

module FixedLengthStrings

export SString, sstring
export @tiny_string, @short_string, @mid_string, @long_string, @text_string

using StaticArrays

using Compat
import Compat.String

struct SString{n,T <: Union{Char, UInt8}} <: AbstractString
    sv::SVector{n,T}
end

function _string(s::SString)
    replace(
        convert(String, s.sv),
        '\0', ""
    )
end

# coercing constructor:
function sstring(s::String, n=nothing)
    str_length = length(s)

    ( n == nothing ) && ( n = str_length )

    ( str_length > n ) &&
        error("String too large to fit into a fixed length of $n")

    nul_length = n - length(s)

    cur_array = eval(parse("b\"$(s)\""))

    cur_nul = eval(parse("$(eltype(cur_array))(C_NULL)"))

    nul_array = repmat([cur_nul], nul_length)

    append!(cur_array, nul_array)

    sv = SVector{n,Char}(cur_array)

    return SString(sv)
end

sstring(s::AbstractString, n=nothing) = sstring(String(s), n)
sstring(args...; n=nothing) = sstring(string(args...), n)

macro tiny_string(s, flags...) sstring(s, n=4) end
macro short_string(s, flags...) sstring(s, n=16) end
macro mid_string(s, flags...) sstring(s, n=64) end
macro long_string(s, flags...) sstring(s, n=256) end
macro text_string(s, flags...) sstring(s, n=1024) end

import Base: write, endof, getindex, sizeof, search, rsearch, isvalid, next, length, IOBuffer, pointer

if isdefined(Base, :bytestring)
    import Base: bytestring
    bytestring(s::SString) = bytestring(_string(s))
end

endof(s::SString) = endof(_string(s))
next(s::SString, i::Int) = next(_string(s), i)
length(s::SString) = length(_string(s))
getindex(s::SString, i::Int) = getindex(_string(s), i)
getindex(s::SString, i::Integer) = getindex(_string(s), i)
getindex(s::SString, i::Real) = getindex(_string(s), i)
getindex(s::SString, i::UnitRange{Int}) = getindex(_string(s), i)
getindex{T<:Integer}(s::SString, i::UnitRange{T}) = getindex(_string(s), i)
getindex(s::SString, i::AbstractVector) = getindex(_string(s), i)
sizeof(s::SString) = sizeof(_string(s))
search(s::SString, c::Char, i::Integer) = search(_string(s), c, i)
rsearch(s::SString, c::Char, i::Integer) = rsearch(_string(s), c, i)
isvalid(s::SString, i::Integer) = isvalid(_string(s), i)
pointer(s::SString) = pointer(_string(s))
IOBuffer(s::SString) = IOBuffer(_string(s))

import Base.convert
const unsafe_convert = Base.convert

@compat unsafe_convert(T::Union{Type{Ptr{UInt8}},Type{Ptr{Int8}}}, s::SString) = convert(T, _string(s))
unsafe_convert(::Type{Cstring}, s::SString) = unsafe_convert(Cstring, _string(s))

end # module
