# gsCPFutilitySpending roxy [sinew] ----
#' @title Calibrate Futility Spending to Conditional Power Targets
#'
#' @description
#' \code{gsCPFutilitySpending()} selects parameters for a beta-spending futility
#' boundary so that conditional power at one or more interim futility bounds
#' matches specified targets. Each candidate design is reconstructed with
#' \code{gsDesign()}, which recalculates the statistical information required to
#' retain the reference design's unconditional power.
#'
#' @details
#' Conditional power is evaluated at the candidate lower bound. When \code{theta}
#' is \code{NULL}, the future effect is the observed effect implied by that bound,
#' \code{lower$bound[i] / sqrt(n.I[i])}, following the default convention in
#' \code{\link{gsCP}()}. The calculation conditions on the interim statistic even though it
#' is at a stopping boundary; future futility bounds remain part of the
#' conditional power calculation.
#'
#' One-target calibration supports the one-parameter families \code{sfHSD},
#' \code{sfPower}, \code{sfExponential}, and \code{sfLDOF}. Two-target calibration supports
#' \code{sfLogistic}, \code{sfBetaDist}, \code{sfCauchy}, \code{sfNormal}, \code{sfExtremeValue}, and
#' \code{sfExtremeValue2}. \code{sfLinear} may be used with any number of targets and is
#' the intended choice for more than two. Its knot times are fixed at the lower
#' spending times for the targeted analyses; the fitted cumulative spending
#' proportions are constrained to be strictly increasing and between zero and
#' one.
#'
#' With multiple targets, a latest-to-earliest coordinate solve supplies
#' starting values for a final joint constrained optimization. A result is
#' returned only when every conditional power residual is within
#' \code{control$cp_tol}.
#'
#' The fitted lower spending parameters depend on the complete design,
#' including efficacy spending. For \code{test.type} 7 and 8 they may also depend on
#' harm spending. Changing any of those specifications requires recalibration.
#' \code{\link{toInteger}()} carries the fitted spending function and parameters forward,
#' but rounding information can change the achieved conditional power and does
#' not trigger recalibration.
#'
#' @param x A fixed-timing \code{gsDesign} object with \code{test.type} 3, 4, 7, or 8.
#' @param target_cp Numeric vector of conditional power targets strictly between
#'   zero and one.
#' @param i Interim analysis indices corresponding to \code{target_cp}. Values must
#'   identify active futility bounds, be unique, and be in
#'   \code{1:(x$k - 1)}. Results are ordered by analysis.
#' @param sfl Futility spending function, supplied as a supported function or
#'   its character name. The default is \code{"sfHSD"}.
#' @param theta Optional future effect for conditional power. A scalar is
#'   recycled; otherwise its length must equal \code{target_cp}. When \code{NULL}, the
#'   observed effect at each candidate lower bound is used.
#' @param control Optional named list with components \code{start}, \code{lower}, \code{upper},
#'   \code{cp_tol} (default \code{1e-4}), \code{maxit} (default 500), \code{reltol} (default
#'   \code{1e-10}), \code{backward} (default \code{TRUE}), and \code{trace} (default \code{FALSE}). For
#'   \code{sfLinear}, \code{start} is a vector of cumulative spending proportions; for
#'   other families it contains the spending-function parameters.
#'
#' @return
#' A calibrated design with class \code{c("gsCPFutilitySpending", "gsDesign")}.
#' The \code{cpFutilitySpending} component contains targets, achieved conditional
#' powers, effects, fitted spending metadata, information, reference efficacy
#' and harm specifications, and solver diagnostics.
#'
#' Invalid inputs raise a \code{gsCPFutilitySpending_input_error}. A well-formed
#' target that cannot be attained raises a
#' \code{gsCPFutilitySpending_infeasible_error}; optimizer failure raises a
#' \code{gsCPFutilitySpending_convergence_error}.
#'
#' @examples
#' x <- gsDesign(
#'   k = 3, test.type = 4, timing = c(.5, .75),
#'   sfu = sfHSD, sfupar = -4,
#'   sfl = sfHSD, sflpar = 1
#' )
#' observed_effect <- x$lower$bound[1] / sqrt(x$n.I[1])
#' target <- sum(gsCP(
#'   x, i = 1, zi = x$lower$bound[1], theta = observed_effect
#' )$upper$prob)
#' fit <- gsCPFutilitySpending(x, target_cp = target, i = 1)
#' fit$cpFutilitySpending[c("target_cp", "achieved_cp", "sflpar")]
#'
#' target_h1 <- sum(gsCP(
#'   x, i = 1, zi = x$lower$bound[1], theta = x$delta
#' )$upper$prob)
#' fit_h1 <- gsCPFutilitySpending(
#'   x, target_cp = target_h1, i = 1, theta = x$delta
#' )
#' fit_h1$cpFutilitySpending$theta
#'
#' @seealso \code{\link{gsDesign}}, \code{\link{gsCP}}, \code{\link{sfLinear}},
#'   \code{\link{toInteger}}
#' @export
gsCPFutilitySpending <- function(x, target_cp, i = seq_along(target_cp),
                                 sfl = "sfHSD", theta = NULL,
                                 control = list()) {
  call <- match.call()
  .gsCPFValidateReference(x)

  if (!is.numeric(target_cp) || length(target_cp) < 1L ||
      any(!is.finite(target_cp)) || any(target_cp <= 0 | target_cp >= 1)) {
    .gsCPFAbort(
      "target_cp must be a finite numeric vector with values strictly between 0 and 1.",
      "gsCPFutilitySpending_input_error"
    )
  }
  if (!is.numeric(i) || length(i) != length(target_cp) ||
      any(!is.finite(i)) || any(i != as.integer(i)) ||
      any(i < 1L | i >= x$k) || anyDuplicated(i)) {
    .gsCPFAbort(
      "i must contain unique interim analysis indices in 1:(x$k - 1), one for each target_cp.",
      "gsCPFutilitySpending_input_error"
    )
  }
  if (any(!x$testLower[as.integer(i)])) {
    .gsCPFAbort(
      "Each targeted analysis in i must have an active futility bound (x$testLower[i] is TRUE).",
      "gsCPFutilitySpending_input_error"
    )
  }
  if (!is.null(theta)) {
    if (!is.numeric(theta) || any(!is.finite(theta)) ||
        !(length(theta) %in% c(1L, length(target_cp)))) {
      .gsCPFAbort(
        "theta must be NULL, a finite numeric scalar, or a vector with one value per target_cp.",
        "gsCPFutilitySpending_input_error"
      )
    }
    theta <- rep(theta, length.out = length(target_cp))
  }

  ord <- order(i)
  i <- as.integer(i[ord])
  target_cp <- target_cp[ord]
  if (!is.null(theta)) theta <- theta[ord]

  ctl <- .gsCPFControl(control)
  spending <- .gsCPFResolveSpending(
    sfl = sfl,
    sfl_expr = substitute(sfl),
    n_target = length(target_cp),
    x = x,
    i = i,
    control = ctl
  )

  cache <- new.env(parent = emptyenv())
  last_error <- NULL
  evaluate <- function(par) {
    key <- paste(formatC(par, digits = 14L, format = "fg"), collapse = "|")
    if (exists(key, envir = cache, inherits = FALSE)) {
      return(get(key, envir = cache, inherits = FALSE))
    }

    sflpar <- spending$decode(par)
    ans <- tryCatch({
      candidate <- .gsCPFDesign(x, spending$fun, sflpar)
      theta_used <- if (is.null(theta)) {
        candidate$lower$bound[i] / sqrt(candidate$n.I[i])
      } else {
        theta
      }
      achieved <- vapply(seq_along(i), function(j) {
        cp <- gsCP(
          candidate,
          i = i[j],
          zi = candidate$lower$bound[i[j]],
          theta = theta_used[j],
          r = candidate$r
        )
        sum(cp$upper$prob[, 1L])
      }, numeric(1))
      if (any(!is.finite(achieved))) stop("non-finite conditional power")
      list(
        valid = TRUE,
        design = candidate,
        achieved = achieved,
        residual = achieved - target_cp,
        theta = theta_used,
        sflpar = sflpar,
        par = par,
        error = NULL
      )
    }, error = function(e) {
      last_error <<- conditionMessage(e)
      list(
        valid = FALSE,
        design = NULL,
        achieved = rep(NA_real_, length(target_cp)),
        residual = rep(NA_real_, length(target_cp)),
        theta = rep(NA_real_, length(target_cp)),
        sflpar = sflpar,
        par = par,
        error = conditionMessage(e)
      )
    })
    assign(key, ans, envir = cache)
    ans
  }

  objective <- function(par, target_index = NULL) {
    z <- evaluate(par)
    if (!z$valid) return(1e6 + sum(par^2) * .Machine$double.eps)
    residual <- if (is.null(target_index)) z$residual else z$residual[target_index]
    sum(residual^2)
  }

  start_eval <- evaluate(spending$start)
  if (start_eval$valid && max(abs(start_eval$residual)) <= ctl$cp_tol) {
    best <- start_eval
    solver <- list(
      convergence = 0L,
      message = "Starting values satisfied all conditional power targets.",
      method = "starting values",
      backward = spending$start,
      value = sum(start_eval$residual^2),
      counts = 1L
    )
  } else if (length(target_cp) == 1L) {
    solution <- .gsCPFOneParameterSolve(
      evaluate = evaluate,
      objective = objective,
      start = spending$start,
      lower = spending$lower,
      upper = spending$upper,
      control = ctl
    )
    best <- solution$best
    solver <- solution$solver
  } else {
    solution <- .gsCPFMultipleSolve(
      evaluate = evaluate,
      objective = objective,
      start = spending$start,
      lower = spending$solver_lower,
      upper = spending$solver_upper,
      control = ctl,
      target_order = rev(seq_along(target_cp)),
      bounded = spending$bounded
    )
    best <- solution$best
    solver <- solution$solver
  }

  if (is.null(best) || !best$valid) {
    .gsCPFAbort(
      paste0(
        "No valid candidate design could be constructed",
        if (!is.null(last_error)) paste0(": ", last_error) else "."
      ),
      "gsCPFutilitySpending_infeasible_error",
      list(target_cp = target_cp, closest_cp = rep(NA_real_, length(target_cp)))
    )
  }

  max_residual <- max(abs(best$residual))
  if (max_residual > ctl$cp_tol) {
    bound_reached <- .gsCPFBoundReached(best$par, spending)
    error_class <- if (isTRUE(solver$convergence == 0L)) {
      "gsCPFutilitySpending_infeasible_error"
    } else {
      "gsCPFutilitySpending_convergence_error"
    }
    .gsCPFAbort(
      .gsCPFFailureMessage(
        target_cp = target_cp,
        best = best,
        max_residual = max_residual,
        bound_reached = bound_reached,
        solver = solver
      ),
      error_class,
      list(
        target_cp = target_cp,
        closest_cp = best$achieved,
        residual = best$residual,
        sflpar = best$sflpar,
        max_information = best$design$n.I[best$design$k],
        parameter_bound_reached = bound_reached,
        solver = solver
      )
    )
  }

  candidate <- best$design
  reference <- list(
    class = class(x),
    max_information = x$n.I[x$k],
    timing = x$timing,
    test_type = x$test.type,
    alpha = x$alpha,
    beta = x$beta,
    upper = .gsCPFSpendingMetadata(x$upper),
    harm = if (x$test.type %in% c(7L, 8L)) .gsCPFSpendingMetadata(x$harm) else NULL,
    testUpper = x$testUpper,
    testLower = x$testLower,
    testHarm = x$testHarm
  )
  candidate$cpFutilitySpending <- list(
    target_cp = target_cp,
    achieved_cp = best$achieved,
    residual = best$residual,
    i = i,
    lower_bound = candidate$lower$bound[i],
    theta = best$theta,
    theta_source = if (is.null(theta)) "observed at futility bound" else "specified",
    sfl = spending$name,
    sflpar = candidate$lower$param,
    free_parameters = spending$free(best$par),
    reproducible_by_name = spending$reproducible_by_name,
    information = candidate$n.I,
    max_information = candidate$n.I[candidate$k],
    information_ratio = candidate$n.I[candidate$k] / x$n.I[x$k],
    unconditional_power = sum(candidate$upper$prob[, 2L]),
    reference = reference,
    solver = c(
      solver,
      list(
        cp_tol = ctl$cp_tol,
        max_abs_residual = max_residual,
        converged = TRUE
      )
    ),
    call = call
  )
  candidate$call <- call
  class(candidate) <- c("gsCPFutilitySpending", "gsDesign")
  candidate
}

