##################################################################################
#  S3 methods for the gsDesign package
#
#  Exported Functions:
#                   
#    plot.gsDesign
#    plot.gsProbability
#    print.gsDesign
#    print.gsProbability
#
#  Hidden Functions:
#
#    gsLegendText
#    gsPlotName
#    plotgsZ
#    plotBval
#    plotreleffect
#    plotgsCP
#    sfplot
#    plotASN
#    plotgsPower
#    sfprint
#
#  Author(s): Keaven Anderson, PhD.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
##################################################################################

###
# Exported Functions
###

"plot.gsDesign" <- function(x, plottype=1, ...)
{   
#   checkScalar(plottype, "integer", c(1, 7))
    invisible(do.call(gsPlotName(plottype), list(x, ...)))
}

"plot.gsProbability" <- function(x, plottype=2, ...)
{   
#   checkScalar(plottype, "integer", c(1, 7))    
    invisible(do.call(gsPlotName(plottype), list(x, ...)))
}

"print.gsProbability" <- function(x, ...)
{    
    ntxt <- "N "
    nval <- ceiling(x$n.I)
    nspace <- log10(x$n.I[x$k])
    for (i in 1:nspace)
    {
        cat(" ")
    }
    
    cat("            ")
    if (min(x$lower$bound) < 0)
    {
        cat(" ")
    }
    cat("Lower bounds   Upper bounds")
    y <- cbind(1:x$k, nval, round(x$lower$bound, 2), round(pnorm(x$lower$bound), 4), round(x$upper$bound, 2), 
            round(pnorm(-x$upper$bound), 4))
    colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Z  ", "Nominal p")
    rownames(y) <- array(" ", x$k)
    cat("\n")
    print(y)
    cat("\nBoundary crossing probabilities and expected sample size assuming any cross stops the trial\n\n")
    j <- length(x$theta)
    sump <- 1:j
    for (m in 1:j)
    {
        sump[m] <- sum(x$upper$prob[, m])
    }
    y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
    y[, x$k+3] <- round(y[, x$k+3], 1)
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
    cat("Upper boundary (power or Type I Error)\n")
    cat("          Analysis\n")
    print(y)
    
    for (m in 1:j) 
    {
        sump[m] <- sum(x$lower$prob[, m])
    }
    
    y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total")
    cat("\nLower boundary (futility or Type II Error)\n")
    cat("          Analysis\n")
    print(y)
}

"print.gsDesign" <- function(x, ...)
{    
    
    if (x$test.type == 1) 
    {
        cat("One-sided")
    }
    else if (x$test.type == 2)
    {
        cat("Symmetric two-sided")
    }
    else 
    {
        cat("Asymmetric two-sided")
    }
    
    cat(" group sequential design with", 100 * (1 - x$beta), "% power and", 100 * x$alpha, "% Type I Error.\n")
    if (x$test.type > 1)
    {    
        if (x$test.type==4 || x$test.type==6)
        {
            cat("Upper bound spending computations assume trial continues if lower bound is crossed.\n\n")            
        }
        else
        {
            cat("Spending computations assume trial stops if a bound is crossed.\n\n")
        }
    }
    if (x$n.fix != 1)
    {    
        ntxt <- "N "
        nval <- ceiling(x$n.I)
        nspace <- log10(x$n.I[x$k])
        for(i in 1:nspace)
        {
            cat(" ")
        }
        cat("            ")
    }
    else
    {    
        ntxt <- "Ratio*"
        nval <- round(x$n.I, 3)
        cat("           Sample\n")
        cat("            Size ")
    }
    if (x$test.type > 2) 
    {    
        if (min(x$lower$bound) < 0)
        {
            cat(" ")
        }
        cat("  ----Lower bounds----  ----Upper bounds-----")
        y <- cbind(1:x$k, nval, round(x$lower$bound, 2), round(pnorm(x$lower$bound), 4), 
                round(x$lower$spend, 4), round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4), 
                round(x$upper$spend, 4))
        colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend+", "Z  ", "Nominal p", "Spend++")
    }
    else
    {    y <- cbind(1:x$k, nval, round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4), 
                round(x$upper$spend, 4))
        colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend")
    }
    rownames(y) <- array(" ", x$k)
    cat("\n")
    print(y)
    cat("     Total")
    if (x$n.fix != 1)
    {    
        for (i in 1:nspace)
        {
            cat(" ")
        }
    }
    else 
    {
        cat("     ")
    }
    cat("                  ")
    
    if (x$test.type>2)
    {    
        if (min(x$lower$bound) < 0)
        {
            cat(" ")
        }
        cat(format(round(sum(x$lower$spend), 4), nsmall=4), "                ")
    }
    
    cat(format(round(sum(x$upper$spend), 4), nsmall=4), "\n")
    
    if (x$test.type > 4)
    {
        cat("+ lower bound spending (under H0): ")
    }
    else if (x$test.type > 2)
    {
        cat("+ lower bound beta spending (under H1): ")
    }
    
    if (x$test.type>2) 
    {
        sfprint(x$lower)
    }
    
    cat("++ alpha spending: ")
    sfprint(x$upper) 
    
    if (x$n.fix==1)
    {
        cat("* Sample size ratio compared to fixed non-group sequential design\n")
    }
    
    cat("\nBoundary crossing probabilities and expected sample size assuming any cross stops the trial\n\n")
    j <- length(x$theta)
    sump <- 1:j
    
    for (m in 1:j)
    {
        sump[m] <- sum(x$upper$prob[, m])
    }
    
    y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
    if (x$n.fix != 1)
    {
        y[, x$k+3] <- round(y[, x$k+3], 1)
    }
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
    cat("Upper boundary (power or Type I Error)\n")
    cat("          Analysis\n")
    print(y)
    if (x$test.type>1)
    {    
        for (m in 1:j) 
        {
            sump[m] <- sum(x$lower$prob[, m])
        }
        y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
        rownames(y) <- array(" ", j)
        colnames(y) <- c("Theta", 1:x$k, "Total")
        cat("\nLower boundary (futility or Type II Error)\n")
        cat("          Analysis\n")
        print(y)
    }
}

