## TODO recap: draw a sine wave
x <- seq(0, pi*2, 0.1)
plot(x, sin(x))
plot(x, sin(x), type = 'l', xlim = c(0, pi*2))

?curve
curve(sin, from = 0, to = 2*pi)

## TODO how to plot 2x+1?
## first, define custom functions to plot 2x+1
f <- function(x) 2 * x + 1
f
f(5)
f(pi)
str(f(1:5))

## now we store a sequence from 1 to 5 by 0.1 as x and plot f(x)
x <- seq(1, 5, 0.1)
plot(x, f(x))
plot(x, f(x), type = 'l')
plot(x, f(x), type = 'l', xlab = '', main = '2x+1')
grid()

## TODO draw 2x+1 (black) and x+3 (red)
curve(2*x + 1, from = 0, to = 50)
curve(x + 1, add = TRUE, col = 'red')

## TODO simulate Brownian motion (random walk) in 1D
round(runif(1))
round(runif(1))*2 - 1
sign(runif(1) - 0.5)
sign(runif(1, min = -0.5, max = 0.5))

## loop approach
set.seed(42)
x <- 0
for (i in 1:25) {
    x <- x + sign(runif(1) - 0.5)
}
x

## vectorized approach
round(runif(5))
round(runif(5))*2 - 1
cumsum(round(runif(25))*2 - 1)

plot(cumsum(round(runif(25))*2 - 1), type = 's')

## plot multiple simulations
set.seed(42)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

for (i in 2:6) {
    lines(cumsum(round(runif(25))*2 - 1), type = 's', col = i)
}

## pro tipp: set ylim to accommodate all possible outcomes
plot(c(1, 25), c(-25, 25), type = 'n')
plot(NULL, NULL, xlim = c(1, 25), ylim = c(-25, 25))

## pro tipp: use "sample" instead of transforming a random number between 0 and 1
sample(c(-1, 1), 25, replace = TRUE)

## pro tipp: create a new function generating these numbers
minus_or_plus <- function(n) {
    sample(c(-1, 1), n, replace = TRUE)
}
minus_or_plus(5)

## TODO plot a histogram of results running the above simulation for 1K times each with 500 rounds
res <- replicate(n = 1000, expr = sum(minus_or_plus(500)))
hist(res)

## TODO plot the histogram at the 400th iteration
res <- replicate(n = 1000, expr = sum(minus_or_plus(400)))
hist(res)

res <- replicate(n = 1000, expr = cumsum(minus_or_plus(500)))
hist(res[400, ])

res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
res <- do.call(cbind, res)
hist(res[400, ])

## better to store simulations in rows
res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
res <- do.call(rbind, res)
hist(res[, 400])

## NOTE simplify it right away
res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)

## TODO plot a histogram doing the same simulation but after the 100th, 200th, 300th etc iteration
library(animation)
saveGIF({
    for (i in 1:500) {
        hist(res[i, ])
    }
})

library(animation)
ani.options(interval = 0.5)
saveGIF({
    for (i in seq(1, 500, by = 25)) {
        hist(res[i, ], main = i)
        abline(v = mean(res[i, ]), col = 'red')
    }
})

## TODO compute the minimum value for each simulation
?lapply
?sapply
?replicate
?apply

apply(res, 1, min)
apply(res, 2, min)
