function bootstrapanalysis(; repeats = 1000, t1 = t1, t2 = t2, y1 = y1, y2 = y2, σ1 = σ1, σ2 = σ2, minτ = 0.0, maxτ = maxτ, dτ = 0.1, seed₀ = 1, threshold = 0.8, showplot = false)

    if showplot
        figure(); title(@sprintf("%d average curves", repeats))
    end

    centroidarray = zeros(repeats)

    @showprogress for i in 1:repeats

        
        t1res, y1res = resamplingwithnoise(t = t1, y = y1, σ = σ1, seed = seed₀ + i)

        t2res, y2res = resamplingwithnoise(t = t2, y = y2, σ = σ2, seed = seed₀ + i + repeats)


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

