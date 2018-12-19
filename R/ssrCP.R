# conditional power function
condPower <- function(z1, n2, z2=z2NC, theta=NULL, 
                x=gsDesign(k=2, timing=.5, beta=beta),
                ...){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(pnorm(sqrt(n2)*theta-
                            z2(z1=z1,x=x,n2=n2))))
}



condPowerDiff <- function(z1, target, n2, z2=z2NC,
                            theta=NULL,
                            x=gsDesign(k=2,timing=.5)){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(pnorm(sqrt(n2)*theta-
                            z2(z1=z1,x=x,n2=n2))-target))
}



n2sizediff <- function(z1, target, beta=.1, z2=z2NC, 
                         theta=NULL, 
                         x=gsDesign(k=2, timing=.5, beta=beta)){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(((z2(z1=z1,x=x,n2=target-x$n.I[1]) - 
                        qnorm(beta))/theta)^2 + x$n.I[1] - 
                      target))
}



#' Sample size re-estimation based on conditional power
#' 
#' \code{ssrCP()} adapts 2-stage group sequential designs to 2-stage sample
#' size re-estimation designs based on interim analysis conditional power. This
#' is a simple case of designs developed by Lehmacher and Wassmer, Biometrics
#' (1999).  The conditional power designs of Bauer and Kohne (1994), Proschan
#' and Hunsberger (199x), Cui, Hung and Wang (199x) and Liu and Chi (), Gao,
#' Ware and Mehta (), and Mehta and Pocock (2011).  Either the estimated
#' treatment effect at the interim analysis or any chosen effect size can be
#' used for sample size re-estimation. If not done carefully, these designs can
#' be very inefficient. It is probably a good idea to compare any design to a
#' simpler group sequential design; see, for example, Jennison and Turnbull
#' (2003). The a assumes a small Type I error is included with the interim
#' analysis and that the design is an adaptation from a 2-stage group
#' sequential design Related functions include 3 pre-defined combination test
#' functions (\code{z2NC}, \code{z2Z}, \code{z2Fisher}) that represent the
#' inverse normal combination test (Lehmacher and Wassmer, 1999), the
#' sufficient statistic for the complete data, and Fisher's combination test.
#' \code{Power.ssrCP} computes unconditional power for a conditional power
#' design derived by \code{ssrCP}.
#' 
#' \code{condPower} is a supportive routine that also is interesting in its own
#' right; it computes conditional power of a combination test given an interim
#' test statistic, stage 2 sample size and combindation test statistic. While
#' the returned data frame should make general plotting easy, the function
#' \code{plot.ssrCP()} prints a plot of study sample size by stage 1 outcome
#' with multiple x-axis labels for stage 1 z-value, conditional power, and
#' stage 1 effect size relative to the effect size for which the underlying
#' group sequential design was powered.
#' 
#' Sample size re-estimation using conditional power and an interim estimate of
#' treatment effect was proposed by several authors in the 1990's (see
#' references below). Statistical testing for these original methods was based
#' on combination tests since Type I error could be inflated by using a
#' sufficient statistic for testing at the end of the trial. Since 2000, more
#' efficient variations of these conditional power designs have been developed.
#' Fully optimized designs have also been derived (Posch et all, 2003,
#' Lokhnygina and Tsiatis, 2008). Some of the later conditional power methods
#' allow use of sufficient statistics for testing (Chen, DeMets and Lan, 2004,
#' Gao, Ware and Mehta, 2008, and Mehta and Pocock, 2011).
#' 
#' The methods considered here are extensions of 2-stage group sequential
#' designs that include both an efficacy and a futility bound at the planned
#' interim analysis. A maximum fold-increase in sample size (\code{maxinc})from
#' the supplied group sequential design (\code{x}) is specified by the user, as
#' well as a range of conditional power (\code{cpadj}) where sample size should
#' be re-estimated at the interim analysis, 1-the targeted conditional power to
#' be used for sample size re-estimation (\code{beta}) and a combination test
#' statistic (\code{z2}) to be used for testing at the end of the trial. The
#' input value \code{overrun} represents incremental enrollment not included in
#' the interim analysis that is not included in the analysis; this is used for
#' calculating the required number of patients enrolled to complete the trial.
#' 
#' Whereas most of the methods proposed have been based on using the interim
#' estimated treatment effect size (default for \code{ssrCP}), the variable
#' \code{theta} allows the user to specify an alternative; Liu and Chi (2001)
#' suggest that using the parameter value for which the trial was originally
#' powered is a good choice.
#' 
#' @aliases ssrCP plot.ssrCP Power.ssrCP condPower z2NC z2Z z2Fisher
#' @param z1 Scalar or vector with interim standardized Z-value(s). Input of
#' multiple values makes it easy to plot the revised sample size as a function
#' of the interim test statistic.
#' @param theta If \code{NULL} (default), conditional power calculation will be
#' based on estimated interim treatment effect. Otherwise, \code{theta} is the
#' standardized effect size used for conditional power calculation. Using the
#' alternate hypothesis treatment effect can be more efficient than the
#' estimated effect size; see Liu and Chi, Biometrics (2001).
#' @param maxinc Maximum fold-increase from planned maximum sample size in
#' underlying group sequential design provided in \code{x}.
#' @param overrun The number of patients enrolled before the interim analysis
#' is completed who are not included in the interim analysis.
#' @param beta Targeted Type II error (1 - targeted conditional power); used
#' for conditional power in sample size reestimation.
#' @param cpadj Range of values strictly between 0 and 1 specifying the range
#' of interim conditional power for which sample size re-estimation is to be
#' performed. Outside of this range, the sample size supplied in \code{x} is
#' used.
#' @param x A group sequential design with 2 stages (\code{k=2}) generated by
#' \code{\link{gsDesign}}. For \code{plot.ssrCP}, \code{x} is a design returned
#' by \code{ssrCP()}.
#' @param z2 a combination function that returns a test statistic cutoff for
#' the stage 2 test based in the interim test statistic supplied in \code{z1},
#' the design \code{x} and the stage 2 sample size.
#' @param ... Allows passing of arguments that may be needed by the
#' user-supplied function, codez2. In the case of \code{plot.ssrCP()}, allows
#' passing more graphical parameters.
#' @param delta Natural parameter values for power calculation; see
#' \code{\link{gsDesign}} for a description of how this is related to
#' \code{theta}.
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @param n2 stage 2 sample size to be used in computing sufficient statistic
#' when combining stage 1 and 2 test statistics.
#' @param z1ticks Test statistic values at which tick marks are to be made on
#' x-axis; automatically calculated under default of \code{NULL}
#' @param mar Plot margins; see help for \code{par}
#' @param ylab y-axis label
#' @param xlaboffset offset on x-axis for printing x-axis labels
#' @param lty line type for stage 2 sample size
#' @param col line color for stage 2 sample size
#' @return \code{ssrCP} returns a list with the following items: \item{x}{As
#' input.} \item{z2fn}{As input in \code{z2}.} \item{theta}{standardize effect
#' size used for conditional power; if \code{NULL} is input, this is computed
#' as \code{z1/sqrt(n1)} where \code{n1} is the stage 1 sample size.}
#' \item{maxinc}{As input.} \item{overrun}{As input.} \item{beta}{As input.}
#' \item{cpadj}{As input.} \item{dat}{A data frame containing the input
#' \code{z1} values, computed cutoffs for the standard normal test statistic
#' based solely on stage 2 data (\code{z2}), stage 2 sample sizes (\code{n2}),
#' stage 2 conditional power (\code{CP}), standardize effect size used for
#' conditional power calculation (\code{theta}), and the natural parameter
#' value corresponding to \code{theta} (\code{delta}). The relation between
#' \code{theta} and \code{delta} is determined by the \code{delta0} and
#' \code{delta1} values from \code{x}: \code{delta = delta0 +
#' theta(delta1-delta0)}.}
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{gsDesign}}
#' @references Bauer, Peter and Kohne, F., Evaluation of experiments with
#' adaptive interim analyses, Biometrics, 50:1029-1041, 1994.
#' 
#' Chen, YHJ, DeMets, DL and Lan, KKG. Increasing the sample size when the
#' unblinded interim result is promising, Statistics in Medicine, 23:1023-1038,
#' 2004.
#' 
#' Gao, P, Ware, JH and Mehta, C, Sample size re-estimation for adaptive
#' sequential design in clinical trials, Journal of Biopharmaceutical
#' Statistics", 18:1184-1196, 2008.
#' 
#' Jennison, C and Turnbull, BW.  Mid-course sample size modification in
#' clinical trials based on the observed treatment effect. Statistics in
#' Medicine, 22:971-993", 2003.
#' 
#' Lehmacher, W and Wassmer, G. Adaptive sample size calculations in group
#' sequential trials, Biometrics, 55:1286-1290, 1999.
#' 
#' Liu, Q and Chi, GY., On sample size and inference for two-stage adaptive
#' designs, Biometrics, 57:172-177, 2001.
#' 
#' Mehta, C and Pocock, S. Adaptive increase in sample size when interim
#' results are promising: A practical guide with examples, Statistics in
#' Medicine, 30:3267-3284, 2011.
#' @keywords design
#' @examples
#' 
#' # Following is a template for entering parameters for ssrCP
#' # Natural parameter value null and alternate hypothesis values
#' delta0 <- 0
#' delta1 <- 1
#' # timing of interim analysis for underlying group sequential design
#' timing <- .5
#' # upper spending function 
#' sfu <- sfHSD
#' # upper spending function paramater
#' sfupar <- -12
#' # maximum sample size inflation
#' maxinflation <- 2
#' # assumed enrollment overrrun at IA
#' overrun <- 25
#' # interim z-values for plotting
#' z <- seq(0,4,.025)
#' # Type I error (1-sided)
#' alpha <- .025
#' # Type II error for design
#' beta <- .1
#' # Fixed design sample size
#' n.fix <- 100
#' # conditional power interval where sample 
#' # size is to be adjusted
#' cpadj <- c(.3,.9)
#' # targeted Type II error when adapting sample size
#' betastar <- beta
#' # combination test (built-in options are: z2Z, z2NC, z2Fisher)
#' z2 <- z2NC
#' 
#' # use the above parameters to generate design
#' # generate a 2-stage group sequential design with 
#' x<-gsDesign(k=2,n.fix=n.fix,timing=timing,sfu=sfu,sfupar=sfupar,
#'             alpha=alpha,beta=beta,delta0=delta0,delta1=delta1)
#' # extend this to a conditional power design
#' xx <- ssrCP(x=x,z1=z,overrun=overrun,beta=betastar,cpadj=cpadj,
#'         maxinc=maxinflation, z2=z2)
#' # plot the stage 2 sample size
#' plot(xx)
#' # demonstrate overlays on this plot
#' # overlay with densities for z1 under different hypotheses
#' lines(z,80+240*dnorm(z,mean=0),col=2)
#' lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]),col=3)
#' lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]/2),col=4)
#' lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]*.75),col=5)
#' axis(side=4, at=80+240*seq(0,.4,.1), labels=as.character(seq(0,.4,.1))) 
#' mtext(side=4,expression(paste("Density for ",z[1])),line=2)
#' text(x=1.5,y=90,col=2,labels=expression(paste("Density for ",theta,"=0")))
#' text(x=3.00,y=180,col=3,labels=expression(paste("Density for ",theta,"=", theta[1])))
#' text(x=1.00,y=180,col=4,labels=expression(paste("Density for ",theta,"=", theta[1],"/2")))
#' text(x=2.5,y=140,col=5,labels=expression(paste("Density for ",theta,"=", theta[1],"*.75")))
#' # overall line for max sample size
#' nalt <- xx$maxinc*x$n.I[2]
#' lines(x=par("usr")[1:2],y=c(nalt,nalt),lty=2)
#' 
#' # compare above design with different combination tests
#' # use sufficient statistic for final testing
#' xxZ <- ssrCP(x=x,z1=z,overrun=overrun,beta=betastar,cpadj=cpadj,
#'         maxinc=maxinflation, z2=z2Z)
#' # use Fisher combination test for final testing
#' xxFisher <- ssrCP(x=x,z1=z,overrun=overrun,beta=betastar,cpadj=cpadj,
#'         maxinc=maxinflation, z2=z2Fisher)
#' # combine data frames from these designs
#' y <- rbind(
#'        data.frame(cbind(xx$dat,Test="Normal combination")),
#'        data.frame(cbind(xxZ$dat,Test="Sufficient statistic")),
#'        data.frame(cbind(xxFisher$dat,Test="Fisher combination")))
#' # plot stage 2 statistic required for positive combination test
#' ggplot(data=y,aes(x=z1,y=z2,col=Test))+geom_line()
#' # plot total sample size versus stage 1 test statistic
#' ggplot(data=y,aes(x=z1,y=n2,col=Test))+geom_line()
#' # check achieved Type I error for sufficient statistic design
#' Power.ssrCP(x=xxZ, theta=0)
#' 
#' # compare designs using observed vs planned theta for conditional power
#' xxtheta1 <- ssrCP(x=x,z1=z,overrun=overrun,beta=betastar,cpadj=cpadj,
#'         maxinc=maxinflation, z2=z2, theta=x$delta)
#' # combine data frames for the 2 designs
#' y <- rbind(
#'        data.frame(cbind(xx$dat,"CP effect size"="Obs. at IA")),
#'        data.frame(cbind(xxtheta1$dat,"CP effect size"="Alt. hypothesis")))
#' # plot stage 2 sample size by design
#' ggplot(data=y,aes(x=z1,y=n2,col=CP.effect.size))+geom_line()
#' # compare power and expected sample size
#' y1 <- Power.ssrCP(x=xx)
#' y2 <- Power.ssrCP(x=xxtheta1)
#' # combine data frames for the 2 designs
#' y3 <- rbind(
#'        data.frame(cbind(y1,"CP effect size"="Obs. at IA")),
#'        data.frame(cbind(y2,"CP effect size"="Alt. hypothesis")))
#' # plot expected sample size by design and effect size
#' ggplot(data=y3,aes(x=delta,y=en,col=CP.effect.size))+geom_line() + 
#'         xlab(expression(delta)) + ylab("Expected sample size")
#' # plot power by design and effect size
#' ggplot(data=y3,aes(x=delta,y=Power,col=CP.effect.size))+geom_line() + xlab(expression(delta))
#' 
ssrCP <- function(z1, theta=NULL, maxinc=2, overrun=0, 
                  beta = x$beta, cpadj=c(.5,1-beta), 
                  x=gsDesign(k=2, timing=.5),
                  z2=z2NC,...){
  if (class(x)!="gsDesign")
    stop("x must be passed as an object of class gsDesign")
  if (2 != x$k) 
    stop("input group sequential design must have 2 stages (k=2)")
  if (overrun <0 | overrun + x$n.I[1]>x$n.I[2])
    stop(paste("overrun  must be >= 0 and",
               " <= 2nd stage sample size (",
          round(x$n.I[2]-x$n.I[1],2),")",sep=""))
  checkVector(x=z1,interval=c(-Inf,Inf), 
              inclusion=c(FALSE,FALSE))
  checkScalar(maxinc,interval=c(1,Inf), 
              inclusion=c(FALSE,TRUE))
  checkVector(cpadj,interval=c(0,1), 
              inclusion=c(FALSE,FALSE),length=2)
  if (cpadj[2]<=cpadj[1]) 
    stop(paste("cpadj must be an increasing pair", 
               "of numbers between 0 and 1"))
  n2 <- array(x$n.I[1]+overrun,length(z1))
  temtheta <- theta
  if (is.null(theta))theta <- z1 / sqrt(x$n.I[1])
  # compute conditional power for group sequential design
  # for given z1
  CP <- condPower(z1, n2=x$n.I[2]-x$n.I[1], z2=z2, 
                  theta=theta, x=x, ...)
  # continuation range
  indx <- ((z1 > x$lower$bound[1]) & 
           (z1 < x$upper$bound[1]))
  # where final sample size will not be adapted
  indx2 <- indx & ((CP < cpadj[1]) | (CP>cpadj[2]))
  # in continuation region with no adaptation, use planned final n
  n2[indx2] <- x$n.I[2]
  # now set where you will adapt
  indx2 <- indx & !indx2
  # update sample size based on combination function  
  # assuming original stage 2 sample size
  z2i <- z2(z1=z1[indx2], x=x, n2=x$n.I[2]-x$n.I[1],...)
  if (length(theta)==1){
    n2i <- ((z2i - qnorm(beta)) / theta)^2 + x$n.I[1]
  }else{
    n2i <- ((z2i - qnorm(beta)) / theta[indx2])^2 + x$n.I[1]
  }
  n2i[n2i/x$n.I[2] > maxinc] <- x$n.I[2]*maxinc
  # if conditional error depends on stage 2 sample size,
  # do fixed point iteration to get conditional error
  # and stage 2 sample size to correspond
  if (class(z2i)[1] == "n2dependent"){
    for(i in 1:6){
      z2i <- z2(z1=z1[indx2], x=x, n2=n2i-x$n.I[1], ...)
      if (length(theta)==1){
        n2i <- ((z2i - qnorm(beta))/theta)^2 + x$n.I[1]
      }else{
        n2i <- ((z2i - qnorm(beta))/theta[indx2])^2 + 
          x$n.I[1]
      }
      n2i[n2i/x$n.I[2] > maxinc] <- x$n.I[2]*maxinc
    }
  }
  n2[indx2] <- n2i
  if (length(theta)==1) theta <- array(theta,length(n2))
  rval <- list(x=x, z2fn=z2, theta=temtheta, maxinc=maxinc, 
               overrun=overrun, beta=beta, cpadj=cpadj, 
               dat=data.frame(z1=z1, 
                        z2=z2(z1=z1, x=x, n2=x$n.I[2], ...), 
                        n2=n2, CP=CP, theta=theta,
                        delta=x$delta0+theta*(x$delta1-x$delta0)))
  class(rval) <- "ssrCP"
  return(rval)
}

