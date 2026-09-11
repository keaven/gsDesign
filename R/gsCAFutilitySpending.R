#' Calibrate Futility Spending at Fixed Information
#'
#' @description
#' Compatibility wrapper for \code{gsCPOSFutilitySpending(mode = "fixed_information")},
#' retaining the legacy argument, diagnostic and error names.
#' Fit beta-spending parameters to conditional-assurance targets while holding
#' the reference information and efficacy boundaries fixed. Overall power may
#' change. Total beta is solved internally so that the spending rule and the
#' terminal decision at the fixed efficacy boundary are consistent.
#'
#' @inheritParams gsCPOSFutilitySpending
#' @param target_ca Conditional-assurance targets strictly between zero and one.
#' @param i Unique active interim futility indices, one per target.
#' @param control Named numerical controls. Use \code{ca_tol} for the maximum
#'   absolute target residual (default \code{1e-4}, finite and in (0, 0.1)).
#'   All other controls and defaults are as in \code{\link{gsCPOSFutilitySpending}}:
#'   \code{start}, \code{lower}, \code{upper}, \code{maxit}, \code{reltol},
#'   \code{backward}, and \code{trace}. Unknown or invalid controls are errors.
#'
#' @details
#' This is the fixed-information counterpart of
#' \code{\link{gsCPOSFutilitySpending}}. The prior, information, efficacy
#' boundaries, spending times and testing indicators are held fixed.
#' For each candidate spending parameter set, \code{gsBound1()} derives interim
#' futility bounds, and \code{gsProbability()} evaluates total beta when final
#' lower and upper bounds coincide. An internal scalar solve makes that beta
#' agree with the beta used by the spending function.
#'
#' The probability target conditions on continuation through an analysis, not
#' on an observed statistic at a boundary. An externally calculated fixed-design
#' \code{gsPOS()} benchmark can be supplied as a target. This implements a
#' spending-based fixed-information conditional-assurance rule, not a full
#' sample-size re-estimation procedure.
#'
#' With nonbinding futility (\code{test.type = 4}), the efficacy-only type I
#' error specification is unchanged. With binding futility (\code{test.type = 3}),
#' changing futility while freezing efficacy can change actual type I error,
#' including increasing it above the reference alpha. Inspect
#' \code{achieved_type1}; this function does not promise preservation of alpha
#' or power in that case. The reference nominal alpha remains in \code{x$alpha}.
#'
#' Replay by calling this function with the original reference, the fitted
#' spending family, prior and targets, and \code{control$start} set to the fitted
#' free parameters. A usual power-preserving \code{gsDesign()} call is not an
#' equivalent reconstruction. The internally fitted beta and spending
#' parameters together specify the lower spending rule at the fixed information.
#'
#' @return A \code{c("gsCAFutilitySpending", "gsDesign")} object, with
#'   \code{caFutilitySpending} diagnostics analogous to those of
#'   \code{gsCPOSFutilitySpending}, using \code{target_ca}, \code{achieved_ca}
#'   and \code{ca_tol}. Additional fields include \code{achieved_beta},
#'   \code{achieved_type1}, and \code{fixed_information}. The returned
#'   \code{beta} is achieved overall beta, not the reference beta.
#'   Error classes use the prefix \code{gsCAFutilitySpending}.
#' @examples
#' x <- gsDesign(k = 2, test.type = 4, sflpar = 0)
#' prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
#' target <- gsCPOS(1, x, prior$z, prior$wgts)
#' fit <- gsCAFutilitySpending(x, target, prior = prior,
#'                            control = list(start = 1))
#' fit$caFutilitySpending[c("sflpar", "achieved_ca", "achieved_beta")]
#' stopifnot(identical(fit$n.I, x$n.I),
#'           identical(fit$upper$bound, x$upper$bound))
#' @seealso \code{\link{gsCPOSFutilitySpending}}, \code{\link{gsCPOS}},
#'   \code{\link{gsPOS}}, \code{\link{gsBound1}}
#' @export
gsCAFutilitySpending <- function(x, target_ca, i = seq_along(target_ca),
                                 sfl = "sfHSD", prior, control = list()) {
  call <- match.call()
  tryCatch({
    if (missing(prior)) {
      .gsCPFAbort("prior must be supplied.", "gsCPOSFutilitySpending_input_error")
    }
    if (!is.list(control) || (length(control) &&
        (is.null(names(control)) || anyNA(names(control)) ||
         any(names(control) == "") || anyDuplicated(names(control))))) {
      .gsCPFAbort("control must be a named list with unique names.",
                  "gsCPOSFutilitySpending_input_error")
    }
    if ("cpos_tol" %in% names(control)) {
      .gsCPFAbort("Unknown control component: cpos_tol",
                  "gsCPOSFutilitySpending_input_error")
    }
    names(control)[names(control) == "ca_tol"] <- "cpos_tol"
    result <- gsCPOSFutilitySpending(x, target_cpos = target_ca, i = i,
      sfl = sfl, prior = prior, control = control, mode = "fixed_information")
    meta <- result$cposFutilitySpending
    meta$call <- call
    names(meta)[names(meta) == "target_cpos"] <- "target_ca"
    names(meta)[names(meta) == "achieved_cpos"] <- "achieved_ca"
    names(meta$solver)[names(meta$solver) == "cpos_tol"] <- "ca_tol"
    names(meta$solver)[names(meta$solver) == "backward_cpos"] <- "backward_ca"
    meta$solver$message <- .gsCAFMessage(meta$solver$message)
    result$cposFutilitySpending <- NULL
    result$caFutilitySpending <- meta
    class(result) <- c("gsCAFutilitySpending", "gsDesign")
    result
  }, error = function(e) {
    if (!inherits(e, c("gsCPFutilitySpending_error", "gsCPOSFutilitySpending_error"))) stop(e)
    if (!startsWith(conditionMessage(e), "Unknown control component")) {
      e$message <- .gsCAFMessage(conditionMessage(e))
    }
    names(e)[names(e) == "target_cpos"] <- "target_ca"
    names(e)[names(e) == "closest_cpos"] <- "closest_ca"
    if (!is.null(e$solver$backward_cpos)) {
      names(e$solver)[names(e$solver) == "backward_cpos"] <- "backward_ca"
    }
    if (!is.null(e$solver$message)) e$solver$message <- .gsCAFMessage(e$solver$message)
    class(e) <- sub("^gs(CP|CPOS)FutilitySpending", "gsCAFutilitySpending", class(e))
    stop(e)
  })
}
.gsCAFMessage <- function(message) {
  message <- .gsCPOSFMessage(message)
  message <- gsub("target_cpos", "target_ca", message, fixed = TRUE)
  message <- gsub("cpos_tol", "ca_tol", message, fixed = TRUE)
  gsub("CPOS", "CA", message, fixed = TRUE)
}

