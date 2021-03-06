# Stochastic Trends can be handled by ARIMA
# Seasonal Effects - Seasonal ARIMA
# Conditional Heteroscedastic effects - ARCH/GARCh
# diff(z, d=3) for repeated difference
# Simulate ARIMA(1,1,1)
set.seed(2)
x <- arima.sim(list(order = c(1,1,1), ar = 0.6, ma=-0.5), n = 1000)
# Non stationary time series with stochastic trending component
plot(x)

# Fit ARIMA
x.arima <- arima(x, order = c(1,1,1))
x.arima
# CI for AR and MA parameters
0.6470 + c(-1.96, 1.96)*0.1065
-0.5165 + c(-1.96, 1.96)*0.1189
# Both parameter estimates fall within CI
# Residuals as the Discrete White Noise (DWN)
acf(resid(x.arima))
# Box-Ljung test to check the model
Box.test(resid(x.arima), lag=20, type = "Ljung-Box")
# p-value = .5191 is > 0.05 and therefore DWN is a godd fit to residuals
# Financial Data and Prediction
library(quantmod)
library(forecast)
#Amazon
getSymbols("AMZN", from="2013-01-01")
amzn = diff(log(Cl(AMZN))) # already taken first order difference
# Find the best ARIMA model
azfinal.aic <- Inf
azfinal.order <- c(0,0,0)
for (p in 1:4) 
  for (d in 0:1) 
    for (q in 1:4) {
      azcurrent.aic <- AIC(arima(amzn, order=c(p, d, q)))
      if (azcurrent.aic < azfinal.aic) {
        azfinal.aic <- azcurrent.aic    
        azfinal.order <- c(p, d, q)    
        azfinal.arima <- arima(amzn, order=azfinal.order)  
     }
    }
azfinal.order # ARIMA(4,0,4)
acf(resid(azfinal.arima), na.action=na.omit) # residual as DWN or not
# Perfect fit visible
# Ljung-Box test for p-value
Box.test(resid(azfinal.arima), lag=20, type="Ljung-Box")
# p-value = .9911 > 0.05 and hence we have evidence for good fit at 95% level
# Forecast using forecast library
plot(forecast(azfinal.arima, h=25))
# 25 days ahead, 95% dark blue, 99% light blue

# S&P 500
getSymbols("^GSPC", from="2013-01-01")
sp = diff(log(Cl(GSPC))) # already taken first order difference
# Find the best ARIMA model
spfinal.aic <- Inf
spfinal.order <- c(0,0,0)
for (p in 1:4) 
  for (d in 0:1) 
    for (q in 1:4) {
      spcurrent.aic <- AIC(arima(sp, order=c(p, d, q)))
      if (spcurrent.aic < spfinal.aic) {
        spfinal.aic <- spcurrent.aic
        spfinal.order <- c(p, d, q)
        spfinal.arima <- arima(sp, order=spfinal.order) 
      }
    }
spfinal.order # ARIMA(1,0,2)
acf(resid(spfinal.arima), na.action=na.omit) # residual as DWN or not
# Perfect fit visible but long term memory effects
# Ljung-Box test for p-value
Box.test(resid(spfinal.arima), lag=20, type="Ljung-Box")
# p-value = .7148 > 0.05 and hence we have evidence for good fit at 95% level
# Forecast using forecast library
plot(forecast(spfinal.arima, h=25))
# 25 days ahead, 95% dark blue, 99% light blue
# In quantitative finance, trying to determine periods of differing volatility 
# is often known as "regime detection". It is one of the harder tasks to achiev.
# Hence 2007-08, volatile period is been excluded