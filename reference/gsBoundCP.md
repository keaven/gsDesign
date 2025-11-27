# Conditional Power at Interim Boundaries

`gsBoundCP()` computes the total probability of crossing future upper
bounds given an interim test statistic at an interim bound. For each
interim boundary, assumes an interim test statistic at the boundary and
computes the probability of crossing any of the later upper boundaries.

See Conditional power section of manual for further clarification. See
also Muller and Schaffer (2001) for background theory.

## Usage

``` r
gsBoundCP(x, theta = "thetahat", r = 18)
```

## Arguments

- x:

  An object of type `gsDesign` or `gsProbability`

- theta:

  if `"thetahat"` and `class(x)!="gsDesign"`, conditional power
  computations for each boundary value are computed using estimated
  treatment effect assuming a test statistic at that boundary
  (`zi/sqrt(x$n.I[i])` at analysis `i`, interim test statistic `zi` and
  interim sample size/statistical information of `x$n.I[i]`). Otherwise,
  conditional power is computed assuming the input scalar value `theta`.

- r:

  Integer value (\>= 1 and \<= 80) controlling the number of numerical
  integration grid points. Default is 18, as recommended by Jennison and
  Turnbull (2000). Grid points are spread out in the tails for accurate
  probability calculations. Larger values provide more grid points and
  greater accuracy but slow down computation. Jennison and Turnbull
  (p. 350) note an accuracy of \\10^{-6}\\ with `r = 16`. This parameter
  is normally not changed by users.

## Value

A list containing two vectors, `CPlo` and `CPhi`.

- CPlo:

  A vector of length `x$k-1` with conditional powers of crossing upper
  bounds given interim test statistics at each lower bound

- CPhi:

  A vector of length `x$k-1` with conditional powers of crossing upper
  bounds given interim test statistics at each upper bound.

## Note

The gsDesign technical manual is available at
<https://keaven.github.io/gsd-tech-manual/>.

## References

Jennison C and Turnbull BW (2000), *Group Sequential Methods with
Applications to Clinical Trials*. Boca Raton: Chapman and Hall.

Muller, Hans-Helge and Schaffer, Helmut (2001), Adaptive group
sequential designs for clinical trials: combining the advantages of
adaptive and classical group sequential approaches.
*Biometrics*;57:886-891.

## See also

[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsProbability`](https://keaven.github.io/gsDesign/reference/gsProbability.md),
[`gsCP`](https://keaven.github.io/gsDesign/reference/gsCP.md)

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# set up a group sequential design
x <- gsDesign(k = 5)
x
#> Asymmetric two-sided group sequential design with
#> 90 % power and 2.5 % Type I Error.
#> Upper bound spending computations assume
#> trial continues if lower bound is crossed.
#> 
#>            Sample
#>             Size    ----Lower bounds----  ----Upper bounds-----
#>   Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
#>          1  0.220 -0.90    0.1836 0.0077 3.25    0.0006  0.0006
#>          2  0.441 -0.04    0.4853 0.0115 2.99    0.0014  0.0013
#>          3  0.661  0.69    0.7563 0.0171 2.69    0.0036  0.0028
#>          4  0.881  1.36    0.9131 0.0256 2.37    0.0088  0.0063
#>          5  1.101  2.03    0.9786 0.0381 2.03    0.0214  0.0140
#>      Total                        0.1000                 0.0250 
#> + lower bound beta spending (under H1):
#>  Hwang-Shih-DeCani spending function with gamma = -2.
#> ++ alpha spending:
#>  Hwang-Shih-DeCani spending function with gamma = -4.
#> * Sample size ratio compared to fixed design with no interim
#> 
#> Boundary crossing probabilities and expected sample size
#> assume any cross stops the trial
#> 
#> Upper boundary (power or Type I Error)
#>           Analysis
#>    Theta      1      2      3      4      5  Total   E{N}
#>   0.0000 0.0006 0.0013 0.0028 0.0062 0.0117 0.0226 0.5726
#>   3.2415 0.0417 0.1679 0.2806 0.2654 0.1444 0.9000 0.7440
#> 
#> Lower boundary (futility or Type II Error)
#>           Analysis
#>    Theta      1      2      3      4      5  Total
#>   0.0000 0.1836 0.3201 0.2700 0.1477 0.0559 0.9774
#>   3.2415 0.0077 0.0115 0.0171 0.0256 0.0381 0.1000

# compute conditional power based on interim treatment effects
gsBoundCP(x)
#>              CPlo      CPhi
#> [1,] 2.294534e-06 1.0000001
#> [2,] 2.238566e-03 0.9998352
#> [3,] 2.669114e-02 0.9922459
#> [4,] 1.296705e-01 0.9200502

# compute conditional power based on original x$delta
gsBoundCP(x, theta = x$delta)
#>           CPlo      CPhi
#> [1,] 0.4936972 0.9940265
#> [2,] 0.3676577 0.9954019
#> [3,] 0.3331896 0.9912361
#> [4,] 0.3871332 0.9590607
```
