#' Compute power for a group sequential survival design
#'
#' \code{gsSurvPower()} computes power for a group sequential survival design
#' with specified enrollment, dropout, treatment effect, and analysis timing.
#' Unlike \code{gsSurv()} and \code{gsSurvCalendar()} which solve for sample
#' size to achieve target power, \code{gsSurvPower()} takes fixed design
#' assumptions and computes the resulting power. It is meant to compute for
#' a single set of assumptions at a time; different scenarios are evaluated
#' with separate calls.
#'
#' @details
#' \strong{Accepting a gsSurv object:}
#' An optional \code{gsSurv}-class object \code{x} provides defaults for all
#' parameters. This includes output from \code{gsSurv()} and
#' \code{gsSurvCalendar()}. User-specified parameters override these defaults,
#' enabling "what-if" analyses: e.g., \code{gsSurvPower(x = design, hr = 0.8)}
#' evaluates power under HR = 0.8 using all other parameters from the design.
#' When \code{x} is not provided, all design parameters must be specified
#' directly.
#'
#' \strong{Hazard ratio roles:}
#' Two distinct hazard ratios serve different purposes. \code{hr} is the
#' assumed treatment effect under which power is evaluated.
#' \code{hr1} is the design alternative used to calibrate futility bounds
#' (for \code{test.type} 3, 4, 7, 8). It is not used for \code{test.type}
#' 5 or 6 (which use H0 spending for the lower bound) or for harm bounds.
#' When \code{x} is provided, \code{hr1} defaults
#' to \code{x$hr}, so futility bounds remain calibrated to the original design
#' even when power is evaluated under a different \code{hr}.
#'
#' \strong{Analysis timing:}
#' Analysis times are determined by per-analysis criteria. Each timing parameter
#' can be a scalar (recycled to all \code{k} analyses), a vector of length
#' \code{k}, or \code{NA} at position \code{i} to indicate the criterion does
#' not apply to analysis \code{i}.
#'
#' The choice between \code{plannedCalendarTime} and \code{targetEvents} has an
#' important consequence for sensitivity analyses:
#' \itemize{
#'   \item \code{plannedCalendarTime} fixes calendar times; expected events are
#'     recomputed under the assumed HR. A worse HR produces more events at the
#'     same calendar time (the experimental arm fails faster). This gives an
#'     "unconditional" power.
#'   \item \code{targetEvents} fixes event counts; calendar times adjust. Since
#'     events are held constant, information fractions do not change with HR, and
#'     results match the \code{gsDesign} power plot
#'     (\code{plot(x, plottype = 2)}) to numerical precision.
#' }
#'
#' \strong{How criteria combine within a single analysis:}
#' For analysis \code{i}, the analysis time \code{T[i]} is determined as:
#' \enumerate{
#'   \item Compute floor times from applicable criteria:
#'     \code{plannedCalendarTime[i]},
#'     \code{T[i-1] + minTimeFromPreviousAnalysis[i]}, and
#'     time when \code{minN[i]} enrolled + \code{minFollowUp[i]}.
#'   \item \code{floor_time = max(all applicable floor times)}.
#'   \item If \code{targetEvents[i]} is specified: find \code{t_events} when
#'     expected events reach target. If \code{t_events <= floor_time}, analysis
#'     at \code{floor_time}. If \code{t_events > floor_time} and
#'     \code{maxExtension[i]} is set, analysis at
#'     \code{min(t_events, floor_time + maxExtension[i])}. Otherwise, analysis
#'     at \code{t_events}.
#'   \item If no \code{targetEvents}: analysis at \code{floor_time}.
#'   \item \code{maxExtension} is a hard cap: the analysis time is never pushed
#'     beyond \code{plannedCalendarTime[i] + maxExtension[i]} (or
#'     \code{T[i-1] + maxExtension[i]} when no calendar time is specified),
#'     even if other criteria such as \code{minTimeFromPreviousAnalysis}
#'     or \code{minN + minFollowUp} would require a later time.
#' }
#'
#' \strong{Normalization and consistency:}
#' When \code{x} is provided, \code{x$n.fix} is used for the
#' \code{gsDesign::gsDesign()} call to ensure the internal drift parameter
#' \eqn{\theta} and bounds match the original design exactly.
#' The assumed HR's drift is obtained by scaling:
#' \eqn{\theta_{\mathrm{assumed}} = \theta_{\mathrm{design}} \times
#' |\log(\mathrm{hr}/\mathrm{hr}_0)| / |\log(\mathrm{hr}_1/\mathrm{hr}_0)|}.
#' Power is computed via \code{gsDesign::gsProbability()} with actual expected
#' events as \code{n.I}. At the design HR, this reproduces the design power
#' exactly.
#'
#' \strong{Stratified targetEvents:}
#' \code{targetEvents} accepts a scalar (recycled), a vector of length \code{k}
#' (overall targets per analysis), or a matrix with \code{k} rows and
#' \code{nstrata} columns (per-stratum targets). A vector of length \code{k}
#' is always interpreted as overall targets; use a matrix for per-stratum
#' specification.
#'
#' \strong{Bound recalculation when parameters change:}
#' When \code{x} is provided, the handling of bounds depends on which
#' parameters change relative to the original design:
#' \itemize{
#'   \item \strong{No bound parameters changed} (same \code{alpha}, \code{sfu},
#'     \code{sfupar}) and timing matches: both bounds are reused from \code{x}
#'     exactly.
#'   \item \strong{Upper-bound parameters changed} (\code{alpha}, \code{sfu},
#'     or \code{sfupar}) but timing matches: new efficacy bounds are computed
#'     via \code{gsDesign(test.type = 1)} at the new alpha, while the
#'     original futility bounds from \code{x} are preserved. Any futility
#'     bound that exceeds the new efficacy bound is clipped. This follows
#'     the same convention as \code{gsBoundSummary()}. Lower-bound spending
#'     settings from \code{x} are intentionally kept in this branch, which
#'     avoids
#'     complications with \code{astar} validation for binding types.
#'   \item \strong{Timing changed} (different target events or calendar
#'     times): both bounds are recomputed from scratch using the full
#'     \code{test.type} and all spending parameters.
#' }
#'
#' @param x Optional \code{gsSurv} or \code{gsSurvCalendar} object providing
#'   defaults for all parameters. When provided, any user-specified parameter
#'   overrides the corresponding value from \code{x}.
#' @param k Number of analyses planned, including interim and final.
#' @param test.type \code{1} = one-sided, \code{2} = two-sided symmetric,
#'   \code{3} = two-sided, asymmetric, beta-spending with binding lower bound,
#'   \code{4} = two-sided, asymmetric, beta-spending with non-binding lower bound,
#'   \code{5} = two-sided, asymmetric, lower bound spending under the null
#'   hypothesis with binding lower bound,
#'   \code{6} = two-sided, asymmetric, lower bound spending under the null
#'   hypothesis with non-binding lower bound,
#'   \code{7} = two-sided, asymmetric, with binding futility and binding harm
#'   bounds,
#'   \code{8} = two-sided, asymmetric, with non-binding futility and
#'   non-binding harm bounds.
#' @param alpha Type I error rate. Default is 0.025 since 1-sided testing
#'   is default. Internally divided by \code{sided} before passing to
#'   \code{gsDesign()}, matching the convention used by \code{gsSurv()} and
#'   \code{gsSurvCalendar()}.
#' @param sided 1 for 1-sided, 2 for 2-sided testing. Used to convert
#'   \code{alpha} to one-sided via \code{alpha / sided} for internal
#'   calculations, matching the convention of \code{gsSurv()} and
#'   \code{nSurv()}.
#' @param astar Lower bound total crossing probability for \code{test.type}
#'   5 or 6. Default 0.
#' @param sfu Upper bound spending function (default \code{sfHSD}).
#' @param sfupar Parameter for \code{sfu} (default -4).
#' @param sfl Lower bound spending function (default \code{sfHSD}).
#' @param sflpar Parameter for \code{sfl} (default -2).
#' @param sfharm Spending function for the harm bound, used with
#'   \code{test.type = 7} or \code{test.type = 8}. Default \code{sfHSD}.
#' @param sfharmparam Real value, default \eqn{-2}. Parameter for the harm
#'   bound spending function \code{sfharm}.
#' @param testUpper Indicator of which analyses include an efficacy test.
#'   \code{TRUE} (default) for all analyses. A logical vector of length
#'   \code{k} may be specified.
#' @param testLower Indicator of which analyses include a futility test.
#'   \code{TRUE} (default) for all analyses. A logical vector of length
#'   \code{k} may be specified.
#' @param testHarm Indicator of which analyses include a harm bound.
#'   \code{TRUE} (default) for all analyses. A logical vector of length
#'   \code{k} may be specified. Only used for \code{test.type} 7 or 8.
#' @param r Integer grid parameter for numerical integration (default 18).
#' @param usTime Upper spending time override; vector of length \code{k}
#'   or \code{NULL} (default) to use information fractions. Ignored when
#'   \code{spending = "calendar"}, because realized analysis times determine
#'   the spending fractions.
#' @param lsTime Lower spending time override; vector of length \code{k}
#'   or \code{NULL} (default) to use information fractions. Ignored when
#'   \code{spending = "calendar"}.
#' @param lambdaC Scalar, vector, or matrix of control event hazard rates.
#'   Rows = time periods, columns = strata.
#' @param hr Assumed hazard ratio (experimental/control) for power computation.
#'   This is the "what-if" treatment effect.
#' @param hr0 Null hazard ratio. Set \code{hr0 > 1} for non-inferiority.
#' @param hr1 Design alternative hazard ratio used to calibrate futility bounds
#'   (\code{test.type} 3, 4, 7, 8 only; not used for 5, 6 or harm bounds).
#'   Defaults to \code{x$hr} when \code{x} is provided, otherwise \code{hr}.
#' @param eta Scalar, vector, or matrix of control dropout hazard rates.
#' @param etaE Experimental dropout hazard rates; if \code{NULL}, set to
#'   \code{eta}.
#' @param gamma Scalar, vector, or matrix of enrollment rates by period (rows)
#'   and strata (columns).
#' @param R Scalar or vector of enrollment period durations.
#' @param S Scalar or vector of piecewise failure period durations; \code{NULL}
#'   for exponential failure.
#' @param ratio Randomization ratio (experimental/control). Default 1.
#' @param minfup Minimum follow-up time.
#' @param method Sample-size variance formulation. One of
#'   \code{"LachinFoulkes"} (default), \code{"Schoenfeld"},
#'   \code{"Freedman"}, or \code{"BernsteinLagakos"}. Affects \code{n.fix}
#'   computation when \code{x} is not provided.
#' @param spending One of \code{"information"} (default) or \code{"calendar"}.
#'   Controls whether alpha/beta spending tracks information fractions or
#'   calendar time fractions (\code{T / max(T)}). With calendar spending,
#'   \code{usTime} and \code{lsTime} are derived from the realized analysis
#'   times and any user-supplied overrides are ignored.
#' @param plannedCalendarTime Calendar times for analyses (time 0 = start of
#'   randomization). Scalar (recycled) or vector of length \code{k}. Use
#'   \code{NA} for analyses not determined by calendar time.
#' @param targetEvents Target number of events at each analysis. Scalar
#'   (recycled), vector of length \code{k} (overall targets), or matrix
#'   with \code{k} rows and \code{nstrata} columns (per-stratum targets).
#'   Use \code{NA} for analyses not determined by events. When a matrix is
#'   supplied, row sums give the total event target used to solve each
#'   analysis time.
#' @param maxExtension Maximum time extension beyond the floor time to wait
#'   for \code{targetEvents}. Scalar or vector of length \code{k}.
#' @param minTimeFromPreviousAnalysis Minimum elapsed time since the previous
#'   analysis. Scalar or vector of length \code{k}. Ignored for the first
#'   analysis.
#' @param minN Minimum total sample size enrolled before analysis can proceed.
#'   Scalar or vector of length \code{k}.
#' @param minFollowUp Minimum follow-up time after \code{minN} is reached.
#'   Scalar or vector of length \code{k}. Must be >= 0.
#' @param informationRates Numeric vector of length \code{k} specifying
#'   planned information fractions. When provided, spending fractions are
#'   \code{pmin(informationRates, actual_timing)} at each analysis, where
#'   \code{actual_timing} is expected events divided by maximum expected
#'   events. This prevents over-spending when events are ahead of schedule
#'   and under-spends when behind. Default \code{NULL} uses actual
#'   information fractions (or calendar fractions when
#'   \code{spending = "calendar"}).
#' @param fullSpendingAtFinal Logical. When \code{TRUE}, the spending
#'   fraction at the final analysis is forced to 1 regardless of the actual
#'   (or capped) information fraction. This ensures full alpha spending
#'   even when expected events fall short of the design target. Default
#'   \code{FALSE}.
#' @param tol Tolerance for \code{\link[stats]{uniroot}} when solving for
#'   analysis times.
#'
#' @return An object of class \code{c("gsSurv", "gsDesign")} containing:
#' \item{k}{Number of analyses.}
#' \item{n.I}{Total expected events at each analysis.}
#' \item{timing}{Information fractions at each analysis.}
#' \item{T}{Calendar times of analyses.}
#' \item{eDC, eDE}{Expected events by stratum (control, experimental).}
#' \item{eNC, eNE}{Expected sample sizes by stratum (control, experimental).}
#' \item{upper, lower}{Bounds and crossing probabilities.}
#' \item{harm}{Harm-bound information when \code{test.type} is 7 or 8.}
#' \item{en, theta}{Expected sample size summary and drift values returned by
#'   \code{gsDesign::gsProbability()}.}
#' \item{hr, hr0, hr1}{Assumed, null, and design hazard ratios.}
#' \item{power}{Overall power (sum of upper-bound crossing probabilities
#'   under the assumed HR).}
#' \item{beta}{Type II error (\code{1 - power}).}
#' \item{variable}{Always \code{"Power"}.}
#' \item{test.type, alpha, sided, method, spending, call}{Design settings used
#'   for the power calculation.}
#' \item{testUpper, testLower, testHarm}{Logical indicators of which analyses
#'   include each bound type, when relevant.}
#' \item{lambdaC, etaC, etaE, gamma, R, S, ratio, minfup}{Rate and timing inputs
#'   used in the calculation.}
#'
#' @examples
#' # Create a design, then evaluate power at the design HR
#' design <- gsSurv(
#'   k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
#'   lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
#'   gamma = 10, R = 16, minfup = 12, T = 28
#' )
#' pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
#' pwr$power  # should be 0.9
#'
#' # Power under a worse HR
#' gsSurvPower(x = design, hr = 0.8, plannedCalendarTime = design$T)$power
#'
#' # Event-driven timing (matches gsDesign power plot)
#' design_events <- design$n.I
#' gsSurvPower(x = design, hr = 0.8, targetEvents = design_events)$power
#'
#' # Without a reference design
#' gsSurvPower(
#'   k = 2, test.type = 4, alpha = 0.025, sided = 1,
#'   lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
#'   gamma = 8, R = 18, ratio = 1,
#'   plannedCalendarTime = c(24, 36)
#' )$power
#'
#' @seealso \code{vignette("gssurvpower", package = "gsDesign")} for
#'   worked examples including calendar spending, stratified event targets,
#'   and biomarker subgroup analyses.
#'
#'   \code{\link{gsSurv}}, \code{\link{gsSurvCalendar}},
#'   \code{\link[gsDesign]{gsDesign}}, \code{\link[gsDesign]{gsProbability}}
#'
#' @export
gsSurvPower <- function(
    x = NULL,
    k = NULL,
    test.type = NULL, alpha = NULL, sided = NULL, astar = NULL,
    sfu = NULL, sfupar = NULL, sfl = NULL, sflpar = NULL,
    sfharm = NULL, sfharmparam = NULL,
    r = NULL, usTime = NULL, lsTime = NULL,
    testUpper = NULL, testLower = NULL, testHarm = NULL,
    lambdaC = NULL, hr = NULL, hr0 = NULL, hr1 = NULL,
    eta = NULL, etaE = NULL,
    gamma = NULL, R = NULL, S = NULL,
    ratio = NULL, minfup = NULL,
    method = NULL,
    spending = c("information", "calendar"),
    plannedCalendarTime = NULL,
    targetEvents = NULL,
    maxExtension = NULL,
    minTimeFromPreviousAnalysis = NULL,
    minN = NULL,
    minFollowUp = NULL,
    informationRates = NULL,
    fullSpendingAtFinal = FALSE,
    tol = .Machine$double.eps^0.25) {
  spending <- match.arg(spending)

  # Track whether user explicitly provided alpha; used below to decide
  # whether the gsSurv alpha/sided convention applies.
  alpha_provided_by_user <- !is.null(alpha)

  recycle_to_k <- function(value, name, analysis_count) {
    if (is.null(value)) return(rep(NA_real_, analysis_count))
    if (length(value) == 1) return(rep(value, analysis_count))
    if (length(value) == analysis_count) return(value)
    stop(paste(name, "must have length 1 or", analysis_count))
  }

  resolve_input_defaults <- function() {
    if (!is.null(x)) {
      if (!inherits(x, "gsSurv")) stop("x must be a gsSurv object")

      resolved_test_type <- if (is.null(test.type)) x$test.type else test.type

      list(
        k = if (is.null(k)) x$k else k,
        test.type = resolved_test_type,
        sided = if (is.null(sided)) {
          if (!is.null(x$sided)) x$sided else 1L
        } else {
          sided
        },
        alpha = if (is.null(alpha)) x$alpha else alpha,
        astar = if (is.null(astar)) x$astar else astar,
        sfu = if (is.null(sfu)) x$upper$sf else sfu,
        sfupar = if (is.null(sfupar)) x$upper$param else sfupar,
        sfl = if (is.null(sfl)) x$lower$sf else sfl,
        sflpar = if (is.null(sflpar)) x$lower$param else sflpar,
        sfharm = if (is.null(sfharm)) {
          if (!is.null(x$harm) && is.function(x$harm$sf)) x$harm$sf else gsDesign::sfHSD
        } else {
          sfharm
        },
        sfharmparam = if (is.null(sfharmparam)) {
          if (!is.null(x$harm) && !is.null(x$harm$param)) x$harm$param else -2
        } else {
          sfharmparam
        },
        testUpper = if (is.null(testUpper)) {
          if (!is.null(x$testUpper)) x$testUpper else TRUE
        } else {
          testUpper
        },
        testLower = if (is.null(testLower)) {
          if (!is.null(x$testLower)) x$testLower else TRUE
        } else {
          testLower
        },
        testHarm = if (is.null(testHarm)) {
          if (!is.null(x$testHarm)) x$testHarm else TRUE
        } else {
          testHarm
        },
        r = if (is.null(r)) x$r else r,
        lambdaC = if (is.null(lambdaC)) x$lambdaC else lambdaC,
        hr = if (is.null(hr)) x$hr else hr,
        hr0 = if (is.null(hr0)) x$hr0 else hr0,
        hr1 = if (is.null(hr1)) x$hr else hr1,
        eta = if (is.null(eta)) x$etaC else eta,
        etaE = if (is.null(etaE)) x$etaE else etaE,
        gamma = if (is.null(gamma)) x$gamma else gamma,
        R = if (is.null(R)) x$R else R,
        S = if (is.null(S)) x$S else S,
        ratio = if (is.null(ratio)) x$ratio else ratio,
        minfup = if (is.null(minfup)) x$minfup else minfup,
        method = if (is.null(method)) {
          if (!is.null(x$method)) x$method else "LachinFoulkes"
        } else {
          method
        },
        beta_design = x$beta
      )
    } else {
      if (is.null(k)) stop("k must be specified when x is not provided")

      list(
        k = k,
        test.type = if (is.null(test.type)) 4L else test.type,
        sided = if (is.null(sided)) 1L else sided,
        alpha = if (is.null(alpha)) 0.025 else alpha,
        astar = if (is.null(astar)) 0 else astar,
        sfu = if (is.null(sfu)) gsDesign::sfHSD else sfu,
        sfupar = if (is.null(sfupar)) -4 else sfupar,
        sfl = if (is.null(sfl)) gsDesign::sfHSD else sfl,
        sflpar = if (is.null(sflpar)) -2 else sflpar,
        sfharm = if (is.null(sfharm)) gsDesign::sfHSD else sfharm,
        sfharmparam = if (is.null(sfharmparam)) -2 else sfharmparam,
        testUpper = if (is.null(testUpper)) TRUE else testUpper,
        testLower = if (is.null(testLower)) TRUE else testLower,
        testHarm = if (is.null(testHarm)) TRUE else testHarm,
        r = if (is.null(r)) 18 else r,
        lambdaC = if (is.null(lambdaC)) log(2) / 6 else lambdaC,
        hr = if (is.null(hr)) 0.6 else hr,
        hr0 = if (is.null(hr0)) 1 else hr0,
        hr1 = if (is.null(hr1)) {
          if (is.null(hr)) 0.6 else hr
        } else {
          hr1
        },
        eta = if (is.null(eta)) 0 else eta,
        etaE = etaE,
        gamma = gamma,
        R = if (is.null(R)) 12 else R,
        S = S,
        ratio = if (is.null(ratio)) 1 else ratio,
        minfup = if (is.null(minfup)) 18 else minfup,
        method = if (is.null(method)) "LachinFoulkes" else method,
        beta_design = 0.1
      )
    }
  }

  normalize_rate_inputs <- function(
      control_hazard,
      control_dropout,
      experimental_dropout,
      enrollment_rate,
      allocation_ratio) {
    if (is.null(experimental_dropout)) experimental_dropout <- control_dropout
    if (!is.matrix(control_hazard)) {
      control_hazard <- matrix(
        if (is.vector(control_hazard)) control_hazard else as.vector(control_hazard)
      )
    }
    n_strata <- ncol(control_hazard)
    n_hazard_periods <- nrow(control_hazard)

    control_dropout <- if (is.matrix(control_dropout)) {
      control_dropout
    } else {
      matrix(control_dropout, nrow = n_hazard_periods, ncol = n_strata)
    }
    experimental_dropout <- if (is.matrix(experimental_dropout)) {
      experimental_dropout
    } else {
      matrix(experimental_dropout, nrow = n_hazard_periods, ncol = n_strata)
    }
    if (!is.matrix(enrollment_rate)) enrollment_rate <- matrix(enrollment_rate)

    experimental_fraction <- allocation_ratio / (1 + allocation_ratio)
    control_fraction <- 1 - experimental_fraction

    list(
      lambdaC = control_hazard,
      etaC = control_dropout,
      etaE = experimental_dropout,
      gamma = enrollment_rate,
      Qc = control_fraction,
      Qe = experimental_fraction
    )
  }

  resolve_timing_inputs <- function(default_k) {
    planned_time_input <- plannedCalendarTime
    target_event_input <- targetEvents

    if (is.null(planned_time_input) && is.null(target_event_input)) {
      if (!is.null(x)) {
        planned_time_input <- x$T
      } else {
        stop("At least one of plannedCalendarTime or targetEvents must be specified")
      }
    }

    analysis_count <- default_k
    if (is.null(analysis_count)) {
      if (!is.null(planned_time_input)) {
        analysis_count <- length(planned_time_input)
      } else if (is.matrix(target_event_input)) {
        analysis_count <- nrow(target_event_input)
      } else if (!is.null(target_event_input)) {
        analysis_count <- length(target_event_input)
      }
    }
    if (is.null(analysis_count) || analysis_count < 1) {
      stop("Could not determine number of analyses (k)")
    }

    planned_time <- recycle_to_k(
      planned_time_input, "plannedCalendarTime", analysis_count
    )
    max_extension <- recycle_to_k(
      maxExtension, "maxExtension", analysis_count
    )
    min_time_from_previous <- recycle_to_k(
      minTimeFromPreviousAnalysis,
      "minTimeFromPreviousAnalysis",
      analysis_count
    )
    min_follow_up <- recycle_to_k(
      minFollowUp, "minFollowUp", analysis_count
    )
    min_enrolled <- recycle_to_k(minN, "minN", analysis_count)

    if (is.null(target_event_input)) {
      total_event_targets <- rep(NA_real_, analysis_count)
    } else if (is.matrix(target_event_input)) {
      if (nrow(target_event_input) != analysis_count) {
        stop("targetEvents matrix must have k rows")
      }
      # Per-stratum targets determine timing through their total at each look.
      total_event_targets <- rowSums(target_event_input)
    } else {
      total_event_targets <- recycle_to_k(
        target_event_input, "targetEvents", analysis_count
      )
    }

    list(
      k = analysis_count,
      planned_time = planned_time,
      max_extension = max_extension,
      min_time_from_previous = min_time_from_previous,
      min_follow_up = min_follow_up,
      min_enrolled = min_enrolled,
      total_event_targets = total_event_targets
    )
  }

  build_expected_counts_at_time <- function(
      control_hazard,
      control_dropout,
      experimental_dropout,
      enrollment_rate,
      control_fraction,
      experimental_fraction) {
    function(current_time) {
      control_counts <- eEvents(
        lambda = control_hazard,
        eta = control_dropout,
        gamma = enrollment_rate * control_fraction,
        R = R,
        S = S,
        T = current_time,
        minfup = 0
      )
      experimental_counts <- eEvents(
        lambda = control_hazard * hr,
        eta = experimental_dropout,
        gamma = enrollment_rate * experimental_fraction,
        R = R,
        S = S,
        T = current_time,
        minfup = 0
      )

      list(
        eDC = control_counts$d,
        eDE = experimental_counts$d,
        eNC = control_counts$n,
        eNE = experimental_counts$n,
        total_d = sum(control_counts$d + experimental_counts$d),
        total_n = sum(control_counts$n + experimental_counts$n)
      )
    }
  }

  solve_analysis_schedule <- function(timing_inputs, expected_counts_at_time) {
    planned_time <- timing_inputs$planned_time
    max_extension <- timing_inputs$max_extension
    min_time_from_previous <- timing_inputs$min_time_from_previous
    min_follow_up <- timing_inputs$min_follow_up
    min_enrolled <- timing_inputs$min_enrolled
    total_event_targets <- timing_inputs$total_event_targets
    analysis_count <- timing_inputs$k

    planned_time_max <- if (any(!is.na(planned_time))) {
      max(planned_time[!is.na(planned_time)])
    } else {
      0
    }
    search_upper_bound <- max(sum(R) * 5, planned_time_max * 2, 200)

    find_time_for_events <- function(target) {
      objective <- function(current_time) {
        expected_counts_at_time(current_time)$total_d - target
      }
      if (objective(search_upper_bound) < 0) {
        warning("Target ", round(target), " events may not be achievable")
        return(search_upper_bound)
      }
      if (objective(0.001) >= 0) return(0.001)
      uniroot(objective, c(0.001, search_upper_bound), tol = tol)$root
    }

    find_time_for_enrollment <- function(target) {
      objective <- function(current_time) {
        expected_counts_at_time(current_time)$total_n - target
      }
      if (objective(search_upper_bound) < 0) return(search_upper_bound)
      if (objective(0.001) >= 0) return(0.001)
      uniroot(objective, c(0.001, search_upper_bound), tol = tol)$root
    }

    analysis_time <- numeric(analysis_count)

    for (analysis_index in seq_len(analysis_count)) {
      floor_times <- numeric(0)
      if (!is.na(planned_time[analysis_index])) {
        floor_times <- c(floor_times, planned_time[analysis_index])
      }
      if (analysis_index > 1 && !is.na(min_time_from_previous[analysis_index])) {
        floor_times <- c(
          floor_times,
          analysis_time[analysis_index - 1] + min_time_from_previous[analysis_index]
        )
      }
      if (!is.na(min_enrolled[analysis_index])) {
        enrollment_time <- find_time_for_enrollment(min_enrolled[analysis_index])
        follow_up_time <- if (!is.na(min_follow_up[analysis_index])) {
          min_follow_up[analysis_index]
        } else {
          0
        }
        floor_times <- c(floor_times, enrollment_time + follow_up_time)
      }
      floor_time <- if (length(floor_times) > 0) max(floor_times) else 0.001

      if (!is.na(total_event_targets[analysis_index])) {
        event_time <- find_time_for_events(total_event_targets[analysis_index])
        if (event_time <= floor_time) {
          analysis_time[analysis_index] <- floor_time
        } else if (!is.na(max_extension[analysis_index])) {
          analysis_time[analysis_index] <- min(
            event_time,
            floor_time + max_extension[analysis_index]
          )
        } else {
          analysis_time[analysis_index] <- event_time
        }
      } else {
        analysis_time[analysis_index] <- floor_time
      }

      # maxExtension is a hard cap on top of the analysis floor.
      if (!is.na(max_extension[analysis_index]) &&
          !is.na(planned_time[analysis_index])) {
        analysis_time[analysis_index] <- min(
          analysis_time[analysis_index],
          planned_time[analysis_index] + max_extension[analysis_index]
        )
      } else if (!is.na(max_extension[analysis_index]) && analysis_index > 1) {
        analysis_time[analysis_index] <- min(
          analysis_time[analysis_index],
          analysis_time[analysis_index - 1] + max_extension[analysis_index]
        )
      }
    }

    control_events <- experimental_events <- NULL
    control_enrollment <- experimental_enrollment <- NULL

    for (analysis_index in seq_len(analysis_count)) {
      expected_counts <- expected_counts_at_time(analysis_time[analysis_index])
      control_events <- rbind(control_events, expected_counts$eDC)
      experimental_events <- rbind(experimental_events, expected_counts$eDE)
      control_enrollment <- rbind(control_enrollment, expected_counts$eNC)
      experimental_enrollment <- rbind(experimental_enrollment, expected_counts$eNE)
    }

    total_events <- rowSums(control_events) + rowSums(experimental_events)

    list(
      analysis_time = analysis_time,
      eDC = control_events,
      eDE = experimental_events,
      eNC = control_enrollment,
      eNE = experimental_enrollment,
      total_events = total_events,
      timing = total_events / max(total_events)
    )
  }

  compute_delta_ratio <- function(hr_num, hr_denom) {
    if (method == "Freedman") {
      delta_num <- (hr_num - 1) / (hr_num + 1 / ratio)
      delta_den <- (hr_denom - 1) / (hr_denom + 1 / ratio)
      abs(delta_num) / abs(delta_den)
    } else {
      abs(log(hr_num) - log(hr0)) / abs(log(hr_denom) - log(hr0))
    }
  }

  resolve_fixed_design_events <- function(analysis_time) {
    if (!is.null(x) && !is.null(x$n.fix)) return(x$n.fix)

    final_analysis_time <- analysis_time[k]
    min_follow_up_for_nfix <- max(0, final_analysis_time - sum(R))

    nSurv(
      lambdaC = lambdaC_input,
      hr = hr1,
      hr0 = hr0,
      eta = eta_input,
      etaE = etaE_input,
      gamma = gamma_input,
      R = R,
      S = S,
      T = final_analysis_time,
      minfup = min_follow_up_for_nfix,
      ratio = ratio,
      alpha = alpha,
      beta = beta_design,
      sided = 1,
      tol = tol,
      method = method
    )$d
  }

  resolve_spending_times <- function(analysis_time, actual_timing) {
    # When informationRates is provided, spending fractions are
    # min(planned, actual) information fractions at each analysis.
    if (!is.null(informationRates)) {
      capped <- pmin(informationRates, actual_timing)
      if (isTRUE(fullSpendingAtFinal)) {
        capped[length(capped)] <- 1
      }
      return(list(usTime = capped, lsTime = capped))
    }

    if (spending == "calendar") {
      # Calendar spending always tracks realized analysis times.
      upper_spending_time <- analysis_time / max(analysis_time)
      lower_spending_time <- upper_spending_time
    } else {
      upper_spending_time <- usTime
      lower_spending_time <- lsTime
    }

    # Force full spending at final analysis.
    if (isTRUE(fullSpendingAtFinal)) {
      if (is.null(upper_spending_time)) upper_spending_time <- actual_timing
      if (is.null(lower_spending_time)) lower_spending_time <- actual_timing
      upper_spending_time[length(upper_spending_time)] <- 1
      lower_spending_time[length(lower_spending_time)] <- 1
    }

    list(usTime = upper_spending_time, lsTime = lower_spending_time)
  }

  build_fixed_design_result <- function(total_events, n_fix) {
    z_alpha <- qnorm(1 - alpha)
    theta_design <- (z_alpha + qnorm(1 - beta_design)) / sqrt(n_fix)
    theta_assumed <- theta_design * compute_delta_ratio(hr, hr1)
    drift <- theta_assumed * sqrt(total_events[1])
    power_value <- pnorm(drift - z_alpha)

    design_object <- list(
      k = 1,
      test.type = test.type,
      alpha = alpha,
      sided = sided,
      n.I = total_events[1],
      n.fix = n_fix,
      timing = 1,
      tol = tol,
      r = r,
      upper = list(
        bound = z_alpha,
        prob = matrix(c(alpha, power_value), nrow = 1)
      ),
      lower = list(
        bound = -20,
        prob = matrix(c(1 - alpha, 1 - power_value), nrow = 1)
      ),
      theta = c(0, theta_assumed),
      en = list(en = total_events[1]),
      delta = theta_design,
      delta0 = log(hr0),
      delta1 = log(hr1),
      astar = astar,
      beta = 1 - power_value
    )
    class(design_object) <- "gsDesign"

    list(
      design_object = design_object,
      upper_bounds = design_object$upper$bound,
      lower_bounds = design_object$lower$bound,
      probabilities = list(
        upper = list(prob = design_object$upper$prob),
        lower = list(prob = design_object$lower$prob),
        en = design_object$en,
        theta = design_object$theta
      )
    )
  }

  choose_bound_strategy <- function(current_timing, spending_times) {
    timing_matches <- !is.null(x) && !is.null(x$timing) &&
      length(x$timing) == k &&
      isTRUE(all.equal(current_timing, x$timing, tolerance = 1e-4))

    # Custom spending times (e.g. calendar spending) change bound computation
    # even when information fractions match the original design.
    has_custom_spending <- !is.null(spending_times$usTime) ||
      !is.null(spending_times$lsTime)

    upper_params_match <- !is.null(x) &&
      isTRUE(all.equal(alpha, x$alpha, tolerance = 1e-7)) &&
      identical(sfu, x$upper$sf) &&
      isTRUE(all.equal(sfupar, x$upper$param, tolerance = 1e-7))

    if (timing_matches && upper_params_match && !has_custom_spending) return("reuse")
    if (timing_matches && !is.null(x) && !has_custom_spending) return("update_upper")
    "recompute_all"
  }

  compute_group_sequential_result <- function(
      n_fix,
      current_timing,
      total_events,
      spending_times) {
    bound_strategy <- choose_bound_strategy(current_timing, spending_times)

    if (bound_strategy == "reuse") {
      design_object <- x
      upper_bounds <- x$upper$bound
      lower_bounds <- x$lower$bound
    } else if (bound_strategy == "update_upper") {
      # When timing is unchanged, gsBoundSummary() updates only efficacy bounds.
      design_object <- do.call(gsDesign::gsDesign, list(
        k = k,
        test.type = 1,
        alpha = alpha,
        beta = beta_design,
        n.fix = n_fix,
        timing = current_timing,
        sfu = sfu,
        sfupar = sfupar,
        tol = tol,
        delta1 = log(hr1),
        delta0 = log(hr0),
        usTime = spending_times$usTime,
        r = r
      ))
      upper_bounds <- design_object$upper$bound
      lower_bounds <- pmin(x$lower$bound, upper_bounds)
      if (test.type %in% c(7, 8) && !is.null(x$harm)) {
        design_object$harm <- x$harm
      }
    } else {
      design_object <- do.call(gsDesign::gsDesign, list(
        k = k,
        test.type = test.type,
        alpha = alpha,
        beta = beta_design,
        astar = astar,
        n.fix = n_fix,
        timing = current_timing,
        sfu = sfu,
        sfupar = sfupar,
        sfl = sfl,
        sflpar = sflpar,
        sfharm = sfharm,
        sfharmparam = sfharmparam,
        tol = tol,
        delta1 = log(hr1),
        delta0 = log(hr0),
        usTime = spending_times$usTime,
        lsTime = spending_times$lsTime,
        testUpper = testUpper,
        testLower = testLower,
        testHarm = testHarm,
        r = r
      ))
      upper_bounds <- design_object$upper$bound
      lower_bounds <- design_object$lower$bound
    }

    if (length(lower_bounds) == 0) lower_bounds <- rep(-20, k)

    theta_assumed <- design_object$delta * compute_delta_ratio(hr, hr1)
    probabilities <- gsDesign::gsProbability(
      k = k,
      theta = c(0, theta_assumed),
      n.I = total_events,
      a = lower_bounds,
      b = upper_bounds,
      r = r
    )

    list(
      design_object = design_object,
      upper_bounds = upper_bounds,
      lower_bounds = lower_bounds,
      probabilities = probabilities
    )
  }

  format_test_flag <- function(flag, analysis_count) {
    if (length(flag) == 1 && isTRUE(flag)) rep(TRUE, analysis_count) else flag
  }

  label_output_matrices <- function(result) {
    accrual_period_names <- nameperiod(cumsum(result$R))
    stratum_names <- paste("Stratum", seq_len(ncol(result$lambdaC)))
    event_period_names <- if (is.null(result$S)) {
      "0-Inf"
    } else {
      nameperiod(cumsum(c(result$S, Inf)))
    }

    rownames(result$lambdaC) <- event_period_names
    colnames(result$lambdaC) <- stratum_names
    rownames(result$etaC) <- event_period_names
    colnames(result$etaC) <- stratum_names
    rownames(result$etaE) <- event_period_names
    colnames(result$etaE) <- stratum_names
    rownames(result$gamma) <- accrual_period_names
    colnames(result$gamma) <- stratum_names

    result
  }

  assemble_power_output <- function(design_result, analysis_schedule, bound_result) {
    result <- design_result
    result$n.I <- analysis_schedule$total_events
    result$T <- analysis_schedule$analysis_time
    result$eDC <- analysis_schedule$eDC
    result$eDE <- analysis_schedule$eDE
    result$eNC <- analysis_schedule$eNC
    result$eNE <- analysis_schedule$eNE
    result$hr <- hr
    result$hr0 <- hr0
    result$hr1 <- hr1
    result$R <- R
    result$S <- S
    result$minfup <- minfup
    result$gamma <- gamma_matrix
    result$ratio <- ratio
    result$lambdaC <- lambdaC_matrix
    result$etaC <- etaC_matrix
    result$etaE <- etaE_matrix
    result$variable <- "Power"
    result$test.type <- test.type
    result$alpha <- alpha
    result$sided <- sided
    result$tol <- tol
    result$method <- method
    result$spending <- spending
    result$informationRates <- informationRates
    result$fullSpendingAtFinal <- fullSpendingAtFinal
    result$call <- match.call()
    result$timing <- analysis_schedule$timing
    result$testUpper <- format_test_flag(testUpper, k)
    result$testLower <- format_test_flag(testLower, k)
    if (test.type %in% c(7, 8)) {
      result$testHarm <- format_test_flag(testHarm, k)
    }

    result$upper$prob <- bound_result$probabilities$upper$prob
    result$upper$bound <- bound_result$upper_bounds
    result$lower$prob <- bound_result$probabilities$lower$prob
    result$lower$bound <- bound_result$lower_bounds
    result$en <- bound_result$probabilities$en
    result$theta <- bound_result$probabilities$theta
    result$power <- sum(bound_result$probabilities$upper$prob[, 2])
    result$beta <- 1 - result$power

    class(result) <- c("gsSurv", "gsDesign")
    label_output_matrices(result)
  }

  resolved_inputs <- resolve_input_defaults()
  k <- resolved_inputs$k
  test.type <- resolved_inputs$test.type
  sided <- resolved_inputs$sided
  alpha <- resolved_inputs$alpha

  # Apply gsSurv/gsSurvCalendar convention: user-facing alpha is divided
  # by sided to obtain the one-sided alpha used by gsDesign().  When
  # inheriting from x, x$alpha is already one-sided (stored by gsDesign),
  # so conversion is skipped.
  if (is.null(x) || alpha_provided_by_user) {
    alpha <- alpha / sided
  }
  astar <- resolved_inputs$astar
  sfu <- resolved_inputs$sfu
  sfupar <- resolved_inputs$sfupar
  sfl <- resolved_inputs$sfl
  sflpar <- resolved_inputs$sflpar
  sfharm <- resolved_inputs$sfharm
  sfharmparam <- resolved_inputs$sfharmparam
  testUpper <- resolved_inputs$testUpper
  testLower <- resolved_inputs$testLower
  testHarm <- resolved_inputs$testHarm
  r <- resolved_inputs$r
  lambdaC_input <- resolved_inputs$lambdaC
  hr <- resolved_inputs$hr
  hr0 <- resolved_inputs$hr0
  hr1 <- resolved_inputs$hr1
  eta_input <- resolved_inputs$eta
  etaE_input <- resolved_inputs$etaE
  gamma_input <- resolved_inputs$gamma
  R <- resolved_inputs$R
  S <- resolved_inputs$S
  ratio <- resolved_inputs$ratio
  minfup <- resolved_inputs$minfup
  method <- resolved_inputs$method
  beta_design <- resolved_inputs$beta_design

  method <- match.arg(
    method,
    c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
  )

  timing_inputs <- resolve_timing_inputs(k)
  k <- timing_inputs$k

  # Validate informationRates
  if (!is.null(informationRates)) {
    if (length(informationRates) != k) {
      stop("informationRates must have length k (", k, ")")
    }
    if (any(informationRates <= 0 | informationRates > 1)) {
      stop("informationRates values must be in (0, 1]")
    }
  }

  normalized_rates <- normalize_rate_inputs(
    control_hazard = lambdaC_input,
    control_dropout = eta_input,
    experimental_dropout = etaE_input,
    enrollment_rate = gamma_input,
    allocation_ratio = ratio
  )
  lambdaC_matrix <- normalized_rates$lambdaC
  etaC_matrix <- normalized_rates$etaC
  etaE_matrix <- normalized_rates$etaE
  gamma_matrix <- normalized_rates$gamma

  expected_counts_at_time <- build_expected_counts_at_time(
    control_hazard = lambdaC_matrix,
    control_dropout = etaC_matrix,
    experimental_dropout = etaE_matrix,
    enrollment_rate = gamma_matrix,
    control_fraction = normalized_rates$Qc,
    experimental_fraction = normalized_rates$Qe
  )

  analysis_schedule <- solve_analysis_schedule(
    timing_inputs = timing_inputs,
    expected_counts_at_time = expected_counts_at_time
  )
  fixed_design_events <- resolve_fixed_design_events(
    analysis_time = analysis_schedule$analysis_time
  )
  spending_times <- resolve_spending_times(
    analysis_time = analysis_schedule$analysis_time,
    actual_timing = analysis_schedule$timing
  )

  if (k == 1) {
    bound_result <- build_fixed_design_result(
      total_events = analysis_schedule$total_events,
      n_fix = fixed_design_events
    )
  } else {
    bound_result <- compute_group_sequential_result(
      n_fix = fixed_design_events,
      current_timing = analysis_schedule$timing,
      total_events = analysis_schedule$total_events,
      spending_times = spending_times
    )
  }

  assemble_power_output(
    design_result = bound_result$design_object,
    analysis_schedule = analysis_schedule,
    bound_result = bound_result
  )
}
