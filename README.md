# ICCF 

This is a Julia implementation of interpolated cross-correlation function.

To install and use this package, please add first the registry [AINJuliaRegistry](https://github.com/HITS-AIN/AINJuliaRegistry).

This package exposes the function `iccf`, which can be queried in help mode for more information.

## Example 1

This is a toy example between two signals where the delay is set to 2.

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

```
using ICCF
using GPCCData # must be independently installed
using PyPlot # must be independently installed

tobs, yobs, σobs,  = readdataset(source = "3C120");

delays, ccf = iccf(y1 = yobs[1], y2 = yobs[2], t1 = tobs[1], t2 = tobs[2], maxτ = 140)

figure(); plot(delays, ccf, "ko-")
```
