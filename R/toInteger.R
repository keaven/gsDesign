#' Translate group sequential design to integer events (survival designs)
#' or sample size (other designs)
#'
#' @param x An object of class \code{gsDesign} or \code{gsSurv}.
#' @param ratio Usually corresponds to experimental:control sample size ratio.
#'   If an integer is provided, rounding is done to a multiple of
#'   \code{ratio + 1}. See details.
#'   If input is non integer, rounding is done to the nearest integer or
#'   nearest larger integer depending on \code{roundUpFinal}.
#' @param roundUpFinal For non-survival designs, final sample size is rounded
#'   up to a multiple of \code{ratio + 1} with the default
#'   \code{roundUpFinal = TRUE} if \code{ratio} is a non-negative integer.
#'   For survival designs, the final event count is rounded up with
#'   \code{roundUpFinal = TRUE}.
#'   If \code{roundUpFinal = FALSE} and \code{ratio} is a non-negative integer,
#'   sample size is rounded to the nearest multiple of \code{ratio + 1}.
#'   See details.
#'
#' @return Output is an object of the same class as input \code{x}; i.e.,
#'   \code{gsDesign} with integer vector for \code{n.I} or \code{gsSurv}
#'   with integer vector \code{n.I} and integer total sample size. See details.
#'
#' @details
#' It is useful to explicitly provide the argument \code{ratio} when a
#' \code{gsDesign} object is input since \code{gsDesign()} does not have a
#' \code{ratio} in return.
#' \code{ratio = 0, roundUpFinal = TRUE} will just round up the sample size
#' for non-survival designs.
#' Since \code{x <- gsSurv(ratio = M)} returns a value for \code{ratio},
#' \code{toInteger(x)} will round to a multiple of \code{M + 1} if \code{M}
#' is a non-negative integer; otherwise, just rounding will occur.
#' For 1:1 randomization, \code{ratio = 1} gives an even final sample size.
#' For 2:1 randomization, \code{ratio = 2} gives a final sample size that is
#' a multiple of 3.
#' To just round without concern for randomization ratio, set \code{ratio = 0}.
#' If \code{toInteger(x, ratio = 3)}, rounding for final sample size is done
#' to a multiple of 3 + 1 = 4; this could represent a 3:1 or 1:3
#' randomization ratio.
#' For 3:2 randomization, \code{ratio = 4} would ensure rounding sample size
#' to a multiple of 5.
#'
#' For a \code{gsSurv} object, \code{x$n.I} is an event-count schedule.
#' \code{toInteger()} rounds the final planned event count (up when
#' \code{roundUpFinal = TRUE}; otherwise to nearest integer, with a 0.01
#' tolerance), then derives interim integer event targets from
#' \code{x$timing * final_events}. Interim counts are constrained to be positive
#' and strictly increasing. Group sequential boundaries and spending are
#' recomputed with \code{gsDesign()} at the integer event counts.
#'
#' Total sample size for a survival design is then updated under a fixed
#' calendar plan (same enrollment periods, study duration, and minimum
#' follow-up). Enrollment rates are scaled proportionally to the final-event
#' inflation factor and rounded to the nearest allocation multiple
#' \code{ratio + 1} (or rounded up when \code{roundUpFinal = TRUE}), with
#' additional allocation-step adjustment only if needed to make the integer
#' final event target achievable.
#'
#' If fixed-calendar enrollment-rate inflation cannot make the integer final
#' event target feasible, \code{toInteger()} falls back to a variable-duration
#' solve and issues a warning.
#' For a complete seasonal exact-binomial monitoring workflow, see
#' \code{vignette("MultiSeasonRareEvents", package = "gsDesign")}.
#'
#' Selective-bound settings (\code{testUpper}, \code{testLower}, \code{testHarm},
#' and harm spending for \code{test.type} 7 or 8) are carried from the input
#' design into the internal \code{gsDesign()} recomputation so skipped looks stay
#' skipped after integer rounding.
#'
#' @seealso \code{\link{gsSurv}}, \code{\link{toBinomialExact}},
#'   \code{vignette("MultiSeasonRareEvents", package = "gsDesign")}
#'
#' @export
#'
#' @examples
#' # The following code derives the group sequential design using the method
#' # of Lachin and Foulkes
#'
#' x <- gsSurv(
#'   k = 3,                 # 3 analyses
#'   test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
#'   alpha = .025,          # 1-sided Type I error
#'   beta = .1,             # Type II error (1 - power)
#'   timing = c(0.45, 0.7), # Proportion of final planned events at interims
#'   sfu = sfHSD,           # Efficacy spending function
#'   sfupar = -4,           # Parameter for efficacy spending function
#'   sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
#'   sflpar = 0,            # Parameter for futility spending function
#'   lambdaC = .001,        # Exponential failure rate
#'   hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
#'   hr0 = 0.7,             # Null hypothesis VE
#'   eta = 5e-04,           # Exponential dropout rate
#'   gamma = 10,            # Piecewise exponential enrollment rates
#'   R = 16,                # Time period durations for enrollment rates in gamma
#'   T = 24,                # Planned trial duration
#'   minfup = 8,            # Planned minimum follow-up
#'   ratio = 3              # Randomization ratio (experimental:control)
#' )
#' # Convert sample size to multiple of ratio + 1 = 4,
#' # with final event count rounded up by default.
#' toInteger(x)
toInteger <- function(x, ratio = x$ratio, roundUpFinal = TRUE) {
  if (!inherits(x, "gsDesign")) stop("must have class gsDesign as input")
  if (!(isInteger(ratio) && ratio >= 0)){
    message("toInteger: rounding done to nearest integer since ratio was not specified as postive integer .")
    ratio <- 0
  }
  if (inherits(x, "gsSurv")) {
    final_count <- round(x$n.I[x$k])
    if (abs(x$n.I[x$k] - final_count) > .01) {
      final_count <- if (roundUpFinal) ceiling(x$n.I[x$k]) else round(x$n.I[x$k])
    }
    counts <- rep(final_count, x$k)
    if (x$k > 1) {
      counts[1:(x$k - 1)] <- round(x$timing[1:(x$k - 1)] * final_count)
      counts[1:(x$k - 1)] <- pmax(1, pmin(counts[1:(x$k - 1)], final_count - 1))
      if (x$k > 2) {
        for (i in 2:(x$k - 1)) {
          max_allowed <- final_count - (x$k - i)
          counts[i] <- min(max_allowed, max(counts[i], counts[i - 1] + 1))
        }
      }
      counts[x$k] <- max(final_count, counts[x$k - 1] + 1)
    }
  } else {
    counts <- round(x$n.I) # Round sample size for non-survival designs
    # Check if control size is close to integer multiple of ratio + 1
    if (abs(x$n.I[x$k] - round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)) <= .01) {
      counts[x$k] <- round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)
    # For non-survival designs round sample size based on randomization ratio
    }else if (roundUpFinal) {
      counts[x$k] <- ceiling(x$n.I[x$k] / (ratio + 1)) * (ratio + 1) # Round up for final sample size
    } else {
      counts[x$k] <- round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)
    }
  }
  # update bounds and counts from original design
  # Preserve selective-bound flags and spending (lower may be NULL for test.type 1)
  lower_sf <- if (!is.null(x$lower) && is.function(x$lower$sf)) {
    x$lower$sf
  } else {
    sfHSD
  }
  lower_par <- if (!is.null(x$lower) && !is.null(x$lower$param)) {
    x$lower$param
  } else {
    -2
  }
  sfharm_arg <- if (x$test.type %in% c(7, 8) && !is.null(x$harm) && is.function(x$harm$sf)) {
    x$harm$sf
  } else {
    sfHSD
  }
  sfharmparam_arg <- if (x$test.type %in% c(7, 8) && !is.null(x$harm)) {
    if (!is.null(x$harm$param)) x$harm$param else -2
  } else {
    -2
  }
  test_upper_arg <- if (!is.null(x$testUpper)) x$testUpper else TRUE
  test_lower_arg <- if (!is.null(x$testLower)) x$testLower else TRUE
  test_harm_arg <- if (!is.null(x$testHarm)) x$testHarm else TRUE

  xi <- gsDesign(
    k = x$k, test.type = x$test.type, n.I = counts, maxn.IPlan = counts[x$k],
    alpha = x$alpha, beta = x$beta, astar = x$astar,
    delta = x$delta, delta1 = x$delta1, delta0 = x$delta0, endpoint = x$endpoint,
    sfu = x$upper$sf, sfupar = x$upper$param, sfl = lower_sf, sflpar = lower_par,
    sfharm = sfharm_arg, sfharmparam = sfharmparam_arg,
    lsTime = x$lsTime, usTime = x$usTime,
    testUpper = test_upper_arg, testLower = test_lower_arg, testHarm = test_harm_arg
  )
  if (max(abs(xi$n.I - counts)) > .01) warning("toInteger: check n.I input versus output")
  xi$n.I <- counts # ensure these are integers as they became real in gsDesign call
  # Non-binding futility designs have x$test.type either 4 or 6
  if (x$test.type %in% c(4, 6)) {
    xi$falseposnb <- as.vector(gsprob(0, xi$n.I, rep(-20, xi$k), xi$upper$bound, r = xi$r)$probhi)
  }
  if (inherits(x, "gsSurv") || x$nFixSurv > 0) {
    xi$hr0 <- x$hr0 # H0 hazard ratio
    xi$hr <- x$hr # H1 hazard ratio

    N_continuous <- rowSums(x$eNC + x$eNE)[x$k]
    event_inflate <- xi$n.I[x$k] / x$n.I[x$k]
    N_raw <- N_continuous * event_inflate
    if (roundUpFinal) {
      N <- ceiling(N_raw / (ratio + 1)) * (ratio + 1)
    } else {
      N <- round(N_raw / (ratio + 1), 0) * (ratio + 1)
    }
    build_nsurv <- function(N_target) {
      # Update enrollment rates to achieve new sample size in same time
      inflateN <- N_target / N_continuous
      # Following is adapted from gsSurv() to construct gsSurv object
      xx <- nSurv(
        lambdaC = x$lambdaC, hr = x$hr, hr0 = x$hr0, eta = x$etaC, etaE = x$etaE,
        gamma = x$gamma * inflateN, R = x$R, S = x$S, T = max(x$T), minfup = x$minfup, ratio = x$ratio,
        alpha = x$alpha, beta = NULL, sided = 1, tol = x$tol
      )
      xx$tol <- x$tol
      xx
    }
    if (N <= 0) {
      N <- ratio + 1
    }

    target_events <- xi$n.I[x$k]
    N_step <- ratio + 1
    xx <- build_nsurv(N)
    d_final <- sum(xx$eDC + xx$eDE)

    # Keep enrollment inflation minimal: reduce by allocation steps when possible
    N_candidate <- N - N_step
    while (N_candidate >= N_step) {
      xx_candidate <- build_nsurv(N_candidate)
      d_candidate <- sum(xx_candidate$eDC + xx_candidate$eDE)
      if (d_candidate + .01 < target_events) break
      N <- N_candidate
      xx <- xx_candidate
      d_final <- d_candidate
      N_candidate <- N_candidate - N_step
    }

    # Increase by allocation steps if needed to make final integer event target feasible
    n_adjustments <- 0
    while (d_final + .01 < target_events && n_adjustments < 10000) {
      N <- N + N_step
      xx <- build_nsurv(N)
      d_final <- sum(xx$eDC + xx$eDE)
      n_adjustments <- n_adjustments + 1
    }

    z <- xx
    if (d_final + .01 < target_events) {
      warning(
        "toInteger: fixed-calendar enrollment-rate inflation could not achieve the integer final event target; ",
        "falling back to variable-duration solve.",
        call. = FALSE
      )
      z <- tryCatch(gsnSurv(xx, xi$n.I[xi$k]), error = function(e) e)
      if (inherits(z, "error")) {
        z_error <- z
        z_message <- conditionMessage(z)
        N_original <- N
        if (grepl("under-powered for any follow-up duration", z_message, fixed = TRUE)) {
          N_candidate <- N + N_step
          adjustment <- "increased"
          next_N <- function(N_current) N_current + N_step
          keep_going <- function(N_current) is.finite(N_current)
        } else if (grepl("over-powered for any follow-up duration", z_message, fixed = TRUE)) {
          N_candidate <- N - N_step
          adjustment <- "reduced"
          next_N <- function(N_current) N_current - N_step
          keep_going <- function(N_current) N_current >= N_step
        } else {
          stop(conditionMessage(z), call. = FALSE)
        }
        n_adjustments <- 0
        while (keep_going(N_candidate) && inherits(z, "error") && n_adjustments < 10000) {
          xx_candidate <- build_nsurv(N_candidate)
          z_candidate <- tryCatch(gsnSurv(xx_candidate, xi$n.I[xi$k]), error = function(e) e)
          if (!inherits(z_candidate, "error")) {
            N <- N_candidate
            xx <- xx_candidate
            z <- z_candidate
          } else {
            N_candidate <- next_N(N_candidate)
            n_adjustments <- n_adjustments + 1
          }
        }
        if (inherits(z, "error")) {
          stop(conditionMessage(z_error), call. = FALSE)
        }
        warning(
          "toInteger: rounded total sample size was ", adjustment, " from ", N_original,
          " to ", N, " to make the integer event target achievable with the enrollment model.",
          call. = FALSE
        )
      }
    }
    eDC <- NULL
    eDE <- NULL
    eDC0 <- NULL
    eDE0 <- NULL
    eNC <- NULL
    eNE <- NULL
    T <- NULL
    for (i in 1:(x$k - 1)) {
      xx <- tEventsIA(z, xi$timing[i], tol = x$tol)
      T <- c(T, xx$T)
      eDC <- rbind(eDC, xx$eDC)
      eDE <- rbind(eDE, xx$eDE)
      eDC0 <- rbind(eDC0, xx$eDC0) # Added 6/15/2023
      eDE0 <- rbind(eDE0, xx$eDE0) # Added 6/15/2023
      eNC <- rbind(eNC, xx$eNC)
      eNE <- rbind(eNE, xx$eNE)
    }
    xi$T <- c(T, z$T)
    xi$eDC <- rbind(eDC, z$eDC)
    xi$eDE <- rbind(eDE, z$eDE)
    xi$eDC0 <- rbind(eDC0, z$eDC0) # Added 6/15/2023
    xi$eDE0 <- rbind(eDE0, z$eDE0) # Added 6/15/2023
    xi$eNC <- rbind(eNC, z$eNC)
    xi$eNE <- rbind(eNE, z$eNE)
    xi$hr <- x$hr
    xi$hr0 <- x$hr0
    xi$R <- z$R
    xi$S <- z$S
    xi$minfup <- z$minfup
    xi$gamma <- z$gamma
    xi$ratio <- x$ratio
    xi$lambdaC <- z$lambdaC
    xi$etaC <- z$etaC
    xi$etaE <- z$etaE
    xi$variable <- x$variable
    xi$tol <- x$tol
    class(xi) <- c("gsSurv", "gsDesign")
    nameR <- nameperiod(cumsum(xi$R))
    stratnames <- paste("Stratum", seq_len(ncol(xi$lambdaC)))
    if (is.null(xi$S)) {
      nameS <- "0-Inf"
    } else {
      nameS <- nameperiod(cumsum(c(xi$S, Inf)))
    }
    rownames(xi$lambdaC) <- nameS
    colnames(xi$lambdaC) <- stratnames
    rownames(xi$etaC) <- nameS
    colnames(xi$etaC) <- stratnames
    rownames(xi$etaE) <- nameS
    colnames(xi$etaE) <- stratnames
    rownames(xi$gamma) <- nameR
    colnames(xi$gamma) <- stratnames
  }
  return(xi)
}

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol
