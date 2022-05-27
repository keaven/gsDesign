# sfLogistic roxy [sinew] ----
#' @title Two-parameter Spending Function Families
#' @description The functions \code{sfLogistic()}, \code{sfNormal()},
#' \code{sfExtremeValue()}, \code{sfExtremeValue2()}, \code{sfCauchy()}, and
#' \code{sfBetaDist()} are all 2-parameter spending function families. These
#' provide increased flexibility in some situations where the flexibility of a
#' one-parameter spending function family is not sufficient. These functions
#' all allow fitting of two points on a cumulative spending function curve; in
#' this case, four parameters are specified indicating an x and a y coordinate
#' for each of 2 points. Normally each of these functions will be passed to
#' \code{gsDesign()} in the parameter \code{sfu} for the upper bound or
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence.
#' The calling sequence is useful, however, when the user wishes to plot a
#' spending function as demonstrated in the examples; note, however, that an
#' automatic \eqn{\alpha}{alpha}- and \eqn{\beta}{beta}-spending function plot
#' is also available.
#'
#' \code{sfBetaDist(alpha,t,param)} is simply \code{alpha} times the incomplete
#' beta cumulative distribution function with parameters \eqn{a} and \eqn{b}
#' passed in \code{param} evaluated at values passed in \code{t}.
#'
#' The other spending functions take the form \deqn{f(t;\alpha,a,b)=\alpha
#' F(a+bF^{-1}(t))}{f(t;alpha,a,b)=alpha F(a+bF^{-1}(t))} where \eqn{F()} is a
#' cumulative distribution function with values \eqn{> 0} on the real line
#' (logistic for \code{sfLogistic()}, normal for \code{sfNormal()}, extreme
#' value for \code{sfExtremeValue()} and Cauchy for \code{sfCauchy()}) and
#' \eqn{F^{-1}()} is its inverse.
#'
#' For the logistic spending function this simplifies to
#' \deqn{f(t;\alpha,a,b)=\alpha (1-(1+e^a(t/(1-t))^b)^{-1}).}
#'
#' For the extreme value distribution with \deqn{F(x)=\exp(-\exp(-x))} this
#' simplifies to \deqn{f(t;\alpha,a,b)=\alpha \exp(-e^a (-\ln t)^b).} Since the
#' extreme value distribution is not symmetric, there is also a version where
#' the standard distribution is flipped about 0. This is reflected in
#' \code{sfExtremeValue2()} where \deqn{F(x)=1-\exp(-\exp(x)).}
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size or information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size or information for which the
#' spending function will be computed.
#' @param param In the two-parameter specification, \code{sfBetaDist()}
#' requires 2 positive values, while \code{sfLogistic()}, \code{sfNormal()},
#' \code{sfExtremeValue()},
#'
#' \code{sfExtremeValue2()} and \code{sfCauchy()} require the first parameter
#' to be any real value and the second to be a positive value.  The four
#' parameter specification is \code{c(t1,t2,u1,u2)} where the objective is that
#' \code{sf(t1)=alpha*u1} and \code{sf(t2)=alpha*u2}.  In this
#' parameterization, all four values must be between 0 and 1 and \code{t1 <
#' t2}, \code{u1 < u2}.
#' @return An object of type \code{spendfn}. 
#' See \code{\link{Spending_Function_Overview}} for further details.
#' @examples
#' library(ggplot2)
#' # design a 4-analysis trial using a Kim-DeMets spending function
#' # for both lower and upper bounds
#' x <- gsDesign(k = 4, sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 1.5)
#' 
#' # print the design
#' x
#' 
#' # plot the alpha- and beta-spending functions
#' plot(x, plottype = 5)
#' 
#' # start by showing how to fit two points with sfLogistic
#' # plot the spending function using many points to obtain a smooth curve
#' # note that curve fits the points x=.1,  y=.01 and x=.4,  y=.1
#' # specified in the 3rd parameter of sfLogistic
#' t <- 0:100 / 100
#' plot(t, sfLogistic(1, t, c(.1, .4, .01, .1))$spend,
#'   xlab = "Proportion of final sample size",
#'   ylab = "Cumulative Type I error spending",
#'   main = "Logistic Spending Function Examples",
#'   type = "l", cex.main = .9
#' )
#' lines(t, sfLogistic(1, t, c(.01, .1, .1, .4))$spend, lty = 2)
#' 
#' # now just give a=0 and b=1 as 3rd parameters for sfLogistic
#' lines(t, sfLogistic(1, t, c(0, 1))$spend, lty = 3)
#' 
#' # try a couple with unconventional shapes again using
#' # the xy form in the 3rd parameter
#' lines(t, sfLogistic(1, t, c(.4, .6, .1, .7))$spend, lty = 4)
#' lines(t, sfLogistic(1, t, c(.1, .7, .4, .6))$spend, lty = 5)
#' legend(
#'   x = c(.0, .475), y = c(.76, 1.03), lty = 1:5,
#'   legend = c(
#'     "Fit (.1, 01) and (.4, .1)", "Fit (.01, .1) and (.1, .4)",
#'     "a=0,  b=1", "Fit (.4, .1) and (.6, .7)",
#'     "Fit (.1, .4) and (.7, .6)"
#'   )
#' )
#' 
#' # set up a function to plot comparsons of all
#' # 2-parameter spending functions
#' plotsf <- function(alpha, t, param) {
#'   plot(t, sfCauchy(alpha, t, param)$spend,
#'     xlab = "Proportion of enrollment",
#'     ylab = "Cumulative spending", type = "l", lty = 2
#'   )
#'   lines(t, sfExtremeValue(alpha, t, param)$spend, lty = 5)
#'   lines(t, sfLogistic(alpha, t, param)$spend, lty = 1)
#'   lines(t, sfNormal(alpha, t, param)$spend, lty = 3)
#'   lines(t, sfExtremeValue2(alpha, t, param)$spend, lty = 6, col = 2)
#'   lines(t, sfBetaDist(alpha, t, param)$spend, lty = 7, col = 3)
#'   legend(
#'     x = c(.05, .475), y = .025 * c(.55, .9),
#'     lty = c(1, 2, 3, 5, 6, 7),
#'     col = c(1, 1, 1, 1, 2, 3),
#'     legend = c(
#'       "Logistic", "Cauchy", "Normal", "Extreme value",
#'       "Extreme value 2", "Beta distribution"
#'     )
#'   )
#' }
#' # do comparison for a design with conservative early spending
#' # note that Cauchy spending function is quite different
#' # from the others
#' param <- c(.25, .5, .05, .1)
#' plotsf(.025, t, param)
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \code{\link{gsDesign}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @export
#' @rdname sfDistribution
# sfLogistic function [sinew] ----
sfLogistic <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 2) {
    if (!is.numeric(param[1])) {
      stop("Numeric first logistic spending parameter not given")
    }
    if (param[2] <= 0.) {
      stop("Second logistic spending parameter param[2] must be real value > 0")
    }

    a <- param[1]
    b <- param[2]
  }
  else if (len == 4) {
    checkRange(param, inclusion = c(FALSE, FALSE))
    t0 <- param[1:2]
    p0 <- param[3:4]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("4-parameter specification of logistic function incorrect")
    }

    xv <- log(t0 / (1 - t0))
    y <- log(p0 / (1 - p0))
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
    param <- c(a, b)
  }
  else {
    stop("Logistic spending function parameter must be of length 2 or 4")
  }

  xv <- log(t / (1 - 1 * (!is.element(t, 1)) * t))
  y <- exp(a + b * xv)
  y <- y / (1 + y)
  t[t > 1] <- 1

  x <- list(
    name = "Logistic", param = param, parname = c("a", "b"), sf = sfLogistic,
    spend = alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1)),
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# sfExponential roxy [sinew] ----
#' @title Exponential Spending Function
#' @description The function \code{sfExponential} implements the exponential spending
#' function (Anderson and Clark, 2009). Normally \code{sfExponential} will be
#' passed to \code{gsDesign} in the parameter \code{sfu} for the upper bound or
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence.
#' The calling sequence is useful, however, when the user wishes to plot a
#' spending function as demonstrated below in examples.
#'
#' An exponential spending function is defined for any positive \code{nu} and
#' \eqn{0\le t\le 1} as
#' \deqn{f(t;\alpha,\nu)=\alpha(t)=\alpha^{t^{-\nu}}.}{f(t;alpha,nu)=alpha^(t^(-nu)).}
#' A value of \code{nu=0.8} approximates an O'Brien-Fleming spending function
#' well.
#'
#' The general class of spending functions this family is derived from requires
#' a continuously increasing cumulative distribution function defined for
#' \eqn{x>0} and is defined as \deqn{f(t;\alpha,
#' \nu)=1-F\left(F^{-1}(1-\alpha)/ t^\nu\right).}{% f(t; alpha,
#' nu)=1-F(F^(-1)(1-alpha)/ t^nu).} The exponential spending function can be
#' derived by letting \eqn{F(x)=1-\exp(-x)}, the exponential cumulative
#' distribution function. This function was derived as a generalization of the
#' Lan-DeMets (1983) spending function used to approximate an O'Brien-Fleming
#' spending function (\code{sfLDOF()}), \deqn{f(t; \alpha)=2-2\Phi \left(
#' \Phi^{-1}(1-\alpha/2)/ t^{1/2} \right).}{% f(t;
#' alpha)=2-2*Phi(Phi^(-1)(1-alpha/2)/t^(1/2)).}
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param A single positive value specifying the nu parameter for which
#' the exponential spending is to be computed; allowable range is (0, 1.5].
#' @return An object of type \code{spendfn}.
#' @examples
#' library(ggplot2)
#' # use 'best' exponential approximation for k=6 to O'Brien-Fleming design
#' # (see manual for details)
#' gsDesign(
#'   k = 6, sfu = sfExponential, sfupar = 0.7849295,
#'   test.type = 2
#' )$upper$bound
#' 
#' # show actual O'Brien-Fleming bound
#' gsDesign(k = 6, sfu = "OF", test.type = 2)$upper$bound
#' 
#' # show Lan-DeMets approximation
#' # (not as close as sfExponential approximation)
#' gsDesign(k = 6, sfu = sfLDOF, test.type = 2)$upper$bound
#' 
#' # plot exponential spending function across a range of values of interest
#' t <- 0:100 / 100
#' plot(t, sfExponential(0.025, t, 0.8)$spend,
#'   xlab = "Proportion of final sample size",
#'   ylab = "Cumulative Type I error spending",
#'   main = "Exponential Spending Function Example", type = "l"
#' )
#' lines(t, sfExponential(0.025, t, 0.5)$spend, lty = 2)
#' lines(t, sfExponential(0.025, t, 0.3)$spend, lty = 3)
#' lines(t, sfExponential(0.025, t, 0.2)$spend, lty = 4)
#' lines(t, sfExponential(0.025, t, 0.15)$spend, lty = 5)
#' legend(
#'   x = c(.0, .3), y = .025 * c(.7, 1), lty = 1:5,
#'   legend = c(
#'     "nu = 0.8", "nu = 0.5", "nu = 0.3", "nu = 0.2",
#'     "nu = 0.15"
#'   )
#' )
#' text(x = .59, y = .95 * .025, labels = "<--approximates O'Brien-Fleming")
#' @note The manual shows how to use \code{sfExponential()} to closely
#' approximate an O'Brien-Fleming design. An example is given below. The manual
#' is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Anderson KM and Clark JB (2009), Fitting spending functions.
#' \emph{Statistics in Medicine}; 29:321-327.
#'
#' Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with
#' Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Lan, KKG and DeMets, DL (1983), Discrete sequential boundaries for clinical
#' trials. \emph{Biometrika}; 70:659-663.
#' @keywords design
#' @export
#' @rdname sfExponential
# sfExponential function [sinew] ----
sfExponential <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  # K. Wills 12/11/08: restrict param range
  # checkScalar(param, "numeric", c(0, 10), c(FALSE, TRUE))
  checkScalar(param, "numeric", c(0, 1.5), c(FALSE, TRUE))

  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  x <- list(
    name = "Exponential", param = param, parname = "nu", sf = sfExponential,
    spend = alpha^(t^(-param)), bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# sfBetaDist roxy [sinew] ----
#' @rdname sfDistribution
#' @export
#' @importFrom stats nlminb pbeta
# sfBetaDist function [sinew] ----
sfBetaDist <- function(alpha, t, param) {
  
  if(length(param) == 4){
    if (param[1] >= param[2]) stop("sfBetaDist: param[1] < param[2] required in 4 point parameterization")
    if (param[3] >= param[4]) stop("sfBetaDist: param[3] < param[4] required in 4 point parameterization")
  }
  
  x <- list(
    name = "Beta distribution", param = param, parname = c("a", "b"), sf = sfBetaDist, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  len <- length(param)

  if (len == 2) {
    checkVector(param, "numeric", c(0, Inf), c(FALSE, TRUE))
  }
  else if (len == 4) {
    checkVector(param, "numeric", c(0, 1), c(FALSE, FALSE))

    tem <- stats::nlminb(c(1, 1), diffbetadist, lower = c(0, 0), xval = param[1:2], uval = param[3:4])

    if (tem$convergence != 0) {
      stop("Solution to 4-parameter specification of Beta distribution spending function not found.")
    }

    x$param <- tem$par
  }
  else {
    stop("Beta distribution spending function parameter must be of length 2 or 4")
  }

  t[t > 1] <- 1

  x$spend <- alpha * stats::pbeta(t, x$param[1], x$param[2])

  x
}

# sfCauchy roxy [sinew] ----
#' @rdname sfDistribution
#' @export
#' @importFrom stats qcauchy pcauchy
# sfCauchy function [sinew] ----
sfCauchy <- function(alpha, t, param) {
  x <- list(
    name = "Cauchy", param = param, parname = c("a", "b"), sf = sfCauchy, spend = NULL,
    bound = NULL, prob = NULL
  )

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  class(x) <- "spendfn"

  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 2) {
    if (param[2] <= 0.) {
      stop("Second Cauchy spending parameter param[2] must be real value > 0")
    }

    a <- param[1]
    b <- param[2]
  }
  else if (len == 4) {
    t0 <- param[1:2]
    p0 <- param[3:4]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("4-parameter specification of Cauchy function incorrect")
    }

    xv <- stats::qcauchy(t0)
    y <- stats::qcauchy(p0)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
    x$param <- c(a, b)
  }
  else {
    stop("Cauchy spending function parameter must be of length 2 or 4")
  }

  t[t > 1] <- 1
  xv <- stats::qcauchy(1 * (!is.element(t, 1)) * t)
  y <- stats::pcauchy(a + b * xv)
  x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))

  x
}

