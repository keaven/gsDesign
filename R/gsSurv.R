# gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# gsSurv function [sinew] ----
gsSurv <- function(
  k = 3, test.type = 4, alpha = 0.025, sided = 1,
  beta = 0.1, astar = 0, timing = 1, sfu = sfHSD, sfupar = -4,
  sfl = sfHSD, sflpar = -2, r = 18,
  lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
  gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
  tol = .Machine$double.eps^0.25,
  usTime = NULL, lsTime = NULL,
  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
) { # KA: usTime and lsTime added 10/8/2017
  method <- match.arg(method)
  input_vals <- list(
    gamma = gamma,
    R = R,
    lambdaC = lambdaC,
    eta = eta,
    etaE = etaE,
    S = S
  )
  # Validate ratio is a single positive scalar
  if (!is.numeric(ratio) || length(ratio) != 1 || ratio <= 0) {
    stop("ratio must be a single positive scalar")
  }
  # If both gamma and R are provided (non-NULL) and T is NULL, set T to force solving for accrual rate
  # This matches gsDesign::gsSurv behavior which keeps R fixed and solves for gamma
  if (is.null(T) && !is.null(minfup) &&
    !is.null(R) && length(R) > 0 &&
    !is.null(gamma) && length(gamma) > 0) {
    T <- sum(R) + minfup
  }
  x <- nSurv(
    lambdaC = lambdaC, hr = hr, hr0 = hr0, eta = eta, etaE = etaE,
    gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
    alpha = alpha, beta = beta, sided = sided, tol = tol, method = method
  )
  y <- gsDesign(
    k = k, test.type = test.type, alpha = alpha / sided,
    beta = beta, astar = astar, n.fix = x$d, timing = timing,
    sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar, tol = tol,
    delta1 = log(hr), delta0 = log(hr0),
    usTime = usTime, lsTime = lsTime
  ) # KA: usTime and lsTime added 10/8/2017

  z <- gsnSurv(x, y$n.I[k])
  eDC <- NULL
  eDE <- NULL
  eNC <- NULL
  eNE <- NULL
  T <- NULL
  for (i in 1:(k - 1)) {
    xx <- tEventsIA(z, y$timing[i], tol)
    T <- c(T, xx$T)
    eDC <- rbind(eDC, xx$eDC)
    eDE <- rbind(eDE, xx$eDE)
    eNC <- rbind(eNC, xx$eNC)
    eNE <- rbind(eNE, xx$eNE)
  }
  y$T <- c(T, z$T)
  y$eDC <- rbind(eDC, z$eDC)
  y$eDE <- rbind(eDE, z$eDE)
  y$eNC <- rbind(eNC, z$eNC)
  y$eNE <- rbind(eNE, z$eNE)
  y$hr <- hr
  y$hr0 <- hr0
  y$R <- z$R
  y$S <- z$S
  y$minfup <- z$minfup
  y$gamma <- z$gamma
  y$ratio <- ratio
  y$lambdaC <- z$lambdaC
  y$etaC <- z$etaC
  y$etaE <- z$etaE
  y$variable <- x$variable
  y$tol <- tol
  y$method <- x$method
  y$call <- match.call()
  y$inputs <- input_vals
  class(y) <- c("gsSurv", "gsDesign")

  nameR <- nameperiod(cumsum(y$R))
  stratnames <- paste("Stratum", seq_len(ncol(y$lambdaC)))
  if (is.null(y$S)) {
    nameS <- "0-Inf"
  } else {
    nameS <- nameperiod(cumsum(c(y$S, Inf)))
  }
  rownames(y$lambdaC) <- nameS
  colnames(y$lambdaC) <- stratnames
  rownames(y$etaC) <- nameS
  colnames(y$etaC) <- stratnames
  rownames(y$etaE) <- nameS
  colnames(y$etaE) <- stratnames
  rownames(y$gamma) <- nameR
  colnames(y$gamma) <- stratnames
  return(y)
}

