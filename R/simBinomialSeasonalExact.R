#' Simulate exact-binomial seasonal monitoring scenarios
#'
#' @description
#' Simulate seasonal rare-event trials monitored with exact-binomial efficacy
#' bounds derived from a `gsSurv` design. This helper supports fixed enrollment
#' and a simple blinded information-adaptive enrollment rule while keeping the
#' spending framework fixed through the original `gsSurv` design object.
#'
#' The function summarizes empirical rejection rates (Type I error or power),
#' futility stopping rates (binding interpretation), Monte Carlo standard
#' errors, average final events, average total enrollment, and average number
#' of informative looks.
#'
#' @param gsD A `gsSurv` object with `test.type` 1 or 4.
#' @param ve Numeric vector of vaccine efficacy (or prevention efficacy)
#'   scenarios to simulate. Each value must be finite and less than 1.
#'   `ve = 0` corresponds to equal event rates (superiority null); `ve < 0`
#'   corresponds to experimental-arm event rates above control (non-inferiority
#'   margin or harmful scenarios).
#' @param nsim Integer scalar or vector giving the number of simulations per
#'   element of `ve`.
#' @param control_event_rate Numeric scalar or vector with control seasonal
#'   event probabilities corresponding to `ve`.
#' @param season_length Numeric scalar > 0 giving season duration in years.
#' @param dropout_rate Seasonal dropout probability in `[0, 1)`.
#' @param planned_counts Optional increasing integer vector of planned
#'   cumulative events at analyses. If `NULL`, these are derived from
#'   `timing * toInteger(gsD)$n.I[k]`.
#' @param timing Optional increasing cumulative spending-time vector ending at 1
#'   used to derive `planned_counts` when `planned_counts = NULL`.
#' @param enroll_control_per_look Optional control-arm enrollment by look
#'   (scalar or length `k` integer vector). If both enrollment vectors are
#'   `NULL`, defaults are derived from the seasonal accrual pattern in `gsD`.
#' @param enroll_experimental_per_look Optional experimental-arm enrollment by
#'   look (scalar or length `k` integer vector). If `NULL` and
#'   `enroll_control_per_look` is supplied, this is set using `gsD$ratio`.
#' @param adaptive Logical vector specifying whether to simulate fixed and/or
#'   adaptive enrollment scenarios.
#' @param adapt_looks Integer vector of look indices after which adaptation can
#'   be applied (default: all interim looks).
#' @param max_multiplier Maximum multiplicative enrollment increase at a look
#'   when adaptation is enabled.
#' @param usTime Optional upper spending-time override passed to
#'   [toBinomialExact()]. If `NULL`, spending time defaults to
#'   `1 / k, 2 / k, ..., 1`.
#' @param lsTime Optional lower spending-time override for `test.type = 4`.
#'   If `NULL`, this defaults to `usTime`.
#' @param final_full_spending Logical scalar. If `TRUE`, force full alpha
#'   spending at the final analysis even when the final observed total event
#'   count is below planned final events.
#' @param seed Optional integer seed for reproducibility.
#' @param return_trials Logical. If `TRUE`, return trial-level simulation
#'   outcomes.
#'
#' @return A list with:
#' \describe{
#'   \item{`summary`}{Data frame with scenario-level summaries.}
#'   \item{`planned`}{List with planned counts, exact design object, and
#'     planned/calibrated enrollment by look.}
#'   \item{`inputs`}{List of simulation inputs used.}
#'   \item{`trials`}{Optional trial-level data frame (`NULL` unless
#'     `return_trials = TRUE`).}
#' }
#'
#' @seealso [toBinomialExact()], [repeatedPValueBinomialExact()],
#'   [sequentialPValueBinomialExact()]
#'
#' @examples
#' x <- gsSurv(
#'   k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(1 / 3, 2 / 3),
#'   sfu = sfHSD, sfupar = 1, sfl = sfHSD, sflpar = -2,
#'   lambdaC = -log(1 - 0.003) / 0.5,
#'   hr = 0.2, hr0 = 0.7, eta = -log(1 - 0.1) / 0.5,
#'   gamma = c(1, 0, 1, 0, 1, 0), R = c(2, 10, 2, 10, 2, 10),
#'   T = 42, minfup = 6, ratio = 3
#' ) |> toInteger()
#'
#' simBinomialSeasonalExact(
#'   gsD = x,
#'   ve = c(0.3, 0.8),
#'   nsim = c(50, 50),
#'   control_event_rate = c(0.003, 0.003),
#'   seed = 123
#' )$summary
#' @export
simBinomialSeasonalExact <- function(
    gsD,
    ve = c(0.3, 0.8),
    nsim = c(600, 600),
    control_event_rate = c(0.003, 0.003),
    season_length = 0.5,
    dropout_rate = 0.1,
    planned_counts = NULL,
    timing = NULL,
    enroll_control_per_look = NULL,
    enroll_experimental_per_look = NULL,
    adaptive = c(FALSE, TRUE),
    adapt_looks = NULL,
    max_multiplier = 2,
    usTime = NULL,
    lsTime = NULL,
    final_full_spending = FALSE,
    seed = NULL,
    return_trials = FALSE) {
  if (!inherits(gsD, "gsSurv")) {
    stop("gsD must be an object of class gsSurv", call. = FALSE)
  }
  if (!(gsD$test.type %in% c(1, 4))) {
    stop("gsD$test.type must be 1 or 4", call. = FALSE)
  }
  if (!is.numeric(ve) || length(ve) < 1 || any(!is.finite(ve)) || any(ve >= 1)) {
    stop("ve must be a numeric vector with finite values less than 1", call. = FALSE)
  }
  if (!is.numeric(season_length) || length(season_length) != 1 || !is.finite(season_length) || season_length <= 0) {
    stop("season_length must be a positive scalar", call. = FALSE)
  }
  if (!is.numeric(dropout_rate) || length(dropout_rate) != 1 || !is.finite(dropout_rate) ||
      dropout_rate < 0 || dropout_rate >= 1) {
    stop("dropout_rate must be a scalar in [0, 1)", call. = FALSE)
  }
  if (!is.numeric(max_multiplier) || length(max_multiplier) != 1 || !is.finite(max_multiplier) || max_multiplier < 1) {
    stop("max_multiplier must be a scalar >= 1", call. = FALSE)
  }
  if (gsD$test.type == 1 && !is.null(lsTime)) {
    stop("lsTime can only be specified for test.type = 4", call. = FALSE)
  }
  if (!is.logical(final_full_spending) || length(final_full_spending) != 1 || is.na(final_full_spending)) {
    stop("final_full_spending must be TRUE or FALSE", call. = FALSE)
  }
  if (!is.logical(return_trials) || length(return_trials) != 1) {
    stop("return_trials must be TRUE or FALSE", call. = FALSE)
  }
  if (!is.null(seed)) {
    if (!is.numeric(seed) || length(seed) != 1 || !is.finite(seed) || seed != floor(seed)) {
      stop("seed must be NULL or a finite integer scalar", call. = FALSE)
    }
    set.seed(as.integer(seed))
  }

  n_scen <- length(ve)
  if (length(nsim) == 1) nsim <- rep(nsim, n_scen)
  if (!is.numeric(nsim) || length(nsim) != n_scen || any(!is.finite(nsim)) || any(nsim < 1) || any(nsim != floor(nsim))) {
    stop("nsim must be an integer scalar or integer vector with one value per ve scenario", call. = FALSE)
  }
  nsim <- as.integer(nsim)

  if (length(control_event_rate) == 1) control_event_rate <- rep(control_event_rate, n_scen)
  if (!is.numeric(control_event_rate) || length(control_event_rate) != n_scen ||
      any(!is.finite(control_event_rate)) || any(control_event_rate <= 0) || any(control_event_rate >= 1)) {
    stop("control_event_rate must be a scalar or vector in (0, 1) with one value per ve scenario", call. = FALSE)
  }
  experimental_event_rate <- control_event_rate * (1 - ve)
  if (any(experimental_event_rate < 0) || any(experimental_event_rate >= 1)) {
    stop("ve and control_event_rate imply experimental event rates outside [0, 1)", call. = FALSE)
  }

  if (!is.logical(adaptive) || length(adaptive) < 1 || any(is.na(adaptive))) {
    stop("adaptive must be a logical vector with at least one value", call. = FALSE)
  }
  adaptive <- unique(adaptive)

  ratio <- gsD$ratio
  if (!is.numeric(ratio) || length(ratio) != 1 || !is.finite(ratio) || ratio <= 0) {
    stop("gsD$ratio must be a positive scalar for simulation", call. = FALSE)
  }

  gsD_int <- if (max(round(gsD$n.I) != gsD$n.I)) toInteger(gsD) else gsD
  if (is.null(planned_counts)) {
    if (is.null(timing)) {
      timing <- gsD_int$timing
    }
    if (!is.numeric(timing) || length(timing) < 2 || any(!is.finite(timing)) || any(timing <= 0) ||
        any(diff(timing) <= 0) || abs(max(timing) - 1) > 1e-8) {
      stop("timing must be increasing, positive, length >= 2, and end at 1", call. = FALSE)
    }
    planned_final_events <- as.integer(round(gsD_int$n.I[gsD_int$k]))
    planned_counts <- as.integer(round(planned_final_events * timing))
    planned_counts[length(planned_counts)] <- planned_final_events
    for (j in seq_along(planned_counts)[-1]) {
      planned_counts[j] <- max(planned_counts[j], planned_counts[j - 1] + 1L)
    }
  } else {
    if (!is.numeric(planned_counts) || any(!is.finite(planned_counts)) || any(planned_counts != floor(planned_counts))) {
      stop("planned_counts must be a numeric vector of increasing positive integers", call. = FALSE)
    }
    planned_counts <- as.integer(planned_counts)
    if (length(planned_counts) < 2 || any(planned_counts <= 0) || any(diff(planned_counts) <= 0)) {
      stop("planned_counts must be an increasing vector of positive integers with length >= 2", call. = FALSE)
    }
    timing <- planned_counts / max(planned_counts)
  }
  k <- length(planned_counts)
  if (is.null(adapt_looks)) {
    adapt_looks <- seq_len(max(0, k - 1))
  }
  if (!is.numeric(adapt_looks) || any(!is.finite(adapt_looks)) || any(adapt_looks != floor(adapt_looks)) ||
      any(adapt_looks < 1) || any(adapt_looks >= k)) {
    stop("adapt_looks must contain integers between 1 and k-1", call. = FALSE)
  }
  adapt_looks <- sort(unique(as.integer(adapt_looks)))

  planned_final_events <- max(planned_counts)
  default_spending <- seq_len(k) / k
  usTime_resolved <- normalizeSpendingTimeVector(usTime, default_spending, k, "usTime")
  lsTime_resolved <- normalizeSpendingTimeVector(lsTime, usTime_resolved, k, "lsTime")
  if (isTRUE(final_full_spending)) {
    usTime_resolved[k] <- 1
    lsTime_resolved[k] <- 1
  }
  if (sum(usTime_resolved >= 1) > 1) {
    stop("usTime must have at most 1 value >= 1", call. = FALSE)
  }
  if (gsD$test.type == 4 && sum(lsTime_resolved >= 1) > 1) {
    stop("lsTime must have at most 1 value >= 1", call. = FALSE)
  }

  design_exact <- do.call(
    toBinomialExact,
    list(
      x = gsD_int,
      observedEvents = planned_counts,
      usTime = usTime_resolved,
      lsTime = if (gsD$test.type == 4) lsTime_resolved else NULL,
      maxSpend = final_full_spending
    )
  )

  missing_control_enrollment <- is.null(enroll_control_per_look)
  missing_experimental_enrollment <- is.null(enroll_experimental_per_look)
  if (missing_control_enrollment && missing_experimental_enrollment) {
    planned_enrollment <- plannedSeasonalEnrollment(gsD_int, k, ratio)
    if (is.null(planned_enrollment)) {
      planned_enrollment <- calibratedSeasonalEnrollment(
        ve = ve,
        control_event_rate = control_event_rate,
        season_length = season_length,
        dropout_rate = dropout_rate,
        planned_final_events = planned_final_events,
        ratio = ratio,
        k = k
      )
    }
    enroll_control_per_look <- planned_enrollment$control
    enroll_experimental_per_look <- planned_enrollment$experimental
  } else {
    if (!missing_control_enrollment) {
      enroll_control_per_look <- normalizeEnrollmentVector(enroll_control_per_look, k, "enroll_control_per_look")
    }
    if (!missing_experimental_enrollment) {
      enroll_experimental_per_look <- normalizeEnrollmentVector(enroll_experimental_per_look, k, "enroll_experimental_per_look")
    }
    if (missing_control_enrollment) {
      enroll_control_per_look <- as.integer(ceiling(enroll_experimental_per_look / ratio))
    }
    if (missing_experimental_enrollment) {
      enroll_experimental_per_look <- as.integer(ceiling(enroll_control_per_look * ratio))
    }
  }

  all_summary <- list()
  all_trials <- list()
  idx <- 1L

  for (i in seq_len(n_scen)) {
    lambda_c <- -log(1 - control_event_rate[i]) / season_length
    eta_rate <- if (dropout_rate == 0) 0 else -log(1 - dropout_rate) / season_length

    for (ad in adaptive) {
      trials <- replicate(
        nsim[i],
        simulateSeasonalExactTrial(
          gsD = gsD_int,
          ve = ve[i],
          lambda_c = lambda_c,
          eta_rate = eta_rate,
          season_length = season_length,
          planned_counts = planned_counts,
          planned_final_events = planned_final_events,
          enroll_control_base = enroll_control_per_look,
          enroll_experimental_base = enroll_experimental_per_look,
          adaptive = ad,
          adapt_looks = adapt_looks,
          max_multiplier = max_multiplier,
          usTime = usTime_resolved,
          lsTime = lsTime_resolved,
          final_full_spending = final_full_spending
        ),
        simplify = FALSE
      )

      trial_df <- data.frame(
        scenario = if (!is.null(names(ve)) && nzchar(names(ve)[i])) names(ve)[i] else paste0("Scenario", i),
        ve = unname(ve[i]),
        control_event_rate = unname(control_event_rate[i]),
        adaptive = ad,
        reject = as.logical(vapply(trials, `[[`, logical(1), "reject")),
        futility_stop = as.logical(vapply(trials, `[[`, logical(1), "futility_stop")),
        looks = as.integer(vapply(trials, `[[`, integer(1), "looks")),
        total_events = as.integer(vapply(trials, `[[`, integer(1), "total_events")),
        total_enrolled = as.numeric(vapply(trials, `[[`, numeric(1), "total_enrolled")),
        stringsAsFactors = FALSE
      )

      p <- mean(trial_df$reject)
      se <- sqrt(p * (1 - p) / nrow(trial_df))
      p_fut <- mean(trial_df$futility_stop)
      se_fut <- sqrt(p_fut * (1 - p_fut) / nrow(trial_df))
      all_summary[[idx]] <- data.frame(
        scenario = trial_df$scenario[1],
        ve = unname(ve[i]),
        control_event_rate = unname(control_event_rate[i]),
        adaptive = ad,
        nsim = nrow(trial_df),
        rejection_rate = p,
        mc_se = se,
        futility_stop_rate = p_fut,
        futility_mc_se = se_fut,
        mean_total_events = mean(trial_df$total_events),
        mean_total_enrolled = mean(trial_df$total_enrolled),
        mean_looks = mean(trial_df$looks),
        stringsAsFactors = FALSE
      )
      if (return_trials) all_trials[[idx]] <- trial_df
      idx <- idx + 1L
    }
  }

  list(
    summary = do.call(rbind, all_summary),
    planned = list(
      counts = planned_counts,
      timing = timing,
      design_exact = design_exact,
      enroll_control_per_look = enroll_control_per_look,
      enroll_experimental_per_look = enroll_experimental_per_look
    ),
    inputs = list(
      ve = ve,
      nsim = nsim,
      control_event_rate = control_event_rate,
      season_length = season_length,
      dropout_rate = dropout_rate,
      adaptive = adaptive,
      adapt_looks = adapt_looks,
      max_multiplier = max_multiplier,
      usTime = usTime_resolved,
      lsTime = if (gsD$test.type == 4) lsTime_resolved else NULL,
      final_full_spending = final_full_spending,
      seed = seed
    ),
    trials = if (return_trials) do.call(rbind, all_trials) else NULL
  )
}

