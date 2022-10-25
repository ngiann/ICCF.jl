function centroid(; τ = τ, avgcurve = avgcurve, threshold = threshold)

    # find index of peak
    
    peakindex = argmax(avgcurve)

    # find value at peak

    peakvalue = avgcurve[peakindex]

    # following value defines interval around peak

    val = threshold * peakvalue

    # find boundary index on the right of the peak
    
    rightindex = 0

    while true
        rightindex += 1
        if avgcurve[peakindex + rightindex] <= val
            break
        end
    end

    absoluterightindex = peakindex + rightindex


    # find boundary index on the left of the peak
    
    leftindex = 0

    while true
        leftindex -= 1
        if avgcurve[peakindex + leftindex] <= val
            break
        end
    end

    absoluteleftindex = peakindex + leftindex


    # calculate and return centroid

    centroid = mean(τ[absoluteleftindex:absoluterightindex])
    
    return centroid

    # PLEASE KEEP FOR DEBUGGING PURPOSES
    # plot(τ[peakindex], peakvalue, "ro")
    # plot(τ[absoluteleftindex], avgcurve[absoluteleftindex], "go")
    # plot(τ[absoluterightindex], avgcurve[absoluterightindex], "bo")
    # @show leftindex rightindex centroid

end