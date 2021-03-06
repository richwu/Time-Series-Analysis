# Moving Average Proces (MA(1), parameter = 0.6)
set.seed(1)
x <- w <- rnorm(100)
for (t in 2:100) 
  x[t] <- w[t] + 0.6*w[t-1]
layout(1:2)
plot(x, type="l")
acf(x) # for k(lag) > q(number of parameters), acf = 0

# Simulate moving average to fit the above generated series
# Arima function, setting AR and Integrated paramter = 0
x.ma <- arima(x, order=c(0, 0, 1)) 
x.ma
# Ouput shows Standard erord, estimated variance
# loglikelihood and Akaike Information Criterion also
# Arima also intercept intercept term as it do no subtract mean value of series
# CI for parameter
0.6023 + c(-1.96, 1.96)*0.0827

# Moving Average Proces (MA(1), parameter = -0.6)
set.seed(1)
x2 <- w <- rnorm(100)
for (t in 2:100) 
  x2[t] <- w[t] -0.6*w[t-1]
layout(1:2)
plot(x2, type="l")
acf(x2) # for k(lag) > q(number of parameters), acf = 0

# Simulate moving average to fit the above generated series
# Arima function, setting AR and Integrated paramter = 0
x2.ma <- arima(x2, order=c(0, 0, 1)) 
x2.ma
# CI for parameter
-0.7298 + c(-1.96, 1.96)* 0.1008 

# MA(3) - significant peaks at k =1,2,3 and insignificant peaks for k > 3
# parameters - 0.6,0.4,0.2
set.seed(3)
x3 <- w <- rnorm(1000)
for (t in 4:1000) 
  x3[t] <- w[t] + 0.6*w[t-1] + 0.4*w[t-2] + 0.2*w[t-3]
layout(1:2)
plot(x3, type="l")
acf(x3)

# Fit MA(3)
x3.ma <- arima(x3, order=c(0, 0, 3))
x3.ma
# CI of paramters
0.6081 + c(-1.96, 1.96)* 0.0309
0.3776 + c(-1.96, 1.96)* 0.0357
0.1731 + c(-1.96, 1.96)* 0.0323
# All parameters are in the CI
# Good fit

# Fitiing MA on financial data
# Amazon
library(quantmod)
getSymbols("AMZN")
amznrt = diff(log(Cl(AMZN))) # log returns
# Fitting MA(1)
amznrt.ma <- arima(amznrt, order=c(0, 0, 1))
amznrt.ma
layout(1,1)
acf(amznrt.ma$res[-1]) # we find that it is not a good fit
# Fitting MA(2)
amznrt.ma2 <- arima(amznrt, order=c(0, 0, 2))
amznrt.ma2
layout(1,1)
acf(amznrt.ma2$res[-1]) # we find that it is not a good fit, long memory effects
# Fitting MA(3)
amznrt.ma3 <- arima(amznrt, order=c(0, 0, 3))
amznrt.ma3
layout(1,1)
acf(amznrt.ma3$res[-1]) # we find that it is not a good fit
# MA(3) similar to MA(2), can`t explain long term effects

# MA on S&P Index
getSymbols("^GSPC")
gspcrt = diff(log(Cl(GSPC))) # Log returns
# Fitting MA(1)
gspcrt.ma <- arima(gspcrt, order=c(0, 0, 1))
gspcrt.ma
acf(gspcrt.ma$res[-1]) # Not a good fit
# Fitting MA(2)
gspcrt.ma2 <- arima(gspcrt, order=c(0, 0, 2))
gspcrt.ma2
acf(gspcrt.ma2$res[-1]) # Not a good fit
# Fitting MA(3)
gspcrt.ma3 <- arima(gspcrt, order=c(0, 0, 3))
gspcrt.ma3
acf(gspcrt.ma3$res[-1]) # Not a good fit
 