simulateSeasonalExactTrial <- function(
    gsD,
    ve,
    lambda_c,
    eta_rate,
    season_length,
    planned_counts,
    planned_final_events,
    enroll_control_base,
    enroll_experimental_base,
    adaptive,
    adapt_looks,
    max_multiplier,
    usTime,
    lsTime,
    final_full_spending) {
  k <- length(planned_counts)
  probs <- seasonalBinomialProb(ve = ve, lambda_c = lambda_c, eta = eta_rate, season_length = season_length)

  enroll_c <- enroll_control_base
  enroll_e <- enroll_experimental_base
  at_risk_c <- 0L
  at_risk_e <- 0L
  cum_total <- integer(k)
  cum_exp <- integer(k)
  cum_enrolled <- integer(k)

  for (season in seq_len(k)) {
    if (adaptive && season > 1 && (season - 1) %in% adapt_looks) {
      mult <- min(max_multiplier, max(1, planned_counts[season - 1] / max(cum_total[season - 1], 1)))
      enroll_c[season] <- as.integer(ceiling(enroll_control_base[season] * mult))
      enroll_e[season] <- as.integer(ceiling(enroll_experimental_base[season] * mult))
    }

    at_risk_c <- at_risk_c + enroll_c[season]
    at_risk_e <- at_risk_e + enroll_e[season]
    cum_enrolled[season] <- sum(enroll_c[seq_len(season)] + enroll_e[seq_len(season)])

    out_c <- as.integer(stats::rmultinom(1, at_risk_c, probs$control))
    out_e <- as.integer(stats::rmultinom(1, at_risk_e, probs$experimental))

    inc_total <- out_c[1] + out_e[1]
    inc_exp <- out_e[1]
    cum_total[season] <- if (season == 1) inc_total else cum_total[season - 1] + inc_total
    cum_exp[season] <- if (season == 1) inc_exp else cum_exp[season - 1] + inc_exp

    at_risk_c <- out_c[3]
    at_risk_e <- out_e[3]
  }

  reached_final <- which(cum_total >= planned_final_events)
  looks <- if (length(reached_final) == 0) seq_len(k) else seq_len(reached_final[1])
  informative <- looks[cum_total[looks] > 0]
  if (length(informative) > 1) {
    informative <- informative[c(TRUE, diff(cum_total[informative]) > 0)]
  }
  if (length(informative) == 0) {
    last_look <- looks[length(looks)]
    return(list(
      reject = FALSE,
      futility_stop = FALSE,
      looks = 0L,
      total_events = as.integer(cum_total[last_look]),
      total_enrolled = as.numeric(cum_enrolled[last_look])
    ))
  }

  look_spending <- usTime[informative]
  look_lower_spending <- lsTime[informative]
  if (isTRUE(final_full_spending)) {
    look_spending[length(look_spending)] <- 1
    look_lower_spending[length(look_lower_spending)] <- 1
  }

  active_lower <- if (gsD$test.type == 4 && !is.null(gsD$testLower)) {
    tl <- gsD$testLower
    if (length(tl) == 1) tl <- rep(tl, k)
    as.logical(tl[informative])
  } else {
    rep(gsD$test.type == 4, length(informative))
  }

  trial_exact <- NULL
  if (length(informative) >= 2) {
    gsD_trial <- gsD
    if (gsD$test.type == 4) {
      gsD_trial$testLower <- active_lower
    }
    trial_exact <- tryCatch(do.call(
      toBinomialExact,
      list(
        x = gsD_trial,
        observedEvents = cum_total[informative],
        usTime = look_spending,
        lsTime = if (gsD$test.type == 4) look_lower_spending else NULL,
        maxSpend = FALSE
      )
    ), error = function(e) NULL)
  }
  bounds <- if (!is.null(trial_exact)) {
    trial_exact$lower$bound
  } else {
    binomialExactLowerBound(
      gsD,
      cum_total[informative],
      gsD$alpha,
      fullSpendFinal = FALSE,
      spendingTime = look_spending
    )
  }

  efficacy_cross <- which(cum_exp[informative] <= bounds)
  reject <- length(efficacy_cross) > 0
  futility_stop <- FALSE
  futility_cross <- integer(0)
  if (gsD$test.type == 4 && !is.null(trial_exact)) {
    futility_cross <- which(active_lower & (cum_exp[informative] >= trial_exact$upper$bound))
  }
  first_eff <- if (length(efficacy_cross) > 0) min(efficacy_cross) else Inf
  first_fut <- if (length(futility_cross) > 0) min(futility_cross) else Inf
  first_stop <- min(first_eff, first_fut)
  stopped_on_bound <- is.finite(first_stop)
  stop_position <- if (stopped_on_bound) first_stop else length(informative)
  stop_look <- informative[stop_position]
  futility_stop <- is.finite(first_fut) && (first_fut < first_eff)

  list(
    reject = reject,
    futility_stop = futility_stop,
    looks = as.integer(stop_position),
    total_events = as.integer(cum_total[stop_look]),
    total_enrolled = as.numeric(if (stopped_on_bound) cum_enrolled[stop_look] else cum_enrolled[looks[length(looks)]])
  )
}