###
# Hidden Functions
###

"gsLegendText" <- function(test.type)
{
    switch(as.character(test.type), 
            "1" = c(expression(paste("Reject ", H[0])), "Continue"),
            "2" = c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[0]))),
            c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[1]))))            
}

"gsPlotName" <- function(plottype)
{
    # define plots and associated valid plot types
    plots <- list(plotgsZ=c("1","z"), 
            plotgsPower=c("2","power"), 
            plotreleffect=c("3","xbar","thetahat","theta"), 
            plotgsCP=c("4","cp"),
            sfplot=c("5","sf"), 
            plotASN=c("6","asn", "e{n}","n"), 
            plotBval=c("7","b","b-val","b-value"))
    
    # perform partial matching on plot type and return name
    plottype <- match.arg(tolower(as.character(plottype)), as.vector(unlist(plots)))
    names(plots)[which(unlist(lapply(plots, function(x, type) is.element(type, x), type=plottype)))]    
}

"plotgsZ" <- function(x, main="Group sequential stopping boundaries", ylab="Normal critical value", 
        xlab=ifelse(x$n.I[x$k] < 3, "Sample size relative to fixed design", "N"), 
        lty=1, col=1, pch=22, textcex=1, legtext=gsLegendText(test.type), ...)
{    
    test.type <- ifelse(is(x,"gsProbability"), 3, x$test.type)
    ymax <- ceiling(4 * max(x$upper$bound)) / 4    
    ymin <- ifelse(test.type == 1, floor(4 * min(x$upper$bound)) / 4, floor(4 * min(x$lower$bound)) / 4)
    
    if (ymin == ymax)
    {
        ymin <- ymin - .25
    }
    
    ymid <- (x$upper$bound[2] + x$lower$bound[2]) / 2

    if (test.type == 1)
    {    
        plot(x$n.I,  x$upper$bound,  xlab=xlab,  ylab=ylab,  main = main, 
                 ylim=c(ymin,  ymax),  type="l", ...)
        points(x$n.I,  x$upper$bound, ...)
        ymid <- ymin
    }
    else
    {    
        matplot(x$n.I,  cbind(x$lower$bound, x$upper$bound),  xlab=xlab,  ylab=ylab,  main = main, 
                 lty=lty, col=col, ylim=c(ymin,  ymax),  type="l", ...)        
        matpoints(x$n.I,  cbind(x$lower$bound, x$upper$bound), pch=pch, col=col, ...)
        text(x$n.I[2], ymin, legtext[3], cex=textcex)
    }
    
    text(x$n.I[2], ymid, legtext[2], cex=textcex)
    text(x$n.I[2], ymax, legtext[1], cex=textcex)
    
    invisible(x)
}

