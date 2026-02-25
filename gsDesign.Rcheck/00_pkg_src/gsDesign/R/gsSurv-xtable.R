# xtable.gsSurv roxy [sinew] ----
#' @seealso
#'  \code{\link[stats]{Normal}}
#'  \code{\link[xtable]{xtable}}
#' @importFrom stats pnorm
#' @rdname nSurv
#' @export
# xtable.gsSurv function [sinew] ----
xtable.gsSurv <- function(
  x, caption = NULL, label = NULL, align = NULL, digits = NULL,
  display = NULL, auto = FALSE, footnote = NULL, fnwid = "9cm", timename = "months", ...
) {
  k <- x$k
  stat <- c(
    "Z-value", "HR", "p (1-sided)", paste("P\\{Cross\\} if HR=", x$hr0, sep = ""),
    paste("P\\{Cross\\} if HR=", x$hr, sep = "")
  )
  st <- stat
  for (i in 2:k) stat <- c(stat, st)
  an <- rep(" ", 5 * k)
  tim <- an
  enrol <- an
  fut <- an
  eff <- an
  an[5 * (0:(k - 1)) + 1] <- c(paste("IA ", as.character(1:(k - 1)), ": ",
    as.character(round(100 * x$timing[1:(k - 1)], 1)), "\\%",
    sep = ""
  ), "Final analysis")
  an[5 * (1:(k - 1)) + 1] <- paste("\\hline", an[5 * (1:(k - 1)) + 1])
  an[5 * (0:(k - 1)) + 2] <- paste("N:", ceiling(rowSums(x$eNC)) + ceiling(rowSums(x$eNE)))
  an[5 * (0:(k - 1)) + 3] <- paste("Events:", ceiling(rowSums(x$eDC + x$eDE)))
  an[5 * (0:(k - 1)) + 4] <- paste(round(x$T, 1), timename, sep = " ")
  if (x$test.type != 1) fut[5 * (0:(k - 1)) + 1] <- as.character(round(x$lower$bound, 2))
  eff[5 * (0:(k - 1)) + 1] <- as.character(round(x$upper$bound, 2))
  if (x$test.type != 1) fut[5 * (0:(k - 1)) + 2] <- as.character(round(gsHR(z = x$lower$bound, i = 1:k, x, ratio = x$ratio) * x$hr0, 2))
  eff[5 * (0:(k - 1)) + 2] <- as.character(round(gsHR(z = x$upper$bound, i = 1:k, x, ratio = x$ratio) * x$hr0, 2))
  asp <- as.character(round(stats::pnorm(-x$upper$bound), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 3] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[, 1]), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 4] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[, 2]), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 5] <- asp
  if (x$test.type != 1) {
    bsp <- as.character(round(stats::pnorm(-x$lower$bound), 4))
    bsp[bsp == "0"] <- " $< 0.0001$"
    fut[5 * (0:(k - 1)) + 3] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[, 1]), 4))
    bsp[bsp == "0"] <- "$< 0.0001$"
    fut[5 * (0:(k - 1)) + 4] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[, 2]), 4))
    bsp[bsp == "0"] <- "$< 0.0001$"
    fut[5 * (0:(k - 1)) + 5] <- bsp
  }
  neff <- length(eff)
  if (!is.null(footnote)) {
    eff[neff] <-
      paste(eff[neff], "\\\\ \\hline \\multicolumn{4}{p{", fnwid, "}}{\\footnotesize", footnote, "}")
  }
  if (x$test.type != 1) {
    xxtab <- data.frame(an, stat, fut, eff)
    colnames(xxtab) <- c("Analysis", "Value", "Futility", "Efficacy")
  } else {
    xxtab <- data.frame(an, stat, eff)
    colnames(xxtab) <- c("Analysis", "Value", "Efficacy")
  }
  return(xtable::xtable(xxtab,
    caption = caption, label = label, align = align, digits = digits,
    display = display, auto = auto, ...
  ))
}
