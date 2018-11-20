## #############################################################################
## homework

Set the seed to 42 and run a simulation 1000 times: playing roulette for 100 rounds, starting with $100 budget, always betting $1 on numbers 18-36 in each round. After saving the results in a helper variable, answer the below questions by using your saved results: ...

## #############################################################################
## not so nice solution

foobar=100
for (i in   1:100) {
        foobar <- foobar- 1
if (sample(0:36, 1) > 18) {
   #     foobar <- foobar +???# 1
 #    bet *3
        foobar <- foobar + 2
  }
foobar}

## #############################################################################
## nice solution

## Helper functions to play roulette for the simulation

#' Play a number of roulette games betting on a number larger than 18
#' @param budget total player starting budget
#' @param plays number of roulette bets to make and play
#' @param bet the size of each bet
#' @return the final net budget after playing all of the games with a minumum of 0
play_roulette <- function(budget, plays, bet) {
    res <- budget + sum(ifelse(sample(0:36, plays, replace = TRUE) > 18, +bet, -bet))
    if (res < 0) {
        print("BANKRUPT")
        return(0)
    }
    return(res)
}

## 1.1 Set the seed to 42
set.seed(42)

## 1.1 Run a simulation 1000 times
res <- replicate(1000, play_roulette(100, 100, 1))

## #############################################################################
## merging data

library(data.table)
bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
features <- fread('http://bit.ly/CEU-R-hotels-2018-features')

## compute the average price per night for each booking
bookings[, price_per_night := price / nnights]

## create new dataset including all the features on the hotels we have +
## number of bookings + average price per night
hotels <- merge(
    features,
    bookings[, .(
        bookings = .N,
        price_per_night = mean(price_per_night)), by = hotel_id],
    by = 'hotel_id')

## compute average price per night per country
hotels[, .(price_per_night = mean(price_per_night)), by = country]

## NOTE need for weighting
hotels[, .(price_per_night = weighted.mean(price_per_night, bookings)), by = country]

## create a country-level dataset including
##  - the number of hotels
##  - average distance of the hotels from the city center
##  - average rating weighted by the number of bookings
##  - average price per night weighted by the number of bookings
countries <- hotels[, .(
    hotels = .N,
    hotel_distance = mean(distance),
    rating = weighted.mean(rating, bookings, na.rm = TRUE),
    price_per_night = weighted.mean(price_per_night, bookings)),
    by = country]
countries

## plot the rating VS price per night
library(ggplot2)
ggplot(countries, aes(rating, price_per_night)) + geom_point()
ggplot(countries, aes(rating, price_per_night, size = hotels)) + geom_point()
ggplot(countries, aes(rating, price_per_night, label = country)) + geom_text()
ggplot(countries, aes(rating, price_per_night, label = country, size = hotels)) + geom_text()

## similar results? how to group countries? maybe geo?
library(ggmap)

geocode('CEU, Budapest')
?register_google

geocode('CEU, Budapest', source = 'dsk')
## paste to chrome ... reverse lat lot ... Budapest?
geocode('Budapest, Nador utca 9', source = 'dsk', )
geocode('Budapest, Nador utca 9', source = 'dsk', output = 'all')
## Google is much smarter to find eg CEU + lot of extra metadata ... but not free

geocode(countries[1, country], source = 'dsk')

for (i in 1:nrow(countries)) {
    geocode <- geocode(countries[i, country], source = 'dsk')
    countries[i, lon := geocode$lon]
    countries[i, lat := geocode$lat]
}
## TODO while it's running, copy and paste a URL into the browser
## http://www.datasciencetoolkit.org/maps/api/geocode/json?address=Hungary&sensor=false
warnings()
countries
## write.csv(countries, '/tmp/hotels_countries_geo.csv', row.names = FALSE, na = '')
## countries <- fread('http://bit.ly/CEU-R-hotels-2018-countries')

## plot the location of the countries
ggplot(countries, aes(lon, lat, label = country)) + geom_text()

## plot the avg rating of the countries
ggplot(countries, aes(lon, lat, label = country, color = rating)) + geom_text()
ggplot(countries, aes(lon, lat, size = rating)) + geom_point()

## plot the prices per night in the countries
ggplot(countries, aes(lon, lat, size = price_per_night)) + geom_point()

## plot over map
worldmap <- map_data('world')
str(worldmap)
ggplot() +
    geom_polygon(data = worldmap, aes(x = long, y = lat, group = group)) +
    geom_point(data = countries, aes(lon, lat, size = price_per_night), color = 'orange') +
    coord_fixed(1.3)

## plot over Europe
europe <- get_map(location = 'Berlin', zoom = 4, maptype = 'terrain')
europe <- get_map(location = 'Berlin', zoom = 4, maptype = 'terrain', api_key = key)

center <- countries[country == 'Germany', c(lon = lon, lat = lat)]
center <- c(left = -12, bottom = 35, right = 30, top = 63)

europe <- get_map(location = center, zoom = 4, source = 'stamen', maptype = 'toner')
europe <- get_map(location = center, zoom = 4, source = 'stamen', maptype = 'watercolor')
## http://maps.stamen.com

ggmap(europe) +
    geom_point(data = countries, aes(lon, lat, size = price_per_night), color = 'orange')

## TODO add further data ... eg why some countries might be similar besides geo?
library(XML)
## NOTE rvest
gdp <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita'), which = 3)
gdp <- readHTMLTable(readLines('http://bit.ly/CEU-R-gdp'), which = 3, header = TRUE)
head(gdp)

gdp <- data.table(gdp)

gdp[, country := iconv(`Country/Territory\n`, to = 'ASCII', sub = '')]
gdp[, gdp := as.numeric(sub(',', '', `Int$\n`))]

countries$country %in% gdp$country
## \o/

countries <- merge(countries, gdp[, .(country, gdp)], by = 'country')

ggplot(countries, aes(gdp, price_per_night)) + geom_point()
ggplot(countries, aes(gdp, price_per_night)) + geom_point() + geom_smooth(method = 'lm')