.gsCPFValidateReference <- function(x) {
  if (!inherits(x, "gsDesign")) {
    .gsCPFAbort("x must inherit from gsDesign.", "gsCPFutilitySpending_input_error")
  }
  if (inherits(x, "gsSurv") || inherits(x, "gsSurvPower")) {
    .gsCPFAbort(
      "Only fixed-timing gsDesign objects are currently supported; gsSurv and gsSurvPower objects are not yet supported.",
      "gsCPFutilitySpending_input_error"
    )
  }
  if (!(x$test.type %in% c(3L, 4L, 7L, 8L))) {
    .gsCPFAbort(
      "x$test.type must be 3, 4, 7, or 8 for beta-spending futility calibration.",
      "gsCPFutilitySpending_input_error"
    )
  }
  if (x$k < 2L || length(x$timing) != x$k ||
      any(!is.finite(x$timing)) || any(diff(x$timing) <= 0) ||
      abs(x$timing[x$k] - 1) > sqrt(.Machine$double.eps)) {
    .gsCPFAbort(
      "x must have fixed, strictly increasing information fractions ending at 1.",
      "gsCPFutilitySpending_input_error"
    )
  }
  invisible(TRUE)
}

.gsCPFControl <- function(control) {
  if (!is.list(control) || is.null(names(control)) || any(names(control) == "")) {
    if (length(control) == 0L) control <- list() else {
      .gsCPFAbort("control must be a named list.", "gsCPFutilitySpending_input_error")
    }
  }
  allowed <- c("start", "lower", "upper", "cp_tol", "maxit", "reltol", "backward", "trace")
  unknown <- setdiff(names(control), allowed)
  if (length(unknown)) {
    .gsCPFAbort(
      paste0("Unknown control component", if (length(unknown) > 1L) "s" else "", ": ", paste(unknown, collapse = ", "), "."),
      "gsCPFutilitySpending_input_error"
    )
  }
  defaults <- list(
    start = NULL, lower = NULL, upper = NULL, cp_tol = 1e-4,
    maxit = 500L, reltol = 1e-10, backward = TRUE, trace = FALSE
  )
  ctl <- utils::modifyList(defaults, control)
  if (!is.numeric(ctl$cp_tol) || length(ctl$cp_tol) != 1L ||
      !is.finite(ctl$cp_tol) || ctl$cp_tol <= 0 || ctl$cp_tol >= .1) {
    .gsCPFAbort("control$cp_tol must be a finite scalar in (0, 0.1).", "gsCPFutilitySpending_input_error")
  }
  if (!is.numeric(ctl$maxit) || length(ctl$maxit) != 1L ||
      !is.finite(ctl$maxit) || ctl$maxit < 1 || ctl$maxit != as.integer(ctl$maxit)) {
    .gsCPFAbort("control$maxit must be a positive integer.", "gsCPFutilitySpending_input_error")
  }
  if (!is.numeric(ctl$reltol) || length(ctl$reltol) != 1L ||
      !is.finite(ctl$reltol) || ctl$reltol <= 0) {
    .gsCPFAbort("control$reltol must be a positive finite scalar.", "gsCPFutilitySpending_input_error")
  }
  if (!is.logical(ctl$backward) || length(ctl$backward) != 1L || is.na(ctl$backward) ||
      !is.logical(ctl$trace) || length(ctl$trace) != 1L || is.na(ctl$trace)) {
    .gsCPFAbort("control$backward and control$trace must be TRUE or FALSE.", "gsCPFutilitySpending_input_error")
  }
  ctl$maxit <- as.integer(ctl$maxit)
  ctl
}