plot.ssrCP <- function(x, z1ticks=NULL, mar=c(7, 4, 4, 4)+.1, ylab="Adapted sample size", xlaboffset=-.2, lty=1, col=1,...){
  par(mar=mar)
  plot(x$dat$z1, x$dat$n2,type="l", axes=FALSE, xlab="", ylab="", lty=lty, col=col,...)
  xlim <- par("usr")[1:2] # get x-axis range
  axis(side=2, ...)
  mtext(side=2, ylab, line=2,...)
  w <- x$x$timing[1]
  if (is.null(z1ticks)) z1ticks <- seq(ceiling(2*xlim[1])/2, floor(2*xlim[2])/2, by=.5)
  theta <- z1ticks / sqrt(x$x$n.I[1])
  CP <- pnorm(theta*sqrt(x$x$n.I[2]*(1-w))-(x$upper$bound[2]-z1ticks*sqrt(w))/sqrt(1-w))
  CP <- condPower(z1=z1ticks,x=x$x,cpadj=x$cpadj,n2=x$x$n.I[2]-x$x$n.I[1])
  axis(side=1,line=3,at=z1ticks,labels=as.character(round(CP,2)), ...)
  mtext(side=1,"CP",line=3.5,at=xlim[1]+xlaboffset,...)
  axis(side=1,line=1,at=z1ticks, labels=as.character(z1ticks),...)
  mtext(side=1,expression(z[1]),line=.75,at=xlim[1]+xlaboffset,...)
  axis(side=1,line=5,at=z1ticks, labels=as.character(round(theta/x$x$delta,2)),...)
  mtext(side=1,expression(hat(theta)/theta[1]),line=5.5,at=xlim[1]+xlaboffset,...)
}

