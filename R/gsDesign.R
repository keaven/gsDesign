#' 2.7: Boundary derivation - low level
#' 
#' \code{gsBound()} and \code{gsBound1()} are lower-level functions used to
#' find boundaries for a group sequential design. They are not recommended
#' (especially \code{gsBound1()}) for casual users. These functions do not
#' adjust sample size as \code{gsDesign()} does to ensure appropriate power for
#' a design.
#' 
#' \code{gsBound()} computes upper and lower bounds given boundary crossing
#' probabilities assuming a mean of 0, the usual null hypothesis.
#' \code{gsBound1()} computes the upper bound given a lower boundary, upper
#' boundary crossing probabilities and an arbitrary mean (\code{theta}).
#' 
#' The function \code{gsBound1()} requires special attention to detail and
#' knowledge of behavior when a design corresponding to the input parameters
#' does not exist.
#' 
#' @aliases gsBound gsBound1
#' @param theta Scalar containing mean (drift) per unit of statistical
#' information.
#' @param I Vector containing statistical information planned at each analysis.
#' @param a Vector containing lower bound that is fixed for use in
#' \code{gsBound1}.
#' @param trueneg Vector of desired probabilities for crossing upper bound
#' assuming mean of 0.
#' @param falsepos Vector of desired probabilities for crossing lower bound
#' assuming mean of 0.
#' @param probhi Vector of desired probabilities for crossing upper bound
#' assuming mean of theta.
#' @param tol Tolerance for error (scalar; default is 0.000001). Normally this
#' will not be changed by the user.  This does not translate directly to number
#' of digits of accuracy, so use extra decimal places.
#' @param r Single integer value controlling grid for numerical integration as
#' in Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @param printerr If this scalar argument set to 1, this will print messages
#' from underlying C program.  Mainly intended to notify user when an output
#' solution does not match input specifications.  This is not intended to stop
#' execution as this often occurs when deriving a design in \code{gsDesign}
#' that uses beta-spending.
#' @return Both routines return a list. Common items returned by the two
#' routines are: \item{k}{The length of vectors input; a scalar.}
#' \item{theta}{As input in \code{gsBound1()}; 0 for \code{gsBound()}.}
#' \item{I}{As input.} \item{a}{For \code{gsbound1}, this is as input. For
#' \code{gsbound} this is the derived lower boundary required to yield the
#' input boundary crossing probabilities under the null hypothesis.}
#' \item{b}{The derived upper boundary required to yield the input boundary
#' crossing probabilities under the null hypothesis.} \item{tol}{As input.}
#' \item{r}{As input.} \item{error}{Error code. 0 if no error; greater than 0
#' otherwise.}
#' 
#' \code{gsBound()} also returns the following items: \item{rates}{a list
#' containing two items:} \item{falsepos}{vector of upper boundary crossing
#' probabilities as input.} \item{trueneg}{vector of lower boundary crossing
#' probabilities as input.}
#' 
#' \code{gsBound1()} also returns the following items: \item{problo}{vector of
#' lower boundary crossing probabilities; computed using input lower bound and
#' derived upper bound.} \item{probhi}{vector of upper boundary crossing
#' probabilities as input.}
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \link{gsDesign package overview}, \code{\link{gsDesign}},
#' \code{\link{gsProbability}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' # set boundaries so that probability is .01 of first crossing
#' # each upper boundary and .02 of crossing each lower boundary
#' # under the null hypothesis
#' x <- gsBound(I=c(1, 2, 3)/3, trueneg=array(.02, 3),
#'              falsepos=array(.01, 3))
#' x
#' 
#' #  use gsBound1 to set up boundary for a 1-sided test
#' x <- gsBound1(theta= 0, I=c(1, 2, 3) / 3, a=array(-20, 3),
#'               probhi=c(.001, .009, .015))
#' x$b
#' 
#' # check boundary crossing probabilities with gsProbability 
#' y <- gsProbability(k=3, theta=0, n.I=x$I, a=x$a, b=x$b)$upper$prob
#' 
#' #  Note that gsBound1 only computes upper bound 
#' #  To get a lower bound under a parameter value theta:
#' #      use minus the upper bound as a lower bound
#' #      replace theta with -theta
#' #      set probhi as desired lower boundary crossing probabilities 
#' #  Here we let set lower boundary crossing at 0.05 at each analysis
#' #  assuming theta=2.2 
#' y <- gsBound1(theta=-2.2, I=c(1, 2, 3)/3, a= -x$b, 
#'               probhi=array(.05, 3))
#' y$b
#' 
#' #  Now use gsProbability to look at design
#' #  Note that lower boundary crossing probabilities are as
#' #  specified for theta=2.2, but for theta=0 the upper boundary
#' #  crossing probabilities are smaller than originally specified
#' #  above after first interim analysis
#' gsProbability(k=length(x$b), theta=c(0, 2.2), n.I=x$I, b=x$b, a= -y$b)
#' 
gsBound <- function(I, trueneg, falsepos, tol=0.000001, r=18){    
    # gsBound: assuming theta=0, derive lower and upper crossing boundaries given 
    #          timing of interims, false positive rates and true negative rates
    
    # check input arguments
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(trueneg, "numeric", c(0,1), c(TRUE, FALSE))
    checkVector(falsepos, "numeric", c(0,1), c(TRUE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkLengths(trueneg, falsepos, I)    
    
    k <- as.integer(length(I))
    if (trueneg[k]<=0.) stop("Final futility spend must be > 0")
    if (falsepos[k]<=0.) stop("Final efficacy spend must be > 0")
    r <- as.integer(r)
    storage.mode(I) <- "double"
    storage.mode(trueneg) <- "double"
    storage.mode(falsepos) <- "double"
    storage.mode(tol) <- "double"
    a <- falsepos
    b <- falsepos
    retval <- as.integer(0)
    xx <- .C("gsbound", k, I, a, b, trueneg, falsepos, tol, r, retval)
    rates <- list(falsepos=xx[[6]], trueneg=xx[[5]])
    
    list(k=xx[[1]],theta=0.,I=xx[[2]],a=xx[[3]],b=xx[[4]],rates=rates,tol=xx[[7]],
            r=xx[[8]],error=xx[[9]])
}

gsBound1 <- function(theta, I, a, probhi, tol=0.000001, r=18, printerr=0){   
    # gsBound1: derive upper bound to match specified upper bound crossing probability given
    #           a value of theta, a fixed lower bound and information at each analysis   
    
    # check input arguments
    checkScalar(theta, "numeric")
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(a, "numeric")
    checkVector(probhi, "numeric", c(0,1), c(TRUE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkScalar(printerr, "integer")
    checkLengths(a, probhi, I)
    
    # coerce type
    k <- as.integer(length(I))
    if (probhi[k]<=0.) stop("Final spend must be > 0")
    r <- as.integer(r)
    printerr <- as.integer(printerr)
    
    storage.mode(theta) <- "double"
    storage.mode(I) <- "double"
    storage.mode(a) <- "double"
    storage.mode(probhi) <- "double"
    storage.mode(tol) <- "double"
    problo <- a
    b <- a
    retval <- as.integer(0)
    
    xx <- .C("gsbound1", k, theta, I, a, b, problo, probhi, tol, r, retval, printerr)
    
    y <- list(k=xx[[1]], theta=xx[[2]], I=xx[[3]], a=xx[[4]], b=xx[[5]], 
            problo=xx[[6]], probhi=xx[[7]], tol=xx[[8]], r=xx[[9]], error=xx[[10]])
    
    if (y$error==0 && min(y$b-y$a) < 0)
    {   
        indx <- (y$b - y$a < 0)
        y$b[indx] <- y$a[indx]
        z <- gsprob(theta=theta, I=I, a=a, b=y$b, r=r)
        y$probhi <- z$probhi
        y$problo <- z$problo
    }
    
    y
}



#' 2.1: Design Derivation
#' 
#' \code{gsDesign()} is used to find boundaries and trial size required for a
#' group sequential design.
#' 
#' Many parameters normally take on default values and thus do not require
#' explicit specification. One- and two-sided designs are supported. Two-sided
#' designs may be symmetric or asymmetric. Wang-Tsiatis designs, including
#' O'Brien-Fleming and Pocock designs can be generated. Designs with common
#' spending functions as well as other built-in and user-specified functions
#' for Type I error and futility are supported. Type I error computations for
#' asymmetric designs may assume binding or non-binding lower bounds. The print
#' function has been extended using \code{\link{print.gsDesign}()} to print
#' \code{gsDesign} objects; see examples.
#' 
#' The user may ignore the structure of the value returned by \code{gsDesign()}
#' if the standard printing and plotting suffice; see examples.
#' 
#' \code{delta} and \code{n.fix} are used together to determine what sample
#' size output options the user seeks. The default, \code{delta=0} and
#' \code{n.fix=1}, results in a \sQuote{generic} design that may be used with
#' any sampling situation. Sample size ratios are provided and the user
#' multiplies these times the sample size for a fixed design to obtain the
#' corresponding group sequential analysis times. If \code{delta>0},
#' \code{n.fix} is ignored, and \code{delta} is taken as the standardized
#' effect size - the signal to noise ratio for a single observation; for
#' example, the mean divided by the standard deviation for a one-sample normal
#' problem.  In this case, the sample size at each analysis is computed.  When
#' \code{delta=0} and \code{n.fix>1}, \code{n.fix} is assumed to be the sample
#' size for a fixed design with no interim analyses. See examples below.
#' 
#' Following are further comments on the input argument \code{test.type} which
#' is used to control what type of error measurements are used in trial design.
#' The manual may also be worth some review in order to see actual formulas for
#' boundary crossing probabilities for the various options.  Options 3 and 5
#' assume the trial stops if the lower bound is crossed for Type I and Type II
#' error computation (binding lower bound).  For the purpose of computing Type
#' I error, options 4 and 6 assume the trial continues if the lower bound is
#' crossed (non-binding lower bound); that is a Type I error can be made by
#' crossing an upper bound after crossing a previous lower bound.
#' Beta-spending refers to error spending for the lower bound crossing
#' probabilities under the alternative hypothesis (options 3 and 4). In this
#' case, the final analysis lower and upper boundaries are assumed to be the
#' same. The appropriate total beta spending (power) is determined by adjusting
#' the maximum sample size through an iterative process for all options. Since
#' options 3 and 4 must compute boundary crossing probabilities under both the
#' null and alternative hypotheses, deriving these designs can take longer than
#' other options. Options 5 and 6 compute lower bound spending under the null
#' hypothesis.
#' 
#' @param k Number of analyses planned, including interim and final.
#' @param test.type \code{1=}one-sided \cr \code{2=}two-sided symmetric \cr
#' \code{3=}two-sided, asymmetric, beta-spending with binding lower bound \cr
#' \code{4=}two-sided, asymmetric, beta-spending with non-binding lower bound
#' \cr \code{5=}two-sided, asymmetric, lower bound spending under the null
#' hypothesis with binding lower bound \cr \code{6=}two-sided, asymmetric,
#' lower bound spending under the null hypothesis with non-binding lower bound.
#' \cr See details, examples and manual.
#' @param alpha Type I error, always one-sided. Default value is 0.025.
#' @param beta Type II error, default value is 0.1 (90\% power).
#' @param astar Normally not specified. If \code{test.type=5} or \code{6},
#' \code{astar} specifies the total probability of crossing a lower bound at
#' all analyses combined.  This will be changed to \eqn{1 - }\code{alpha} when
#' default value of 0 is used.  Since this is the expected usage, normally
#' \code{astar} is not specified by the user.
#' @param delta Effect size for theta under alternative hypothesis. This can be
#' set to the standardized effect size to generate a sample size if
#' \code{n.fix=NULL}. See details and examples.
#' @param n.fix Sample size for fixed design with no interim; used to find
#' maximum group sequential sample size. For a time-to-event outcome, input
#' number of events required for a fixed design rather than sample size and
#' enter fixed design sample size (optional) in \code{nFixSurv}.  See details
#' and examples.
#' @param timing Sets relative timing of interim analyses. Default of 1
#' produces equally spaced analyses.  Otherwise, this is a vector of length
#' \code{k} or \code{k-1}.  The values should satisfy \code{0 < timing[1] <
#' timing[2] < ... < timing[k-1] < timing[k]=1}.
#' @param sfu A spending function or a character string indicating a boundary
#' type (that is, \dQuote{WT} for Wang-Tsiatis bounds, \dQuote{OF} for
#' O'Brien-Fleming bounds and \dQuote{Pocock} for Pocock bounds).  For
#' one-sided and symmetric two-sided testing is used to completely specify
#' spending (\code{test.type=1, 2}), \code{sfu}.  The default value is
#' \code{sfHSD} which is a Hwang-Shih-DeCani spending function.  See details,
#' \link{Spending function overview}, manual and examples.
#' @param sfupar Real value, default is \eqn{-4} which is an
#' O'Brien-Fleming-like conservative bound when used with the default
#' Hwang-Shih-DeCani spending function. This is a real-vector for many spending
#' functions.  The parameter \code{sfupar} specifies any parameters needed for
#' the spending function specified by \code{sfu}; this will be ignored for
#' spending functions (\code{sfLDOF}, \code{sfLDPocock}) or bound types
#' (\dQuote{OF}, \dQuote{Pocock}) that do not require parameters.
#' @param sfl Specifies the spending function for lower boundary crossing
#' probabilities when asymmetric, two-sided testing is performed
#' (\code{test.type = 3}, \code{4}, \code{5}, or \code{6}).  Unlike the upper
#' bound, only spending functions are used to specify the lower bound.  The
#' default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending
#' function.  The parameter \code{sfl} is ignored for one-sided testing
#' (\code{test.type=1}) or symmetric 2-sided testing (\code{test.type=2}).  See
#' details, spending functions, manual and examples.
#' @param sflpar Real value, default is \eqn{-2}, which, with the default
#' Hwang-Shih-DeCani spending function, specifies a less conservative spending
#' rate than the default for the upper bound.
#' @param tol Tolerance for error (default is 0.000001). Normally this will not
#' be changed by the user.  This does not translate directly to number of
#' digits of accuracy, so use extra decimal places.
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @param n.I Used for re-setting bounds when timing of analyses changes from
#' initial design; see examples.
#' @param maxn.IPlan Used for re-setting bounds when timing of analyses changes
#' from initial design; see examples.
#' @param nFixSurv If a time-to-event variable is used, \code{nFixSurv}
#' computed as the sample size from \code{nSurvival} may be entered to have
#' \code{gsDesign} compute the total sample size required as well as the number
#' of events at each analysis that will be returned in \code{n.fix}; this is
#' rounded up to an even number.
#' @param endpoint An optional character string that should represent the type
#' of endpoint used for the study. This may be used by output functions. Types
#' most likely to be recognized initially are "TTE" for time-to-event outcomes
#' with fixed design sample size generated by \code{nSurvival()} and "Binomial"
#' for 2-sample binomial outcomes with fixed design sample size generated by
#' \code{nBinomial()}.
#' @param delta1 \code{delta1} and \code{delta0} may be used to store
#' information about the natural parameter scale compared to \code{delta} that
#' is a standardized effect size. \code{delta1} is the alternative hypothesis
#' parameter value on the natural parameter scale (e.g., the difference in two
#' binomial rates).
#' @param delta0 \code{delta0} is the null hypothesis parameter value on the
#' natural parameter scale.
#' @param overrun Scalar or vector of length \code{k-1} with patients enrolled
#' that are not included in each interim analysis.
#' @return An object of the class \code{gsDesign}. This class has the following
#' elements and upon return from \code{gsDesign()} contains: \item{k}{As
#' input.} \item{test.type}{As input.} \item{alpha}{As input.} \item{beta}{As
#' input.} \item{astar}{As input, except when \code{test.type=5} or \code{6}
#' and \code{astar} is input as 0; in this case \code{astar} is changed to
#' \code{1-alpha}.} \item{delta}{The standardized effect size for which the
#' design is powered. Will be as input to \code{gsDesign()} unless it was input
#' as 0; in that case, value will be computed to give desired power for fixed
#' design with input sample size \code{n.fix}.} \item{n.fix}{Sample size
#' required to obtain desired power when effect size is \code{delta}.}
#' \item{timing}{A vector of length \code{k} containing the portion of the
#' total planned information or sample size at each analysis.} \item{tol}{As
#' input.} \item{r}{As input.} \item{n.I}{Vector of length \code{k}. If values
#' are input, same values are output. Otherwise, \code{n.I} will contain the
#' sample size required at each analysis to achieve desired \code{timing} and
#' \code{beta} for the output value of \code{delta}.  If \code{delta=0} was
#' input, then this is the sample size required for the specified group
#' sequential design when a fixed design requires a sample size of
#' \code{n.fix}. If \code{delta=0} and \code{n.fix=1} then this is the relative
#' sample size compared to a fixed design; see details and examples.}
#' \item{maxn.IPlan}{As input.} \item{nFixSurv}{As input.} \item{nSurv}{Sample
#' size for Lachin and Foulkes method when \code{nSurvival} is used for fixed
#' design input. If \code{nSurvival} is used to compute \code{n.fix}, then
#' \code{nFixSurv} is inflated by the same amount as \code{n.fix} and stored in
#' \code{nSurv}. Note that if you use \code{gsSurv} for time-to-event sample
#' size, this is not needed and a more complete output summary is given.}
#' \item{endpoint}{As input.} \item{delta1}{As input.} \item{delta0}{As input.}
#' \item{overrun}{As input.} \item{upper}{Upper bound spending function,
#' boundary and boundary crossing probabilities under the NULL and alternate
#' hypotheses. See \link{Spending function overview} and manual for further
#' details.} \item{lower}{Lower bound spending function, boundary and boundary
#' crossing probabilities at each analysis. Lower spending is under alternative
#' hypothesis (beta spending) for \code{test.type=3} or \code{4}.  For
#' \code{test.type=2}, \code{5} or \code{6}, lower spending is under the null
#' hypothesis. For \code{test.type=1}, output value is \code{NULL}. See
#' \link{Spending function overview} and manual.} \item{theta}{Standarized
#' effect size under null (0) and alternate hypothesis. If \code{delta} is
#' input, \code{theta[1]=delta}. If \code{n.fix} is input, \code{theta[1]} is
#' computed using a standard sample size formula (pseudocode):
#' \code{((Zalpha+Zbeta)/theta[1])^2=n.fix}.} \item{falseprobnb}{For
#' \code{test.type=4} or \code{6}, this contains false positive probabilities
#' under the null hypothesis assuming that crossing a futility bound does not
#' stop the trial.} \item{en}{Expected sample size accounting for early
#' stopping. For time-to-event outcomes, this would be the expected number of
#' events (although \code{gsSurv} will give expected sample size). For
#' information-based-design, this would give the expected information when the
#' trial stops. If \code{overrun} is specified, the expected sample size
#' includes the overrun at each interim.}
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \link{gsDesign package overview}, \link{gsDesign print, summary and
#' table summary functions}, \link{Plots for group sequential designs},
#' \code{\link{gsProbability}}, \link{Spending function overview},
#' \link{Wang-Tsiatis Bounds}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' #  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#' #  lower bound is non-binding (ignored in Type I error computation)
#' #  sample size is computed based on a fixed design requiring n=800
#' x <- gsDesign(k=5, test.type=2, n.fix=800)
#' 
#' # note that "x" below is equivalent to print(x) and print.gsDesign(x)
#' x
#' plot(x)
#' plot(x, plottype=2)
#' 
#' # Assuming after trial was designed actual analyses occurred after
#' # 300, 600, and 860 patients, reset bounds 
#' y <- gsDesign(k=3, test.type=2, n.fix=800, n.I=c(300,600,860),
#'    maxn.IPlan=x$n.I[x$k])
#' y
#' 
#' #  asymmetric design with user-specified spending that is non-binding
#' #  sample size is computed relative to a fixed design with n=1000
#' sfup <- c(.033333, .063367, .1)
#' sflp <- c(.25, .5, .75)
#' timing <- c(.1, .4, .7)
#' x <- gsDesign(k=4, timing=timing, sfu=sfPoints, sfupar=sfup, sfl=sfPoints,
#' 	            sflpar=sflp,n.fix=1000) 
#' x
#' plot(x)
#' plot(x, plottype=2)
#' 
#' # same design, but with relative sample sizes
#' gsDesign(k=4, timing=timing, sfu=sfPoints, sfupar=sfup, sfl=sfPoints,
#' sflpar=sflp)
#' 
gsDesign <- function(k=3, test.type=4, alpha=0.025, beta=0.1, astar=0,  
        delta=0, n.fix=1, timing=1, sfu=sfHSD, sfupar=-4,
        sfl=sfHSD, sflpar=-2, tol=0.000001, r=18, n.I=0, maxn.IPlan=0, 
        nFixSurv=0, endpoint=NULL, delta1=1, delta0=0, overrun=0) {
    # Derive a group sequential design and return in a gsDesign structure
    
    # set up class variable x for gsDesign being requested
    x <- list(k=k, test.type=test.type, alpha=alpha, beta=beta, astar=astar,
            delta=delta, n.fix=n.fix, timing=timing, tol=tol, r=r, n.I=n.I, maxn.IPlan=maxn.IPlan,
            nFixSurv=nFixSurv, nSurv=0, endpoint=endpoint, delta1=delta1, delta0=delta0, overrun=overrun)
    
    class(x) <- "gsDesign"
    
    # check parameters other than spending functions
    x <- gsDErrorCheck(x)

    # set up spending for upper bound
    if (is.character(sfu))
    {  
        upper <- list(sf = sfu, name = sfu, parname = "Delta", param = sfupar)
        
        class(upper) <- "spendfn"
        
        if (!is.element(upper$name,c("OF", "Pocock" , "WT")))           
        {
            stop("Character specification of upper spending may only be WT, OF or Pocock")
        }
        
        if (is.element(upper$name, c("OF", "Pocock")))
        {    
            upper$param <- NULL
        }
    }
    else if (!is.function(sfu))
    {   
        stop("Upper spending function mis-specified")
    }
    else
    {   
        upper <- sfu(x$alpha, x$timing, sfupar)
        upper$sf <- sfu
    }
    
    x$upper <- upper
    
    # set up spending for lower bound
    if (x$test.type == 1) 
    {
        x$lower <- NULL
    }
    else if (x$test.type == 2) 
    {
        x$lower <- x$upper
    }
    else
    {   
        if (!is.function(sfl))
        {     
            stop("Lower spending function must return object with class spendfn")
        }
        else if (is.element(test.type, 3:4)) 
        {
            x$lower <- sfl(x$beta, x$timing, sflpar)
        }
        else if (is.element(test.type, 5:6)) 
        {   
            if (x$astar == 0) 
            {
                x$astar <- 1 - x$alpha
            }
            x$lower <- sfl(x$astar, x$timing, sflpar)
        }
        
        x$lower$sf <- sfl
    }
    
    # call appropriate calculation routine according to test.type
    x <- switch(x$test.type,
            gsDType1(x),
            gsDType2and5(x),
            gsDType3(x),
            gsDType4(x),
            gsDType2and5(x),
            gsDType6(x))
    if (x$nFixSurv > 0) x$nSurv <- ceiling(x$nFixSurv * x$n.I[x$k] / n.fix / 2) * 2
    x
}



#' 2.2: Boundary Crossing Probabilities
#' 
#' Computes power/Type I error and expected sample size for a group sequential
#' design across a selected set of parameter values for a given set of analyses
#' and boundaries. The print function has been extended using
#' \code{print.gsProbability} to print \code{gsProbability} objects; see
#' examples.
#' 
#' Depending on the calling sequence, an object of class \code{gsProbability}
#' or class \code{gsDesign} is returned. If it is of class \code{gsDesign} then
#' the members of the object will be the same as described in
#' \code{\link{gsDesign}}. If \code{d} is input as \code{NULL} (the default),
#' all other arguments (other than \code{r}) must be specified and an object of
#' class \code{gsProbability} is returned. If \code{d} is passed as an object
#' of class \code{gsProbability} or \code{gsDesign} the only other argument
#' required is \code{theta}; the object returned has the same class as the
#' input \code{d}. On output, the values of \code{theta} input to
#' \code{gsProbability} will be the parameter values for which the design is
#' characterized.
#' 
#' @aliases gsProbability print.gsProbability
#' @param k Number of analyses planned, including interim and final.
#' @param theta Vector of standardized effect sizes for which boundary crossing
#' probabilities are to be computed.
#' @param n.I Sample size or relative sample size at analyses; vector of length
#' k. See \code{\link{gsDesign}} and manual.
#' @param a Lower bound cutoffs (z-values) for futility or harm at each
#' analysis, vector of length k.
#' @param b Upper bound cutoffs (z-values) for futility at each analysis;
#' vector of length k.
#' @param r Control for grid as in Jennison and Turnbull (2000); default is 18,
#' range is 1 to 80.  Normally this will not be changed by the user.
#' @param d If not \code{NULL}, this should be an object of type
#' \code{gsDesign} returned by a call to \code{gsDesign()}.  When this is
#' specified, the values of \code{k}, \code{n.I}, \code{a}, \code{b}, and
#' \code{r} will be obtained from \code{d} and only \code{theta} needs to be
#' specified by the user.
#' @param x An item of class \code{gsProbability}.
#' @param overrun Scalar or vector of length \code{k-1} with patients enrolled
#' that are not included in each interim analysis.
#' @param \dots Not implemented (here for compatibility with generic print
#' input).
#' @return \item{k}{As input.} \item{theta}{As input.} \item{n.I}{As input.}
#' \item{lower}{A list containing two elements: \code{bound} is as input in
#' \code{a} and \code{prob} is a matrix of boundary crossing probabilities.
#' Element \code{i,j} contains the boundary crossing probability at analysis
#' \code{i} for the \code{j}-th element of \code{theta} input. All boundary
#' crossing is assumed to be binding for this computation; that is, the trial
#' must stop if a boundary is crossed.} \item{upper}{A list of the same form as
#' \code{lower} containing the upper bound and upper boundary crossing
#' probabilities.} \item{en}{A vector of the same length as \code{theta}
#' containing expected sample sizes for the trial design corresponding to each
#' value in the vector \code{theta}.} \item{r}{As input.} Note:
#' \code{print.gsProbability()} returns the input \code{x}.
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \link{Plots for group sequential designs}, \code{\link{gsDesign}},
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' # making a gsDesign object first may be easiest...
#' x <- gsDesign()
#' 
#' # take a look at it
#' x
#' 
#' # default plot for gsDesign object shows boundaries
#' plot(x)
#' 
#' # plottype=2 shows boundary crossing probabilities
#' plot(x, plottype=2)
#' 
#' # now add boundary crossing probabilities and 
#' # expected sample size for more theta values
#' y <- gsProbability(d=x, theta=x$delta*seq(0, 2, .25))
#' class(y)
#' 
#' # note that "y" below is equivalent to print(y) and
#' # print.gsProbability(y)
#' y
#' 
#' # the plot does not change from before since this is a
#' # gsDesign object; note that theta/delta is on x axis
#' plot(y, plottype=2)
#' 
#' # now let's see what happens with a gsProbability object
#' z <- gsProbability(k=3, a=x$lower$bound, b=x$upper$bound, 
#'     n.I=x$n.I, theta=x$delta*seq(0, 2, .25))
#' 
#' # with the above form,  the results is a gsProbability object
#' class(z)
#' z
#' 
#' # default plottype is now 2
#' # this is the same range for theta, but plot now has theta on x axis
#' plot(z)
#' 
gsProbability <- function(k=0, theta, n.I, a, b, r=18, d=NULL, overrun=0){
    # compute boundary crossing probabilities and return in a gsProbability structure
    
    # check input arguments
    checkScalar(k, "integer", c(0,30))
    checkVector(theta, "numeric")

    if (k == 0)
    {   
        if (!is(d,"gsDesign"))
        {
            stop("d should be an object of class gsDesign")
        }
        return(gsDProb(theta=theta, d=d))
    }
    
    # check remaining input arguments
    checkVector(x=overrun,isType="numeric",interval=c(0,Inf),inclusion=c(TRUE,FALSE))
    if(length(overrun)!= 1 && length(overrun)!= k-1) stop(paste("overrun length should be 1 or ",as.character(k-1)))
    checkScalar(r, "integer", c(1,80))
    checkLengths(n.I, a, b)
    if (k != length(a))
    {
        stop("Lengths of n.I, a, and b must all equal k")
    }
    
    # cast integer scalars
    ntheta <- as.integer(length(theta))
    k <- as.integer(k)
    r <- as.integer(r)
    
    phi <- as.double(c(1:(k * ntheta)))
    plo <- as.double(c(1:(k * ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    if(k==1){nOver <- n.I[k]}else{
      nOver <- c(n.I[1:(k-1)]+overrun,n.I[k])
    }
    nOver[nOver>n.I[k]] <- n.I[k]
    en <- as.vector(nOver %*% (plo + phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))
    x <- list(k=xx[[1]], theta=xx[[3]], n.I=xx[[4]], lower=list(bound=xx[[5]], prob=plo), 
            upper=list(bound=xx[[6]], prob=phi), en=en, r=r, overrun=overrun)
    
    class(x) <- "gsProbability"
    
    x
}

gsPOS <- function(x, theta, wgts){
    if (!is(x,c("gsProbability","gsDesign")))
      stop("x must have class gsProbability or gsDesign")
    checkVector(theta, "numeric")
    checkVector(wgts, "numeric")
    checkLengths(theta, wgts)    
    x <- gsProbability(theta = theta, d=x)
    one <- array(1, x$k)
    as.double(one %*% x$upper$prob %*% wgts)
}

gsCPOS <- function(i, x, theta, wgts){
    if (!is(x,c("gsProbability","gsDesign")))
      stop("x must have class gsProbability or gsDesign")
    checkScalar(i, "integer", c(1, x$k), c(TRUE, FALSE))
    checkVector(theta, "numeric")
    checkVector(wgts, "numeric")
    checkLengths(theta, wgts)    
    x <- gsProbability(theta = theta, d=x)
    v <- c(array(1, i), array(0, (x$k - i)))
    pAi <- 1 - as.double(v %*% (x$upper$prob + x$lower$prob) %*% wgts)
    v <- 1 - v
    pAiB <- as.double(v %*% x$upper$prob %*% wgts)
    pAiB / pAi
}



#' 2.6: Group sequential design interim density function
#' 
#' Given an interim analysis \code{i} of a group sequential design and a vector
#' of real values \code{zi}, \code{gsDensity()} computes an interim density
#' function at analysis \code{i} at the values in \code{zi}.  For each value in
#' \code{zi}, this interim density is the derivative of the probability that
#' the group sequential trial does not cross a boundary prior to the
#' \code{i}-th analysis and at the \code{i}-th analysis the interim Z-statistic
#' is less than that value. When integrated over the real line, this density
#' computes the probability of not crossing a bound at a previous analysis. It
#' corresponds to the subdistribution function at analysis \code{i} that
#' excludes the probability of crossing a bound at an earlier analysis.
#' 
#' The initial purpose of this routine was as a component needed to compute the
#' predictive power for a trial given an interim result; see
#' \code{\link{gsPP}}.
#' 
#' See Jennison and Turnbull (2000) for details on how these computations are
#' performed.
#' 
#' @param x An object of type \code{gsDesign} or \code{gsProbability}
#' @param theta a vector with \eqn{\theta}{theta} value(s) at which the interim
#' density function is to be computed.
#' @param i analysis at which interim z-values are given; must be from 1 to
#' \code{x$k}
#' @param zi interim z-value at analysis \code{i} (scalar)
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @return \item{zi}{The input vector \code{zi}.} \item{theta}{The input vector
#' \code{theta}.} \item{density}{A matrix with \code{length(zi)} rows and
#' \code{length(theta)} columns.  The subdensity function for \code{z[j]},
#' \code{theta[m]} at analysis \code{i} is returned in \code{density[j,m]}. }
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{gsDesign}}, \code{\link{gsProbability}},
#' \code{\link{gsBoundCP}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' # set up a group sequential design
#' x <- gsDesign()
#' 
#' # set theta values where density is to be evaluated
#' theta <- x$theta[2] * c(0, .5, 1, 1.5)
#' 
#' # set zi values from -1 to 7 where density is to be evaluated
#' zi <- seq(-3, 7, .05)
#' 
#' # compute subdensity values at analysis 2
#' y <- gsDensity(x, theta=theta, i=2, zi=zi)
#' 
#' # plot sub-density function for each theta value
#' plot(y$zi, y$density[,3], type="l", xlab="Z",
#'      ylab="Interim 2 density", lty=3, lwd=2)
#' lines(y$zi, y$density[,2], lty=2, lwd=2)
#' lines(y$zi, y$density[,1], lwd=2)
#' lines(y$zi, y$density[,4], lty=4, lwd=2)
#' title("Sub-density functions at interim analysis 2")
#' legend(x=c(3.85,7.2), y = c(.27,.385), lty=1:5, lwd=2, cex=1.5,
#' legend=c(
#' expression(paste(theta,"=0.0")),
#' expression(paste(theta,"=0.5", delta)),
#' expression(paste(theta,"=1.0", delta)),
#' expression(paste(theta,"=1.5", delta))))
#' 
#' # add vertical lines with lower and upper bounds at analysis 2
#' # to demonstrate how likely it is to continue, stop for futility
#' # or stop for efficacy at analysis 2 by treatment effect
#' lines(array(x$upper$bound[2],2), c(0,.4),col=2)
#' lines(array(x$lower$bound[2],2), c(0,.4), lty=2, col=2)
#' 
#' # Replicate part of figures 8.1 and 8.2 of Jennison and Turnbull text book
#' # O'Brien-Fleming design with four analyses
#' 
#' x <- gsDesign(k=4, test.type=2, sfu="OF", alpha=.1, beta=.2)
#' 
#' z <- seq(-4.2, 4.2, .05)
#' d <- gsDensity(x=x, theta=x$theta, i=4, zi=z)
#' 
#' plot(z, d$density[,1], type="l", lwd=2, ylab=expression(paste(p[4],"(z,",theta,")")))
#' lines(z, d$density[,2], lty=2, lwd=2)
#' u <- x$upper$bound[4]
#' text(expression(paste(theta,"=",delta)),x=2.2, y=.2, cex=1.5)
#' text(expression(paste(theta,"=0")),x=.55, y=.4, cex=1.5)
#' 
gsDensity <- function(x, theta=0, i=1, zi=0, r=18){
  if (class(x) != "gsDesign" && class(x) != "gsProbability")
        stop("x must have class gsDesign or gsProbability.")
    checkVector(theta, "numeric")
    checkScalar(i, "integer", c(0,x$k), c(FALSE, TRUE))
    checkVector(zi, "numeric")
    checkScalar(r, "integer", c(1, 80)) 
    den <- array(0, length(theta) * length(zi))
    xx <- .C("gsdensity", den, as.integer(i), length(theta), 
              as.double(theta), as.double(x$n.I), 
              as.double(x$lower$bound), as.double(x$upper$bound),
              as.double(zi), length(zi), as.integer(r))
    list(zi=zi, theta=theta, density=matrix(xx[[1]], nrow=length(zi), ncol=length(theta)))
}


###
# Hidden Functions
###

gsDType1 <- function(x, ss=1){    
    # gsDType1: calculate bound assuming one-sided rule (only upper bound)
    
    # set lower bound
    a <- array(-20, x$k)

    # get Wang-Tsiatis bound, if desired
    if (is.element(x$upper$name, c("WT", "Pocock", "OF")))
    {    
        Delta <- switch(x$upper$name, WT = x$upper$param, Pocock = 0.5, 0) 
   
        cparam <- WT(Delta, x$alpha, a, x$timing, x$tol, x$r)
        x$upper$bound <- cparam * x$timing^(Delta - 0.5)
        
        x$upper$spend <- as.vector(gsprob(0., x$timing, a, x$upper$bound, x$r)$probhi)
        falsepos <- x$upper$spend
    }

    # otherwise, get bound using specified spending
    else
    {    
        # set false positive rates
        falsepos <- x$upper$spend
        falsepos <- falsepos - c(0, falsepos[1:x$k-1])
        x$upper$spend <- falsepos

        # compute upper bound and store in x
        x$upper$bound <- gsBound1(0, x$timing, a, falsepos, x$tol, x$r)$b
    }

    # set information to get desired power (only if sample size is being computed)
    if (max(x$n.I) == 0)
    {
       x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10*x$n.fix, theta=x$delta, beta=x$beta,
                        time=x$timing, a=a, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
    }
    
    # add boundary crossing probabilities for theta to x
    x$theta <- c(0,x$delta)
    y <- gsprob(x$theta, x$n.I, a, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- y$probhi
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos - y$probhi[,1])) > x$tol)
    {
        stop("False positive rates not achieved")   
    }

    x
}

gsDType2and5 <- function(x){    
    # gsDType2and5: calculate bound assuming two-sided rule, binding, all alpha spending    
    
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        if (x$test.type == 5)
        {
            stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")          
        }

        Delta <- switch(x$upper$name, WT = x$upper$param, Pocock = 0.5, 0) 
        
        cparam <- WT(Delta, x$alpha, 1, x$timing, x$tol, x$r)
        x$upper$bound <- cparam * x$timing^(Delta - 0.5)
        
        x$upper$spend <- as.vector(gsprob(0., x$timing, -x$upper$bound, x$upper$bound, x$r)$probhi)
        x$lower <- x$upper
        x$lower$bound<- -x$lower$bound
        
        # set information to get desired power
        if (max(x$n.I) == 0)
        {    
            x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10*x$n.fix, theta=x$delta, beta=x$beta,
                             time=x$timing, a=x$lower$bound, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
        }
        
        falsepos <- x$upper$spend
        trueneg <- x$lower$spend
    }
    else
    {    
        falsepos <- x$upper$spend
        falsepos <- falsepos - c(0,falsepos[1:x$k-1])
        x$upper$spend <- falsepos
        if (x$test.type == 5)
        {   trueneg <- x$lower$spend
            trueneg <- trueneg - c(0,trueneg[1:x$k-1])
            errno <- 0
        }
        else 
        {   trueneg <- falsepos
            errno <- 0
        }
        
        x$lower$spend <- trueneg
        
        # argument for "symmetric" to gsI should be 1 unless test.type==5 and astar=1-alpha
        sym <- ifelse(x$test.type == 2 || x$astar < 1 - x$alpha, 1, 0)
        
        # set information to get desired power (only if sample size is being computed)
        if (max(x$n.I) == 0)
        {    
            x2 <- gsI(I=x$timing, theta=x$delta, beta=x$beta, trueneg=trueneg, 
                      falsepos=falsepos, symmetric=sym)
            
            x$n.I <- x2$I
        }
        else
        {
            x2 <- gsBound(I=x$n.I, trueneg=trueneg, falsepos=falsepos, tol=x$tol, r=x$r)
        }
        
        x$upper$bound <- x2$b
        x$lower$bound <- x2$a
    }
    
    x$theta <- c(0, x$delta)
    y <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- y$probhi
    x$lower$prob <- y$problo
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities to not meet desired tolerance
    if (max(abs(falsepos - x$upper$prob[,1])) > x$tol)
    {
        stop("False positive rates not achieved")        
    }

    if (max(abs(trueneg - x$lower$prob[,1])) > x$tol)
    {
        stop("False negative rates not achieved")
    }

    x
}

gsDType3 <- function(x){
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")  
    }
    
    # gsDType3: calculate bound assuming binding stopping rule and beta spending
    # this routine should get a thorough check for error handling!!!    
    if (max(x$n.I) == 0) gsDType3ss(x) else gsDType3a(x)
}

gsDType3ss <- function(x){    
    # compute starting bounds under H0 
    k <- x$k
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0, falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    trueneg <- array((1 - x$alpha) / x$k, x$k)
    x1 <- gsBound(x$timing, trueneg, falsepos, x$tol, x$r)

    # get I(max) and lower bound
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    Ilow <- x$n.fix / 3
    Ihigh <- 1.2 * x$n.fix
    while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x1$b, tol=x$tol, r=x$r))
    {   if (Ihigh > 5 * x$n.fix)
            stop("Unable to derive sample size")
        Ilow <- Ihigh
        Ihigh <- Ihigh * 1.2
    }
    x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x1$b, Ilow=Ilow,
               Ihigh=Ihigh, x$tol, x$r)
    
    #check alpha
    x3 <- gsprob(0, x2$I, x2$a, x2$b)
    gspowr <- x3$powr
    I <- x2$I
    flag <- abs(gspowr - x$alpha)
 
    # iterate until Type I error is correct
    jj <- 0
    while (flag > x$tol && jj < 100)
    {    
        # if alpha <> power, go back to set upper bound, lower bound and I(max) 
        x4 <- gsBound1(0, I, c(x2$a[1:k-1],-20), falsepos)
        Ilow <- x$n.fix / 3
        Ihigh <- 1.2 * x$n.fix
        while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x4$b, tol=x$tol, r=x$r))
        {   if (Ihigh > 5 * x$n.fix)
                stop("Unable to derive sample size")
            Ilow <- Ihigh
            Ihigh <- Ihigh * 1.2
        }
        x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x4$b, 
                   Ilow=Ilow,Ihigh=Ihigh,x$tol,x$r)
        x3 <- gsprob(0,x2$I,x2$a,x2$b)
        gspowr <- x3$powr
        I <- x2$I
        flag <- max(abs(c(gspowr-x$alpha,falsepos - x3$probhi))) # bug fix here, 20140221, KA
        jj <- jj + 1
    }

    # add bounds and information to x
    x$upper$bound <- x2$b
    x$lower$bound <- x2$a
    x$n.I <- x2$I

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x2$I, x2$a, x2$b, overrun=x$overrun)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)

    # return error if boundary crossing probabilities 
    # do not meet desired tolerance
    if (max(abs(falsepos - x3$probhi)) > x$tol)
    {
        stop("False positive rates not achieved")       
    }

    if (max(abs(falseneg - x2$problo)) > x$tol)
    {
        stop("False negative rates not achieved")       
    }

    x
}

