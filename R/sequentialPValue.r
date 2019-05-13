#' @title Sequential p-value computation
#' @description \code{sequentialPValue} computes a sequential p-value for a group sequential design using a spending function as described in 
#' Maurer and Bretz (2013) and previously defined by Liu and Anderson (2008).
#' It is the minimum of repeated p-values computed at each analysis (Jennison and Turnbull, 2000).
#' This is particularly useful for multiplicity methods such as the graphical method for group sequential designs 
#' where sequential p-values for multiple hypotheses can be used as nominal p-values to plug into a multiplicity graph. 
#' A sequential p-value is described as the minimum alpha level at which a one-sided group sequential bound would 
#' be rejected given interim and final observed results.
#' It is meaningful for both one-sided designs and designs with non-binding futility bounds (\code{test.type} 1, 4, 6), 
#' but not for 2-sided designs with binding futility bounds (\code{test.type} 2, 3 or 5).
#' Mild restrictions are required on spending functions used, but these are satisfied for commonly used spending functions
#' such as the Lan-DeMets spending function approximating an O'Brien-Fleming bound or a Hwang-Shih-DeCani spending function; see Maurer and Bretz (2013).
#' 
#' @param gsD Group sequential design generated by \code{gsDesign} or \code{gsSurv}.
#' @param n.I Event counts (for time-to-event outcomes) or sample size (for most other designs); numeric vector with increasing, positive values with at most one
#' value greater than or equal to largest value in \code{gsD$n.I}; NOTE: if NULL, planned n.I will be used (\code{gsD$n.I}).
#' @param Z Z-value tests corresponding to analyses in \code{n.I}; positive values indicate a positive finding; must have the same length as \code{n.I}.
#' @param usTime  Spending time for upper bound at specified analyses; specify default: \code{NULL} if this is to be based on information fraction; 
#' if not \code{NULL}, must have the same length as \code{n.I}; increasing positive values with at most 1 greater than or equal to 1.
#' @param interval Interval for search to derive p-value; Default: \code{c(1e-05, 0.9999)}. Lower end of interval must be >0 and upper end must be < 1. 
#' The primary reason to not use the defaults would likely be if a test were vs a Type I error <0.0001.
#' @return Sequential p-value (single numeric one-sided p-value between 0 and 1). 
#' Note that if the sequential p-value is less than the lower end of the input interval, 
#' the lower of interval will be returned.
#' Similarly, if the sequential p-value is greater than the upper end of the input interval, 
#' then the upper end of interval is returned. 
#' @author Keaven Anderson
#' @references 
#' Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' 
#' Liu, Qing, and Keaven M. Anderson. "On adaptive extensions of group sequential trials for clinical investigations." \emph{Journal of the American Statistical Association} 103.484 (2008): 1621-1630.
#' 
#' Maurer, Willi, and Frank Bretz. "Multiple testing in group sequential trials using graphical approaches." \emph{Statistics in Biopharmaceutical Research} 5.4 (2013): 311-320.; 
#' @examples
#' 
#' # Derive Group Sequential Design 
#' x <- gsSurv(k = 4, alpha = 0.025, beta = 0.1, timing = c(.5,.65,.8), sfu = sfLDOF,
#'             sfl = sfHSD, sflpar = 2, lambdaC = log(2)/6, hr = 0.6,
#'             eta = 0.01 , gamma = c(2.5,5,7.5,10), R = c( 2,2,2,6 ),
#'             T = 30 , minfup = 18)
#' x$n.I
#' # Analysis at IA2
#' sequentialPValue(gsD=x,n.I=c(100,160),Z=c(1.5,2))
#' # Use planned spending instead of information fraction; do final analysis
#' sequentialPValue(gsD=x,n.I=c(100,160,190,230),Z=c(1.5,2,2.5,3),usTime=x$timing)
#' # Check bounds for updated design to verify at least one was crossed
#' xupdate <- gsDesign(maxn.IPlan=max(x$n.I),n.I=c(100,160,190,230),usTime=x$timing,
#'                     delta=x$delta,delta1=x$delta1,k=4,alpha=x$alpha,test.type=1,
#'                     sfu=x$upper$sf,sfupar=x$upper$param)
# gsBoundSummary(xupdate,logdelta=TRUE,Nname="Events",deltaname="HR")
#' @rdname sequentiaPValue
#' @details 
#' Solution is found with a search using \code{uniroot}.
#' This finds the maximum alpha-level for which an efficacy bound is crossed, 
#' completely ignoring any futility bound.
#' @export
sequentialPValue <- function(gsD = gsDesign(),
                             n.I = NULL,
                             Z = NULL,
                             usTime = NULL,
                             interval=c(.00001,.9999)){
  # check that gsD has class "gsDesign" (note: this includes "gsSurv" type)
  if (!methods::is(gsD, "gsDesign")) stop("d should be an object of class gsDesign or gsSurv")
  # check that gsD$test.type is 1,4 or 6
  if(max(gsD$test.type == c(1,4,6)) != 1) stop("gsD$test.type must be 1, 4, or 6 (no binding lower bound allowed)")
  # if n.I not specified, assume planned values used
  if (is.null(n.I)) n.I <- gsD$n.I
  # check that n.I, Z and, if non-NULL, usTime are real vectors of the same length
  if(is.vector(n.I,mode="numeric") != TRUE) stop("n.I must be numeric vector")
  if(is.vector(Z,mode="numeric")!=TRUE) stop("Z must be numeric vector")
  if (is.null(usTime)) usTime <- n.I/gsD$n.I[gsD$k]
  if(is.vector(usTime,mode="numeric")!=TRUE) stop("usTime must be a positive, increasing numeric vector with at most one value >= 1")
  checkLengths(n.I, Z, usTime)
  # check that n.I and usTime are increasing and greater than 0
  if(length(n.I)!=length(unique(n.I))) stop("n.I values must be an increasing positive")
  if (!(all(sort(n.I) == n.I) && all(gsD$n.I > 0))) stop("n.I must be an increasing, positive sequence at most one value > max(gsD$n.I)")
  # check that n.I has at most one value >= gsD$n.I[gsD$k]
  if(sum(n.I>=max(gsD$n.I))>1) stop("At most one value of n.I >= max(gsD$n.I)")
  # check that usTime has at most 1 value >= 1
  if(sum(usTime>=1)>1)stop("No more than one value of usTime >= 1")
  # check the interval is 2 values in (0,1), exclusive of endpoints
  probhi <- gsD$upper$sf(alpha=max(interval), t=usTime, param=gsD$upper$param)$spend
  # check upper end of p-value interval input
  if (length(Z)>1) probhi <- probhi - c(0,probhi[1:(length(Z)-1)])
  if (min(gsBound1(I=n.I, theta=0, a=rep(-20,length(Z)),
                   probhi=probhi)$b-Z) > 0) return(max(interval))
  # check lower end of p-value interval input
  if(is.vector(interval,mode="numeric")!=TRUE||length(interval) != 2 || min(interval)<=0||max(interval)>=1){ 
    stop("interval must be 2 distinct values strictly between 0 and 1")}
  probhi <- gsD$upper$sf(alpha=min(interval), t=usTime, param=gsD$upper$param)$spend
  if (length(Z)>1) probhi <- probhi - c(0,probhi[1:(length(Z)-1)])
  if (min(gsBound1(I=n.I, theta=0, a=rep(-20,length(Z)),
                   probhi=probhi)$b-Z) < 0) return(min(interval))
  # if answer is between interval bounds, find it with root-finding
  x <- try(uniroot(sequentialZdiff, interval = -qnorm(interval), gsD = gsD, n.I = n.I, Z = Z,
               usTime=usTime))
  if(class(x)=="try-error") stop("Failed to find root for sequential p-value")
  pnorm(-x$root)
}
sequentialZdiff <- function(x,
                            gsD=gsDesign(),
                            n.I = (1:3)/3,
                            Z = 1:3,
                            usTime = NULL){
  alpha <- pnorm(-x)
  probhi <- gsD$upper$sf(alpha=alpha, t=usTime, param=gsD$upper$param)$spend
  if (length(Z)>1) probhi <- probhi - c(0,probhi[1:(length(Z)-1)])
  return(min(gsBound1(I=n.I, theta=0, a=rep(-20,length(Z)),
                      probhi=probhi)$b-Z))
}
