##################################################################################
#  S3 methods for the gsDesign package
#
#  Exported Functions:
#                   
#    plot.gsDesign
#    plot.gsProbability
#    gsCPz
#    gsHR
#    gsRR
#    gsDelta
#    gsBValue
#    qplotit
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
#
#  Author(s): Keaven Anderson, PhD.
# 
#  Reviewer(s): 
#
#  R Version: 2.9.1
#
##################################################################################

#####
# global variables used to eliminate warnings in R CMD check
#####
globalVariables(c("y","N","Z","Bound","thetaidx","Probability","delta","Analysis"))

###
# Exported Functions
###

"plot.gsDesign" <- function(x, plottype=1, base=FALSE,...)
{   
#   checkScalar(plottype, "integer", c(1, 7))
   # if (base) invisible(do.call(gsPlotName(plottype), list(x, ...)))
     do.call(gsPlotName(plottype), list(x, base=base,...))
}

"plot.gsProbability" <- function(x, plottype=2, base=FALSE,...)
{   
#   checkScalar(plottype, "integer", c(1, 9))
	y <- x
	if (max(x$n.I)>3) y$n.fix<-max(x$n.I)
	else y$n.fix<-1
	y$nFixSurv <- 0
	y$test.type <- 3
	y$timing <- y$n.I/max(y$n.I)
	do.call(gsPlotName2(plottype), list(y, base=base,...))
}

