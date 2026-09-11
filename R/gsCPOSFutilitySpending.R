#' Calibrate Futility Spending to Conditional Probability of Success
#'
#' @description
#' Select beta-spending parameters to match \code{gsCPOS()} targets at selected
#' interims, either preserving reference power or fixing reference information.
#'
#' @param x A fixed-timing \code{gsDesign} object with \code{test.type} 3 or 4.
#' @param target_cpos Numeric conditional assurance targets strictly between
#'   zero and one, one per selected interim.
#' @param i Unique active interim futility indices, defaulting to
#'   \code{seq_along(target_cpos)}. Results are ordered by analysis.
#' @param sfl Supported lower spending function or its name; default
#'   \code{"sfHSD"}. See Details.
#' @param prior List with finite numeric vectors \code{z} (standardized effects
#'   on the \code{gsCPOS()} theta scale) and \code{wgts} (nonnegative prior masses
#'   or density-weighted quadrature weights). Weights must have positive total
#'   and are normalized internally. The prior must be supplied explicitly and
#'   is held fixed throughout fitting. For the default \code{gsBoundSummary()}
#'   prior, use \code{normalGrid(mu = x$delta / 2,
#'   sigma = 10 / sqrt(x$n.fix))}.
#' @param control Named list of solver controls. \code{cpos_tol} is the maximum
#'   absolute target residual (default \code{1e-4}, finite and in (0, 0.1)).
#'   The remaining controls have the same definitions and defaults as in
#'   \code{\link{gsPPFutilitySpending}}: \code{start}, \code{lower}, and
#'   \code{upper} (all \code{NULL}); \code{maxit} (500); \code{reltol}
#'   (\code{1e-10}); \code{backward} (\code{TRUE}); and \code{trace}
#'   (\code{FALSE}). Unknown, unnamed, duplicate or invalid controls are errors.
#'   \code{pp_tol} and \code{cp_tol} are not accepted here.
#' @param mode Design constraint: \code{"preserve_power"} (default) rebuilds
#'   candidates with \code{gsDesign()}, allowing maximum information to change.
#'   \code{"fixed_information"} holds information and efficacy boundaries fixed,
#'   solving total beta internally and allowing overall power to change.
#'
#' @details
#' Both modes target the existing \code{gsCPOS()} calculation. In fixed-information
#' mode, \code{gsBound1()} derives lower bounds and an internal beta solve makes
#' spending consistent with the final decision. For binding futility, changing
#' lower bounds while fixing efficacy can increase actual type I error above
#' nominal alpha; inspect \code{achieved_type1}. Replay this mode with the
#' original reference and fitted parameters as \code{control$start}; an ordinary
#' power-preserving \code{gsDesign()} call is not equivalent. The legacy
#' \code{\link{gsCAFutilitySpending}} interface is a compatibility wrapper.
#'
#' Conditional assurance is the prior-averaged probability of future efficacy
#' rejection given that neither stopping boundary has been crossed through
#' interim \code{i}. It includes the entire previous stopping history.
#' Conditioning on continuation reweights the effect distribution; this differs
#' from \code{gsPP()}, which conditions on an exact interim statistic, and from
#' unconditional \code{gsPOS()}. A point prior gives fixed-effect success
#' conditional on continuation, not conditional power at the futility bound.
#'
#' A fixed-design \code{gsPOS()} value at a separately chosen feasible sample
#' size can be computed once and supplied as a benchmark target. The benchmark
#' must not be recomputed from candidates. Preserving power while adjusting
#' information is an extension of a fixed-information conditional-assurance
#' rule, not an implementation of sample-size re-estimation. Inspect sample-size
#' inflation, overall operating characteristics and effect sizes at all bounds.
#'
#' The supported spending families and one-target-per-free-parameter rule are
#' the same as for \code{\link{gsPPFutilitySpending}}, including two-parameter
#' families and \code{sfLinear}. The shared solver accepts only fits meeting
#' every target tolerance; failure is not a proof of global infeasibility.
#'
#' Candidate continuation probabilities at or below
#' \code{sqrt(.Machine$double.eps)} are rejected to avoid unstable conditioning.
#' Harm-bound designs are unsupported because \code{gsCPOS()} does not account
#' for their harm stopping probability in its denominator. Direct survival
#' objects are unsupported; use a matching fixed-timing statistical design.
#' Replay parameters with the complete reference design and the same prior.
#' Spending functions retain their usual timing flexibility, but changed
#' timing, testing indicators or rounding need not retain exact target values.
#'
#' @inheritSection gsCPFutilitySpending Spending-parameter search defaults
#' @return A \code{c("gsCPOSFutilitySpending", "gsDesign")} object. Component
#'   \code{cposFutilitySpending} contains targets (\code{target_cpos}), achieved
#'   values (\code{achieved_cpos}), residuals, indices, normalized prior, fitted
#'   parameters, information and power, reference settings and solver diagnostics.
#'   It also records \code{continuation_probability}, \code{joint_future_efficacy}
#'   and \code{unconditional_pos}. Errors inherit from
#'   \code{gsCPOSFutilitySpending_error}, with suffixes \code{_input_error},
#'   \code{_infeasible_error} or \code{_convergence_error}.
#'   Both modes also record \code{mode}, \code{fixed_information},
#'   \code{achieved_beta} and \code{achieved_type1}.
#' @examples
#' x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sflpar = 1)
#' prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
#' target <- gsCPOS(i = 1, x = x, theta = prior$z, wgts = prior$wgts)
#' fit <- gsCPOSFutilitySpending(
#'   x, target_cpos = target, i = 1, prior = prior,
#'   control = list(start = 0)
#' )
#' fit$cposFutilitySpending$sflpar
#' gsCPOS(i = 1, x = fit, theta = prior$z, wgts = prior$wgts)
#' fixed <- gsCPOSFutilitySpending(
#'   x, target_cpos = target, prior = prior, mode = "fixed_information"
#' )
#' fixed$cposFutilitySpending[c("mode", "achieved_cpos", "achieved_beta")]
#' stopifnot(identical(fixed$n.I, x$n.I))
#' @seealso \code{\link{gsCPOS}}, \code{\link{gsPOS}},
#'   \code{\link{gsPPFutilitySpending}}, \code{\link{gsCPFutilitySpending}}
#' @export
gsCPOSFutilitySpending <- function(x, target_cpos, i = seq_along(target_cpos),
                                 sfl = "sfHSD", prior, control = list(),
                                 mode = c("preserve_power", "fixed_information")) {
  call <- match.call()
  sfl_expr <- substitute(sfl)
  tryCatch({
    if (missing(mode)) mode <- "preserve_power"
    if (!is.character(mode) || length(mode) != 1L || is.na(mode) ||
        !mode %in% c("preserve_power", "fixed_information")) {
      .gsCPFAbort('mode must be "preserve_power" or "fixed_information".',
                  "gsCPFutilitySpending_input_error")
    }
    .gsCPFValidateReference(x)
    if (!x$test.type %in% c(3L, 4L)) {
      .gsCPFAbort("x$test.type must be 3 or 4; harm-bound continuation is unsupported.",
                  "gsCPFutilitySpending_input_error")
    }
    if (missing(prior)) {
      .gsCPFAbort("prior must be supplied.", "gsCPFutilitySpending_input_error")
    }
    prior <- .gsPPFValidatePrior(prior)
    if (!is.list(control) || (length(control) &&
        (is.null(names(control)) || anyNA(names(control)) ||
         any(names(control) == "") || anyDuplicated(names(control))))) {
      .gsCPFAbort("control must be a named list with unique names.",
                  "gsCPFutilitySpending_input_error")
    }
    allowed <- c("start", "lower", "upper", "cpos_tol", "maxit", "reltol", "backward", "trace")
    if (any(!names(control) %in% allowed)) {
      .gsCPFAbort(paste("Unknown control component:",
                       paste(setdiff(names(control), allowed), collapse = ", ")),
                  "gsCPFutilitySpending_input_error")
    }
    names(control)[names(control) == "cpos_tol"] <- "cp_tol"
    result <- .gsFutilitySpending(
      x, target_cpos, i, sfl, theta = NULL, control = control,
      call = call, sfl_expr = sfl_expr,
      design_builder = if (mode == "fixed_information") .gsCAFDesign else .gsCPFDesign,
      probability = function(candidate, indices) {
        .gsCPOSFProbabilities(candidate, indices, prior)$conditional_assurance
      }
    )
    meta <- result$cpFutilitySpending
    names(meta)[names(meta) == "target_cp"] <- "target_cpos"
    names(meta)[names(meta) == "achieved_cp"] <- "achieved_cpos"
    meta$theta <- meta$theta_source <- NULL
    meta$prior <- prior
    meta$mode <- mode
    meta$fixed_information <- mode == "fixed_information"
    meta$achieved_beta <- result$beta
    meta$achieved_type1 <- sum(result$upper$prob[, 1L])
    probabilities <- .gsCPOSFProbabilities(result, meta$i, prior)
    meta$continuation_probability <- probabilities$continuation
    meta$joint_future_efficacy <- probabilities$future_efficacy
    meta$unconditional_pos <- probabilities$pos
    names(meta$solver)[names(meta$solver) == "cp_tol"] <- "cpos_tol"
    names(meta$solver)[names(meta$solver) == "backward_cp"] <- "backward_cpos"
    meta$solver$message <- .gsCPOSFMessage(meta$solver$message)
    result$cpFutilitySpending <- NULL
    result$cposFutilitySpending <- meta
    class(result) <- c("gsCPOSFutilitySpending", "gsDesign")
    result
  }, gsCPFutilitySpending_error = function(e) {
    if (!startsWith(conditionMessage(e), "Unknown control component")) {
      e$message <- .gsCPOSFMessage(conditionMessage(e))
    }
    names(e)[names(e) == "target_cp"] <- "target_cpos"
    names(e)[names(e) == "closest_cp"] <- "closest_cpos"
    if (!is.null(e$solver$backward_cp)) {
      names(e$solver)[names(e$solver) == "backward_cp"] <- "backward_cpos"
    }
    if (!is.null(e$solver$message)) e$solver$message <- .gsCPOSFMessage(e$solver$message)
    class(e) <- sub("^gsCPFutilitySpending", "gsCPOSFutilitySpending", class(e))
    stop(e)
  })
}

