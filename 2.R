## recap from last week
minus_or_plus <- function(n) {
    sample(c(-1, 1), n, replace = TRUE)
}
minus_or_plus(5)

res <- replicate(n = 1000, expr = sum(minus_or_plus(500)))
str(res)
hist(res)

res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
res <- do.call(cbind, res)
str(res)
hist(res[500, ])

res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
hist(res[500, ])

## TODO rerun with setting the rnd seed to 42
set.seed(42)
res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))

## TODO list all simulation when the value did not become negative
which(apply(res, 2, min) > 0)
## eg
res[, 23]

## TODO roll 3 dices! 1-6 x 3
sample(1:6, 3, replace = TRUE)

## TODO roll 3 dices 1K times and plot the sum of points
dices <- function() sample(1:6, 3, replace = TRUE)
dices_sum <- function() sum(dices())
dices_sum()
hist(replicate(1000, dices_sum()))
## NOTE interesting, should be symmetric?

hist(replicate(100000, dices_sum()))
hist(replicate(1e5, dices_sum()))
table(replicate(1e5, dices_sum()))
barplot(table(replicate(1e5, dices_sum())))
hist(replicate(1e5, dices_sum()), breaks = 2:18)

## TODO how many times out of 1K rolls we had the same points on each dice?
set.seed(42)
res <- replicate(1000, dices())
str(res)
which(apply(res, 2, sd) == 0)
res[, 58]
length(which(apply(res, 2, sd) == 0))

## TODO playing on roulette – always bet on red (or 18-36)
roulette <- function() sample(0:36, 1)
wallet <- 100
bet <- 1
for (i in 1:100) {
    wallet <- wallet - bet
    number <- roulette()
    if (number > 18) {
        cat('win!\n')
        wallet <- wallet + bet * 2
    } else {
        cat('lost :(\n')
    }
}
wallet

## advanced logging
library(futile.logger)
flog.info('Win!')
flog.error('Duh :/')

## TODO vectorize
sum(ifelse(sample(0:36, 100, replace = TRUE) > 18, 1, -1))

## #############################################################################

## NOTE read.csv -> readxl from the Internet for MDS

## distance between 40 Hungarian cities -> 2D scatterplot
download.file('http://bit.ly/hun-cities-distance', 'cities.xls')
## on windows
download.file('http://bit.ly/hun-cities-distance', 'cities.xls', mode = 'wb')

library(readxl)
cities <- read_excel('cities.xls')
str(cities)

## get rid of 1st column and last row (metadata)
cities <- cities[, -1]
cities <- cities[-nrow(cities), ]

mds <- cmdscale(as.dist(cities))
mds

plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## flipping both x and y axis
mds <- -mds
plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## non-geo example
?mtcars
str(mtcars)
mtcars

mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))

mds <- as.data.frame(mds)
library(ggplot2)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text() + theme_bw()

library(ggrepel)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text_repel() + theme_bw()

## NOTE think about why the above visualization is off