# gsnSurv function [sinew] ----
gsnSurv <- function(x, nEvents) {
  if (x$variable == "Accrual rate") {
    Ifct <- nEvents / x$d
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma * Ifct, ratio = x$ratio, R = x$R, S = x$S, T = x$T,
      minfup = x$minfup, hr = x$hr, hr0 = x$hr0, n = x$n * Ifct, d = nEvents,
      eDC = x$eDC * Ifct, eDE = x$eDE * Ifct, eDC0 = x$eDC0 * Ifct,
      eDE0 = x$eDE0 * Ifct, eNC = x$eNC * Ifct, eNE = x$eNE * Ifct,
      variable = x$variable
    )
  } else if (x$variable == "Accrual duration") {
    y <- KT(
      n1Target = nEvents, minfup = x$minfup, lambdaC = x$lambdaC, etaC = x$etaC,
      etaE = x$etaE, R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0, gamma = x$gamma,
      ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = y$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0, n = y$n, d = nEvents,
      eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  } else {
    y <- KT(
      n1Target = nEvents, minfup = NULL, lambdaC = x$lambdaC, etaC = x$etaC,
      etaE = x$etaE, R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0, gamma = x$gamma,
      ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = x$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0, n = y$n, d = nEvents,
      eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  }
  class(rval) <- "gsSize"
  return(rval)
}

# print.gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# print.gsSurv function [sinew] ----
print.gsSurv <- function(x, digits = 3, show_gsDesign = FALSE, show_strata = TRUE, ...) {
  if (!inherits(x, "gsSurv")) {
    stop("Primary argument must have class gsSurv")
  }

  # Helper for compact display (matching print.nSurv style)
  compact <- function(v) {
    if (is.null(v)) {
      return("NULL")
    }
    # Convert matrix to vector for display (row-wise)
    if (is.matrix(v)) {
      v <- as.vector(t(v))
    }
    if (length(v) <= 3) {
      return(paste(round(v, digits), collapse = ", "))
    }
    paste0(
      paste(round(v[1:3], digits), collapse = ", "),
      " ... (len=", length(v), ")"
    )
  }

  # Helper to preserve input values
  input_value <- function(nm) {
    if (!is.null(x$inputs) && !is.null(x$inputs[[nm]])) {
      return(compact(x$inputs[[nm]]))
    }
    if (!is.null(x$call) && !is.null(x$call[[nm]])) {
      return(paste(deparse(x$call[[nm]]), collapse = ""))
    }
    nm
  }

  # Test type description
  test_type_desc <- switch(as.character(x$test.type),
    "1" = "One-sided (efficacy only)",
    "2" = "Two-sided symmetric",
    "3" = "Two-sided asymmetric with binding futility",
    "4" = "Two-sided asymmetric with non-binding futility",
    "5" = "Two-sided asymmetric with binding harm bound",
    "6" = "Two-sided asymmetric with non-binding harm bound",
    paste("Test type", x$test.type)
  )

  # Summary header
  cat(
    "Group sequential design ",
    "(method=", x$method, "; k=", x$k, " analyses; ", test_type_desc, ")\n",
    sep = ""
  )
  cat(
    sprintf(
      "HR=%.3f vs HR0=%.3f | alpha=%.3f (sided=%d) | power=%.1f%%\n",
      x$hr, x$hr0, x$alpha, x$sided, (1 - x$beta) * 100
    )
  )

  # Get final analysis values
  final_n <- sum((x$eNC + x$eNE)[x$k, ])
  final_d <- sum((x$eDC + x$eDE)[x$k, ])
  final_T <- x$T[x$k]
  accrual_dur <- if (!is.null(x$R) && length(x$R) > 0) {
    sum(x$R)
  } else {
    final_T - x$minfup
  }

  cat(
    sprintf(
      paste(
        "N=%.1f subjects | D=%.1f events |",
        "T=%.1f study duration |",
        "accrual=%.1f Accrual duration |",
        "minfup=%.1f minimum follow-up |",
        "ratio=%s randomization ratio (experimental/control)\n"
      ),
      final_n, final_d, final_T, accrual_dur, x$minfup,
      paste(x$ratio, collapse = "/")
    )
  )

  # Spending function summary (extracted from summary())
  summ_text <- summary(x)
  # Extract spending function sentences
  spending_parts <- unlist(strsplit(summ_text, "\\."))
  spending_parts <- grep("spending function", spending_parts, ignore.case = TRUE, value = TRUE)
  if (length(spending_parts) > 0) {
    cat("\nSpending functions:\n")
    for (part in spending_parts) {
      cat("  ", trimws(part), ".\n", sep = "")
    }
  }

  # Analysis summary table using gsBoundSummary
  cat("\nAnalysis summary:\n")
  print(gsDesign::gsBoundSummary(x))

  # Optional: show gsDesign details
  if (show_gsDesign) {
    cat("\n--- gsDesign details ---\n")
    print.gsDesign(x)
  }

  # Key inputs table (matching print.nSurv style)
  cat("\nKey inputs (names preserved):\n")
  items <- c("gamma", "R", "lambdaC", "eta", "etaE", "S")
  desc_map <- list(
    gamma = "Accrual rate(s)",
    R = "Accrual rate duration(s)",
    lambdaC = "Control hazard rate(s)",
    eta = "Control dropout rate(s)",
    etaE = "Experimental dropout rate(s)",
    S = "Event and dropout rate duration(s)"
  )
  tab <- data.frame(
    desc = unlist(desc_map[items], use.names = FALSE),
    item = items,
    value = vapply(
      items,
      function(nm) {
        switch(nm,
          lambdaC = compact(x$lambdaC),
          gamma = compact(x$gamma),
          eta = compact(x$etaC),
          etaE = compact(x$etaE),
          R = compact(x$R),
          S = compact(x$S),
          compact(NULL)
        )
      },
      character(1)
    ),
    input = vapply(items, function(nm) {
      # For "eta", check both "eta" and "etaC" in the call
      if (nm == "eta") {
        if (!is.null(x$inputs) && !is.null(x$inputs$eta)) {
          return(compact(x$inputs$eta))
        }
        if (!is.null(x$call) && "eta" %in% names(x$call)) {
          return(input_value("eta"))
        } else if (!is.null(x$call) && "etaC" %in% names(x$call)) {
          return(input_value("etaC"))
        } else {
          return("eta")
        }
      }
      input_value(nm)
    }, character(1)),
    stringsAsFactors = FALSE
  )
  print(tab, row.names = FALSE)

  # Optional: show strata details
  if (show_strata && !is.null(x$eDC) && ncol(x$eDC) > 1) {
    cat("\nExpected events by stratum (H1) at final analysis:\n")
    evt <- data.frame(
      stratum = paste("Stratum", seq_len(ncol(x$eDC))),
      control = round(x$eDC[x$k, ], digits),
      experimental = round(x$eDE[x$k, ], digits),
      total = round(x$eDC[x$k, ] + x$eDE[x$k, ], digits)
    )
    print(evt, row.names = FALSE)
  }

  invisible(x)
}
