module ICCF

    using Interpolations, Statistics, PyPlot, Printf, Random, ProgressMeter

    using MiscUtil: CVindices, taketestfold, taketrainfold
    
    include("iccf.jl")

    include("resamplingwithnoise.jl")

    include("plotprogress.jl")

    include("bootstrapanalysis.jl")

    include("centroid.jl")

    export iccf, resamplingwithnoise, bootstrapanalysis

end