###
# Hidden Functions
###
"gsPlotName" <- function(plottype)
{
    # define plots and associated valid plot types
    plots <- list(plotgsZ=c("1","z"), 
            plotgsPower=c("2","power"), 
            plotreleffect=c("3","xbar","thetahat","theta"), 
            plotgsCP=c("4", "cp", "copp"),
            plotsf=c("5","sf"), 
            plotASN=c("6","asn", "e{n}","n"), 
            plotBval=c("7","b","b-val","b-value"),
            plotHR=c("8","hr","hazard"),
            plotRR=c("9","rr"))
    
    # perform partial matching on plot type and return name
    plottype <- match.arg(tolower(as.character(plottype)), as.vector(unlist(plots)))
    names(plots)[which(unlist(lapply(plots, function(x, type) is.element(type, x), type=plottype)))]    
}
"gsPlotName2" <- function(plottype)
{
    # define plots and associated valid plot types
    plots <- list(plotgsZ=c("1","z"), 
            plotgsPower=c("2","power"), 
            plotgsCP=c("4", "cp", "copp"),
            plotASN=c("6","asn", "e{n}","n"), 
            plotBval=c("7","b","b-val","b-value"),
            plotHR=c("8","hr","hazard"),
            plotRR=c("9","rr"))

    # perform partial matching on plot type and return name
    plottype <- match.arg(tolower(as.character(plottype)), as.vector(unlist(plots)))
    names(plots)[which(unlist(lapply(plots, function(x, type) is.element(type, x), type=plottype)))]    
}
"plotgsZ" <- function(x, ylab="Normal critical value",main="Normal test statistics at bounds",...){qplotit(x=x,ylab=ylab,main=main,fn=function(z,...){z},...)}
"plotBval" <- function(x, ylab="B-value", main="B-values at bounds",...){qplotit(x=x, fn=gsBValue, ylab=ylab, main=main, ...)}
"plotreleffect" <- function(x=x, ylab=NULL, main="Treatment effect at bounds",...){
    qplotit(x, fn=gsDelta, main=main, ylab=ifelse(!is.null(ylab), ylab, 
            ifelse(tolower(x$endpoint)=="binomial",
                   expression(hat(p)[C]-hat(p)[E]), 
                   expression(hat(theta)/theta[1]))),...)
}
"plotHR" <- function(x=x, ylab="Estimated hazard ratio",main="Hazard ratio at bounds",...){qplotit(x, fn=gsHR,  ylab=ylab, main=main, ratio=1, ...)}
"plotRR" <- function(x=x, ylab="Estimated risk ratio",main="Risk ratio at bounds",...){qplotit(x, fn=gsRR,  ylab=ylab, main=main, ratio=1, ...)}
gsBValue <- function(z,i,x,ylab="B-value",...)
{   Bval <- z * sqrt(x$timing[i])
    Bval
}
gsDelta <- function(z, i, x, ylab=NULL,...)
{   deltaHat <- z / sqrt(x$n.I[i]) * (x$delta1-x$delta0) / x$delta + x$delta0
    deltaHat
}
gsRR <- function(z, i, x, ratio=1, ylab="Estimated risk ratio",...)
{   deltaHat <- z / sqrt(x$n.I[i]) * (x$delta1-x$delta0) / x$delta + x$delta0
    exp(deltaHat)
}
gsHR <- function(z, i, x, ratio=1, ylab="Estimated hazard ratio", ...)
{    c <- 1 / (1 + ratio)
     psi <- c * (1 - c)
     if (is.null(x$hr0)) x$hr0 <- 1
     hrHat <- exp(-z / sqrt(x$n.I[i] * psi)) * x$hr0
     hrHat
}
gsCPz <- function(z, i, x, theta=NULL, ylab=NULL, ...)
{	cp <- array(0,length(z))
	if (is.null(theta)) theta <- z / sqrt(x$n.I[i])
	if (length(theta)==1 && length(z)>1) theta <- array(theta,length(z))
	for(j in 1:length(z))
	{	cp[j] <- sum(gsCP(x=x, theta=theta[j], i=i[j], zi=z[j])$upper$prob)
	}
	cp
}
# qplots for z-values and transforms of z-values
"qplotit" <- function(x, xlim=NULL, ylim=NULL, main=NULL, geom=c("line", "text"), 
                     dgt=c(2,2), lty=c(2,1), col=c(1,1),
                     lwd=c(1,1), nlabel="TRUE", xlab=NULL, ylab=NULL, fn=function(z,i,x,...){z},
                     ratio=1, delta0=0, delta=1, cex=1, base=FALSE,...)
{  ggver <- as.numeric_version(packageVersion('ggplot2'))
   if (length(lty)==1) lty <- array(lty, 2)
   if (length(col)==1) col <- array(col, 2)
   if (length(lwd)==1) lwd <- array(lwd, 2)
   if (length(dgt)==1) dgt <- array(dgt, 2)
   if(x$n.fix == 1) 
   {   nround <- 3 
       ntx <- "r="
       if (is.null(xlab)) xlab <- "Information relative to fixed sample design"
   }else if (x$nFixSurv > 0)
   {   ntx <- "d="
       nround <- 0
       if (is.null(xlab)) xlab <- "Number of events"
   }else
   {   nround <- 0
       ntx <- "n="
       if (is.null(xlab)) xlab <- "Sample size"
   }
   if (x$test.type > 1)
   {  z <- fn(z=c(x$upper$bound, x$lower$bound), i=c(1:x$k,1:x$k), x=x,
                  ratio=ratio, delta0=delta0, delta=delta)
		Ztxt <- as.character(c(round(z[1:x$k],dgt[2]), round(z[x$k+(1:x$k)], dgt[1])))
		# use maximum digits for equal final bounds
		if (x$upper$bound[x$k]==x$lower$bound[x$k])
		{	Ztxt[c(x$k,2*x$k)] <- round(z[x$k],max(dgt))
		}
      	indxu <- (1:x$k)[x$upper$bound < 20]
      	indxl <- (1:x$k)[x$lower$bound > -20]
		y <- data.frame(
				N=as.numeric(c(x$n.I[indxu],x$n.I[indxl])), 
				Z=as.numeric(z[c(indxu,x$k+indxl)]), 
				Bound=c(array("Upper", length(indxu)), array("Lower", length(indxl))),
				Ztxt=Ztxt[c(indxu,x$k+indxl)])
	}else{
		z <- fn(z=x$upper$bound, i=1:x$k, x=x,
               ratio=ratio, delta0=delta0, delta=delta)
		Ztxt <- as.character(round(z,dgt[1]))
		y <- data.frame(
				N=as.numeric(x$n.I), 
				Z=as.numeric(z), 
				Bound=array("Upper", x$k),
				Ztxt=Ztxt)
	}
   if (!is.numeric(ylim))
   {   ylim <- range(y$Z)
       ylim[1] <- ylim[1]  -.1 * (ylim[2] - ylim[1])
   }
   if (!is.numeric(xlim))
   {   xlim <- range(x$n.I)
       xlim <- xlim + c(-.05,.05) * (xlim[2] - xlim[1])
   }
	if (base==TRUE)
	{	plot(x=y$N[y$Bound=="Upper"], y=y$Z[y$Bound=="Upper"], type="l", xlim=xlim, ylim=ylim,
			main=main, lty=lty[1], col=col[1], lwd=lwd[1], xlab=xlab, ylab=ylab,...)
		lines(x=y$N[y$Bound=="Lower"], y=y$Z[y$Bound=="Lower"], lty=lty[2], col=col[2], lwd=lwd[2])
	}else
	{	lbls <- c("Lower", "Upper")
		if (x$test.type > 1)
		{ p <- ggplot(data=y, aes(x=as.numeric(N), y=as.numeric(Z), group=factor(Bound),
            	col=factor(Bound), label=Ztxt, lty=factor(Bound))) +
            	geom_text(show.legend=F,size=cex*5)+geom_line()  +
            	scale_x_continuous(xlab)+scale_y_continuous(ylab) +
  			scale_colour_manual(name= "Bound", values=col, labels=lbls, breaks=lbls) +
			scale_linetype_manual(name= "Bound", values=lty, labels=lbls, breaks=lbls)
      if (ggver >= as.numeric_version("0.9.2"))
      {  p <- p + ggtitle(label=main)}else{
         p <- p + opts(title=main)
      }
		}else{
			p <- ggplot(aes(x=as.numeric(N), y=as.numeric(Z), label=Ztxt, group=factor(Bound)), data=y) + 
					geom_line(colour=col[1], lty=lty[1], lwd=lwd[1]) +
					geom_text(size=cex*5) + xlab(xlab) + ylab(ylab) 
			if (ggver >= as.numeric_version("0.9.2"))
			{  p <- p + ggtitle(label=main)}else{
			  p <- p + opts(title=main)
			}
		}
	}
	if (nlabel==TRUE)
	{	y2 <- data.frame(
					N=as.numeric(x$n.I), 
					Z=as.numeric(array(ylim[1], x$k)), 
					Bound=array("Lower", x$k),
					Ztxt=ifelse(array(nround,x$k) > 0, as.character(round(x$n.I, nround)), ceiling(x$n.I)))
		if (base)
		{	text(x=y2$N, y=y$Z, y$Ztxt, cex=cex)
		}
		if (x$n.fix == 1)
		{	if (base)
			{	text(x=y2$N, y=y2$Z, paste(array("r=",x$k), y2$Ztxt, sep=""), cex=cex)
			}else
			{	y2$Ztxt <- paste(array("r=",x$k), y2$Ztxt, sep="")
				p <- p + geom_text(data=y2, aes(group=factor(Bound), label=Ztxt), size=cex*5, show.legend=F, colour=1)
			}
		}else
		{	if(base)
			{	text(x=y2$N, y=y2$Z, paste(array("N=",x$k), y2$Ztxt, sep=""), cex=cex)
			}else
			{	y2$Ztxt <- paste(array("N=",x$k), y2$Ztxt, sep="")
				p <- p + geom_text(data=y2, aes(group=factor(Bound),label=Ztxt), size=cex*5, show.legend=F, colour=1)
			}
	}	}
	if (base)
	{	invisible(x)
	}else
	{	return(p)
	}
}