"plotBval" <- function(x, main="B-values at stopping boundaries", ylab="B-value", 
        xlab=ifelse(x$n.I[x$k] < 3, "Sample size relative to fixed design", "N"), 
        lty=1, col=1, pch=22, textcex=1, legtext=gsLegendText(test.type), ...)
{    
    test.type <- ifelse(is(x,"gsProbability"), 3, x$test.type)
    
    sqrtt <- sqrt(x$n.I / x$n.I[x$k])
    ymax <- ceiling(4 * max(sqrtt * x$upper$bound)) / 4
    ymin <- ifelse(test.type == 1, 0, min(0, floor(4 * min(sqrtt * x$lower$bound)) / 4))
        
    if (ymin == ymax)
    {
        ymin <- ymin - .25
    }
    
    ymid <- sqrtt[2] * (x$upper$bound[2] + x$lower$bound[2]) / 2
    
    if (test.type == 1)
    {    
        plot(x$n.I,  sqrtt * x$upper$bound,  xlab=xlab,  ylab=ylab,  main = main, 
                 ylim=c(ymin,  ymax),  xlim=c(0, x$n.I[x$k]), type="l", ...)
        points(x$n.I,  sqrtt * x$upper$bound, ...)
        ymid <- ymin
    }
    else
    {    
        matplot(x$n.I,  cbind(sqrtt * x$lower$bound, sqrtt * x$upper$bound),  xlab=xlab,  ylab=ylab,  main = main, 
                 lty=lty, col=col, ylim=c(ymin,  ymax),  xlim=c(0, x$n.I[x$k]), type="l", ...)
        matpoints(x$n.I,  cbind(sqrtt * x$lower$bound, sqrtt * x$upper$bound), pch=pch, col=col, ...)
        text(x$n.I[2], ymin, legtext[3], cex=textcex)
    }
    text(x$n.I[2], ymid, legtext[2], cex=textcex)
    text(x$n.I[2], ymax, legtext[1], cex=textcex)

    invisible(x)
}

"plotreleffect" <- function(x, main="Observed treatment effect at stopping boundaries", 
        ylab=ifelse(ses && is(x, "gsDesign"), expression(paste("Observed effect (", hat(theta) / delta, ")")),
                expression(paste("Observed effect (", hat(theta), ")"))), 
        xlab=ifelse(x$n.I[x$k] < 3, "Sample size relative to fixed design", "N"), 
        lty=1, col=1, pch=22, textcex=1, legtext=gsLegendText(test.type), ses=TRUE, ...)
{    
    test.type <- ifelse(is(x,"gsDesign"), x$test.type, 3)
    psi <- if (ses && is(x, "gsDesign")) 1 / x$delta else 1    
    thathi <- x$upper$bound / sqrt(x$n.I) * psi
    ymax <- ceiling(4 * max(thathi)) / 4
    
    if (test.type == 1) 
    {    
        ymid <- floor(4 * min(thathi)) / 4
        ymin <- ymid
    }
    else 
    {    
        thatlow <- x$lower$bound / sqrt(x$n.I) * psi
        ymin  <-  floor(4 * min(thatlow)) / 4
        ymid  <-  (thathi[2] + thatlow[2]) / 2
    
        if (ymin == ymax)
        {
            ymid <- ymid-.25
        }
    }
    
    if (test.type == 1)
    {    
        plot(x$n.I,  thathi,  xlab=xlab,  ylab=ylab,  main = main, 
                 ylim=c(ymin,  ymax),  type="l", ...)
        points(x$n.I,  thathi, ...)
    }
    else
    {    
        matplot(x$n.I,  cbind(thatlow, thathi),  xlab=xlab,  ylab=ylab,  main = main, 
                 lty=lty, col=col, ylim=c(ymin,  ymax),  type="l", ...)
        matpoints(x$n.I,  cbind(thatlow, thathi), pch=pch, col=col, ...)
        text(x$n.I[2], ymin, legtext[3], cex=textcex)
    }
    
    text(x$n.I[2], ymid, legtext[2], cex=textcex)
    text(x$n.I[2], ymax, legtext[1], cex=textcex)
    
    invisible(list(n.I=x$n.I, lower=thatlow, upper=thathi))
}