# sfExtremeValue roxy [sinew] ----
#' @rdname sfDistribution
#' @export
# sfExtremeValue function [sinew] ----
sfExtremeValue <- function(alpha, t, param) {
  x <- list(
    name = "Extreme value", param = param, parname = c("a", "b"), sf = sfExtremeValue, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 2) {
    if (param[2] <= 0.) {
      stop("Second extreme value spending parameter param[2] must be real value > 0")
    }

    a <- param[1]
    b <- param[2]
  }
  else if (len == 4) {
    t0 <- param[1:2]
    p0 <- param[3:4]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("4-parameter specification of extreme value function incorrect")
    }

    xv <- -log(-log(t0))
    y <- -log(-log(p0))
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
    x$param <- c(a, b)
  }
  else {
    stop("Extreme value spending function parameter must be of length 2 or 4")
  }

  t[t > 1] <- 1
  xv <- -log(-log((!is.element(t, 1)) * t))
  y <- exp(-exp(-a - b * xv))
  x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))

  x
}

# sfExtremeValue2 roxy [sinew] ----
#' @rdname sfDistribution
#' @export
# sfExtremeValue2 function [sinew] ----
sfExtremeValue2 <- function(alpha, t, param) {
  x <- list(
    name = "Extreme value 2", param = param, parname = c("a", "b"), sf = sfExtremeValue2, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 2) {
    if (param[2] <= 0.) {
      stop("Second extreme value (2) spending parameter param[2] must be real value > 0")
    }

    a <- param[1]
    b <- param[2]
  }
  else if (len == 4) {
    t0 <- param[1:2]
    p0 <- param[3:4]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("4-parameter specification of extreme value (2) function incorrect")
    }

    xv <- log(-log(1 - t0))
    y <- log(-log(1 - p0))
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
    x$param <- c(a, b)
  }
  else {
    stop("Extreme value (2) spending function parameter must be of length 2 or 4")
  }

  t[t > 1] <- 1
  xv <- log(-log(1 - 1 * (!is.element(t, 1)) * t))
  y <- 1 - exp(-exp(a + b * xv))
  x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))

  x
}