.gsCPFSpendingRegistry <- function() {
  list(
    sfHSD = list(fun = sfHSD, npar = 1L, start = -2, lower = -40, upper = 40),
    sfPower = list(fun = sfPower, npar = 1L, start = 1, lower = 1e-4, upper = 50),
    sfExponential = list(fun = sfExponential, npar = 1L, start = .5, lower = 1e-4, upper = 1.5),
    sfLDOF = list(fun = sfLDOF, npar = 1L, start = 1, lower = .005, upper = 20),
    sfLogistic = list(fun = sfLogistic, npar = 2L, start = c(0, 1), lower = c(-20, 1e-3), upper = c(20, 50)),
    sfBetaDist = list(fun = sfBetaDist, npar = 2L, start = c(1, 1), lower = c(1e-3, 1e-3), upper = c(50, 50)),
    sfCauchy = list(fun = sfCauchy, npar = 2L, start = c(0, 1), lower = c(-20, 1e-3), upper = c(20, 50)),
    sfNormal = list(fun = sfNormal, npar = 2L, start = c(0, 1), lower = c(-20, 1e-3), upper = c(20, 50)),
    sfExtremeValue = list(fun = sfExtremeValue, npar = 2L, start = c(0, 1), lower = c(-20, 1e-3), upper = c(20, 50)),
    sfExtremeValue2 = list(fun = sfExtremeValue2, npar = 2L, start = c(0, 1), lower = c(-20, 1e-3), upper = c(20, 50)),
    sfLinear = list(fun = sfLinear, npar = NA_integer_, start = NULL, lower = NULL, upper = NULL)
  )
}