"plotgsCP" <- function(x, theta="thetahat", main="Conditional power at interim stopping boundaries", 
        ylab=ifelse(theta == "thetahat", expression(paste("Conditional power at", " ", theta, "=", hat(theta))),
                expression(paste("Conditional power at", " ", theta, "=", delta))), 
        xlab=ifelse(x$n.I[x$k] < 3, "Sample size relative to fixed design", "N"), 
        lty=1, col=1, pch=22, textcex=1, legtext=gsLegendText(test.type), ...)
{    
    test.type <- ifelse(is(x,"gsProbability"), 3, x$test.type)    
    y <- gsBoundCP(x, theta=theta)
    ymax <- 1.05
    ymin <- - 0.05
    
    if (x$k > 3)
    {
        xtext <- x$n.I[2]
    }
    else if (x$k == 3)
    {
        xtext <- (x$n.I[2] + x$n.I[1]) / 2
    }
    else
    {
        xtext <- x$n.I[1]
    }
    
    if (test.type > 1)
    {
        ymid <- (y[2, 2] + y[2, 1]) / 2
    }
    
    if (test.type == 1)
    {    
        plot(x$n.I[1:(x$k-1)], y,  xlab=xlab,  ylab=ylab,  main = main, 
                 ylim=c(ymin,  ymax),  type="l", ...)
        points(x$n.I[1:(x$k-1)],  y, ...)
        ymid <- ymin
    }
    else
    {    
        matplot(x$n.I[1:(x$k-1)],  y,  xlab=xlab,  ylab=ylab,  main = main, 
                 lty=lty, col=col, ylim=c(ymin,  ymax),  type="l", ...)
        matpoints(x$n.I[1:(x$k-1)],  y, pch=pch, col=col, ...)
        text(xtext, ymin, legtext[3], cex=textcex)
    }
    text(xtext, ymid, legtext[2], cex=textcex)
    text(xtext, 1.03, legtext[1], cex=textcex)
    
    invisible(x)
}

"sfplot" <- function(x, 
        xlab=ifelse(max(x$n.I) > 3, "N", "Proportion of total sample size"), 
        ylab=expression(paste(alpha, "-spending")), 
        ylab2=expression(paste(beta, "-spending")), oma=c(2, 2, 2, 2), 
        legtext=if (x$test.type > 4) c("Upper bound", "Lower bound") else c(expression(paste(alpha, "-spending")), 
                            expression(paste(beta, "-spending"))), 
        mai=c(.85, .75, .5, .5), lty=1:2, xmax=1, ...)
{
	# K. Wills (GSD-31)
	if (is(x, "gsProbability"))
	{
		stop("Spending function plot not available for gsProbability object")
	}
	
	# K. Wills (GSD-30)
	if (x$upper$name %in% c("WT", "OF", "Pocock") || x$upper$parname=="Points")
	{
		stop("Spending function plot not available for pointwise spending functions")
	}
	
    t <- 0:40 / 40 * xmax
            
    if (x$test.type > 2)
    {
        par(mai=mai, oma=oma) 
    }
    
    plot(t, x$upper$sf(x$alpha, t, x$upper$param)$spend, type="l", ylab=ylab, xlab=xlab, ...)
    
    if (x$test.type > 2)
    {    
#        if (is.character(legtext) && legtext != "") 
#        if (legtext != "") 
            legend(x=c(.0, .43), y=x$alpha * c(.85, 1), lty=lty, legend=legtext)
        par(new=TRUE)
        plot(t, x$lower$sf(x$beta, t, x$lower$param)$spend, ylim=c(0, x$beta), type="l", ylab="", main="", yaxt="n", xlab=xlab, lty=2)
        axis(4)
        mtext(text=ylab2,  side = 4, outer=TRUE)
    }
}

"plotASN" <- function(x, xlab=NULL, ylab=NULL, main=NULL, theta=NULL, xval=NULL, type="l", ...)
{    
    if (is(x, "gsDesign") && x$n.fix == 1) 
    {    
        if (is.null(ylab))
        {
            ylab <- "E{N} relative to fixed design"
        }
    
        if (is.character(main) && main == "Default")
        {
            main <- "Expected sample size relative to fixed design"
        }
    }
    
    if (is.null(ylab))
    {
        ylab <- "E{N} relative to fixed design"
    }
    
    if (is.null(main)) 
    {
        main <- "Expected sample size by treatment difference"
    }
    
    if (is.null(theta))
    {    
        if (is(x,"gsDesign"))
        {
            theta <- seq(0, 2, .05) * x$delta
        }
        else
        {
            theta <- x$theta
        }
    }

    if (is.null(xval))
    {    
        if (is(x, "gsDesign") && is.null(xlab))
        {    
            xval <- theta / x$delta
        
            if (is.null(xlab))
            {
                xlab <- expression(theta / delta)
            }
        }
        else
        {    
            xval <- theta
            
            if (is.null(xlab))
            {
                xlab <- expression(theta)
            }
        }    
    }
    
    if (is.null(xlab))
    {
        xlab <- ""
    }
    
    x <- if (is(x, "gsDesign")) gsProbability(d=x, theta=theta) else 
                gsProbability(k=x$k, a=x$lower$bound, b=x$upper$bound, n.I=x$n.I, theta=theta)
    
    plot(xval, x$en, type=type, ylab=ylab, xlab=xlab, main=main, ...)
    
    invisible(x)
}

