pkgname <- "gsDesign"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('gsDesign')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("as_gt")
### * as_gt

flush(stderr()); flush(stdout())

### Name: as_gt
### Title: Convert a summary table object to a gt object
### Aliases: as_gt as_gt.gsBinomialExactTable

### ** Examples

safety_design <- binomialSPRT(
  p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75
)
safety_power <- gsBinomialExact(
  k = length(safety_design$n.I),
  theta = seq(.02, .16, .02),
  n.I = safety_design$n.I,
  a = safety_design$lower$bound,
  b = safety_design$upper$bound
)
safety_power |>
  as_table() |>
  as_gt(
    theta_label = gt::html("Underlying<br>AE rate"),
    prob_decimals = 3,
    bound_label = c("low rate", "high rate")
  )



cleanEx()
nameEx("as_rtf")
### * as_rtf

flush(stderr()); flush(stdout())

### Name: as_rtf
### Title: Save a summary table object as an RTF file
### Aliases: as_rtf as_rtf.gsBinomialExactTable as_rtf.gsBoundSummary

### ** Examples

# as_rtf for gsBinomialExact
zz <- gsBinomialExact(
  k = 3, theta = seq(0.1, 0.9, 0.1), n.I = c(12, 24, 36),
  a = c(-1, 0, 11), b = c(5, 9, 12)
)
zz |>
  as_table() |>
  as_rtf(
    file = tempfile(fileext = ".rtf"),
    title = "Power/Type I Error and Expected Sample Size for a Group Sequential Design"
  )

safety_design <- binomialSPRT(
  p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75
)
safety_power <- gsBinomialExact(
  k = length(safety_design$n.I),
  theta = seq(.02, .16, .02),
  n.I = safety_design$n.I,
  a = safety_design$lower$bound,
  b = safety_design$upper$bound
)
safety_power |>
  as_table() |>
  as_rtf(
    file = tempfile(fileext = ".rtf"),
    theta_label = "Underlying\nAE Rate",
    prob_decimals = 3,
    bound_label = c("Low Rate", "High Rate")
  )
# as_rtf for gsBoundSummary
xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
gsBoundSummary(xgs, timename = "Year", tdigits = 1) |> as_rtf(file = tempfile(fileext = ".rtf"))

ss <- nSurvival(
  lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
  sided = 1, alpha = .025, ratio = 2
)
xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) |> as_rtf(file = tempfile(fileext = ".rtf"))

xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) |>
  as_rtf(file = tempfile(fileext = ".rtf"),
  footnote_specify = "Z",
  footnote_text = "Z-Score")



cleanEx()
nameEx("as_table")
### * as_table

flush(stderr()); flush(stdout())

### Name: as_table
### Title: Create a summary table
### Aliases: as_table as_table.gsBinomialExact

### ** Examples

b <- binomialSPRT(p0 = .1, p1 = .35, alpha = .08, beta = .2, minn = 10, maxn = 25)
b_power <- gsBinomialExact(
  k = length(b$n.I), theta = seq(.1, .45, .05), n.I = b$n.I,
  a = b$lower$bound, b = b$upper$bound
)
b_power |>
  as_table() |>
  as_gt()



cleanEx()
nameEx("binomialPowerTable")
### * binomialPowerTable

flush(stderr()); flush(stdout())

### Name: binomialPowerTable
### Title: Power Table for Binomial Tests
### Aliases: binomialPowerTable

### ** Examples

# Create a power table with analytical power calculation
power_table <- binomialPowerTable(
  pC = c(0.8, 0.9),
  delta = seq(-0.05, 0.05, 0.025),
  n = 70
)

# Create a power table with simulation
power_table_sim <- binomialPowerTable(
  pC = c(0.8, 0.9),
  delta = seq(-0.05, 0.05, 0.025),
  n = 70,
  simulation = TRUE,
  nsim = 10000
)



cleanEx()
nameEx("checkScalar")
### * checkScalar

flush(stderr()); flush(stdout())

### Name: checkLengths
### Title: Utility functions to verify variable properties
### Aliases: checkLengths checkRange checkScalar isInteger checkVector
### Keywords: programming

### ** Examples


# check whether input is an integer
isInteger(1)
isInteger(1:5)
try(isInteger("abc")) # expect error

# check whether input is an integer scalar
checkScalar(3, "integer")

# check whether input is an integer scalar that resides
# on the interval on [3, 6]. Then test for interval (3, 6].
checkScalar(3, "integer", c(3, 6))
try(checkScalar(3, "integer", c(3, 6), c(FALSE, TRUE))) # expect error

# check whether the input is an atomic vector of class numeric,
# of length 3, and whose value all reside on the interval [1, 10)
x <- c(3, pi, exp(1))
checkVector(x, "numeric", c(1, 10), c(TRUE, FALSE), length = 3)

# do the same but change the expected length; expect error
try(checkVector(x, "numeric", c(1, 10), c(TRUE, FALSE), length = 2))

# create faux function to check input variable
foo <- function(moo) checkVector(moo, "character")
foo(letters)
try(foo(1:5)) # expect error with function and argument name in message

# check for equal lengths of various inputs
checkLengths(1:2, 2:3, 3:4)
try(checkLengths(1, 2, 3, 4:5)) # expect error

# check for equal length inputs but ignore single element vectors
checkLengths(1, 2, 3, 4:5, 7:8, allowSingle = TRUE)





cleanEx()
nameEx("eEvents")
### * eEvents

flush(stderr()); flush(stdout())

### Name: eEvents
### Title: Expected number of events for a time-to-event study
### Aliases: eEvents print.eEvents
### Keywords: design

### ** Examples

# 3 enrollment periods, 3 piecewise exponential failure rates
str(eEvents(
  lambda = c(.05, .02, .01), eta = .01, gamma = c(5, 10, 20),
  R = c(2, 1, 2), S = c(1, 1), T = 20
))

# Control group for example from Bernstein and Lagakos (1978)
lamC <- c(1, .8, .5)
n <- eEvents(
  lambda = matrix(c(lamC, lamC * 2 / 3), ncol = 6), eta = 0,
  gamma = matrix(.5, ncol = 6), R = 2, T = 4
)



cleanEx()
nameEx("gsBinomialExact")
### * gsBinomialExact

flush(stderr()); flush(stdout())

### Name: gsBinomialExact
### Title: One-Sample Binomial Routines
### Aliases: gsBinomialExact print.gsBinomialExact binomialSPRT
###   plot.gsBinomialExact plot.binomialSPRT nBinomial1Sample
### Keywords: design

### ** Examples

library(ggplot2)

zz <- gsBinomialExact(
  k = 3, theta = seq(0.1, 0.9, 0.1), n.I = c(12, 24, 36),
  a = c(-1, 0, 11), b = c(5, 9, 12)
)

# let's see what class this is
class(zz)

# because of "gsProbability" class above, following is equivalent to
# \code{print.gsProbability(zz)}
zz

# also plot (see also plots below for \code{binomialSPRT})
# add lines using geom_line()
plot(zz) + 
ggplot2::geom_line()

# now for SPRT examples
x <- binomialSPRT(p0 = .05, p1 = .25, alpha = .1, beta = .2)
# boundary plot
plot(x)
# power plot
plot(x, plottype = 2)
# Response (event) rate at boundary
plot(x, plottype = 3)
# Expected sample size at boundary crossing or end of trial
plot(x, plottype = 6)

# sample size for single arm exact binomial

# plot of table of power by sample size
# note that outtype need not be specified if beta is NULL
nb1 <- nBinomial1Sample(p0 = 0.05, p1=0.2,alpha = 0.025, beta=NULL, n = 25:40)
nb1
library(scales)
ggplot2::ggplot(nb1, ggplot2::aes(x = n, y = Power)) + 
ggplot2::geom_line() + 
ggplot2::geom_point() + 
ggplot2::scale_y_continuous(labels = percent)

# simple call with same parameters to get minimum sample size yielding desired power
nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40)

# change to 'conservative' if you want all larger sample
# sizes to also provide adequate power
nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40, conservative = TRUE)

# print out more information for the selected derived sample size
nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40, conservative = TRUE,
 outtype = 2)
# Reproduce realized Type I error alphaR
stats::pbinom(q = 5, size = 39, prob = .05, lower.tail = FALSE)
# Reproduce realized power
stats::pbinom(q = 5, size = 39, prob = 0.2, lower.tail = FALSE)
# Reproduce critical value for positive finding
stats::qbinom(p = 1 - .025, size = 39, prob = .05) + 1
# Compute p-value for 7 successes
stats::pbinom(q = 6, size = 39, prob = .05, lower.tail = FALSE)
# what happens if input sample sizes not sufficient?
## Not run: 
##D  
##D   nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:30)
## End(Not run)



cleanEx()
nameEx("gsBound")
### * gsBound

flush(stderr()); flush(stdout())

### Name: gsBound
### Title: Boundary derivation - low level
### Aliases: gsBound gsBound1
### Keywords: design

### ** Examples


# set boundaries so that probability is .01 of first crossing
# each upper boundary and .02 of crossing each lower boundary
# under the null hypothesis
x <- gsBound(
  I = c(1, 2, 3) / 3, trueneg = rep(.02, 3),
  falsepos = rep(.01, 3)
)
x

#  use gsBound1 to set up boundary for a 1-sided test
x <- gsBound1(
  theta = 0, I = c(1, 2, 3) / 3, a = rep(-20, 3),
  probhi = c(.001, .009, .015)
)
x$b

# check boundary crossing probabilities with gsProbability
y <- gsProbability(k = 3, theta = 0, n.I = x$I, a = x$a, b = x$b)$upper$prob