"plotgsCP" <- function(x, theta="thetahat", main="Conditional power at interim stopping boundaries", 
        ylab=NULL, geom=c("line","text"),
        xlab=ifelse(x$n.fix == 1, "Sample size relative to fixed design", "N"), xlim=NULL,
        lty=c(1,2), col=c(1,1), lwd=c(1,1), pch=" ", cex=1, legtext=NULL,  dgt=c(3,2), nlabel=TRUE, 
        base=FALSE,...)
{  ggver <- as.numeric_version(packageVersion('ggplot2'))
   if (length(lty)==1) lty <- array(lty, 2)
   if (length(col)==1) col <- array(col, 2)
   if (length(lwd)==1) lwd <- array(lwd, 2)
   if (length(dgt)==1) dgt <- array(dgt, 2)
	if (x$k == 2) stop("No conditional power plot available for k=2")
# switch order of parameters
	lty <- lty[2:1]
	col <- col[2:1]
	lwd <- lwd[2:1]
	dgt <- dgt[2:1]
	if (is.null(ylab))
	{	ylab <- ifelse(theta == "thetahat",
                       expression(paste("Conditional power at",
                          theta, " = ", hat(theta),sep=" ")),
                       "Conditional power")
	}
	if (!is.numeric(xlim))
	{	xlim <- range(x$n.I[1:(x$k-1)])
		xlim <- xlim + c(-.05,.05) * (xlim[2] - xlim[1])
		if (x$k==2) xlim=xlim+c(-1, 1)
	}
	if(x$n.fix == 1) 
	{	nround <- 3 
		ntx <- "r="
		if (is.null(xlab)) xlab <- "Information relative to fixed sample design"
	}else 
	{	nround <- 0
		ntx <- "n="
		if (is.null(xlab)) xlab <- "N"
	}
	test.type <- ifelse(is(x,"gsProbability"), 3, x$test.type)    
	if (is.null(legtext)) legtext <- gsLegendText(test.type)
	y <- gsBoundCP(x, theta=theta)
	ymax <- 1.05
	ymin <- - 0.1
    
    if (x$k > 3)
    {   xtext <- x$n.I[2]
    }else if (x$k == 3)
    {   xtext <- (x$n.I[2] + x$n.I[1]) / 2
    }else xtext <- x$n.I[1]
    
    if (test.type > 1)
    {
        if (x$k > 2) ymid <- (y[2, 2] + y[2, 1]) / 2
        else ymid <- mean(y)
    }
    
	if (base)
    {	if (test.type == 1)
		{    
			plot(x$n.I[1:(x$k-1)], y,  xlab=xlab,  ylab=ylab,  main = main, 
				ylim=c(ymin,  ymax),  xlim=xlim, col=col[1], lwd=lwd[1], lty=lty[1], type="l", ...)
			points(x$n.I[1:(x$k-1)],  y, ...)
			text(x$n.I[1:(x$k-1)], y, as.character(round(y,dgt[2])), cex=cex)
			ymid <- ymin
		}
		else
		{    
			matplot(x$n.I[1:(x$k-1)],  y,  xlab=xlab,  ylab=ylab,  main = main, 
				lty=lty, col=col, lwd=lwd, ylim=c(ymin,  ymax), xlim=xlim,  type="l", ...)
				matpoints(x$n.I[1:(x$k-1)],  y, pch=pch, col=col, ...)
				text(xtext, ymin, legtext[3], cex=cex)
				text(x$n.I[1:(x$k-1)], y[,1], as.character(round(y[,1],dgt[1])), col=col[1], cex=cex)
				text(x$n.I[1:(x$k-1)], y[,2], as.character(round(y[,2],dgt[2])), col=col[2], cex=cex)
		}
		text(xtext, ymid, legtext[2], cex=cex)
		text(xtext, 1.03, legtext[1], cex=cex)
	}else
	{	N <- as.numeric(x$n.I[1:(x$k-1)])
		if (test.type > 1) CP <- y[,2]
		else CP <- y 
		Bound <- array("Upper", x$k-1)
		Ztxt <- as.character(round(CP[1:(x$k-1)], dgt[2]))
		if (test.type > 1)
		{	N <- c(N, N)
			CP <- c(CP, y[,1])
			Bound <- c(Bound, array("Lower", x$k-1))
			Ztxt <- as.character(c(Ztxt ,round(y[,1],dgt[1])))
		}
		y <- data.frame(N=N, CP=CP, Bound=Bound, Ztxt=Ztxt)
		if (test.type > 1)
		{	lbls <- c("Lower","Upper")
      p <- ggplot(data=y, aes(x=as.numeric(N), y=as.numeric(CP), group=factor(Bound),
        col=factor(Bound), label=Ztxt, lty=factor(Bound))) +
        geom_text(show.legend=F, size=cex*5)+geom_line() + 
        scale_x_continuous(xlab)+scale_y_continuous(ylab)  +
  	    scale_colour_manual(name= "Bound", values=col, labels=lbls, breaks=lbls) +
		    scale_linetype_manual(name= "Bound", values=lty, labels=lbls, breaks=lbls)
		  if (ggver >= as.numeric_version("0.9.2"))
		  {  p <- p + ggtitle(label=main)}else{
		    p <- p + opts(title=main)
		  }
		}else 
		{ #p <- qplot(x=as.numeric(N), y=as.numeric(CP), data=y, main=main,
			#	label=Ztxt, geom="text",
			#	xlab=xlab, ylab=ylab, ylim=c(ymin, ymax), xlim=xlim) + geom_line(colour=col[1],lty=lty[1],lwd=lwd[1])
  		p <- ggplot(aes(x=as.numeric(N), y=as.numeric(CP), label=Ztxt, group=factor(Bound)), data=y) + 
					geom_line(colour=col[1], lty=lty[1], lwd=lwd[1]) +
					geom_text(size=cex*5) +	xlab(xlab) + ylab(ylab) 
  		if (ggver >= as.numeric_version("0.9.2"))
  		{  p <- p + ggtitle(label=main)}else{
  		  p <- p + opts(title=main)
  		}
		}	}   
	if (nlabel==TRUE)
	{	y2 <- data.frame(
					N=x$n.I[1:(x$k-1)], 
					CP=array(ymin/2, x$k-1), 
					Bound=array("Lower", x$k-1),
					Ztxt=as.character(round(x$n.I[1:(x$k-1)],nround)))
		if (x$n.fix == 1)
		{	if (base)
			{	text(x=y2$N, y=y2$CP, paste(array("r=",x$k), y2$Ztxt, sep=""), cex=cex)
			}else
			{	y2$Ztxt <- paste(array("r=",x$k-1), y2$Ztxt, sep="")
				p <- p + geom_text(data=y2, aes(N,CP, group=factor(Bound),label=Ztxt), size=cex*5, colour=1)
			}
		}else
		{	if(base)
			{	text(x=y2$N, y=y2$CP, paste(array("N=",x$k), y2$Ztxt, sep=""), cex=cex)
			}else
			{	y2$Ztxt <- paste(array("N=",x$k-1), y2$Ztxt, sep="")
				p <- p + geom_text(data=y2, aes(N,CP, group=factor(Bound),label=Ztxt), size=cex*5, colour=1)
			}
	}	}
	if (base)
	{	invisible(x)
	}else
	{	return(p)
	}
}
"plotsf" <- function(x, 
	xlab="Proportion of total sample size", 
	ylab=NULL, main="Spending function plot",
	ylab2=NULL, oma=c(2, 2, 2, 2),
	legtext=NULL, 
	col=c(1,1), lwd=c(.5,.5), lty=c(1,2),
	mai=c(.85, .75, .5, .5), xmax=1, base=FALSE,...)
{ ggver <- as.numeric_version(packageVersion('ggplot2'))
 	if (is.null(legtext))
	{	if (x$test.type > 4) legtext <- c("Upper bound", "Lower bound") 
		else legtext <- c(expression(paste(alpha, "-spending")), expression(paste(beta, "-spending")))
	}
	if (is.null(ylab))
	{  if (base==F &&  x$test.type > 2) ylab <- "Proportion of spending"
		else ylab <- expression(paste(alpha, "-spending"))
	}
	if (is.null(ylab2)) 
	{	if (x$test.type > 4) ylab2 <- "Proportion of spending"
		else ylab2 <- expression(paste(beta, "-spending"))
	}
	if (length(lty)==1) lty <- array(lty, 2)
	if (length(col)==1) col <- array(col, 2)
	if (length(lwd)==1) lwd <- array(lwd, 2)

	# K. Wills (GSD-31)
	if (is(x, "gsProbability"))
	{
		stop("Spending function plot not available for gsProbability object")
	}
	
	# K. Wills (GSD-30)
	if (x$upper$name %in% c("WT", "OF", "Pocock"))
	{
		stop("Spending function plot not available for boundary families")
	}
#	if (x$upper$parname == "Points"){x$sfupar <- sfLinear} 

	t <- 0:40 / 40 * xmax
            
	if (x$test.type > 2 && base)
	{
		par(mai=mai, oma=oma) 
	}
	if (base) 
	{	plot(t, x$upper$sf(x$alpha, t, x$upper$param)$spend, type="l", ylab=ylab, xlab=xlab, lty=lty[1],
           lwd=lwd[1], col=col[1], main=main,...)
	}
	else if (x$test.type < 3)
	{	spend <- x$upper$sf(x$alpha, t, x$upper$param)$spend
		q <- data.frame(t=t, spend=spend)
		p <- qplot(x=t, y=spend, data=q, geom="line", ylab=ylab, xlab=xlab, main=main,...)
		return(p)
	}

	if (x$test.type > 2)
	{    
		if (base)
		{	legend(x=c(.0, .43), y=x$alpha * c(.85, 1), lty=lty, col=col, lwd=lwd, legend=legtext)
			par(new=TRUE)
			plot(t, x$lower$sf(x$beta, t, x$lower$param)$spend,
					ylim=c(0, x$beta), type="l", ylab=ylab,
					yaxt="n", xlab=xlab, lty=lty[2], lwd=lwd[2], col=col[2], main=main,...)
			axis(4)
			mtext(text=ylab2,  side = 4, outer=TRUE)
		}else
		{	spenda <- x$upper$sf(x$alpha, t, x$upper$param)$spend/x$alpha
			if (x$test.type < 5)
			{	spendb <- x$lower$sf(x$beta, t, x$lower$param)$spend/x$beta
			}else
			{	spendb <- x$lower$sf(x$astar, t, x$lower$param)$spend/x$astar
			}
			group <- array(1, length(t))
			q <- data.frame(t=c(t,t), spend=c(spenda, spendb), group=c(group,2*group))
			p <- qplot(x=t, y=spend, data=q, geom="line", ylab=ylab, xlab=xlab, main=main, 
							group=factor(group), linetype=factor(group), colour=factor(group)) 
			p <- p +
				scale_colour_manual(name="Spending",values=col,
					labels=c(expression(alpha),ifelse(x$test.type<5,expression(beta),expression(1-alpha))), breaks=1:2) +
				scale_linetype_manual(name="Spending",values=lty,
					labels=c(expression(alpha),ifelse(x$test.type<5,expression(beta),expression(1-alpha))), breaks=1:2)
			return(p)
		}
	}
}
"plotASN" <- function(x, xlab=NULL, ylab=NULL, main=NULL, theta=NULL, xval=NULL, type="l", 
                      base=FALSE,...)
{    
  if (is(x, "gsDesign") && x$n.fix == 1) 
  {    
    if (is.null(ylab)) ylab <- "E{N} relative to fixed design"
    if (is.null(main)) main <- "Expected sample size relative to fixed design"
  }
  else if (is(x, "gsSurv"))
  {
    if (is.null(ylab)) ylab <- "Expected number of events"
    if (is.null(main)) main <- "Expected number of events by underlying hazard ratio"
  }
  else  
  {
    if (is.null(ylab)) ylab <- "Expected sample size"
    if (is.null(main)) main <- "Expected sample size by underlying treatment difference"
  }
  
  if (is.null(theta))
  {    
    if (is(x,"gsDesign")) theta <- seq(0, 2, .05) * x$delta
    else theta <- x$theta
  }
  
  if (is.null(xval)){
    if (is(x, "gsDesign")){
      xval <- x$delta0 + (x$delta1-x$delta0)*theta/x$delta
      if (is(x, "gsSurv")){
        xval <- exp(xval)
        if (is.null(xlab)) xlab <- "Hazard ratio"
      }else if (is.null(xlab)) xlab <- expression(delta)
    }else{
      xval <- theta
      if (is.null(xlab)) xlab <- expression(theta)
    }
  }
  
  x <- if (is(x, "gsDesign")) gsProbability(d=x, theta=theta) else 
    gsProbability(k=x$k, a=x$lower$bound, b=x$upper$bound, n.I=x$n.I, theta=theta)
  
  if (is.null(ylab))
  {
    if (max(x$n.I) < 3) ylab <- "E{N} relative to fixed design"
    else ylab <- "Expected sample size"
  }
  if (base) 
  {  plot(xval, x$en, type=type, ylab=ylab, xlab=xlab, main=main,...)
     return(invisible(x))
  }
  else
  {  q <- data.frame(x=xval, y=x$en)
     p <- qplot(x=x, y=y, data=q, geom="line", ylab=ylab, xlab=xlab, main=main)
     return(p)
  }
}
"plotgsPower" <- function(x, main="Boundary crossing probabilities by effect size",
                          ylab="Cumulative Boundary Crossing Probability",
                          xlab=NULL, lty=NULL, col=NULL, lwd=1, cex=1,
                          theta=if (is(x, "gsDesign")) seq(0, 2, .05) * x$delta else x$theta, 
                          xval=NULL, base=FALSE, outtype=1,...)
{  ggver <- as.numeric_version(packageVersion('ggplot2'))
   if (is.null(xval)){
     if (is(x, "gsDesign")){
       xval <- x$delta0 + (x$delta1-x$delta0)*theta/x$delta
       if (is(x, "gsSurv")){
         xval <- exp(xval)
         if (is.null(xlab)) xlab <- "Hazard ratio"
       }else if (is.null(xlab)) xlab <- expression(delta)
     }else{
       xval <- theta
       if (is.null(xlab)) xlab <- expression(theta)
     }
   }
   if (is.null(xlab)) xlab <- ""
   x <- if (is(x, "gsDesign")) gsProbability(d=x, theta=theta) else 
     gsProbability(k=x$k, a=x$lower$bound, b=x$upper$bound, n.I=x$n.I, theta=theta)
   test.type <- ifelse(is(x,"gsProbability"), 3, x$test.type)
   theta <- xval
   if (!base && outtype==1){
     if (is.null(lty)) lty <- x$k:1
     xu <-data.frame(x$upper$prob)
     y <- cbind(reshape(xu, varying=names(xu), v.names="Probability", timevar="thetaidx",direction="long"), Bound="Upper bound")
     if (is.null(col)) col<-1
     if (is.null(x$test.type) || x$test.type > 1){
       y <- rbind(
         cbind(reshape(data.frame(x$lower$prob), varying=names(xu), v.names="Probability", timevar="thetaidx", direction="long"), Bound="1-Lower bound"),
         y)
       if (length(col)==1) col <- c(2,1)
     }
     y2 <- ddply(y, .(Bound, thetaidx),summarize,Probability=cumsum(Probability))
     y2$Probability[y2$Bound=="1-Lower bound"]<-1-y2$Probability[y2$Bound=="1-Lower bound"]  
     y2$Analysis <- factor(y$id)
     y2$delta <- xval[y$thetaidx]
     p <- ggplot(y2,aes(x=delta,y=Probability,col=Bound,lty=Analysis))+geom_line(size=lwd)+ylab(ylab) +
       guides(color=guide_legend(title="Probability")) + xlab(xlab) +
       scale_linetype_manual(values=lty) +
       scale_color_manual(values=col) +
       scale_y_continuous(breaks=seq(0,1,.2))
     if (ggver >= as.numeric_version("0.9.2")) return(p+ggtitle(label=main))
     else return(p + opts(title=main))
   }
   if (is.null(col)){
     if (base || outtype==2) col <- c(1,2)
     else col <- c(2,1)
   }
   if (length(col==1)) col=array(col,2)
   if (is.null(lty)){
     if(base || outtype==2) lty <- c(1,2)
     else lty <- c(2,1)
   }
   if (length(lty==1)) lty=array(lty,2)
   if (length(lwd==1)) lwd=array(lwd,2)
   
   
   interim <- array(1,length(xval))
   bound <- array(1,length(xval)*x$k)
   boundprob <- x$upper$prob[1,]
   prob <- boundprob
   yval <- min(mean(range(x$upper$prob[1,])))
   xv <- ifelse(xval[2]>xval[1],min(xval[boundprob>=yval]),max(xval[boundprob>=yval]))
   for(j in 2:x$k)
   {	theta <- c(theta, xval)
     interim <- c(interim, array(j, length(xval)))
     boundprob <- boundprob + x$upper$prob[j,]
     prob <- c(prob, boundprob)
     ymid <- mean(range(boundprob))
     yval <- c(yval, min(boundprob[boundprob >= ymid]))
     xv <- c(xv, ifelse(xval[2]>xval[1],min(xval[boundprob >= ymid]),max(xval[boundprob>=ymid])))
   }
   itxt <- array("Interim",x$k-1)
   itxt <- paste(itxt,1:(x$k-1),sep=" ")
   
   if (is(x, "gsProbability") || (is(x, "gsDesign") && test.type > 1))
   {
     itxt <- c(itxt,"Final",itxt)
     boundprob <- array(1, length(xval))
     bound <- c(bound, array(2, length(xval)*(x$k-1)))
     for(j in 1:(x$k-1))
     {	theta <- c(theta, xval)
       interim <- c(interim, array(j, length(xval)))
       boundprob <- boundprob - x$lower$prob[j,]
       prob <- c(prob, boundprob)
       ymid <- mean(range(boundprob))
       yval <- c(yval, min(boundprob[boundprob >= ymid]))
       xv <- c(xv, ifelse(xval[2]>xval[1], min(xval[boundprob >= ymid]), max(xval[boundprob>=ymid])))
     }
   }else {itxt <- c(itxt,"Final")}
   y <- data.frame(theta=as.numeric(theta), interim=interim, bound=bound, prob=as.numeric(prob),
                   itxt=as.character(round(prob,2)))
   y$group=(y$bound==2)*x$k + y$interim
   bound <- array(1, x$k)
   interim <- 1:x$k
   if (test.type > 1)
   {	bound <- c(bound, array(2, x$k-1))
     interim <- c(interim, 1:(x$k-1))
   }
   yt <- data.frame(theta=xv, interim=interim, bound=bound, prob=yval, itxt=itxt)
   bound <- array(1, x$k)
   interim <- 1:x$k
   if (test.type > 1)
   {	bound <- c(bound, array(2, x$k-1))
     interim <- c(interim, 1:(x$k-1))
   }
   yt <- data.frame(theta=xv, interim=interim, bound=bound, prob=yval, itxt=itxt)
   if (base)    
   {	col2 <- ifelse(length(col) > 1, col[2], col)
     lwd2 <- ifelse(length(lwd) > 1, lwd[2], lwd)
     lty2 <- ifelse(length(lty) > 1, lty[2], lty)    
     
     ylim <- if (is(x, "gsDesign") && test.type<=2) c(0, 1) else c(0, 1.25)
     
     plot(xval, x$upper$prob[1, ], xlab=xlab, main=main, ylab=ylab, 
          ylim=ylim, type="l", col=col[1], lty=lty[1], lwd=lwd[1], yaxt = "n")
     
     if (is(x, "gsDesign") && test.type <= 2)
     {    
       axis(2, seq(0, 1, 0.1))
       axis(4, seq(0, 1, 0.1))
     }
     else
     {    
       axis(4, seq(0, 1, by=0.1), col.axis=col[1], col=col[1])
       axis(2, seq(0, 1, .1), labels=1 - seq(0, 1, .1), col.axis=col2, col=col2)
     }
     
     if (x$k == 1)
     {
       return(invisible(x))
     }
     
     if ((is(x, "gsDesign") && test.type > 2) || !is(x, "gsDesign"))
     {    
       lines(xval, 1-x$lower$prob[1, ], lty=lty2,  col=col2,  lwd=lwd2)
       plo <- x$lower$prob[1, ]
       
       for (i in 2:x$k)
       {    
         plo  <-  plo + x$lower$prob[i, ]
         lines(xval, 1 - plo, lty=lty2,  col=col2,  lwd=lwd2)
       }
       
       temp <- legend("topleft",  legend = c(" ",  " "),  col=col, 
                      text.width = max(strwidth(c("Upper","Lower"))),  lwd=lwd, 
                      lty = lty,  xjust = 1,  yjust = 1, 
                      title = "Boundary")
       
       text(temp$rect$left  +  temp$rect$w,  temp$text$y, 
            c("Upper","Lower"),  col=col,  pos=2)
     }
     
     phi <- x$upper$prob[1, ]
     
     for (i in 2:x$k)
     {    
       phi <- phi + x$upper$prob[i, ]
       lines(xval, phi, col=col[1], lwd=lwd[1], lty=lty[1])
     }
     colr <- array(col[1], x$k)
     if (length(yt$theta)>x$k) colr<-c(colr,array(col[2],x$k-1))
     text(x=yt$theta, y=yt$prob, col=colr, yt$itxt, cex=cex)
     invisible(x)
   }
   else
   {	p <- ggplot(data=subset(y,interim==1), 
                 aes(x=theta, y=prob, group=factor(bound),
                     col=factor(bound), lty=factor(bound))) +
       geom_line() +
       scale_x_continuous(xlab)+scale_y_continuous(ylab) +
       scale_colour_manual(name= "Bound", values=col) +
       scale_linetype_manual(name= "Bound",  values=lty)
     if (ggver >= as.numeric_version("0.9.2"))
     {	p <- p + ggtitle(label=main)}else{
       p <- p + opts(title=main)
     }
     if(test.type == 1)
     {	p <- p + scale_colour_manual(name= "Probability", values=col, breaks=1,
                                    labels="Upper bound") +
         scale_linetype_manual(name="Probability", values=lty[1], breaks=1,
                               labels="Upper bound")
       if (ggver >= as.numeric_version("0.9.2"))
       {	p <- p + ggtitle(label=main)}else{
         p <- p + opts(title=main)
       }
     }else{
       p <- p + scale_colour_manual(name= "Probability", values=col, breaks=1:2,
                                    labels=c("Upper bound","1-Lower bound")) +
         scale_linetype_manual(name="Probability", values=lty, breaks=1:2,
                               labels=c("Upper bound","1-Lower bound"))
     }
     p <- p + geom_text(data=yt, aes(theta, prob, colour=factor(bound), group=1, label=itxt), size=cex*5, show.legend=F)
     for(i in 1:x$k) p <- p + geom_line(data=subset(y,interim==i&bound==1), 
                                        colour=col[1], lty=lty[1], lwd=lwd[1])
     if (test.type > 2) for(i in 1:(x$k-1)) {
       p <- p + geom_line(data=subset(y,interim==i&bound==2), colour=col[2], lty=lty[2], lwd=lwd[2])
     }
     return(p)
   }
}
