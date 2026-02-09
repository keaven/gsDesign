# gsDesign

The gsDesign package supports group sequential clinical trial design,
largely as presented in the book Group Sequential Methods with
Applications to Clinical Trials by Christopher Jennison and Bruce
Turnbull (Chapman and Hall/CRC, 2000). An easy-to-use [web
interface](https://rinpharma.shinyapps.io/gsdesign/) to both enable
usage without coding and to generate code to be able to reproduce the
design; this is being enhanced to support more features on an ongoing
basis. See the [talk](https://www.youtube.com/watch?v=8uZRuvzma9M)
presented at the R/Pharma Conference to get started with the web
interface.

## Installation

``` r
# The easiest way to get gsDesign is to install:
install.packages("gsDesign")

# Alternatively, install development version from GitHub:
# install.packages("remotes")
remotes::install_github("keaven/gsDesign")
```

## Description

While there is a strong focus on designs using **α** and **β** spending
functions, Wang-Tsiatis designs, including O’Brien-Fleming and Pocock
designs, are also available. The ability to design with non-binding
futility rules allows control of Type I error in a manner acceptable to
regulatory authorities when futility bounds are employed. Particular
effort has gone into designs with time-to-event endpoints.

Most routines are designed to provide simple access to commonly used
designs using default arguments. Standard, published spending functions
are supported as well as the ability to write custom spending functions.
A plot function provides a wide variety of plots summarizing designs:
boundaries, power, estimated treatment effect at boundaries, conditional
power at boundaries, spending function plots, expected sample size plot,
and B-values at boundaries.

While the main design functions,
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
and [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
have a complex output, the function
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
provides a simple summary of a design in a data frame that can be useful
for printing in a document.

Thus, the intent of the gsDesign package is to easily create, fully
characterize and even optimize routine group sequential trial designs as
well as provide a tool to evaluate innovative designs.

## A little history

In 2026 we have updated survival sample size and power methods
([`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)) to
allow methods by 1) Schoenfeld, 2) Freedman, and 3) Bernstein and
Lagakos. While we still recommend the default Lachin and Foulkes method,
these additions allow replication of results from other software.
Updates in late 2018 and early 2019 largely enabled by Metrum Research
Group (Devin Pastoor, Harsh Baid, Jonathan Sidi). These include, but are
not limited to, converting unit testing to use testthat package as well
as developing the github web pages and implementing covrpage to document
unit testing. Yilong Zhang implemented 3.1.1 continuous integration at
github. 2020 collaborations with Cytel, Inc. increased unit testing
coverage to \> 80% in version 3.2.0 from essential unit testing done
long ago. Much earlier development, testing and documentation help were
lead largely by Bill Constantine and Rich Calaway while they were with
Revolution Computing. Thanks to John Lueders for his excellent and
extensive collaboration building the Shiny app; more recent Shiny
development done by Nan Xiao adds significant features such as saving
and reloading designs and creating default Rmarkdown reports.