.gsCPOSFMessage <- function(message) {
  message <- gsub("conditional power", "conditional assurance", message, fixed = TRUE)
  message <- gsub("Conditional power", "Conditional assurance", message, fixed = TRUE)
  message <- gsub("target_cp", "target_cpos", message, fixed = TRUE)
  message <- gsub("cp_tol", "cpos_tol", message, fixed = TRUE)
  gsub("CP", "CPOS", message, fixed = TRUE)
}

.gsCPOSFProbabilities <- function(x, indices, prior) {
  positive <- prior$wgts > 0
  p <- gsProbability(d = x, theta = prior$z[positive])
  weights <- prior$wgts[positive]
  upper <- as.vector(p$upper$prob %*% weights)
  lower <- as.vector(p$lower$prob %*% weights)
  continuation <- 1 - cumsum(upper + lower)[indices]
  # Sum future crossings directly to avoid subtracting nearly equal totals.
  future <- vapply(indices, function(j) sum(upper[seq.int(j + 1L, x$k)]),
                   numeric(1))
  if (any(!is.finite(continuation)) ||
      any(continuation <= sqrt(.Machine$double.eps))) {
    stop("Near-zero or non-finite continuation probability; conditional assurance is unstable.")
  }
  assurance <- future / continuation
  if (any(!is.finite(assurance)) || any(assurance < 0 | assurance > 1)) {
    stop("Invalid conditional assurance from crossing probabilities.")
  }
  list(conditional_assurance = assurance, continuation = continuation,
       future_efficacy = future, pos = sum(upper))
}
