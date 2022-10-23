"""
    ccf, delays = iccf(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, minτ = 0.0, maxτ = maxτ, dτ = 0.5, showplot = false)

Calculated ICCF between two lightcurves

# Arguments
- `t1` are the observed times of the first lightcurve.
- `t2` are the observed times of the second lightcurve.
- `y1` are the observed fluxes of the first lightcurve.
- `y2` are the observed fluxes of the second lightcurve.
- `minτ` is the minimum considered delay, default value is 0.
- `maxτ` is the maximum considered delay.
- `dτ` is the delay step size, default value is 0.5.
- when `showplot` is set to true, it will plot the progress of ICCF. Default value is false.

# Outputs
- `delays` holds the delays at which `ccf` was calculated.
- `ccf` holds the measure of overlap.


# Example

Infer delay for toy example where delay is known to be equal to 2.

```julia-repl
julia> using ICCF, PyPlot 
julia> delay = 2
julia> signal(x) = sin(x) + 4*exp(-2*(x-3)^2)
julia> shiftedsignal(x) = signal(x-delay)
julia> σnoise = 0.2
julia> numobs = 25
julia> t1, t2 = sort(rand(numobs)) * 10, sort(rand(numobs)) * 10
julia> y1 = signal.(t1) + σnoise*randn(numobs)
julia> y2 = shiftedsignal.(t2) + σnoise*randn(numobs)
julia> figure()
julia> plot(t1, y1, "bo", label="observed 1st lightcurve")
julia> plot(t2, y2, "ro", label="observed 2nd lightcurve")
julia> delays, ccf = iccf(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, minτ = 0.0, maxτ = 12, dτ = 0.1, showplot = false)
julia> figure(); plot(delays, ccf, "ko-")
```
"""
function iccf(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, minτ = 0.0, maxτ = maxτ,  dτ = 0.5, showplot = false)

    # considered range of delays
    
    τrange = minτ:dτ:maxτ

    # Linearly nterpolate 2nd observed light curve

    f2 = linear_interpolation(t2, y2, extrapolation_bc = mean(y2))

    # Store here cross-correlation measure, initialise

    score = zeros(length(τrange))
    
    
    # Shift 1st lightcurve while keeping 2nd lightcurve fixed

    for (index, τ) in enumerate(τrange)

        tshifted = t1  .+ τ

        # find left and right limits of interval containing overlapping points
        
        tright = min(maximum(tshifted), maximum(t2))
        
        tleft  = min(max(minimum(tshifted), minimum(t2)), tright)

        # find points contained between above limits 

        containedindices = intersect(findall(tshifted .> tleft), findall(tshifted .< tright))

        # Calculate means and standard deviations

        μ1, μ2 = mean(y1[containedindices]), mean(f2.(tshifted[containedindices]))
        σ1, σ2 =  std(y1[containedindices]),  std(f2.(tshifted[containedindices]))

        # Calculate ccf at τ

        score[index] = mean((y1[containedindices] .- μ1) .* (f2.(tshifted[containedindices]) .- μ2)) / (σ1 * σ2)

        # plot ICCF if showplot set to true

        showplot ? plotprogress(tleft, tright, τ, t1, t2, y1, y2, f2, tshifted, containedindices, score, index) : nothing

    end

    # Array score will contain NaN values for delays τ when interval becomes of zero length
    # Find indices of score values that are not nan
    
    notNaNindices = findall(.~isnan.(score))

    return τrange[notNaNindices], score[notNaNindices]

end