seasonalBinomialProb <- function(ve, lambda_c, eta, season_length) {
  lambda_e <- lambda_c * (1 - ve)
  armProb <- function(lambda_event) {
    total <- lambda_event + eta
    if (total <= 0) {
      return(c(event = 0, dropout = 0, stay = 1))
    }
    p_event <- lambda_event / total * (1 - exp(-total * season_length))
    p_drop <- eta / total * (1 - exp(-total * season_length))
    p_stay <- exp(-total * season_length)
    c(event = p_event, dropout = p_drop, stay = p_stay)
  }
  list(control = armProb(lambda_c), experimental = armProb(lambda_e))
}

expectedEventsPerPerson <- function(p_event, p_stay, m) {
  m <- as.numeric(m)
  out <- numeric(length(m))
  pos <- m > 0
  if (!any(pos)) return(out)
  if (abs(1 - p_stay) < 1e-12) {
    out[pos] <- p_event * m[pos]
  } else {
    out[pos] <- p_event * (1 - p_stay^m[pos]) / (1 - p_stay)
  }
  out
}

plannedSeasonalEnrollment <- function(gsD, k, ratio) {
  total <- NULL
  if (!is.null(gsD$gamma) && !is.null(gsD$R)) {
    gamma <- as.matrix(gsD$gamma)
    periods <- as.numeric(gsD$R)
    if (nrow(gamma) == length(periods) && length(periods) >= k && length(periods) %% k == 0) {
      periods_per_look <- length(periods) / k
      period_enrollment <- as.numeric(rowSums(gamma)) * periods
      groups <- rep(seq_len(k), each = periods_per_look)
      total <- as.numeric(tapply(period_enrollment, groups, sum))
    }
  }
  if (is.null(total) && !is.null(gsD$eNC) && !is.null(gsD$eNE)) {
    cumulative <- rowSums(as.matrix(gsD$eNC)) + rowSums(as.matrix(gsD$eNE))
    if (length(cumulative) == k) {
      total <- c(cumulative[1], diff(cumulative))
    }
  }
  if (is.null(total) || length(total) != k || any(!is.finite(total)) || any(total <= 0)) {
    return(NULL)
  }
  total <- pmax(2L, as.integer(round(total)))
  control <- as.integer(round(total / (1 + ratio)))
  control <- pmin(pmax(control, 1L), total - 1L)
  list(
    control = control,
    experimental = as.integer(total - control)
  )
}

