#' Calibrate Futility Spending to Predictive Power Targets
#'
#' @description
#' Select beta-spending futility parameters so that posterior predictive power
#' at selected interim lower bounds matches the requested targets. Each candidate
#' is rebuilt with \code{gsDesign()}, recalculating information to preserve the
#' reference design's target unconditional power.
#'
#' @param x A fixed-timing \code{gsDesign} object with \code{test.type} 3, 4, 7, or 8.
#' @param target_pp Numeric vector of predictive power targets strictly between
#'   zero and one.
#' @param i Unique active interim futility analysis indices, one per target,
#'   in \code{1:(x$k - 1)}. Results are ordered by analysis.
#' @param sfl Supported lower spending function or its character name. Default
#'   \code{"sfHSD"}. See Details for supported families.
#' @param prior A list containing finite numeric vectors \code{z} and
#'   \code{wgts} of the same positive length. \code{z} gives standardized effect
#'   values on the \code{gsPP()} theta scale. \code{wgts} gives nonnegative prior
#'   masses or density-weighted quadrature weights, with positive total weight.
#'   For example, use \code{normalGrid(mu = x$delta / 2,
#'   sigma = 10 / sqrt(x$n.fix))} for the default prior in
#'   \code{gsBoundSummary(x)}. Weights are normalized internally; the normalized
#'   prior is retained in the result. A one-point prior targets fixed-effect CP.
#' @param control Optional named list of numerical solver settings. Unspecified
#'   settings retain their defaults; unknown names and invalid values cause
#'   input errors. These controls change the search, not the prior or target.
#'   \describe{
#'     \item{\code{start}}{Initial spending parameters (default \code{NULL}).
#'       Use matching reference parameters or family defaults when omitted.
#'       Custom functions require explicit starts. For \code{sfLinear}, supply
#'       one strictly increasing cumulative spending proportion in (0, 1) per
#'       target, not the full spending parameter vector.}
#'     \item{\code{lower}, \code{upper}}{Spending-parameter search limits,
#'       not Z-boundaries (default \code{NULL}, selecting family defaults).
#'       Start and limit vectors must be finite and match the free parameter
#'       count; \code{lower < upper} must hold and contain the start.
#'       Supplied limits are not supported for constrained \code{sfLinear}.}
#'     \item{\code{pp_tol}}{Maximum absolute predictive power residual at
#'       every target (default \code{1e-4}); a finite scalar in (0, 0.1).}
#'     \item{\code{maxit}}{Positive integer joint-optimizer iteration limit
#'       (default 500), not a global limit on design evaluations or the
#'       one-parameter root search.}
#'     \item{\code{reltol}}{Positive finite internal convergence tolerance
#'       (default \code{1e-10}); does not replace the \code{pp_tol} check.}
#'     \item{\code{backward}}{Initialize multiple-target fitting from the
#'       latest interim backward before joint refinement (default \code{TRUE}).}
#'     \item{\code{trace}}{Display joint-optimizer progress (default
#'       \code{FALSE}). Both logical controls must be nonmissing scalars.}
#'   }
#'
#' @details
#' \code{gsPP()} averages conditional power over the posterior effect
#' distribution to give the probability of future efficacy rejection. This is
#' not the posterior probability of a positive effect, observed-effect CP, or
#' CP H1. The prior is held fixed throughout calibration, but the posterior is
#' recomputed at each candidate lower bound using its information. As in
#' \code{gsPP()}, conditioning uses the interim statistic, not additionally the
#' event of surviving previous looks. The current bound is a conditioning state,
#' not a reason to set predictive power to zero.
#'
#' One target supports \code{sfHSD}, \code{sfPower}, \code{sfExponential}, and
#' \code{sfLDOF}; two targets support \code{sfLogistic}, \code{sfBetaDist},
#' \code{sfCauchy}, \code{sfNormal}, \code{sfExtremeValue}, and
#' \code{sfExtremeValue2}. \code{sfLinear} supports one or more targets with
#' fixed knots at their lower spending times. The target count must equal the
#' number of free parameters. The solver is shared with
#' \code{gsCPFutilitySpending()}, including its latest-to-earliest initialization
#' and joint refinement. Only fits meeting all target tolerances are returned.
#'
#' Preserve the complete reference design when replaying fitted parameters.
#' Changing timing, efficacy or harm spending, or testing indicators requires
#' recalibration. Use the same prior and effect scale when verifying PP with
#' \code{gsBoundSummary()}. Direct survival-object calibration is unsupported;
#' the vignette \code{vignette("CPFutilitySpending")} shows reconstruction of
#' a survival design from a matching statistical reference.
#'
#' \code{toInteger()} retains the spending specification but does not
#' recalibrate PP after rounding. Extremely remote prior support can make the
#' likelihood normalization in \code{gsPP()} numerically undefined; such
#' candidates are rejected and the diagnostic reports this if no valid design
#' can be constructed.
#'
#' @inheritSection gsCPFutilitySpending Spending-parameter search defaults
#'
#' @return A calibrated object with class
#'   \code{c("gsPPFutilitySpending", "gsDesign")}. Its
#'   \code{ppFutilitySpending} component records \code{target_pp},
#'   \code{achieved_pp}, residuals, analysis indices, normalized prior,
#'   fitted spending parameters, information, unconditional power, reference
#'   settings, and solver diagnostics (including \code{pp_tol}). Invalid inputs,
#'   infeasible searches, and convergence failures raise respectively
#'   \code{gsPPFutilitySpending_input_error},
#'   \code{gsPPFutilitySpending_infeasible_error}, and
#'   \code{gsPPFutilitySpending_convergence_error}, all inheriting from
#'   \code{gsPPFutilitySpending_error}. These describe the implemented search,
#'   not a global certificate of mathematical infeasibility.
#'
#' @examples
#' x <- gsDesign(
#'   k = 3, test.type = 4, timing = c(.5, .75),
#'   sfu = sfLDOF, sfl = sfHSD, sflpar = 1,
#'   testLower = c(TRUE, FALSE, FALSE)
#' )
#' prior <- normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))
#' fit <- gsPPFutilitySpending(x, target_pp = .3, i = 1, prior = prior)
#' final_design <- gsDesign(
#'   k = 3, test.type = 4, timing = c(.5, .75),
#'   sfu = sfLDOF, sfl = sfHSD,
#'   sflpar = fit$ppFutilitySpending$sflpar,
#'   testLower = c(TRUE, FALSE, FALSE)
#' )
#' gsBoundSummary(final_design, prior = prior, exclude = "B-value")
#' # Optional tighter predictive power acceptance tolerance:
#' fit_tight <- gsPPFutilitySpending(
#'   x, target_pp = .3, i = 1, prior = prior,
#'   control = list(pp_tol = 1e-6)
#' )
#' fit_tight$ppFutilitySpending$residual
#'
#' @seealso \code{\link{gsCPFutilitySpending}}, \code{\link{gsPP}},
#'   \code{\link{normalGrid}}, \code{\link{gsBoundSummary}}
#' @export
gsPPFutilitySpending <- function(x, target_pp, i = seq_along(target_pp),
                                 sfl = "sfHSD", prior, control = list()) {
  call <- match.call()
  sfl_expr <- substitute(sfl)
  tryCatch({
    .gsCPFValidateReference(x)
    if (missing(prior)) {
      .gsCPFAbort("prior must be supplied.", "gsCPFutilitySpending_input_error")
    }
    prior <- .gsPPFValidatePrior(prior)
    positive <- prior$wgts > 0
    if (!is.list(control) || (length(control) &&
        (is.null(names(control)) || anyNA(names(control)) ||
         any(names(control) == "") || anyDuplicated(names(control))))) {
      .gsCPFAbort("control must be a named list with unique names.",
                  "gsCPFutilitySpending_input_error")
    }
    allowed <- c("start", "lower", "upper", "pp_tol", "maxit", "reltol", "backward", "trace")
    if (any(!names(control) %in% allowed)) {
      .gsCPFAbort(paste("Unknown control component:",
                       paste(setdiff(names(control), allowed), collapse = ", ")),
                  "gsCPFutilitySpending_input_error")
    }
    names(control)[names(control) == "pp_tol"] <- "cp_tol"
    result <- .gsFutilitySpending(
      x, target_pp, i, sfl, theta = NULL, control = control,
      call = call, sfl_expr = sfl_expr,
      probability = function(candidate, indices) {
        vapply(indices, function(j) {
          pp <- gsPP(candidate, i = j, zi = candidate$lower$bound[j],
                     theta = prior$z[positive], wgts = prior$wgts[positive],
                     r = candidate$r)
          if (!is.finite(pp)) {
            stop("Non-finite gsPP result; posterior likelihood normalization may have underflowed.")
          }
          pp
        }, numeric(1))
      }
    )
    meta <- result$cpFutilitySpending
    names(meta)[names(meta) == "target_cp"] <- "target_pp"
    names(meta)[names(meta) == "achieved_cp"] <- "achieved_pp"
    meta$theta <- meta$theta_source <- NULL
    meta$prior <- prior
    names(meta$solver)[names(meta$solver) == "cp_tol"] <- "pp_tol"
    names(meta$solver)[names(meta$solver) == "backward_cp"] <- "backward_pp"
    meta$solver$message <- .gsPPFMessage(meta$solver$message)
    result$cpFutilitySpending <- NULL
    result$ppFutilitySpending <- meta
    class(result) <- c("gsPPFutilitySpending", "gsDesign")
    result
  }, gsCPFutilitySpending_error = function(e) {
    if (!startsWith(conditionMessage(e), "Unknown control component")) {
      e$message <- .gsPPFMessage(conditionMessage(e))
    }
    names(e)[names(e) == "target_cp"] <- "target_pp"
    names(e)[names(e) == "closest_cp"] <- "closest_pp"
    if (!is.null(e$solver$backward_cp)) {
      names(e$solver)[names(e$solver) == "backward_cp"] <- "backward_pp"
    }
    if (!is.null(e$solver$message)) e$solver$message <- .gsPPFMessage(e$solver$message)
    class(e) <- sub("^gsCPFutilitySpending", "gsPPFutilitySpending", class(e))
    stop(e)
  })
}