.gsCPFResolveSpending <- function(sfl, sfl_expr, n_target, x, i, control) {
  registry <- .gsCPFSpendingRegistry()
  aliases <- c(HSD = "sfHSD", Power = "sfPower", Exponential = "sfExponential", LDOF = "sfLDOF")
  name <- NULL
  reproducible_by_name <- TRUE

  if (is.character(sfl) && length(sfl) == 1L && !is.na(sfl)) {
    name <- unname(if (sfl %in% names(aliases)) aliases[[sfl]] else sfl)
    if (!name %in% names(registry)) {
      .gsCPFAbort(
        paste0("Unsupported spending-function name: ", sfl, "."),
        "gsCPFutilitySpending_input_error"
      )
    }
    spec <- registry[[name]]
  } else if (is.function(sfl)) {
    known <- names(registry)[vapply(registry, function(z) identical(z$fun, sfl), logical(1))]
    if (length(known)) {
      name <- known[1L]
      spec <- registry[[name]]
    } else {
      expr <- paste(deparse(sfl_expr), collapse = "")
      name <- if (grepl("^function", expr)) "<anonymous>" else expr
      reproducible_by_name <- name != "<anonymous>"
      if (is.null(control$start)) {
        .gsCPFAbort(
          "control$start is required for a custom spending function.",
          "gsCPFutilitySpending_input_error"
        )
      }
      spec <- list(
        fun = sfl,
        npar = length(control$start),
        start = control$start,
        lower = rep(-20, length(control$start)),
        upper = rep(20, length(control$start))
      )
    }
  } else {
    .gsCPFAbort(
      "sfl must be a supported character name or a spending function.",
      "gsCPFutilitySpending_input_error"
    )
  }

  if (identical(name, "sfLinear")) {
    times <- x$lower$sTime[i]
    start <- control$start
    if (is.null(start)) {
      cumulative <- cumsum(x$lower$spend) / x$beta
      start <- .gsCPFIncreasingStart(cumulative[i])
    }
    if (!is.numeric(start) || length(start) != n_target || any(!is.finite(start))) {
      .gsCPFAbort(
        "For sfLinear, control$start must contain one cumulative spending proportion per target.",
        "gsCPFutilitySpending_input_error"
      )
    }
    if (!is.null(control$start) &&
        (any(start <= 0 | start >= 1) || any(diff(start) <= 0))) {
      .gsCPFAbort(
        "For sfLinear, control$start must be strictly increasing with values in (0, 1).",
        "gsCPFutilitySpending_input_error"
      )
    }
    if (!is.null(control$lower) || !is.null(control$upper)) {
      .gsCPFAbort(
        "control$lower and control$upper are not used with the constrained sfLinear parameterization.",
        "gsCPFutilitySpending_input_error"
      )
    }
    encode <- function(p) {
      p <- .gsCPFIncreasingStart(p)
      z <- numeric(length(p))
      z[length(p)] <- stats::qlogis(p[length(p)])
      if (length(p) > 1L) {
        for (j in seq_len(length(p) - 1L)) z[j] <- stats::qlogis(p[j] / p[j + 1L])
      }
      z
    }
    decode_free <- function(z) {
      p <- numeric(length(z))
      p[length(z)] <- stats::plogis(z[length(z)])
      if (length(z) > 1L) {
        for (j in (length(z) - 1L):1L) p[j] <- p[j + 1L] * stats::plogis(z[j])
      }
      p
    }
    decode <- function(z) c(times, decode_free(z))
    return(list(
      fun = spec$fun,
      name = name,
      npar = n_target,
      start = encode(start),
      lower = rep(-Inf, n_target),
      upper = rep(Inf, n_target),
      solver_lower = rep(-12, n_target),
      solver_upper = rep(12, n_target),
      bounded = FALSE,
      decode = decode,
      free = decode_free,
      reproducible_by_name = TRUE
    ))
  }

  if (spec$npar != n_target) {
    .gsCPFAbort(
      paste0(
        name, " has ", spec$npar, " free parameter", if (spec$npar == 1L) "" else "s",
        " but ", n_target, " conditional power target", if (n_target == 1L) " was" else "s were", " supplied."
      ),
      "gsCPFutilitySpending_input_error"
    )
  }

  same_as_reference <- is.function(x$lower$sf) && identical(spec$fun, x$lower$sf) &&
    length(x$lower$param) == spec$npar
  start <- if (!is.null(control$start)) control$start else if (same_as_reference) x$lower$param else spec$start
  lower <- if (!is.null(control$lower)) control$lower else spec$lower
  upper <- if (!is.null(control$upper)) control$upper else spec$upper
  for (value in list(start = start, lower = lower, upper = upper)) {
    if (!is.numeric(value) || length(value) != spec$npar || any(!is.finite(value))) {
      .gsCPFAbort(
        "control$start, control$lower, and control$upper must match the number of free spending parameters.",
        "gsCPFutilitySpending_input_error"
      )
    }
  }
  if (any(lower >= upper) || any(start < lower | start > upper)) {
    .gsCPFAbort(
      "Spending parameter bounds must satisfy lower < upper and contain control$start.",
      "gsCPFutilitySpending_input_error"
    )
  }
  test <- tryCatch(spec$fun(x$beta, x$lower$sTime, start), error = function(e) e)
  if (inherits(test, "error") || !inherits(test, "spendfn")) {
    .gsCPFAbort(
      paste0(
        "The spending function is invalid at the starting parameters",
        if (inherits(test, "error")) paste0(": ", conditionMessage(test)) else "."
      ),
      "gsCPFutilitySpending_input_error"
    )
  }

  list(
    fun = spec$fun,
    name = name,
    npar = spec$npar,
    start = as.numeric(start),
    lower = as.numeric(lower),
    upper = as.numeric(upper),
    solver_lower = as.numeric(lower),
    solver_upper = as.numeric(upper),
    bounded = TRUE,
    decode = identity,
    free = identity,
    reproducible_by_name = reproducible_by_name
  )
}

