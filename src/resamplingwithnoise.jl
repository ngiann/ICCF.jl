function resamplingwithnoise(; t = t, y = y, σ = σ, seed = 1, scalebysqrt = true)

    rg = MersenneTwister(seed)

    N = length(y)

    repeatedindices = ceil.(Int, rand(rg, N)*N)

    indices = sort(unique(repeatedindices))

    scale = (scalebysqrt ? sqrt(length(indices)) : 1)

    yout = y[indices] .+ randn(rg, length(indices)) .* σ[indices] / scale

    
    return t[indices], yout

end