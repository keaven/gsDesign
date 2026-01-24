# eEvents roxy [sinew] ----
#' Expected number of events for a time-to-event study
#'
#' `eEvents()` is used to calculate the expected number of events for a
#' population with a time-to-event endpoint.  It is based on calculations
#' demonstrated in Lachin and Foulkes (1986) and is fundamental in computations
#' for the sample size method they propose. Piecewise exponential survival and
#' dropout rates are supported as well as piecewise uniform enrollment. A
#' stratified population is allowed. Output is the expected number of events
#' observed given a trial duration and the above rate parameters.
#'
#' \code{eEvents()} produces an object of class \code{eEvents} with the number
#' of subjects and events for a set of pre-specified trial parameters, such as
#' accrual duration and follow-up period. The underlying power calculation is
#' based on Lachin and Foulkes (1986) method for proportional hazards assuming
#' a fixed underlying hazard ratio between 2 treatment groups. The method has
#' been extended here to enable designs to test non-inferiority. Piecewise
#' constant enrollment and failure rates are assumed and a stratified
#' population is allowed. See also \code{\link{nSurvival}} for other Lachin and
#' Foulkes (1986) methods assuming a constant hazard difference or exponential
#' enrollment rate.
#'
#' \code{print.eEvents()} formats the output for an object of class
#' \code{eEvents} and returns the input value.
#'
#' @param lambda scalar, vector or matrix of event hazard rates; rows represent
#' time periods while columns represent strata; a vector implies a single
#' stratum.
#' @param eta scalar, vector or matrix of dropout hazard rates; rows represent
#' time periods while columns represent strata; if entered as a scalar, rate is
#' constant across strata and time periods; if entered as a vector, rates are
#' constant across strata.
#' @param gamma a scalar, vector or matrix of rates of entry by time period
#' (rows) and strata (columns); if entered as a scalar, rate is constant
#' across strata and time periods; if entered as a vector, rates are constant
#' across strata.
#' @param R a scalar or vector of durations of time periods for recruitment
#' rates specified in rows of \code{gamma}. Length is the same as number of
#' rows in \code{gamma}. In \code{eEvents()}, recruitment after the final
#' period is assumed to be 0 if \code{T} exceeds \code{sum(R)}; the final
#' period is only extended in designs where \code{T} is solved for (e.g.,
#' \code{nSurv} with \code{T = NULL}).
#' @param S a scalar or vector of durations of piecewise constant event rates
#' specified in rows of \code{lambda}, \code{eta} and \code{etaE}; this is NULL
#' if there is a single event rate per stratum (exponential failure) or length
#' of the number of rows in \code{lambda} minus 1, otherwise.
#' @param T time of analysis; if \code{Tfinal=NULL}, this is also the study
#' duration.
#' @param Tfinal Study duration; if \code{NULL}, this will be replaced with
#' \code{T} on output.
#' @param minfup time from end of planned enrollment (\code{sum(R)} from output
#' value of \code{R}) until \code{Tfinal}.
#' @param x an object of class \code{eEvents} returned from \code{eEvents()}.
#' @param digits which controls number of digits for printing.
#' @param ... Other arguments that may be passed to the generic print function.
#' @return \code{eEvents()} and \code{print.eEvents()} return an object of
#' class \code{eEvents} which contains the following items: \item{lambda}{as
#' input; converted to a matrix on output.} \item{eta}{as input; converted to a
#' matrix on output.} \item{gamma}{as input.} \item{R}{as input.} \item{S}{as
#' input.} \item{T}{as input.} \item{Tfinal}{planned duration of study.}
#' \item{minfup}{as input.} \item{d}{expected number of events.}
#' \item{n}{expected sample size.} \item{digits}{as input.}
#' @examples
#'
#' # 3 enrollment periods, 3 piecewise exponential failure rates
#' str(eEvents(
#'   lambda = c(.05, .02, .01), eta = .01, gamma = c(5, 10, 20),
#'   R = c(2, 1, 2), S = c(1, 1), T = 20
#' ))
#'
#' # control group for example from Bernstein and Lagakos (1978)
#' lamC <- c(1, .8, .5)
#' n <- eEvents(
#'   lambda = matrix(c(lamC, lamC * 2 / 3), ncol = 6), eta = 0,
#'   gamma = matrix(.5, ncol = 6), R = 2, T = 4
#' )
#'
#' @aliases print.eEvents
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{gsDesign package overview}, \link{plot.gsDesign},
#' \code{\link{gsDesign}}, \code{\link{gsHR}},
#' \code{\link{nSurvival}}
#' @references Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and
#' Power for Analyses of Survival with Allowance for Nonuniform Patient Entry,
#' Losses to Follow-Up, Noncompliance, and Stratification. \emph{Biometrics},
#' 42, 507-519.
#'
#' Bernstein D and Lagakos S (1978), Sample size and power determination for
#' stratified clinical trials. \emph{Journal of Statistical Computation and
#' Simulation}, 8:65-73.
#' @keywords design
#' @rdname eEvents
#' @export
# eEvents function [sinew] ----
eEvents <- function(lambda = 1, eta = 0, gamma = 1, R = 1, S = NULL, T = 2,
                    Tfinal = NULL, minfup = 0, digits = 4) {
  if (is.null(Tfinal)) {
    if (minfup >= T) {
      stop("Minimum follow-up greater than study duration.")
    }
    Tfinal <- T
    minfupia <- minfup
  } else {
    minfupia <- max(0, minfup - (Tfinal - T))
  }
  if (!is.null(S)) {
    if (!is.numeric(S) || any(is.na(S)) || any(!is.finite(S)) || any(S <= 0)) {
      stop("S must be a numeric vector of positive values")
    }
  }

  if (!is.matrix(lambda)) {
    lambda <- matrix(lambda, nrow = length(lambda))
  }
  if (!is.matrix(eta)) {
    eta <- matrix(eta, nrow = nrow(lambda), ncol = ncol(lambda))
  }
  if (!is.matrix(gamma)) {
    gamma <- matrix(gamma, nrow = length(R), ncol = ncol(lambda))
  }
  n <- rep(0, ncol(lambda))
  d <- n
  for (i in seq_len(ncol(lambda)))
  {
    # KA: updated following line with as.vector statements 10/16/2017
    a <- eEvents1(
      lambda = as.vector(lambda[, i]), eta = as.vector(eta[, i]),
      gamma = as.vector(gamma[, i]), R = R, S = S, T = T,
      Tfinal = Tfinal, minfup = minfup
    )
    n[i] <- a$n
    d[i] <- a$d
  }
  T1 <- cumsum(S)
  T1 <- unique(c(0, T1[T1 < T], T))
  nper <- length(T1) - 1
  names1 <- round(T1[1:nper], digits)
  namesper <- paste("-", round(T1[2:(nper + 1)], digits), sep = "")
  namesper <- paste(names1, namesper, sep = "")
  if (nper < dim(lambda)[1]) {
    lambda <- matrix(lambda[1:nper, ], nrow = nper)
  }
  if (nper < dim(eta)[1]) {
    eta <- matrix(eta[1:nper, ], nrow = nper)
  }
  rownames(lambda) <- namesper
  rownames(eta) <- namesper
  colnames(lambda) <- paste("Stratum", seq_len(ncol(lambda)))
  colnames(eta) <- paste("Stratum", seq_len(ncol(eta)))
  T2 <- cumsum(R)
  T2[T - T2 < minfupia] <- T - minfupia
  T2 <- unique(c(0, T2))
  nper <- length(T2) - 1
  names1 <- round(c(T2[1:nper]), digits)
  namesper <- paste("-", round(T2[2:(nper + 1)], digits), sep = "")
  namesper <- paste(names1, namesper, sep = "")
  if (nper < length(gamma)) {
    gamma <- matrix(gamma[1:nper, ], nrow = nper)
  }
  rownames(gamma) <- namesper
  colnames(gamma) <- paste("Stratum", seq_len(ncol(gamma)))
  x <- list(
    lambda = lambda, eta = eta, gamma = gamma, R = R,
    S = S, T = T, Tfinal = Tfinal,
    minfup = minfup, d = d, n = n, digits = digits
  )
  class(x) <- "eEvents"
  return(x)
}