gsDType3a <- function(x){    
    aspend <- x$upper$spend
    bspend <- x$lower$spend
    
    # try to match spending
    x <- gsDType3b(x)
    if (x$test.type==4){
        return(x)
    } 
    
    # if alpha spent, finish
    if (sum(x$upper$prob[,1]) > x$alpha - x$tol)
    {
        return(x)
    }
    
    # if beta spent prior to final analysis, reduce x$k
    pwr <- 1 - x$beta
    pwrtot <- 0
    for (i in 1:x$k)
    {    
        pwrtot <- pwrtot + x$upper$prob[i,2]
        if (pwrtot > pwr-x$tol) 
        {
            break
        }
    }
    x$k <- i
    x$n.I <- x$n.I[1:i]
    x$timing <- x$timing[1:i]
    x$upper$spend <- c(aspend[1:i-1], x$alpha)
    x$lower$spend <- c(bspend[1:i-1], x$beta)
    
    gsDType3b(x)
}

gsDType3b <- function(x){    
    # set I0, desired false positive and false negative rates
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg - c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    falsepos <- x$upper$spend
    falsepos <- falsepos - c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos

    # compute initial upper bound under H0 
    trueneg <- array((1 - x$alpha) / x$k, x$k)
    x1 <- gsBound(x$timing, trueneg, falsepos, x$tol, x$r)
    
    # x$k==1 is a special case
    if (x$k == 1)
    {    
        x$upper$bound <- x1$b
        x$lower$bound <- x1$b
    }
    else
    {
        # get initial lower bound
          x2 <- gsBound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
          x2$b[x2$k] <- -x1$b[x1$k]
          x2 <- gsprob(x$delta, x$n.I, -x2$b, x1$b, r=x$r)

          # set up x3 for loop and set flag so loop runs 1st time
          x3 <- gsprob(0, x2$I, x2$a, x2$b, r=x$r)
          flag <- x$tol + 1
    
        # iterate until convergence
        while (flag > x$tol)
        {    
            aold <- x2$a
            bold <- x2$b
            alphaold <- x3$powr
            a <- c(x2$a[1:(x2$k-1)], -20)
            x4 <- gsBound1(0, x$n.I, a, falsepos)
            x2 <- gsBound1(theta=-x$delta, I=x$n.I, a=-x4$b, probhi=falseneg, tol=x$tol, r=x$r)
            x2$a[x2$k] <-  x2$b[x2$k]
            x2 <- gsprob(x$delta, x$n.I, -x2$b, x4$b, r=x$r)
            x3 <- gsprob(0, x2$I, x2$a, x2$b)
            flag <- max(abs(c(x2$a - aold, x2$b - bold, alphaold - x3$powr)))
        }

        # add bounds and information to x
        x$upper$bound <- x2$b
        x$lower$bound <- x2$a
    }
    
    # add boundary crossing probabilities for theta to x
    x$theta <- c(0,x$delta)
    x4 <- gsprob(x$theta,x$n.I,x$lower$bound,x$upper$bound,overrun=x$overrun)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)
    
    x
}

