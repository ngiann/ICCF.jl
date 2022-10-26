"""
    centroids = bootstrapanalysis(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, σ1 = σ1, σ2 = σ2, minτ = 0.0, maxτ = maxτ, dτ = 0.1, repeats = 1000, threshold = 0.8, seed = 1, showplot = false)

Given a pair of lightcurves returns the distribution of the centroid as obtained via bootstrapping.

# Arguments
# Arguments
- `t1` are the observed times of the first lightcurve.
- `t2` are the observed times of the second lightcurve.
- `y1` are the observed fluxes of the first lightcurve.
- `y2` are the observed fluxes of the second lightcurve.
- `minτ` is the minimum considered delay, default value is 0.
- `maxτ` is the maximum considered delay.
- `dτ` is the delay step size, default value is 0.1.
- `seed` controls the random number generator. Default is `1`.
- `repeats` is the number of times that ICCF is repeated for. Each repeatition produces a sample for the centroid. Default is `1000`.
- `threshold` specifies the interval around the peak of the ICCF curve used to calculate the centroid.
- If `showplot` is set to `true`, a plot of the produced ICCF curves will appear. Default is `false`. 

# Outputs
- `centroids` holds the sampled centroids.
"""
function bootstrapanalysis(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, σ1 = σ1, σ2 = σ2, minτ = 0.0, maxτ = maxτ, dτ = 0.1, repeats = 1000, threshold = 0.8, seed = 1, showplot = false)

    if showplot
        figure(); title(@sprintf("%d average curves", repeats))
    end

    centroidarray = zeros(repeats)

    @showprogress for i in 1:repeats


        t1res, y1res = resamplingwithnoise(t = t1, y = y1, σ = σ1, seed = seed + i)

        t2res, y2res = resamplingwithnoise(t = t2, y = y2, σ = σ2, seed = seed + i + repeats)


        delays12, ccf12    = iccf(t1 = t1res, t2 = t2res, y1 = y1res, y2 = y2res, minτ = minτ, maxτ = maxτ, dτ = dτ, showplot = false)

        delays21, negccf21 = iccf(t1 = t2res, t2 = t1res, y1 = y2res, y2 = y1res, minτ = minτ, maxτ = maxτ, dτ = dτ, showplot = false)

        ccf21 = - negccf21


        commondelays = intersect(delays12, delays21)

        indices12    = findall(in(delays12), commondelays)

        indices21    = findall(in(delays21), commondelays)

        avgcurve = (ccf12[indices12] .+ ccf21[indices21]) / 2
    
        showplot ? plot(commondelays, avgcurve) : nothing

        centroidarray[i] = centroid(τ = commondelays, avgcurve = avgcurve, threshold = threshold)
        
    end
    
    return centroidarray

end

