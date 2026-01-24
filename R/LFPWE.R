# LFPWE function [sinew] ----
LFPWE <- function(alpha = .025, sided = 1, beta = .1,
                  lambdaC = log(2) / 6, hr = .5, hr0 = 1, etaC = 0, etaE = 0,
                  gamma = 1, ratio = 1, R = 18, S = NULL, T = 24, minfup = NULL,
                  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")) {
  method <- match.arg(method)
  # set up parameters
  zalpha <- -qnorm(alpha / sided)
  zbeta <- if (is.null(beta)) NULL else -qnorm(beta)
  if (is.null(minfup)) minfup <- max(0, T - sum(R))
  if (length(R) == 1) {
    R <- T - minfup
  } else if (sum(R) != T - minfup) {
    cR <- cumsum(R)
    nR <- length(R)
    if (cR[length(cR)] < T - minfup) {
      cR[length(cR)] <- T - minfup
    } else {
      cR[cR > T - minfup] <- T - minfup
      cR <- unique(cR)
    }
    if (length(cR) > 1) {
      R <- cR - c(0, cR[1:(length(cR) - 1)])
    } else {
      R <- cR
    }
    if (nR != length(R)) {
      if (is.vector(gamma)) {
        gamma <- gamma[1:length(R)]
      } else {
        gamma <- gamma[1:length(R), ]
      }
    }
  }
  ngamma <- length(R)
  if (is.null(S)) {nlambda <- 1} else {nlambda <- length(S) + 1}
  # ratio is validated in nSurv/gsSurv/gsSurvCalendar to be a single positive scalar
  Qe <- ratio / (1 + ratio) # Proportion of subjects in the experimental group
  Qc <- 1 - Qe
  # allocation of accrual by arm
  gammaC <- gamma * Qc
  gammaE <- gamma * Qe

  # For all methods, we need expected events under H1
  eDC <- eEvents(
    lambda = lambdaC, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE <- eEvents(
    lambda = lambdaC * hr, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )
  # Need expected events under control hazards for BernsteinLagakos and LF null variance
  eDC0_list <- eEvents(
    lambda = lambdaC, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE0_list <- eEvents(
    lambda = lambdaC, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )
  eDC0 <- eDC0_list$d
  eDE0 <- eDE0_list$d
  # Compute total n for each  treatment group
  nC <- sum(eDC$n)
  nE <- sum(eDE$n)
  # For a subject enrolled in  a treatment group, what is the probability
  # for each stratum that they are in that stratum and have an event?
  pC1 <- eDC$d / nC
  pE1 <- eDE$d / nE
  pC0 <- eDC0 / sum(eDC0_list$n)
  pE0 <- eDE0 / sum(eDE0_list$n)
  # Inverse-variance weighting across strata
  v1_strata <- (1 / pC1) + (1 / pE1)
  v1_strat <- 1 / sum(1 / v1_strata)
  v0_strata <- (1 / pC0) + (1 / pE0)
  v0_strat <- 1 / sum(1 / v0_strata)
  # Total event proportion under H1 (for scaling events to sample size)
  total_d1 <- sum(eDC$d + eDE$d) / sum(eDC$n + eDE$n)
  # Expected enrollment per unit accrual rate (needed for event-based methods)
  mx <- sum(eDC$n + eDE$n)
  # Initialize power_val for methods that compute power directly
  power_val <- NULL
  if (identical(method, "LachinFoulkes")) {
    # compute H0 failure rates as average of control, experimental
    # This is used for LachinFoulkes only
    lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
    # do computations
    eDC0 <- eEvents(
      lambda = lambdaC0, eta = etaC, gamma = gammaC,
      R = R, S = S, T = T, minfup = minfup
    )$d
    eDE0 <- eEvents(
      lambda = lambdaC0 * hr0, eta = etaE, gamma = gammaE,
      R = R, S = S, T = T, minfup = minfup
    )$d
    # Compute variances
    var0_lf <- 1 / sum((1 / eDC0 + 1 / eDE0)^(-1))
    var1_lf <- 1 / sum((1 / eDC$d + 1 / eDE$d)^(-1))
    delta_log <- abs(log(hr / hr0))
    if (is.null(beta)) {
      # Power calculation matching vignette formula:
      # power = pnorm(-(qnorm(1-alpha)*sqrt(var0) - |delta|)/sqrt(var1))
      # Note: variances are already computed for the given gamma (sample size)
      power_val <- pnorm(-(zalpha * sqrt(var0_lf) - delta_log) / sqrt(var1_lf))
      n <- 1  # Multiplier is 1 for power calculation
    } else {
      # Sample size calculation
      n <- ((zalpha * sqrt(var0_lf) + zbeta * sqrt(var1_lf)) / delta_log)^2
    }
  } else if (identical(method, "Schoenfeld")) {
    # Schoenfeld formula: D = (zalpha + zbeta)^2 / (Qe*(1-Qe) * (log(HR))^2)
    # Check for non-inferiority/super-superiority (hr0 must equal 1)
    if (hr0 != 1) {
      stop("Schoenfeld method only supports superiority testing (hr0 = 1)")
    }
    # For stratified: use inverse-variance weighted variance
    # Check for single vs multiple strata
    if (!is.matrix(lambdaC) || ncol(lambdaC) == 1) {
      # Single stratum: use standard formula
      var_schoen <- 1 / (Qe * (1 - Qe))
      if (is.null(beta)) {
        # Power calculation: solve for zbeta from sample size
        # D = (zalpha + zbeta)^2 * var / delta^2
        # sqrt(D)*delta = (zalpha + zbeta)*sqrt(var)
        # zbeta = sqrt(D)*delta/sqrt(var) - zalpha
        n_current <- mx  # Current sample size from input gamma
        d_current <- n_current * total_d1  # Current events
        delta_log <- abs(log(hr))
        zbeta_calc <- sqrt(d_current) * delta_log / sqrt(var_schoen) - zalpha
        power_val <- pnorm(zbeta_calc)
        n <- 1  # Multiplier is 1 for power calculation
      } else {
        d_req <- (zalpha + zbeta)^2 * var_schoen / (log(hr)^2)
        n_sample <- d_req / total_d1
        n <- n_sample / mx
      }
    } else {
      # Multi-stratum: use stratified variance (Schoenfeld uses same var for H0 and H1)
      # For H0 variance with ratio != 1: take total events under H1 and divide by ratio
      # Experimental gets ratio/(ratio+1) proportion, control gets 1/(ratio+1)
      total_events_H1 <- eDC$d + eDE$d
      eDC0_sch <- total_events_H1 * Qc  # Control events under H0
      eDE0_sch <- total_events_H1 * Qe  # Experimental events under H0
      # var0sch then inverse-variance weighted
      var0sch <- 1 / sum((1 / eDC0_sch + 1 / eDE0_sch)^(-1))
      # H1 variance uses actual H1 events
      var1sch <- var0sch
      delta_log <- abs(log(hr / hr0))
      if (is.null(beta)) {
        # Power calculation matching vignette formula:
        # power = pnorm(-(qnorm(1-alpha)*sqrt(var0) - |delta|)/sqrt(var1))
        # Note: variances are already computed for the given gamma (sample size)
        power_val <- pnorm(-(zalpha * sqrt(var0sch) - delta_log) / sqrt(var1sch))
        n <- 1  # Multiplier is 1 for power calculation
      } else {
        # Sample size calculation for stratified Schoenfeld
        # Use the same formula as other methods: c = ((zalpha*sqrt(var0) + zbeta*sqrt(var1)) / |delta|)^2
        # This gives the multiplier for the accrual rate (same as BernsteinLagakos)
        c_mult <- ((zalpha * sqrt(var0sch) + zbeta * sqrt(var1sch)) / delta_log)^2
        n <- c_mult
      }
    }
  } else if (identical(method, "Freedman")) {
    # Freedman formula with contrast delta
    # Check for stratified populations
    if (is.matrix(lambdaC) && ncol(lambdaC) > 1) {
      stop("Stratified method not available for Freedman method")
    }
    # Check for non-inferiority/super-superiority (hr0 must equal 1)
    if (hr0 != 1) {
      stop("Freedman method only supports superiority testing (hr0 = 1)")
    }
    # Freedman uses control:experimental allocation ratio; convert to exp/control
    # Equivalent to D = (zalpha + zbeta)^2 * ratio * (hr + 1/ratio)^2 / (hr - 1)^2
    delta <- (hr - 1) / (hr + 1 / ratio)
    if (is.null(beta)) {
      # Power calculation: solve for zbeta from current expected events
      # D = ((zalpha + zbeta)^2 * ratio) / delta^2
      d_current <- mx * total_d1
      zbeta_calc <- sqrt(d_current / ratio) * abs(delta) - zalpha
      power_val <- pnorm(zbeta_calc)
      n <- 1
    } else {
      d_req <- ((zalpha + zbeta) / delta)^2 * ratio
      # scale to sample size, then convert to accrual rate multiplier
      n_sample <- d_req / total_d1
      n <- n_sample / mx
    }
  } else if (identical(method, "BernsteinLagakos")) {
    # BernsteinLagakos: 
    # Variance computations use 1/c_events + 1/e_events per stratum.
    # Both H1 and H0 variances use input control event rates for  1/c_events.
    # For H1 variance we compute 1/e_events using the input failure rates 
    # times the input hr; for H0 variance we set experimental rate to control
    # when computing e_events.
    # Both H0 and H1 are inverse-variance weighted across strata
    # Compute eDE0 for BernsteinLagakos H0 variance
    # For superiority (hr0 = 1): use lambdaC for experimental group
    # For non-inferiority/super-superiority (hr0 != 1): use lambdaC * hr0
    if (hr0 == 1) {
      # Superiority: experimental rate = control rate
      eDE0_bl_list <- eEvents(
        lambda = lambdaC, eta = etaE, gamma = gammaE,
        R = R, S = S, T = T, minfup = minfup
      )
    } else {
      # Non-inferiority/super-superiority: experimental rate = control * hr0
      eDE0_bl_list <- eEvents(
        lambda = lambdaC * hr0, eta = etaE, gamma = gammaE,
        R = R, S = S, T = T, minfup = minfup
      )
    }
    eDE0_bl <- eDE0_bl_list$d
    # H1 variance per stratum: 1/c_events + 1/e_events (using H1 events)
    var1_bl_strata <- 1 / eDC$d + 1 / eDE$d
    var1_bl <- 1 / sum(1 / var1_bl_strata)  # Inverse-variance weighted
    # H0 variance per stratum: 1/c_events + 1/e_events (using H0 events)
    # where experimental uses control rates (superiority) or control * hr0
    var0_bl_strata <- 1 / eDC0 + 1 / eDE0_bl
    var0_bl <- 1 / sum(1 / var0_bl_strata)  # Inverse-variance weighted
    delta_log <- abs(log(hr / hr0))
    power_val <- NULL
    if (is.null(beta)) {
      # Power calculation matching vignette formula:
      # power = pnorm(-(qnorm(1-alpha)*sqrt(var0) - |delta|)/sqrt(var1))
      power_val <- pnorm(
        -(zalpha * sqrt(var0_bl) - delta_log) / sqrt(var1_bl)
      )
      # For power calculation, n is the multiplier (1 = no chg from input gamma)
      n <- 1
    } else {
      # n calculation: c = ((zalpha*sqrt(var0) + zbeta*sqrt(var1)) / |delta|)^2
      # This gives the multiplier for the accrual rate
      c_mult <- ((zalpha * sqrt(var0_bl) + zbeta * sqrt(var1_bl)) /
        delta_log)^2
      n <- c_mult
    }
  } else {
    stop("Unsupported method")
  }

  # Determine variable type based on what was computed
  if (is.null(beta)) {
    variable_type <- "Power"
  } else {
    variable_type <- "Accrual rate"
  }
  
  rval <- list(
    alpha = alpha, sided = sided, beta = beta, 
    power = if (is.null(power_val)) 1 - beta else power_val,
    lambdaC = lambdaC, etaC = etaC, etaE = etaE, gamma = n * gamma,
    ratio = ratio, R = R, S = S, T = T, minfup = minfup,
    hr = hr, hr0 = hr0, n = n * mx, d = n * sum(eDC$d + eDE$d),
    eDC = eDC$d * n, eDE = eDE$d * n, eDC0 = eDC0 * n, eDE0 = eDE0 * n,
    eNC = eDC$n * n, eNE = eDE$n * n, variable = variable_type
  )
  class(rval) <- "nSurv"
  return(rval)
}
