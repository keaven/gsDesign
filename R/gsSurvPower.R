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
#' An optional \code{gsSurv} object \code{x} provides defaults for all
#' parameters. User-specified parameters override these defaults, enabling
#' "what-if" analyses: e.g., \code{gsSurvPower(x = design, hr = 0.8)} evaluates
#' power under HR = 0.8 using all other parameters from the design.
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
#' @param x Optional \code{gsSurv} or \code{gsSurvCalendar} object providing
#'   defaults for all parameters. When provided, any user-specified parameter
#'   overrides the corresponding value from \code{x}.
#' @param k Number of analyses planned, including interim and final.
#' @param test.type \code{1} = one-sided, \code{2} = two-sided symmetric,
#'   \code{3} = two-sided asymmetric with binding futility,
#'   \code{4} = two-sided asymmetric with non-binding futility,
#'   \code{5} = two-sided with binding lower bound (alpha-spending),
#'   \code{6} = two-sided with non-binding lower bound (alpha-spending).
#' @param alpha Type I error rate. Default 0.025 for 1-sided testing.
#' @param sided 1 for 1-sided, 2 for 2-sided testing.
#' @param astar Lower bound total crossing probability for \code{test.type}
#'   5 or 6. Default 0.
#' @param sfu Upper bound spending function (default \code{sfHSD}).
#' @param sfupar Parameter for \code{sfu} (default -4).
#' @param sfl Lower bound spending function (default \code{sfHSD}).
#' @param sflpar Parameter for \code{sfl} (default -2).
#' @param r Integer grid parameter for numerical integration (default 18).
#' @param usTime Upper spending time override; vector of length \code{k}
#'   or \code{NULL} (default) to use information fractions.
#' @param lsTime Lower spending time override; vector of length \code{k}
#'   or \code{NULL} (default) to use information fractions.
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
#'   calendar time fractions (\code{T / max(T)}).
#' @param plannedCalendarTime Calendar times for analyses (time 0 = start of
#'   randomization). Scalar (recycled) or vector of length \code{k}. Use
#'   \code{NA} for analyses not determined by calendar time.
#' @param targetEvents Target number of events at each analysis. Scalar
#'   (recycled), vector of length \code{k} (overall targets), or matrix
#'   with \code{k} rows and \code{nstrata} columns (per-stratum targets).
#'   Use \code{NA} for analyses not determined by events.
#' @param maxExtension Maximum time extension beyond the floor time to wait
#'   for \code{targetEvents}. Scalar or vector of length \code{k}.
#' @param minTimeFromPreviousAnalysis Minimum elapsed time since the previous
#'   analysis. Scalar or vector of length \code{k}. Ignored for the first
#'   analysis.
#' @param minN Minimum total sample size enrolled before analysis can proceed.
#'   Scalar or vector of length \code{k}.
#' @param minFollowUp Minimum follow-up time after \code{minN} is reached.
#'   Scalar or vector of length \code{k}. Must be >= 0.
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
#' \item{hr, hr0, hr1}{Assumed, null, and design hazard ratios.}
#' \item{power}{Overall power (sum of upper-bound crossing probabilities
#'   under the assumed HR).}
#' \item{beta}{Type II error (\code{1 - power}).}
#' \item{lambdaC, etaC, etaE, gamma, R, S, ratio, minfup}{As input.}
#' \item{method, spending, variable, call}{As input.}
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
#' design_events <- rowSums(design$eDC) + rowSums(design$eDE)
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
#' @seealso \code{\link{gsSurv}}, \code{\link{gsSurvCalendar}},
#'   \code{\link[gsDesign]{gsDesign}}, \code{\link[gsDesign]{gsProbability}}
#'
#' @export
gsSurvPower <- function(
    x = NULL,
    k = NULL,
    test.type = NULL, alpha = NULL, sided = NULL, astar = NULL,
    sfu = NULL, sfupar = NULL, sfl = NULL, sflpar = NULL,
    r = NULL, usTime = NULL, lsTime = NULL,
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
    tol = .Machine$double.eps^0.25) {
  spending <- match.arg(spending)

  # ---- Resolve parameters from x or defaults ----
  if (!is.null(x)) {
    if (!inherits(x, "gsSurv")) stop("x must be a gsSurv object")

    sided_infer <- function(tt) if (tt == 1) 1L else 2L

    if (is.null(k)) k <- x$k
    if (is.null(test.type)) test.type <- x$test.type
    if (is.null(sided)) sided <- sided_infer(
      if (!is.null(test.type)) test.type else x$test.type
    )
    if (is.null(alpha)) alpha <- x$alpha * sided
    if (is.null(astar)) astar <- x$astar
    if (is.null(sfu)) sfu <- x$upper$sf
    if (is.null(sfupar)) sfupar <- x$upper$param
    if (is.null(sfl)) sfl <- x$lower$sf
    if (is.null(sflpar)) sflpar <- x$lower$param
    if (is.null(r)) r <- x$r
    if (is.null(lambdaC)) lambdaC <- x$lambdaC
    if (is.null(hr)) hr <- x$hr
    if (is.null(hr0)) hr0 <- x$hr0
    if (is.null(hr1)) hr1 <- x$hr
    if (is.null(eta)) eta <- x$etaC
    if (is.null(etaE)) etaE <- x$etaE
    if (is.null(gamma)) gamma <- x$gamma
    if (is.null(R)) R <- x$R
    if (is.null(S)) S <- x$S
    if (is.null(ratio)) ratio <- x$ratio
    if (is.null(minfup)) minfup <- x$minfup
    if (is.null(method)) {
      method <- if (!is.null(x$method)) x$method else "LachinFoulkes"
    }
    beta_design <- x$beta
  } else {
    if (is.null(k)) stop("k must be specified when x is not provided")
    if (is.null(test.type)) test.type <- 4L
    if (is.null(sided)) sided <- 1L
    if (is.null(alpha)) alpha <- 0.025
    if (is.null(astar)) astar <- 0
    if (is.null(sfu)) sfu <- gsDesign::sfHSD
    if (is.null(sfupar)) sfupar <- -4
    if (is.null(sfl)) sfl <- gsDesign::sfHSD
    if (is.null(sflpar)) sflpar <- -2
    if (is.null(r)) r <- 18
    if (is.null(lambdaC)) lambdaC <- log(2) / 6
    if (is.null(hr)) hr <- 0.6
    if (is.null(hr0)) hr0 <- 1
    if (is.null(hr1)) hr1 <- hr
    if (is.null(eta)) eta <- 0
    if (is.null(ratio)) ratio <- 1
    if (is.null(R)) R <- 12
    if (is.null(minfup)) minfup <- 18
    if (is.null(method)) method <- "LachinFoulkes"
    beta_design <- 0.1
  }

  method <- match.arg(
    method, c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
  )

  # ---- Set up rate matrices ----
  if (is.null(etaE)) etaE <- eta
  if (!is.matrix(lambdaC)) lambdaC <- matrix(if (is.vector(lambdaC)) lambdaC else as.vector(lambdaC))
  nstrata <- ncol(lambdaC)
  nlambda <- nrow(lambdaC)
  etaC <- if (is.matrix(eta)) eta else matrix(eta, nrow = nlambda, ncol = nstrata)
  etaE_mat <- if (is.matrix(etaE)) etaE else matrix(etaE, nrow = nlambda, ncol = nstrata)
  if (!is.matrix(gamma)) gamma <- matrix(gamma)

  Qe <- ratio / (1 + ratio)
  Qc <- 1 - Qe

  # ---- Default timing from x when no criteria specified ----
  if (is.null(plannedCalendarTime) && is.null(targetEvents)) {
    if (!is.null(x)) {
      plannedCalendarTime <- x$T
    } else {
      stop("At least one of plannedCalendarTime or targetEvents must be specified")
    }
  }

  # Infer k from timing parameters
  if (is.null(k)) {
    if (!is.null(plannedCalendarTime)) k <- length(plannedCalendarTime)
    else if (is.matrix(targetEvents)) k <- nrow(targetEvents)
    else if (!is.null(targetEvents)) k <- length(targetEvents)
  }
  if (is.null(k) || k < 1) stop("Could not determine number of analyses (k)")

  # ---- Recycle timing parameters to length k ----
  recycle_k <- function(p, nm) {
    if (is.null(p)) return(rep(NA_real_, k))
    if (length(p) == 1) return(rep(p, k))
    if (length(p) == k) return(p)
    stop(paste(nm, "must have length 1 or", k))
  }

  pct  <- recycle_k(plannedCalendarTime, "plannedCalendarTime")
  me   <- recycle_k(maxExtension, "maxExtension")
  mtpa <- recycle_k(minTimeFromPreviousAnalysis, "minTimeFromPreviousAnalysis")
  mfu  <- recycle_k(minFollowUp, "minFollowUp")
  mn   <- recycle_k(minN, "minN")

  if (is.null(targetEvents)) {
    te <- rep(NA_real_, k)
  } else if (is.matrix(targetEvents)) {
    if (nrow(targetEvents) != k) stop("targetEvents matrix must have k rows")
    te <- rowSums(targetEvents)
  } else {
    te <- recycle_k(targetEvents, "targetEvents")
  }

  # ---- Helper: expected events at calendar time t ----
  ev_at <- function(t) {
    dc <- eEvents(
      lambda = lambdaC, eta = etaC, gamma = gamma * Qc,
      R = R, S = S, T = t, minfup = 0
    )
    de <- eEvents(
      lambda = lambdaC * hr, eta = etaE_mat, gamma = gamma * Qe,
      R = R, S = S, T = t, minfup = 0
    )
    list(
      eDC = dc$d, eDE = de$d, eNC = dc$n, eNE = de$n,
      total_d = sum(dc$d + de$d), total_n = sum(dc$n + de$n)
    )
  }

  pct_max <- if (any(!is.na(pct))) max(pct[!is.na(pct)]) else 0
  T_ub <- max(sum(R) * 5, pct_max * 2, 200)

  find_t_events <- function(target) {
    f <- function(t) ev_at(t)$total_d - target
    if (f(T_ub) < 0) {
      warning("Target ", round(target), " events may not be achievable")
      return(T_ub)
    }
    if (f(0.001) >= 0) return(0.001)
    uniroot(f, c(0.001, T_ub), tol = tol)$root
  }

  find_t_enroll <- function(target) {
    f <- function(t) ev_at(t)$total_n - target
    if (f(T_ub) < 0) return(T_ub)
    if (f(0.001) >= 0) return(0.001)
    uniroot(f, c(0.001, T_ub), tol = tol)$root
  }

  # ---- Determine analysis times ----
  T_an <- numeric(k)

  for (i in seq_len(k)) {
    floors <- numeric(0)
    if (!is.na(pct[i])) floors <- c(floors, pct[i])
    if (i > 1 && !is.na(mtpa[i])) floors <- c(floors, T_an[i - 1] + mtpa[i])
    if (!is.na(mn[i])) {
      t_n <- find_t_enroll(mn[i])
      fu <- if (!is.na(mfu[i])) mfu[i] else 0
      floors <- c(floors, t_n + fu)
    }
    fl <- if (length(floors) > 0) max(floors) else 0.001

    if (!is.na(te[i])) {
      t_ev <- find_t_events(te[i])
      if (t_ev <= fl) {
        T_an[i] <- fl
      } else if (!is.na(me[i])) {
        T_an[i] <- min(t_ev, fl + me[i])
      } else {
        T_an[i] <- t_ev
      }
    } else {
      T_an[i] <- fl
    }

    # maxExtension is a hard cap: the analysis cannot be pushed beyond
    # the base time + maxExtension, even by other criteria.
    if (!is.na(me[i]) && !is.na(pct[i])) {
      T_an[i] <- min(T_an[i], pct[i] + me[i])
    } else if (!is.na(me[i]) && i > 1) {
      T_an[i] <- min(T_an[i], T_an[i - 1] + me[i])
    }
  }

  # ---- Compute events / sample sizes at each analysis ----
  eDC_mat <- eDE_mat <- eNC_mat <- eNE_mat <- NULL

  for (i in seq_len(k)) {
    ev <- ev_at(T_an[i])
    eDC_mat <- rbind(eDC_mat, ev$eDC)
    eDE_mat <- rbind(eDE_mat, ev$eDE)
    eNC_mat <- rbind(eNC_mat, ev$eNC)
    eNE_mat <- rbind(eNE_mat, ev$eNE)
  }

  total_d <- rowSums(eDC_mat) + rowSums(eDE_mat)
  timing <- total_d / max(total_d)

  # Method-specific effect-size scaling.
  # Schoenfeld/LachinFoulkes/BernsteinLagakos use log(HR) parameterization.
  # Freedman uses delta = (hr - 1) / (hr + 1/ratio).
  compute_delta_ratio <- function(hr_num, hr_denom) {
    if (method == "Freedman") {
      delta_num <- (hr_num - 1) / (hr_num + 1 / ratio)
      delta_den <- (hr_denom - 1) / (hr_denom + 1 / ratio)
      abs(delta_num) / abs(delta_den)
    } else {
      abs(log(hr_num) - log(hr0)) / abs(log(hr_denom) - log(hr0))
    }
  }

  # ---- Fixed-design events for normalization ----
  # Use x$n.fix when available for exact consistency with the design.
  # Otherwise compute from nSurv with hr1.
  if (!is.null(x) && !is.null(x$n.fix)) {
    n_fix <- x$n.fix
  } else {
    T_final <- T_an[k]
    minfup_nfix <- max(0, T_final - sum(R))
    n_fix <- nSurv(
      lambdaC = lambdaC, hr = hr1, hr0 = hr0, eta = eta, etaE = etaE,
      gamma = gamma, R = R, S = S, T = T_final, minfup = minfup_nfix,
      ratio = ratio, alpha = alpha, beta = beta_design, sided = sided,
      tol = tol, method = method
    )$d
  }

  # ---- Compute bounds via gsDesign ----
  if (spending == "calendar") {
    usTime_use <- T_an / max(T_an)
    lsTime_use <- usTime_use
  } else {
    usTime_use <- usTime
    lsTime_use <- lsTime
  }

  if (k == 1) {
    # Fixed design: gsDesign requires k >= 2, so compute directly.
    # Use gsDesign's normalization: theta = delta stored by gsDesign,
    # which equals (z_alpha + z_beta) / sqrt(n_fix).
    z_alpha <- qnorm(1 - alpha / sided)
    theta_design <- (z_alpha + qnorm(1 - beta_design)) / sqrt(n_fix)
    theta_assumed <- theta_design * compute_delta_ratio(hr, hr1)
    drift <- theta_assumed * sqrt(total_d[1])
    power_val <- pnorm(drift - z_alpha)

    design <- list(
      k = 1, test.type = test.type,
      alpha = alpha / sided, sided = sided,
      n.I = total_d[1], n.fix = n_fix,
      timing = 1, tol = tol, r = r,
      upper = list(bound = z_alpha, prob = matrix(c(alpha / sided, power_val), nrow = 1)),
      lower = list(bound = -20, prob = matrix(c(1 - alpha / sided, 1 - power_val), nrow = 1)),
      theta = c(0, theta_assumed),
      en = list(en = total_d[1]),
      delta = theta_design, delta0 = log(hr0), delta1 = log(hr1),
      astar = astar, beta = 1 - power_val
    )
    class(design) <- "gsDesign"

    pwr <- list(
      upper = list(prob = design$upper$prob),
      lower = list(prob = design$lower$prob),
      en = design$en, theta = design$theta
    )
  } else {
    # Reuse original design bounds when x is provided and timing matches,
    # avoiding numerical noise from re-running gsDesign's iteration.
    reuse_bounds <- !is.null(x) && !is.null(x$timing) && length(x$timing) == k &&
      isTRUE(all.equal(timing, x$timing, tolerance = 1e-4))

    if (reuse_bounds) {
      design <- x
      lower_bounds <- x$lower$bound
      upper_bounds <- x$upper$bound
    } else {
      gs_args <- list(
        k = k, test.type = test.type, alpha = alpha / sided,
        beta = beta_design, astar = astar,
        n.fix = n_fix,
        timing = timing,
        sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar,
        tol = tol,
        delta1 = log(hr1), delta0 = log(hr0),
        usTime = usTime_use, lsTime = lsTime_use,
        r = r
      )
      design <- do.call(gsDesign::gsDesign, gs_args)
      lower_bounds <- design$lower$bound
      upper_bounds <- design$upper$bound
    }

    if (length(lower_bounds) == 0) lower_bounds <- rep(-20, k)

    # Scale theta from design HR to assumed HR (method-specific)
    theta_assumed <- design$delta * compute_delta_ratio(hr, hr1)

    pwr <- gsDesign::gsProbability(
      k = k, theta = c(0, theta_assumed),
      n.I = total_d,
      a = lower_bounds,
      b = upper_bounds,
      r = r
    )
  }

  # ---- Assemble gsSurv-compatible output ----
  y <- design
  y$n.I <- total_d
  y$T <- T_an
  y$eDC <- eDC_mat
  y$eDE <- eDE_mat
  y$eNC <- eNC_mat
  y$eNE <- eNE_mat
  y$hr <- hr
  y$hr0 <- hr0
  y$hr1 <- hr1
  y$R <- R
  y$S <- S
  y$minfup <- minfup
  y$gamma <- gamma
  y$ratio <- ratio
  y$lambdaC <- lambdaC
  y$etaC <- etaC
  y$etaE <- etaE_mat
  y$variable <- "Power"
  y$sided <- sided
  y$tol <- tol
  y$method <- method
  y$spending <- spending
  y$call <- match.call()
  y$timing <- timing

  y$upper$prob <- pwr$upper$prob
  y$lower$prob <- pwr$lower$prob
  y$en <- pwr$en
  y$theta <- pwr$theta
  y$power <- sum(pwr$upper$prob[, 2])
  y$beta <- 1 - y$power

  class(y) <- c("gsSurv", "gsDesign")

  nameR <- nameperiod(cumsum(y$R))
  stratnames <- paste("Stratum", seq_len(ncol(y$lambdaC)))
  nameS <- if (is.null(y$S)) "0-Inf" else nameperiod(cumsum(c(y$S, Inf)))
  rownames(y$lambdaC) <- nameS
  colnames(y$lambdaC) <- stratnames
  rownames(y$etaC) <- nameS
  colnames(y$etaC) <- stratnames
  rownames(y$etaE) <- nameS
  colnames(y$etaE) <- stratnames
  rownames(y$gamma) <- nameR
  colnames(y$gamma) <- stratnames

  return(y)
}