gsDType4 <- function(x){
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")       
    }
    
    if (length(x$n.I) < x$k) gsDType4ss(x) 
    else gsDType4a(x)
}

gsDType4a <- function(x){    
    # set I0, desired false positive and false negative rates
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg - c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    falsepos <- x$upper$spend
    falsepos <- falsepos - c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos

    # compute upper bound under H0 
    x1 <- gsBound1(theta = 0, I = x$n.I, a = array(-20, x$k), probhi = falsepos, tol = x$tol, r = x$r)

    # get lower bound
    x2 <- gsBound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
    if (-x2$b[x2$k] > x1$b[x1$k] - x$tol)
    {
        x2$b[x2$k] <- -x1$b[x1$k]
    }

    # add bounds and information to x
    x$upper$bound <- x1$b
    x$lower$bound <- -x2$b

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x$n.I, -x2$b, x1$b, overrun=x$overrun)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)

    x
}

gsDType4ss <- function(x){    
    # compute starting bounds under H0 
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    x0 <- gsBound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)

    # get beta spending (falseneg)
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0,falseneg[1:x$k-1])
    x$lower$spend <- falseneg

    # find information and boundaries needed 
    I0 <- x$n.fix
    Ilow <- .98 * I0
    Ihigh <- 1.2 * I0
    while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x0$b, tol=x$tol, r=x$r))
    {   if (Ihigh > 5 * I0)
            stop("Unable to derive sample size")
        Ilow <- Ihigh
        Ihigh <- Ihigh * 1.2
    }
    xx <- gsI1(theta = x$delta, I = x$timing, beta = falseneg, b = x0$b, Ilow = Ilow, Ihigh = Ihigh, x$tol, x$r)
    x$lower$bound <- xx$a
    x$upper$bound <- xx$b
    x$n.I <- xx$I

    # compute additional error rates needed and add to x
    x$theta <- c(0, x$delta)
    x$falseposnb <- as.vector(gsprob(0, xx$I, array(-20, x$k), x0$b, r=x$r)$probhi)
    x3 <- gsprob(x$theta, xx$I, xx$a, x0$b, r=x$r, overrun=x$overrun)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        stop("False positive rates not achieved")
    }

    if (max(abs(falseneg-x$lower$prob[,2])) > x$tol)
    {
        stop("False negative rates not achieved")      
    }

    x
}

