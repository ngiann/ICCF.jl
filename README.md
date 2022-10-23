# ICCF 

Julia implementation of interpolated cross-correlation function.

This package exposes the function `iccf`, which can be queried in help mode for more information.

## Example 1

This is a toy example between two signals where the delay is set to 2.

```
using ICCF, PyPlot

# define signals
signal(x) = sin(x) + 4*exp(-2*(x-3)^2)
shiftedsignal(x) = signal(x-2)

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
delays, ccf = iccf(; t1 = t1, t2 = t2, y1 = y1, y2 = y2, minτ = 0.0, maxτ = 12, dτ = 0.1, showplot = false)

# plot outcome
figure()
plot(delays,ccf,"o--")
```

## Example 2

```
using GPCCData
```
