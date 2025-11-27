# Boundary derivation - low level

`gsBound()` and `gsBound1()` are lower-level functions used to find
boundaries for a group sequential design. They are not recommended
(especially `gsBound1()`) for casual users. These functions do not
adjust sample size as
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
does to ensure appropriate power for a design.

`gsBound()` computes upper and lower bounds given boundary crossing
probabilities assuming a mean of 0, the usual null hypothesis.
`gsBound1()` computes the upper bound given a lower boundary, upper
boundary crossing probabilities and an arbitrary mean (`theta`).

The function `gsBound1()` requires special attention to detail and
knowledge of behavior when a design corresponding to the input
parameters does not exist.

## Usage

``` r
gsBound(I, trueneg, falsepos, tol = 1e-06, r = 18, printerr = 0)

gsBound1(theta, I, a, probhi, tol = 1e-06, r = 18, printerr = 0)
```

## Arguments

- I:

  Vector containing statistical information planned at each analysis.

- trueneg:

  Vector of desired probabilities for crossing upper bound assuming mean
  of 0.

- falsepos:

  Vector of desired probabilities for crossing lower bound assuming mean
  of 0.

- tol:

  Tolerance for error (scalar; default is 0.000001). Normally this will
  not be changed by the user. This does not translate directly to number
  of digits of accuracy, so use extra decimal places.

- r:

  Integer value (\>= 1 and \<= 80) controlling the number of numerical
  integration grid points. Default is 18, as recommended by Jennison and
  Turnbull (2000). Grid points are spread out in the tails for accurate
  probability calculations. Larger values provide more grid points and
  greater accuracy but slow down computation. Jennison and Turnbull
  (p. 350) note an accuracy of \\10^{-6}\\ with `r = 16`. This parameter
  is normally not changed by users.

- printerr:

  If this scalar argument set to 1, this will print messages from
  underlying C program. Mainly intended to notify user when an output
  solution does not match input specifications. This is not intended to
  stop execution as this often occurs when deriving a design in
  `gsDesign` that uses beta-spending.

- theta:

  Scalar containing mean (drift) per unit of statistical information.

- a:

  Vector containing lower bound that is fixed for use in `gsBound1`.

- probhi:

  Vector of desired probabilities for crossing upper bound assuming mean
  of theta.

## Value

Both routines return a list. Common items returned by the two routines
are:

- k:

  The length of vectors input; a scalar.

- theta:

  As input in `gsBound1()`; 0 for `gsBound()`.

- I:

  As input.

- a:

  For `gsbound1`, this is as input. For `gsbound` this is the derived
  lower boundary required to yield the input boundary crossing
  probabilities under the null hypothesis.

- b:

  The derived upper boundary required to yield the input boundary
  crossing probabilities under the null hypothesis.

- tol:

  As input.

- r:

  As input.

- error:

  Error code. 0 if no error; greater than 0 otherwise.

`gsBound()` also returns the following items:

- rates:

  a list containing two items:

- falsepos:

  vector of upper boundary crossing probabilities as input.

- trueneg:

  vector of lower boundary crossing probabilities as input.

`gsBound1()` also returns the following items:

- problo:

  vector of lower boundary crossing probabilities; computed using input
  lower bound and derived upper bound.

- probhi:

  vector of upper boundary crossing probabilities as input.

## Note

The gsDesign technical manual is available at
<https://keaven.github.io/gsd-tech-manual/>.

## References

Jennison C and Turnbull BW (2000), *Group Sequential Methods with
Applications to Clinical Trials*. Boca Raton: Chapman and Hall.

## See also

[`vignette("gsDesignPackageOverview")`](https://keaven.github.io/gsDesign/articles/gsDesignPackageOverview.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsProbability`](https://keaven.github.io/gsDesign/reference/gsProbability.md)

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# set boundaries so that probability is .01 of first crossing
# each upper boundary and .02 of crossing each lower boundary
# under the null hypothesis
x <- gsBound(
  I = c(1, 2, 3) / 3, trueneg = rep(.02, 3),
  falsepos = rep(.01, 3)
)
x
#> $k
#> [1] 3
#> 
#> $theta
#> [1] 0
#> 
#> $I
#> [1] 0.3333333 0.6666667 1.0000000
#> 
#> $a
#> [1] -2.053749 -1.914183 -1.789206
#> 
#> $b
#> [1] 2.326348 2.219299 2.120127
#> 
#> $rates
#> $rates$falsepos
#> [1] 0.01 0.01 0.01
#> 
#> $rates$trueneg
#> [1] 0.02 0.02 0.02
#> 
#> 
#> $tol
#> [1] 1e-06
#> 
#> $r
#> [1] 18
#> 
#> $error
#> [1] 0
#> 

#  use gsBound1 to set up boundary for a 1-sided test
x <- gsBound1(
  theta = 0, I = c(1, 2, 3) / 3, a = rep(-20, 3),
  probhi = c(.001, .009, .015)
)
x$b
#> [1] 3.090232 2.344824 2.039501

# check boundary crossing probabilities with gsProbability
y <- gsProbability(k = 3, theta = 0, n.I = x$I, a = x$a, b = x$b)$upper$prob

#  Note that gsBound1 only computes upper bound
#  To get a lower bound under a parameter value theta:
#      use minus the upper bound as a lower bound
#      replace theta with -theta
#      set probhi as desired lower boundary crossing probabilities
#  Here we let set lower boundary crossing at 0.05 at each analysis
#  assuming theta=2.2
y <- gsBound1(
  theta = -2.2, I = c(1, 2, 3) / 3, a = -x$b,
  probhi = rep(.05, 3)
)
y$b
#> [1]  0.3746830 -0.3594403 -0.9470061

#  Now use gsProbability to look at design
#  Note that lower boundary crossing probabilities are as
#  specified for theta=2.2, but for theta=0 the upper boundary
#  crossing probabilities are smaller than originally specified
#  above after first interim analysis
gsProbability(k = length(x$b), theta = c(0, 2.2), n.I = x$I, b = x$b, a = -y$b)
#>                Lower bounds   Upper bounds
#>   Analysis N    Z   Nominal p  Z   Nominal p
#>          1  1 -0.37    0.3539 3.09    0.0010
#>          2  1  0.36    0.6404 2.34    0.0095
#>          3  1  0.95    0.8282 2.04    0.0207
#> 
#> Boundary crossing probabilities and expected sample size assume
#> any cross stops the trial
#> 
#> Upper boundary
#>           Analysis
#>   Theta      1      2      3  Total E{N}
#>     0.0 0.0010 0.0090 0.0146 0.0246  0.7
#>     2.2 0.0344 0.2601 0.2783 0.5728  0.8
#> 
#> Lower boundary
#>           Analysis
#>   Theta      1      2     3  Total
#>     0.0 0.3539 0.3153 0.184 0.8532
#>     2.2 0.0500 0.0500 0.050 0.1500
```