#  Note that gsBound1 only computes upper bound
#  To get a lower bound under a parameter value theta:
#      use minus the upper bound as a lower bound
#      replace theta with -theta
#      set probhi as desired lower boundary crossing probabilities
#  Here we let set lower boundary crossing at 0.05 at each analysis
#  assuming theta=2.2
y <- gsBound1(
  theta = -2.2, I = c(1, 2, 3) / 3, a = -x$b,
  probhi = rep(.05, 3)
)
y$b

#  Now use gsProbability to look at design
#  Note that lower boundary crossing probabilities are as
#  specified for theta=2.2, but for theta=0 the upper boundary
#  crossing probabilities are smaller than originally specified
#  above after first interim analysis
gsProbability(k = length(x$b), theta = c(0, 2.2), n.I = x$I, b = x$b, a = -y$b)



cleanEx()
nameEx("gsBoundCP")
### * gsBoundCP

flush(stderr()); flush(stdout())

### Name: gsBoundCP
### Title: Conditional Power at Interim Boundaries
### Aliases: gsBoundCP
### Keywords: design

### ** Examples


# set up a group sequential design
x <- gsDesign(k = 5)
x

# compute conditional power based on interim treatment effects
gsBoundCP(x)

# compute conditional power based on original x$delta
gsBoundCP(x, theta = x$delta)



cleanEx()
nameEx("gsBoundSummary")
### * gsBoundSummary

flush(stderr()); flush(stdout())

### Name: summary.gsDesign
### Title: Bound Summary and Z-transformations
### Aliases: summary.gsDesign print.gsDesign gsBoundSummary xprint
###   print.gsBoundSummary gsBValue gsDelta gsRR gsHR gsCPz
### Keywords: design

### ** Examples

library(ggplot2)
# survival endpoint using gsSurv
# generally preferred over nSurv since time computations are shown
xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
gsBoundSummary(xgs, timename = "Year", tdigits = 1)
summary(xgs)

# survival endpoint using nSurvival
# NOTE: generally recommend gsSurv above for this!
ss <- nSurvival(
  lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
  sided = 1, alpha = .025, ratio = 2
)
xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio)
# generate some of the above summary statistics for the upper bound
z <- xs$upper$bound
# B-values
gsBValue(z = z, i = 1:3, x = xs)
# hazard ratio
gsHR(z = z, i = 1:3, x = xs)
# conditional power at observed treatment effect
gsCPz(z = z[1:2], i = 1:2, x = xs)
# conditional power at H1 treatment effect
gsCPz(z = z[1:2], i = 1:2, x = xs, theta = xs$delta)

# information-based design
xinfo <- gsDesign(delta = .3, delta1 = .3)
gsBoundSummary(xinfo, Nname = "Information")

# show all available boundary descriptions
gsBoundSummary(xinfo, Nname = "Information", exclude = NULL)

# add intermediate parameter value
xinfo <- gsProbability(d = xinfo, theta = c(0, .15, .3))
class(xinfo) # note this is still as gsDesign class object
gsBoundSummary(xinfo, Nname = "Information")

# now look at a binomial endpoint; specify H0 treatment difference as p1-p2=.05
# now treatment effect at bound (say, thetahat) is transformed to
# xp$delta0 + xp$delta1*(thetahat-xp$delta0)/xp$delta
np <- nBinomial(p1 = .15, p2 = .10)
xp <- gsDesign(n.fix = np, endpoint = "Binomial", delta1 = .05)
summary(xp)
gsBoundSummary(xp, deltaname = "p[C]-p[E]")
# estimate treatment effect at lower bound
# by setting delta0=0 (default) and delta1 above in gsDesign
# treatment effect at bounds is scaled to these differences
# in this case, this is the difference in event rates
gsDelta(z = xp$lower$bound, i = 1:3, xp)

# binomial endpoint with risk ratio estimates
n.fix <- nBinomial(p1 = .3, p2 = .15, scale = "RR")
xrr <- gsDesign(k = 2, n.fix = n.fix, delta1 = log(.15 / .3), endpoint = "Binomial")
gsBoundSummary(xrr, deltaname = "RR", logdelta = TRUE)
gsRR(z = xp$lower$bound, i = 1:3, xrr)
plot(xrr, plottype = "RR")

# delta is odds-ratio: sample size slightly smaller than for relative risk or risk difference
n.fix <- nBinomial(p1 = .3, p2 = .15, scale = "OR")
xOR <- gsDesign(k = 2, n.fix = n.fix, delta1 = log(.15 / .3 / .85 * .7), endpoint = "Binomial")
gsBoundSummary(xOR, deltaname = "OR", logdelta = TRUE)

# for nice LaTeX table output, use xprint
xprint(xtable::xtable(gsBoundSummary(xOR, deltaname = "OR", logdelta = TRUE),
  caption = "Table caption."
))



cleanEx()
nameEx("gsCP")
### * gsCP

flush(stderr()); flush(stdout())

### Name: gsCP
### Title: Conditional and Predictive Power, Overall and Conditional
###   Probability of Success
### Aliases: gsCP gsPP gsPI gsPosterior gsPOS gsCPOS
### Keywords: design

### ** Examples

library(ggplot2)
# set up a group sequential design
x <- gsDesign(k = 5)
x

# set up a prior distribution for the treatment effect
# that is normal with mean .75*x$delta and standard deviation x$delta/2
mu0 <- .75 * x$delta
sigma0 <- x$delta / 2
prior <- normalGrid(mu = mu0, sigma = sigma0)

# compute POS for the design given the above prior distribution for theta
gsPOS(x = x, theta = prior$z, wgts = prior$wgts)

# assume POS should only count cases in prior where theta >= x$delta/2
gsPOS(x = x, theta = prior$z, wgts = prior$wgts * (prior$z >= x$delta / 2))

# assuming a z-value at lower bound at analysis 2, what are conditional
# boundary crossing probabilities for future analyses
# assuming theta values from x as well as a value based on the interim
# observed z
CP <- gsCP(x, i = 2, zi = x$lower$bound[2])
CP

# summing values for crossing future upper bounds gives overall
# conditional power for each theta value
CP$theta
t(CP$upper$prob) %*% c(1, 1, 1)

# compute predictive probability based on above assumptions
gsPP(x, i = 2, zi = x$lower$bound[2], theta = prior$z, wgts = prior$wgts)

# if it is known that boundary not crossed at interim 2, use
# gsCPOS to compute conditional POS based on this
gsCPOS(x = x, i = 2, theta = prior$z, wgts = prior$wgts)

# 2-stage example to compare results to direct computation
x <- gsDesign(k = 2)
z1 <- 0.5
n1 <- x$n.I[1]
n2 <- x$n.I[2] - x$n.I[1]
thetahat <- z1 / sqrt(n1)
theta <- c(thetahat, 0, x$delta)

# conditional power direct computation - comparison w gsCP
pnorm((n2 * theta + z1 * sqrt(n1) - x$upper$bound[2] * sqrt(n1 + n2)) / sqrt(n2))

gsCP(x = x, zi = z1, i = 1)$upper$prob

# predictive power direct computation - comparison w gsPP
# use same prior as above
mu0 <- .75 * x$delta * sqrt(x$n.I[2])
sigma2 <- (.5 * x$delta)^2 * x$n.I[2]
prior <- normalGrid(mu = .75 * x$delta, sigma = x$delta / 2)
gsPP(x = x, zi = z1, i = 1, theta = prior$z, wgts = prior$wgts)
t <- .5
z1 <- .5
b <- z1 * sqrt(t)
# direct from Proschan, Lan and Wittes eqn 3.10
# adjusted drift at n.I[2]
pnorm(((b - x$upper$bound[2]) * (1 + t * sigma2) +
  (1 - t) * (mu0 + b * sigma2)) /
  sqrt((1 - t) * (1 + sigma2) * (1 + t * sigma2)))

# plot prior then posterior distribution for unblinded analysis with i=1, zi=1
xp <- gsPosterior(x = x, i = 1, zi = 1, prior = prior)
plot(x = xp$z, y = xp$density, type = "l", col = 2, xlab = expression(theta), ylab = "Density")
points(x = x$z, y = x$density, col = 1)

# add posterior plot assuming only knowlede that interim bound has
# not been crossed at interim 1
xpb <- gsPosterior(x = x, i = 1, zi = 1, prior = prior)
lines(x = xpb$z, y = xpb$density, col = 4)

# prediction interval based in interim 1 results
# start with point estimate, followed by 90% prediction interval
gsPI(x = x, i = 1, zi = z1, j = 2, theta = prior$z, wgts = prior$wgts, level = 0)
gsPI(x = x, i = 1, zi = z1, j = 2, theta = prior$z, wgts = prior$wgts, level = .9)



cleanEx()
nameEx("gsDensity")
### * gsDensity

flush(stderr()); flush(stdout())

### Name: gsDensity
### Title: Group sequential design interim density function
### Aliases: gsDensity
### Keywords: design

### ** Examples

library(ggplot2)
# set up a group sequential design
x <- gsDesign()

# set theta values where density is to be evaluated
theta <- x$theta[2] * c(0, .5, 1, 1.5)

# set zi values from -1 to 7 where density is to be evaluated
zi <- seq(-3, 7, .05)

# compute subdensity values at analysis 2
y <- gsDensity(x, theta = theta, i = 2, zi = zi)

# plot sub-density function for each theta value
plot(y$zi, y$density[, 3],
  type = "l", xlab = "Z",
  ylab = "Interim 2 density", lty = 3, lwd = 2
)
lines(y$zi, y$density[, 2], lty = 2, lwd = 2)
lines(y$zi, y$density[, 1], lwd = 2)
lines(y$zi, y$density[, 4], lty = 4, lwd = 2)
title("Sub-density functions at interim analysis 2")
legend(
  x = c(3.85, 7.2), y = c(.27, .385), lty = 1:5, lwd = 2, cex = 1.5,
  legend = c(
    expression(paste(theta, "=0.0")),
    expression(paste(theta, "=0.5", delta)),
    expression(paste(theta, "=1.0", delta)),
    expression(paste(theta, "=1.5", delta))
  )
)