.gsCPFIncreasingStart <- function(p) {
  eps <- 1e-4
  p <- pmin(pmax(p, eps), 1 - eps)
  p <- cummax(p)
  if (length(p) > 1L) {
    for (j in 2:length(p)) p[j] <- max(p[j], p[j - 1L] + eps)
  }
  if (p[length(p)] >= 1) {
    p <- seq(eps, 1 - eps, length.out = length(p) + 2L)[-c(1L, length(p) + 2L)]
  }
  p
}

.gsCPFDesign <- function(x, sfl, sflpar) {
  upper_param <- x$upper$param
  if (is.null(upper_param)) upper_param <- -4
  harm_fun <- if (x$test.type %in% c(7L, 8L)) x$harm$sf else sfHSD
  harm_param <- if (x$test.type %in% c(7L, 8L)) x$harm$param else -2

  gsDesign(
    k = x$k,
    test.type = x$test.type,
    alpha = x$alpha,
    beta = x$beta,
    astar = x$astar,
    delta = x$delta,
    n.fix = x$n.fix,
    timing = x$timing,
    sfu = x$upper$sf,
    sfupar = upper_param,
    sfl = sfl,
    sflpar = sflpar,
    sfharm = harm_fun,
    sfharmparam = harm_param,
    tol = x$tol,
    r = x$r,
    n.I = 0,
    maxn.IPlan = 0,
    nFixSurv = 0,
    endpoint = x$endpoint,
    delta1 = x$delta1,
    delta0 = x$delta0,
    overrun = x$overrun,
    usTime = x$upper$sTime,
    lsTime = x$lower$sTime,
    testUpper = x$testUpper,
    testLower = x$testLower,
    testHarm = x$testHarm
  )
}

