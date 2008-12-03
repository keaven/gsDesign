"print.gsProbability" <- function(x, ...)
{	
    # check for error
	if (x$errcode>0)
    {
        cat("gsProbability error: ", x$errcode, x$errmsg, "\n")
    }
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
    # check for error
    if (x$errcode > 0) 
    {   
        cat("gsDesign error: ", x$errcode, x$errmsg, "\n")
        return()
    }
    
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
    if (x$test.type>1)
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
    {	y <- cbind(1:x$k, nval, round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4), 
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
