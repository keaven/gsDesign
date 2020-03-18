# nNormal roxy [sinew] ----
#' @title Normal distribution sample size (2-sample)
#'
#' @description \code{nNormal()} computes a fixed design sample size for comparing 2 means
#' where variance is known. T The function allows computation of sample size
#' for a non-inferiority hypothesis. Note that you may wish to investigate 
#' other R packages such as the \code{pwr} package which uses the t-distribution.
#' In the examples below we show how to set up a 2-arm group sequential design with a normal outcome. 
#'
#' \code{nNormal()} computes sample size for comparing two normal means when
#' the variance for observations in
#'
#' @details 
#' This is more of a convenience routine than one recommended for broad use without careful considerations
#' such as those outlined in Jennison and Turnbull (2000).
#' For larger studies where a conservative estimate of within group standard deviations is available, it
#' can be useful.
#' A more detailed formulation is available in the vignette on two-sample normal sample size.
#' 
#' @param delta1 difference between sample means under the alternate
#' hypothesis.
#' @param delta0 difference between sample means under the null hypothesis;
#' normally this will be left as the default of 0.
#' @param ratio randomization ratio of experimental group compared to control.
#' @param sided 1 for 1-sided test (default), 2 for 2-sided test.
#' @param sd Standard deviation for the control arm.
#' @param sd2 Standard deviation of experimental arm; this will be set to be
#' the same as the control arm with the default of \code{NULL}.
#' @param alpha type I error rate. Default is 0.025 since 1-sided testing is
#' default.
#' @param beta type II error rate. Default is 0.10 (90\% power). Not needed if
#' \code{n} is provided.
#' @param n Sample size; may be input to compute power rather than sample size.
#' If \code{NULL} (default) then sample size is computed.
#' @param outtype controls output; see value section below.
#' @return If \code{n} is \code{NULL} (default), total sample size (2 arms
#' combined) is computed. Otherwise, power is computed. If \code{outtype=1}
#' (default), the computed value (sample size or power) is returned in a scalar
#' or vector. If \code{outtype=2}, a data frame with sample sizes for each arm
#' (\code{n1}, \code{n2})is returned; if \code{n} is not input as \code{NULL},
#' a third variable, \code{Power}, is added to the output data frame. If
#' \code{outtype=3}, a data frame with is returned with the following columns:
#' \item{n}{A vector with total samples size required for each event rate
#' comparison specified} \item{n1}{A vector of sample sizes for group 1 for
#' each event rate comparison specified} \item{n2}{A vector of sample sizes for
#' group 2 for each event rate comparison specified} \item{alpha}{As input}
#' \item{sided}{As input} \item{beta}{As input; if \code{n} is input, this is
#' computed} \item{Power}{If \code{n=NULL} on input, this is \code{1-beta};
#' otherwise, the power is computed for each sample size input} \item{sd}{As
#' input} \item{sd2}{As input} \item{delta1}{As input} \item{delta0}{As input}
#' \item{se}{standard error for estimate of difference in treatment group
#' means}
#' @examples
#' 
#' # EXAMPLES
#' # equal variances
#' n=nNormal(delta1=.5,sd=1.1,alpha=.025,beta=.2)
#' n
# Set up a corresponding group sequential design.
# Note the argument n.fix to represent fixed designs sample size for above difference
# in means and standard deviation.
# Note that the argument delta1 does NOT affect sample size approximation,
# but DOES affect approximation of observed difference in means to achieve 
# statistical significance when gsBoundSummary is run.
#' x <- gsDesign(k = 3, n.fix = n, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(.5,.75),
#' sfu = sfLDOF, sfl = sfHSD, sflpar = -1, delta1 = 0.5, endpoint = 'normal') 
#' gsBoundSummary(x)
#' summary(x)
#' # unequal variances, fixed design
#' nNormal(delta1 = .5, sd = 1.1, sd2 = 2, alpha = .025, beta = .2)
#' # unequal sample sizes
#' nNormal(delta1 = .5, sd = 1.1, alpha = .025, beta = .2, ratio = 2)
#' # non-inferiority assuming a better effect than null
#' nNormal(delta1 = .5, delta0 = -.1, sd = 1.2)
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{gsDesign package overview}
#' @references 
#' Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' 
#' Lachin JM (1981), Introduction to sample size determination and
#' power analysis for clinical trials. \emph{Controlled Clinical Trials}
#' 2:93-113.
#'
#' Snedecor GW and Cochran WG (1989), Statistical Methods. 8th ed. Ames, IA:
#' Iowa State University Press.
#' 
#' @keywords design
#' @rdname nNormal
#' @importFrom stats qnorm pnorm
#' @export
# nNormal function [sinew] ----
nNormal <- function(delta1 = 1, sd = 1.7, sd2 = NULL, alpha = .025,
                    beta = .1, ratio = 1, sided = 1, n = NULL, delta0 = 0, outtype = 1) { # check input arguments
  checkVector(delta1, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(sd, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkScalar(sided, "integer", c(1, 2))
  checkScalar(alpha, "numeric", c(0, 1 / sided), c(FALSE, FALSE))
  checkVector(beta, "numeric", c(0, 1 - alpha / sided), c(FALSE, FALSE))
  checkVector(delta0, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(ratio, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkScalar(outtype, "integer", c(1, 3))
  checkLengths(delta1, delta0, sd, sd2, alpha, beta, ratio, allowSingle = TRUE)

  xi <- ratio / (1 + ratio)
  if (is.null(sd2)) sd2 <- sd
  se <- sqrt(sd2^2 / xi + sd^2 / (1 - xi))
  theta1 <- (delta1 - delta0) / se
  if (max(abs(theta1) == 0)) stop("delta1 may not equal delta0")
  if (is.null(n)) {
    n <- ((stats::qnorm(alpha / sided) + stats::qnorm(beta)) / theta1)^2
    if (outtype == 2) {
      return(data.frame(cbind(n1 = n / (ratio + 1), n2 = ratio * n / (ratio + 1))))
    }
    else if (outtype == 3) {
      return(data.frame(cbind(
        n = n, n1 = n / (ratio + 1), n2 = ratio * n / (ratio + 1),
        alpha = alpha, sided = sided, beta = beta, Power = 1 - beta,
        sd = sd, sd2 = sd2, delta1 = delta1, delta0 = delta0, se = se / sqrt(n)
      )))
    }
    else {
      return(n = n)
    }
  } else {
    powr <- stats::pnorm(sqrt(n) * theta1 - stats::qnorm(1 - alpha / sided))
    if (outtype == 2) {
      return(data.frame(cbind(n1 = n / (ratio + 1), n2 = ratio * n / (ratio + 1), Power = powr)))
    } else if (outtype == 3) {
      return(data.frame(cbind(
        n = n, n1 = n / (ratio + 1), n2 = ratio * n / (ratio + 1),
        alpha = alpha, sided = sided, beta = 1 - powr, Power = powr,
        sd = sd, sd2 = sd2, delta1 = delta1, delta0 = delta0, se = se / sqrt(n)
      )))
    }
    else {
      (return(Power = powr))
    }
  }
}
