# Shared survival adapters for the spending-calibration front ends.
.gsSpendingClass <- function(x, calibration) {
  c(calibration, intersect(c("gsSurvPower", "gsSurv", "gsDesign"), class(x)))
}

.gsSpendingReference <- function(x) {
  if (inherits(x, "gsSurv") && is.null(x$spendingSurvivalConstructor)) {
    constructor <- if (length(x$call)) x$call[[1L]] else NULL
    is_calendar <- identical(constructor, gsSurvCalendar) ||
      identical(constructor, quote(gsSurvCalendar)) ||
      identical(constructor, quote(gsDesign::gsSurvCalendar))
    x$spendingSurvivalConstructor <- if (is_calendar) "gsSurvCalendar" else "gsSurv"
  }
  if (inherits(x, "gsSurvPower")) {
    # Power objects may evaluate a different HR from the design alternative.
    # Calibrate at the evaluated alternative and preserve its achieved power.
    if (length(x$theta) != 2L || !is.finite(x$theta[2L]) || x$theta[2L] <= 0) {
      .gsCPFAbort("Survival calibration requires a positive alternative drift.",
                  "gsCPFutilitySpending_input_error")
    }
    x$delta <- x$theta[2L]
    x$delta1 <- log(x$hr)
    x$hr1 <- x$hr
    x$n.fix <- ((stats::qnorm(x$alpha) + stats::qnorm(x$beta)) / x$delta)^2
  }
  x
}

.gsSpendingSurvival <- function(x, candidate) {
  if (!inherits(x, "gsSurv")) return(candidate)

  if (inherits(x, "gsSurvPower")) {
    # Freeze the realized calendar schedule and scale enrollment to the fitted
    # event requirement. Passing the fitted boundaries as the reference avoids
    # re-solving them with the original spending parameters or planned times.
    reference <- x
    for (nm in names(candidate)) reference[[nm]] <- candidate[[nm]]
    reference$hr1 <- reference$hr
    result <- gsSurvPower(
      x = reference,
      gamma = x$gamma * utils::tail(candidate$n.I, 1L) / utils::tail(x$n.I, 1L),
      plannedCalendarTime = x$T, hr1 = x$hr,
      spending = "information", r = x$r, tol = x$tol
    )
    return(result)
  }

  # Use resolved values, never evaluate the stored call: its symbols can have
  # gone out of scope or changed since the reference design was constructed.
  args <- list(
    k = x$k, test.type = x$test.type, alpha = x$alpha, beta = x$beta,
    astar = x$astar, timing = x$timing,
    sfu = candidate$upper$sf, sfupar = candidate$upper$param,
    sfl = candidate$lower$sf, sflpar = candidate$lower$param,
    r = x$r, tol = x$tol, lambdaC = x$lambdaC, hr = x$hr, hr0 = x$hr0,
    eta = x$etaC, etaE = x$etaE, gamma = x$gamma, R = x$R, S = x$S,
    T = utils::tail(x$T, 1L), minfup = x$minfup, ratio = x$ratio,
    usTime = x$upper$sTime, lsTime = x$lower$sTime,
    testUpper = x$testUpper, testLower = x$testLower, testHarm = x$testHarm,
    method = x$method
  )
  if (x$test.type %in% c(7L, 8L)) {
    args$sfharm <- candidate$harm$sf
    args$sfharmparam <- candidate$harm$param
  }
  if (identical(x$variable, "Accrual duration")) args["T"] <- list(NULL)
  if (identical(x$variable, "Follow-up duration")) {
    args[c("T", "minfup")] <- list(NULL, NULL)
  }
  constructor <- x$spendingSurvivalConstructor
  if (identical(constructor, "gsSurvCalendar")) {
    args[c("k", "timing", "T", "usTime", "lsTime")] <- NULL
    args$calendarTime <- x$T
    args$spending <- if (isTRUE(all.equal(x$lower$sTime, x$T / max(x$T)))) {
      "calendar"
    } else "information"
    result <- do.call(gsSurvCalendar, args)
  } else {
    result <- do.call(gsSurv, args)
  }
  result$spendingSurvivalConstructor <- constructor
  result
}
