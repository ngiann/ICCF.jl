# ICCF 

This is a Julia implementation of interpolated cross-correlation function.

Apart from cloning, an easy way of using the package is the following:

1 - Add the registry [AINJuliaRegistry](https://github.com/HITS-AIN/AINJuliaRegistry).

2 - Switch into "package mode" with ```]``` and add the package with
```
add ICCF
```

This package exposes the functions `iccf`, `bootstrapanalysis` and `resamplingwithnoise`, which can be queried in help mode.

## Example 1

This is a toy example regarding two signals where one is delayed by 2 units relative to ther other.

```
using ICCF
using PyPlot # must be independently installed

delay = 2

# define signals
signal(x) = sin(x) + 4*exp(-2*(x-3)^2)
shiftedsignal(x) = signal(x-delay)

# generate observations
σnoise = 0.2
numobs = 25
t1, t2 = sort(rand(numobs)) * 10, sort(rand(numobs)) * 10
y1 = signal.(t1) + σnoise*randn(numobs)
y2 = shiftedsignal.(t2) + σnoise*randn(numobs)

# plot observations
figure()
plot(t1, y1, "bo", label="observed 1st lightcurve")
plot(t2, y2, "ro", label="observed 2nd lightcurve")

# run iccf
delays, ccf = iccf(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, minτ = 0.0, maxτ = 10, dτ = 0.1, showplot = false)

# plot outcome
figure()
plot(delays,ccf,"o--")
```

## Example 2

This is an example of running ICCF on a pair of observed lighcurves.

```
using ICCF
using GPCCData # must be independently installed
using PyPlot # must be independently installed

tobs, yobs, σobs,  = readdataset(source = "3C120");

delays, ccf = iccf(y1 = yobs[1], y2 = yobs[2], t1 = tobs[1], t2 = tobs[2], maxτ = 140)

figure(); plot(delays, ccf, "ko-")
```


## Example 3

This is an example that shows what a resampled lightcurve looks like.

```
using ICCF
using GPCCData # must be independently installed
using PyPlot # must be independently installed

tobs, yobs, σobs,  = readdataset(source = "3C120");

tres, yres = resamplingwithnoise(t=tobs[1], y=yobs[1], σ=σobs[1],seed=1)

figure(); plot(tres, yres, "ko-"); title("resampled lightcurve")
```


## Example 4

This is an example that uses function `bootstrapanalysis` to obtain a set of samples of the centroid for real observations.

```
using ICCF
using GPCCData # must be independently installed
using PyPlot # must be independently installed

tobs, yobs, σobs,  = readdataset(source = "3C120");

c = bootstrapanalysis(repeats = 5000, t1=tobs[1], t2=tobs[2], y1=yobs[1], y2=yobs[2], σ1=σobs[1], σ2=σobs[2], maxτ=140, dτ = 0.5);

figure(); hist(c);
```