# add vertical lines with lower and upper bounds at analysis 2
# to demonstrate how likely it is to continue, stop for futility
# or stop for efficacy at analysis 2 by treatment effect
lines(rep(x$upper$bound[2], 2), c(0, .4), col = 2)
lines(rep(x$lower$bound[2], 2), c(0, .4), lty = 2, col = 2)

# Replicate part of figures 8.1 and 8.2 of Jennison and Turnbull text book
# O'Brien-Fleming design with four analyses

x <- gsDesign(k = 4, test.type = 2, sfu = "OF", alpha = .1, beta = .2)

z <- seq(-4.2, 4.2, .05)
d <- gsDensity(x = x, theta = x$theta, i = 4, zi = z)

plot(z, d$density[, 1], type = "l", lwd = 2, ylab = expression(paste(p[4], "(z,", theta, ")")))
lines(z, d$density[, 2], lty = 2, lwd = 2)
u <- x$upper$bound[4]
text(expression(paste(theta, "=", delta)), x = 2.2, y = .2, cex = 1.5)
text(expression(paste(theta, "=0")), x = .55, y = .4, cex = 1.5)



cleanEx()
nameEx("gsDesign")
### * gsDesign

flush(stderr()); flush(stdout())

### Name: gsDesign
### Title: Design Derivation
### Aliases: gsDesign xtable.gsDesign
### Keywords: design

### ** Examples

library(ggplot2)
#  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#  lower bound is non-binding (ignored in Type I error computation)
#  sample size is computed based on a fixed design requiring n=800
x <- gsDesign(k = 5, test.type = 2, n.fix = 800)

# note that "x" below is equivalent to print(x) and print.gsDesign(x)
x
plot(x)
plot(x, plottype = 2)

# Assuming after trial was designed actual analyses occurred after
# 300, 600, and 860 patients, reset bounds
y <- gsDesign(
  k = 3, test.type = 2, n.fix = 800, n.I = c(300, 600, 860),
  maxn.IPlan = x$n.I[x$k]
)
y

#  asymmetric design with user-specified spending that is non-binding
#  sample size is computed relative to a fixed design with n=1000
sfup <- c(.033333, .063367, .1)
sflp <- c(.25, .5, .75)
timing <- c(.1, .4, .7)
x <- gsDesign(
  k = 4, timing = timing, sfu = sfPoints, sfupar = sfup, sfl = sfPoints,
  sflpar = sflp, n.fix = 1000
)
x
plot(x)
plot(x, plottype = 2)

# same design, but with relative sample sizes
gsDesign(
  k = 4, timing = timing, sfu = sfPoints, sfupar = sfup, sfl = sfPoints,
  sflpar = sflp
)



cleanEx()
nameEx("gsProbability")
### * gsProbability

flush(stderr()); flush(stdout())

### Name: gsProbability
### Title: Boundary Crossing Probabilities
### Aliases: gsProbability print.gsProbability
### Keywords: design

### ** Examples

library(ggplot2)
# making a gsDesign object first may be easiest...
x <- gsDesign()

# take a look at it
x

# default plot for gsDesign object shows boundaries
plot(x)

# \code{plottype=2} shows boundary crossing probabilities
plot(x, plottype = 2)

# now add boundary crossing probabilities and
# expected sample size for more theta values
y <- gsProbability(d = x, theta = x$delta * seq(0, 2, .25))
class(y)

# note that "y" below is equivalent to \code{print(y)} and
# \code{print.gsProbability(y)}
y

# the plot does not change from before since this is a
# gsDesign object; note that theta/delta is on x axis
plot(y, plottype = 2)

# now let's see what happens with a gsProbability object
z <- gsProbability(
  k = 3, a = x$lower$bound, b = x$upper$bound,
  n.I = x$n.I, theta = x$delta * seq(0, 2, .25)
)

# with the above form,  the results is a gsProbability object
class(z)
z

# default plottype is now 2
# this is the same range for theta, but plot now has theta on x axis
plot(z)



cleanEx()
nameEx("gsSurvCalendar")
### * gsSurvCalendar

flush(stderr()); flush(stdout())

### Name: gsSurvCalendar
### Title: Group sequential design with calendar-based timing of analyses
### Aliases: gsSurvCalendar

### ** Examples

# First example: while timing is calendar-based, spending is event-based
x <- gsSurvCalendar() |> toInteger()
gsBoundSummary(x)

# Second example: both timing and spending are calendar-based
# This results in less spending at interims and leaves more for final analysis
y <- gsSurvCalendar(spending = "calendar") |> toInteger()
gsBoundSummary(y)

# Note that calendar timing for spending relates to planned timing for y
# rather than timing in y after toInteger() conversion

# Values plugged into spending function for calendar time
y$usTime
# Actual calendar fraction from design after toInteger() conversion
y$T / max(y$T)



cleanEx()
nameEx("nNormal")
### * nNormal

flush(stderr()); flush(stdout())

### Name: nNormal
### Title: Normal distribution sample size (2-sample)
### Aliases: nNormal
### Keywords: design

### ** Examples


# EXAMPLES
# equal variances
n=nNormal(delta1=.5,sd=1.1,alpha=.025,beta=.2)
n
x <- gsDesign(k = 3, n.fix = n, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(.5,.75),
sfu = sfLDOF, sfl = sfHSD, sflpar = -1, delta1 = 0.5, endpoint = 'normal') 
gsBoundSummary(x)
summary(x)
# unequal variances, fixed design
nNormal(delta1 = .5, sd = 1.1, sd2 = 2, alpha = .025, beta = .2)
# unequal sample sizes
nNormal(delta1 = .5, sd = 1.1, alpha = .025, beta = .2, ratio = 2)
# non-inferiority assuming a better effect than null
nNormal(delta1 = .5, delta0 = -.1, sd = 1.2)



cleanEx()
nameEx("nSurv")
### * nSurv

flush(stderr()); flush(stdout())

### Name: tEventsIA
### Title: Advanced time-to-event sample size calculation
### Aliases: tEventsIA nEventsIA nSurv gsSurv print.nSurv print.gsSurv
###   xtable.gsSurv
### Keywords: Bernstein Foulkes Freedman Lachin Lagakos Schoenfeld and
###   design hazards non-inferiority power proportional sample size
###   stratified super-superiority survival

### ** Examples


# Vary accrual rate gamma to obtain power
# T, minfup and R all specified, although R will be adjusted on output
# gamma as input will be multiplied in output to achieve desired power
# Default method is Lachin and Foulkes
x_nsurv <- nSurv(
  lambdaC = log(2) / 6, R = 10, hr = .5, eta = .001, gamma = 1,
  alpha = 0.02, beta = .15, T = 36, minfup = 12, method = "LachinFoulkes"
)
# Demonstrate print method
print(x_nsurv)
# Same assumptions for group sequential design
x_gs <- gsSurv(
  k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
  eta = .001, gamma = 1, T = 36, minfup = 12, method = "LachinFoulkes"
)
print(x_gs)
# Demonstrate xtable method for gsSurv
print(xtable::xtable(x_gs,
  footnote = "This is a footnote; note that it can be wide.",
  caption = "Caption example for xtable output."
))
# Demonstrate nEventsIA method
# find expected number of events at time 12 in the above trial
nEventsIA(x = x_gs, tIA = 10)

# find time at which 1/4 of events are expected
tEventsIA(x = x_gs, timing = .25)

# Adjust accrual duration R to achieve desired power
# Trial duration T input as NULL and will be computed based on
# accrual duration R and minimum follow-up duration minfup
# Minimum follow-up duration minfup is specified
# We use the Schoenfeld method to compute accrual duration R
# Control median survival time is 6
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  alpha = .025, beta = .1, minfup = 12, T = NULL, method = "Schoenfeld"
)
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  T = 36, minfup = 12, method = "Schoenfeld"
) |>
  print()

# Vary minimum follow-up duration minfup to obtain power
# Accrual duration R rate gamma are fixed and will not change on output.
# Trial duration T and minimum follow-up minfup are input as NULL
# and will be computed on output.
# We will use the Freedman method to compute sample size
# Control median survival time is 6
# Often this method will fail as the accrual duration and rate provide too
# little or too much sample size.
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6, R = 25,
  alpha = .025, beta = .1, minfup = NULL, T = NULL, method = "Freedman"
)
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  T = 36, minfup = 12, method = "Freedman"
) |>
  print()

# piecewise constant enrollment rates (vary accrual rate to achieve power)
# also piecewise constant failure rates
# will specify annualized enrollment and failure rates
nSurv(
  lambdaC = -log(c(.95, .97, .98)), # 5%, 3% and 2% annual failure rates
  S = c(1, 1), # 1 year duration for first 2 failure rates, 3rd continues indefinitely
  R = c(.25, .25, 1.5), # 2-year enrollment with ramp-up over first 1/2 year
  gamma = c(1, 3, 6), # 1, 3 and 6 annualized enrollment rates will be
  # multiplied by ratio to achieve desired power
  hr = .5, eta = -log(1 - .01), # 1% annual censoring rate
  minfup = 3, T = 5, # 5-year trial duration with 3-year minimum follow-up
  alpha = .025, beta = .1, method = "LachinFoulkes"
)
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = -log(c(.95, .97, .98)), # 5%, 3% and 2% annual failure rates
  S = c(1, 1), # 1 year duration for first 2 failure rates, 3rd continues indefinitely
  R = c(.25, .25, 1.5), # 2-year enrollment with ramp-up over first 1/2 year
  gamma = c(1, 3, 6), # 1, 3 and 6 annualized enrollment rates will be
  # multiplied by ratio to achieve desired power
  hr = .5, eta = -log(1 - .01), # 1% annual censoring rate
  minfup = 3, T = 5, # 5-year trial duration with 3-year minimum follow-up
  alpha = .025, beta = .1, method = "LachinFoulkes"
) |>
  print()

