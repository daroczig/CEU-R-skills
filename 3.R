## #############################################################################
## recap from last week:
## applying MDS on mtcars and visualizing (dis)similarity of cars

mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))

library(ggplot2)
library(ggrepel)
mds <- as.data.frame(mds)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text_repel() + theme_bw()

ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text_repel() + theme_bw() +
    xlim(c(-200, 200)) + ylim(c(-200, 200))

## check actual distances eg for Camaro
which(rownames(mtcars) == 'Camaro Z28')
sort(as.matrix(dist(mtcars))[, 24])

## but we made a terrible mistake ... the measurement units are not standardized any more!

library(data.table)
data.table(mtcars)
dtcars <- data.table(mtcars, keep.rownames = TRUE)
setorder(dtcars, rn)
dtcars
dtcars[order(hp)]

dtcars$hp
dtcars$disp
dtcars$am

summary(mtcars)

## need to standardize to give every variable equal weight!
dtcars$hp - mean(dtcars$hp)
mean(dtcars$hp - mean(dtcars$hp))

(x <- (dtcars$hp - mean(dtcars$hp)) / sd(dtcars$hp))
mean(x)
sd(x)
hist(x)

x
scale(dtcars$hp)
plot(x, scale(dtcars$hp))
x - scale(dtcars$hp)

?scale

## check distances again for Camaro
sort(as.matrix(dist(scale(mtcars)))[, 24])

## visualize it
mds <- cmdscale(dist(scale(mtcars)))
mds <- as.data.frame(mds)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text_repel() + theme_bw()

## #############################################################################
## other data sources ... public data, APIs etc
## eg https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md

## install package from GitHub with the devtools or remotes package
devtools::install_github('daroczig/binancer')

## use the package to download time-series data from the above reference API
library(binancer)
binance_klines('ETHBTC')
binance_klines('ETHBTC', interval = '1h')

## #############################################################################
## intro to time-series analysis

prices <- binance_klines('BTCUSDT', interval = '1h')

## create a time-series (ts) with a frequency of 24,
## where the 24 hours in a day refers to the daily seasonality that we expect in the data
plot(ts(prices$close, frequency = 24))

## decompose time-series into trend + seasonal + irregular components
plot(decompose(ts(prices$close, frequency = 24)))

## loading daily data and setting the frequency to 7 for weekly seasonality
prices <- binance_klines('BTCUSDT', interval = '1d')
prices <- ts(prices$close, frequency = 7)
plot(prices)

plot(decompose(prices))
str(decompose(prices))
## the effects of weekdays
decompose(prices)$seasonal[1:7]

library(forecast)
plot(prices)

## naïve forecasting: using the most recent value as a forecast
fit <- naive(prices)
fit

plot(forecast(fit))

## visualize raw data and values used in the forecast
plot(fit)
lines(fitted(fit), col = 'red')

## in-sample accuracy metrics of the prediction
accuracy(fit)

## moving averages
lines(ma(prices, 2), col = 'red')
lines(ma(prices, 7), col = 'blue')
lines(ma(prices, 4*7), col = 'green')

## using exponential smoothing for forecasting
fit <- ses(prices)
fit

plot(forecast(fit))

plot(fit)
lines(fitted(fit), col = 'red')

accuracy(fit)

## Autoregressive integrated moving average with auto-tuned parameters
fit <- auto.arima(prices)
fit

plot(forecast(fit))

plot(prices)
lines(fitted(fit), col = 'red')

accuracy(fit)

## other forecasting methods
plot(forecast(ets(prices)))
plot(forecast(tbats(prices)))
plot(forecast(nnetar(prices)))

## #############################################################################
## analyzing the amount of gasoline products supplied between 1991 and 2017

library(fpp2)
## https://otexts.org/fpp2/
## https://www.datacamp.com/courses/forecasting-using-r

gasoline
?gasoline

plot(gasoline)
autoplot(gasoline)

## forecasts with default options
forecast(gasoline)
autoplot(forecast(gasoline))

## using different forecasting methods and checking on the resulting forecasts and accuracy

naive(gasoline)
autoplot(forecast(naive(gasoline)))

## forecasting 52 weeks (1 year)
autoplot(forecast(naive(gasoline, h = 52)))

## check accuracy metrics when forecasting the next 4 weeks
accuracy(forecast(naive(gasoline, 4)))

ma(gasoline, 4)
ses(gasoline)

autoplot(forecast(ses(gasoline)))
autoplot(forecast(ses(gasoline, h = 52)))

accuracy(forecast(ses(gasoline, 4)))

?hw
?ets

fit <- ets(gasoline)
fit <- ets(ts(gasoline, frequency = 4))
autoplot(forecast(fit, h = 52))

accuracy(forecast(fit, h = 4))

## other, much slower methods
auto.arima(gasoline)
tbats(gasoline)
nnetar(gasoline)

## putting all the above together to print the in-sample accuracy metrics when forecasting 4 weeks
rbindlist(list(
    data.table(method = 'naive', as.data.frame(accuracy(forecast(naive(gasoline))))),
    data.table(method = 'ses', as.data.frame(accuracy(forecast(ses(gasoline, 4))))),
    data.table(method = 'ets', as.data.frame(accuracy(forecast(ets(gasoline), 4)))),
    data.table(method = 'ets4', as.data.frame(accuracy(forecast(ets(ts(gasoline, frequency = 4)), 4)))),
    data.table(method = 'arima', as.data.frame(accuracy(forecast(auto.arima(gasoline), 4)))),
    data.table(method = 'tbats', as.data.frame(accuracy(forecast(tbats(gasoline), 4)))),
    data.table(method = 'nnetar', as.data.frame(accuracy(forecast(nnetar(gasoline), 4))))))

## see also
?tsCV
