#' Calibrate Spending to Natural-Scale Effects at Boundaries
#'
#' Select efficacy, futility or harm spending parameters, separately or jointly,
#' to match approximate observed effects at interim boundaries. Candidate designs
#' are rebuilt with gsDesign(), preserving nominal error budgets and planned
#' power while allowing maximum information to change.
#'
#' @param x Fixed-timing gsDesign reference with test.type 3, 4, 7 or 8.
#'   Direct survival objects are unsupported.
#' @param target_effect Finite natural-scale effect targets.
#' @param i Interim indices, one per target. Duplicate boundary/index pairs
#'   and inactive boundaries are not allowed.
#' @param bound "efficacy", "futility" or "harm", scalar or one per target.
#' @param spending Spending function/name for a single boundary, or a named
#'   list keyed by targeted boundaries. NULL retains the reference families.
#' @param scale "difference", "rr" or "hr".
#' @param effect Endpoint metadata. For differences, optional endpoint is
#'   "mean_difference" or "risk_difference"; for RR it is "risk_ratio".
#'   Difference/RR designs require nondegenerate delta0/delta1 metadata and
#'   n.fix > 1. For RR, delta0/delta1 must be log ratios.
#'   HR requires information = "events", ratio (experimental/control),
#'   hr0 (null HR), and hr1 (alternative HR), all explicitly supplied.
#'   The reference delta must agree with abs(log(hr1/hr0)) *
#'   sqrt(ratio)/(1 + ratio), verifying its event-count scale.
#' @param control Named solver list. start, lower and upper are parameter
#'   vectors for one boundary or named lists by boundary for joint fits.
#'   Defaults use the reference/family settings described in
#'   gsCPFutilitySpending. effect_tol is a positive finite absolute tolerance
#'   in natural effect units, scalar or one per target (default 1e-4).
#'   maxit is a positive integer (default 500), reltol is positive finite
#'   (default 1e-10), and trace is a scalar logical (default FALSE).
#'   Unknown controls are errors. sfLinear starts are increasing cumulative
#'   proportions; user limits are unsupported for sfLinear, whose internal
#'   logit coordinates are searched over [-12, 12].
#'
#' @details
#' One target per free parameter is required for each selected family.
#' Supported families are shared with gsCPFutilitySpending(), including
#' two-parameter functions and piecewise linear spending. Joint fits check
#' all targets simultaneously. Untargeted spending specifications remain fixed,
#' but numerical boundaries may change as information is recalculated.
#'
#' These are approximate effects at bounds, not true-effect assumptions,
#' posterior estimates or bias-adjusted sequential estimates. HRs and RRs are
#' supplied as ratios, not logs. Risk differences must lie in [-1, 1].
#' An effect is transformed using each candidate's information.
#'
#' Count equality does not ensure identifiability. A numerical Jacobian rank
#' and condition number are returned as local diagnostics, not proofs of
#' uniqueness. Harm/futility coincidence is reported and may indicate capping.
#' A failed search does not prove mathematical infeasibility. Inspect all
#' operating characteristics and sample-size inflation before choosing a design.
#' Changing timing or rounding need not retain the calibrated effects.
#'
#' @return A gsDesign object also inheriting from gsEffectSpending. Component
#'   effectSpending contains a target/achieved/residual table, named spending
#'   specifications and free parameters, effect metadata, solver diagnostics,
#'   information inflation, power and local identifiability diagnostics.
#'   replay contains arguments for do.call(gsDesign, ...); for HR, also restore
#'   the returned hr/hr0/ratio metadata for HR summaries.
#'   Errors inherit from gsEffectSpending_error with input_error or
#'   convergence_error suffixes.
#' @examples
#' x <- gsDesign(k = 3, test.type = 4, n.fix = 200, delta1 = .2, sflpar = 1)
#' target <- gsDelta(x$lower$bound[1], 1, x)
#' fit <- gsEffectSpending(x, target, spending = sfHSD,
#'                         control = list(start = 0))
#' fit$effectSpending$targets
#' replay <- do.call(gsDesign, fit$effectSpending$replay)
#' gsDelta(replay$lower$bound[1], 1, replay)
#' @seealso gsCPFutilitySpending, gsDelta, gsRR, gsHR, gsBoundSummary
#' @export
gsEffectSpending <- function(x, target_effect, i = seq_along(target_effect),
                             bound = "futility", spending = NULL,
                             scale = "difference", effect = list(),
                             control = list()) {
  call <- match.call()
  tryCatch({
    targets <- .gsEffectTargets(x, target_effect, i, bound)
    if (length(scale) != 1L || !is.character(scale) || is.na(scale) ||
        !scale %in% c("difference", "rr", "hr")) .gsEffectAbort("Invalid effect scale.")
    if (scale != "difference" && any(target_effect <= 0))
      .gsEffectAbort("Ratio targets must be positive.")
    if (!is.list(effect)) .gsEffectAbort("effect must be a named list.")
    if (identical(effect$endpoint, "risk_difference") && any(abs(target_effect) > 1))
      .gsEffectAbort("Risk difference targets must lie in [-1, 1].")
    .gsEffectAtBound(x, targets$i, targets$bound, scale, effect)
    allowed <- c("start", "lower", "upper", "effect_tol", "maxit", "reltol", "trace")
    if (!is.list(control) || length(control) &&
        (is.null(names(control)) || anyNA(names(control)) ||
         anyDuplicated(names(control)) || any(!names(control) %in% allowed)))
      .gsEffectAbort("control must have unique, recognized names.")
    tol <- control$effect_tol
    if (is.null(tol)) tol <- 1e-4
    if (!is.numeric(tol) || is.complex(tol) || !length(tol) %in% c(1L, nrow(targets)) ||
        any(!is.finite(tol)) || any(tol <= 0)) .gsEffectAbort("Invalid effect_tol.")
    tol <- rep(tol, length.out = nrow(targets))
    groups <- unique(targets$bound)
    slots <- c(efficacy = "upper", futility = "lower", harm = "harm")
    named <- function(z) is.list(z) && !is.null(names(z)) &&
      !anyNA(names(z)) && !anyDuplicated(names(z)) &&
      all(names(z) %in% groups)
    if (!is.null(spending) && length(groups) > 1L && !named(spending))
      .gsEffectAbort("Joint spending must be a named list by boundary.")
    if (is.list(spending) && !named(spending)) .gsEffectAbort("Invalid spending names.")
    for (key in c("start", "lower", "upper")) {
      z <- control[[key]]
      if (!is.null(z) && (is.list(z) || length(groups) > 1L) && !named(z))
        .gsEffectAbort(paste(key, "must be named by boundary for joint fitting."))
    }
    ctl <- .gsCPFControl(control[intersect(names(control), c("maxit", "reltol", "trace"))])
    ctl$backward <- FALSE
    ctl$cp_tol <- 1
    specs <- ids <- list()
    for (b in groups) {
      rows <- which(targets$bound == b)
      rows <- rows[order(targets$i[rows])]
      y <- x
      y$lower <- x[[slots[[b]]]]
      y$beta <- switch(b, efficacy = x$alpha, futility = x$beta, harm = x$astar)
      local_ctl <- ctl
      for (key in c("start", "lower", "upper")) {
        z <- control[[key]]
        local_ctl[[key]] <- if (is.list(z)) z[[b]] else z
      }
      sf <- if (is.null(spending)) y$lower$sf else if (is.list(spending)) spending[[b]] else spending
      if (is.null(sf)) sf <- y$lower$sf
      specs[[b]] <- .gsCPFResolveSpending(sf, substitute(spending), length(rows),
                                         y, targets$i[rows], local_ctl)
    }
    start <- lower <- upper <- numeric()
    for (b in groups) {
      ids[[b]] <- length(start) + seq_along(specs[[b]]$start)
      start <- c(start, specs[[b]]$start)
      lower <- c(lower, specs[[b]]$solver_lower)
      upper <- c(upper, specs[[b]]$solver_upper)
    }
    decode <- function(par) setNames(lapply(groups, function(b)
      list(fun = specs[[b]]$fun, param = specs[[b]]$decode(par[ids[[b]]]))), groups)
    cache <- new.env(parent = emptyenv())
    best <- NULL
    last_error <- NULL
    evaluate <- function(par) {
      key <- paste(format(par, digits = 17), collapse = "|")
      if (exists(key, cache, inherits = FALSE)) return(get(key, cache))
      ans <- tryCatch({
        d <- .gsEffectDesign(x, decode(par))
        achieved <- .gsEffectAtBound(d, targets$i, targets$bound, scale, effect)
        list(valid = TRUE, design = d, achieved = achieved,
             residual = (achieved - target_effect) / tol, par = par)
      }, error = function(e) {
        last_error <<- conditionMessage(e)
        list(valid = FALSE, residual = rep(Inf, nrow(targets)), par = par)
      })
      if (ans$valid && (is.null(best) || sum(ans$residual^2) < sum(best$residual^2)))
        best <<- ans
      assign(key, ans, cache)
      ans
    }
    objective <- function(par, target_index = NULL) {
      z <- evaluate(par)
      if (!z$valid) return(1e20)
      sum(z$residual^2)
    }
    initial <- evaluate(start)
    if (initial$valid && max(abs(initial$residual)) <= 1) {
      solver <- list(method = "starting values", convergence = 0L)
    } else if (length(start) == 1L) {
      solver <- .gsCPFOneParameterSolve(evaluate, objective, start, lower, upper, ctl)$solver
    } else {
      solver <- .gsCPFMultipleSolve(evaluate, objective, start, lower, upper,
                                    ctl, rev(seq_along(start)), TRUE)$solver
    }
    if (is.null(best) || max(abs(best$residual)) > 1) {
      stop(structure(list(
        message = paste("Effect calibration did not meet all tolerances.",
                        if (is.null(best)) last_error else "Closest valid effects are attached."),
        call = NULL, target_effect = target_effect,
        closest_effect = if (is.null(best)) NULL else best$achieved, solver = solver),
        class = c("gsEffectSpending_convergence_error", "gsEffectSpending_error", "error", "condition")))
    }
    solution <- best
    # Local finite-difference sensitivity; preserve the accepted solution.
    jac <- vapply(seq_along(start), function(j) {
      h <- 1e-4 * max(1, abs(solution$par[j]))
      lo <- hi <- solution$par
      lo[j] <- max(lower[j], lo[j] - h)
      hi[j] <- min(upper[j], hi[j] + h)
      a <- evaluate(lo); b <- evaluate(hi)
      if (!a$valid || !b$valid || hi[j] == lo[j]) return(rep(NA_real_, nrow(targets)))
      (b$achieved - a$achieved) / (hi[j] - lo[j])
    }, numeric(nrow(targets)))
    jac <- matrix(jac, nrow = nrow(targets))
    singular <- if (all(is.finite(jac))) svd(jac)$d else NA_real_
    rank <- if (anyNA(singular)) NA_integer_ else sum(singular > max(1e-8, max(singular) * 1e-6))
    d <- solution$design
    if (scale == "hr") { d$hr <- effect$hr1; d$hr0 <- effect$hr0; d$ratio <- effect$ratio }
    targets$achieved_effect <- solution$achieved
    targets$residual <- solution$achieved - target_effect
    replay <- .gsEffectReplay(d)
    d$effectSpending <- list(targets = targets, scale = scale, effect = effect,
      spending = decode(solution$par),
      free_parameters = setNames(lapply(groups, function(b) specs[[b]]$free(solution$par[ids[[b]]])), groups),
      information = d$n.I, information_ratio = tail(d$n.I, 1) / tail(x$n.I, 1),
      power = sum(d$upper$prob[, 2]), actual_type1 = sum(d$upper$prob[, 1]),
      effect_tol = tol, solver = solver, jacobian = jac, local_rank = rank,
      locally_identified = !is.na(rank) && rank == length(start),
      condition_number = if (anyNA(singular) || min(singular) == 0) Inf else max(singular) / min(singular),
      harm_futility_coincidence = if (d$test.type %in% c(7L, 8L))
        which(d$testHarm & d$testLower & abs(d$harm$bound - d$lower$bound) < d$tol) else integer(),
      reference = list(alpha = x$alpha, beta = x$beta, astar = x$astar, n.I = x$n.I),
      replay = replay, call = call)
    d$call <- call
    class(d) <- c("gsEffectSpending", "gsDesign")
    d
  }, gsCPFutilitySpending_error = function(e) {
    e$message <- gsub("conditional power", "effect", conditionMessage(e), fixed = TRUE)
    class(e) <- sub("^gsCPFutilitySpending", "gsEffectSpending", class(e))
    stop(e)
  })
}

