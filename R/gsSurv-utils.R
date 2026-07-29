# periods function [sinew] ----
periods <- function(S, T, minfup, digits) {
  periods <- cumsum(S)
  if (length(periods) == 0) {
    periods <- max(0, T - minfup)
  } else {
    maxT <- max(0, min(T - minfup, max(periods)))
    periods <- periods[periods <= maxT]
    if (max(periods) < T - minfup) {
      periods <- c(periods, T - minfup)
    }
  }
  nper <- length(periods)
  names1 <- c(0, round(periods[1:(nper - 1)], digits))
  names <- paste("-", periods, sep = "")
  names <- paste(names1, names, sep = "")
  return(list(periods, names))
}

# nameperiod function [sinew] ----
nameperiod <- function(R, digits = 2) {
  if (length(R) == 1) {
    return(paste("0-", round(R, digits), sep = ""))
  }
  R0 <- c(0, R[1:(length(R) - 1)])
  return(paste(round(R0, digits), "-", round(R, digits), sep = ""))
}

# validate_survival_timing_inputs function [sinew] ----
validate_survival_timing_inputs <- function(R, T, minfup, call = "nSurv") {
  if (is.null(R)) {
    stop(call, ": R must be specified and cannot be NULL", call. = FALSE)
  }
  if (!is.numeric(R) || any(is.na(R)) || any(!is.finite(R)) || any(R <= 0)) {
    stop(call, ": R must be a numeric vector of positive finite values", call. = FALSE)
  }
  if (!is.null(T) &&
    (!is.numeric(T) || length(T) != 1 || is.na(T) || !is.finite(T) || T <= 0)) {
    stop(
      call, ": T must be NULL or a single positive finite numeric value",
      call. = FALSE
    )
  }
  if (!is.null(minfup) &&
    (!is.numeric(minfup) || length(minfup) != 1 ||
      is.na(minfup) || !is.finite(minfup) || minfup < 0)) {
    stop(
      call, ": minfup must be NULL or a single non-negative finite numeric value",
      call. = FALSE
    )
  }
  if (!is.null(T) && !is.null(minfup)) {
    accrual_duration <- T - minfup
    if (accrual_duration <= 0) {
      stop(call, ": T must be greater than minfup", call. = FALSE)
    }
    tolerance <- sqrt(.Machine$double.eps) * max(1, abs(accrual_duration))
    if (length(R) > 1 && sum(R) - accrual_duration > tolerance) {
      stop(
        call, ": enrollment duration from R (", signif(sum(R), 12),
        ") exceeds T - minfup (", signif(accrual_duration, 12),
        "); shorten R/gamma or increase T relative to minfup",
        call. = FALSE
      )
    }
  }
  invisible(TRUE)
}

# Construct the gsDesign portion of a single-analysis survival design without
# calling gsDesign(), whose group-sequential validation requires k >= 2.
gsSurvFixedDesignObject <- function(
    alpha,
    design_beta,
    n_fix,
    event_count,
    delta0,
    delta1,
    theta_alt,
    power,
    sfu = sfHSD,
    sfupar = -4,
    sided = 1,
    tol = .Machine$double.eps^0.25,
    r = 18) {
  z_alpha <- stats::qnorm(1 - alpha)

  if (is.character(sfu)) {
    upper <- list(
      sf = sfu, name = sfu, parname = "Delta", param = sfupar, sTime = 1
    )
    if (sfu %in% c("OF", "Pocock")) upper$param <- NULL
    class(upper) <- "spendfn"
  } else if (is.function(sfu)) {
    upper <- sfu(alpha, 1, sfupar)
    upper$sTime <- 1
  } else {
    stop("Upper spending function mis-specified")
  }
  upper$spend <- alpha
  upper$bound <- z_alpha
  upper$prob <- matrix(c(alpha, power), nrow = 1)

  delta <- (z_alpha + stats::qnorm(1 - design_beta)) / sqrt(n_fix)
  result <- list(
    k = 1L,
    test.type = 1L,
    alpha = alpha,
    sided = sided,
    beta = 1 - power,
    astar = 0,
    delta = delta,
    n.fix = n_fix,
    timing = 1,
    tol = tol,
    r = r,
    n.I = event_count,
    maxn.IPlan = event_count,
    nFixSurv = 0,
    nSurv = 0,
    endpoint = NULL,
    delta1 = delta1,
    delta0 = delta0,
    overrun = 0,
    usTime = NULL,
    lsTime = NULL,
    testUpper = TRUE,
    testLower = FALSE,
    testHarm = FALSE,
    upper = upper,
    lower = NULL,
    theta = c(0, theta_alt),
    en = rep(event_count, 2)
  )
  class(result) <- "gsDesign"
  result
}

asGsSurvFixedDesign <- function(
    x,
    sfu = sfHSD,
    sfupar = -4,
    r = 18,
    tol = .Machine$double.eps^0.25,
    call = NULL,
    inputs = NULL) {
  design <- gsSurvFixedDesignObject(
    alpha = x$alpha / x$sided,
    design_beta = x$beta,
    n_fix = x$d,
    event_count = x$d,
    delta0 = log(x$hr0),
    delta1 = log(x$hr),
    theta_alt = (stats::qnorm(1 - x$alpha / x$sided) +
      stats::qnorm(x$power)) / sqrt(x$d),
    power = x$power,
    sfu = sfu,
    sfupar = sfupar,
    sided = x$sided,
    tol = tol,
    r = r
  )

  design$T <- x$T
  design$eDC <- matrix(x$eDC, nrow = 1)
  design$eDE <- matrix(x$eDE, nrow = 1)
  design$eDC0 <- matrix(x$eDC0, nrow = 1)
  design$eDE0 <- matrix(x$eDE0, nrow = 1)
  design$eNC <- matrix(x$eNC, nrow = 1)
  design$eNE <- matrix(x$eNE, nrow = 1)
  design$hr <- x$hr
  design$hr0 <- x$hr0
  design$R <- x$R
  design$S <- x$S
  design$minfup <- x$minfup
  design$gamma <- x$gamma
  design$ratio <- x$ratio
  design$lambdaC <- x$lambdaC
  design$etaC <- x$etaC
  design$etaE <- x$etaE
  design$variable <- x$variable
  design$method <- x$method
  design$power <- x$power
  design$call <- call
  design$inputs <- inputs
  class(design) <- c("gsSurv", "gsDesign")

  design
}