# sfHSD roxy [sinew] ----
#' @title Hwang-Shih-DeCani Spending Function
#' @description The function \code{sfHSD} implements a Hwang-Shih-DeCani spending function.
#' This is the default spending function for \code{gsDesign()}. Normally it
#' will be passed to \code{gsDesign} in the parameter \code{sfu} for the upper
#' bound or \code{sfl} for the lower bound to specify a spending function
#' family for a design. In this case, the user does not need to know the
#' calling sequence. The calling sequence is useful, however, when the user
#' wishes to plot a spending function as demonstrated below in examples.
#'
#' A Hwang-Shih-DeCani spending function takes the form \deqn{f(t;\alpha,
#' \gamma)=\alpha(1-e^{-\gamma t})/(1-e^{-\gamma})}{f(t; alpha, gamma) = alpha
#' * (1-exp(-gamma * t))/(1 - exp(-gamma))} where \eqn{\gamma}{gamma} is the
#' value passed in \code{param}. A value of \eqn{\gamma=-4}{gamma=-4} is used
#' to approximate an O'Brien-Fleming design (see \code{\link{sfExponential}}
#' for a better fit), while a value of \eqn{\gamma=1}{gamma=1} approximates a
#' Pocock design well.
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param A single real value specifying the gamma parameter for which
#' Hwang-Shih-DeCani spending is to be computed; allowable range is [-40, 40]
#' @return An object of type \code{spendfn}. See \link{Spending_Function_Overview} for further details.
#' @examples
#' library(ggplot2)
#' # design a 4-analysis trial using a Hwang-Shih-DeCani spending function
#' # for both lower and upper bounds
#' x <- gsDesign(k = 4, sfu = sfHSD, sfupar = -2, sfl = sfHSD, sflpar = 1)
#' 
#' # print the design
#' x
#' 
#' # since sfHSD is the default for both sfu and sfl,
#' # this could have been written as
#' x <- gsDesign(k = 4, sfupar = -2, sflpar = 1)
#' 
#' # print again
#' x
#' 
#' # plot the spending function using many points to obtain a smooth curve
#' # show default values of gamma to see how the spending function changes
#' # also show gamma=1 which is supposed to approximate a Pocock design
#' t <- 0:100 / 100
#' plot(t, sfHSD(0.025, t, -4)$spend,
#'   xlab = "Proportion of final sample size",
#'   ylab = "Cumulative Type I error spending",
#'   main = "Hwang-Shih-DeCani Spending Function Example", type = "l"
#' )
#' lines(t, sfHSD(0.025, t, -2)$spend, lty = 2)
#' lines(t, sfHSD(0.025, t, 1)$spend, lty = 3)
#' legend(
#'   x = c(.0, .375), y = .025 * c(.8, 1), lty = 1:3,
#'   legend = c("gamma= -4", "gamma= -2", "gamma= 1")
#' )
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @export
#' @rdname sfHSD
#'
# sfHSD function [sinew] ----
sfHSD <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkScalar(param, "numeric", c(-40, 40))

  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  x <- list(
    name = "Hwang-Shih-DeCani", param = param, parname = "gamma", sf = sfHSD,
    spend = if (param == 0) t * alpha else alpha * (1. - exp(-t * param)) / (1 - exp(-param)),
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# sfLDOF roxy [sinew] ----
#' @title Lan-DeMets Spending function overview
#' @description Lan and DeMets (1983) first published the method of using spending functions 
#' to set boundaries for group sequential trials. In this publication they
#' proposed two specific spending functions: one to approximate an
#' O'Brien-Fleming design and the other to approximate a Pocock design.
#' The spending function to approximate O'Brien-Fleming has been generalized as proposed by Liu, et al (2012)
#'
#' With \code{param=1=rho}, the Lan-DeMets (1983) spending function to approximate an O'Brien-Fleming
#' bound is implemented in the function (\code{sfLDOF()}): \deqn{f(t; 
#' \alpha)=2-2\Phi\left(\Phi^{-1}(1-\alpha/2)/ t^{\rho/2}\right).}{%
#' f(t; alpha)=2-2*Phi(Phi^(-1)(1-alpha/2)/t^(rho/2)\right)}
#' For \code{rho} otherwise in \code{[.005,2]}, this is the generalized version of Liu et al (2012).
#' For \code{param} outside of \code{[.005,2]}, \code{rho} is set to 1. The Lan-DeMets (1983)
#' spending function to approximate a Pocock design is implemented in the
#' function \code{sfLDPocock()}:
#' \deqn{f(t;\alpha)=\alpha ln(1+(e-1)t).}{f(t;alpha)= alpha ln(1+(e-1)t).} As shown in
#' examples below, other spending functions can be used to ge t as good or
#' better approximations to Pocock and O'Brien-Fleming bounds. In particular,
#' O'Brien-Fleming bounds can be closely approximated using
#' \code{\link{sfExponential}}.
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param This parameter is not used for \code{sfLDPocock}, not required 
#' for \code{sfLDOF} and need not be specified. For \code{sfLDPocock} it is here 
#' so that the calling sequence conforms to the standard for spending functions used 
#' with \code{gsDesign()}. For \code{sfLDOF} it will default to 1 (Lan-DeMets function 
#' to approximate O'Brien-Fleming) if \code{NULL} or if outside of the range \code{[.005,2]}.
#' otherwise, it will be use to set rho from Liu et al (2012).
#' @return An object of type \code{spendfn}. See spending functions for further
#' details.
#' @examples
#' library(ggplot2)
#' # 2-sided,  symmetric 6-analysis trial Pocock
#' # spending function approximation
#' gsDesign(k = 6, sfu = sfLDPocock, test.type = 2)$upper$bound
#' 
#' # show actual Pocock design
#' gsDesign(k = 6, sfu = "Pocock", test.type = 2)$upper$bound
#' 
#' # approximate Pocock again using a standard
#' # Hwang-Shih-DeCani approximation
#' gsDesign(k = 6, sfu = sfHSD, sfupar = 1, test.type = 2)$upper$bound
#' 
#' # use 'best' Hwang-Shih-DeCani approximation for Pocock,  k=6;
#' # see manual for details
#' gsDesign(k = 6, sfu = sfHSD, sfupar = 1.3354376, test.type = 2)$upper$bound
#' 
#' # 2-sided, symmetric 6-analysis trial
#' # O'Brien-Fleming spending function approximation
#' gsDesign(k = 6, sfu = sfLDOF, test.type = 2)$upper$bound
#' 
#' # show actual O'Brien-Fleming bound
#' gsDesign(k = 6, sfu = "OF", test.type = 2)$upper$bound
#' 
#' # approximate again using a standard Hwang-Shih-DeCani
#' # approximation to O'Brien-Fleming
#' x <- gsDesign(k = 6, test.type = 2)
#' x$upper$bound
#' x$upper$param
#' 
#' # use 'best' exponential approximation for k=6; see manual for details
#' gsDesign(
#'   k = 6, sfu = sfExponential, sfupar = 0.7849295,
#'   test.type = 2
#' )$upper$bound
#' 
#' # plot spending functions for generalized Lan-DeMets approximation of
# O'Brien-Fleming (from Liu et al, 2012)
#' ti <-(0:100)/100
#' rho <- c(.05,.5,1,1.5,2,2.5,3:6,8,10,12.5,15,20,30,200)/10
#' df <- NULL
#' for(r in rho){
#'   df <- rbind(df,data.frame(t=ti,rho=r,alpha=.025,spend=sfLDOF(alpha=.025,t=ti,param=r)$spend))
#' }
#' ggplot(df,aes(x=t,y=spend,col=as.factor(rho)))+
#'   geom_line()+
#'   guides(col=guide_legend(expression(rho)))+
#'   ggtitle("Generalized Lan-DeMets O'Brien-Fleming Spending Function")
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Lan, KKG and DeMets, DL (1983), Discrete sequential boundaries for clinical
#' trials. \emph{Biometrika};70: 659-663.
#' 
#' Liu, Q, Lim, P, Nuamah, I, and Li, Y (2012), On adaptive error spending approach 
#' for group sequential trials with random information levels. 
#' \emph{Journal of biopharmaceutical statistics}; 22(4), 687-699.
#' @keywords design
#' @rdname sfLDOF
#' @export
# sfLDOF function [sinew] ----
sfLDOF <- function(alpha, t, param = NULL) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  # Following 2 lines udated 10/11/17 
  # fix needed since default for gsDesign is param=-4 is out of range for LDOF
  if (is.null(param) || param < .005 || param > 20) param <- 1
  checkScalar(param, "numeric", c(.005,20),c(TRUE,TRUE))
  t[t>1] <- 1
  if (param == 1){
    rho <- 1
    txt <- "Lan-DeMets O'Brien-Fleming approximation"
    parname <- "none"
  }else{
    rho<-param
    txt <- "Generalized Lan-DeMets O'Brien-Fleming"
    parname <- "rho"
  }
  z <- - qnorm(alpha / 2)
  
  x <- list(name=txt, param=param, parname=parname, sf=sfLDOF, 
            spend=2 * (1 - pnorm(z / t^(rho/2))), bound=NULL, prob=NULL)  
  
  class(x) <- "spendfn"
  
  x
}

