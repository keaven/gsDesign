#' Calibrate Futility Spending to Unconditional Probability of Success
#'
#' @description
#' Select one free beta-spending parameter to match the unconditional
#' prior-predictive probability of success \code{gsPOS()}. Recalculate maximum
#' information to preserve reference frequentist power.
#'
#' @inheritParams gsCPOSFutilitySpending
#' @param target_pos A single probability of success strictly between zero and
#'   one for the complete design. This is not an interim-specific target.
#' @param sfl A supported one-parameter lower spending function or its name.
#'   Default \code{"sfHSD"}. A custom function must expose exactly one free
#'   parameter. For \code{sfLinear}, a single free knot is placed at the first
#'   active interim futility spending time.
#' @param control Named numerical controls. \code{pos_tol} is the maximum
#'   absolute POS residual (default \code{1e-4}, finite and in (0, 0.1)).
#'   Other controls and defaults are as in \code{\link{gsCPOSFutilitySpending}}:
#'   \code{start}, \code{lower}, \code{upper}, \code{maxit}, \code{reltol},
#'   \code{backward}, and \code{trace}. Unknown or invalid controls are errors.
#'
#' @details
#' \code{gsPOS()} averages the probability of any efficacy rejection over the
#' supplied effect prior, before observing trial data or conditioning on
#' continuation. The prior weights are normalized and then held fixed during
#' fitting. No interim index is required because POS is a single scalar for the
#' entire trial. Consequently, an unconstrained two-parameter spending family
#' cannot be identified from POS alone and is rejected. A custom one-parameter
#' wrapper may fix the other parameters explicitly.
#'
#' Unconditional POS calibration is not Dragalin's conditional-assurance
#' criterion. Compare \code{\link{gsCPOSFutilitySpending}} and
#' \code{\link{gsCAFutilitySpending}} for continuation-conditioned targets.
#' For a point prior at the planned alternative, POS equals the power already
#' preserved by the design builder: the spending shape is then not identified
#' by that target. A valid starting solution can be returned, but does not imply
#' uniqueness. Other priors can also produce flat or nonmonotone objectives.
#' Inspect information inflation and all operating characteristics.
#'
#' @return A \code{c("gsPOSFutilitySpending", "gsDesign")} object with
#'   \code{posFutilitySpending} diagnostics. These include \code{target_pos},
#'   \code{achieved_pos}, residual, normalized prior, fitted parameters,
#'   information, frequentist power, reference settings and solver diagnostics
#'   including \code{pos_tol}. There is no interim target index.
#'   Error classes use the prefix \code{gsPOSFutilitySpending}.
#' @examples
#' x <- gsDesign(k = 3, test.type = 4, sflpar = 1)
#' prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .4, .5))
#' target <- gsPOS(x, prior$z, prior$wgts)
#' fit <- gsPOSFutilitySpending(x, target, prior = prior,
#'                             control = list(start = 0))
#' fit$posFutilitySpending$sflpar
#' gsPOS(fit, prior$z, prior$wgts)
#' @seealso \code{\link{gsPOS}}, \code{\link{gsCPOSFutilitySpending}},
#'   \code{\link{gsCAFutilitySpending}}
#' @export
gsPOSFutilitySpending <- function(x, target_pos,
                                 sfl = "sfHSD", prior, control = list()) {
  call <- match.call()
  sfl_expr <- substitute(sfl)
  tryCatch({
    .gsCPFValidateReference(x)
    if (length(target_pos) != 1L) {
      .gsCPFAbort("target_pos must be a scalar; unconditional POS supplies only one constraint.",
                  "gsCPFutilitySpending_input_error")
    }
    i <- which(x$testLower[seq_len(x$k - 1L)])[1L]
    if (!x$test.type %in% c(3L, 4L)) {
      .gsCPFAbort("x$test.type must be 3 or 4.",
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
    allowed <- c("start", "lower", "upper", "pos_tol", "maxit", "reltol", "backward", "trace")
    if (any(!names(control) %in% allowed)) {
      .gsCPFAbort(paste("Unknown control component:",
                       paste(setdiff(names(control), allowed), collapse = ", ")),
                  "gsCPFutilitySpending_input_error")
    }
    names(control)[names(control) == "pos_tol"] <- "cp_tol"
    result <- .gsFutilitySpending(
      x, target_pos, i, sfl, theta = NULL, control = control,
      call = call, sfl_expr = sfl_expr,
      probability = function(candidate, indices) {
        positive <- prior$wgts > 0
        gsPOS(candidate, theta = prior$z[positive], wgts = prior$wgts[positive])
      }
    )
    meta <- result$cpFutilitySpending
    names(meta)[names(meta) == "target_cp"] <- "target_pos"
    names(meta)[names(meta) == "achieved_cp"] <- "achieved_pos"
    meta$theta <- meta$theta_source <- NULL
    meta$prior <- prior
    meta$i <- meta$lower_bound <- NULL
    meta$unconditional_pos <- meta$achieved_pos
    names(meta$solver)[names(meta$solver) == "cp_tol"] <- "pos_tol"
    names(meta$solver)[names(meta$solver) == "backward_cp"] <- "backward_pos"
    meta$solver$message <- .gsPOSFMessage(meta$solver$message)
    result$cpFutilitySpending <- NULL
    result$posFutilitySpending <- meta
    class(result) <- c("gsPOSFutilitySpending", "gsDesign")
    result
  }, gsCPFutilitySpending_error = function(e) {
    if (!startsWith(conditionMessage(e), "Unknown control component")) {
      e$message <- .gsPOSFMessage(conditionMessage(e))
    }
    names(e)[names(e) == "target_cp"] <- "target_pos"
    names(e)[names(e) == "closest_cp"] <- "closest_pos"
    if (!is.null(e$solver$backward_cp)) {
      names(e$solver)[names(e$solver) == "backward_cp"] <- "backward_pos"
    }
    if (!is.null(e$solver$message)) e$solver$message <- .gsPOSFMessage(e$solver$message)
    class(e) <- sub("^gsCPFutilitySpending", "gsPOSFutilitySpending", class(e))
    stop(e)
  })
}

.gsPOSFMessage <- function(message) {
  message <- gsub("conditional power", "unconditional probability of success", message, fixed = TRUE)
  message <- gsub("Conditional power", "Unconditional probability of success", message, fixed = TRUE)
  message <- gsub("target_cp", "target_pos", message, fixed = TRUE)
  message <- gsub("cp_tol", "pos_tol", message, fixed = TRUE)
  gsub("CP", "POS", message, fixed = TRUE)
}
