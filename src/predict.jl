function fluxprediction(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest)

    _fluxprediction(; ttrain = ttrain.+delay, ytrain = ytrain, ttest = ttest)

end


function _fluxprediction(; ttrain = ttrain, ytrain = ytrain, ttest = ttest)

    f = linear_interpolation(ttrain, ytrain, extrapolation_bc = mean(ytrain))

    f(ttest)

end


function mseprediction(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest, ytest = ytest)

    ypred = fluxprediction(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest.+delay)

    mean(sum(ypred .- ytest).^2)

end