# sfLDPocock roxy [sinew] ----
#' @rdname sfLDOF
#' @export
# sfLDPocock function [sinew] ----
sfLDPocock <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  x <- list(
    name = "Lan-DeMets Pocock approximation", param = NULL, parname = "none", sf = sfLDPocock,
    spend = alpha * log(1 + (exp(1) - 1) * t), bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# sfNormal roxy [sinew] ----
#' @export
#' @rdname sfDistribution
#' @importFrom stats qnorm pnorm
# sfNormal function [sinew] ----
sfNormal <- function(alpha, t, param) {
  x <- list(
    name = "Normal", param = param, parname = c("a", "b"), sf = sfNormal, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 2) {
    if (param[2] <= 0.) {
      stop("Second Normal spending parameter param[2] must be real value > 0")
    }

    a <- param[1]
    b <- param[2]
  }
  else if (len == 4) {
    t0 <- param[1:2]
    p0 <- param[3:4]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("4-parameter specification of Normal function incorrect")
    }

    xv <- stats::qnorm(t0)
    y <- stats::qnorm(p0)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
    x$param <- c(a, b)
  }
  else {
    stop("Normal spending function parameter must be of length 2 or 4")
  }

  t[t > 1] <- 1
  xv <- stats::qnorm(1 * (!is.element(t, 1)) * t)
  y <- stats::pnorm(a + b * xv)
  x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))

  x
}