gsDType6 <- function(x){
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")          
    }
    
    if (length(x$n.I) == x$k) x$timing <- x$n.I / x$maxn.IPlan

    # compute upper bounds with non-binding assumption 
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0, falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    x0 <- gsBound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)
    x$upper$bound <- x0$b
    
    if (x$astar == 1 - x$alpha)
    {   
        # get lower spending (trueneg) and lower bounds using binding
        flag <- 1
        tn <- x$lower$spend
        tn <- tn - c(0, tn[1:x$k-1])
        trueneg <- tn
        
        i <- 0
        
        while (flag > x$tol && i < 10)
        {      
            xx <- gsBound1(0, x$timing, -x$upper$bound, trueneg, x$tol, x$r)
            alpha <- sum(xx$problo)
            trueneg <- (1 - alpha) * tn / x$astar
            xx2 <- gsprob(0, x$timing, c(-xx$b[1:x$k-1], x$upper$bound[x$k]), x$upper$bound, r=x$r)
            flag <- max(abs(as.vector(xx2$problo) - trueneg))
            i <- i + 1
        }
        
        x$lower$spend <- trueneg
        x$lower$bound <- xx2$a
      }
      else
      {   
          trueneg <- x$lower$spend
          trueneg <- trueneg - c(0, trueneg[1:x$k-1])
          x$lower$spend <- trueneg
          xx <- gsBound1(0, x$timing, -x$upper$bound, x$lower$spend, x$tol, x$r)
          x$lower$bound <- -xx$b
      }
    # find information needed 
    if (max(x$n.I) == 0)
    {    
        x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10 * x$n.fix, theta=x$delta, beta=x$beta, time=x$timing,
               a=x$lower$bound, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
    }
    
    # compute error rates needed and add to x
    x$theta <- c(0,x$delta)
    x$falseposnb <- as.vector(gsprob(0, x$n.I, array(-20, x$k), x$upper$bound,r =x$r)$probhi)
    x3 <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        stop("False positive rates not achieved")       
    }

    if (max(abs(trueneg[1:x$k-1] - x$lower$prob[1:x$k-1,1])) > x$tol)
    {
        stop("True negative rates not achieved")    
    }

    x
}

