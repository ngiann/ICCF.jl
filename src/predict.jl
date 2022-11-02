function predict(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest)

    _predict(; ttrain = ttrain.+delay, ytrain = ytrain, ttest = ttest)

end


function _predict(; ttrain = ttrain, ytrain = ytrain, ttest = ttest)

    f = linear_interpolation(ttrain, ytrain, extrapolation_bc = mean(ytrain))

    f(ttest)

end


function mseprediction(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest, ytest = ytest)

    ypred = predict(delay; ttrain = ttrain, ytrain = ytrain, ttest = ttest.+delay)

    mean(sum(ypred .- ytest).^2)

end