calibratedSeasonalEnrollment <- function(
    ve,
    control_event_rate,
    season_length,
    dropout_rate,
    planned_final_events,
    ratio,
    k) {
  ve_cal <- max(ve)
  lambda_c_cal <- -log(1 - control_event_rate[which.max(ve)]) / season_length
  eta_cal <- if (dropout_rate == 0) 0 else -log(1 - dropout_rate) / season_length
  probs_cal <- seasonalBinomialProb(ve = ve_cal, lambda_c = lambda_c_cal, eta = eta_cal, season_length = season_length)
  m <- rev(seq_len(k))
  sum_c <- sum(expectedEventsPerPerson(probs_cal$control["event"], probs_cal$control["stay"], m))
  sum_e <- sum(expectedEventsPerPerson(probs_cal$experimental["event"], probs_cal$experimental["stay"], m))
  n_c <- ceiling(planned_final_events / (sum_c + ratio * sum_e))
  control <- rep(as.integer(n_c), k)
  list(
    control = control,
    experimental = as.integer(ceiling(control * ratio))
  )
}

normalizeEnrollmentVector <- function(x, k, varname) {
  if (!is.numeric(x) || any(!is.finite(x)) || any(x != floor(x)) || any(x <= 0)) {
    stop(varname, " must be an integer scalar or length-k integer vector with values > 0", call. = FALSE)
  }
  if (length(x) == 1) x <- rep(x, k)
  if (length(x) != k) {
    stop(varname, " must have length 1 or length k", call. = FALSE)
  }
  as.integer(x)
}

normalizeSpendingTimeVector <- function(x, default, k, varname) {
  if (is.null(x)) {
    return(default)
  }
  if (!is.numeric(x) || any(!is.finite(x))) {
    stop(varname, " must be numeric", call. = FALSE)
  }
  if (!(length(x) %in% c(k - 1, k))) {
    stop(varname, " must have length k or k-1", call. = FALSE)
  }
  if (length(x) == k - 1) {
    x <- c(x, 1)
  }
  if (any(x <= 0) || any(diff(x) <= 0)) {
    stop(varname, " must be strictly increasing and positive", call. = FALSE)
  }
  as.numeric(x)
}