.gsEffectReplay <- function(x) {
  fields <- c("k", "test.type", "alpha", "beta", "astar", "delta", "n.fix",
              "timing", "tol", "r", "endpoint", "delta1", "delta0", "overrun",
              "testUpper", "testLower", "testHarm")
  args <- x[fields]
  args$sfu <- x$upper$sf; args$sfupar <- x$upper$param
  args$sfl <- x$lower$sf; args$sflpar <- x$lower$param
  if (x$test.type %in% c(7L, 8L)) {
    args$sfharm <- x$harm$sf; args$sfharmparam <- x$harm$param
  }
  args$usTime <- x$upper$sTime; args$lsTime <- x$lower$sTime
  args
}

.gsEffectAbort <- function(message) {
  stop(structure(list(message = message, call = NULL),
                 class = c("gsEffectSpending_input_error",
                           "gsEffectSpending_error", "error", "condition")))
}

.gsEffectTargets <- function(x, target_effect, i, bound) {
  .gsCPFValidateReference(x)
  n <- length(target_effect)
  if (!is.numeric(target_effect) || is.complex(target_effect) ||
      !is.null(dim(target_effect)) || n == 0L || any(!is.finite(target_effect))) {
    .gsEffectAbort("target_effect must be a finite numeric vector.")
  }
  if (!is.numeric(i) || is.complex(i) || !is.null(dim(i)) ||
      length(i) != n || any(!is.finite(i)) || any(i < 1 | i >= x$k) ||
      any(i != as.integer(i))) {
    .gsEffectAbort("i must contain one interim analysis index per target.")
  }
  if (!is.character(bound) || !length(bound) %in% c(1L, n) ||
      anyNA(bound) || any(!bound %in% c("efficacy", "futility", "harm"))) {
    .gsEffectAbort("bound must identify efficacy, futility or harm for each target.")
  }
  bound <- rep(bound, length.out = n)
  if (anyDuplicated(paste(bound, i))) {
    .gsEffectAbort("Duplicate boundary/analysis targets are not allowed.")
  }
  if (any(bound == "harm") && !x$test.type %in% c(7L, 8L)) {
    .gsEffectAbort("The reference design has no harm boundary.")
  }
  flags <- list(efficacy = x$testUpper, futility = x$testLower, harm = x$testHarm)
  active <- vapply(seq_len(n), function(j) isTRUE(flags[[bound[j]]][i[j]]), logical(1))
  if (!all(active)) .gsEffectAbort("Every targeted boundary must be active.")
  data.frame(bound = bound, i = as.integer(i), target_effect = target_effect,
             stringsAsFactors = FALSE)
}