gsbetadiff <- function(Imax, theta, beta, time, a, b, tol=0.000001, r=18){    
    # compute difference between actual and desired Type II error     
    I <- time * Imax
    x <- gsprob(theta, I, a, b, r)

    beta - 1 + sum(x$probhi)
}

gsI <- function(I, theta, beta, trueneg, falsepos, symmetric, tol=0.000001, r=18){   
    # gsI: find gs design with falsepos and trueneg
  
    k <- length(I)
    tx <- I/I[k]
    x <- gsBound(I, trueneg, falsepos, tol, r)
    alpha <- sum(falsepos)
    I0 <- ((qnorm(alpha)+qnorm(beta))/theta)^2
    x$I <- uniroot(gsbetadiff, lower=I0, upper=10*I0, theta=theta, beta=beta, time=tx, 
                 a=x$a, b=x$b, tol=tol, r=r)$root*tx 
         
    if (symmetric==0)
    {
        x$a[x$k] <- x$b[x$k]
    }
    
    y <- gsprob(theta, x$I, x$a, x$b, r=r)
    rates <- list(falsepos=x$rates$falsepos, trueneg=x$rates$trueneg, 
                  falseneg=as.vector(y$problo), truepos=as.vector(y$probhi))
          
    list(k=x$k, theta0=0, theta1=theta, I=x$I, a=x$a, b=x$b, alpha=alpha, beta=beta, 
        rates=rates, futilitybnd="Binding", tol=x$tol, r=x$r, error=x$error)
}

