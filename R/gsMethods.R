# print.gsProbability roxy [sinew] ----
#' @export
#' @rdname gsProbability
#' @importFrom stats pnorm
# print.gsProbability function [sinew] ----
print.gsProbability <- function(x, ...) {
  ntxt <- "N "
  nval <- ceiling(x$n.I)
  nspace <- log10(x$n.I[x$k])
  for (i in 1:nspace)
  {
    cat(" ")
  }

  cat("            ")
  if (min(x$lower$bound) < 0) {
    cat(" ")
  }
  if (max(class(x) == "gsBinomialExact") == 1) {
    cat("Bounds")
    y <- cbind(1:x$k, nval, x$lower$bound, round(x$upper$bound, 2))
    colnames(y) <- c("Analysis", "  N", "  a", "  b")
  }
  else {
    cat("Lower bounds   Upper bounds")
    y <- cbind(
      1:x$k, nval, round(x$lower$bound, 2), round(stats::pnorm(x$lower$bound), 4),
      round(x$upper$bound, 2), round(stats::pnorm(-x$upper$bound), 4)
    )
    colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Z  ", "Nominal p")
  }
  rownames(y) <- rep(" ", x$k)
  cat("\n")
  print(y)
  cat("\nBoundary crossing probabilities and expected sample size assume\n")
  cat("any cross stops the trial\n\n")
  j <- length(x$theta)
  sump <- 1:j
  for (m in 1:j)
  {
    sump[m] <- sum(x$upper$prob[, m])
  }
  y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
  y[, x$k + 3] <- round(y[, x$k + 3], 1)
  rownames(y) <- rep(" ", j)
  colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
  cat("Upper boundary (power or Type I Error)\n")
  cat("          Analysis\n")
  print(y)

  for (m in 1:j)
  {
    sump[m] <- sum(x$lower$prob[, m])
  }

  y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
  rownames(y) <- rep(" ", j)
  colnames(y) <- c("Theta", 1:x$k, "Total")
  cat("\nLower boundary (futility or Type II Error)\n")
  cat("          Analysis\n")
  print(y)
  invisible(x)
}


# summary.gsDesign roxy [sinew] ----
#' @export
#' @rdname gsBoundSummary
# summary.gsDesign function [sinew] ----
summary.gsDesign <- function(object, information = FALSE, timeunit = "months", ...) {
  out <- NULL
  if (object$test.type == 1) {
    out <- paste(out, "One-sided group sequential design with ", sep = "")
  } else if (object$test.type == 2) {
    out <- paste(out, "Symmetric two-sided group sequential design with ", sep = "")
  } else {
    out <- paste(out, "Asymmetric two-sided group sequential design with ", sep = "")
    if (object$test.type %in% c(2, 3, 5)) {
      out <- paste(out, "binding futility bound, ", sep = "")
    } else {
      out <- paste(out, "non-binding futility bound, ", sep = "")
    }
  }
  out <- paste(out, object$k, " analyses, ", sep = "")
  if (object$nFixSurv > 0) {
    out <- paste(out, "time-to-event outcome with sample size ", ceiling(object$nSurv),
      " and ", ceiling(object$n.I[object$k]), " events required, ",
      sep = ""
    )
  } else if ("gsSurv" %in% class(object)) {
    out <- paste(out, "time-to-event outcome with sample size ",
      ifelse(object$ratio == 1, 2 * ceiling(rowSums(object$eNE))[object$k],
        (ceiling(rowSums(object$eNE)) + ceiling(rowSums(object$eNC)))[object$k]
      ),
      " and ", ceiling(object$n.I[object$k]), " events required, ",
      sep = ""
    )
  } else if (information) {
    out <- paste(out, " total information ", round(object$n.I[object$k], 2), ", ", sep = "")
  } else {
    out <- paste(out, "sample size ", ceiling(object$n.I[object$k]), ", ", sep = "")
  }
  out <- paste(out, 100 * (1 - object$beta), " percent power, ", 100 * object$alpha, " percent (1-sided) Type I error", sep = "")
  if ("gsSurv" %in% class(object)) {
    out <- paste(out, " to detect a hazard ratio of ", round(object$hr, 2), sep = "")
    if (object$hr0 != 1) out <- paste(out, " with a null hypothesis hazard ratio of ", round(object$hr0, 2), sep = "")
    out <- paste(out, ". Enrollment and total study durations are assumed to be ", round(sum(object$R), 1),
      " and ", round(max(object$T), 1), " ", timeunit, ", respectively",
      sep = ""
    )
  }
  if (object$test.type == 2) {
    out <- paste(out, ". Bounds derived using a ", sep = "")
  } else {
    out <- paste(out, ". Efficacy bounds derived using a", sep = "")
  }
  out <- paste(out, " ", summary(object$upper), ".", sep = "")
  if (object$test.type > 2) out <- paste(out, " Futility bounds derived using a ", summary(object$lower), ".", sep = "")
  return(out)
}

