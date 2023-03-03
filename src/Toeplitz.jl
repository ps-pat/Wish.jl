using LinearAlgebra:
    AbstractMatrix

abstract type AbstractToeplitz{T} <: AbstractMatrix{T} end

##########################
# BitToeplitz definition #
##########################

struct BitToeplitz <: AbstractToeplitz{Bool}
    data::BitVector
    nrows::Int
    ncols::Int
end

BitToeplitz(vr, vc) = BitToeplitz(vcat(reverse(vc), vr),
                                  length(vc) + 1, length(vr))

### Abstract Array Interface
import Base: size, getindex, setindex!, IndexStyle

@generated IndexStyle(::AbstractToeplitz) = IndexCartesian()

size(M::BitToeplitz) = (M.nrows, M.ncols)

compute_idx(row, col, vc_length) = vc_length + col - row + 1

getindex(M::BitToeplitz, row, col) =
    M.data[compute_idx(row, col, size(M, 1) - 1)]

setindex!(M::BitToeplitz, v, row, col) =
    setindex!(M.data, v, compute_idx(row, col, size(M, 1) - 1))

#################################
# End of BitToeplitz definition #
#################################