"plotgsPower" <- function(x, main="Group sequential power plot", ylab="Boundary Crossing Probalities", xlab=NULL, 
                title="Boundary", legtext=c("Upper", "Lower"), lty=c(1, 2), col=c(1, 2), lwd=1, 
                theta=if (is(x, "gsDesign")) seq(0, 2, .05) * x$delta else x$theta, xval=NULL, ...)
{    
    if (is.null(xval))
    {    
        if (is(x, "gsDesign") && is.null(xlab))
        {    
            xval <- theta / x$delta
            xlab <- expression(theta/delta)
        }
        else
        {    
            xval <- theta
            if (is.null(xlab)) xlab <- expression(theta)    
        }    
    }

    if (is.null(xlab)) xlab <- ""
    
    x <- if (is(x, "gsDesign")) gsProbability(d=x, theta=theta) else 
                gsProbability(k=x$k, a=x$lower$bound, b=x$upper$bound, n.I=x$n.I, theta=theta)
    
    col2 <- ifelse(length(col) > 1, col[2], col)
    lwd2 <- ifelse(length(lwd) > 1, lwd[2], lwd)
    lty2 <- ifelse(length(lty) > 1, lty[2], lty)    
    
    ylim <- if (is(x, "gsDesign") && x$test.type<=2) c(0, 1) else c(0, 1.25)
    
    plot(xval,  x$upper$prob[1, ],  xlab=xlab,  main=main,  ylab=ylab, 
        ylim=ylim,  type="l",  col=col[1],  lty=lty[1],  lwd=lwd[1],  yaxt = "n")
    
    if (is(x, "gsDesign") && x$test.type <= 2)
    {    
        axis(2, seq(0, 1, 0.1))
        axis(4, seq(0, 1, 0.1))
    }
    else
    {    
        axis(4,  seq(0, 1,  by =0.1))
        axis(2, seq(0, 1, .1), labels=1 - seq(0, 1, .1), col.axis=col2, col=col2)
    }
    
    if (x$k == 1)
    {
        return(invisible(x))
    }
    
    if ((is(x, "gsDesign") && x$test.type > 2) || !is(x, "gsDesign"))
    {    
        lines(xval, 1-x$lower$prob[1, ], lty=lty2,  col=col2,  lwd=lwd2)
        plo <- x$lower$prob[1, ]
        
        for (i in 2:x$k)
        {    
            plo  <-  plo + x$lower$prob[i, ]
            lines(xval, 1 - plo, lty=lty2,  col=col2,  lwd=lwd2)
        }
        
        temp <- legend("topleft",  legend = c(" ",  " "),  col=col, 
                text.width = strwidth("Lower"),  lwd=lwd, 
                lty = lty,  xjust = 1,  yjust = 1, 
                title = title)
        
        text(temp$rect$left  +  temp$rect$w,  temp$text$y, 
                legtext,  col=col,  pos=2)
    }
    
    phi <- x$upper$prob[1, ]
    
    for (i in 2:x$k)
    {    
        phi <- phi + x$upper$prob[i, ]
        lines(xval, phi, col=col[1], lwd=lwd[1], lty=lty[1])
    }
    
    invisible(x)
}

"sfprint" <- function(x)
{    
    # print spending function information    
    if (x$name == "OF")
    {
        cat("O'Brien-Fleming boundary")
    }
    else if (x$name == "Pocock")
    {
        cat("Pocock boundary")
    }
    else if (x$name == "WT")
    {
        cat("Wang-Tsiatis boundary with Delta =", x$param)
    }
    else 
    {   
        cat(x$name, "spending function")
        if (!is.null(x$parname) && !is.null(x$param))
        {
            cat(" with", x$parname, "=", x$param)
        }
    }
    cat("\n")
}