# Natural effects must be recomputed after each candidate's information changes.
# Ratio metadata uses log(null ratio) and log(alternative ratio), as in gsRR().
.gsEffectAtBound <- function(x, i, bound, scale = "difference", effect = list()) {
  if (identical(scale, "hr")) {
    fields <- c("information", "ratio", "hr0", "hr1")
    if (!is.list(effect) || is.null(names(effect)) || anyNA(names(effect)) ||
        anyDuplicated(names(effect)) || !setequal(names(effect), fields) ||
        !identical(effect$information, "events")) {
      .gsEffectAbort("HR metadata requires information='events', ratio, hr0 and hr1.")
    }
    positive <- function(z) is.numeric(z) && !is.complex(z) &&
      length(z) == 1L && is.finite(z) && z > 0
    if (!all(vapply(effect[c("ratio", "hr0", "hr1")], positive, logical(1))) ||
        effect$hr0 == effect$hr1) .gsEffectAbort("Invalid HR metadata.")
    psi <- effect$ratio / (1 + effect$ratio)^2
    expected <- abs(log(effect$hr1 / effect$hr0)) * sqrt(psi)
    if (length(x$delta) != 1L || !is.finite(x$delta) ||
        abs(x$delta - expected) > 1e-7 * max(1, expected)) {
      .gsEffectAbort("Reference delta is inconsistent with HR metadata on the event-count scale.")
    }
    x$hr <- effect$hr1; x$hr0 <- effect$hr0
    slots <- c(efficacy = "upper", futility = "lower", harm = "harm")
    bound <- rep(bound, length.out = length(i))
    z <- vapply(seq_along(i), function(j) x[[slots[[bound[j]]]]]$bound[i[j]], numeric(1))
    value <- gsHR(z, i, x, ratio = effect$ratio)
    if (any(!is.finite(value)) || any(value <= 0)) .gsEffectAbort("Undefined HR at boundary.")
    return(value)
  }
  if (length(scale) != 1L || is.na(scale) ||
      !scale %in% c("difference", "rr")) {
    .gsEffectAbort("Supported scales are difference, rr and hr.")
  }
  if (!is.list(effect) || length(effect) &&
      (is.null(names(effect)) || anyNA(names(effect)) || anyDuplicated(names(effect)) ||
       any(!names(effect) %in% "endpoint"))) {
    .gsEffectAbort("effect currently supports only a named endpoint component.")
  }
  endpoint <- effect$endpoint
  if (!is.null(endpoint) &&
      (!is.character(endpoint) || length(endpoint) != 1L || is.na(endpoint) ||
       !endpoint %in% c("mean_difference", "risk_difference", "risk_ratio"))) {
    .gsEffectAbort("Invalid endpoint descriptor.")
  }
  if ((!is.null(endpoint) && endpoint == "risk_ratio" && scale != "rr") ||
      (!is.null(endpoint) && endpoint != "risk_ratio" && scale != "difference")) {
    .gsEffectAbort("Endpoint descriptor and effect scale are inconsistent.")
  }
  scalar <- function(z) is.numeric(z) && length(z) == 1L && is.finite(z)
  if (!all(vapply(x[c("delta", "delta0", "delta1", "n.fix")], scalar, logical(1))) ||
      length(x[c("delta", "delta0", "delta1", "n.fix")]) != 4L ||
      x$delta == 0 || x$delta1 == x$delta0 || x$n.fix <= 1) {
    .gsEffectAbort("Natural effects require nondegenerate null/alternative metadata and a fixed sample size.")
  }
  if (any(!is.finite(x$n.I)) || any(x$n.I <= 0)) {
    .gsEffectAbort("Candidate information must be finite and positive.")
  }
  if (identical(endpoint, "risk_difference") && any(abs(c(x$delta0, x$delta1)) > 1))
    .gsEffectAbort("Risk-difference null and alternative must lie in [-1, 1].")
  if (scale == "rr" && any(!is.finite(exp(c(x$delta0, x$delta1))) |
                           exp(c(x$delta0, x$delta1)) <= 0))
    .gsEffectAbort("RR null and alternative must define finite positive ratios.")
  slots <- c(efficacy = "upper", futility = "lower", harm = "harm")
  bound <- rep(bound, length.out = length(i))
  z <- vapply(seq_along(i), function(j) x[[slots[[bound[j]]]]]$bound[i[j]], numeric(1))
  value <- if (scale == "rr") gsRR(z, i, x) else gsDelta(z, i, x)
  if (any(!is.finite(value)) || (scale == "rr" && any(value <= 0))) {
    .gsEffectAbort("Natural-scale boundary effects are undefined.")
  }
  if (identical(endpoint, "risk_difference") && any(abs(value) > 1)) {
    .gsEffectAbort("Approximate risk difference at a boundary is outside [-1, 1].")
  }
  value
}

# specifications is a named list of list(fun = spending function, param = ...).
# The reference remains unchanged; only the selected spending slots are varied.
.gsEffectDesign <- function(x, specifications) {
  if (!is.list(specifications) || !length(specifications) ||
      is.null(names(specifications)) || anyNA(names(specifications)) ||
      anyDuplicated(names(specifications)) ||
      any(!names(specifications) %in% c("efficacy", "futility", "harm"))) {
    .gsEffectAbort("Spending specifications must be uniquely named by boundary.")
  }
  .gsCPFValidateReference(x)
  if ("harm" %in% names(specifications) && !x$test.type %in% c(7L, 8L)) {
    .gsEffectAbort("The reference design has no harm boundary.")
  }
  slots <- c(efficacy = "upper", futility = "lower", harm = "harm")
  for (boundary in names(specifications)) {
    spec <- specifications[[boundary]]
    if (!is.list(spec) || !is.function(spec$fun)) {
      .gsEffectAbort("Each spending specification must contain a function named fun.")
    }
    x[[slots[[boundary]]]]$sf <- spec$fun
    x[[slots[[boundary]]]]$param <- spec$param
  }
  .gsCPFDesign(x, x$lower$sf, x$lower$param)
}