# sfLinear roxy [sinew] ----
#' @title  Piecewise Linear and Step Function Spending Functions
#'
#' @description The function \code{sfLinear()} allows specification of a piecewise linear
#' spending function. The function \code{sfStep()} specifies a step function
#' spending function. Both functions provide complete flexibility in setting
#' spending at desired timepoints in a group sequential design. Normally these
#' function will be passed to \code{gsDesign()} in the parameter \code{sfu} for
#' the upper bound or \code{sfl} for the lower bound to specify a spending
#' function family for a design. When passed to \code{gsDesign()}, the value of
#' \code{param} would be passed to \code{sfLinear()} or \code{sfStep()} through
#' the \code{gsDesign()} arguments \code{sfupar} for the upper bound and
#' \code{sflpar} for the lower bound.
#'
#' Note that \code{sfStep()} allows setting a particular level of spending when
#' the timing is not strictly known; an example shows how this can inflate Type
#' I error when timing of analyses are changed based on knowing the treatment
#' effect at an interim.
#'
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size or information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size or information for which the
#' spending function will be computed.
#' @param param A vector with a positive, even length. Values must range from 0
#' to 1, inclusive. Letting \code{m <- length(param/2)}, the first \code{m}
#' points in param specify increasing values strictly between 0 and 1
#' corresponding to interim timing (proportion of final total statistical
#' information). The last \code{m} points in \code{param} specify
#' non-decreasing values from 0 to 1, inclusive, with the cumulative proportion
#' of spending at the specified timepoints.
#' @return An object of type \code{spendfn}.  The cumulative spending returned
#' in \code{sfLinear$spend} is 0 for \code{t <= 0} and \code{alpha} for
#' \code{t>=1}.  For \code{t} between specified points, linear interpolation is
#' used to determine \code{sfLinear$spend}.
#'
#' The cumulative spending returned in \code{sfStep$spend} is 0 for
#' \code{t<param[1]} and \code{alpha} for \code{t>=1}.  Letting \code{m <-
#' length(param/2)}, for \code{i=1,2,...m-1} and \code{ param[i]<= t <
#' param[i+1]}, the cumulative spending is set at \code{alpha * param[i+m]}
#' (also for \code{param[m]<=t<1}).
#'
#' Note that if \code{param[2m]} is 1, then the first time an analysis is
#' performed after the last proportion of final planned information
#' (\code{param[m]}) will be the final analysis, using any remaining error that
#' was not previously spent.
#'
#' See \code{\link{Spending_Function_Overview}} for further details.
#' @examples
#' library(ggplot2)
#' # set up alpha spending and beta spending to be piecewise linear
#' sfupar <- c(.2, .4, .05, .2)
#' sflpar <- c(.3, .5, .65, .5, .75, .9)
#' x <- gsDesign(sfu = sfLinear, sfl = sfLinear, sfupar = sfupar, sflpar = sflpar)
#' plot(x, plottype = "sf")
#' x
#' 
#' # now do an example where there is no lower-spending at interim 1
#' # and no upper spending at interim 2
#' sflpar <- c(1 / 3, 2 / 3, 0, .25)
#' sfupar <- c(1 / 3, 2 / 3, .1, .1)
#' x <- gsDesign(sfu = sfLinear, sfl = sfLinear, sfupar = sfupar, sflpar = sflpar)
#' plot(x, plottype = "sf")
#' x
#' 
#' # now do an example where timing of interims changes slightly, but error spending does not
#' # also, spend all alpha when at least >=90 percent of final information is in the analysis
#' sfupar <- c(.2, .4, .9, ((1:3) / 3)^3)
#' x <- gsDesign(k = 3, n.fix = 100, sfu = sfStep, sfupar = sfupar, test.type = 1)
#' plot(x, pl = "sf")
#' # original planned sample sizes
#' ceiling(x$n.I)
#' # cumulative spending planned at original interims
#' cumsum(x$upper$spend)
#' # change timing of analyses;
#' # note that cumulative spending "P(Cross) if delta=0" does not change from cumsum(x$upper$spend)
#' # while full alpha is spent, power is reduced by reduced sample size
#' y <- gsDesign(
#'   k = 3, sfu = sfStep, sfupar = sfupar, test.type = 1,
#'   maxn.IPlan = x$n.I[x$k], n.I = c(30, 70, 95),
#'   n.fix = x$n.fix
#' )
#' # note that full alpha is used, but power is reduced due to lowered sample size
#' gsBoundSummary(y)
#' 
#' # now show how step function can be abused by 'adapting' stage 2 sample size based on interim result
#' x <- gsDesign(k = 2, delta = .05, sfu = sfStep, sfupar = c(.02, .001), timing = .02, test.type = 1)
#' # spending jumps from miniscule to full alpha at first analysis after interim 1
#' plot(x, pl = "sf")
#' # sample sizes at analyses:
#' ceiling(x$n.I)
#' # simulate 1 million stage 1 sum of 178 Normal(0,1) random variables
#' # Normal(0,Variance=178) under null hypothesis
#' s1 <- rnorm(1000000, 0, sqrt(178))
#' # compute corresponding z-values
#' z1 <- s1 / sqrt(178)
#' # set stage 2 sample size to 1 if z1 is over final bound, otherwise full sample size
#' n2 <- rep(1, 1000000)
#' n2[z1 < 1.96] <- ceiling(x$n.I[2]) - ceiling(178)
#' # now sample n2 observations for second stage
#' s2 <- rnorm(1000000, 0, sqrt(n2))
#' # add sum and divide by standard deviation
#' z2 <- (s1 + s2) / (sqrt(178 + n2))
#' # By allowing full spending when final analysis is either
#' # early or late depending on observed interim z1,
#' # Type I error is now almost twice the planned .025
#' sum(z1 >= x$upper$bound[1] | z2 >= x$upper$bound[2]) / 1000000
#' # if stage 2 sample size is random and independent of z1 with same frequency,
#' # this is not a problem
#' s1alt <- rnorm(1000000, 0, sqrt(178))
#' z1alt <- s1alt / sqrt(178)
#' z2alt <- (s1alt + s2) / sqrt(178 + n2)
#' sum(z1alt >= x$upper$bound[1] | z2alt >= x$upper$bound[2]) / 1000000
#' 
#' @aliases sfLinear
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @rdname sfLinear
#' @export
#' 
# sfLinear function [sinew] ----
sfLinear <- function(alpha, t, param) {
  x <- list(
    name = "Piecewise linear", param = param, parname = "line points", sf = sfLinear, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  if (!is.numeric(param)) {
    stop("sfLinear parameter param must be numeric")
  }
  j <- length(param)
  if (floor(j / 2) * 2 != j) {
    stop("sfLinear parameter param must have even length")
  }
  k <- j / 2
  if (max(param) > 1 || min(param) < 0) {
    stop("Timepoints and cumulative proportion of spending must be >= 0 and <= 1 in sfLinear")
  }
  if (k > 1) {
    inctime <- x$param[1:k] - c(0, x$param[1:(k - 1)])
    incspend <- x$param[(k + 1):j] - c(0, x$param[(k + 1):(j - 1)])
    if ((j > 2) && (min(inctime) <= 0)) {
      stop("Timepoints must be strictly increasing in sfLinear")
    }
    if ((j > 2) && (min(incspend) < 0)) {
      stop("Spending must be non-decreasing in sfLinear")
    }
  }
  s <- t
  s[t <= 0] <- 0
  s[t >= 1] <- 1
  ind <- (0 < t) & (t <= param[1])
  s[ind] <- param[k + 1] * t[ind] / param[1]
  ind <- (1 > t) & (t >= param[k])
  s[ind] <- param[j] + (t[ind] - param[k]) / (1 - param[k]) * (1 - param[j])
  if (k > 1) {
    for (i in 2:k)
    {
      ind <- (param[i - 1] < t) & (t <= param[i])
      s[ind] <- param[k + i - 1] + (t[ind] - param[i - 1]) /
        (param[i] - param[i - 1]) *
        (param[k + i] - param[k + i - 1])
    }
  }
  x$spend <- alpha * s
  x
}

#' @export 
#' @rdname sfLinear
# sfStep function [sinew] ----
sfStep <- function(alpha, t, param) {
  x <- list(
    name = "Step ", param = param, parname = "line points", sf = sfStep, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  if (!is.numeric(param)) {
    stop("sfStep parameter param must be numeric")
  }

  j <- length(param)
  if (floor(j / 2) * 2 != j) {
    stop("sfStep parameter param must have even length")
  }
  k <- j / 2

  if (max(param) > 1 || min(param) < 0) {
    stop("Timepoints and cumulative proportion of spending must be >= 0 and <= 1 in sfStep")
  }
  inctime <- param[1]
  if (k>1) inctime <- c(inctime, param[2:k] - param[1:(k-1)])
  if (min(inctime <= 0)) stop("Timepoints in param must be strictly increasing in sfStep")
  incspend <- param[k+1]
  if (k > 1) incspend <- c(incspend, param[(k + 2):j] - param[(k+1):(j-1)])
  if (min(incspend) < 0) stop("Spending in param must be non-decreasing in sfStep")
  s <- rep(-3, length(t))
  s[t < param[1]] <- 0
  s[t >= param[k]] <- param[j]
  s[t >= 1] <- 1
  if (k > 1){
     for (i in 1:(k-1)){
       ind <- (param[i] <= t) & (t < param[i+1])
       s[ind] <- param[k + i]
     }
  }
  x$spend <- alpha * s
  x
}

# sfPoints roxy [sinew] ----
#' @title  Pointwise Spending Function
#'
#' @description The function \code{sfPoints} implements a spending function with values
#' specified for an arbitrary set of specified points. It is now recommended to
#' use sfLinear rather than sfPoints. Normally \code{sfPoints} will be passed
#' to \code{gsDesign} in the parameter \code{sfu} for the upper bound or
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence,
#' just the points they wish to specify. If using \code{sfPoints()} in a
#' design, it is recommended to specify how to interpolate between the
#' specified points (e.g,, linear interpolation); also consider fitting smooth
#' spending functions; see \link{Spending_Function_Overview}.
#'
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from >0 and <=1.  Values
#' of the proportion of sample size/information for which the spending function
#' will be computed.
#' @param param A vector of the same length as \code{t} specifying the
#' cumulative proportion of spending to corresponding to each point in
#' \code{t}; must be >=0 and <=1.
#' @return An object of type \code{spendfn}. See spending functions for further
#' details.
#' @examples
#' library(ggplot2)
#' # example to specify spending on a pointwise basis
#' x <- gsDesign(
#'   k = 6, sfu = sfPoints, sfupar = c(.01, .05, .1, .25, .5, 1),
#'   test.type = 2
#' )
#' x
#' 
#' # get proportion of upper spending under null hypothesis
#' # at each analysis
#' y <- x$upper$prob[, 1] / .025
#' 
#' # change to cumulative proportion of spending
#' for (i in 2:length(y))
#'   y[i] <- y[i - 1] + y[i]
#' 
#' # this should correspond to input sfupar
#' round(y, 6)
#' 
#' # plot these cumulative spending points
#' plot(1:6 / 6, y,
#'   main = "Pointwise spending function example",
#'   xlab = "Proportion of final sample size",
#'   ylab = "Cumulative proportion of spending",
#'   type = "p"
#' )
#' 
#' # approximate this with a t-distribution spending function
#' # by fitting 3 points
#' tx <- 0:100 / 100
#' lines(tx, sfTDist(1, tx, c(c(1, 3, 5) / 6, .01, .1, .5))$spend)
#' text(x = .6, y = .9, labels = "Pointwise Spending Approximated by")
#' text(x = .6, y = .83, "t-Distribution Spending with 3-point interpolation")
#' 
#' # example without lower spending at initial interim or
#' # upper spending at last interim
#' x <- gsDesign(
#'   k = 3, sfu = sfPoints, sfupar = c(.25, .25),
#'   sfl = sfPoints, sflpar = c(0, .25)
#' )
#' x
#' 
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}, \link{sfLogistic}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @rdname sfPoints
#' @export
# sfPoints function [sinew] ----
sfPoints <- function(alpha, t, param) {
  x <- list(
    name = "User-specified", param = param, parname = "Points", sf = sfPoints, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  k <- length(t)
  j <- length(param)

  if (j == k - 1) {
    x$param <- c(param, 1)
    j <- k
  }

  if (j != k) {
    stop("Cumulative user-specified proportion of spending must be specified for each interim analysis")
  }

  if (!is.numeric(param)) {
    stop("Numeric user-specified spending levels not given")
  }

  incspend <- x$param - c(0, x$param[1:k - 1])

  if (min(incspend) < 0.) {
    stop("Cumulative user-specified spending levels must be non-decreasing with each analysis")
  }

  if (max(x$param) > 1.) {
    stop("Cumulative user-specified spending must be >= 0 and <= 1")
  }

  x$spend <- alpha * x$param

  x
}

# sfPower roxy [sinew] ----
#' @title Kim-DeMets (power) Spending Function
#'
#' @description The function \code{sfPower()} implements a Kim-DeMets (power) spending
#' function. This is a flexible, one-parameter spending function recommended by
#' Jennison and Turnbull (2000). Normally it will be passed to
#' \code{gsDesign()} in the parameter \code{sfu} for the upper bound or
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence.
#' The calling sequence is useful, however, when the user wishes to plot a
#' spending function as demonstrated below in examples.
#'
#' A Kim-DeMets spending function takes the form \deqn{f(t;\alpha,\rho)=\alpha
#' t^\rho}{f(t; alpha, rho) = alpha t^rho} where \eqn{\rho}{rho} is the value
#' passed in \code{param}. See examples below for a range of values of
#' \eqn{\rho}{rho} that may be of interest (\code{param=0.75} to \code{3} are
#' documented there).
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param A single, positive value specifying the \eqn{\rho}{rho}
#' parameter for which Kim-DeMets spending is to be computed; allowable range
#' is (0,15]
#' @return An object of type \code{spendfn}. See \link{Spending_Function_Overview} for further details.
#' @examples
#' library(ggplot2)
#' # design a 4-analysis trial using a Kim-DeMets spending function
#' # for both lower and upper bounds
#' x <- gsDesign(k = 4, sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 1.5)
#' 
#' # print the design
#' x
#' 
#' # plot the spending function using many points to obtain a smooth curve
#' # show rho=3 for approximation to O'Brien-Fleming and rho=.75 for
#' # approximation to Pocock design.
#' # Also show rho=2 for an intermediate spending.
#' # Compare these to Hwang-Shih-DeCani spending with gamma=-4,  -2,  1
#' t <- 0:100 / 100
#' plot(t, sfPower(0.025, t, 3)$spend,
#'   xlab = "Proportion of sample size",
#'   ylab = "Cumulative Type I error spending",
#'   main = "Kim-DeMets (rho) versus Hwang-Shih-DeCani (gamma) Spending",
#'   type = "l", cex.main = .9
#' )
#' lines(t, sfPower(0.025, t, 2)$spend, lty = 2)
#' lines(t, sfPower(0.025, t, 0.75)$spend, lty = 3)
#' lines(t, sfHSD(0.025, t, 1)$spend, lty = 3, col = 2)
#' lines(t, sfHSD(0.025, t, -2)$spend, lty = 2, col = 2)
#' lines(t, sfHSD(0.025, t, -4)$spend, lty = 1, col = 2)
#' legend(
#'   x = c(.0, .375), y = .025 * c(.65, 1), lty = 1:3,
#'   legend = c("rho= 3", "rho= 2", "rho= 0.75")
#' )
#' legend(
#'   x = c(.0, .357), y = .025 * c(.65, .85), lty = 1:3, bty = "n", col = 2,
#'   legend = c("gamma= -4", "gamma= -2", "gamma=1")
#' )
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @rdname sfPower
#' @export
# sfPower function [sinew] ----
sfPower <- function(alpha, t, param) {
  # K. Wills 12/11/08: restrict param range
  # checkScalar(param, "numeric", c(0, Inf), c(FALSE, TRUE))
  checkScalar(param, "numeric", c(0, 15), c(FALSE, TRUE))

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  x <- list(
    name = "Kim-DeMets (power)", param = param, parname = "rho", sf = sfPower,
    spend = alpha * t^param, bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# sfTDist roxy [sinew] ----
#' @title t-distribution Spending Function
#'
#' @description The function \code{sfTDist()} provides perhaps the maximum flexibility among
#' spending functions provided in the \code{gsDesign} package. This function
#' allows fitting of three points on a cumulative spending function curve; in
#' this case, six parameters are specified indicating an x and a y coordinate
#' for each of 3 points. Normally this function will be passed to
#' \code{gsDesign()} in the parameter \code{sfu} for the upper bound or
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence.
#' The calling sequence is useful, however, when the user wishes to plot a
#' spending function as demonstrated below in examples.
#'
#' The t-distribution spending function takes the form \deqn{f(t;\alpha)=\alpha
#' F(a+bF^{-1}(t))} where \eqn{F()} is a cumulative t-distribution function
#' with \code{df} degrees of freedom and \eqn{F^{-1}()} is its inverse.
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param In the three-parameter specification, the first paramater (a)
#' may be any real value, the second (b) any positive value, and the third
#' parameter (df=degrees of freedom) any real value 1 or greater. When
#' \code{gsDesign()} is called with a t-distribution spending function, this is
#' the parameterization printed.  The five parameter specification is
#' \code{c(t1,t2,u1,u2,df)} where the objective is that the resulting
#' cumulative proportion of spending at \code{t} represented by \code{sf(t)}
#' satisfies \code{sf(t1)=alpha*u1}, \code{sf(t2)=alpha*u2}. The t-distribution
#' used has \code{df} degrees of freedom.  In this parameterization, all the
#' first four values must be between 0 and 1 and \code{t1 < t2}, \code{u1 <
#' u2}.  The final parameter is any real value of 1 or more. This
#' parameterization can fit any two points satisfying these requirements.  The
#' six parameter specification attempts to fit 3 points, but does not have
#' flexibility to fit any three points.  In this case, the specification for
#' \code{param} is c(t1,t2,t3,u1,u2,u3) where the objective is that
#' \code{sf(t1)=alpha*u1}, \code{sf(t2)=alpha*u2}, and \code{sf(t3)=alpha*u3}.
#' See examples to see what happens when points are specified that cannot be
#' fit.
#' @return An object of type \code{spendfn}. See spending functions for further
#' details.
#' @examples
#' library(ggplot2)
#' # 3-parameter specification: a,  b,  df
#' sfTDist(1, 1:5 / 6, c(-1, 1.5, 4))$spend
#' 
#' # 5-parameter specification fits 2 points,  in this case
#' # the 1st 2 interims are at 25% and 50% of observations with
#' # cumulative error spending of 10% and 20%, respectively
#' # final parameter is df
#' sfTDist(1, 1:3 / 4, c(.25, .5, .1, .2, 4))$spend
#' 
#' # 6-parameter specification fits 3 points
#' # Interims are at 25%. 50% and 75% of observations
#' # with cumulative spending of 10%, 20% and 50%, respectively
#' # Note: not all 3 point combinations can be fit
#' sfTDist(1, 1:3 / 4, c(.25, .5, .75, .1, .2, .5))$spend
#' 
#' # Example of error message when the 3-points specified
#' # in the 6-parameter version cannot be fit
#' try(sfTDist(1, 1:3 / 4, c(.25, .5, .75, .1, .2, .3))$errmsg)
#' 
#' # sfCauchy (sfTDist with 1 df) and sfNormal (sfTDist with infinite df)
#' # show the limits of what sfTdist can fit
#' # for the third point are u3 from 0.344 to 0.6 when t3=0.75
#' sfNormal(1, 1:3 / 4, c(.25, .5, .1, .2))$spend[3]
#' sfCauchy(1, 1:3 / 4, c(.25, .5, .1, .2))$spend[3]
#' 
#' # plot a few t-distribution spending functions fitting
#' # t=0.25, .5 and u=0.1, 0.2
#' # to demonstrate the range of flexibility
#' t <- 0:100 / 100
#' plot(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 1))$spend,
#'   xlab = "Proportion of final sample size",
#'   ylab = "Cumulative Type I error spending",
#'   main = "t-Distribution Spending Function Examples", type = "l"
#' )
#' lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 1.5))$spend, lty = 2)
#' lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 3))$spend, lty = 3)
#' lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 10))$spend, lty = 4)
#' lines(t, sfTDist(0.025, t, c(.25, .5, .1, .2, 100))$spend, lty = 5)
#' legend(
#'   x = c(.0, .3), y = .025 * c(.7, 1), lty = 1:5,
#'   legend = c("df = 1", "df = 1.5", "df = 3", "df = 10", "df = 100")
#' )
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @rdname sfTDist
#' @export
#' @importFrom stats qt uniroot pt
# sfTDist function [sinew] ----
sfTDist <- function(alpha, t, param) {
  x <- list(
    name = "t-distribution", param = param, parname = c("a", "b", "df"), sf = sfTDist, spend = NULL,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1
  checkVector(param, "numeric")
  len <- length(param)

  if (len == 3) {
    if (param[3] < 1.) {
      stop("Final t-distribution spending parameter must be real value at least 1")
    }

    a <- param[1]
    b <- param[2]
    df <- param[3]
  }
  else if (len == 5) {
    t0 <- param[1:2]
    p0 <- param[3:4]
    df <- param[5]

    if (param[5] < 1.) {
      stop("Final t-distribution spending parameter must be real value at least 1")
    }

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("5-parameter specification of t-distribution spending function incorrect")
    }

    xv <- stats::qt(t0, df)
    y <- stats::qt(p0, df)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
  }
  else if (len == 6) {
    t0 <- param[1:3]
    p0 <- param[4:6]

    if (t0[2] <= t0[1] || p0[2] <= p0[1]) {
      stop("6-parameter specification of t-distribution spending function incorrect")
    }

    # check Cauchy and normal which must err in opposite directions for a solution to exist
    unorm <- sfNormal(alpha, t0[3], param = c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]
    ucauchy <- sfCauchy(alpha, t0[3], param = c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]

    if (unorm * ucauchy >= 0.) {
      stop("6-parameter specification of t-distribution spending function did not produce a solution")
    }

    sol <- stats::uniroot(Tdistdiff, interval = c(1, 200), t0 = t0, p0 = p0)
    df <- sol$root
    xv <- stats::qt(t0, df)
    y <- stats::qt(p0, df)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
  }
  else {
    stop("t-distribution spending function parameter must be of length 3, 5 or 6")
  }

  x$param <- c(a, b, df)
  t[t > 1] <- 1
  xv <- stats::qt(1 * (!is.element(t, 1)) * t, df)
  y <- stats::pt(a + b * xv, df)
  x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))

  x
}

# sfTruncated roxy [sinew] ----
#' @title Truncated, trimmed and gapped spending functions
#' @description The functions \code{sfTruncated()} and \code{sfTrimmed} apply any other
#' spending function over a restricted range. This allows eliminating spending
#' for early interim analyses when you desire not to stop for the bound being
#' specified; this is usually applied to eliminate early tests for a positive
#' efficacy finding. The truncation can come late in the trial if you desire to
#' stop a trial any time after, say, 90 percent of information is available and
#' an analysis is performed. This allows full Type I error spending if the
#' final analysis occurs early. Both functions set cumulative spending to 0
#' below a 'spending interval' in the interval [0,1], and set cumulative
#' spending to 1 above this range. \code{sfTrimmed()} otherwise does not change
#' an input spending function that is specified; probably the preferred and
#' more intuitive method in most cases. \code{sfTruncated()} resets the time
#' scale on which the input spending function is computed to the 'spending
#' interval.'
#'
#' \code{sfGapped()} allows elimination of analyses after some time point in
#' the trial; see details and examples.
#'
#' \code{sfTrimmed} simply computes the value of the input spending function
#' and parameters in the sub-range of [0,1], sets spending to 0 below this
#' range and sets spending to 1 above this range.
#'
#' \code{sfGapped} spends outside of the range provided in trange. Below
#' trange, the input spending function is used. Above trange, full spending is
#' used; i.e., the first analysis performed above the interval in trange is the
#' final analysis. As long as the input spending function is strictly
#' increasing, this means that the first interim in the interval trange is the
#' final interim analysis for the bound being specified.
#'
#' \code{sfTruncated} compresses spending into a sub-range of [0,1]. The
#' parameter \code{param$trange} specifies the range over which spending is to
#' occur. Within this range, spending is spent according to the spending
#' function specified in \code{param$sf} along with the corresponding spending
#' function parameter(s) in \code{param$param}. See example using
#' \code{sfLinear} that spends uniformly over specified range.
#'
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size or information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size or information for which the
#' spending function will be computed.
#' @param param a list containing the elements sf (a spendfn object such as
#' sfHSD), trange (the range over which the spending function increases from 0
#' to 1; 0 <= trange[1]<trange[2] <=1; for sfGapped, trange[1] must be > 0),
#' and param (null for a spending function with no parameters or a scalar or
#' vector of parameters needed to fully specify the spending function in sf).
#' @return An object of type \code{spendfn}. See \code{\link{Spending_Function_Overview}} 
#' for further details.
#' @examples
#' 
#' 
#' # Eliminate efficacy spending forany interim at or before 20 percent of information.
#' # Complete spending at first interim at or after 80 percent of information.
#' tx <- (0:100) / 100
#' s <- sfHSD(alpha = .05, t = tx, param = 1)$spend
#' x <- data.frame(t = tx, Spending = s, sf = "Original spending")
#' param <- list(trange = c(.2, .8), sf = sfHSD, param = 1)
#' s <- sfTruncated(alpha = .05, t = tx, param = param)$spend
#' x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Truncated"))
#' s <- sfTrimmed(alpha = .05, t = tx, param = param)$spend
#' x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Trimmed"))
#' s <- sfGapped(alpha = .05, t = tx, param = param)$spend
#' x <- rbind(x, data.frame(t = tx, Spending = s, sf = "Gapped"))
#' ggplot2::ggplot(x, ggplot2::aes(x = t, y = Spending, col = sf)) + 
#' ggplot2::geom_line()
#' 
#' 
#' # now apply the sfTrimmed version in gsDesign
#' # initially, eliminate the early efficacy analysis
#' # note: final spend must occur at > next to last interim
#' x <- gsDesign(
#'   k = 4, n.fix = 100, sfu = sfTrimmed,
#'   sfupar = list(sf = sfHSD, param = 1, trange = c(.3, .9))
#' )
#' 
#' # first upper bound=20 means no testing there
#' gsBoundSummary(x)
#' 
#' # now, do not eliminate early efficacy analysis
#' param <- list(sf = sfHSD, param = 1, trange = c(0, .9))
#' x <- gsDesign(k = 4, n.fix = 100, sfu = sfTrimmed, sfupar = param)
#' 
#' # The above means if final analysis is done a little early, all spending can occur
#' # Suppose we set calendar date for final analysis based on
#' # estimated full information, but come up with only 97 pct of plan
#' xA <- gsDesign(
#'   k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], .97 * x$n.I[4]),
#'   test.type = x$test.type,
#'   maxn.IPlan = x$n.I[x$k],
#'   sfu = sfTrimmed, sfupar = param
#' )
#' # now accelerate without the trimmed spending function
#' xNT <- gsDesign(
#'   k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], .97 * x$n.I[4]),
#'   test.type = x$test.type,
#'   maxn.IPlan = x$n.I[x$k],
#'   sfu = sfHSD, sfupar = 1
#' )
#' # Check last bound if analysis done at early time
#' x$upper$bound[4]
#' # Now look at last bound if done at early time with trimmed spending function
#' # that allows capture of full alpha
#' xA$upper$bound[4]
#' # With original spending function, we don't get full alpha and therefore have
#' # unnecessarily stringent bound at final analysis
#' xNT$upper$bound[4]
#' 
#' # note that if the last analysis is LATE, all 3 approaches should give the same
#' # final bound that has a little larger z-value
#' xlate <- gsDesign(
#'   k = x$k, n.fix = 100, n.I = c(x$n.I[1:3], 1.25 * x$n.I[4]),
#'   test.type = x$test.type,
#'   maxn.IPlan = x$n.I[x$k],
#'   sfu = sfHSD, sfupar = 1
#' )
#' xlate$upper$bound[4]
#' 
#' # eliminate futility after the first interim analysis
#' # note that by setting trange[1] to .2, the spend at t=.2 is used for the first
#' # interim at or after 20 percent of information
#' x <- gsDesign(n.fix = 100, sfl = sfGapped, sflpar = list(trange = c(.2, .9), sf = sfHSD, param = 1))
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @export
#' @rdname sfSpecial
# sfTruncated function [sinew] ----
sfTruncated <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  if (!is.list(param)) stop("param must be a list. See help(sfTruncated)")
  if (!max(names(param) == "trange")) stop("param must include trange, sf, param. See help(sfTruncated)")
  if (!max(names(param) == "sf")) stop("param must include trange, sf, param. See help(sfTruncated)")
  if (!max(names(param) == "param")) stop("param must include trange, sf, param. See help(sfTruncated)")
  if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTruncated)")
  if (length(param$trange) != 2) stop("param$trange parameter must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTruncated)")
  if (param$trange[1] >= 1. | param$trange[2] <= param$trange[1] | param$trange[2] <= 0) {
    stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] < param$trange[2]<=1. See help(sfTruncated)")
  }
  if (!inherits(param$sf, "function")) stop("param$sf must be a spending function")
  if (!is.numeric(param$param)) stop("param$param must be numeric")
  spend <- as.vector(rep(0, length(t)))
  spend[t >= param$trange[2]] <- alpha
  indx <- param$trange[1] < t & t < param$trange[2]
  if (max(indx)) {
    s <- param$sf(alpha = alpha, t = (t[indx] - param$trange[1]) / (param$trange[2] - param$trange[1]), param$param)
    spend[indx] <- s$spend
  }
  # the following line is awkward, but necessary to get the input spending function name in some cases
  param2 <- param$sf(alpha = alpha, t = .5, param = param$param)
  param$name <- param2$name
  param$parname <- param2$parname
  x <- list(
    name = "Truncated", param = param, parname = "range",
    sf = sfTruncated, spend = spend, bound = NULL, prob = NULL
  )
  class(x) <- "spendfn"
  x
}