.gsCPFOneParameterSolve <- function(evaluate, objective, start, lower, upper, control) {
  candidates <- list(evaluate(start))
  grid <- unique(c(lower, seq(lower, upper, length.out = 41L), start, upper))
  values <- lapply(grid, evaluate)
  valid <- vapply(values, `[[`, logical(1), "valid")
  candidates <- c(candidates, values[valid])

  roots <- list()
  if (sum(valid) >= 2L) {
    valid_grid <- grid[valid]
    residual <- vapply(values[valid], function(z) z$residual[1L], numeric(1))
    exact <- which(abs(residual) <= control$cp_tol)
    if (length(exact)) roots <- c(roots, values[valid][exact])
    changes <- which(residual[-length(residual)] * residual[-1L] < 0)
    for (j in changes) {
      root <- tryCatch(
        stats::uniroot(
          function(p) evaluate(p)$residual[1L],
          interval = valid_grid[c(j, j + 1L)],
          tol = min(control$cp_tol / 10, 1e-7)
        )$root,
        error = function(e) NULL
      )
      if (!is.null(root)) roots[[length(roots) + 1L]] <- evaluate(root)
    }
  }
  candidates <- c(candidates, roots)

  opt <- tryCatch(
    stats::optimize(
      function(p) objective(p),
      interval = c(lower, upper),
      tol = control$reltol
    ),
    error = function(e) NULL
  )
  if (!is.null(opt)) candidates[[length(candidates) + 1L]] <- evaluate(opt$minimum)
  candidates <- Filter(function(z) isTRUE(z$valid), candidates)
  best <- if (length(candidates)) candidates[[which.min(vapply(candidates, function(z) sum(z$residual^2), numeric(1)))]] else NULL
  list(
    best = best,
    solver = list(
      convergence = if (!is.null(best)) 0L else 1L,
      message = if (!is.null(best)) "One-parameter root search completed." else "No valid one-parameter candidate was found.",
      method = "grid, uniroot, and optimize",
      backward = start,
      value = if (!is.null(best)) sum(best$residual^2) else Inf,
      counts = length(grid)
    )
  )
}

