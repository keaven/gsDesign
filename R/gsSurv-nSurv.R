# nSurv roxy [sinew] ----
#' Advanced time-to-event sample size calculation
#'
#' \code{nSurv()} is used to calculate the sample size for a clinical trial
#' with a time-to-event endpoint and an assumption of proportional hazards.
#' This set of routines is new with version 2.7 and will continue to be
#' modified and refined to improve input error checking and output format with
#' subsequent versions. It allows both the Lachin and Foulkes (1986) method
#' (fixed trial duration) as well as the Kim and Tsiatis (1990) method (fixed
#' enrollment rates and either fixed enrollment duration or fixed minimum
#' follow-up). Piecewise exponential survival is supported as well as piecewise
#' constant enrollment and dropout rates. The methods are for a 2-arm trial
#' with treatment groups referred to as experimental and control. A stratified
#' population is allowed as in Lachin and Foulkes (1986); this method has been
#' extended to derive non-inferiority as well as superiority trials.
#' Stratification also allows power calculation for meta-analyses.
#' \code{gsSurv()} combines \code{nSurv()} with \code{gsDesign()} to derive a
#' group sequential design for a study with a time-to-event endpoint.
#'
#' @details
#' \code{print()}, \code{xtable()} and \code{summary()} methods are provided to
#' operate on the returned value from \code{gsSurv()}, an object of class
#' \code{gsSurv}. \code{print()} is also extended to \code{nSurv} objects. The
#' functions \code{\link{gsBoundSummary}} (data frame for tabular output),
#' \code{\link{xprint}} (application of \code{xtable} for tabular output) and
#' \code{summary.gsSurv} (textual summary of \code{gsDesign} or \code{gsSurv}
#' object) may be preferred summary functions; see example in vignettes. See
#' also \link{gsBoundSummary} for output
#' of tabular summaries of bounds for designs produced by \code{gsSurv()}.
#'
#' Both \code{nEventsIA} and \code{tEventsIA} require a group sequential design
#' for a time-to-event endpoint of class \code{gsSurv} as input.
#' \code{nEventsIA} calculates the expected number of events under the
#' alternate hypothesis at a given interim time. \code{tEventsIA} calculates
#' the time that the expected number of events under the alternate hypothesis
#' is a given proportion of the total events planned for the final analysis.
#'
#' \code{nSurv()} produces an object of class \code{nSurv} with the number of
#' subjects and events for a set of pre-specified trial parameters, such as
#' accrual duration and follow-up period. The underlying power calculation is
#' based on Lachin and Foulkes (1986) method for proportional hazards assuming
#' a fixed underlying hazard ratio between 2 treatment groups. The method has
#' been extended here to enable designs to test non-inferiority. Piecewise
#' constant enrollment and failure rates are assumed and a stratified
#' population is allowed. See also \code{\link{nSurvival}} for other Lachin and
#' Foulkes (1986) methods assuming a constant hazard difference or exponential
#' enrollment rate.
#'
#' When study duration (\code{T}) and follow-up duration (\code{minfup}) are
#' fixed, \code{nSurv} applies exactly the Lachin and Foulkes (1986) method of
#' computing sample size under the proportional hazards assumption when For
#' this computation, enrollment rates are altered proportionately to those
#' input in \code{gamma} to achieve the power of interest.
#'
#' Given the specified enrollment rate(s) input in \code{gamma}, \code{nSurv}
#' may also be used to derive enrollment duration required for a trial to have
#' defined power if \code{T} is input as \code{NULL}; in this case, both
#' \code{R} (enrollment duration for each specified enrollment rate) and
#' \code{T} (study duration) will be computed on output.
#'
#' Alternatively and also using the fixed enrollment rate(s) in \code{gamma},
#' if minimum follow-up \code{minfup} is specified as \code{NULL}, then the
#' enrollment duration(s) specified in \code{R} are considered fixed and
#' \code{minfup} and \code{T} are computed to derive the desired power. This
#' method will fail if the specified enrollment rates and durations either
#' over-powers the trial with no additional follow-up or underpowers the trial
#' with infinite follow-up. This method produces a corresponding error message
#' in such cases.
#'
#' The input to \code{gsSurv} is a combination of the input to \code{nSurv()}
#' and \code{gsDesign()}.
#'
#' \code{nEventsIA()} is provided to compute the expected number of events at a
#' given point in time given enrollment, event and censoring rates. The routine
#' is used with a root finding routine to approximate the approximate timing of
#' an interim analysis. It is also used to extend enrollment or follow-up of a
#' fixed design to obtain a sufficient number of events to power a group
#' sequential design.
#'
#' @aliases nSurv print.nSurv print.gsSurv xtable.gsSurv
#'
#' @param x An object of class \code{nSurv} or \code{gsSurv}.
#'   \code{print.nSurv()} is used for an object of class \code{nSurv} which will
#'   generally be output from \code{nSurv()}. For \code{print.gsSurv()} is used
#'   for an object of class \code{gsSurv} which will generally be output from
#'   \code{gsSurv()}. \code{nEventsIA} and \code{tEventsIA} operate on both the
#'   \code{nSurv} and \code{gsSurv} class.
#' @param digits Number of digits past the decimal place to print
#'   (\code{print.gsSurv.}); also a pass through to generic \code{xtable()} from
#'   \code{xtable.gsSurv()}.
#' @param lambdaC Scalar, vector or matrix of event hazard rates for the
#'   control group; rows represent time periods while columns represent strata; a
#'   vector implies a single stratum.
#' @param hr Hazard ratio (experimental/control) under the alternate hypothesis
#'   (scalar).
#' @param hr0 Hazard ratio (experimental/control) under the null hypothesis
#'   (scalar).
#' @param eta Scalar, vector or matrix of dropout hazard rates for the control
#'   group; rows represent time periods while columns represent strata; if
#'   entered as a scalar, rate is constant across strata and time periods; if
#'   entered as a vector, rates are constant across strata.
#' @param etaE Matrix dropout hazard rates for the experimental group specified
#'   in like form as \code{eta}; if NULL, this is set equal to \code{eta}.
#' @param gamma A scalar, vector or matrix of rates of entry by time period
#'   (rows) and strata (columns); if entered as a scalar, rate is constant
#'   across strata and time periods; if entered as a vector, rates are constant
#'   across strata.
#' @param R A scalar or vector of durations of time periods for recruitment
#'   rates specified in rows of \code{gamma}. Length is the same as number of
#'   rows in \code{gamma}. Note that when variable enrollment duration is
#'   specified (input \code{T=NULL}), the final enrollment period is extended as
#'   long as needed.
#' @param S A scalar or vector of durations of piecewise constant event rates
#'   specified in rows of \code{lambda}, \code{eta} and \code{etaE}; this is NULL
#'   if there is a single event rate per stratum (exponential failure) or length
#'   of the number of rows in \code{lambda} minus 1, otherwise.
#' @param T Study duration; if \code{T} is input as \code{NULL}, this will be
#'   computed on output; see details.
#' @param minfup Follow-up of last patient enrolled; if \code{minfup} is input
#'   as \code{NULL}, this will be computed on output; see details.
#' @param ratio Randomization ratio of experimental treatment divided by
#'   control; normally a scalar, but may be a vector with length equal to number
#'   of strata.
#' @param sided 1 for 1-sided testing, 2 for 2-sided testing.
#' @param alpha Type I error rate. Default is 0.025 since 1-sided testing is
#'   default.
#' @param beta Type II error rate. Default is 0.10 (90\% power); NULL if power
#'   is to be computed based on other input values.
#' @param tol For cases when \code{T} or \code{minfup} values are derived
#'   through root finding (\code{T} or \code{minfup} input as \code{NULL}),
#'   \code{tol} provides the level of error input to the \code{uniroot()}
#'   root-finding function. The default is the same as for \code{\link{uniroot}}.
#' @param k Number of analyses planned, including interim and final.
#' @param test.type \code{1=}one-sided \cr \code{2=}two-sided symmetric \cr
#'   \code{3=}two-sided, asymmetric, beta-spending with binding lower bound \cr
#'   \code{4=}two-sided, asymmetric, beta-spending with non-binding lower bound
#'   \cr \code{5=}two-sided, asymmetric, lower bound spending under the null
#'   hypothesis with binding lower bound \cr \code{6=}two-sided, asymmetric,
#'   lower bound spending under the null hypothesis with non-binding lower bound.
#'   \cr See details, examples and manual.
#' @param astar Normally not specified. If \code{test.type=5} or \code{6},
#'   \code{astar} specifies the total probability of crossing a lower bound at
#'   all analyses combined.  This will be changed to \eqn{1 - }\code{alpha} when
#'   default value of 0 is used.  Since this is the expected usage, normally
#'   \code{astar} is not specified by the user.
#' @param timing Sets relative timing of interim analyses in \code{gsSurv}.
#'   Default of 1 produces equally spaced analyses.  Otherwise, this is a vector
#'   of length \code{k} or \code{k-1}.  The values should satisfy \code{0 <
#'   timing[1] < timing[2] < ... < timing[k-1] < timing[k]=1}. For
#'   \code{tEventsIA}, this is a scalar strictly between 0 and 1 that indicates
#'   the targeted proportion of final planned events available at an interim
#'   analysis.
#' @param sfu A spending function or a character string indicating a boundary
#'   type (that is, \dQuote{WT} for Wang-Tsiatis bounds, \dQuote{OF} for
#'   O'Brien-Fleming bounds and \dQuote{Pocock} for Pocock bounds).  For
#'   one-sided and symmetric two-sided testing is used to completely specify
#'   spending (\code{test.type=1, 2}), \code{sfu}.  The default value is
#'   \code{sfHSD} which is a Hwang-Shih-DeCani spending function.  See details,
#'   \code{vignette("SpendingFunctionOverview")}, manual and examples.
#' @param sfupar Real value, default is \eqn{-4} which is an
#'   O'Brien-Fleming-like conservative bound when used with the default
#'   Hwang-Shih-DeCani spending function. This is a real-vector for many spending
#'   functions.  The parameter \code{sfupar} specifies any parameters needed for
#'   the spending function specified by \code{sfu}; this will be ignored for
#'   spending functions (\code{sfLDOF}, \code{sfLDPocock}) or bound types
#'   (\dQuote{OF}, \dQuote{Pocock}) that do not require parameters.
#'   Note that \code{sfupar} can be specified as a positive scalar for
#'   \code{sfLDOF} for a generalized O'Brien-Fleming spending function.
#' @param sfl Specifies the spending function for lower boundary crossing
#'   probabilities when asymmetric, two-sided testing is performed
#'   (\code{test.type = 3}, \code{4}, \code{5}, or \code{6}).  Unlike the upper
#'   bound, only spending functions are used to specify the lower bound.  The
#'   default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending
#'   function.  The parameter \code{sfl} is ignored for one-sided testing
#'   (\code{test.type=1}) or symmetric 2-sided testing (\code{test.type=2}).  See
#'   details, spending functions, manual and examples.
#' @param sflpar Real value, default is \eqn{-2}, which, with the default
#'   Hwang-Shih-DeCani spending function, specifies a less conservative spending
#'   rate than the default for the upper bound.
#' @param r Integer value (>= 1 and <= 80) controlling the number of numerical
#'   integration grid points. Default is 18, as recommended by Jennison and
#'   Turnbull (2000). Grid points are spread out in the tails for accurate
#'   probability calculations. Larger values provide more grid points and greater
#'   accuracy but slow down computation. Jennison and Turnbull (p. 350) note an
#'   accuracy of \eqn{10^{-6}} with \code{r = 16}. This parameter is normally
#'   not changed by users.
#' @param usTime Default is NULL in which case upper bound spending time is
#'   determined by \code{timing}. Otherwise, this should be a vector of length
#'   \code{k} with the spending time at each analysis (see Details in help for \code{gsDesign}).
#' @param lsTime Default is NULL in which case lower bound spending time is
#'   determined by \code{timing}. Otherwise, this should be a vector of length
#'   \code{k} with the spending time at each analysis (see Details in help for \code{gsDesign}).
#' @param tIA Timing of an interim analysis; should be between 0 and
#'   \code{y$T}.
#' @param target The targeted proportion of events at an interim analysis. This
#'   is used for root-finding will be 0 for normal use.
#' @param simple See output specification for \code{nEventsIA()}.
#' @param footnote Footnote for xtable output; may be useful for describing
#'   some of the design parameters.
#' @param fnwid A text string controlling the width of footnote text at the
#'   bottom of the xtable output.
#' @param timename Character string with plural of time units (e.g., "months")
#' @param caption Passed through to generic \code{xtable()}.
#' @param label Passed through to generic \code{xtable()}.
#' @param align Passed through to generic \code{xtable()}.
#' @param display Passed through to generic \code{xtable()}.
#' @param auto Passed through to generic \code{xtable()}.
#' @param ... Other arguments that may be passed to generic functions
#'   underlying the methods here.
#'
#' @return \code{nSurv()} returns an object of type \code{nSurv} with the
#'   following components:
#'   \item{alpha}{As input.}
#'   \item{sided}{As input.}
#'   \item{beta}{Type II error; if missing, this is computed.}
#'   \item{power}{Power corresponding to input \code{beta} or computed if
#'   output \code{beta} is computed.}
#'   \item{lambdaC}{As input.}
#'   \item{etaC}{As input.}
#'   \item{etaE}{As input.}
#'   \item{gamma}{As input unless none of the following are \code{NULL}:
#'   \code{T}, \code{minfup}, \code{beta}; otherwise, this is a constant times
#'   the input value required to power the trial given the other input
#'   variables.}
#'   \item{ratio}{As input.}
#'   \item{R}{As input unless \code{T} was \code{NULL} on input.}
#'   \item{S}{As input.}
#'   \item{T}{As input.}
#'   \item{minfup}{As input.}
#'   \item{hr}{As input.}
#'   \item{hr0}{As input.}
#'   \item{n}{Total expected sample size corresponding to output accrual rates
#'   and durations.}
#'   \item{d}{Total expected number of events under the alternate
#'   hypothesis.}
#'   \item{tol}{As input, except when not used in computations in
#'   which case this is returned as \code{NULL}. This and the remaining output
#'   below are not printed by the \code{print()} extension for the \code{nSurv}
#'   class.}
#'   \item{eDC}{A vector of expected number of events by stratum in the
#'   control group under the alternate hypothesis.}
#'   \item{eDE}{A vector of expected number of events by stratum in the
#'   experimental group under the alternate hypothesis.}
#'   \item{eDC0}{A vector of expected number of events by stratum in the
#'   control group under the null hypothesis.}
#'   \item{eDE0}{A vector of expected number of events by stratum in the
#'   experimental group under the null hypothesis.}
#'   \item{eNC}{A vector of the expected accrual in each stratum in the
#'   control group.}
#'   \item{eNE}{A vector of the expected accrual in each stratum in the
#'   experimental group.}
#'   \item{variable}{A text string equal to "Accrual rate" if a design was
#'   derived by varying the accrual rate, "Accrual duration" if a design was
#'   derived by varying the accrual duration, "Follow-up duration" if a design
#'   was derived by varying follow-up duration, or "Power" if accrual rates and
#'   duration as well as follow-up duration was specified and
#'   \code{beta=NULL} was input.}
#'
#'   \code{gsSurv()} returns much of the above plus variables in the class
#'   \code{gsDesign}; see \code{\link{gsDesign}}
#'   for general documentation on what is returned in \code{gs}.  The value of
#'   \code{gs$n.I} represents the number of endpoints required at each analysis
#'   to adequately power the trial. Other items returned by \code{gsSurv()} are:
#'   \item{lambdaC}{As input.}
#'   \item{etaC}{As input.}
#'   \item{etaE}{As input.}
#'   \item{gamma}{As input unless none of the following are \code{NULL}:
#'   \code{T}, \code{minfup}, \code{beta}; otherwise, this is a constant times
#'   the input value required to power the trial given the other input
#'   variables.}
#'   \item{ratio}{As input.}
#'   \item{R}{As input unless \code{T} was \code{NULL} on input.}
#'   \item{S}{As input.}
#'   \item{T}{As input.}
#'   \item{minfup}{As input.}
#'   \item{hr}{As input.}
#'   \item{hr0}{As input.}
#'   \item{eNC}{Total expected sample size corresponding to output accrual rates
#'   and durations.}
#'   \item{eNE}{Total expected sample size corresponding to output accrual rates
#'   and durations.}
#'   \item{eDC}{Total expected number of events under the alternate hypothesis.}
#'   \item{eDE}{Total expected number of events under the alternate hypothesis.}
#'   \item{tol}{As input, except when not used in computations in which case
#'   this is returned as \code{NULL}. This and the remaining output below are
#'   not printed by the \code{print()} extension for the \code{nSurv} class.}
#'   \item{eDC}{A vector of expected number of events by stratum in the
#'   control group under the alternate hypothesis.}
#'   \item{eDE}{A vector of expected number of events by stratum in the
#'   experimental group under the alternate hypothesis.}
#'   \item{eNC}{A vector of the expected accrual in each stratum in the
#'   control group.}
#'   \item{eNE}{A vector of the expected accrual in each stratum in the
#'   experimental group.}
#'   \item{variable}{A text string equal to "Accrual rate" if a design was
#'   derived by varying the accrual rate, "Accrual duration" if a design was
#'   derived by varying the accrual duration, "Follow-up duration" if a design
#'   was derived by varying follow-up duration, or "Power" if accrual rates and
#'   duration as well as follow-up duration was specified and \code{beta=NULL}
#'   was input.}
#'
#'   \code{nEventsIA()} returns the expected proportion of the final planned
#'   events observed at the input analysis time minus \code{target} when
#'   \code{simple=TRUE}. When \code{simple=FALSE}, \code{nEventsIA} returns a
#'   list with following components:
#'   \item{T}{The input value \code{tIA}.}
#'   \item{eDC}{The expected number of events in the control group at time the
#'   output time \code{T}.}
#'   \item{eDE}{The expected number of events in the experimental group at the
#'   output time \code{T}.}
#'   \item{eNC}{The expected enrollment in the control group at the
#'   output time \code{T}.}
#'   \item{eNE}{The expected enrollment in the experimental group at the
#'   output time \code{T}.}
#'
#'   \code{tEventsIA()} returns the same structure as \code{nEventsIA(..., simple=TRUE)} when
#'
#' @export
#'
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#'
#' @seealso \code{\link{gsBoundSummary}}, \code{\link{xprint}},
#'   \code{vignette("gsDesignPackageOverview")}, \link{plot.gsDesign},
#'   \code{\link{gsDesign}}, \code{\link{gsHR}}, \code{\link{nSurvival}}
#'
#' @references
#' Kim KM and Tsiatis AA (1990), Study duration for clinical trials
#' with survival response and early stopping rule. \emph{Biometrics}, 46, 81-92
#'
#' Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and Power for
#' Analyses of Survival with Allowance for Nonuniform Patient Entry, Losses to
#' Follow-Up, Noncompliance, and Stratification. \emph{Biometrics}, 42,
#' 507-519.
#'
#' Schoenfeld D (1981), The Asymptotic Properties of Nonparametric Tests for
#' Comparing Survival Distributions. \emph{Biometrika}, 68, 316-319.
#'
#' @keywords design
#'
#' @examples
#' # Vary accrual rate to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 1, T = 36, minfup = 12)
#'
#' # Vary accrual duration to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, minfup = 12)
#'
#' # Vary follow-up duration to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, R = 25)
#'
#' # Piecewise constant enrollment rates (vary accrual duration)
#' nSurv(
#'   lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = c(1, 3, 6),
#'   R = c(3, 6, 9), T = NULL, minfup = 12
#' )
#'
#' # Stratified population (vary accrual duration)
#' nSurv(
#'   lambdaC = matrix(log(2) / c(6, 12), ncol = 2), hr = .5, eta = log(2) / 40,
#'   gamma = matrix(c(2, 4), ncol = 2), minfup = 12
#' )
#'
#' # Piecewise exponential failure rates (vary accrual duration)
#' nSurv(lambdaC = log(2) / c(6, 12), hr = .5, eta = log(2) / 40, S = 3, gamma = 6, minfup = 12)
#'
#' # Combine it all: 2 strata, 2 failure rate periods
#' nSurv(
#'   lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
#'   eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
#'   gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12
#' )
#'
#' # Example where only 1 month of follow-up is desired.
#' # Set failure rate to 0 after 1 month using lambdaC and S.
#' nSurv(lambdaC = c(.4, 0), hr = 2 / 3, S = 1, minfup = 1)
#'
#' # Group sequential design (vary accrual rate to obtain power)
#' x <- gsSurv(
#'   k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
#'   eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
#' )
#' x
#' print(xtable::xtable(x,
#'   footnote = "This is a footnote; note that it can be wide.",
#'   caption = "Caption example."
#' ))
#' # Find expected number of events at time 12 in the above trial
#' nEventsIA(x = x, tIA = 10)
#'
#' # Find time at which 1/4 of events are expected
#' tEventsIA(x = x, timing = .25)
# nSurv function [sinew] ----
nSurv <- function(
  lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
  gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
  alpha = 0.025, beta = 0.10, sided = 1, tol = .Machine$double.eps^0.25
) {
  if (is.null(etaE)) etaE <- eta
  # Set up rates as matrices with row and column names.
  # Default is 1 stratum if lambdaC not input as matrix.
  if (is.vector(lambdaC)) lambdaC <- matrix(lambdaC)
  ldim <- dim(lambdaC)
  nstrata <- ldim[2]
  nlambda <- ldim[1]
  rownames(lambdaC) <- paste("Period", 1:nlambda)
  colnames(lambdaC) <- paste("Stratum", 1:nstrata)
  etaC <- matrix(eta, nrow = nlambda, ncol = nstrata)
  etaE <- matrix(etaE, nrow = nlambda, ncol = nstrata)
  if (!is.matrix(gamma)) gamma <- matrix(gamma)
  gdim <- dim(gamma)
  eCdim <- dim(etaC)
  eEdim <- dim(etaE)

  if (is.null(minfup) || is.null(T)) {
    xx <- KT(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta, tol = tol
    )
  } else if (is.null(beta)) {
    xx <- KTZ(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta, simple = F
    )
  } else {
    xx <- LFPWE(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta
    )
  }

  nameR <- nameperiod(cumsum(xx$R))
  stratnames <- paste("Stratum", 1:ncol(xx$lambdaC))
  if (is.null(xx$S)) {
    nameS <- "0-Inf"
  } else {
    nameS <- nameperiod(cumsum(c(xx$S, Inf)))
  }
  rownames(xx$lambdaC) <- nameS
  colnames(xx$lambdaC) <- stratnames
  rownames(xx$etaC) <- nameS
  colnames(xx$etaC) <- stratnames
  rownames(xx$etaE) <- nameS
  colnames(xx$etaE) <- stratnames
  rownames(xx$gamma) <- nameR
  colnames(xx$gamma) <- stratnames
  return(xx)
}