# print.gsDesign roxy [sinew] ----
#' @export
#' @rdname gsBoundSummary
# print.gsDesign function [sinew] ----
print.gsDesign <- function(x, ...) {
  if (x$nFixSurv > 0) {
    cat("Group sequential design sample size for time-to-event outcome\n",
      "with sample size ", x$nSurv, ". The analysis plan below shows events\n",
      "at each analysis.\n",
      sep = ""
    )
  }

  if (x$test.type == 1) {
    cat("One-sided")
  }
  else if (x$test.type == 2) {
    cat("Symmetric two-sided")
  }
  else {
    cat("Asymmetric two-sided")
  }

  cat(" group sequential design with\n")
  cat(100 * (1 - x$beta), "% power and", 100 * x$alpha, "% Type I Error.\n")
  if (x$test.type > 1) {
    if (x$test.type == 4 || x$test.type == 6) {
      cat("Upper bound spending computations assume\ntrial continues if lower bound is crossed.\n\n")
    }
    else {
      cat("Spending computations assume trial stops\nif a bound is crossed.\n\n")
    }
  }
  if (x$n.fix != 1) {
    ntxt <- "N "
    nval <- ceiling(x$n.I)
    nspace <- log10(x$n.I[x$k])
    for (i in 1:nspace)
    {
      cat(" ")
    }
    cat("            ")
  }
  else {
    ntxt <- "Ratio*"
    nval <- round(x$n.I, 3)
    cat("           Sample\n")
    cat("            Size ")
  }
  if (x$test.type > 2) {
    if (min(x$lower$bound) < 0) {
      cat(" ")
    }
    cat("  ----Lower bounds----  ----Upper bounds-----")
    y <- cbind(
      1:x$k, nval, round(x$lower$bound, 2), round(stats::pnorm(x$lower$bound), 4),
      round(x$lower$spend, 4), round(x$upper$bound, 2), round(stats::pnorm(-x$upper$bound), 4),
      round(x$upper$spend, 4)
    )
    colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend+", "Z  ", "Nominal p", "Spend++")
  }
  else {
    y <- cbind(
      1:x$k, nval, round(x$upper$bound, 2), round(stats::pnorm(-x$upper$bound), 4),
      round(x$upper$spend, 4)
    )
    colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend")
  }
  rownames(y) <- rep(" ", x$k)
  cat("\n")
  print(y)
  cat("     Total")
  if (x$n.fix != 1) {
    for (i in 1:nspace)
    {
      cat(" ")
    }
  }
  else {
    cat("     ")
  }
  cat("                  ")

  if (x$test.type > 2) {
    if (min(x$lower$bound) < 0) {
      cat(" ")
    }
    cat(format(round(sum(x$lower$spend), 4), nsmall = 4), "                ")
  }

  cat(format(round(sum(x$upper$spend), 4), nsmall = 4), "\n")

  if (x$test.type > 4) {
    cat("+ lower bound spending (under H0):\n ")
  }
  else if (x$test.type > 2) {
    cat("+ lower bound beta spending (under H1):\n ")
  }

  if (x$test.type > 2) {
    cat(summary(x$lower), ".", sep = "")
  }

  cat("\n++ alpha spending:\n ")
  cat(summary(x$upper), ".\n", sep = "")

  if (x$n.fix == 1) {
    cat("* Sample size ratio compared to fixed design with no interim\n")
  }

  cat("\nBoundary crossing probabilities and expected sample size\nassume any cross stops the trial\n\n")
  j <- length(x$theta)
  sump <- 1:j

  for (m in 1:j)
  {
    sump[m] <- sum(x$upper$prob[, m])
  }

  y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
  if (x$n.fix != 1) {
    y[, x$k + 3] <- round(y[, x$k + 3], 1)
  }
  rownames(y) <- rep(" ", j)
  colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
  cat("Upper boundary (power or Type I Error)\n")
  cat("          Analysis\n")
  print(y)
  if (x$test.type > 1) {
    for (m in 1:j)
    {
      sump[m] <- sum(x$lower$prob[, m])
    }
    y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
    rownames(y) <- rep(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total")
    cat("\nLower boundary (futility or Type II Error)\n")
    cat("          Analysis\n")
    print(y)
  }
  invisible(x)
}

# print.nSurvival roxy [sinew] ----
#' @rdname nSurvival
#' @export
# print.nSurvival function [sinew] ----
print.nSurvival <- function(x, ...) {
  if (class(x) != "nSurvival") stop("print.nSurvival: primary argument must have class nSurvival")
  cat("Fixed design, two-arm trial with time-to-event\n")
  cat("outcome (Lachin and Foulkes, 1986).\n")
  cat("Study duration (fixed):          Ts=", x$Ts, "\n", sep = "")
  cat("Accrual duration (fixed):        Tr=", x$Tr, "\n", sep = "")
  if (x$entry == "unif") {
    cat('Uniform accrual:              entry="unif"\n')
  } else {
    cat('Exponential accrual:          entry="expo"\n')
    cat("Accrual shape parameter:      gamma=", round(x$gamma, 3), "\n", sep = "")
  }
  cat("Control median:      log(2)/lambda1=", round(log(2) / x$lambda1, 1), "\n", sep = "")
  cat("Experimental median: log(2)/lambda2=", round(log(2) / x$lambda2, 1), "\n", sep = "")
  if (x$eta == 0) {
    cat("Censoring only at study end (eta=0)\n")
  } else {
    cat("Censoring median:        log(2)/eta=", round(log(2) / x$eta, 1), "\n", sep = "")
  }
  cat("Control failure rate:       lambda1=", round(x$lambda1, 3), "\n", sep = "")
  cat("Experimental failure rate:  lambda2=", round(x$lambda2, 3), "\n", sep = "")
  cat("Censoring rate:                 eta=", round(x$eta, 3), "\n", sep = "")
  cat("Power:                 100*(1-beta)=", (1 - x$beta) * 100, "%\n", sep = "")
  cat("Type I error (", x$sided, "-sided):   100*alpha=", 100 * x$alpha, "%\n", sep = "")
  if (x$ratio == 1) {
    cat("Equal randomization:          ratio=1\n")
  } else {
    cat("Randomization (Exp/Control):  ratio=", x$ratio, "\n", sep = "")
  }
  if (x$type == "rr") {
    cat("Sample size based on hazard ratio=", round(x$lambda2 / x$lambda1, 3), ' (type="rr")\n', sep = "")
  } else {
    cat("Sample size based on risk difference=", round(x$lambda1 - x$lambda2, 3), ' (type="rd")\n', sep = "")
    if (x$approx) {
      cat("Sample size based on H1 variance only:  approx=TRUE\n")
    } else {
      cat("Sample size based on H0 and H1 variance: approx=FALSE\n")
    }
  }
  cat("Sample size (computed):           n=", 2 * ceiling(x$n / 2), "\n", sep = "")
  cat("Events required (computed): nEvents=", ceiling(x$nEvents), "\n", sep = "")
  invisible(x)
}



# gsBoundSummary roxy [sinew] ----
#' @title Bound Summary and Z-transformations
#' @description  A tabular summary of a group sequential design's bounds and their properties
#' are often useful. The 'vintage' \code{print.gsDesign()} function provides a
#' complete but minimally formatted summary of a group sequential design
#' derived by \code{gsDesign()}. A brief description of the overall design can
#' also be useful (\code{summary.gsDesign()}.  A tabular summary of boundary
#' characteristics oriented only towards LaTeX output is produced by
#' \code{\link{xtable.gsSurv}}. More flexibility is provided by
#' \code{gsBoundSummary()} which produces a tabular summary of a
#' user-specifiable set of package-provided boundary properties in a data
#' frame.  This can also be used to along with functions such as
#' \code{\link{print.data.frame}()}, \code{\link{write.table}()},
#' \code{\link{write.csv}()}, \code{\link{write.csv2}()} or, from the RTF
#' package, \code{addTable.RTF()} (from the rtf package) to produce console or
#' R Markdown output or output to a variety of file types. \code{xprint()} is
#' provided for LaTeX output by setting default options for
#' \code{\link{print.xtable}()} when producing tables summarizing design
#' bounds.
#'
#' Individual transformation of z-value test statistics for interim and final
#' analyses are obtained from \code{gsBValue()}, \code{gsDelta()},
#' \code{gsHR()} and \code{gsCPz()} for B-values, approximate treatment effect
#' (see details), approximate hazard ratio and conditional power, respectively.
#'
#' The \code{print.gsDesign} function is intended to provide an easier output
#' to review than is available from a simple list of all the output components.
#' The \code{gsBoundSummary} function is intended to provide a summary of
#' boundary characteristics that is often useful for evaluating boundary
#' selection; this outputs an extension of the \code{data.frame} class that
#' sets up default printing without row names using
#' \code{print.gsBoundSummary}. \code{summary.gsDesign}, on the other hand,
#' provides a summary of the overall design at a higher level; this provides
#' characteristics not included in the \code{gsBoundSummary} summary and no
#' detail concerning interim analysis bounds.
#'
#' In brief, the computed descriptions of group sequential design bounds are as
#' follows: \code{Z:} Standardized normal test statistic at design bound.
#'
#' \code{p (1-sided):} 1-sided p-value for \code{Z}. This will be computed as
#' the probability of a greater EXCEPT for lower bound when a 2-sided design is
#' being summarized.
#'
#' \code{delta at bound:} Approximate value of the natural parameter at the
#' bound. The approximate standardized effect size at the bound is generally
#' computed as \code{Z/sqrt(n)}. Calling this \code{theta}, this is translated
#' to the \code{delta} using the values \code{delta0} and \code{delta1} from
#' the input \code{x} by the formula \code{delta0 +
#' (delta1-delta0)/theta1*theta} where \code{theta1} is the alternate
#' hypothesis value of the standardized parameter. Note that this value will be
#' exponentiated in the case of relative risks, hazard ratios or when the user
#' specifies \code{logdelta=TRUE}. In the case of hazard ratios, the value is
#' computed instead by \code{gsHR()} to be consistent with
#' \code{plot.gsDesign()}. Similarly, the value is computed by \code{gsRR()}
#' when the relative risk is the natural parameter.
#'
#' \code{Spending: }Incremental error spending at each given analysis. For
#' asymmetric designs, futility bound will have beta-spending summarized.
#' Efficacy bound always has alpha-spending summarized.
#'
#' \code{B-value: }\code{sqrt(t)*Z} where \code{t} is the proportion of
#' information at the analysis divided by the final analysis planned
#' information. The expected value for B-values is directly proportional to
#' \code{t}.
#'
#' \code{CP: }Conditional power under the estimated treatment difference
#' assuming the interim Z-statistic is at the study bound
#'
#' \code{CP H1: }Conditional power under the alternate hypothesis treatment
#' effect assuming the interim test statistic is at the study bound.
#'
#' \code{PP: }Predictive power assuming the interim test statistic is at the
#' study bound and the input prior distribution for the standardized effect
#' size. This is the conditional power averaged across the posterior
#' distribution for the treatment effect given the interim test statistic
#' value. \code{P{Cross if delta=xx}: }For each of the parameter values in
#' \code{x}, the probability of crossing either bound given that treatment
#' effect is computed. This value is cumulative for each bound. For example,
#' the probability of crossing the efficacy bound at or before the analysis of
#' interest.
#'
#' @param x An item of class \code{gsDesign} or \code{gsSurv}, except for
#' \code{print.gsBoundSummary()} where \code{x} is an object created by
#' \code{gsBoundSummary()} and \code{xprint()} which is used with \code{xtable}
#' (see examples)
#' @param object An item of class \code{gsDesign} or \code{gsSurv}
#' @param information indicator of whether \code{n.I} in \code{object}
#' represents statistical information rather than sample size or event counts.
#' @param timeunit Text string with time units used for time-to-event designs
#' created with \code{gsSurv()}
#' @param deltaname Natural parameter name. If default \code{NULL} is used,
#' routine will default to \code{"HR"} when class is \code{gsSurv} or if
#' \code{nFixSurv} was input when creating \code{x} with \code{gsDesign()}.
#' @param logdelta Indicates whether natural parameter is the natural logarithm
#' of the actual parameter. For example, the relative risk or odds-ratio would
#' be put on the logarithmic scale since the asymptotic behavior is 'more
#' normal' than a non-transformed value. As with \code{deltaname}, the default
#' will be changed to true if \code{x} has class \code{gsDesign} or if
#' \code{nFixSurv>0} was input when \code{x} was created by \code{gsDesign()};
#' that is, the natural parameter for a time-to-event endpoint will be on the
#' logarithmic scale.
#' @param Nname This will normally be changed to \code{"N"} or, if a
#' time-to-event endpoint is used, \code{"Events"}. Other immediate possibility
#' are \code{"Deaths"} or \code{"Information"}.
#' @param digits Number of digits past the decimal to be printed in the body of
#' the table.
#' @param ddigits Number of digits past the decimal to be printed for the
#' natural parameter delta.
#' @param tdigits Number of digits past the decimal point to be shown for
#' estimated timing of each analysis.
#' @param timename Text string indicating time unit.
#' @param prior A prior distribution for the standardized effect size. Must be
#' of the format produced by \code{normalGrid()}, but can reflect an arbitrary
#' prior distribution. The default reflects a normal prior centered half-way
#' between the null and alternate hypothesis with the variance being equivalent
#' to the treatment effect estimate if 1 percent of the sample size for a fixed
#' design were sampled. The prior is intended to be relatively uninformative.
#' This input will only be applied if \code{POS=TRUE} is input.
#' @param ratio Sample size ratio assumed for experimental to control treatment
#' group sample sizes. This only matters when \code{x} for a binomial or
#' time-to-event endpoint where \code{gsRR} or \code{gsHR} are used for
#' approximating the treatment effect if a test statistic falls on a study
#' bound.
#' @param exclude A list of test statistics to be excluded from design boundary
#' summary produced; see details or examples for a list of all possible output
#' values. A value of \code{NULL} produces all available summaries.
#' @param POS This is an indicator of whether or not probability of success
#' (POS) should be estimated at baseline or at each interim based on the prior
#' distribution input in \code{prior}. The prior probability of success before
#' the trial starts is the power of the study averaged over the prior
#' distribution for the standardized effect size. The POS after an interim
#' analysis assumes the interim test statistic is an unknown value between the
#' futility and efficacy bounds. Based on this, a posterior distribution for
#' the standardized parameter is computed and the conditional power of the
#' trial is averaged over this posterior distribution.
#' @param r See \code{\link{gsDesign}}. This is an integer used to control the
#' degree of accuracy of group sequential calculations which will normally not
#' be changed.
#' @param row.names indicator of whether or not to print row names
#' @param include.rownames indicator of whether or not to include row names in
#' output.
#' @param hline.after table lines after which horizontal separation lines
#' should be set; default is to put lines between each analysis as well as at
#' the top and bottom of the table.
#' @param z A vector of z-statistics
#' @param i A vector containing the analysis for each element in \code{z}; each
#' element must be in 1 to \code{x$k}, inclusive
#' @param theta A scalar value representing the standardized effect size used
#' for conditional power calculations; see \code{gsDesign}; if NULL,
#' conditional power is computed at the estimated interim treatment effect
#' based on \code{z}
#' @param ylab Used when functions are passed to \code{plot.gsDesign} to
#' establish default y-axis labels
#' @param ... This allows many optional arguments that are standard when
#' calling \code{plot} for \code{gsBValue}, \code{gsDelta}, \code{gsHR},
#' \code{gsRR} and \code{gsCPz}
#' @return \code{gsBValue()}, \code{gsDelta()}, \code{gsHR()} and
#' \code{gsCPz()} each returns a vector containing the B-values, approximate
#' treatment effect (see details), approximate hazard ratio and conditional
#' power, respectively, for each value specified by the interim test statistics
#' in \code{z} at interim analyses specified in \code{i}.
#'
#' \code{summary} returns a text string summarizing the design at a high level.
#' This may be used with \code{gsBoundSummary} for a nicely formatted, concise
#' group sequential design description.
#'
#' \code{gsBoundSummary} returns a table in a data frame providing a variety of
#' boundary characteristics. The tabular format makes formatting particularly
#' amenable to place in documents either through direct creation of readable by
#' Word (see the \code{rtf} package) or to a csv format readable by spreadsheet
#' software using \code{write.csv}.
#'
#' \code{print.gsDesign} prints an overall summary a group sequential design.
#' While the design description is complete, the format is not as `document
#' friendly' as \code{gsBoundSummary}.
#'
#' \code{print.gsBoundSummary} is a simple extension of \code{print.data.frame}
#' intended for objects created with \code{gsBoundSummary}. The only extension
#' is to make the default to not print row names. This is probably `not good R
#' style' but may be helpful for many lazy R programmers like the author.
#' @examples
#' library(ggplot2)
#' # survival endpoint using gsSurv
#' # generally preferred over nSurv since time computations are shown
#' xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
#' gsBoundSummary(xgs, timename = "Year", tdigits = 1)
#' summary(xgs)
#' 
#' # survival endpoint using nSurvival
#' # NOTE: generally recommend gsSurv above for this!
#' ss <- nSurvival(
#'   lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
#'   sided = 1, alpha = .025, ratio = 2
#' )
#' xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
#' gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio)
#' # generate some of the above summary statistics for the upper bound
#' z <- xs$upper$bound
#' # B-values
#' gsBValue(z = z, i = 1:3, x = xs)
#' # hazard ratio
#' gsHR(z = z, i = 1:3, x = xs)
#' # conditional power at observed treatment effect
#' gsCPz(z = z[1:2], i = 1:2, x = xs)
#' # conditional power at H1 treatment effect
#' gsCPz(z = z[1:2], i = 1:2, x = xs, theta = xs$delta)
#' 
#' # information-based design
#' xinfo <- gsDesign(delta = .3, delta1 = .3)
#' gsBoundSummary(xinfo, Nname = "Information")
#' 
#' # show all available boundary descriptions
#' gsBoundSummary(xinfo, Nname = "Information", exclude = NULL)
#' 
#' # add intermediate parameter value
#' xinfo <- gsProbability(d = xinfo, theta = c(0, .15, .3))
#' class(xinfo) # note this is still as gsDesign class object
#' gsBoundSummary(xinfo, Nname = "Information")
#' 
#' # now look at a binomial endpoint; specify H0 treatment difference as p1-p2=.05
#' # now treatment effect at bound (say, thetahat) is transformed to
#' # xp$delta0 + xp$delta1*(thetahat-xp$delta0)/xp$delta
#' np <- nBinomial(p1 = .15, p2 = .10)
#' xp <- gsDesign(n.fix = np, endpoint = "Binomial", delta1 = .05)
#' summary(xp)
#' gsBoundSummary(xp, deltaname = "p[C]-p[E]")
#' # estimate treatment effect at lower bound
#' # by setting delta0=0 (default) and delta1 above in gsDesign
#' # treatment effect at bounds is scaled to these differences
#' # in this case, this is the difference in event rates
#' gsDelta(z = xp$lower$bound, i = 1:3, xp)
#' 
#' # binomial endpoint with risk ratio estimates
#' n.fix <- nBinomial(p1 = .3, p2 = .15, scale = "RR")
#' xrr <- gsDesign(k = 2, n.fix = n.fix, delta1 = log(.15 / .3), endpoint = "Binomial")
#' gsBoundSummary(xrr, deltaname = "RR", logdelta = TRUE)
#' gsRR(z = xp$lower$bound, i = 1:3, xrr)
#' plot(xrr, plottype = "RR")
#' 
#' # delta is odds-ratio: sample size slightly smaller than for relative risk or risk difference
#' n.fix <- nBinomial(p1 = .3, p2 = .15, scale = "OR")
#' xOR <- gsDesign(k = 2, n.fix = n.fix, delta1 = log(.15 / .3 / .85 * .7), endpoint = "Binomial")
#' gsBoundSummary(xOR, deltaname = "OR", logdelta = TRUE)
#' 
#' # for nice LaTeX table output, use xprint
#' xprint(xtable::xtable(gsBoundSummary(xOR, deltaname = "OR", logdelta = TRUE), 
#'                                           caption = "Table caption."))
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \link{gsDesign}, \link{plot.gsDesign},
#' \code{\link{gsProbability}}, \code{\link{xtable.gsSurv}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @aliases print.gsDesign summary.gsDesign
#' @rdname gsBoundSummary
#' @export
#' @importFrom stats pnorm
# gsBoundSummary function [sinew] ----
gsBoundSummary <- function(x, deltaname = NULL, logdelta = FALSE, Nname = NULL, digits = 4, ddigits = 2, tdigits = 0, timename = "Month",
                           prior = normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix)),
                           POS = FALSE, ratio = NULL, exclude = c("B-value", "Spending", "CP", "CP H1", "PP"), r = 18, ...) {
  k <- x$k
  if (is.null(Nname)) {
    if (x$n.fix == 1) {
      Nname <- "N/Fixed design N"
    } else {
      Nname <- "N"
    }
  }
  if(is.null(deltaname)){
    if ("gsSurv" %in% class(x) || x$nFixSurv>0){deltaname="HR"}else{deltaname="delta"}
  }
  # delta values corresponding to x$theta
  delta <- x$delta0 + (x$delta1 - x$delta0) * x$theta / x$delta
  if (logdelta || "gsSurv" %in% class(x)) delta <- exp(delta)
  # ratio is only used for RR and HR calculations at boundaries
  if ("gsSurv" %in% class(x)) {
    ratio <- x$ratio
  } else if (is.null(ratio)) ratio <- 1
  # delta values at bounds
  # note that RR and HR are treated specially
  if (x$test.type > 1) {
    if (x$nFixSurv > 0 || "gsSurv" %in% class(x) || toupper(deltaname) == "HR") {
      deltafutility <- gsHR(x = x, i = 1:x$k, z = x$lower$bound[1:x$k], ratio = ratio)
    } else if (tolower(deltaname) == "rr") {
      deltafutility <- gsRR(x = x, i = 1:x$k, z = x$lower$bound[1:x$k], ratio = ratio)
    } else {
      deltafutility <- gsDelta(x = x, i = 1:x$k, z = x$lower$bound[1:x$k])
      if (logdelta==TRUE) deltafutility <- exp(deltafutility)
    }
  }
  if (x$nFixSurv > 0 || "gsSurv" %in% class(x) || toupper(deltaname) == "HR") {
    deltaefficacy <- gsHR(x = x, i = 1:x$k, z = x$upper$bound[1:x$k], ratio = ratio)
  } else if (tolower(deltaname) == "rr") {
    deltaefficacy <- gsRR(x = x, i = 1:x$k, z = x$upper$bound[1:x$k], ratio = ratio)
  } else {
    deltaefficacy <- gsDelta(x = x, i = 1:x$k, z = x$upper$bound[1:x$k])
    if (logdelta==TRUE) deltaefficacy <- exp(deltaefficacy)
  }
  # create delta names for boundary crossing probabilities
  deltanames <- paste("P(Cross) if ", deltaname, "=", round(delta, ddigits), sep = "")
  pframe <- NULL
  for (i in 1:length(x$theta)) pframe <- rbind(pframe, data.frame("Value" = deltanames[i], "Efficacy" = cumsum(x$upper$prob[, i]), i = 1:x$k))
  if (x$test.type > 1) {
    pframe2 <- NULL
    for (i in 1:length(x$theta)) pframe2 <- rbind(pframe2, data.frame("Futility" = cumsum(x$lower$prob[, i])))
    pframe <- data.frame(cbind("Value" = pframe[, 1], pframe2, pframe[, -1]))
  }
  # conditional power at bound, theta=hat(theta)
  cp <- data.frame(gsBoundCP(x, r = r))
  # conditional power at bound, theta=theta[1]
  cp1 <- data.frame(gsBoundCP(x, theta = x$delta, r = r))
  if (x$test.type > 1) {
    colnames(cp) <- c("Futility", "Efficacy")
    colnames(cp1) <- c("Futility", "Efficacy")
  } else {
    colnames(cp) <- "Efficacy"
    colnames(cp1) <- "Efficacy"
  }
  cp <- data.frame(cp, "Value" = "CP", i = 1:(x$k - 1))
  cp1 <- data.frame(cp1, "Value" = "CP H1", i = 1:(x$k - 1))
  if ("PP" %in% exclude) {
    pp <- NULL
  } else {
    # predictive probability
    Efficacy <- as.vector(1:(x$k - 1))
    for (i in 1:(x$k - 1)) Efficacy[i] <- gsPP(x = x, i = i, zi = x$upper$bound[i], theta = prior$z, wgts = prior$wgts, r = r, total = TRUE)
    if (x$test.type > 1) {
      Futility <- Efficacy
      for (i in 1:(x$k - 1)) Futility[i] <- gsPP(x = x, i = i, zi = x$lower$bound[i], theta = prior$z, wgts = prior$wgts, r = r, total = TRUE)
    } else {
      Futility <- NULL
    }
    pp <- data.frame(cbind(Efficacy, Futility, i = 1:(x$k - 1)))
    pp$Value <- "PP"
  }
  # start a frame for other statistics
  # z at bounds
  statframe <- data.frame("Value" = "Z", "Efficacy" = x$upper$bound, i = 1:x$k)
  if (x$test.type > 1) statframe <- data.frame(cbind(statframe, "Futility" = x$lower$bound))
  # add nominal p-values at each bound
  tem <- data.frame("Value" = "p (1-sided)", "Efficacy" = stats::pnorm(x$upper$bound, lower.tail = FALSE), i = 1:x$k)
  if (x$test.type == 2) tem <- data.frame(cbind(tem, "Futility" = stats::pnorm(x$lower$bound, lower.tail = TRUE)))
  if (x$test.type > 2) tem <- data.frame(cbind(tem, "Futility" = stats::pnorm(x$lower$bound, lower.tail = FALSE)))
  statframe <- rbind(statframe, tem)
  # delta values at bounds
  tem <- data.frame("Value" = paste("~",deltaname, " at bound", sep = ""), "Efficacy" = deltaefficacy, i = 1:x$k)
  if (x$test.type > 1) tem$Futility <- deltafutility
  statframe <- rbind(statframe, tem)

  # spending
  tem <- data.frame("Value" = "Spending", i = 1:x$k, "Efficacy" = x$upper$spend)
  if (x$test.type > 1) tem$Futility <- x$lower$spend
  statframe <- rbind(statframe, tem)
  # B-values
  tem <- data.frame("Value" = "B-value", i = 1:x$k, "Efficacy" = gsBValue(x = x, z = x$upper$bound, i = 1:x$k))
  if (x$test.type > 1) tem$Futility <- gsBValue(x = x, i = 1:x$k, z = x$lower$bound)
  statframe <- rbind(statframe, tem)
  # put it all together
  statframe <- rbind(statframe, cp, cp1, pp, pframe)
  # exclude rows not wanted
  statframe <- statframe[!(statframe$Value %in% exclude), ]
  # sort by analysis
  statframe <- statframe[order(statframe$i), ]
  # add analysis and timing
  statframe$Analysis <- ""
  aname <- paste("IA ", 1:x$k, ": ", round(100 * x$timing, 0), "%", sep = "")
  aname[x$k] <- "Final"
  statframe[statframe$Value == statframe$Value[1], ]$Analysis <- aname
  # sample size, events or information at analyses
  if (!("gsSurv" %in% class(x))) {
    if (x$n.fix > 1) N <- ceiling(x$n.I) else N <- round(x$n.I, 2)
    if (Nname == "Information") N <- round(x$n.I, 2)
    nstat <- 2
  } else {
    nstat <- 4
    statframe[statframe$Value == statframe$Value[3], ]$Analysis <- paste("Events:", ceiling(rowSums(x$eDC + x$eDE)))
    if (x$ratio == 1) N <- 2 * ceiling(rowSums(x$eNE)) else N <- ceiling(rowSums(x$eNE)) + ceiling(rowSums(x$eNC))
    Time <- round(x$T, tdigits)
    statframe[statframe$Value == statframe$Value[4], ]$Analysis <- paste(timename, ": ", as.character(Time), sep = "")
  }
  statframe[statframe$Value == statframe$Value[2], ]$Analysis <- paste(Nname, ": ", N, sep = "")
  # add POS and predicitive POS, if requested
  if (POS) {
    ppos <- rep("", x$k)
    for (i in 1:(x$k - 1)) ppos[i] <- paste("Post IA POS: ", as.character(round(100 * gsCPOS(i = i, x = x, theta = prior$z, wgts = prior$wgts), 1)), "%", sep = "")
    statframe[statframe$Value == statframe$Value[nstat + 1], ]$Analysis <- ppos
    statframe[nstat + 2, ]$Analysis <- ppos[1]
    statframe[nstat + 1, ]$Analysis <- paste("Trial POS: ", as.character(round(100 * gsPOS(x = x, theta = prior$z, wgts = prior$wgts), 1)), "%", sep = "")
  }
  # add futility column to data frame
  scol <- c(1, 2, if (x$test.type > 1) {
    4
  } else {
    NULL
  })
  rval <- statframe[c(ncol(statframe), scol)]
  rval$Efficacy <- round(rval$Efficacy, digits)
  if (x$test.type > 1) rval$Futility <- round(rval$Futility, digits)
  class(rval) <- c("gsBoundSummary", "data.frame")
  return(rval)
}