# sfTrimmed roxy [sinew] ----
#' @export
#' @rdname sfSpecial
# sfTrimmed function [sinew] ----
sfTrimmed <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  if (!is.list(param)) stop("param must be a list. See help(sfTrimmed)")
  if (!max(names(param) == "trange")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!max(names(param) == "sf")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!max(names(param) == "param")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTrimmed)")
  if (length(param$trange) != 2) stop("param$trange parameter must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTrimmed)")
  if (param$trange[1] >= 1. | param$trange[2] <= param$trange[1] | param$trange[2] <= 0) {
    stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] < param$trange[2]<=1. See help(sfTrimmed)")
  }
  if (!inherits(param$sf, "function")) stop("param$sf must be a spending function")
  if (!is.numeric(param$param)) stop("param$param must be numeric")
  spend <- as.vector(rep(0, length(t)))
  spend[t >= param$trange[2]] <- alpha
  indx <- param$trange[1] < t & t < param$trange[2]
  if (max(indx)) {
    s <- param$sf(alpha = alpha, t = t[indx], param$param)
    spend[indx] <- s$spend
  }
  # the following line is awkward, but necessary to get the input spending function name in some cases
  param2 <- param$sf(alpha = alpha, t = .5, param = param$param)
  param$name <- param2$name
  param$parname <- param2$parname
  x <- list(
    name = "Trimmed", param = param, parname = "range",
    sf = sfTrimmed, spend = spend, bound = NULL, prob = NULL
  )
  class(x) <- "spendfn"
  x
}