.gsCPFMultipleSolve <- function(evaluate, objective, start, lower, upper,
                                control, target_order, bounded) {
  backward <- start
  if (control$backward) {
    for (j in target_order) {
      interval <- c(lower[j], upper[j])
      opt <- tryCatch(
        stats::optimize(
          function(value) {
            candidate <- backward
            candidate[j] <- value
            objective(candidate, target_index = j)
          },
          interval = interval,
          tol = sqrt(control$reltol)
        ),
        error = function(e) NULL
      )
      if (!is.null(opt)) backward[j] <- opt$minimum
    }
  }
  backward_eval <- evaluate(backward)

  run_joint <- function(initial) {
    optimizer_control <- list(
      maxit = control$maxit,
      trace = if (control$trace) 1L else 0L
    )
    if (bounded) {
      optimizer_control$factr <- control$reltol / .Machine$double.eps
      optimizer_control$pgtol <- control$reltol
    } else {
      optimizer_control$reltol <- control$reltol
    }
    tryCatch(
      stats::optim(
        par = initial,
        fn = objective,
        method = if (bounded) "L-BFGS-B" else "BFGS",
        lower = if (bounded) lower else -Inf,
        upper = if (bounded) upper else Inf,
        control = optimizer_control
      ),
      error = function(e) list(
        par = initial, value = objective(initial), counts = NA_integer_,
        convergence = 100L, message = conditionMessage(e)
      )
    )
  }
  fits <- list(run_joint(backward))
  if (!isTRUE(all.equal(backward, start))) fits[[2L]] <- run_joint(start)
  best_fit <- fits[[which.min(vapply(fits, `[[`, numeric(1), "value"))]]
  best <- evaluate(best_fit$par)
  list(
    best = best,
    solver = list(
      convergence = best_fit$convergence,
      message = if (is.null(best_fit$message)) "Joint optimization completed." else best_fit$message,
      method = paste0(
        if (control$backward) "latest-to-earliest initialization; " else "",
        if (bounded) "L-BFGS-B" else "BFGS",
        " joint refinement"
      ),
      backward = backward,
      backward_cp = if (backward_eval$valid) backward_eval$achieved else rep(NA_real_, length(target_order)),
      backward_residual = if (backward_eval$valid) backward_eval$residual else rep(NA_real_, length(target_order)),
      value = best_fit$value,
      counts = best_fit$counts
    )
  )
}