# print.nSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# print.nSurv function [sinew] ----
print.nSurv <- function(x, digits = 4, ...) {
  if (!inherits(x, "nSurv")) {
    stop("Primary argument must have class nSurv")
  }
  x$digits <- digits
  x$sided <- 1
  cat("Fixed design, two-arm trial with time-to-event\n")
  cat("outcome (Lachin and Foulkes, 1986).\n")
  cat("Solving for: ", x$variable, "\n")
  cat("Hazard ratio                  H1/H0=",
    round(x$hr, digits),
    "/", round(x$hr0, digits), "\n",
    sep = ""
  )
  cat("Study duration:                   T=",
    round(x$T, digits), "\n",
    sep = ""
  )
  cat("Accrual duration:                   ",
    round(x$T - x$minfup, digits), "\n",
    sep = ""
  )
  cat("Min. end-of-study follow-up: minfup=",
    round(x$minfup, digits), "\n",
    sep = ""
  )
  cat("Expected events (total, H1):        ",
    round(x$d, digits), "\n",
    sep = ""
  )
  cat("Expected sample size (total):       ",
    round(x$n, digits), "\n",
    sep = ""
  )
  enrollper <- periods(x$S, x$T, x$minfup, x$digits)
  cat("Accrual rates:\n")
  print(round(x$gamma, digits))
  cat("Control event rates (H1):\n")
  print(round(x$lambda, digits))
  if (max(abs(x$etaC - x$etaE)) == 0) {
    cat("Censoring rates:\n")
    print(round(x$etaC, digits))
  } else {
    cat("Control censoring rates:\n")
    print(round(x$etaC, digits))
    cat("Experimental censoring rates:\n")
    print(round(x$etaE, digits))
  }
  cat("Power:                 100*(1-beta)=",
    round((1 - x$beta) * 100, digits), "%\n",
    sep = ""
  )
  cat("Type I error (", x$sided,
    "-sided):   100*alpha=",
    100 * x$alpha, "%\n",
    sep = ""
  )
  if (min(x$ratio == 1) == 1) {
    cat("Equal randomization:          ratio=1\n")
  } else {
    cat(
      "Randomization (Exp/Control):  ratio=",
      x$ratio, "\n"
    )
  }
}