# sfGapped roxy [sinew] ----
#' @export
#' @rdname sfSpecial
# sfGapped function [sinew] ----
sfGapped <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  if (!is.list(param)) stop("param must be a list. See help(sfTrimmed)")
  if (!max(names(param) == "trange")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!max(names(param) == "sf")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!max(names(param) == "param")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 < param$trange[1] < param$trange[2]<=1. See help(sfGapped)")
  if (length(param$trange) != 2) stop("param$trange parameter must be a vector of length 2 with 0 < param$trange[1] <param$trange[2]<=1. See help(sfGapped)")
  if (param$trange[1] >= 1. | param$trange[2] <= param$trange[1] | param$trange[2] <= 0 | param$trange[1] <= 0) {
    stop("param$trange must be a vector of length 2 with 0 < param$trange[1] < param$trange[2]<=1. See help(sfTrimmed)")
  }
  if (!inherits(param$sf, "function")) stop("param$sf must be a spending function")
  if (!is.numeric(param$param)) stop("param$param must be numeric")
  spend <- as.vector(rep(0, length(t)))
  spend[t >= param$trange[2]] <- alpha
  indx <- param$trange[1] > t
  if (max(indx)) {
    s <- param$sf(alpha = alpha, t = t[indx], param$param)
    spend[indx] <- s$spend
  }
  indx <- (param$trange[1] <= t & param$trange[2] > t)
  if (max(indx)) {
    spend[indx] <- param$sf(alpha = alpha, t = param$trange[1], param$param)$spend
  }
  # the following line is awkward, but necessary to get the input spending function name in some cases
  param2 <- param$sf(alpha = alpha, t = .5, param = param$param)
  param$name <- param2$name
  param$parname <- param2$parname
  x <- list(
    name = "Gapped", param = param, parname = "range",
    sf = sfGapped, spend = spend, bound = NULL, prob = NULL
  )
  class(x) <- "spendfn"
  x
}

# spendingFunction roxy [sinew] ----
#' @export
#' @aliases spendingFunction
# spendingFunction function [sinew] ----
spendingFunction <- function(alpha, t, param) {
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t > 1] <- 1

  x <- list(
    name = "Linear", param = param, parname = "none", sf = spendingFunction, spend = alpha * t,
    bound = NULL, prob = NULL
  )

  class(x) <- "spendfn"

  x
}

# diffbetadist roxy [sinew] ----
#' @importFrom stats pbeta
# diffbetadist function [sinew] ----
diffbetadist <- function(aval, xval, uval) {
  if (min(aval) <= 0.) {
    return(1000)
  }

  diff <- uval - stats::pbeta(xval, aval[1], aval[2])

  sum(diff^2)
}

# Tdistdiff roxy [sinew] ----
#' @importFrom stats qt
# Tdistdiff function [sinew] ----
Tdistdiff <- function(x, t0, p0) {
  xv <- stats::qt(t0, x)
  y <- stats::qt(p0, x)
  b <- (y[2] - y[1]) / (xv[2] - xv[1])
  a <- y[2] - b * xv[2]

  a + b * xv[3] - y[3]
}
