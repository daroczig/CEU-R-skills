## #############################################################################
## back to time-series for a bit!

library(binancer)
prices <- binance_klines('BTCUSDT', interval = '1h')
## binance_klines
## binance_query
## binancer:::binance_query
## https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1d

## recap on basic plots
btcprice <- ts(prices$close)
btcprice <- ts(prices$close, frequency = 7)
plot(btcprice)
library(forecast)
autoplot(btcprice)

## keep time on the x axis for plotting and forecasting
library(xts)
btcprice <- xts(prices$close, order.by = prices$close_time, frequency = 7)
plot(btcprice)
autoplot(btcprice)
autoplot(forecast(prices))
autoplot(forecast(ma(btcprice, 7)))

## TODO heatmap => avg closing price per hour of the day (0-24) + day of the week (Mon-Sun)
str(prices)
library(lubridate)
prices[, hod := hour(open_time)]
prices[, dow := wday(open_time)]
?wday
prices[, .(price = mean(close)), by = .(hod, dow)]

library(ggplot2)
ggplot(prices[, .(price = mean(close)), by = .(hod, dow)],
       aes(hod, dow, fill = price)) + geom_tile()

?wday
prices[, dow := wday(open_time, label = TRUE)]
ggplot(prices[, .(price = mean(close)), by = .(hod, dow)],
       aes(hod, dow, fill = price)) + geom_tile()

## TODO plot BTC and ETH prices in USD on the same plot
btc <- binance_klines('BTCUSDT', interval = '1h')
eth <- binance_klines('ETHUSDT', interval = '1h')

ggplot(btc, aes(close_time, close)) + geom_line()

ggplot() +
  geom_line(data = btc, aes(close_time, close), color = 'blue') +
  geom_line(data = eth, aes(close_time, close), color = 'red')

prices <- merge(
    btc[, .(close_time, btc = close)],
    eth[, .(close_time, eth = close)],
    by = 'close_time')

## reshape2 -> cast, dcast, melt
?melt

library(data.table)
ggplot(melt(prices, id.vars = 'close_time'), aes(close_time, value, color = variable)) + geom_line()
ggplot(melt(prices, id.vars = 'close_time'), aes(close_time, value)) +
    geom_line() + facet_wrap(~variable, scales = 'free')

## periods, intervals, durations, eg:
Sys.time()

now()
now(tzone = 'UTC')

now() + days(1)
now() + weeks(2)

date(now() + weeks(2))

wday(now() + hours(100))
wday(now() + hours(100), label = TRUE)

## daylight savings
dst(now())
dst(now() - weeks(8))
leap_year(now())
leap_year(now() + years(2))

floor_date(now(), unit = 'day')
floor_date(now(), unit = 'month')
floor_date(now(), unit = 'year')
floor_date(now(), unit = 'quarter')
ceiling_date(now(), unit = 'quarter')

## duration
dhours(100)
str(dhours(100))

duration(100, unit = 'min')
duration(hour = 1, min = 40)
duration("1H 40M")

duration("1H 40M") > "1H"

## interval length (back to base)
difftime(now(), date('2018-01-01'))
difftime(now(), date('2018-01-01'), units = 'hours')

## #############################################################################
## analysis: Portland, Oregon's Biketown PDX data

## http://biketownpdx.socialbicycles.com/opendata/gbfs.json
rides <- fread('http://bit.ly/CEU-R-bikes')

rides[, date := as.Date(StartDate, format = '%m/%d/%Y')]
?as.Date
?as.POSIXct

rides[, date := mdy(StartDate)]
rides[, start_time := mdy_hm(paste(StartDate, StartTime))]
rides[, end_time := mdy_hm(paste(EndDate, EndTime))]
## warning?
rides[is.na(end_time)]

## TODO compute duration
rides[, duration := difftime(end_time, start_time)]
rides
rides[, duration := difftime(end_time, start_time, unit = 'mins')]
rides
rides[, duration := as.numeric(difftime(end_time, start_time, unit = 'mins'))]
rides[, mean(duration, na.rm = TRUE)]
## hm
rides[, summary(duration, na.rm = TRUE)]
rides[duration > 60*24]
rides[duration < 0]

## filter for good records
rides <- rides[duration > 0 & duration < 60*24*7]
rides[, mean(duration, na.rm = TRUE)]

## TODO compute distance eg via the Haversine formula
library(geosphere)
?distHaversine
distHaversine(rides[1, .(StartLongitude, StartLatitude)], rides[1, .(EndLongitude, EndLatitude)])
distHaversine(rides[1:5, .(StartLongitude, StartLatitude)], rides[1:5, .(EndLongitude, EndLatitude)])
rides[1:5, duration]

rides[, distance := distHaversine(
    cbind(StartLongitude, StartLatitude),
    cbind(EndLongitude, EndLatitude))]

plot(rides$distance, rides$duration)
cor(rides$distance, rides$duration)
summary(lm(rides$distance ~ rides$duration))
mean(rides$distance, na.rm = TRUE)
mean(rides$duration, na.rm = TRUE)

## meters per minute
mean(rides$distance / rides$duration, na.rm = TRUE)
mean(rides$distance / rides$duration, na.rm = TRUE) * 60 / 1000