# normal combination test cutoff for z2
z2NC <- function(z1,x,...){
  z2 <- (x$upper$bound[2] - z1*sqrt(x$timing[1])) / 
    sqrt(1-x$timing[1])
  class(z2) <- c("n2independent","numeric")
  return(z2)
}

# sufficient statistic cutoff for z2
z2Z <- function(z1,x,n2=x$n.I[2]-x$n.I[1],...){
  N2 <- x$n.I[1] + n2
  z2 <- (x$upper$bound[2]-z1*sqrt(x$n.I[1]/N2)) / 
    sqrt(n2/N2)
  class(z2) <- c("n2dependent","numeric")
  return(z2)
}

# Fisher's combination text
z2Fisher <- function(z1,x,...){
  z2 <- z1
  indx <- pchisq(-2*log(pnorm(-z1)), 4, lower.tail=F) <= 
    pnorm(-x$upper$bound[2])
  z2[indx] <- -Inf
  z2[!indx] <- qnorm(exp(-qchisq(pnorm(-x$upper$bound[2]), 
                                 df=4, lower.tail=FALSE) /
                           2-log(pnorm(-z1[!indx]))), 
                     lower.tail=FALSE)
  class(z2) <- c("n2independent","numeric")
  return(z2)
}

Power.ssrCP <- function(x, theta=NULL, delta=NULL, r=18){
  if (class(x) != "ssrCP") 
    stop("Power.ssrCP must be called with x of class ssrCP")
  if (is.null(theta) & is.null(delta)){
    theta <- (0:80)/40*x$x$delta
    delta <- (x$x$delta1-x$x$delta0)/x$x$delta*theta + x$x$delta0
  }else if(!is.null(theta)){delta <- (x$x$delta1-x$x$delta0)/x$x$delta*theta + x$x$delta0
  }else theta <- (delta-x$x$delta0)/(x$x$delta1-x$x$delta0)*x$x$delta
  en <- theta
  Power <- en
  mu <- sqrt(x$x$n.I[1])*theta
  # probability of stopping at 1st interim
  Power <- pnorm(x$x$upper$bound[1]-mu,lower.tail=FALSE)
  en <- (x$x$n.I[1]+x$overrun)*(Power + 
                                  pnorm(x$x$lower$bound[1]-mu))
  # get minimum and maximum conditional power at bounds
  cpmin <- condPower(z1=x$x$lower$bound[1], 
                     n2=x$x$n.I[2] - x$x$n.I[1], 
                     z2=x$z2fn, theta=x$theta, 
                     x=x$x, beta=x$beta)
  cpmax <- condPower(z1=x$x$upper$bound[1], 
                     n2=x$x$n.I[2] - x$x$n.I[1], 
                     z2=x$z2fn, theta=x$theta, 
                     x=x$x, beta=x$beta)
  # if max conditional power <= lower cp for which adjustment 
  # is done or min conditional power >= upper cp for which 
  # adjustment is done, no adjustment required
  if (cpmax <= x$cpadj[1] || cpmin >=x$cpadj[2]){
    en <- en + x$x$n.I[2] * (pnorm(x$x$upper$bound[1]-mu) - 
                               pnorm(x$x$lower$bound[1]-mu))
    a <- x$x$lower$bound[1]
    b <- x$x$upper$bound[2]
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <- Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*sqrt(n2), 
                  lower.tail=FALSE))
    return(data.frame(theta=theta,delta=delta,Power=Power,en=en))
  }
  # check if minimum conditional power met at interim lower bound,
  # if not, compute probability of no SSR and accumulate
  if (cpmin<x$cpadj[1]){
    changepoint <- uniroot(condPowerDiff, 
                           interval=c(x$x$lower$bound[1], 
                                      x$x$upper$bound[1]), 
                           target=x$cpadj[1],
                           n2=x$x$n.I[2]-x$x$n.I[1], 
                           z2=x$z2fn, theta=x$theta, 
                           x=x$x)$root
    en <- en + x$x$n.I[2]*(pnorm(changepoint-mu) - 
                             pnorm(x$x$lower$bound[1]-mu))
    a <- x$x$lower$bound[1]
    b <- changepoint
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,
                       bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <- Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1]) * theta[i])*grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*
                    sqrt(n2), lower.tail=FALSE))
  }else changepoint <- x$x$lower$bound[1]
  # check if max cp exceeded at interim upper bound
  # if it is, compute probability of no final sample 
  # size increase just below upper bound
  if (cpmax >x$cpadj[2]){
    changepoint2 <- uniroot(condPowerDiff, 
                            interval=c(changepoint, x$x$upper$bound[1]), 
                            target=x$cpadj[2], n2=x$x$n.I[2]-x$x$n.I[1], 
                            z2=x$z2fn, theta=x$theta, x=x$x)$root
    en <- en + x$x$n.I[2]*(pnorm(x$x$upper$bound[1]-mu)-
                             pnorm(changepoint2-mu))
    a <- changepoint2
    b <- x$x$upper$bound[1]
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <-  Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*sqrt(n2), 
                  lower.tail=FALSE))
  }else changepoint2 <- x$upper$bound[1]
  # next look if max sample size based on CP is greater than 
  # allowed if it is, compute en for interval at max sample size
  if (n2sizediff(z1=changepoint, target=x$maxinc*x$x$n.I[2], 
                 beta=x$beta, z2=x$z2fn, theta=x$theta, x=x$x)>0){
    # find point at which sample size based on cp 
    # is same as max allowed
    changepoint3 <- uniroot(condPowerDiff, 
                            interval=c(changepoint,15), 
                            target=1-x$beta, x=x$x, 
                            n2=x$maxinc*x$x$n.I[2]-x$x$n.I[1],
                            z2=x$z2fn, theta=x$theta)$root
  
    if (changepoint3 >= changepoint2){
      en <- en + x$maxinc*x$x$n.I[2]*(pnorm(changepoint2-mu)-
                                        pnorm(changepoint-mu))
      a <- changepoint
      b <- changepoint2
      n2 <- x$maxinc*x$x$n.I[2]-x$x$n.I[1]
      grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
      for(i in 1:length(theta)) Power[i] <-  Power[i] +
        sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * 
              grid$gridwgts *
              pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-
                      theta[i] * sqrt(n2), lower.tail=FALSE))
      return(data.frame(theta=theta, delta=delta, 
                        Power=Power, en=en))
    }
    en <- en + x$maxinc*x$x$n.I[2]*(pnorm(changepoint3-mu) - 
                                      pnorm(changepoint-mu))
    a <- changepoint
    b <- changepoint3
    n2 <- x$maxinc*x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <-  Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * 
            grid$gridwgts *
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2) - 
                    theta[i] * sqrt(n2), lower.tail=FALSE))
  }else changepoint3 <- changepoint # changed from x$x$lower$bound[1], 20131201, K Anderson
  # finally, integrate en over area where conditional power is in  
  # range where we wish to increase to desired conditional power
  grid <- normalGrid(mu=(changepoint3+changepoint2)/2, 
                     bounds=c(changepoint3, changepoint2), r=r)    
  y <- ssrCP(z1=grid$z, theta=x$theta, maxinc=x$maxinc*2, 
             beta=x$beta, x=x$x, cpadj=c(.05,.9999), 
             z2=x$z2fn)$dat
  for(i in 1:length(theta)){
    grid$density <- dnorm(y$z1-sqrt(x$x$n.I[1])*theta[i])
    Power[i] <- Power[i] + 
      sum(grid$density * grid$gridwgts * 
            pnorm(y$z2 - theta[i]*sqrt(y$n2-x$x$n.I[1]), 
                  lower.tail=FALSE))
    en[i] <- en[i] + sum(grid$density*grid$gridwgts*y$n2)
  }
  return(data.frame(theta=theta,delta=delta,Power=Power,en=en))
}
