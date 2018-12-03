This is the R script repository of the "[R Skills](https://courses.ceu.edu/courses/r-skills)" course in the 2018/2019 Fall term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU.

## Table of Contents

* [Syllabus](https://github.com/daroczig/CEU-R-skills#syllabus)
* [Technical Prerequisites](https://github.com/daroczig/CEU-R-skills#technical-prerequisites)
* [Class Schedule](https://github.com/daroczig/CEU-R-skills#class-schedule)

    * [Week 1](https://github.com/daroczig/CEU-R-skills#week-1-100-min-writing-loops)
    * [Week 2](https://github.com/daroczig/CEU-R-skills#week-2-100-min-more-loops)
    * [Week 3](https://github.com/daroczig/CEU-R-skills#week-3-100-min-intro-to-time-series-analysis)
    * [Week 4](https://github.com/daroczig/CEU-R-skills#week-4-100-min-intro-to-spatial-data)
    * [Week 5](https://github.com/daroczig/CEU-R-skills#week-5-100-min-recap-on-time-series-and-spatial-data)
    * [Week 6](https://github.com/daroczig/CEU-R-skills#week-6-100-min-presenting-insights)

* [Contact](https://github.com/daroczig/CEU-R-lab#contacts)

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

Please bring your own laptop and make sure to install the below items **before** attending the first class:

1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://www.rstudio.com/products/rstudio/download
3. Register an account at https://github.com
4. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:

```r
install.packages('ggplot2')
library(ggplot2)
ggplot(diamonds, aes(cut)) + geom_bar()
```

Optional steps I highly suggest to do as well before attending the class if you plan to use `git`:

4. Bookmark, watch or star this repository so that you can easily find it later
5. Install `git` from https://git-scm.com/
6. Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
7. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
8. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
9. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial if in doubt or [contact me](#contact).

## Class Schedule

### Week 1 (100 min): Writing Loops

* Recap on generating sequence and drawing `base` plots: [1.R](1.R#L1)
* Intro to writing custom functions: [1.R](1.R#L9)
* Exercises on 1D random walk: [1.R](1.R#L28)

    * Writing loops: [1.R](1.R#L34)
    * Vectorized approach: [1.R](1.R#L42)
    * Custom function: [1.R](1.R#L64)
    
* `lapply`, `sapply`, `do.call`: [1.R](1.R#L70)
* Creating animation by iterating plots: [1.R](1.R#L96)
* `apply` on matrices: [1.R](1.R#L113)

### Week 2 (100 min): More Loops

* Recap on 1D random walk (sim): [2.R](2.R#L1)
* Rolling 3 dices (sim): [2.R](2.R#L29)
* Roulette (sim): [2.R](2.R#L53)
* Reading Excel spreadsheet: [2.R](2.R#L79)
* Dimension reduction with MDS for plotting: [2.R](2.R#L94)

<details>
  <summary>Homework</summary>
  
```
1. Set the seed to 42 and run a simulation 1000 times: playing roulette for 100 rounds, starting with $100 budget, always betting $1 on numbers 18-36 in each round. After saving the results in a helper variable, answer the below questions by using your saved results:

  - Draw a histogram on the (1000) resulting budgets at the end of the 100-100 rounds.
  - What's the average amount of lost dollars in 100 rounds?
  - How many times (out of 1000) did we win at least $1?
  
2. Draw a ggplot2 2D "map" of European cities by applying MDS on the "eurodist" dataset:

  - Start with a scatterplot.
  - Add the city names as labels to the scatterplot.
  - Fix the north-south and east-west orientation if needed.
```

</details>

Homework: check on Moodle

### Week 3 (100 min): Intro to Time-series Analysis

* Recap on MDS: [3.R](3.R#L1)
* Loading data from the Binance API: [3.R](3.R#L63)
* Defining and visualizing time-series: [3.R](3.R#L80)
* Decompose time-series into seasonal, trend and random components: [3.R](3.R#L84)
* The Naïve forecasting method: [3.R](3.R#L100)
* Moving averages: [3.R](3.R#L113)
* Exponential smoothing: [3.R](3.R#L118)
* ARIMA: [3.R](3.R#L129)
* The Naïve forecasting method: [3.R](3.R#L100)
* Analysing the amount of gasoline products supplied between 1991 and 2017: [3.R](3.R#L145)

Homework: check on Moodle

### Week 4 (100 min): Intro to Spatial Data

* General feedback on homework: [4.R](4.R#L1)
* Recap on merging datasets: [4.R](4.R#L44)
* Recap on aggregates: [4.R](4.R#L69)
* Recap on plotting: [4.R](4.R#L82)
* Geocoding: [4.R](4.R#L92)
* Plotting a map: [4.R](4.R#L125)
* Parsing data from the Internet: [4.R](4.R#L147)

Homework: check on Moodle

### Week 5 (100 min): Recap on Time Series and Spatial Data

* Extended time-series object: [5.R](5.R#L18)
* Drawing heatmaps: [5.R](5.R#L26)
* Plotting from multiple datasets: [5.R](5.R#L43)
* Time periods, intervals, duration: [5.R](5.R#L66)
* Case study of Portland's Biketown PDX data: [5.R](5.R#L106)

Homework: check on Moodle

### Week 6 (100 min): Presenting Insights

* [Example R Markdown document](6.Rmd)
* [Example Shiny app](6.R)

Final take-home assignment: check on Moodle

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-skills/issues).
