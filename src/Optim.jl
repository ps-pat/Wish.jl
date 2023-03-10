struct ToeplitzHash
    nrows::Int
    ncols::Int
end

############
# Sampling #
############

import Random: rand, AbstractRNG, SamplerTrivial

function rand(rng::AbstractRNG, th::SamplerTrivial{ToeplitzHash})
    i, n = th[].nrows, th[].ncols

    b = rand(rng, Bool, i)

    vr = rand(rng, Bool, n)
    vc = rand(rng, Bool, i - 1)
    A = Toeplitz(vr, vc)

    A, b
end

###########
# Solving #
###########

using JuMP:
    Model,
    @variables,
    @constraint,
    @objective,
    optimize!,
    value,
    optimizer_with_attributes

import SCIP

function solve(A, b, c; limits_solutions = 1)
    opti = optimizer_with_attributes(SCIP.Optimizer,
                                     "limits/solutions" => limits_solutions)

    model = Model(opti, add_bridges = false)

    i, n = size(A)
    @variables(model, begin
                   ω[1:n], Bin
                   0 ≤ k[1:i] ≤ n ÷ 2, Int
               end)

    @constraint(model, A * ω .== 2k + b)

    @objective(model, Max, c' * ω)

    optimize!(model)

    value.(ω)
end
