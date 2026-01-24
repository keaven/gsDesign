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
    if (is.null(v)) return("NULL")
    # Convert matrix to vector for display (row-wise)
    if (is.matrix(v)) {
      v <- as.vector(t(v))
    }
    if (length(v) <= 3) return(paste(round(v, digits), collapse = ", "))
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
    "3" = "Two-sided asymmetric (efficacy and futility)",
    "4" = "Two-sided asymmetric with non-binding futility",
    "5" = "Two-sided asymmetric with binding futility",
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
    gsDesign:::print.gsDesign(x)
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