# combine it all: 2 strata, 2 failure rate periods
# Note that method = "LachinFoulkes" may be preferred here
nSurv(
  lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
  eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
  gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12,
  alpha = .025, beta = .1, method = "BernsteinLagakos"
)
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
  eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
  gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12,
  alpha = .025, beta = .1, method = "BernsteinLagakos"
) |>
  print()

# Example to compute power for a fixed design.
# Trial duration T, minimum follow-up minfup and accrual duration R are all
# specified and will not change on output.
# beta=NULL will compute power and output will be the same as if beta were specified.
# This option is not available for group sequential designs.
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6, R = 25,
  alpha = .025, beta = NULL, minfup = 12, T = 36, method = "LachinFoulkes"
) |>
  print()



cleanEx()
nameEx("nSurvival")
### * nSurvival

flush(stderr()); flush(stdout())

### Name: print.nSurvival
### Title: Time-to-event sample size calculation (Lachin-Foulkes)
### Aliases: print.nSurvival nSurvival nEvents zn2hr hrn2z hrz2n
### Keywords: design

### ** Examples

library(ggplot2)

# consider a trial with
# 2 year maximum follow-up
# 6 month uniform enrollment
# Treatment/placebo hazards = 0.1/0.2 per 1 person-year
# drop out hazard 0.1 per 1 person-year
# alpha = 0.025 (1-sided)
# power = 0.9 (default beta=.1)

ss <- nSurvival(
  lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
  sided = 1, alpha = .025
)

#  group sequential translation with default bounds
#  note that delta1 is log hazard ratio; used later in gsBoundSummary summary
x <- gsDesign(
  k = 5, test.type = 2, n.fix = ss$nEvents, nFixSurv = ss$n,
  delta1 = log(ss$lambda2 / ss$lambda1)
)
# boundary plot
plot(x)
# effect size plot
plot(x, plottype = "hr")
# total sample size
x$nSurv
# number of events at analyses
x$n.I
# print the design
x
# overall design summary
cat(summary(x))
# tabular summary of bounds
gsBoundSummary(x, deltaname = "HR", Nname = "Events", logdelta = TRUE)



# approximate number of events required using Schoenfeld's method
# for 2 different hazard ratios
nEvents(hr = c(.5, .6), tbl = TRUE)
# vector output
nEvents(hr = c(.5, .6))

# approximate power using Schoenfeld's method
# given 2 sample sizes and hr=.6
nEvents(hr = .6, n = c(50, 100), tbl = TRUE)
# vector output
nEvents(hr = .6, n = c(50, 100))

# approximate hazard ratio corresponding to 100 events and z-statistic of 2
zn2hr(n = 100, z = 2)
# same when hr0 is 1.1
zn2hr(n = 100, z = 2, hr0 = 1.1)
# same when hr0 is .9 and hr1 is greater than hr0
zn2hr(n = 100, z = 2, hr0 = .9, hr1 = 1)

# approximate number of events corresponding to z-statistic of 2 and
# estimated hazard ratio of .5 (or 2)
hrz2n(hr = .5, z = 2)
hrz2n(hr = 2, z = 2)

# approximate z statistic corresponding to 75 events
# and estimated hazard ratio of .6 (or 1/.6)
# assuming 2-to-1 randomization of experimental to control
hrn2z(hr = .6, n = 75, ratio = 2)
hrn2z(hr = 1 / .6, n = 75, ratio = 2)



cleanEx()
nameEx("normalGrid")
### * normalGrid

flush(stderr()); flush(stdout())

### Name: normalGrid
### Title: Normal Density Grid
### Aliases: normalGrid
### Keywords: design

### ** Examples

library(ggplot2)
#  standard normal distribution
x <- normalGrid(r = 3)
plot(x$z, x$wgts)

#  verify that numerical integration replicates sigma
#  get grid points and weights
x <- normalGrid(mu = 2, sigma = 3)

# compute squared deviation from mean for grid points
dev <- (x$z - 2)^2

# multiply squared deviations by integration weights and sum
sigma2 <- sum(dev * x$wgts)

# square root of sigma2 should be sigma (3)
sqrt(sigma2)

# do it again with larger r to increase accuracy
x <- normalGrid(r = 22, mu = 2, sigma = 3)
sqrt(sum((x$z - 2)^2 * x$wgts))

# this can also be done by combining gridwgts and density
sqrt(sum((x$z - 2)^2 * x$gridwgts * x$density))

# integrate normal density and compare to built-in function
# to compute probability of being within 1 standard deviation
# of the mean
pnorm(1) - pnorm(-1)
x <- normalGrid(bounds = c(-1, 1))
sum(x$wgts)
sum(x$gridwgts * x$density)

# find expected sample size for default design with
# n.fix=1000
x <- gsDesign(n.fix = 1000)
x

# set a prior distribution for theta
y <- normalGrid(r = 3, mu = x$theta[2], sigma = x$theta[2] / 1.5)
z <- gsProbability(
  k = 3, theta = y$z, n.I = x$n.I, a = x$lower$bound,
  b = x$upper$bound
)
z <- gsProbability(d = x, theta = y$z)
cat(
  "Expected sample size averaged over normal\n prior distribution for theta with \n mu=",
  x$theta[2], "sigma=", x$theta[2] / 1.5, ":",
  round(sum(z$en * y$wgt), 1), "\n"
)
plot(y$z, z$en,
  xlab = "theta", ylab = "E{N}",
  main = "Expected sample size for different theta values"
)
lines(y$z, z$en)



cleanEx()
nameEx("plot.gsDesign")
### * plot.gsDesign

flush(stderr()); flush(stdout())

### Name: plot.gsDesign
### Title: Plots for group sequential designs
### Aliases: plot.gsDesign plot.gsProbability
### Keywords: design

### ** Examples

library(ggplot2)
#  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#  lower bound is non-binding (ignored in Type I error computation)
#  sample size is computed based on a fixed design requiring n=100
x <- gsDesign(k = 5, test.type = 2, n.fix = 100)
x

# the following translate to calls to plot.gsDesign since x was
# returned by gsDesign; run these commands one at a time
plot(x)
plot(x, plottype = 2)
plot(x, plottype = 3)
plot(x, plottype = 4)
plot(x, plottype = 5)
plot(x, plottype = 6)
plot(x, plottype = 7)

#  choose different parameter values for power plot
#  start with design in x from above
y <- gsProbability(
  k = 5, theta = seq(0, .5, .025), x$n.I,
  x$lower$bound, x$upper$bound
)

# the following translates to a call to plot.gsProbability since
# y has that type
plot(y)



cleanEx()
nameEx("sequentiaPValue")
### * sequentiaPValue

flush(stderr()); flush(stdout())

### Name: sequentialPValue
### Title: Sequential p-value computation
### Aliases: sequentialPValue

### ** Examples


# Derive Group Sequential Design 
x <- gsSurv(k = 4, alpha = 0.025, beta = 0.1, timing = c(.5,.65,.8), sfu = sfLDOF,
            sfl = sfHSD, sflpar = 2, lambdaC = log(2)/6, hr = 0.6,
            eta = 0.01 , gamma = c(2.5,5,7.5,10), R = c( 2,2,2,6 ),
            T = 30 , minfup = 18)
x$n.I
# Analysis at IA2
sequentialPValue(gsD=x,n.I=c(100,160),Z=c(1.5,2))
# Use planned spending instead of information fraction; do final analysis
sequentialPValue(gsD=x,n.I=c(100,160,190,230),Z=c(1.5,2,2.5,3),usTime=x$timing)
# Check bounds for updated design to verify at least one was crossed
xupdate <- gsDesign(maxn.IPlan=max(x$n.I),n.I=c(100,160,190,230),usTime=x$timing,
                    delta=x$delta,delta1=x$delta1,k=4,alpha=x$alpha,test.type=1,
                    sfu=x$upper$sf,sfupar=x$upper$param)



cleanEx()
nameEx("sfDistribution")
### * sfDistribution

flush(stderr()); flush(stdout())

### Name: sfLogistic
### Title: Two-parameter Spending Function Families
### Aliases: sfLogistic sfBetaDist sfCauchy sfExtremeValue sfExtremeValue2
###   sfNormal
### Keywords: design

### ** Examples

library(ggplot2)
# design a 4-analysis trial using a Kim-DeMets spending function
# for both lower and upper bounds
x <- gsDesign(k = 4, sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 1.5)

# print the design
x

# plot the alpha- and beta-spending functions
plot(x, plottype = 5)

# start by showing how to fit two points with sfLogistic
# plot the spending function using many points to obtain a smooth curve
# note that curve fits the points x=.1,  y=.01 and x=.4,  y=.1
# specified in the 3rd parameter of sfLogistic
t <- 0:100 / 100
plot(t, sfLogistic(1, t, c(.1, .4, .01, .1))$spend,
  xlab = "Proportion of final sample size",
  ylab = "Cumulative Type I error spending",
  main = "Logistic Spending Function Examples",
  type = "l", cex.main = .9
)
lines(t, sfLogistic(1, t, c(.01, .1, .1, .4))$spend, lty = 2)

# now just give a=0 and b=1 as 3rd parameters for sfLogistic
lines(t, sfLogistic(1, t, c(0, 1))$spend, lty = 3)

