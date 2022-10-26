"""
    tres, yres = resamplingwithnoise(; t = t, y = y, σ = σ, seed = 1, scalebysqrt = true)

Produces a resampled version of given lightcurve t, y.

# Arguments
- `t` are the observed times of lightcurve.
- `y` are the observed fluxes of lightcurve.
- `σ` are the measurement errors of the lightcurve.
- `seed` controls the random number generator that samples the lightcurve and the added noise. Default value is `1`.
- `scalebysqrt` scales `σ` by the square root of the number of points in resampled lightcurve. Default value is `true`.

# Outputs
- `tres` holds the resampled times, in ascending order.
- `yres` holds the resampled lightcurve.
"""
function resamplingwithnoise(; t = t, y = y, σ = σ, seed = 1, scalebysqrt = true)

    rg = MersenneTwister(seed)

    N = length(y)

    repeatedindices = ceil.(Int, rand(rg, N)*N)

    indices = sort(unique(repeatedindices))

    scale = (scalebysqrt ? sqrt(length(indices)) : 1)

    yout = y[indices] .+ randn(rg, length(indices)) .* σ[indices] / scale

    
    return t[indices], yout

end