# xprint roxy [sinew] ----
#' @export
#' @rdname gsBoundSummary
# xprint function [sinew] ----
xprint <- function(x, include.rownames = FALSE, hline.after = c(-1, which(x$Value == x[1, ]$Value) - 1, nrow(x)), ...) {
  xtable::print.xtable(x, hline.after = hline.after, include.rownames = include.rownames, ...)
}

# print.gsBoundSummary roxy [sinew] ----
#' @export
#' @rdname gsBoundSummary
# print.gsBoundSummary function [sinew] ----
print.gsBoundSummary <- function(x, row.names = FALSE, digits = 4, ...) {
  print.data.frame(x, row.names = row.names, digits = digits, ...)
}

# gsLegendText function [sinew] ----
gsLegendText <- function(test.type) {
  switch(as.character(test.type),
    "1" = c(expression(paste("Reject ", H[0])), "Continue"),
    "2" = c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[0]))),
    c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[1])))
  )
}

# sfprint function [sinew] ----
sfprint <- function(x) {
  # print spending function information
  if (x$name == "OF") {
    cat("O'Brien-Fleming boundary")
  }
  else if (x$name == "Pocock") {
    cat("Pocock boundary")
  }
  else if (x$name == "WT") {
    cat("Wang-Tsiatis boundary with Delta =", x$param)
  }
  else if (x$name == "Truncated") {
    cat(x$param$name, " spending function compressed to ", x$param$trange[1], ", ", x$param$trange[2], sep = "")
    if (!is.null(x$param$parname)) {
      cat(" with", x$param$parname, "=", x$param$param)
    }
  }
  else if (x$name == "Trimmed") {
    cat(x$param$name, " spending function trimmed at ", x$param$trange[1], ", ", x$param$trange[2], sep = "")
    if (!is.null(x$param$parname)) {
      cat(" with", x$param$parname, "=", x$param$param)
    }
  }
  else {
    cat(x$name, "spending function")
    if (!is.null(x$parname) && !is.null(x$param)) {
      cat(" with", x$parname, "=", x$param)
    }
  }
  cat("\n")
}

