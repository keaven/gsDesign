<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/gsDesign)](https://CRAN.R-project.org/package=gsDesign)
[![Codecov test coverage](https://codecov.io/gh/keaven/gsDesign/branch/master/graph/badge.svg)](https://codecov.io/gh/keaven/gsDesign?branch=master)
[![R build status](https://github.com/keaven/gsDesign/workflows/R-CMD-check/badge.svg)](https://github.com/keaven/gsDesign/actions)
[![pkgdown](https://github.com/keaven/gsDesign/workflows/pkgdown/badge.svg)]
!-- badges: end -->

# gsDesign 

The gsDesign package supports group sequential clinical trial design.
An easy-to-use [web interface](https://gsdesign.shinyapps.io/prod/) to both enable usage without coding and to generate code to be able to reproduce the design. 

While there is a strong focus on designs using **α** and **β** spending functions, Wang-Tsiatis designs, including O'Brien-Fleming and Pocock designs, are also available. The ability to design with non-binding futility rules allows control of Type I error in a manner acceptable to regulatory authorities when futility bounds are employed. Particular effort has gone into designs with time-to-event endpoints.

Most routines are designed to provide simple access to commonly used designs using default arguments. Standard, published spending functions are supported as well as the ability to write custom spending functions. A plot function provides a wide variety of plots summarizing designs: boundaries, power, estimated treatment effect at boundaries, conditional power at boundaries, spending function plots, expected sample size plot, and B-values at boundaries.

While the main design functions, ```gsDesign()``` and ```gsSurv()``` have a complex output, the function ```gsBoundSummary()``` provides a simple summary of a design in a data frame that can be useful for printing in a document.

Thus, the intent of the gsDesign package is to easily create, fully characterize and even optimize routine group sequential trial designs as well as provide a tool to evaluate innovative designs.

Updates in late 2018 and early 2019 largely enabled by Metrum Research Group (Devin Pastoor, Harsh Baid, Jonathan Sidi).
These include, but are not limited to, converting unit testing to use testthat package as well as developing the github web pages and implementing covrpage to document unit testing. Much earlier development, testing and documentation help were lead largely by Bill Constantine and Rich Calaway while they were with Revolution Computing. Thanks to John Lueders for his excellent and extensive collaboration building the Shiny app.