gsbetadiff1 <- function(Imax, theta, tx, problo, b, tol=0.000001, r=18){   
    # gsbetadiff1: compute difference between desired and actual upper boundary
    #              crossing probability    
    I <- tx * Imax
    x <- gsBound1(theta=-theta, I=I, a=-b, probhi=problo, tol=tol, r=r)
    x <- gsprob(theta, I, -x$b, b, r=r)

    sum(problo) - 1 + x$powr
}

gsI1 <- function(theta, I, beta, b, Ilow, Ihigh, tol=0.000001, r=18){
    # gsI1: get lower bound and maximum information (Imax)    
    k <- length(I)
    tx <- I / I[k]
    xr <- uniroot(gsbetadiff1, lower=Ilow, upper=Ihigh, theta=theta, tx=tx, 
            problo=beta, b=b, tol=tol, r=r)
    x <- gsBound1(-theta, xr$root*tx, -b, probhi=beta, tol=tol, r=r)
    error <- x$error
    x$b[k] <- -b[k]
    x <- gsprob(theta, xr$root*tx, -x$b, b, r=r)
    x$error <- error
    
    x
}

gsprob <- function(theta, I, a, b, r=18, overrun=0){     
    # gsprob: use call to C routine to compute upper and lower boundary crossing probabilities
    # given theta,  interim sample sizes (information: I),  lower bound (a) and upper bound (b)    
    nanal <- as.integer(length(I))
    ntheta <- as.integer(length(theta))
    phi <- as.double(c(1:(nanal*ntheta)))
    plo <- as.double(c(1:(nanal*ntheta)))
    xx <- .C("probrej", nanal, ntheta, as.double(theta), as.double(I), 
            as.double(a), as.double(b), plo, phi, as.integer(r))
    
    plo <- matrix(xx[[7]], nanal, ntheta)
    phi <- matrix(xx[[8]], nanal, ntheta)
    powr <- array(1, nanal)%*%phi
    futile <- array(1, nanal)%*%plo
    IOver <- c(I[1:(nanal-1)]+overrun,I[nanal])
    IOver[IOver>I[nanal]]<-I[nanal]
    en <- as.vector(IOver %*% (plo+phi) + I[nanal] * (t(array(1, ntheta)) - powr - futile))
    list(k=xx[[1]], theta=xx[[3]], I=xx[[4]], a=xx[[5]], b=xx[[6]], problo=plo, 
            probhi=phi, powr=powr, en=en, r=r)
}