.gsPPFMessage <- function(message) {
  message <- gsub("conditional power", "predictive power", message, fixed = TRUE)
  message <- gsub("Conditional power", "Predictive power", message, fixed = TRUE)
  message <- gsub("target_cp", "target_pp", message, fixed = TRUE)
  message <- gsub("cp_tol", "pp_tol", message, fixed = TRUE)
  gsub("CP", "PP", message, fixed = TRUE)
}

.gsPPFValidatePrior <- function(prior) {
  valid_vector <- function(z) is.numeric(z) && !is.complex(z) && is.null(dim(z)) &&
    length(z) > 0L && all(is.finite(z))
  if (!is.list(prior) || !valid_vector(prior[["z"]]) ||
      !valid_vector(prior[["wgts"]]) ||
      length(prior[["z"]]) != length(prior[["wgts"]]) ||
      any(prior[["wgts"]] < 0) || !any(prior[["wgts"]] > 0)) {
    .gsCPFAbort(paste("prior must contain finite numeric vectors z and wgts of equal",
                     "positive length, with nonnegative weights and positive total weight."),
                "gsCPFutilitySpending_input_error")
  }
  weights <- prior[["wgts"]] / max(prior[["wgts"]])
  list(z = prior[["z"]], wgts = weights / sum(weights))
}