# summary.spendfn roxy [sinew] ----
#' @export
#' @aliases summary.spendfn
# summary.spendfn function [sinew] ----
summary.spendfn <- function(object, ...) {
  # print spending function information
  if (object$name == "OF") {
    s <- "O'Brien-Fleming boundary"
  }
  else if (object$name == "Pocock") {
    s <- "Pocock boundary"
  }
  else if (object$name == "WT") {
    s <- paste("Wang-Tsiatis boundary with Delta =", object$param)
  }
  else if (object$name == "Truncated") {
    s <- paste(object$param$name, " spending function compressed to ", object$param$trange[1], ", ", object$param$trange[2], sep = "")
    if (!is.null(object$param$parname)) {
      s <- paste(s, " with", paste(object$param$parname, collapse = " "), "=", paste(object$param$param, collapse = " "))
    }
  }
  else if (object$name == "Trimmed") {
    s <- paste(object$param$name, " spending function trimmed at ", object$param$trange[1], ", ", object$param$trange[2], sep = "")
    if (!is.null(object$param$parname)) {
      s <- paste(s, " with", paste(object$param$parname, collapse = " "), "=", paste(object$param$param, collapse = " "))
    }
  }
  else if (object$name == "Gapped") {
    s <- paste(object$param$name, " spending function no spending in ", object$param$trange[1], ", ", object$param$trange[2], sep = "")
    if (!is.null(object$param$parname)) {
      s <- paste(s, " with", paste(object$param$parname, collapse = " "), "=", paste(object$param$param, collapse = " "))
    }
  } else {
    s <- paste(object$name, "spending function")
    if (!is.null(object$parname) && !is.null(object$param)) {
      s <- paste(s, "with", paste(object$parname, collapse = " "), "=", paste(object$param, collapse = " "))
    }
  }
  return(s)
}