.gsCAFDesign <- function(x, sfl, sflpar) {
  k <- x$k
  interim <- seq_len(k - 1L)
  evaluate_beta <- function(beta, return_design = FALSE) {
    lower <- sfl(beta, x$lower$sTime, sflpar)
    cumulative <- lower$spend
    if (length(cumulative) != k || any(!is.finite(cumulative)) ||
        any(diff(c(0, cumulative)) < -x$tol) ||
        abs(cumulative[k] - beta) > x$tol) {
      stop("Spending function must give increasing cumulative spending ending at beta.")
    }
    for (j in interim) {
      if (!x$testLower[j]) cumulative[j] <- if (j == 1L) 0 else cumulative[j - 1L]
    }
    increments <- diff(c(0, cumulative))
    bounds <- -gsBound1(theta = -x$delta, I = x$n.I[interim],
                         a = -x$upper$bound[interim],
                         probhi = increments[interim], tol = x$tol, r = x$r)$b
    bounds[!x$testLower[interim]] <- -20
    if (any(bounds[x$testLower[interim]] >=
            x$upper$bound[interim][x$testLower[interim]])) {
      stop("Futility spending exhausts the continuation region.")
    }
    candidate <- x
    candidate$lower <- lower
    candidate$lower$sTime <- x$lower$sTime
    candidate$lower$bound <- c(bounds, x$upper$bound[k])
    p <- gsProbability(d = candidate, theta = c(0, x$delta))
    achieved_beta <- sum(p$lower$prob[, 2L])
    if (!return_design) return(achieved_beta - beta)
    candidate$beta <- achieved_beta
    candidate$theta <- p$theta
    candidate$lower$prob <- p$lower$prob
    candidate$lower$spend <- increments
    candidate$upper$prob <- p$upper$prob
    candidate$en <- p$en
    candidate
  }
  # Search feasible beta values before root refinement. Extreme spending shapes
  # can make high-beta candidates invalid; those are not valid root endpoints.
  grid <- sort(unique(c(1e-8, x$beta, seq(.05, .95, .05), 1 - 1e-8)))
  previous <- NULL
  root <- NULL
  for (beta in grid) {
    value <- tryCatch(evaluate_beta(beta), error = function(e) NA_real_)
    if (!is.finite(value)) next
    if (abs(value) < min(x$tol / 10, 1e-8)) {
      root <- beta
      break
    }
    if (!is.null(previous) && value * previous$value < 0) {
      root <- stats::uniroot(evaluate_beta, c(previous$beta, beta),
                            tol = min(x$tol / 10, 1e-8))$root
      break
    }
    previous <- list(beta = beta, value = value)
  }
  if (is.null(root)) stop("Unable to solve total beta at fixed information for this spending shape.")
  candidate <- evaluate_beta(root, return_design = TRUE)
  if (abs(candidate$beta - root) > max(5 * x$tol, 1e-7)) {
    stop("Fixed-information beta consistency check failed.")
  }
  candidate
}