# try a couple with unconventional shapes again using
# the xy form in the 3rd parameter
lines(t, sfLogistic(1, t, c(.4, .6, .1, .7))$spend, lty = 4)
lines(t, sfLogistic(1, t, c(.1, .7, .4, .6))$spend, lty = 5)
legend(
  x = c(.0, .475), y = c(.76, 1.03), lty = 1:5,
  legend = c(
    "Fit (.1, 01) and (.4, .1)", "Fit (.01, .1) and (.1, .4)",
    "a=0,  b=1", "Fit (.4, .1) and (.6, .7)",
    "Fit (.1, .4) and (.7, .6)"
  )
)

# set up a function to plot comparsons of all
# 2-parameter spending functions
plotsf <- function(alpha, t, param) {
  plot(t, sfCauchy(alpha, t, param)$spend,
    xlab = "Proportion of enrollment",
    ylab = "Cumulative spending", type = "l", lty = 2
  )
  lines(t, sfExtremeValue(alpha, t, param)$spend, lty = 5)
  lines(t, sfLogistic(alpha, t, param)$spend, lty = 1)
  lines(t, sfNormal(alpha, t, param)$spend, lty = 3)
  lines(t, sfExtremeValue2(alpha, t, param)$spend, lty = 6, col = 2)
  lines(t, sfBetaDist(alpha, t, param)$spend, lty = 7, col = 3)
  legend(
    x = c(.05, .475), y = .025 * c(.55, .9),
    lty = c(1, 2, 3, 5, 6, 7),
    col = c(1, 1, 1, 1, 2, 3),
    legend = c(
      "Logistic", "Cauchy", "Normal", "Extreme value",
      "Extreme value 2", "Beta distribution"
    )
  )
}
# do comparison for a design with conservative early spending
# note that Cauchy spending function is quite different
# from the others
param <- c(.25, .5, .05, .1)
plotsf(.025, t, param)



cleanEx()
nameEx("sfExponential")
### * sfExponential

flush(stderr()); flush(stdout())

### Name: sfExponential
### Title: Exponential Spending Function
### Aliases: sfExponential
### Keywords: design

### ** Examples

library(ggplot2)
# use 'best' exponential approximation for k=6 to O'Brien-Fleming design
# (see manual for details)
gsDesign(
  k = 6, sfu = sfExponential, sfupar = 0.7849295,
  test.type = 2
)$upper$bound

# show actual O'Brien-Fleming bound
gsDesign(k = 6, sfu = "OF", test.type = 2)$upper$bound

# show Lan-DeMets approximation
# (not as close as sfExponential approximation)
gsDesign(k = 6, sfu = sfLDOF, test.type = 2)$upper$bound

# plot exponential spending function across a range of values of interest
t <- 0:100 / 100
plot(t, sfExponential(0.025, t, 0.8)$spend,
  xlab = "Proportion of final sample size",
  ylab = "Cumulative Type I error spending",
  main = "Exponential Spending Function Example", type = "l"
)
lines(t, sfExponential(0.025, t, 0.5)$spend, lty = 2)
lines(t, sfExponential(0.025, t, 0.3)$spend, lty = 3)
lines(t, sfExponential(0.025, t, 0.2)$spend, lty = 4)
lines(t, sfExponential(0.025, t, 0.15)$spend, lty = 5)
legend(
  x = c(.0, .3), y = .025 * c(.7, 1), lty = 1:5,
  legend = c(
    "nu = 0.8", "nu = 0.5", "nu = 0.3", "nu = 0.2",
    "nu = 0.15"
  )
)
text(x = .59, y = .95 * .025, labels = "<--approximates O'Brien-Fleming")



cleanEx()
nameEx("sfHSD")
### * sfHSD

flush(stderr()); flush(stdout())

### Name: sfHSD
### Title: Hwang-Shih-DeCani Spending Function
### Aliases: sfHSD
### Keywords: design

### ** Examples

library(ggplot2)
# design a 4-analysis trial using a Hwang-Shih-DeCani spending function
# for both lower and upper bounds
x <- gsDesign(k = 4, sfu = sfHSD, sfupar = -2, sfl = sfHSD, sflpar = 1)

# print the design
x

# since sfHSD is the default for both sfu and sfl,
# this could have been written as
x <- gsDesign(k = 4, sfupar = -2, sflpar = 1)

# print again
x

# plot the spending function using many points to obtain a smooth curve
# show default values of gamma to see how the spending function changes
# also show gamma=1 which is supposed to approximate a Pocock design
t <- 0:100 / 100
plot(t, sfHSD(0.025, t, -4)$spend,
  xlab = "Proportion of final sample size",
  ylab = "Cumulative Type I error spending",
  main = "Hwang-Shih-DeCani Spending Function Example", type = "l"
)
lines(t, sfHSD(0.025, t, -2)$spend, lty = 2)
lines(t, sfHSD(0.025, t, 1)$spend, lty = 3)
legend(
  x = c(.0, .375), y = .025 * c(.8, 1), lty = 1:3,
  legend = c("gamma= -4", "gamma= -2", "gamma= 1")
)



cleanEx()
nameEx("sfLDOF")
### * sfLDOF

flush(stderr()); flush(stdout())

### Name: sfLDOF
### Title: Lan-DeMets Spending function overview
### Aliases: sfLDOF sfLDPocock
### Keywords: design

### ** Examples

library(ggplot2)
# 2-sided,  symmetric 6-analysis trial Pocock
# spending function approximation
gsDesign(k = 6, sfu = sfLDPocock, test.type = 2)$upper$bound

# show actual Pocock design
gsDesign(k = 6, sfu = "Pocock", test.type = 2)$upper$bound

# approximate Pocock again using a standard
# Hwang-Shih-DeCani approximation
gsDesign(k = 6, sfu = sfHSD, sfupar = 1, test.type = 2)$upper$bound

# use 'best' Hwang-Shih-DeCani approximation for Pocock,  k=6;
# see manual for details
gsDesign(k = 6, sfu = sfHSD, sfupar = 1.3354376, test.type = 2)$upper$bound

# 2-sided, symmetric 6-analysis trial
# O'Brien-Fleming spending function approximation
gsDesign(k = 6, sfu = sfLDOF, test.type = 2)$upper$bound

# show actual O'Brien-Fleming bound
gsDesign(k = 6, sfu = "OF", test.type = 2)$upper$bound

# approximate again using a standard Hwang-Shih-DeCani
# approximation to O'Brien-Fleming
x <- gsDesign(k = 6, test.type = 2)
x$upper$bound
x$upper$param

# use 'best' exponential approximation for k=6; see manual for details
gsDesign(
  k = 6, sfu = sfExponential, sfupar = 0.7849295,
  test.type = 2
)$upper$bound

# plot spending functions for generalized Lan-DeMets approximation of
ti <-(0:100)/100
rho <- c(.05,.5,1,1.5,2,2.5,3:6,8,10,12.5,15,20,30,200)/10
df <- NULL
for(r in rho){
  df <- rbind(df,data.frame(t=ti,rho=r,alpha=.025,spend=sfLDOF(alpha=.025,t=ti,param=r)$spend))
}
ggplot(df,aes(x=t,y=spend,col=as.factor(rho)))+
  geom_line()+
  guides(col=guide_legend(expression(rho)))+
  ggtitle("Generalized Lan-DeMets O'Brien-Fleming Spending Function")



cleanEx()
nameEx("sfLinear")
### * sfLinear

flush(stderr()); flush(stdout())

### Name: sfLinear
### Title: Piecewise Linear and Step Function Spending Functions
### Aliases: sfLinear sfStep
### Keywords: design

### ** Examples

library(ggplot2)
# set up alpha spending and beta spending to be piecewise linear
sfupar <- c(.2, .4, .05, .2)
sflpar <- c(.3, .5, .65, .5, .75, .9)
x <- gsDesign(sfu = sfLinear, sfl = sfLinear, sfupar = sfupar, sflpar = sflpar)
plot(x, plottype = "sf")
x

# now do an example where there is no lower-spending at interim 1
# and no upper spending at interim 2
sflpar <- c(1 / 3, 2 / 3, 0, .25)
sfupar <- c(1 / 3, 2 / 3, .1, .1)
x <- gsDesign(sfu = sfLinear, sfl = sfLinear, sfupar = sfupar, sflpar = sflpar)
plot(x, plottype = "sf")
x

# now do an example where timing of interims changes slightly, but error spending does not
# also, spend all alpha when at least >=90 percent of final information is in the analysis
sfupar <- c(.2, .4, .9, ((1:3) / 3)^3)
x <- gsDesign(k = 3, n.fix = 100, sfu = sfStep, sfupar = sfupar, test.type = 1)
plot(x, pl = "sf")
# original planned sample sizes
ceiling(x$n.I)
# cumulative spending planned at original interims
cumsum(x$upper$spend)
# change timing of analyses;
# note that cumulative spending "P(Cross) if delta=0" does not change from cumsum(x$upper$spend)
# while full alpha is spent, power is reduced by reduced sample size
y <- gsDesign(
  k = 3, sfu = sfStep, sfupar = sfupar, test.type = 1,
  maxn.IPlan = x$n.I[x$k], n.I = c(30, 70, 95),
  n.fix = x$n.fix
)
# note that full alpha is used, but power is reduced due to lowered sample size
gsBoundSummary(y)

