# Normal distribution sample size (2-sample)

`nNormal()` computes a fixed design sample size for comparing 2 means
where variance is known. T The function allows computation of sample
size for a non-inferiority hypothesis. Note that you may wish to
investigate other R packages such as the `pwr` package which uses the
t-distribution. In the examples below we show how to set up a 2-arm
group sequential design with a normal outcome.

`nNormal()` computes sample size for comparing two normal means when the
variance for observations in

## Usage

``` r
nNormal(
  delta1 = 1,
  sd = 1.7,
  sd2 = NULL,
  alpha = 0.025,
  beta = 0.1,
  ratio = 1,
  sided = 1,
  n = NULL,
  delta0 = 0,
  outtype = 1
)
```

## Arguments

- delta1:

  difference between sample means under the alternate hypothesis.

- sd:

  Standard deviation for the control arm.

- sd2:

  Standard deviation of experimental arm; this will be set to be the
  same as the control arm with the default of `NULL`.

- alpha:

  type I error rate. Default is 0.025 since 1-sided testing is default.

- beta:

  type II error rate. Default is 0.10 (90% power). Not needed if `n` is
  provided.

- ratio:

  randomization ratio of experimental group compared to control.

- sided:

  1 for 1-sided test (default), 2 for 2-sided test.

- n:

  Sample size; may be input to compute power rather than sample size. If
  `NULL` (default) then sample size is computed.

- delta0:

  difference between sample means under the null hypothesis; normally
  this will be left as the default of 0.

- outtype:

  controls output; see value section below.

## Value

If `n` is `NULL` (default), total sample size (2 arms combined) is
computed. Otherwise, power is computed. If `outtype=1` (default), the
computed value (sample size or power) is returned in a scalar or vector.
If `outtype=2`, a data frame with sample sizes for each arm (`n1`,
`n2`)is returned; if `n` is not input as `NULL`, a third variable,
`Power`, is added to the output data frame. If `outtype=3`, a data frame
with is returned with the following columns:

- n:

  A vector with total samples size required for each event rate
  comparison specified

- n1:

  A vector of sample sizes for group 1 for each event rate comparison
  specified

- n2:

  A vector of sample sizes for group 2 for each event rate comparison
  specified

- alpha:

  As input

- sided:

  As input

- beta:

  As input; if `n` is input, this is computed

- Power:

  If `n=NULL` on input, this is `1-beta`; otherwise, the power is
  computed for each sample size input

- sd:

  As input

- sd2:

  As input

- delta1:

  As input

- delta0:

  As input

- se:

  standard error for estimate of difference in treatment group means

## Details

This is more of a convenience routine than one recommended for broad use
without careful considerations such as those outlined in Jennison and
Turnbull (2000). For larger studies where a conservative estimate of
within group standard deviations is available, it can be useful. A more
detailed formulation is available in the vignette on two-sample normal
sample size.

## References

Jennison C and Turnbull BW (2000), *Group Sequential Methods with
Applications to Clinical Trials*. Boca Raton: Chapman and Hall.

Lachin JM (1981), Introduction to sample size determination and power
analysis for clinical trials. *Controlled Clinical Trials* 2:93-113.

Snedecor GW and Cochran WG (1989), Statistical Methods. 8th ed. Ames,
IA: Iowa State University Press.

## See also

See
[`vignette("nNormal")`](https://keaven.github.io/gsDesign/articles/nNormal.md)
for the full story, including the derivation of the sample size formula,
power checks via simulation, and a group sequential design example.

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# EXAMPLES
# equal variances
n=nNormal(delta1=.5,sd=1.1,alpha=.025,beta=.2)
n
#> [1] 151.9543
x <- gsDesign(k = 3, n.fix = n, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(.5,.75),
sfu = sfLDOF, sfl = sfHSD, sflpar = -1, delta1 = 0.5, endpoint = 'normal') 
gsBoundSummary(x)
#>   Analysis                 Value Efficacy Futility
#>  IA 1: 50%                     Z   2.9626   0.6475
#>      N: 86           p (1-sided)   0.0015   0.2587
#>                  ~delta at bound   0.6109   0.1335
#>              P(Cross) if delta=0   0.0015   0.7413
#>            P(Cross) if delta=0.5   0.2954   0.0378
#>  IA 2: 75%                     Z   2.3590   1.3115
#>     N: 128           p (1-sided)   0.0092   0.0948
#>                  ~delta at bound   0.3972   0.2208
#>              P(Cross) if delta=0   0.0096   0.9155
#>            P(Cross) if delta=0.5   0.7309   0.0650
#>      Final                     Z   2.0141   2.0141
#>     N: 171           p (1-sided)   0.0220   0.0220
#>                  ~delta at bound   0.2937   0.2937
#>              P(Cross) if delta=0   0.0219   0.9781
#>            P(Cross) if delta=0.5   0.9000   0.1000
summary(x)
#> [1] "Asymmetric two-sided group sequential design with non-binding futility bound, 3 analyses, sample size 171, 90 percent power, 2.5 percent (1-sided) Type I error. Efficacy bounds derived using a Lan-DeMets O'Brien-Fleming approximation spending function (no parameters). Futility bounds derived using a Hwang-Shih-DeCani spending function with gamma = -1."
# unequal variances, fixed design
nNormal(delta1 = .5, sd = 1.1, sd2 = 2, alpha = .025, beta = .2)
#> [1] 327.1413
# unequal sample sizes
nNormal(delta1 = .5, sd = 1.1, alpha = .025, beta = .2, ratio = 2)
#> [1] 170.9486
# non-inferiority assuming a better effect than null
nNormal(delta1 = .5, delta0 = -.1, sd = 1.2)
#> [1] 168.1188
```