.gsCPFBoundReached <- function(par, spending) {
  if (!spending$bounded) {
    p <- spending$free(par)
    return(any(p < 1e-5 | p > 1 - 1e-5 | diff(p) < 1e-5))
  }
  scale <- pmax(1, abs(spending$lower), abs(spending$upper))
  any(abs(par - spending$lower) <= 1e-6 * scale |
        abs(par - spending$upper) <= 1e-6 * scale)
}

.gsCPFFailureMessage <- function(target_cp, best, max_residual, bound_reached, solver) {
  paste0(
    "Conditional power calibration did not meet tolerance. Requested CP: ",
    paste(format(target_cp, digits = 6), collapse = ", "),
    "; closest CP: ", paste(format(best$achieved, digits = 6), collapse = ", "),
    "; maximum absolute residual: ", format(max_residual, digits = 6),
    "; candidate sflpar: ", paste(format(best$sflpar, digits = 6), collapse = ", "),
    "; candidate maximum information: ", format(best$design$n.I[best$design$k], digits = 7),
    "; parameter bound reached: ", bound_reached,
    if (!is.null(solver$backward_residual) && any(is.finite(solver$backward_residual))) paste0(
      "; backward-pass maximum absolute residual: ",
      format(max(abs(solver$backward_residual), na.rm = TRUE), digits = 6)
    ) else "",
    "; solver: ", solver$message
  )
}

.gsCPFSpendingMetadata <- function(spending) {
  list(
    name = spending$name,
    param = spending$param,
    sTime = spending$sTime,
    function_name = if (is.character(spending$sf)) spending$sf else {
      registry <- .gsCPFSpendingRegistry()
      known <- names(registry)[vapply(registry, function(z) identical(z$fun, spending$sf), logical(1))]
      if (length(known)) known[1L] else NA_character_
    }
  )
}

.gsCPFAbort <- function(message, class, data = list()) {
  condition <- structure(
    c(list(message = message, call = NULL), data),
    class = c(class, "gsCPFutilitySpending_error", "error", "condition")
  )
  stop(condition)
}