# now show how step function can be abused by 'adapting' stage 2 sample size based on interim result
x <- gsDesign(k = 2, delta = .05, sfu = sfStep, sfupar = c(.02, .001), timing = .02, test.type = 1)
# spending jumps from miniscule to full alpha at first analysis after interim 1
plot(x, pl = "sf")
# sample sizes at analyses:
ceiling(x$n.I)
# simulate 1 million stage 1 sum of 178 Normal(0,1) random variables
# Normal(0,Variance=178) under null hypothesis
s1 <- rnorm(1000000, 0, sqrt(178))
# compute corresponding z-values
z1 <- s1 / sqrt(178)
# set stage 2 sample size to 1 if z1 is over final bound, otherwise full sample size
n2 <- rep(1, 1000000)
n2[z1 < 1.96] <- ceiling(x$n.I[2]) - ceiling(178)
# now sample n2 observations for second stage
s2 <- rnorm(1000000, 0, sqrt(n2))
# add sum and divide by standard deviation
z2 <- (s1 + s2) / (sqrt(178 + n2))
# By allowing full spending when final analysis is either
# early or late depending on observed interim z1,
# Type I error is now almost twice the planned .025
sum(z1 >= x$upper$bound[1] | z2 >= x$upper$bound[2]) / 1000000
# if stage 2 sample size is random and independent of z1 with same frequency,
# this is not a problem
s1alt <- rnorm(1000000, 0, sqrt(178))
z1alt <- s1alt / sqrt(178)
z2alt <- (s1alt + s2) / sqrt(178 + n2)
sum(z1alt >= x$upper$bound[1] | z2alt >= x$upper$bound[2]) / 1000000




cleanEx()
nameEx("sfPoints")
### * sfPoints

flush(stderr()); flush(stdout())

### Name: sfPoints
### Title: Pointwise Spending Function
### Aliases: sfPoints
### Keywords: design

### ** Examples

library(ggplot2)
# example to specify spending on a pointwise basis
x <- gsDesign(
  k = 6, sfu = sfPoints, sfupar = c(.01, .05, .1, .25, .5, 1),
  test.type = 2
)
x

# get proportion of upper spending under null hypothesis
# at each analysis
y <- x$upper$prob[, 1] / .025

# change to cumulative proportion of spending
for (i in 2:length(y))
  y[i] <- y[i - 1] + y[i]

# this should correspond to input sfupar
round(y, 6)

# plot these cumulative spending points
plot(1:6 / 6, y,
  main = "Pointwise spending function example",
  xlab = "Proportion of final sample size",
  ylab = "Cumulative proportion of spending",
  type = "p"
)

# approximate this with a t-distribution spending function
# by fitting 3 points
tx <- 0:100 / 100
lines(tx, sfTDist(1, tx, c(c(1, 3, 5) / 6, .01, .1, .5))$spend)
text(x = .6, y = .9, labels = "Pointwise Spending Approximated by")
text(x = .6, y = .83, "t-Distribution Spending with 3-point interpolation")

# example without lower spending at initial interim or
# upper spending at last interim
x <- gsDesign(
  k = 3, sfu = sfPoints, sfupar = c(.25, .25),
  sfl = sfPoints, sflpar = c(0, .25)
)
x




cleanEx()
nameEx("sfPower")
### * sfPower

flush(stderr()); flush(stdout())

### Name: sfPower
### Title: Kim-DeMets (power) Spending Function
### Aliases: sfPower
### Keywords: design

### ** Examples

library(ggplot2)
# design a 4-analysis trial using a Kim-DeMets spending function
# for both lower and upper bounds
x <- gsDesign(k = 4, sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 1.5)

# print the design
x

# plot the spending function using many points to obtain a smooth curve
# show rho=3 for approximation to O'Brien-Fleming and rho=.75 for
# approximation to Pocock design.
# Also show rho=2 for an intermediate spending.
# Compare these to Hwang-Shih-DeCani spending with gamma=-4,  -2,  1
t <- 0:100 / 100
plot(t, sfPower(0.025, t, 3)$spend,
  xlab = "Proportion of sample size",
  ylab = "Cumulative Type I error spending",
  main = "Kim-DeMets (rho) versus Hwang-Shih-DeCani (gamma) Spending",
  type = "l", cex.main = .9
)
lines(t, sfPower(0.025, t, 2)$spend, lty = 2)
lines(t, sfPower(0.025, t, 0.75)$spend, lty = 3)
lines(t, sfHSD(0.025, t, 1)$spend, lty = 3, col = 2)
lines(t, sfHSD(0.025, t, -2)$spend, lty = 2, col = 2)
lines(t, sfHSD(0.025, t, -4)$spend, lty = 1, col = 2)
legend(
  x = c(.0, .375), y = .025 * c(.65, 1), lty = 1:3,
  legend = c("rho= 3", "rho= 2", "rho= 0.75")
)
legend(
  x = c(.0, .357), y = .025 * c(.65, .85), lty = 1:3, bty = "n", col = 2,
  legend = c("gamma= -4", "gamma= -2", "gamma=1")
)



cleanEx()
nameEx("sfSpecial")
### * sfSpecial

flush(stderr()); flush(stdout())

### Name: sfTruncated
### Title: Truncated, trimmed and gapped spending functions
### Aliases: sfTruncated sfTrimmed sfGapped
### Keywords: design

### ** Examples



# Eliminate efficacy spending forany interim at or before 20 percent of information.
# Complete spending at first interim at or after 80 percent of information.
tx <- (0:100) / 100
s <- sfHSD(alpha = .05, t = tx, param = 1)$spend
x <- data.frame(t = tx, Spending = s, sf = "Original spending")
param <- list(trange = c(.2, .8), sf = sfHSD, param = 1)
s <- sfTruncated(alpha = .05, t = tx, param = param)$spend
x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Truncated"))
s <- sfTrimmed(alpha = .05, t = tx, param = param)$spend
x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Trimmed"))
s <- sfGapped(alpha = .05, t = tx, param = param)$spend
x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Gapped"))
ggplot2::ggplot(x, ggplot2::aes(x = t, y = Spending, col = sf)) + 
ggplot2::geom_line()


# now apply the sfTrimmed version in gsDesign
# initially, eliminate the early efficacy analysis
# note: final spend must occur at > next to last interim
x <- gsDesign(
  k = 4, n.fix = 100, sfu = sfTrimmed,
  sfupar = list(sf = sfHSD, param = 1, trange = c(.3, .9))
)

# first upper bound=20 means no testing there
gsBoundSummary(x)

# now, do not eliminate early efficacy analysis
param <- list(sf = sfHSD, param = 1, trange = c(0, .9))
x <- gsDesign(k = 4, n.fix = 100, sfu = sfTrimmed, sfupar = param)

# The above means if final analysis is done a little early, all spending can occur
# Suppose we set calendar date for final analysis based on
# estimated full information, but come up with only 97 pct of plan
xA <- gsDesign(
  k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], .97 * x$n.I[4]),
  test.type = x$test.type,
  maxn.IPlan = x$n.I[x$k],
  sfu = sfTrimmed, sfupar = param
)
# now accelerate without the trimmed spending function
xNT <- gsDesign(
  k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], .97 * x$n.I[4]),
  test.type = x$test.type,
  maxn.IPlan = x$n.I[x$k],
  sfu = sfHSD, sfupar = 1
)
# Check last bound if analysis done at early time
x$upper$bound[4]
# Now look at last bound if done at early time with trimmed spending function
# that allows capture of full alpha
xA$upper$bound[4]
# With original spending function, we don't get full alpha and therefore have
# unnecessarily stringent bound at final analysis
xNT$upper$bound[4]

# note that if the last analysis is LATE, all 3 approaches should give the same
# final bound that has a little larger z-value
xlate <- gsDesign(
  k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], 1.25 * x$n.I[4]),
  test.type = x$test.type,
  maxn.IPlan = x$n.I[x$k],
  sfu = sfHSD, sfupar = 1
)
xlate$upper$bound[4]

# eliminate futility after the first interim analysis
# note that by setting trange[1] to .2, the spend at t=.2 is used for the first
# interim at or after 20 percent of information
x <- gsDesign(n.fix = 100, sfl = sfGapped, sflpar = list(trange = c(.2, .9), sf = sfHSD, param = 1))



cleanEx()
nameEx("sfTDist")
### * sfTDist

flush(stderr()); flush(stdout())

### Name: sfTDist
### Title: t-distribution Spending Function
### Aliases: sfTDist
### Keywords: design

### ** Examples

library(ggplot2)
# 3-parameter specification: a,  b,  df
sfTDist(1, 1:5 / 6, c(-1, 1.5, 4))$spend

# 5-parameter specification fits 2 points,  in this case
# the 1st 2 interims are at 25% and 50% of observations with
# cumulative error spending of 10% and 20%, respectively
# final parameter is df
sfTDist(1, 1:3 / 4, c(.25, .5, .1, .2, 4))$spend

# 6-parameter specification fits 3 points
# Interims are at 25%. 50% and 75% of observations
# with cumulative spending of 10%, 20% and 50%, respectively
# Note: not all 3 point combinations can be fit
sfTDist(1, 1:3 / 4, c(.25, .5, .75, .1, .2, .5))$spend

# Example of error message when the 3-points specified
# in the 6-parameter version cannot be fit
try(sfTDist(1, 1:3 / 4, c(.25, .5, .75, .1, .2, .3))$errmsg)

# sfCauchy (sfTDist with 1 df) and sfNormal (sfTDist with infinite df)
# show the limits of what sfTdist can fit
# for the third point are u3 from 0.344 to 0.6 when t3=0.75
sfNormal(1, 1:3 / 4, c(.25, .5, .1, .2))$spend[3]
sfCauchy(1, 1:3 / 4, c(.25, .5, .1, .2))$spend[3]

# plot a few t-distribution spending functions fitting
# t=0.25, .5 and u=0.1, 0.2
# to demonstrate the range of flexibility
t <- 0:100 / 100
plot(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 1))$spend,
  xlab = "Proportion of final sample size",
  ylab = "Cumulative Type I error spending",
  main = "t-Distribution Spending Function Examples", type = "l"
)
lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 1.5))$spend, lty = 2)
lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 3))$spend, lty = 3)
lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 10))$spend, lty = 4)
lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 100))$spend, lty = 5)
legend(
  x = c(.0, .3), y = .025 * c(.7, 1), lty = 1:5,
  legend = c("df = 1", "df = 1.5", "df = 3", "df = 10", "df = 100")
)



