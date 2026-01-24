# print.nSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# print.nSurv function [sinew] ----
print.nSurv <- function(x, digits = 3, show_strata = TRUE, ...) {
  if (!inherits(x, "nSurv")) {
    stop("Primary argument must have class nSurv")
  }

  # helpers to preserve input values and compact values
  input_value <- function(nm) {
    if (!is.null(x$inputs) && !is.null(x$inputs[[nm]])) {
      return(compact(x$inputs[[nm]]))
    }
    if (!is.null(x$call) && !is.null(x$call[[nm]])) {
      return(paste(deparse(x$call[[nm]]), collapse = ""))
    }
    nm
  }
  compact <- function(v) {
    if (is.null(v)) return("NULL")
    if (length(v) <= 3) return(paste(round(v, digits), collapse = ", "))
    paste0(
      paste(round(v[1:3], digits), collapse = ", "),
      " ... (len=", length(v), ")"
    )
  }

  cat(
    "nSurv fixed-design summary ",
    "(method=", x$method, "; target=", x$variable, ")\n",
    sep = ""
  )
  power_pct <- if (!is.null(x$beta)) {
    (1 - x$beta) * 100
  } else {
    x$power * 100
  }
  cat(
    sprintf(
      "HR=%.3f vs HR0=%.3f | alpha=%.3f (sided=%d) | power=%.1f%%\n",
      x$hr, x$hr0, x$alpha, x$sided, power_pct
    )
  )
  cat(
    sprintf(
      paste(
        "N=%.1f subjects | D=%.1f events |",
        "T=%.1f study duration |",
        "accrual=%.1f Accrual duration |",
        "minfup=%.1f minimum follow-up |",
        "ratio=%s randomization ratio (experimental/control)\n"
      ),
      x$n, x$d, x$T, x$T - x$minfup, x$minfup,
      paste(x$ratio, collapse = "/")
    )
  )

  if (show_strata && !is.null(x$eDC) && length(x$eDC) > 1) {
    cat("\nExpected events by stratum (H1):\n")
    evt <- data.frame(
      control = x$eDC,
      experimental = x$eDE,
      total = x$eDC + x$eDE
    )
    print(round(evt, digits))
  }

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
    input = vapply(items, input_value, character(1)),
    stringsAsFactors = FALSE
  )
  print(tab, row.names = FALSE)

  invisible(x)
}
