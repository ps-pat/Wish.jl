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

#######################
# Toeplitz definition #
#######################

struct Toeplitz{T} <:AbstractToeplitz{T}
    data::Vector{T}
    nrows::Int
    ncols::Int
end

Toeplitz(vr, vc) = Toeplitz(vcat(reverse(vc), vr), length(vc) + 1, length(vr))

############################
# Abstract Array Interface #
############################

import Base: size, getindex, setindex!, IndexStyle

@generated IndexStyle(::AbstractToeplitz) = IndexCartesian()

size(M::AbstractToeplitz) = (M.nrows, M.ncols)

compute_idx(row, col, vc_length) = vc_length + col - row + 1

getindex(M::AbstractToeplitz, row, col) =
    M.data[compute_idx(row, col, size(M, 1) - 1)]

getindex(M::AbstractToeplitz, row, ::Colon) =
    M.data[range(compute_idx(row, 1, size(M, 1) - 1), length = M.ncols)]

setindex!(M::AbstractToeplitz, v, row, col) =
    setindex!(M.data, v, compute_idx(row, col, size(M, 1) - 1))