cleanEx()
nameEx("sfXG")
### * sfXG

flush(stderr()); flush(stdout())

### Name: sfXG1
### Title: Xi and Gallo conditional error spending functions
### Aliases: sfXG1 sfXG sfXG2 sfXG3
### Keywords: design

### ** Examples

# Plot conditional error spending spending functions across
# a range of values of interest
pts <- seq(0, 1.2, 0.01)
pal <- palette()

plot(
  pts,
  sfXG1(0.025, pts, 0.5)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 1"
)
lines(pts, sfXG1(0.025, pts, 0.6)$spend, col = pal[2])
lines(pts, sfXG1(0.025, pts, 0.75)$spend, col = pal[3])
lines(pts, sfXG1(0.025, pts, 0.9)$spend, col = pal[4])
legend(
  "topleft",
  legend = c("gamma=0.5", "gamma=0.6", "gamma=0.75", "gamma=0.9"),
  col = pal[1:4],
  lty = 1
)

plot(
  pts,
  sfXG2(0.025, pts, 0.14)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 2"
)
lines(pts, sfXG2(0.025, pts, 0.25)$spend, col = pal[2])
lines(pts, sfXG2(0.025, pts, 0.5)$spend, col = pal[3])
lines(pts, sfXG2(0.025, pts, 0.75)$spend, col = pal[4])
lines(pts, sfXG2(0.025, pts, 0.9)$spend, col = pal[5])
legend(
  "topleft",
  legend = c("gamma=0.14", "gamma=0.25", "gamma=0.5", "gamma=0.75", "gamma=0.9"),
  col = pal[1:5],
  lty = 1
)

plot(
  pts,
  sfXG3(0.025, pts, 0.013)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 3"
)
lines(pts, sfXG3(0.025, pts, 0.02)$spend, col = pal[2])
lines(pts, sfXG3(0.025, pts, 0.05)$spend, col = pal[3])
lines(pts, sfXG3(0.025, pts, 0.1)$spend, col = pal[4])
lines(pts, sfXG3(0.025, pts, 0.25)$spend, col = pal[5])
lines(pts, sfXG3(0.025, pts, 0.5)$spend, col = pal[6])
lines(pts, sfXG3(0.025, pts, 0.75)$spend, col = pal[7])
lines(pts, sfXG3(0.025, pts, 0.9)$spend, col = pal[8])
legend(
  "bottomright",
  legend = c(
    "gamma=0.013", "gamma=0.02", "gamma=0.05", "gamma=0.1",
    "gamma=0.25", "gamma=0.5", "gamma=0.75", "gamma=0.9"
  ),
  col = pal[1:8],
  lty = 1
)



cleanEx()
nameEx("spendingFunction")
### * spendingFunction

flush(stderr()); flush(stdout())

### Name: summary.spendfn
### Title: Spending Function
### Aliases: summary.spendfn spendingFunction
### Keywords: design

### ** Examples

# Example 1: simple example showing what most users need to know

# Design a 4-analysis trial using a Hwang-Shih-DeCani spending function
# for both lower and upper bounds
x <- gsDesign(k = 4, sfu = sfHSD, sfupar = -2, sfl = sfHSD, sflpar = 1)

# Print the design
x
# Summarize the spending functions
summary(x$upper)
summary(x$lower)

# Plot the alpha- and beta-spending functions
plot(x, plottype = 5)

# What happens to summary if we used a boundary function design
x <- gsDesign(test.type = 2, sfu = "OF")
y <- gsDesign(test.type = 1, sfu = "WT", sfupar = .25)
summary(x$upper)
summary(y$upper)

# Example 2: advanced example: writing a new spending function
# Most users may ignore this!