gsDProb <- function(theta, d){    
    k <- d$k
    n.I <- d$n.I
    
    a <- if (d$test.type != 1) d$lower$bound else array(-20, k)    
    b <- d$upper$bound
    r <- d$r
    ntheta <- as.integer(length(theta))
    theta <- as.double(theta)
    
    phi <- as.double(c(1:(k*ntheta)))
    plo <- as.double(c(1:(k*ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    if (k==1){IOver <- n.I}else{
      IOver <- c(n.I[1:(k-1)]+d$overrun,n.I[k])
    }
    IOver[IOver>n.I[k]]<-n.I[k]
    en <- as.vector(IOver %*% (plo+phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))

    d$en <- en
    d$theta <- theta
    d$upper$prob <- phi
    
    if (d$test.type!=1)
    {
        d$lower$prob <- plo
    }
        
    d
}

gsDErrorCheck <- function(x){
    # check input arguments for type, range, and length
    
    # check input value of k, test.type, alpha, beta, astar
    checkScalar(x$k, "integer", c(1,Inf))
    checkScalar(x$test.type, "integer", c(1,6))
    checkScalar(x$alpha, "numeric", 0:1, c(FALSE, FALSE))
    if (x$test.type == 2 && x$alpha > 0.5)
    {
        checkScalar(x$alpha, "numeric", c(0,0.5), c(FALSE, TRUE))
    }
    checkScalar(x$beta, "numeric", c(0, 1-x$alpha), c(FALSE,FALSE))
    if (x$test.type > 4)
    {   
        checkScalar(x$astar, "numeric", c(0, 1-x$alpha))
        if (x$astar == 0) 
        {
            x$astar <- 1 - x$alpha
        }
    }
    
    # check delta, n.fix
    checkScalar(x$delta, "numeric", c(0,Inf))
    if (x$delta == 0)
    {
        checkScalar(x$n.fix, "numeric", c(0,Inf), c(FALSE,TRUE))
        x$delta <- abs(qnorm(x$alpha) + qnorm(x$beta)) / sqrt(x$n.fix)
    }
    else
    {
        x$n.fix <- ((qnorm(x$alpha) + qnorm(x$beta)) / x$delta)^2
    }
    
    # check n.I, maxn.IPlan
    checkVector(x$n.I, "numeric")
    checkScalar(x$maxn.IPlan, "numeric", c(0,Inf))
    if (max(abs(x$n.I)) > 0)
    {
        checkRange(length(x$n.I), c(2,Inf))
        if (!(all(sort(x$n.I) == x$n.I) && all(x$n.I > 0)))
        {
            stop("n.I must be an increasing, positive sequence")
        }
        
        if (x$maxn.IPlan <= 0) 
        {
            x$maxn.IPlan<-max(x$n.I)
        }
        else if (x$test.type < 3 && is.character(x$sfu))
        {
            stop("maxn.IPlan can only be > 0 if spending functions are used for boundaries")
        }

        x$timing <- x$n.I / x$maxn.IPlan
        
        if (x$n.I[x$k-1] >= x$maxn.IPlan)
        {
            stop("Only 1 n >= Planned Final n")        
        }
    }
    else if (x$maxn.IPlan > 0)
    {   
        if (length(x$n.I) == 1)
        {
            stop("If maxn.IPlan is specified, n.I must be specified")
        }
    }    
    
    # check input for timing of interim analyses
    # if timing not specified, make it equal spacing
    # this only needs to be done if x$n.I==0; KA added 2013/11/02
    if (max(x$n.I)==0){
      if (length(x$timing) < 1 || (length(x$timing) == 1 && (x$k > 2 || (x$k == 2 && (x$timing[1] <= 0 || x$timing[1] >= 1)))))
      {
          x$timing <- seq(x$k) / x$k
      }
      # if timing specified, make sure it is done correctly
      else if (length(x$timing) == x$k - 1 || length(x$timing) == x$k) 
      {   
  # put back requirement that final analysis timing must be 1, if specified; KA 2013/11/02
          if (length(x$timing) == x$k - 1)
          {
              x$timing <- c(x$timing, 1)
          }
          else if (x$timing[x$k]!=1)
          {
            stop("if analysis timing for final analysis is input, it must be 1")           
          }

          if (min(x$timing - c(0,x$timing[1:(x$k-1)])) <= 0)
          {
            stop("input timing of interim analyses must be increasing strictly between 0 and 1")           
          }
      }
      else
      {
          stop("value input for timing must be length 1, k-1 or k")
      }
    }
    # check input values for tol, r
    checkScalar(x$tol, "numeric", c(0, 0.1), c(FALSE, TRUE))
    checkScalar(x$r, "integer", c(1,80))
    
    # now that the checks have completed, coerce integer types
    # this is necessary because certain plot types will NOT work 
    # otherwise.
    x$k <- as.integer(x$k)
    x$test.type <- as.integer(x$test.type)
    x$r <- as.integer(x$r)
    
    # check overrun vector
    checkVector(x$overrun,interval=c(0,Inf),inclusion=c(TRUE,FALSE))
    if(length(x$overrun)!= 1 && length(x$overrun)!= x$k-1) stop(paste("overrun length should be 1 or ",as.character(x$k-1)))
  
    x
}
