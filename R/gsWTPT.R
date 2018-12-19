###
# Hidden Functions
###
#' 5.0: Wang-Tsiatis Bounds
#' 
#' \code{gsDesign} offers the option of using Wang-Tsiatis bounds as an
#' alternative to the spending function approach to group sequential design.
#' Wang-Tsiatis bounds include both Pocock and O'Brien-Fleming designs.
#' Wang-Tsiatis bounds are currently only available for 1-sided and symmetric
#' 2-sided designs. Wang-Tsiatis bounds are typically used with equally spaced
#' timing between analyses, but the option is available to use them with
#' unequal spacing.
#' 
#' Wang-Tsiatis bounds are defined as follows. Assume \eqn{k} analyses and let
#' \eqn{Z_i} represent the upper bound and \eqn{t_i} the proportion of the
#' total planned sample size for the \eqn{i}-th analysis, \eqn{i=1,2,\ldots,k}.
#' Let \eqn{\Delta}{Delta} be a real-value.  Typically \eqn{\Delta}{Delta} will
#' range from 0 (O'Brien-Fleming design) to 0.5 (Pocock design). The upper
#' boundary is defined by \deqn{ct_i^{\Delta-0.5}} for \eqn{i= 1,2,\ldots,k}
#' where \eqn{c} depends on the other parameters. The parameter
#' \eqn{\Delta}{Delta} is supplied to \code{gsDesign()} in the parameter
#' \code{sfupar}. For O'Brien-Fleming and Pocock designs there is also a
#' calling sequence that does not require a parameter. See examples.
#' 
#' @name Wang-Tsiatis Bounds
#' @aliases O'Brien-Fleming Bounds Wang-Tsiatis Bounds Pocock Bounds
#' @docType package
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{Spending function overview}, \link{gsDesign}},
#' \code{\link{gsProbability}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' # Pocock design
#' gsDesign(test.type=2, sfu="Pocock")
#' 
#' # alternate call to get Pocock design specified using 
#' # Wang-Tsiatis option and Delta=0.5
#' gsDesign(test.type=2, sfu="WT", sfupar=0.5)
#' 
#' # this is how this might work with a spending function approach
#' # Hwang-Shih-DeCani spending function with gamma=1 is often used 
#' # to approximate Pocock design
#' gsDesign(test.type=2, sfu=sfHSD, sfupar=1)
#' 
#' # unequal spacing works,  but may not be desirable 
#' gsDesign(test.type=2, sfu="Pocock", timing=c(.1, .2))
#' 
#' # spending function approximation to Pocock with unequal spacing 
#' # is quite different from this
#' gsDesign(test.type=2, sfu=sfHSD, sfupar=1, timing=c(.1, .2))
#' 
#' # One-sided O'Brien-Fleming design
#' gsDesign(test.type=1, sfu="OF")
#' 
#' # alternate call to get O'Brien-Fleming design specified using 
#' # Wang-Tsiatis option and Delta=0
#' gsDesign(test.type=1, sfu="WT", sfupar=0)
#' 
WT <- function(d, alpha, a, timing, tol=0.000001, r=18){   
    # Wang-Tsiatis boundary
    # find constant for a Wang-Tsiatis bound to get appropriate alpha
    # for 2-sided,  a=1 (set in gsDType2and5); otherwise,  a set in gsDType1
    
    b <- timing^(d - .5)
    
    if (length(a) == 1)
    {
        c0 <- 0
    }
    else
    {   
        i <- 0
        
        while (WTdiff(i, alpha, a, b, timing, r) >= 0.)
        {
            i <- i-1
        }
        
        c0 <- i
    }
    
    i <- 2
    
    while(WTdiff(i, alpha, a, b, timing, r) <= 0.)
    {
        i <- i + 1
    }
    
    c1 <- i
    
    stats::uniroot(WTdiff, lower=c0, upper=c1, alpha=alpha, a=a, b=b, timing=timing, tol=tol, r=r)$root
}

WTdiff <- function(c, alpha, a, b, timing, r){   
    # Wang-Tsiatis boundary alpha comparison
    # for a timing vector,  scalar a,  and vector b,  
    # compute upper crossing probability using upper bound of c*b
    # a is used to control one- or 2-sided bound    
    
    if (length(a) == 1)
    {
        a <- -c * b
    }
    
    x <- gsProbability(k=length(b), theta=0., n.I=timing, a=a, b=c * b, r=r)
    
    alpha - sum(x$upper$prob)
}