# Implementation of 2-parameter version of
# beta distribution spending function
# assumes t and alpha are appropriately specified (does not check!)
sfbdist <- function(alpha, t, param) {
  # Check inputs
  checkVector(param, "numeric", c(0, Inf), c(FALSE, TRUE))
  if (length(param) != 2) {
    stop(
      "b-dist example spending function parameter must be of length 2"
    )
  }

  # Set spending using cumulative beta distribution and return
  x <- list(
    name = "B-dist example", param = param, parname = c("a", "b"),
    sf = sfbdist, spend = alpha *
      pbeta(t, param[1], param[2]), bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# Now try it out!
# Plot some example beta (lower bound) spending functions using
# the beta distribution spending function
t <- 0:100 / 100
plot(
  t, sfbdist(1, t, c(2, 1))$spend,
  type = "l",
  xlab = "Proportion of information",
  ylab = "Cumulative proportion of total spending",
  main = "Beta distribution Spending Function Example"
)
lines(t, sfbdist(1, t, c(6, 4))$spend, lty = 2)
lines(t, sfbdist(1, t, c(.5, .5))$spend, lty = 3)
lines(t, sfbdist(1, t, c(.6, 2))$spend, lty = 4)
legend(
  x = c(.65, 1), y = 1 * c(0, .25), lty = 1:4,
  legend = c("a=2, b=1", "a=6, b=4", "a=0.5, b=0.5", "a=0.6, b=2")
)



cleanEx()
nameEx("ssrCP")
### * ssrCP

flush(stderr()); flush(stdout())

### Name: condPower
### Title: Sample size re-estimation based on conditional power
### Aliases: condPower ssrCP plot.ssrCP z2NC z2Z z2Fisher Power.ssrCP
### Keywords: design

### ** Examples

library(ggplot2)
# quick trick for simple conditional power based on interim z-value, stage 1 and 2 sample size
# assumed treatment effect and final alpha level
# and observed treatment effect
alpha <- .01 # set final nominal significance level
timing <- .6 # set proportion of sample size, events or statistical information at IA
n2 <- 40 # set stage 2 sample size events or statistical information
hr <- .6 # for this example we will derive conditional power based on hazard ratios
n.fix <- nEvents(hr=hr,alpha=alpha) # you could otherwise make n.fix an arbitrary positive value
# this just derives a group sequential design that should not change sample size from n.fix
# due to stringent IA bound
x <- gsDesign(k=2,n.fix=n.fix,alpha=alpha,test.type=1,sfu=sfHSD,
sfupar=-20,timing=timing,delta1=log(hr))
# derive effect sizes for which you wish to compute conditional power
hrpostIA = seq(.4,1,.05)
# in the following, we convert HR into standardized effect size based on the design in x
powr <- condPower(x=x,z1=1,n2=x$n.I[2]-x$n.I[1],theta=log(hrpostIA)/x$delta1*x$theta[2])
ggplot(
  data.frame(
    x = hrpostIA,
    y = condPower(
      x = x,
      z1 = 1,
      n2 = x$n.I[2] - x$n.I[1],
      theta = log(hrpostIA) / x$delta1 * x$theta[2]
    )
  ),
  aes(x = x, y = y)
) +
  geom_line() +
  labs(
    x = "HR post IA",
    y = "Conditional power",
    title = "Conditional power as a function of assumed HR"
  )

# Following is a template for entering parameters for ssrCP
# Natural parameter value null and alternate hypothesis values
delta0 <- 0
delta1 <- 1
# timing of interim analysis for underlying group sequential design
timing <- .5
# upper spending function
sfu <- sfHSD
# upper spending function paramater
sfupar <- -12
# maximum sample size inflation
maxinflation <- 2
# assumed enrollment overrrun at IA
overrun <- 25
# interim z-values for plotting
z <- seq(0, 4, .025)
# Type I error (1-sided)
alpha <- .025
# Type II error for design
beta <- .1
# Fixed design sample size
n.fix <- 100
# conditional power interval where sample
# size is to be adjusted
cpadj <- c(.3, .9)
# targeted Type II error when adapting sample size
betastar <- beta
# combination test (built-in options are: z2Z, z2NC, z2Fisher)
z2 <- z2NC

# use the above parameters to generate design
# generate a 2-stage group sequential design with
x <- gsDesign(
  k = 2, n.fix = n.fix, timing = timing, sfu = sfu, sfupar = sfupar,
  alpha = alpha, beta = beta, delta0 = delta0, delta1 = delta1
)
# extend this to a conditional power design
xx <- ssrCP(
  x = x, z1 = z, overrun = overrun, beta = betastar, cpadj = cpadj,
  maxinc = maxinflation, z2 = z2
)
# plot the stage 2 sample size
plot(xx)
# demonstrate overlays on this plot
# overlay with densities for z1 under different hypotheses
lines(z, 80 + 240 * dnorm(z, mean = 0), col = 2)
lines(z, 80 + 240 * dnorm(z, mean = sqrt(x$n.I[1]) * x$theta[2]), col = 3)
lines(z, 80 + 240 * dnorm(z, mean = sqrt(x$n.I[1]) * x$theta[2] / 2), col = 4)
lines(z, 80 + 240 * dnorm(z, mean = sqrt(x$n.I[1]) * x$theta[2] * .75), col = 5)
axis(side = 4, at = 80 + 240 * seq(0, .4, .1), labels = as.character(seq(0, .4, .1)))
mtext(side = 4, expression(paste("Density for ", z[1])), line = 2)
text(x = 1.5, y = 90, col = 2, labels = expression(paste("Density for ", theta, "=0")))
text(x = 3.00, y = 180, col = 3, labels = expression(paste("Density for ", theta, "=",
 theta[1])))
text(x = 1.00, y = 180, col = 4, labels = expression(paste("Density for ", theta, "=",
 theta[1], "/2")))
text(x = 2.5, y = 140, col = 5, labels = expression(paste("Density for ", theta, "=",
 theta[1], "*.75")))
# overall line for max sample size
nalt <- xx$maxinc * x$n.I[2]
lines(x = par("usr")[1:2], y = c(nalt, nalt), lty = 2)

# compare above design with different combination tests
# use sufficient statistic for final testing
xxZ <- ssrCP(
  x = x, z1 = z, overrun = overrun, beta = betastar, cpadj = cpadj,
  maxinc = maxinflation, z2 = z2Z
)
# use Fisher combination test for final testing
xxFisher <- ssrCP(
  x = x, z1 = z, overrun = overrun, beta = betastar, cpadj = cpadj,
  maxinc = maxinflation, z2 = z2Fisher
)
# combine data frames from these designs
y <- rbind(
  data.frame(xx$dat, Test = "Normal combination"),
  data.frame(xxZ$dat, Test = "Sufficient statistic"),
  data.frame(xxFisher$dat, Test = "Fisher combination")
)
# plot stage 2 statistic required for positive combination test
ggplot2::ggplot(data = y, ggplot2::aes(x = z1, y = z2, col = Test)) + 
ggplot2::geom_line()
# plot total sample size versus stage 1 test statistic
ggplot2::ggplot(data = y, ggplot2::aes(x = z1, y = n2, col = Test)) + 
ggplot2::geom_line()
# check achieved Type I error for sufficient statistic design
Power.ssrCP(x = xxZ, theta = 0)

# compare designs using observed vs planned theta for conditional power
xxtheta1 <- ssrCP(
  x = x, z1 = z, overrun = overrun, beta = betastar, cpadj = cpadj,
  maxinc = maxinflation, z2 = z2, theta = x$delta
)
# combine data frames for the 2 designs
y <- rbind(
  data.frame(xx$dat, "CP effect size" = "Obs. at IA"),
  data.frame(xxtheta1$dat, "CP effect size" = "Alt. hypothesis")
)
# plot stage 2 sample size by design
ggplot2::ggplot(data = y, ggplot2::aes(x = z1, y = n2, col = CP.effect.size)) + 
ggplot2::geom_line()
# compare power and expected sample size
y1 <- Power.ssrCP(x = xx)
y2 <- Power.ssrCP(x = xxtheta1)
# combine data frames for the 2 designs
y3 <- rbind(
  data.frame(y1, "CP effect size" = "Obs. at IA"),
  data.frame(y2, "CP effect size" = "Alt. hypothesis")
)
# plot expected sample size by design and effect size
ggplot2::ggplot(data = y3, ggplot2::aes(x = delta, y = en, col = CP.effect.size)) + 
ggplot2::geom_line() +
ggplot2::xlab(expression(delta)) + 
ggplot2::ylab("Expected sample size")
# plot power by design and effect size
ggplot2::ggplot(data = y3, ggplot2::aes(x = delta, y = Power, col = CP.effect.size)) + 
ggplot2::geom_line() + 
ggplot2::xlab(expression(delta))



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("toBinomialExact")
### * toBinomialExact

flush(stderr()); flush(stdout())

### Name: toBinomialExact
### Title: Translate survival design bounds to exact binomial bounds
### Aliases: toBinomialExact

### ** Examples

# The following code derives the group sequential design using the method
# of Lachin and Foulkes

x <- gsSurv(
  k = 3,                 # 3 analyses
  test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
  alpha = .025,          # 1-sided Type I error
  beta = .1,             # Type II error (1 - power)
  timing = c(0.45, 0.7), # Proportion of final planned events at interims
  sfu = sfHSD,           # Efficacy spending function
  sfupar = -4,           # Parameter for efficacy spending function
  sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
  sflpar = 0,            # Parameter for futility spending function
  lambdaC = .001,        # Exponential failure rate
  hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
  hr0 = 0.7,             # Null hypothesis VE
  eta = 5e-04,           # Exponential dropout rate
  gamma = 10,            # Piecewise exponential enrollment rates
  R = 16,                # Time period durations for enrollment rates in gamma
  T = 24,                # Planned trial duration
  minfup = 8,            # Planned minimum follow-up
  ratio = 3              # Randomization ratio (experimental:control)
)
# Convert bounds to exact binomial bounds
toBinomialExact(x)
# Update bounds at time of analysis
toBinomialExact(x, observedEvents = c(20,55,80))



cleanEx()
nameEx("toInteger")
### * toInteger

flush(stderr()); flush(stdout())

### Name: toInteger
### Title: Translate group sequential design to integer events (survival
###   designs) or sample size (other designs)
### Aliases: toInteger

### ** Examples

# The following code derives the group sequential design using the method
# of Lachin and Foulkes

x <- gsSurv(
  k = 3,                 # 3 analyses
  test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
  alpha = .025,          # 1-sided Type I error
  beta = .1,             # Type II error (1 - power)
  timing = c(0.45, 0.7), # Proportion of final planned events at interims
  sfu = sfHSD,           # Efficacy spending function
  sfupar = -4,           # Parameter for efficacy spending function
  sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
  sflpar = 0,            # Parameter for futility spending function
  lambdaC = .001,        # Exponential failure rate
  hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
  hr0 = 0.7,             # Null hypothesis VE
  eta = 5e-04,           # Exponential dropout rate
  gamma = 10,            # Piecewise exponential enrollment rates
  R = 16,                # Time period durations for enrollment rates in gamma
  T = 24,                # Planned trial duration
  minfup = 8,            # Planned minimum follow-up
  ratio = 3              # Randomization ratio (experimental:control)
)
# Convert sample size to multiple of ratio + 1 = 4, round event counts.
# Default is to round up both event count and sample size for final analysis
toInteger(x)



cleanEx()
nameEx("varBinomial")
### * varBinomial

flush(stderr()); flush(stdout())

### Name: ciBinomial
### Title: Testing, Confidence Intervals, Sample Size and Power for
###   Comparing Two Binomial Rates
### Aliases: ciBinomial nBinomial simBinomial testBinomial varBinomial
### Keywords: design

### ** Examples


# Compute z-test test statistic comparing 39/500 to 13/500
# use continuity correction in variance
x <- testBinomial(x1 = 39, x2 = 13, n1 = 500, n2 = 500, adj = 1)
x
pnorm(x, lower.tail = FALSE)

# Compute with unadjusted variance
x0 <- testBinomial(x1 = 39, x2 = 23, n1 = 500, n2 = 500)
x0
pnorm(x0, lower.tail = FALSE)

# Perform 50k simulations to test validity of the above
# asymptotic p-values
# (you may want to perform more to reduce standard error of estimate)
sum(as.double(x0) <=
  simBinomial(p1 = .078, p2 = .078, n1 = 500, n2 = 500, nsim = 10000)) / 10000
sum(as.double(x0) <=
  simBinomial(p1 = .052, p2 = .052, n1 = 500, n2 = 500, nsim = 10000)) / 10000

# Perform a non-inferiority test to see if p2=400 / 500 is within 5% of
# p1=410 / 500 use a z-statistic with unadjusted variance
x <- testBinomial(x1 = 410, x2 = 400, n1 = 500, n2 = 500, delta0 = -.05)
x
pnorm(x, lower.tail = FALSE)

# since chi-square tests equivalence (a 2-sided test) rather than
# non-inferiority (a 1-sided test),
# the result is quite different
pchisq(testBinomial(
  x1 = 410, x2 = 400, n1 = 500, n2 = 500, delta0 = -.05,
  chisq = 1, adj = 1
), 1, lower.tail = FALSE)

# now simulate the z-statistic witthout continuity corrected variance
sum(qnorm(.975) <=
  simBinomial(p1 = .8, p2 = .8, n1 = 500, n2 = 500, nsim = 100000)) / 100000

# compute a sample size to show non-inferiority
# with 5% margin, 90% power
nBinomial(p1 = .2, p2 = .2, delta0 = .05, alpha = .025, sided = 1, beta = .1)

# assuming a slight advantage in the experimental group lowers
# sample size requirement
nBinomial(p1 = .2, p2 = .19, delta0 = .05, alpha = .025, sided = 1, beta = .1)

# compute a sample size for comparing 15% vs 10% event rates
# with 1 to 2 randomization
nBinomial(p1 = .15, p2 = .1, beta = .2, ratio = 2, alpha = .05)

# now look at total sample size using 1-1 randomization
n <- nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05)
n
# check if inputing sample size returns the desired power
nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, n = n)

# re-do with alternate output types
nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, outtype = 2)
nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, outtype = 3)

# look at power plot under different control event rate and
# relative risk reductions
library(dplyr)
library(ggplot2)
p1 <- seq(.075, .2, .000625)
len <- length(p1)
p2 <- c(p1 * .75, p1 * 2/3, p1 * .6, p1 * .5)
Reduction <- c(rep("25 percent", len), rep("33 percent", len), 
               rep("40 percent", len), rep("50 percent", len))
df <- tibble(p1 = rep(p1, 4), p2, Reduction) |>
  mutate(`Sample size` = nBinomial(p1, p2, beta = .2, alpha = .025, sided = 1))
ggplot(df, aes(x = p1, y = `Sample size`, col = Reduction)) + 
  geom_line() + 
  xlab("Control group event rate") +
  ylim(0,6000) +
  ggtitle("Binomial sample size computation for 80 pct power")

# compute blinded estimate of treatment effect difference
x1 <- rbinom(n = 1, size = 100, p = .2)
x2 <- rbinom(n = 1, size = 200, p = .1)
# blinded estimate of risk difference variance
varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0)
# blinded estimate of log-risk-ratio variance
varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0, scale = "RR")
# blinded estimate of log-odds-ratio variance
varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0, scale = "OR")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
