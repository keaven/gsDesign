globalVariables(c("y", "N", "Z", "Bound", "thetaidx", "Probability", "delta", "Analysis"))

# plot.gsDesign roxy [sinew] ----
#' @title Plots for group sequential designs
#' @description The \code{plot()} function has been extended to work with objects returned
#' by \code{gsDesign()} and \code{gsProbability()}.  For objects of type
#' \code{gsDesign}, seven types of plots are provided: z-values at boundaries
#' (default), power, approximate treatment effects at boundaries, conditional
#' power at boundaries, spending functions, expected sample size, and B-values
#' at boundaries. For objects of type \code{gsProbability} plots are available
#' for z-values at boundaries, power (default), approximate treatment effects at
#' boundaries, conditional power, expected sample size and B-values at
#' boundaries.
#'
#' The intent is that many standard \code{plot()} parameters will function as
#' expected; exceptions to this rule exist. In particular, \code{main, xlab,
#' ylab, lty, col, lwd, type, pch, cex} have been tested and work for most
#' values of \code{plottype}; one exception is that \code{type="l"} cannot be
#' overridden when \code{plottype=2}. Default values for labels depend on
#' \code{plottype} and the class of \code{x}.
#'
#' Note that there is some special behavior for values plotted and returned for
#' power and expected sample size (ASN) plots for a \code{gsDesign} object. A
#' call to \code{x<-gsDesign()} produces power and expected sample size for
#' only two \code{theta} values: 0 and \code{x$delta}.  The call \code{plot(x,
#' plottype="Power")} (or \code{plot(x,plottype="ASN"}) for a \code{gsDesign}
#' object produces power (expected sample size) curves and returns a
#' \code{gsDesign} object with \code{theta} values determined as follows.  If
#' \code{theta} is non-null on input, the input value(s) are used. Otherwise,
#' for a \code{gsProbability} object, the \code{theta} values from that object
#' are used. For a \code{gsDesign} object where \code{theta} is input as
#' \code{NULL} (the default), \code{theta=seq(0,2,.05)*x$delta}) is used.  For
#' a \code{gsDesign} object, the x-axis values are rescaled to
#' \code{theta/x$delta} and the label for the x-axis \eqn{\theta / \delta}. For a
#' \code{gsProbability} object, the values of \code{theta} are plotted and are
#' labeled as \eqn{\theta}. See examples below.
#'
#' Approximate treatment effects at boundaries are computed dividing the Z-values
#' at the boundaries by the square root of \code{n.I} at that analysis.
#'
#' Spending functions are plotted for a continuous set of values from 0 to 1.
#' This option should not be used if a boundary is used or a pointwise spending
#' function is used (\code{sfu} or \code{sfl="WT", "OF", "Pocock"} or
#' \code{sfPoints}).
#'
#' Conditional power is computed using the function \code{gsBoundCP()}.  The
#' default input for this routine is \code{theta="thetahat"} which will compute
#' the conditional power at each bound using the approximate treatment effect at
#' that bound.  Otherwise, if the input is \code{gsDesign} object conditional
#' power is computed assuming \code{theta=x$delta}, the original effect size
#' for which the trial was planned.
#'
#' Average sample number/expected sample size is computed using \code{n.I} at
#' each analysis times the probability of crossing a boundary at that analysis.
#' If no boundary is crossed at any analysis, this is counted as stopping at
#' the final analysis.
#'
#' B-values are Z-values multiplied by \code{sqrt(t)=sqrt(x$n.I/x$n.I[x$k])}.
#' Thus, the expected value of a B-value at an analysis is the true value of
#' \eqn{\theta} multiplied by the proportion of total planned observations at
#' that time. See Proschan, Lan and Wittes (2006).
#'
#' @param x Object of class \code{gsDesign} for \code{plot.gsDesign()} or
#' \code{gsProbability} for
#'
#' \code{plot.gsProbability()}.
#' @param plottype 1=boundary plot (default for \code{gsDesign}),
#'
#' 2=power plot (default for \code{gsProbability}),
#'
#' 3=approximate treatment effect at boundaries,
#'
#' 4=conditional power at boundaries,
#'
#' 5=spending function plot (only available if \code{class(x)=="gsDesign"}),
#'
#' 6=expected sample size plot, and
#'
#' 7=B-values at boundaries.
#'
#' Character values for \code{plottype} may also be entered: \code{"Z"} for
#' plot type 1, \code{"power"} for plot type 2, \code{"thetahat"} for plot type
#' 3, \code{"CP"} for plot type 4, \code{"sf"} for plot type 5, \code{"ASN"},
#' \code{"N"} or \code{"n"} for plot type 6, and \code{"B"}, \code{"B-val"} or
#' \code{"B-value"} for plot type 7.
#' @param base Default is FALSE, which means ggplot2 graphics are used. If
#' true, base graphics are used for plotting.
#' @param ... This allows many optional arguments that are standard when
#' calling \code{plot}.
#'
#' Other arguments include:
#'
#' \code{theta} which is used for \code{plottype=2}, \code{4}, \code{6};
#' normally defaults will be adequate; see details.
#'
#' \code{ses=TRUE} which applies only when \code{plottype=3} and
#'
#' \code{class(x)=="gsDesign"}; indicates that approximate standardized effect
#' size at the boundary is to be plotted rather than the approximate natural parameter.
#'
#' \code{xval="Default"} which is only effective when \code{plottype=2} or
#' \code{6}. Appropriately scaled (reparameterized) values for x-axis for power
#' and expected sample size graphs; see details.
#' @return An object of \code{class(x)}; in many cases this is the input value
#' of \code{x}, while in others \code{x$theta} is replaced and corresponding
#' characteristics computed; see details.
#' @examples
#' library(ggplot2)
#' #  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#' #  lower bound is non-binding (ignored in Type I error computation)
#' #  sample size is computed based on a fixed design requiring n=100
#' x <- gsDesign(k = 5, test.type = 2, n.fix = 100)
#' x
#' 
#' # the following translate to calls to plot.gsDesign since x was
#' # returned by gsDesign; run these commands one at a time
#' plot(x)
#' plot(x, plottype = 2)
#' plot(x, plottype = 3)
#' plot(x, plottype = 4)
#' plot(x, plottype = 5)
#' plot(x, plottype = 6)
#' plot(x, plottype = 7)
#' 
#' #  choose different parameter values for power plot
#' #  start with design in x from above
#' y <- gsProbability(
#'   k = 5, theta = seq(0, .5, .025), x$n.I,
#'   x$lower$bound, x$upper$bound
#' )
#' 
#' # the following translates to a call to plot.gsProbability since
#' # y has that type
#' plot(y)
#' @note The gsDesign technical manual is available at
#'   \url{https://keaven.github.io/gsd-tech-manual/}.
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \code{\link{gsDesign}}, \code{\link{gsProbability}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Proschan, MA, Lan, KKG, Wittes, JT (2006), \emph{Statistical Monitoring of
#' Clinical Trials. A Unified Approach}.  New York: Springer.
#' @keywords design
#' @rdname plot.gsDesign
#' @export
# plot.gsDesign function [sinew] ----
plot.gsDesign <- function(x, plottype = 1, base = FALSE, ...) {
  #   checkScalar(plottype, "integer", c(1, 7))
  # if (base) invisible(do.call(gsPlotName(plottype), list(x, ...)))
  do.call(gsPlotName(plottype), list(x, base = base, ...))
}

# plot.gsProbability roxy [sinew] ----
#' @rdname plot.gsDesign
#' @export
# plot.gsProbability function [sinew] ----
plot.gsProbability <- function(x, plottype = 2, base = FALSE, ...) {
  #   checkScalar(plottype, "integer", c(1, 9))
  y <- x
  if (max(x$n.I) > 3) {
    y$n.fix <- max(x$n.I)
  } else {
    y$n.fix <- 1
  }
  y$nFixSurv <- 0
  y$test.type <- 3
  y$timing <- y$n.I / max(y$n.I)
  do.call(gsPlotName2(plottype), list(y, base = base, ...))
}

###
# Hidden Functions
###

# getColor function [sinew] ----
getColor <- function(.col_vector) {
  
  .col_list <- lapply(
    X = .col_vector, 
    FUN = function(.col){
      if(!is.na(suppressWarnings(as.integer(.col)))){
        rep(palette(), .col)[as.integer(.col)]
      } else {
        .col
      }
    }
  )
  
  unlist(.col_list)
}

# gsPlotName function [sinew] ----
gsPlotName <- function(plottype) {
  # define plots and associated valid plot types
  plots <- list(
    plotgsZ = c("1", "z"),
    plotgsPower = c("2", "power"),
    plotreleffect = c("3", "xbar", "thetahat", "theta"),
    plotgsCP = c("4", "cp", "copp"),
    plotsf = c("5", "sf"),
    plotASN = c("6", "asn", "e{n}", "n"),
    plotBval = c("7", "b", "b-val", "b-value"),
    plotHR = c("8", "hr", "hazard"),
    plotRR = c("9", "rr")
  )

  # perform partial matching on plot type and return name
  plottype <- match.arg(tolower(as.character(plottype)), as.vector(unlist(plots)))
  names(plots)[which(unlist(lapply(plots, function(x, type) is.element(type, x), type = plottype)))]
}

# gsPlotName2 function [sinew] ----
gsPlotName2 <- function(plottype) {
  # define plots and associated valid plot types
  plots <- list(
    plotgsZ = c("1", "z"),
    plotgsPower = c("2", "power"),
    plotgsCP = c("4", "cp", "copp"),
    plotASN = c("6", "asn", "e{n}", "n"),
    plotBval = c("7", "b", "b-val", "b-value"),
    plotHR = c("8", "hr", "hazard"),
    plotRR = c("9", "rr")
  )

  # perform partial matching on plot type and return name
  plottype <- match.arg(tolower(as.character(plottype)), as.vector(unlist(plots)))
  names(plots)[which(unlist(lapply(plots, function(x, type) is.element(type, x), type = plottype)))]
}

# plotgsZ function [sinew] ----
plotgsZ <- function(x, ylab = "Normal critical value", main = "Normal test statistics at bounds", ...) {
  qplotit(x = x, ylab = ylab, main = main, fn = function(z, ...) {
    z
  }, ...)
}

# plotBval function [sinew] ----
plotBval <- function(x, ylab = "B-value", main = "B-values at bounds", ...) {
  qplotit(x = x, fn = gsBValue, ylab = ylab, main = main, ...)
}

# plotreleffect function [sinew] ----
plotreleffect <- function(x = x, ylab = NULL, main = "Treatment effect at bounds", ...) {
  qplotit(x, fn = gsDelta, main = main, ylab = ifelse(!is.null(ylab), ylab,
    ifelse(tolower(x$endpoint) == "binomial",
      expression(hat(p)[C] - hat(p)[E]),
      expression(hat(theta) / theta[1])
    )
  ), ...)
}

# plotHR function [sinew] ----
plotHR <- function(x = x, ylab = "Approximate hazard ratio", main = "Approximate hazard ratio at bounds", ...) {
  qplotit(x, fn = gsHR, ylab = ylab, main = main, ratio = 1, ...)
}

# plotRR function [sinew] ----
plotRR <- function(x = x, ylab = "Approximate risk ratio", main = "Approximate risk ratio at bounds", ...) {
  qplotit(x, fn = gsRR, ylab = ylab, main = main, ratio = 1, ...)
}

# gsBValue function [sinew] ----
#' @export 
#' @rdname gsBoundSummary
gsBValue <- function(z, i, x, ylab = "B-value", ...) {
  Bval <- z * sqrt(x$timing[i])
  Bval
}

# gsDelta function [sinew] ----
#' @export 
#' @rdname gsBoundSummary
gsDelta <- function(z, i, x, ylab = NULL, ...) {
  deltaHat <- z / sqrt(x$n.I[i]) * (x$delta1 - x$delta0) / x$delta + x$delta0
  deltaHat
}

# gsRR function [sinew] ----
#' @export 
#' @rdname gsBoundSummary
gsRR <- function(z, i, x, ratio = 1, ylab = "Approximate risk ratio", ...) {
  deltaHat <- z / sqrt(x$n.I[i]) * (x$delta1 - x$delta0) / x$delta + x$delta0
  exp(deltaHat)
}

# gsHR function [sinew] ----
#' @export 
#' @rdname gsBoundSummary
gsHR <- function(z, i, x, ratio = 1, ylab = "Approximate hazard ratio", ...) {
  c <- 1 / (1 + ratio)
  psi <- c * (1 - c)

  if (is.null(x$hr0)) {
    x$hr0 <- 1
  }

  hrHat <- exp(-z / sqrt(x$n.I[i] * psi)) * x$hr0
  hrHat
}

# gsCPz function [sinew] ----
#' @rdname gsBoundSummary
#' @export
gsCPz <- function(z, i, x, theta = NULL, ylab = NULL, ...) {
  cp <- rep(0, length(z))

  if (is.null(theta)) {
    theta <- z / sqrt(x$n.I[i])
  }

  if (length(theta) == 1 && length(z) > 1) {
    theta <- rep(theta, length(z))
  }

  for (j in 1:length(z)) {
    cp[j] <- sum(gsCP(x = x, theta = theta[j], i = i[j], zi = z[j])$upper$prob)
  }

  cp
}

# qplotit roxy [sinew] ----
#' @importFrom graphics lines text
#' @importFrom ggplot2 ggplot aes geom_text geom_line scale_x_continuous scale_y_continuous scale_colour_manual scale_linetype_manual ggtitle xlab ylab
#' @importFrom rlang .data
# qplotit function [sinew] ----
qplotit <- function(x, xlim = NULL, ylim = NULL, main = NULL, geom = c("line", "text"),
                    dgt = c(2, 2), lty = c(2, 1), col = c(1, 1),
                    lwd = c(1, 1), nlabel = "TRUE", xlab = NULL, ylab = NULL, fn = function(z, i, x, ...) {
                      z
                    },
                    ratio = 1, delta0 = 0, delta = 1, cex = 1, base = FALSE, ...) {

  if (length(lty) == 1) lty <- rep(lty, 2)
  if (length(col) == 1) col <- rep(col, 2)
  if (length(lwd) == 1) lwd <- rep(lwd, 2)
  if (length(dgt) == 1) dgt <- rep(dgt, 2)
  if (x$n.fix == 1) {
    nround <- 3
    ntx <- "r="
    if (is.null(xlab)) xlab <- "Information relative to fixed sample design"
  } else if (x$nFixSurv > 0) {
    ntx <- "d="
    nround <- 0
    if (is.null(xlab)) xlab <- "Number of events"
  } else {
    nround <- 0
    ntx <- "n="
    if (is.null(xlab)) xlab <- "Sample size"
  }
  if (x$test.type > 1) {
    z <- fn(
      z = c(x$upper$bound, x$lower$bound), i = c(1:x$k, 1:x$k), x = x,
      ratio = ratio, delta0 = delta0, delta = delta
    )
    Ztxt <- as.character(c(round(z[1:x$k], dgt[2]), round(z[x$k + (1:x$k)], dgt[1])))
    # use maximum digits for equal final bounds
    if (x$upper$bound[x$k] == x$lower$bound[x$k]) {
      Ztxt[c(x$k, 2 * x$k)] <- round(z[x$k], max(dgt))
    }
    indxu <- (1:x$k)[x$upper$bound < 20]
    indxl <- (1:x$k)[x$lower$bound > -20]
    y <- data.frame(
      N = as.numeric(c(x$n.I[indxu], x$n.I[indxl])),
      Z = as.numeric(z[c(indxu, x$k + indxl)]),
      Bound = c(rep("Upper", length(indxu)), rep("Lower", length(indxl))),
      Ztxt = Ztxt[c(indxu, x$k + indxl)]
    )
  } else {
    z <- fn(
      z = x$upper$bound, i = 1:x$k, x = x,
      ratio = ratio, delta0 = delta0, delta = delta
    )
    Ztxt <- as.character(round(z, dgt[1]))
    y <- data.frame(
      N = as.numeric(x$n.I),
      Z = as.numeric(z),
      Bound = rep("Upper", x$k),
      Ztxt = Ztxt
    )
  }
  if (!is.numeric(ylim)) {
    ylim <- range(y$Z)
    ylim[1] <- ylim[1] - .1 * (ylim[2] - ylim[1])
  }
  if (!is.numeric(xlim)) {
    xlim <- range(x$n.I)
    xlim <- xlim + c(-.05, .05) * (xlim[2] - xlim[1])
  }
  if (base == TRUE) {
    plot(
      x = y$N[y$Bound == "Upper"], y = y$Z[y$Bound == "Upper"], type = "l", xlim = xlim, ylim = ylim,
      main = main, lty = lty[1], col = col[1], lwd = lwd[1], xlab = xlab, ylab = ylab, ...
    )
    graphics::lines(x = y$N[y$Bound == "Lower"], y = y$Z[y$Bound == "Lower"], lty = lty[2], col = col[2], lwd = lwd[2])
  } else {
    lbls <- c("Lower", "Upper")
    if (x$test.type > 1) {
      p <- ggplot2::ggplot(data = y, ggplot2::aes(
        x = as.numeric(.data$N), y = as.numeric(.data$Z), group = factor(.data$Bound),
        col = factor(.data$Bound), label = Ztxt, lty = factor(.data$Bound)
      )) + 
        ggplot2::geom_text(show.legend = F, size = cex * 5) + 
        ggplot2::geom_line() +
        ggplot2::scale_x_continuous(xlab) + 
        ggplot2::scale_y_continuous(ylab) +
        ggplot2::scale_colour_manual(name = "Bound", values = getColor(col), labels = lbls, breaks = lbls) +
        ggplot2::scale_linetype_manual(name = "Bound", values = lty, labels = lbls, breaks = lbls)
      
        p <- p + ggplot2::ggtitle(label = main)

    } else {
      p <- ggplot2::ggplot(ggplot2::aes(
        x = as.numeric(.data$N),
        y = as.numeric(.data$Z),
        label = Ztxt, 
        group = factor(.data$Bound)),
        data = y
        ) +
        ggplot2::geom_line(colour = getColor(col[1]), lty = lty[1], lwd = lwd[1]) +
        ggplot2::geom_text(size = cex * 5) + 
        ggplot2::xlab(xlab) + 
        ggplot2::ylab(ylab)

        p <- p + ggplot2::ggtitle(label = main)
    }
  }
  if (nlabel == TRUE) {
    y2 <- data.frame(
      N = as.numeric(x$n.I),
      Z = as.numeric(rep(ylim[1], x$k)),
      Bound = rep("Lower", x$k),
      Ztxt = ifelse(rep(nround, x$k) > 0, as.character(round(x$n.I, nround)), ceiling(x$n.I))
    )
    if (base) {
      graphics::text(x = y2$N, y = y$Z, y$Ztxt, cex = cex)
    }
    if (x$n.fix == 1) {
      if (base) {
        graphics::text(x = y2$N, y = y2$Z, paste(rep("r=", x$k), y2$Ztxt, sep = ""), cex = cex)
      } else {
        y2$Ztxt <- paste(rep("r=", x$k), y2$Ztxt, sep = "")
        p <- p + geom_text(data = y2, aes(group = factor(.data$Bound), label = Ztxt), size = cex * 5, show.legend = F, colour = getColor(1))
      }
    } else {
      if (base) {
        graphics::text(x = y2$N, y = y2$Z, paste(rep("N=", x$k), y2$Ztxt, sep = ""), cex = cex)
      } else {
        y2$Ztxt <- paste(rep("N=", x$k), y2$Ztxt, sep = "")
        p <- p + ggplot2::geom_text(data = y2, ggplot2::aes(group = factor(.data$Bound), label = Ztxt), size = cex * 5, show.legend = F, colour = getColor(1))
      }
    }
  }
  if (base) {
    invisible(x)
  } else {
    return(p)
  }
}


# plotgsCP roxy [sinew] ----
#' @importFrom graphics plot text matplot matpoints points
#' @importFrom ggplot2 ggplot aes geom_text scale_x_continuous scale_y_continuous scale_colour_manual scale_linetype_manual ggtitle geom_line xlab ylab
# plotgsCP function [sinew] ----
plotgsCP <- function(x, theta = "thetahat", main = "Conditional power at interim stopping boundaries",
                     ylab = NULL, geom = c("line","text"),
                     xlab = ifelse(x$n.fix == 1, "Sample size relative to fixed design", "N"), xlim = NULL,
                     lty = c(1,2), col = c(1,1), lwd = c(1,1), pch = " ", cex = 1, legtext = NULL,  dgt = c(3,2), nlabel = TRUE, 
                     base = FALSE,...){

  if (length(lty) == 1) lty <- rep(lty, 2)
  if (length(col) == 1) col <- rep(col, 2)
  if (length(lwd) == 1) lwd <- rep(lwd, 2)
  if (length(dgt) == 1) dgt <- rep(dgt, 2)
  if (x$k == 2) stop("No conditional power plot available for k=2")
  # switch order of parameters
  lty <- lty[2:1]
  col <- col[2:1]
  lwd <- lwd[2:1]
  dgt <- dgt[2:1]
  if (is.null(ylab)) {
    ylab <- ifelse(theta == "thetahat",
      expression(paste("Conditional power at",
        theta, " = ", hat(theta),
        sep = " "
      )),
      "Conditional power"
    )
  }
  if (!is.numeric(xlim)) {
    xlim <- range(x$n.I[1:(x$k - 1)])
    xlim <- xlim + c(-.05, .05) * (xlim[2] - xlim[1])
    if (x$k == 2) xlim <- xlim + c(-1, 1)
  }
  if (x$n.fix == 1) {
    nround <- 3
    ntx <- "r="
    if (is.null(xlab)) xlab <- "Information relative to fixed sample design"
  } else {
    nround <- 0
    ntx <- "n="
    if (is.null(xlab)) xlab <- "N"
  }
  test.type <- ifelse(inherits(x, "gsProbability"), 3, x$test.type)
  if (is.null(legtext)) legtext <- gsLegendText(test.type)
  y <- gsBoundCP(x, theta = theta)
  ymax <- 1.05
  ymin <- -0.1

  if (x$k > 3) {
    xtext <- x$n.I[2]
  } else if (x$k == 3) {
    xtext <- (x$n.I[2] + x$n.I[1]) / 2
  } else {
    xtext <- x$n.I[1]
  }

  if (test.type > 1) {
    if (x$k > 2) {
      ymid <- (y[2, 2] + y[2, 1]) / 2
    } else {
      ymid <- mean(y)
    }
  }

  if (base) {
    if (test.type == 1) {
      graphics::plot(x$n.I[1:(x$k - 1)], y,
        xlab = xlab, ylab = ylab, main = main,
        ylim = c(ymin, ymax), xlim = xlim, col = col[1], lwd = lwd[1], lty = lty[1], type = "l", ...
      )
      graphics::points(x$n.I[1:(x$k - 1)], y, ...)
      graphics::text(x$n.I[1:(x$k - 1)], y, as.character(round(y, dgt[2])), cex = cex)
      ymid <- ymin
    }
    else {
      graphics::matplot(x$n.I[1:(x$k - 1)], y,
        xlab = xlab, ylab = ylab, main = main,
        lty = lty, col = col, lwd = lwd, ylim = c(ymin, ymax), xlim = xlim, type = "l", ...
      )
      graphics::matpoints(x$n.I[1:(x$k - 1)], y, pch = pch, col = col, ...)
      graphics::text(xtext, ymin, legtext[3], cex = cex)
      graphics::text(x$n.I[1:(x$k - 1)], y[, 1], as.character(round(y[, 1], dgt[1])), col = col[1], cex = cex)
      graphics::text(x$n.I[1:(x$k - 1)], y[, 2], as.character(round(y[, 2], dgt[2])), col = col[2], cex = cex)
    }
    graphics::text(xtext, ymid, legtext[2], cex = cex)
    graphics::text(xtext, 1.03, legtext[1], cex = cex)
  } else {
    N <- as.numeric(x$n.I[1:(x$k - 1)])
    if (test.type > 1) {
      CP <- y[, 2]
    } else {
      CP <- y
    }
    Bound <- rep("Upper", x$k - 1)
    Ztxt <- as.character(round(CP[1:(x$k - 1)], dgt[2]))
    if (test.type > 1) {
      N <- c(N, N)
      CP <- c(CP, y[, 1])
      Bound <- c(Bound, rep("Lower", x$k - 1))
      Ztxt <- as.character(c(Ztxt, round(y[, 1], dgt[1])))
    }
    y <- data.frame(N = N, CP = CP, Bound = Bound, Ztxt = Ztxt)
    if (test.type > 1) {
      lbls <- c("Lower", "Upper")
      p <- ggplot2::ggplot(
        data = y, 
        ggplot2::aes(
          x = as.numeric(N), 
          y = as.numeric(CP), 
          group = factor(Bound),
          col = factor(Bound), 
          label = Ztxt, 
          lty = factor(Bound)
      )) +
        ggplot2::geom_text(show.legend = F, size = cex * 5) + geom_line() +
        ggplot2::scale_x_continuous(xlab) + 
        ggplot2::scale_y_continuous(ylab) +
        ggplot2::scale_colour_manual(name = "Bound", values = getColor(col), labels = lbls, breaks = lbls) +
        ggplot2::scale_linetype_manual(name = "Bound", values = lty, labels = lbls, breaks = lbls)
        p <- p + ggplot2::ggtitle(label = main)
    } else {
      p <- ggplot2::ggplot(
        y,
        ggplot2::aes(
          x = as.numeric(N),
          y = as.numeric(CP),
          label = Ztxt,
          group = factor(Bound)
        )
      ) +
        ggplot2::geom_line(colour = getColor(col[1]), lty = lty[1], lwd = lwd[1]) +
        ggplot2::geom_text(size = cex * 5) +
        ggplot2::xlab(xlab) +
        ggplot2::ylab(ylab)
      p <- p + ggplot2::ggtitle(label = main)
    }
  }
  if (nlabel == TRUE) {
    y2 <- data.frame(
      N = x$n.I[1:(x$k - 1)],
      CP = rep(ymin / 2, x$k - 1),
      Bound = rep("Lower", x$k - 1),
      Ztxt = as.character(round(x$n.I[1:(x$k - 1)], nround))
    )
    if (x$n.fix == 1) {
      if (base) {
        graphics::text(x = y2$N, y = y2$CP, paste(rep("r=", x$k), y2$Ztxt, sep = ""), cex = cex)
      } else {
        y2$Ztxt <- paste(rep("r=", x$k - 1), y2$Ztxt, sep = "")
        p <- p + geom_text(data = y2, aes(N, CP, group = factor(Bound), label = Ztxt), size = cex * 5, colour = getColor(1))
      }
    } else {
      if (base) {
        graphics::text(x = y2$N, y = y2$CP, paste(rep("N=", x$k), y2$Ztxt, sep = ""), cex = cex)
      } else {
        y2$Ztxt <- paste(rep("N=", x$k - 1), y2$Ztxt, sep = "")
        p <- p + geom_text(data = y2, aes(N, CP, group = factor(Bound), label = Ztxt), size = cex * 5, colour = getColor(1))
      }
    }
  }
  if (base) {
    invisible(x)
  } else {
    return(p)
  }
}

# plotsf roxy [sinew] ----
#' @importFrom graphics par plot legend axis mtext
#' @importFrom ggplot2 qplot scale_colour_manual scale_linetype_manual
# plotsf function [sinew] ----
plotsf <- function(x,
                   xlab = "Proportion of total sample size",
                   ylab = NULL, main = "Spending function plot",
                   ylab2 = NULL, oma = c(2, 2, 2, 2),
                   legtext = NULL,
                   col = c(1, 1), lwd = c(.5, .5), lty = c(1, 2),
                   mai = c(.85, .75, .5, .5), xmax = 1, base = FALSE, ...) {
  
  if (is.null(legtext)) {
    if (x$test.type > 4) {
      legtext <- c("Upper bound", "Lower bound")
    } else {
      legtext <- c(expression(paste(alpha, "-spending")), expression(paste(beta, "-spending")))
    }
  }
  if (is.null(ylab)) {
    if (base == F && x$test.type > 2) {
      ylab <- "Proportion of spending"
    } else {
      ylab <- expression(paste(alpha, "-spending"))
    }
  }
  if (is.null(ylab2)) {
    if (x$test.type > 4) {
      ylab2 <- "Proportion of spending"
    } else {
      ylab2 <- expression(paste(beta, "-spending"))
    }
  }
  if (length(lty) == 1) lty <- rep(lty, 2)
  if (length(col) == 1) col <- rep(col, 2)
  if (length(lwd) == 1) lwd <- rep(lwd, 2)

  # K. Wills (GSD-31)
  if (inherits(x, "gsProbability")) {
    stop("Spending function plot not available for gsProbability object")
  }

  # K. Wills (GSD-30)
  if (x$upper$name %in% c("WT", "OF", "Pocock")) {
    stop("Spending function plot not available for boundary families")
  }
  # 	if (x$upper$parname == "Points"){x$sfupar <- sfLinear}

  t <- 0:40 / 40 * xmax

  if (x$test.type > 2 && base) {
    oldpar <- par(no.readonly = TRUE)    
    on.exit(par(oldpar))
    graphics::par(mai = mai, oma = oma)
  }
  if (base) {
    graphics::plot(t, x$upper$sf(x$alpha, t, x$upper$param)$spend,
      type = "l", ylab = ylab, xlab = xlab, lty = lty[1],
      lwd = lwd[1], col = col[1], main = main, ...
    )
  }
  else if (x$test.type < 3) {
    spend <- x$upper$sf(x$alpha, t, x$upper$param)$spend
    q <- data.frame(t = t, spend = spend)
    p <-
      ggplot2::ggplot(q, ggplot2::aes(x = t, y = spend)) +
      ggplot2::geom_line() +
      ggplot2::labs(x = xlab, y = ylab, title = main)
    return(p)
  }

  if (x$test.type > 2) {
    if (base) {
      graphics::legend(x = c(.0, .43), y = x$alpha * c(.85, 1), lty = lty, col = col, lwd = lwd, legend = legtext)
      oldpar <- par(no.readonly = TRUE)    
      on.exit(par(oldpar))
      graphics::par(new = TRUE)
      graphics::plot(t, x$lower$sf(x$beta, t, x$lower$param)$spend,
        ylim = c(0, x$beta), type = "l", ylab = ylab,
        yaxt = "n", xlab = xlab, lty = lty[2], lwd = lwd[2], col = col[2], main = main, ...
      )
      graphics::axis(4)
      graphics::mtext(text = ylab2, side = 4, outer = TRUE)
    } else {
      spenda <- x$upper$sf(x$alpha, t, x$upper$param)$spend / x$alpha
      if (x$test.type < 5) {
        spendb <- x$lower$sf(x$beta, t, x$lower$param)$spend / x$beta
      } else {
        spendb <- x$lower$sf(x$astar, t, x$lower$param)$spend / x$astar
      }
      group <- rep(1, length(t))
      q <- data.frame(t = c(t, t), spend = c(spenda, spendb), group = c(group, 2 * group))
      p <-
        ggplot2::ggplot(q, ggplot2::aes(x = t, y = spend, group = factor(group))) +
        ggplot2::geom_line(aes(linetype = factor(group), colour = factor(group))) +
        ggplot2::labs(x = xlab, y = ylab, title = main)
      p <- p +
        ggplot2::scale_colour_manual(
          name = "Spending", values = getColor(col),
          labels = c(expression(alpha), ifelse(x$test.type < 5, expression(beta), expression(1 - alpha))), breaks = 1:2
        ) +
        ggplot2::scale_linetype_manual(
          name = "Spending", values = lty,
          labels = c(expression(alpha), ifelse(x$test.type < 5, expression(beta), expression(1 - alpha))), breaks = 1:2
        )
      return(p)
    }
  }
}

# plotASN roxy [sinew] ----
#' @importFrom graphics plot
#' @importFrom ggplot2 qplot
#' @importFrom rlang .data
# plotASN function [sinew] ----
plotASN <- function(x, xlab = NULL, ylab = NULL, main = NULL, theta = NULL, xval = NULL, type = "l",
                    base = FALSE, ...) {
  if (inherits(x, "gsDesign") && x$n.fix == 1) {
    if (is.null(ylab)) ylab <- "E{N} relative to fixed design"
    if (is.null(main)) main <- "Expected sample size relative to fixed design"
  }
  else if (inherits(x, "gsSurv")) {
    if (is.null(ylab)) ylab <- "Expected number of events"
    if (is.null(main)) main <- "Expected number of events by underlying hazard ratio"
  }
  else {
    if (is.null(ylab)) ylab <- "Expected sample size"
    if (is.null(main)) main <- "Expected sample size by underlying treatment difference"
  }

  if (is.null(theta)) {
    if (inherits(x, "gsDesign")) {
      theta <- seq(0, 2, .05) * x$delta
    } else {
      theta <- x$theta
    }
  }

  if (is.null(xval)) {
    if (inherits(x, "gsDesign")) {
      xval <- x$delta0 + (x$delta1 - x$delta0) * theta / x$delta
      if (inherits(x, "gsSurv")) {
        xval <- exp(xval)
        if (is.null(xlab)) xlab <- "Hazard ratio"
      } else if (is.null(xlab)) xlab <- expression(delta)
    } else {
      xval <- theta
      if (is.null(xlab)) xlab <- expression(theta)
    }
  }

  x <- if (inherits(x, "gsDesign")) {
    gsProbability(d = x, theta = theta)
  } else {
    gsProbability(k = x$k, a = x$lower$bound, b = x$upper$bound, n.I = x$n.I, theta = theta)
  }

  if (is.null(ylab)) {
    if (max(x$n.I) < 3) {
      ylab <- "E{N} relative to fixed design"
    } else {
      ylab <- "Expected sample size"
    }
  }
  if (base) {
    graphics::plot(xval, x$en, type = type, ylab = ylab, xlab = xlab, main = main, ...)
    return(invisible(x))
  }
  else {
    q <- data.frame(x = xval, y = x$en)
    p <-
      ggplot2::ggplot(q, ggplot2::aes(x = x, y = !!rlang::sym("y"))) +
      ggplot2::geom_line() +
      ggplot2::labs(x = xlab, y = ylab, title = main)
    return(p)
  }
}

# plotgsPower roxy [sinew] ----
#' @importFrom stats reshape
#' @importFrom dplyr group_by reframe
#' @importFrom ggplot2 ggplot aes geom_line ylab guides guide_legend xlab scale_linetype_manual scale_color_manual scale_y_continuous ggtitle scale_x_continuous scale_colour_manual geom_text
#' @importFrom rlang .data
#' @importFrom graphics plot axis lines strwidth text
#' @param offset Integer to offset the numeric labels of the "Analysis" legend
#'   (default: 0). Only relevant for \code{outtype = 1}. By default will change
#'   legend title to "Future Analysis". To customize the title, pass the label
#'   to the argument \code{titleAnalysisLegend}
#' @param titleAnalysisLegend Label to use as the title for the "Analysis"
#'   legend (default: NULL)
# plotgsPower function [sinew] ----
plotgsPower <- function(x, main = "Boundary crossing probabilities by effect size",
                        ylab = "Cumulative Boundary Crossing Probability",
                        xlab = NULL, lty = NULL, col = NULL, lwd = 1, cex = 1,
                        theta = if (inherits(x, "gsDesign")) seq(0, 2, .05) * x$delta else x$theta,
                        xval = NULL, base = FALSE, outtype = 1, offset = 0,
                        titleAnalysisLegend = NULL, ...) {

  stopifnot(
    is.numeric(offset) && length(offset) == 1,
    is.null(titleAnalysisLegend) ||
      (is.character(titleAnalysisLegend) && length(titleAnalysisLegend) == 1)
  )
  if (is.null(xval)) {
    if (inherits(x, "gsDesign")) {
      xval <- x$delta0 + (x$delta1 - x$delta0) * theta / x$delta
      if (inherits(x, "gsSurv")) {
        xval <- exp(xval)
        if (is.null(xlab)) xlab <- "Hazard ratio"
      } else if (is.null(xlab)) xlab <- expression(delta)
    } else {
      xval <- theta
      if (is.null(xlab)) xlab <- expression(theta)
    }
  }
  if (is.null(xlab)) xlab <- ""
  x <- if (inherits(x, "gsDesign")) {
    gsProbability(d = x, theta = theta)
  } else {
    gsProbability(k = x$k, a = x$lower$bound, b = x$upper$bound, n.I = x$n.I, theta = theta)
  }
  test.type <- ifelse(inherits(x, "gsProbability"), 3, x$test.type)
  theta <- xval
  if (!base && outtype == 1) {
    if (is.null(lty)) lty <- x$k:1
    xu <- data.frame(x$upper$prob)
    y <- cbind(stats::reshape(xu, varying = names(xu), v.names = "Probability", timevar = "thetaidx", direction = "long"), Bound = "Upper bound")
    if (is.null(col)) col <- 1
    if (is.null(x$test.type) || x$test.type > 1) {
      y <- rbind(
        cbind(stats::reshape(data.frame(x$lower$prob), varying = names(xu), v.names = "Probability", timevar = "thetaidx", direction = "long"), Bound = "1-Lower bound"),
        y
      )
      if (length(col) == 1) col <- c(2, 1)
    }
    
    Probability <- NULL
    
    y2 <- y %>%
             dplyr::group_by(Bound, thetaidx) %>% 
             dplyr::reframe(Probability = cumsum(Probability))
    
    y2$Probability[y2$Bound == "1-Lower bound"] <- 1 - y2$Probability[y2$Bound == "1-Lower bound"]
    
    y2$Analysis <- factor(y$id + offset)
    
    # Determine title of Analysis legend
    titleAnalysis <- "Analysis"
    if (offset > 0) {
      titleAnalysis <- "Future Analysis"
    }
    if (!is.null(titleAnalysisLegend)) {
      titleAnalysis <- titleAnalysisLegend
    }

    y2$delta <- xval[y$thetaidx]
    
    p <- ggplot2::ggplot(y2, 
                         ggplot2::aes(
                           x = .data$delta,
                           y = .data$Probability,
                           col = .data$Bound,
                           lty = .data$Analysis)
                         ) + 
      ggplot2::geom_line(size = lwd) + 
      ggplot2::ylab(ylab) +
      ggplot2::guides(color = ggplot2::guide_legend(title = "Probability")) + 
      ggplot2::xlab(xlab) +
      ggplot2::scale_linetype_manual(values = lty, name = titleAnalysis) +
      ggplot2::scale_color_manual(values = getColor(col)) +
      ggplot2::scale_y_continuous(breaks = seq(0, 1, .2))
    
    return(p + ggplot2::ggtitle(label = main))
  }
  if (is.null(col)) {
    if (base || outtype == 2) {
      col <- c(1, 2)
    } else {
      col <- c(2, 1)
    }
  }
  if (length(col) == 1) col <- rep(col, 2)
  if (is.null(lty)) {
    if (base || outtype == 2) {
      lty <- c(1, 2)
    } else {
      lty <- c(2, 1)
    }
  }
  if (length(lty) == 1) lty <- rep(lty, 2)
  if (length(lwd) == 1) lwd <- rep(lwd, 2)


  interim <- rep(1, length(xval))
  bound <- rep(1, length(xval) * x$k)
  boundprob <- x$upper$prob[1, ]
  prob <- boundprob
  yval <- min(mean(range(x$upper$prob[1, ])))
  xv <- ifelse(xval[2] > xval[1], min(xval[boundprob >= yval]), max(xval[boundprob >= yval]))
  for (j in 2:x$k)
  {
    theta <- c(theta, xval)
    interim <- c(interim, rep(j, length(xval)))
    boundprob <- boundprob + x$upper$prob[j, ]
    prob <- c(prob, boundprob)
    ymid <- mean(range(boundprob))
    yval <- c(yval, min(boundprob[boundprob >= ymid]))
    xv <- c(xv, ifelse(xval[2] > xval[1], min(xval[boundprob >= ymid]), max(xval[boundprob >= ymid])))
  }
  itxt <- rep("Interim", x$k - 1)
  itxt <- paste(itxt, 1:(x$k - 1), sep = " ")

  if (inherits(x, "gsProbability") || (inherits(x, "gsDesign") && test.type > 1)) {
    itxt <- c(itxt, "Final", itxt)
    boundprob <- rep(1, length(xval))
    bound <- c(bound, rep(2, length(xval) * (x$k - 1)))
    for (j in 1:(x$k - 1))
    {
      theta <- c(theta, xval)
      interim <- c(interim, rep(j, length(xval)))
      boundprob <- boundprob - x$lower$prob[j, ]
      prob <- c(prob, boundprob)
      ymid <- mean(range(boundprob))
      yval <- c(yval, min(boundprob[boundprob >= ymid]))
      xv <- c(xv, ifelse(xval[2] > xval[1], min(xval[boundprob >= ymid]), max(xval[boundprob >= ymid])))
    }
  } else {
    itxt <- c(itxt, "Final")
  }
  y <- data.frame(
    theta = as.numeric(theta), interim = interim, bound = bound, prob = as.numeric(prob),
    itxt = as.character(round(prob, 2))
  )
  y$group <- (y$bound == 2) * x$k + y$interim
  bound <- rep(1, x$k)
  interim <- 1:x$k
  if (test.type > 1) {
    bound <- c(bound, rep(2, x$k - 1))
    interim <- c(interim, 1:(x$k - 1))
  }
  yt <- data.frame(theta = xv, interim = interim, bound = bound, prob = yval, itxt = itxt)
  bound <- rep(1, x$k)
  interim <- 1:x$k
  if (test.type > 1) {
    bound <- c(bound, rep(2, x$k - 1))
    interim <- c(interim, 1:(x$k - 1))
  }
  yt <- data.frame(theta = xv, interim = interim, bound = bound, prob = yval, itxt = itxt)
  if (base) {
    col2 <- ifelse(length(col) > 1, col[2], col)
    lwd2 <- ifelse(length(lwd) > 1, lwd[2], lwd)
    lty2 <- ifelse(length(lty) > 1, lty[2], lty)

    ylim <- if (inherits(x, "gsDesign") && test.type <= 2) c(0, 1) else c(0, 1.25)

    graphics::plot(xval, x$upper$prob[1, ],
      xlab = xlab, main = main, ylab = ylab,
      ylim = ylim, type = "l", col = col[1], lty = lty[1], lwd = lwd[1], yaxt = "n"
    )

    if (inherits(x, "gsDesign") && test.type <= 2) {
      graphics::axis(2, seq(0, 1, 0.1))
      graphics::axis(4, seq(0, 1, 0.1))
    }
    else {
      graphics::axis(4, seq(0, 1, by = 0.1), col.axis = col[1], col = col[1])
      graphics::axis(2, seq(0, 1, .1), labels = 1 - seq(0, 1, .1), col.axis = col2, col = col2)
    }

    if (x$k == 1) {
      return(invisible(x))
    }

    if ((inherits(x, "gsDesign") && test.type > 2) || !inherits(x, "gsDesign")) {
      graphics::lines(xval, 1 - x$lower$prob[1, ], lty = lty2, col = col2, lwd = lwd2)
      plo <- x$lower$prob[1, ]

      for (i in 2:x$k)
      {
        plo <- plo + x$lower$prob[i, ]
        graphics::lines(xval, 1 - plo, lty = lty2, col = col2, lwd = lwd2)
      }

      temp <- legend("topleft",
        legend = c(" ", " "), col = col,
        text.width = max(graphics::strwidth(c("Upper", "Lower"))), lwd = lwd,
        lty = lty, xjust = 1, yjust = 1,
        title = "Boundary"
      )

      graphics::text(temp$rect$left + temp$rect$w, temp$text$y,
        c("Upper", "Lower"),
        col = col, pos = 2
      )
    }

    phi <- x$upper$prob[1, ]

    for (i in 2:x$k)
    {
      phi <- phi + x$upper$prob[i, ]
      graphics::lines(xval, phi, col = col[1], lwd = lwd[1], lty = lty[1])
    }
    colr <- rep(col[1], x$k)
    if (length(yt$theta) > x$k) colr <- c(colr, rep(col[2], x$k - 1))
    graphics::text(x = yt$theta, y = yt$prob, col = colr, yt$itxt, cex = cex)
    invisible(x)
  }
  else {
    p <- ggplot2::ggplot(
      data = subset(y, interim == 1),
      ggplot2::aes(
        x = theta, y = prob, group = factor(bound),
        col = factor(bound), lty = factor(bound)
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::scale_x_continuous(xlab) + 
      ggplot2::scale_y_continuous(ylab) +
      ggplot2::scale_colour_manual(name = "Bound", values = getColor(col)) +
      ggplot2::scale_linetype_manual(name = "Bound", values = lty)

      p <- p + ggplot2::ggtitle(label = main)

    if (test.type == 1) {
      p <- p + 
        ggplot2::scale_colour_manual(
        name = "Probability", values = getColor(col), breaks = 1,
        labels = "Upper bound"
      ) +
        ggplot2::scale_linetype_manual(
          name = "Probability", values = lty[1], breaks = 1,
          labels = "Upper bound"
        )

        p <- p + ggplot2::ggtitle(label = main)

    } else {
      p <- p + 
        ggplot2::scale_colour_manual(
        name = "Probability", values = getColor(col), breaks = 1:2,
        labels = c("Upper bound", "1-Lower bound")
      ) +
        ggplot2::scale_linetype_manual(
          name = "Probability", values = lty, breaks = 1:2,
          labels = c("Upper bound", "1-Lower bound")
        )
    }
    p <- p + 
      ggplot2::geom_text(data = yt, ggplot2::aes(theta, prob, colour = factor(bound), group = 1, label = itxt), size = cex * 5, show.legend = F)
    for (i in 1:x$k) p <- p + ggplot2::geom_line(
        data = subset(y, interim == i & bound == 1),
        colour = getColor(col[1]), lty = lty[1], lwd = lwd[1]
      )
    if (test.type > 2) {
      for (i in 1:(x$k - 1)) {
        p <- p + ggplot2::geom_line(data = subset(y, interim == i & bound == 2), colour = getColor(col[2]), lty = lty[2], lwd = lwd[2])
      }
    }
    return(p)
  }
}
