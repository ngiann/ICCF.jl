function plotprogress(tleft, tright, τ, t1, t2, y1, y2, f2, tshifted, containedindices, score, index)

    figure(0)
    
    # First subplot shows how the 1st lightcurve is shifted
    # while the 2nd lightcurve stays fixed

    subplot(211); cla()

    title(@sprintf("delay is %f", τ))
    plot(t2,f2.(t2), "r", label="interpolated 2nd lightcurve", alpha=0.5)
    plot(t2, y2, "ro", label="observed 2nd lightcurve")
    plot(tshifted, y1, "bo", label="1st lightcurve, shifted")
    plot(tshifted[containedindices], y1[containedindices], "Pb", label = "points of 1st lightcurve in common interval", markersize=10)
    plot(tleft*ones(10), LinRange(minimum(y2),maximum(y2),10), "k--", label="tleft")
    plot(tright*ones(10), LinRange(minimum(y2),maximum(y2),10), "k", label="tright")
    xlim(min(minimum(t1),minimum(t2))-20, max(maximum(t1),maximum(t2))+20)
    legend()


    # Second subplot shows measure of overlap

    subplot(212); cla()

    title("measure of overlap (score array in code)")
    plot(1:index, score[1:index],"ko-")
    pause(0.01)

end