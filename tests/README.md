Tests and Coverage
================
17 January, 2019 05:52:55

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                          | Coverage (%) |
| :---------------------------------------------- | :----------: |
| gsDesign                                        |    20.16     |
| [R/gsBinomialExact.R](../R/gsBinomialExact.R)   |     0.00     |
| [R/gsMethods.R](../R/gsMethods.R)               |     0.00     |
| [R/gsqplot.R](../R/gsqplot.R)                   |     0.00     |
| [R/gsSimulate.R](../R/gsSimulate.R)             |     0.00     |
| [R/gsSurv.R](../R/gsSurv.R)                     |     0.00     |
| [R/gsSurvival.R](../R/gsSurvival.R)             |     0.00     |
| [R/nBinomial1Sample.r](../R/nBinomial1Sample.r) |     0.00     |
| [R/nEvents.R](../R/nEvents.R)                   |     0.00     |
| [R/nNormal.R](../R/nNormal.R)                   |     0.00     |
| [R/ssrCP.R](../R/ssrCP.R)                       |     0.00     |
| [R/varBinomial.R](../R/varBinomial.R)           |     0.00     |
| [R/xtable.R](../R/xtable.R)                     |     0.00     |
| [R/gsCP.R](../R/gsCP.R)                         |     2.86     |
| [R/gsSpending.R](../R/gsSpending.R)             |    11.67     |
| [R/gsNormalGrid.R](../R/gsNormalGrid.R)         |    11.76     |
| [R/gsUtilities.R](../R/gsUtilities.R)           |    45.38     |
| [R/gsWTPT.R](../R/gsWTPT.R)                     |    72.22     |
| [R/gsBinomial.R](../R/gsBinomial.R)             |    73.94     |
| [R/gsDesign.R](../R/gsDesign.R)                 |    75.64     |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat)
package.

| file                                                                |   n |   time | error | failed | skipped | warning |
| :------------------------------------------------------------------ | --: | -----: | ----: | -----: | ------: | ------: |
| [test-base.R](testthat/test-base.R)                                 | 394 | 37.520 |     0 |      0 |       0 |       0 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R)          |  29 |  0.059 |     0 |      0 |       0 |       0 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R) |  29 |  0.095 |     0 |      0 |       0 |       0 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R)          |  27 |  0.895 |     0 |      0 |       0 |       0 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R)      |  27 |  0.044 |     0 |      0 |       0 |       0 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R)                      | 106 |  0.341 |     0 |      0 |       0 |       0 |
| [test-gs\_probability.R](testthat/test-gs_probability.R)            |  18 |  0.021 |     0 |      0 |       0 |       0 |
| [test-gs\_stress.R](testthat/test-gs_stress.R)                      |  30 | 33.626 |     0 |      0 |       0 |       0 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R)        |  32 |  0.060 |     0 |      0 |       0 |       0 |
| [test-normal\_grid\_inputs.R](testthat/test-normal_grid_inputs.R)   |  12 |  0.022 |     0 |      0 |       0 |       0 |
| [test-outputs.R](testthat/test-outputs.R)                           |  48 |  2.288 |     0 |      0 |       0 |       0 |
| [test-plot\_inputs.R](testthat/test-plot_inputs.R)                  |   8 |  0.010 |     0 |      0 |       0 |       0 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R)                      |  28 |  0.024 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results
</summary>

| file                                                                          | context             | test                             | status |  n |  time |
| :---------------------------------------------------------------------------- | :------------------ | :------------------------------- | :----- | -: | ----: |
| [test-base.R](testthat/test-base.R#L57_L60)                                   | base tests          | test.ciBinomial.adj              | PASS   |  4 | 0.051 |
| [test-base.R](testthat/test-base.R#L76_L79)                                   | base tests          | test.ciBinomial.alpha            | PASS   |  4 | 0.009 |
| [test-base.R](testthat/test-base.R#L95_L97)                                   | base tests          | test.ciBinomial.n1               | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L107_L109)                                 | base tests          | test.ciBinomial.n2               | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L119_L122)                                 | base tests          | test.ciBinomial.scale            | PASS   |  3 | 0.007 |
| [test-base.R](testthat/test-base.R#L134_L137)                                 | base tests          | test.ciBinomial.tol              | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L145_L147)                                 | base tests          | test.ciBinomial.x1               | PASS   |  4 | 0.006 |
| [test-base.R](testthat/test-base.R#L160_L162)                                 | base tests          | test.ciBinomial.x2               | PASS   |  4 | 0.007 |
| [test-base.R](testthat/test-base.R#L175_L177)                                 | base tests          | test.gsbound.falsepos            | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L190_L192)                                 | base tests          | test.gsbound.I                   | PASS   |  3 | 0.003 |
| [test-base.R](testthat/test-base.R#L202_L204)                                 | base tests          | test.gsbound.r                   | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L218_L220)                                 | base tests          | test.gsbound.tol                 | PASS   |  2 | 0.001 |
| [test-base.R](testthat/test-base.R#L227_L229)                                 | base tests          | test.gsbound.trueneg             | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L242_L244)                                 | base tests          | test.gsbound1.a                  | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L252_L254)                                 | base tests          | test.gsbound1.I                  | PASS   |  3 | 0.003 |
| [test-base.R](testthat/test-base.R#L264_L266)                                 | base tests          | test.gsbound1.probhi             | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L280_L283)                                 | base tests          | test.gsbound1.r                  | PASS   |  4 | 0.004 |
| [test-base.R](testthat/test-base.R#L299_L301)                                 | base tests          | test.gsbound1.theta              | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L308_L311)                                 | base tests          | test.gsbound1.tol                | PASS   |  2 | 0.001 |
| [test-base.R](testthat/test-base.R#L319)                                      | base tests          | test.gsBoundCP.r                 | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L326)                                      | base tests          | test.gsBoundCP.theta             | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L331)                                      | base tests          | test.gsBoundCP.x                 | PASS   |  1 | 0.001 |
| [test-base.R](testthat/test-base.R#L335)                                      | base tests          | test.gsCP.r                      | PASS   |  4 | 0.004 |
| [test-base.R](testthat/test-base.R#L342)                                      | base tests          | test.gsCP.x                      | PASS   |  1 | 0.001 |
| [test-base.R](testthat/test-base.R#L346)                                      | base tests          | test.gsDesign.alpha              | PASS   |  5 | 0.009 |
| [test-base.R](testthat/test-base.R#L356)                                      | base tests          | test.gsDesign.astar              | PASS   |  5 | 0.009 |
| [test-base.R](testthat/test-base.R#L370)                                      | base tests          | test.gsDesign.beta               | PASS   |  5 | 0.009 |
| [test-base.R](testthat/test-base.R#L384)                                      | base tests          | test.gsDesign.delta              | PASS   |  3 | 0.006 |
| [test-base.R](testthat/test-base.R#L390)                                      | base tests          | test.gsDesign.k                  | PASS   |  6 | 0.177 |
| [test-base.R](testthat/test-base.R#L402)                                      | base tests          | test.gsDesign.maxn.I             | PASS   |  1 | 0.002 |
| [test-base.R](testthat/test-base.R#L406)                                      | base tests          | test.gsDesign.n.fix              | PASS   |  3 | 0.010 |
| [test-base.R](testthat/test-base.R#L412)                                      | base tests          | test.gsDesign.n.I                | PASS   |  1 | 0.003 |
| [test-base.R](testthat/test-base.R#L416)                                      | base tests          | test.gsDesign.r                  | PASS   |  4 | 0.016 |
| [test-base.R](testthat/test-base.R#L423)                                      | base tests          | test.gsDesign.sfl                | PASS   |  2 | 0.007 |
| [test-base.R](testthat/test-base.R#L428)                                      | base tests          | test.gsDesign.sflpar             | PASS   |  2 | 0.011 |
| [test-base.R](testthat/test-base.R#L433)                                      | base tests          | test.gsDesign.sfu                | PASS   |  2 | 0.006 |
| [test-base.R](testthat/test-base.R#L438)                                      | base tests          | test.gsDesign.sfupar             | PASS   |  2 | 0.010 |
| [test-base.R](testthat/test-base.R#L443)                                      | base tests          | test.gsDesign.test.type          | PASS   |  9 | 0.025 |
| [test-base.R](testthat/test-base.R#L455)                                      | base tests          | test.gsDesign.timing             | PASS   |  6 | 0.018 |
| [test-base.R](testthat/test-base.R#L464)                                      | base tests          | test.gsDesign.tol                | PASS   |  4 | 0.011 |
| [test-base.R](testthat/test-base.R#L472)                                      | base tests          | test.stress.sfExp.type1          | PASS   |  1 | 0.156 |
| [test-base.R](testthat/test-base.R#L477)                                      | base tests          | test.stress.sfExp.type2          | PASS   |  1 | 0.129 |
| [test-base.R](testthat/test-base.R#L482)                                      | base tests          | test.stress.sfExp.type3          | PASS   |  1 | 1.126 |
| [test-base.R](testthat/test-base.R#L487)                                      | base tests          | test.stress.sfExp.type4          | PASS   |  1 | 0.260 |
| [test-base.R](testthat/test-base.R#L492)                                      | base tests          | test.stress.sfExp.type5          | PASS   |  1 | 0.102 |
| [test-base.R](testthat/test-base.R#L497)                                      | base tests          | test.stress.sfExp.type6          | PASS   |  1 | 0.158 |
| [test-base.R](testthat/test-base.R#L502)                                      | base tests          | test.stress.sfHSD.type1          | PASS   |  1 | 0.085 |
| [test-base.R](testthat/test-base.R#L507)                                      | base tests          | test.stress.sfHSD.type2          | PASS   |  1 | 0.072 |
| [test-base.R](testthat/test-base.R#L512)                                      | base tests          | test.stress.sfHSD.type3          | PASS   |  1 | 0.672 |
| [test-base.R](testthat/test-base.R#L517)                                      | base tests          | test.stress.sfHSD.type4          | PASS   |  1 | 0.179 |
| [test-base.R](testthat/test-base.R#L522)                                      | base tests          | test.stress.sfHSD.type5          | PASS   |  1 | 0.074 |
| [test-base.R](testthat/test-base.R#L527)                                      | base tests          | test.stress.sfHSD.type6          | PASS   |  1 | 0.103 |
| [test-base.R](testthat/test-base.R#L535)                                      | base tests          | test.stress.sfLDOF.type1         | PASS   |  1 | 1.045 |
| [test-base.R](testthat/test-base.R#L543)                                      | base tests          | test.stress.sfLDOF.type2         | PASS   |  1 | 0.607 |
| [test-base.R](testthat/test-base.R#L551)                                      | base tests          | test.stress.sfLDOF.type3         | PASS   |  1 | 8.723 |
| [test-base.R](testthat/test-base.R#L559)                                      | base tests          | test.stress.sfLDOF.type4         | PASS   |  1 | 2.074 |
| [test-base.R](testthat/test-base.R#L567)                                      | base tests          | test.stress.sfLDOF.type5         | PASS   |  1 | 0.744 |
| [test-base.R](testthat/test-base.R#L575)                                      | base tests          | test.stress.sfLDOF.type6         | PASS   |  1 | 1.292 |
| [test-base.R](testthat/test-base.R#L583)                                      | base tests          | test.stress.sfLDPocock.type1     | PASS   |  1 | 1.005 |
| [test-base.R](testthat/test-base.R#L591)                                      | base tests          | test.stress.sfLDPocock.type2     | PASS   |  1 | 0.551 |
| [test-base.R](testthat/test-base.R#L599)                                      | base tests          | test.stress.sfLDPocock.type3     | PASS   |  1 | 8.148 |
| [test-base.R](testthat/test-base.R#L607)                                      | base tests          | test.stress.sfLDPocock.type4     | PASS   |  1 | 2.050 |
| [test-base.R](testthat/test-base.R#L615)                                      | base tests          | test.stress.sfLDPocock.type5     | PASS   |  1 | 0.728 |
| [test-base.R](testthat/test-base.R#L623)                                      | base tests          | test.stress.sfLDPocock.type6     | PASS   |  1 | 1.271 |
| [test-base.R](testthat/test-base.R#L628)                                      | base tests          | test.stress.sfPower.type1        | PASS   |  1 | 0.122 |
| [test-base.R](testthat/test-base.R#L633)                                      | base tests          | test.stress.sfPower.type2        | PASS   |  1 | 0.121 |
| [test-base.R](testthat/test-base.R#L638)                                      | base tests          | test.stress.sfPower.type3        | PASS   |  1 | 1.402 |
| [test-base.R](testthat/test-base.R#L643)                                      | base tests          | test.stress.sfPower.type4        | PASS   |  1 | 0.281 |
| [test-base.R](testthat/test-base.R#L648)                                      | base tests          | test.stress.sfPower.type5        | PASS   |  1 | 0.108 |
| [test-base.R](testthat/test-base.R#L653)                                      | base tests          | test.stress.sfPower.type6        | PASS   |  1 | 0.168 |
| [test-base.R](testthat/test-base.R#L657)                                      | base tests          | test.gsProbability.a             | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L662)                                      | base tests          | test.gsProbability.b             | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L667)                                      | base tests          | test.gsProbability.k             | PASS   |  5 | 0.010 |
| [test-base.R](testthat/test-base.R#L675)                                      | base tests          | test.gsProbability.n.I           | PASS   |  4 | 0.005 |
| [test-base.R](testthat/test-base.R#L682)                                      | base tests          | test.gsProbability.r             | PASS   |  4 | 0.006 |
| [test-base.R](testthat/test-base.R#L689)                                      | base tests          | test.gsProbability.theta         | PASS   |  1 | 0.002 |
| [test-base.R](testthat/test-base.R#L693_L695)                                 | base tests          | test.nBinomial.alpha             | PASS   |  5 | 0.012 |
| [test-base.R](testthat/test-base.R#L711_L713)                                 | base tests          | test.nBinomial.beta              | PASS   |  4 | 0.008 |
| [test-base.R](testthat/test-base.R#L726_L728)                                 | base tests          | test.nBinomial.delta0            | PASS   |  3 | 0.007 |
| [test-base.R](testthat/test-base.R#L736_L738)                                 | base tests          | test.nBinomial.outtype           | PASS   |  4 | 0.009 |
| [test-base.R](testthat/test-base.R#L751)                                      | base tests          | test.nBinomial.p1                | PASS   |  3 | 0.004 |
| [test-base.R](testthat/test-base.R#L757)                                      | base tests          | test.nBinomial.p2                | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L763_L765)                                 | base tests          | test.nBinomial.ratio             | PASS   |  3 | 0.006 |
| [test-base.R](testthat/test-base.R#L774)                                      | base tests          | test.nBinomial.scale             | PASS   |  3 | 0.007 |
| [test-base.R](testthat/test-base.R#L784_L786)                                 | base tests          | test.nBinomial.sided             | PASS   |  4 | 0.012 |
| [test-base.R](testthat/test-base.R#L795)                                      | base tests          | test.normalGrid.bounds           | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L801)                                      | base tests          | test.normalGrid.mu               | PASS   |  2 | 0.003 |
| [test-base.R](testthat/test-base.R#L806)                                      | base tests          | test.normalGrid.r                | PASS   |  4 | 0.004 |
| [test-base.R](testthat/test-base.R#L813)                                      | base tests          | test.normalGrid.sigma            | PASS   |  3 | 0.004 |
| [test-base.R](testthat/test-base.R#L827)                                      | base tests          | test.Deming.gsProb               | PASS   |  4 | 0.011 |
| [test-base.R](testthat/test-base.R#L838_L841)                                 | base tests          | test.Deming.OFbound              | PASS   |  1 | 0.029 |
| [test-base.R](testthat/test-base.R#L846)                                      | base tests          | test.JT.OFss                     | PASS   |  4 | 0.260 |
| [test-base.R](testthat/test-base.R#L855)                                      | base tests          | test.JT.Pocock                   | PASS   |  6 | 0.167 |
| [test-base.R](testthat/test-base.R#L877)                                      | base tests          | test.JT.Power.symm               | PASS   |  9 | 0.068 |
| [test-base.R](testthat/test-base.R#L913)                                      | base tests          | test.JT.Power.type3              | PASS   | 18 | 1.574 |
| [test-base.R](testthat/test-base.R#L964)                                      | base tests          | test.JT.WT                       | PASS   |  6 | 0.186 |
| [test-base.R](testthat/test-base.R#L981)                                      | base tests          | test.plot.gsDesign.plottype      | PASS   |  4 | 0.005 |
| [test-base.R](testthat/test-base.R#L988)                                      | base tests          | test.plot.gsProbability.plottype | PASS   |  4 | 0.011 |
| [test-base.R](testthat/test-base.R#L995)                                      | base tests          | test.sfcauchy.param              | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1003)                                     | base tests          | test.sfcauchy.param              | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1008)                                     | base tests          | test.sfexp.param                 | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L1015)                                     | base tests          | test.sfHSD.param                 | PASS   |  4 | 0.003 |
| [test-base.R](testthat/test-base.R#L1022)                                     | base tests          | test.sflogistic.param            | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1030)                                     | base tests          | test.sflogistic.param            | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1036)                                     | base tests          | test.sfnorm.param                | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1044)                                     | base tests          | test.sfnorm.param                | PASS   |  2 | 0.002 |
| [test-base.R](testthat/test-base.R#L1049)                                     | base tests          | test.sfpower.param               | PASS   |  3 | 0.002 |
| [test-base.R](testthat/test-base.R#L1055)                                     | base tests          | test.sfTDist.param               | PASS   |  4 | 0.004 |
| [test-base.R](testthat/test-base.R#L1065)                                     | base tests          | test.sfTDist.param               | PASS   |  1 | 0.001 |
| [test-base.R](testthat/test-base.R#L1069_L1072)                               | base tests          | test.simBinomial.adj             | PASS   |  4 | 0.015 |
| [test-base.R](testthat/test-base.R#L1088_L1091)                               | base tests          | test.simBinomial.chisq           | PASS   |  4 | 0.017 |
| [test-base.R](testthat/test-base.R#L1107_L1110)                               | base tests          | test.simBinomial.delta0          | PASS   |  4 | 0.024 |
| [test-base.R](testthat/test-base.R#L1126_L1129)                               | base tests          | test.simBinomial.n1              | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L1140_L1143)                               | base tests          | test.simBinomial.n2              | PASS   |  3 | 0.005 |
| [test-base.R](testthat/test-base.R#L1154_L1156)                               | base tests          | test.simBinomial.p1              | PASS   |  4 | 0.006 |
| [test-base.R](testthat/test-base.R#L1170_L1172)                               | base tests          | test.simBinomial.p2              | PASS   |  4 | 0.007 |
| [test-base.R](testthat/test-base.R#L1186_L1189)                               | base tests          | test.simBinomial.scale           | PASS   |  3 | 0.009 |
| [test-base.R](testthat/test-base.R#L1201_L1204)                               | base tests          | test.testBinomial.adj            | PASS   |  4 | 0.009 |
| [test-base.R](testthat/test-base.R#L1220_L1223)                               | base tests          | test.testBinomial.chisq          | PASS   |  4 | 0.009 |
| [test-base.R](testthat/test-base.R#L1239_L1242)                               | base tests          | test.testBinomial.delta0         | PASS   |  4 | 0.012 |
| [test-base.R](testthat/test-base.R#L1258_L1260)                               | base tests          | test.testBinomial.n1             | PASS   |  2 | 0.010 |
| [test-base.R](testthat/test-base.R#L1267_L1269)                               | base tests          | test.testBinomial.n2             | PASS   |  2 | 0.003 |
| [test-base.R](testthat/test-base.R#L1276_L1279)                               | base tests          | test.testBinomial.scale          | PASS   |  3 | 0.007 |
| [test-base.R](testthat/test-base.R#L1291_L1294)                               | base tests          | test.testBinomial.tol            | PASS   |  2 | 0.004 |
| [test-base.R](testthat/test-base.R#L1302_L1304)                               | base tests          | test.testBinomial.x1             | PASS   |  4 | 0.008 |
| [test-base.R](testthat/test-base.R#L1318_L1320)                               | base tests          | test.testBinomial.x2             | PASS   |  4 | 0.009 |
| [test-base.R](testthat/test-base.R#L1334_L1340)                               | base tests          | test.ciBinomial.misc             | PASS   |  3 | 0.161 |
| [test-base.R](testthat/test-base.R#L1357_L1360)                               | base tests          | test.ciBinomial.ORscale.Infinity | PASS   |  6 | 0.105 |
| [test-base.R](testthat/test-base.R#L1386_L1389)                               | base tests          | test.ciBinomial.RRscale.Infinity | PASS   |  2 | 0.026 |
| [test-base.R](testthat/test-base.R#L1397_L1402)                               | base tests          | test.nBinomial.misc              | PASS   |  6 | 0.015 |
| [test-base.R](testthat/test-base.R#L1439_L1445)                               | base tests          | test.simBinomial.misc            | PASS   |  6 | 0.578 |
| [test-base.R](testthat/test-base.R#L1480_L1486)                               | base tests          | test.testBinomial.numerics       | PASS   |  4 | 0.011 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L4_L6)              | binomial inputs     | test.testBinomial.x2             | PASS   |  4 | 0.008 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L19_L21)            | binomial inputs     | test.testBinomial.x1             | PASS   |  4 | 0.008 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L34_L37)            | binomial inputs     | test.testBinomial.tol            | PASS   |  2 | 0.004 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L45_L48)            | binomial inputs     | test.testBinomial.scale          | PASS   |  3 | 0.006 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L60_L62)            | binomial inputs     | test.testBinomial.n2             | PASS   |  2 | 0.003 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L69_L71)            | binomial inputs     | test.testBinomial.n1             | PASS   |  2 | 0.002 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L78_L81)            | binomial inputs     | test.testBinomial.delta0         | PASS   |  4 | 0.011 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L97_L100)           | binomial inputs     | test.testBinomial.chisq          | PASS   |  4 | 0.008 |
| [test-binomial\_inputs.R](testthat/test-binomial_inputs.R#L116_L119)          | binomial inputs     | test.testBinomial.adj            | PASS   |  4 | 0.009 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L4_L7)     | binomial sim inputs | test.simBinomial.adj             | PASS   |  4 | 0.017 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L23_L26)   | binomial sim inputs | test.simBinomial.chisq           | PASS   |  4 | 0.019 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L42_L45)   | binomial sim inputs | test.simBinomial.delta0          | PASS   |  4 | 0.024 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L61_L64)   | binomial sim inputs | test.simBinomial.n1              | PASS   |  3 | 0.010 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L75_L78)   | binomial sim inputs | test.simBinomial.n2              | PASS   |  3 | 0.005 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L89_L91)   | binomial sim inputs | test.simBinomial.p1              | PASS   |  4 | 0.005 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L105_L107) | binomial sim inputs | test.simBinomial.p2              | PASS   |  4 | 0.006 |
| [test-binomial\_sim\_inputs.R](testthat/test-binomial_sim_inputs.R#L121_L124) | binomial sim inputs | test.simBinomial.scale           | PASS   |  3 | 0.009 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L4_L10)             | binomial stress     | test.simBinomial.misc            | PASS   |  6 | 0.580 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L45_L51)            | binomial stress     | test.testBinomial.numerics       | PASS   |  4 | 0.011 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L76_L81)            | binomial stress     | test.nBinomial.misc              | PASS   |  6 | 0.014 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L117_L120)          | binomial stress     | test.ciBinomial.RRscale.Infinity | PASS   |  2 | 0.026 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L128_L131)          | binomial stress     | test.ciBinomial.ORscale.Infinity | PASS   |  6 | 0.108 |
| [test-binomial\_stress.R](testthat/test-binomial_stress.R#L157_L163)          | binomial stress     | test.ciBinomial.misc             | PASS   |  3 | 0.156 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L4_L7)          | ci binomial inputs  | test.ciBinomial.adj              | PASS   |  4 | 0.008 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L23_L26)        | ci binomial inputs  | test.ciBinomial.alpha            | PASS   |  4 | 0.007 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L42_L44)        | ci binomial inputs  | test.ciBinomial.n1               | PASS   |  3 | 0.003 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L54_L56)        | ci binomial inputs  | test.ciBinomial.n2               | PASS   |  3 | 0.005 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L66_L69)        | ci binomial inputs  | test.ciBinomial.scale            | PASS   |  3 | 0.006 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L81_L84)        | ci binomial inputs  | test.ciBinomial.tol              | PASS   |  2 | 0.002 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L92_L94)        | ci binomial inputs  | test.ciBinomial.x1               | PASS   |  4 | 0.006 |
| [test-cibinomial\_inputs.R](testthat/test-cibinomial_inputs.R#L107_L109)      | ci binomial inputs  | test.ciBinomial.x2               | PASS   |  4 | 0.007 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L4)                             | gs inputs           | test.gsDesign.alpha              | PASS   |  5 | 0.009 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L14)                            | gs inputs           | test.gsDesign.astar              | PASS   |  5 | 0.009 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L28)                            | gs inputs           | test.gsDesign.beta               | PASS   |  5 | 0.014 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L42)                            | gs inputs           | test.gsDesign.delta              | PASS   |  3 | 0.006 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L48)                            | gs inputs           | test.gsDesign.k                  | PASS   |  6 | 0.168 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L60)                            | gs inputs           | test.gsDesign.maxn.I             | PASS   |  1 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L64)                            | gs inputs           | test.gsDesign.n.fix              | PASS   |  3 | 0.006 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L70)                            | gs inputs           | test.gsDesign.n.I                | PASS   |  1 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L74)                            | gs inputs           | test.gsDesign.r                  | PASS   |  4 | 0.010 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L81)                            | gs inputs           | test.gsDesign.sfl                | PASS   |  2 | 0.006 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L86)                            | gs inputs           | test.gsDesign.sflpar             | PASS   |  2 | 0.007 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L91)                            | gs inputs           | test.gsDesign.sfu                | PASS   |  2 | 0.005 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L96)                            | gs inputs           | test.gsDesign.sfupar             | PASS   |  2 | 0.006 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L101)                           | gs inputs           | test.gsDesign.test.type          | PASS   |  9 | 0.020 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L113)                           | gs inputs           | test.gsDesign.timing             | PASS   |  6 | 0.014 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L122)                           | gs inputs           | test.gsDesign.tol                | PASS   |  4 | 0.016 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L129)                           | gs inputs           | test.gsBoundCP.r                 | PASS   |  4 | 0.004 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L136)                           | gs inputs           | test.gsBoundCP.theta             | PASS   |  2 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L141)                           | gs inputs           | test.gsBoundCP.x                 | PASS   |  1 | 0.001 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L145)                           | gs inputs           | test.gsCP.r                      | PASS   |  4 | 0.004 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L152)                           | gs inputs           | test.gsCP.x                      | PASS   |  1 | 0.001 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L156_L158)                      | gs inputs           | test.gsbound1.a                  | PASS   |  2 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L166_L168)                      | gs inputs           | test.gsbound1.I                  | PASS   |  3 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L178_L180)                      | gs inputs           | test.gsbound1.probhi             | PASS   |  4 | 0.003 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L194_L197)                      | gs inputs           | test.gsbound1.r                  | PASS   |  4 | 0.003 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L213_L215)                      | gs inputs           | test.gsbound1.theta              | PASS   |  2 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L222_L225)                      | gs inputs           | test.gsbound1.tol                | PASS   |  2 | 0.002 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L233_L235)                      | gs inputs           | test.gsbound.falsepos            | PASS   |  4 | 0.004 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L248_L250)                      | gs inputs           | test.gsbound.I                   | PASS   |  3 | 0.003 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L260_L262)                      | gs inputs           | test.gsbound.r                   | PASS   |  4 | 0.004 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L276_L278)                      | gs inputs           | test.gsbound.tol                 | PASS   |  2 | 0.001 |
| [test-gs\_inputs.R](testthat/test-gs_inputs.R#L285_L287)                      | gs inputs           | test.gsbound.trueneg             | PASS   |  4 | 0.003 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L4)                   | gs probability      | test.gsProbability.a             | PASS   |  2 | 0.003 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L9)                   | gs probability      | test.gsProbability.b             | PASS   |  2 | 0.002 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L14)                  | gs probability      | test.gsProbability.k             | PASS   |  5 | 0.007 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L22)                  | gs probability      | test.gsProbability.n.I           | PASS   |  4 | 0.004 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L29)                  | gs probability      | test.gsProbability.r             | PASS   |  4 | 0.004 |
| [test-gs\_probability.R](testthat/test-gs_probability.R#L36)                  | gs probability      | test.gsProbability.theta         | PASS   |  1 | 0.001 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L57)                            | gs stress           | test.stress.sfExp.type1          | PASS   |  1 | 0.125 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L62)                            | gs stress           | test.stress.sfExp.type2          | PASS   |  1 | 0.106 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L67)                            | gs stress           | test.stress.sfExp.type3          | PASS   |  1 | 1.120 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L72)                            | gs stress           | test.stress.sfExp.type4          | PASS   |  1 | 0.360 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L77)                            | gs stress           | test.stress.sfExp.type5          | PASS   |  1 | 0.093 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L82)                            | gs stress           | test.stress.sfExp.type6          | PASS   |  1 | 0.154 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L87)                            | gs stress           | test.stress.sfHSD.type1          | PASS   |  1 | 0.089 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L92)                            | gs stress           | test.stress.sfHSD.type2          | PASS   |  1 | 0.072 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L97)                            | gs stress           | test.stress.sfHSD.type3          | PASS   |  1 | 0.622 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L102)                           | gs stress           | test.stress.sfHSD.type4          | PASS   |  1 | 0.181 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L107)                           | gs stress           | test.stress.sfHSD.type5          | PASS   |  1 | 0.070 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L112)                           | gs stress           | test.stress.sfHSD.type6          | PASS   |  1 | 0.107 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L120)                           | gs stress           | test.stress.sfLDOF.type1         | PASS   |  1 | 1.017 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L128)                           | gs stress           | test.stress.sfLDOF.type2         | PASS   |  1 | 0.583 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L136)                           | gs stress           | test.stress.sfLDOF.type3         | PASS   |  1 | 8.749 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L144)                           | gs stress           | test.stress.sfLDOF.type4         | PASS   |  1 | 2.062 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L152)                           | gs stress           | test.stress.sfLDOF.type5         | PASS   |  1 | 0.739 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L160)                           | gs stress           | test.stress.sfLDOF.type6         | PASS   |  1 | 1.387 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L168)                           | gs stress           | test.stress.sfLDPocock.type1     | PASS   |  1 | 0.995 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L176)                           | gs stress           | test.stress.sfLDPocock.type2     | PASS   |  1 | 0.543 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L184)                           | gs stress           | test.stress.sfLDPocock.type3     | PASS   |  1 | 8.110 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L192)                           | gs stress           | test.stress.sfLDPocock.type4     | PASS   |  1 | 2.061 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L200)                           | gs stress           | test.stress.sfLDPocock.type5     | PASS   |  1 | 0.736 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L208)                           | gs stress           | test.stress.sfLDPocock.type6     | PASS   |  1 | 1.275 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L213)                           | gs stress           | test.stress.sfPower.type1        | PASS   |  1 | 0.124 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L218)                           | gs stress           | test.stress.sfPower.type2        | PASS   |  1 | 0.121 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L223)                           | gs stress           | test.stress.sfPower.type3        | PASS   |  1 | 1.477 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L228)                           | gs stress           | test.stress.sfPower.type4        | PASS   |  1 | 0.275 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L233)                           | gs stress           | test.stress.sfPower.type5        | PASS   |  1 | 0.110 |
| [test-gs\_stress.R](testthat/test-gs_stress.R#L238)                           | gs stress           | test.stress.sfPower.type6        | PASS   |  1 | 0.163 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L4_L6)            | nbinomial inputs    | test.nBinomial.alpha             | PASS   |  5 | 0.009 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L22_L24)          | nbinomial inputs    | test.nBinomial.beta              | PASS   |  4 | 0.008 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L37_L39)          | nbinomial inputs    | test.nBinomial.delta0            | PASS   |  3 | 0.006 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L47_L49)          | nbinomial inputs    | test.nBinomial.outtype           | PASS   |  4 | 0.009 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L62)              | nbinomial inputs    | test.nBinomial.p1                | PASS   |  3 | 0.004 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L68)              | nbinomial inputs    | test.nBinomial.p2                | PASS   |  3 | 0.004 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L74_L76)          | nbinomial inputs    | test.nBinomial.ratio             | PASS   |  3 | 0.007 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L85)              | nbinomial inputs    | test.nBinomial.scale             | PASS   |  3 | 0.007 |
| [test-nbinomial\_inputs.R](testthat/test-nbinomial_inputs.R#L95_L97)          | nbinomial inputs    | test.nBinomial.sided             | PASS   |  4 | 0.006 |
| [test-normal\_grid\_inputs.R](testthat/test-normal_grid_inputs.R#L4)          | normal grid inputs  | test.normalGrid.bounds           | PASS   |  3 | 0.004 |
| [test-normal\_grid\_inputs.R](testthat/test-normal_grid_inputs.R#L10)         | normal grid inputs  | test.normalGrid.mu               | PASS   |  2 | 0.003 |
| [test-normal\_grid\_inputs.R](testthat/test-normal_grid_inputs.R#L15)         | normal grid inputs  | test.normalGrid.r                | PASS   |  4 | 0.011 |
| [test-normal\_grid\_inputs.R](testthat/test-normal_grid_inputs.R#L22)         | normal grid inputs  | test.normalGrid.sigma            | PASS   |  3 | 0.004 |
| [test-outputs.R](testthat/test-outputs.R#L12)                                 | outputs             | test.Deming.gsProb               | PASS   |  4 | 0.011 |
| [test-outputs.R](testthat/test-outputs.R#L23_L26)                             | outputs             | test.Deming.OFbound              | PASS   |  1 | 0.029 |
| [test-outputs.R](testthat/test-outputs.R#L31)                                 | outputs             | test.JT.OFss                     | PASS   |  4 | 0.261 |
| [test-outputs.R](testthat/test-outputs.R#L40)                                 | outputs             | test.JT.Pocock                   | PASS   |  6 | 0.166 |
| [test-outputs.R](testthat/test-outputs.R#L62)                                 | outputs             | test.JT.Power.symm               | PASS   |  9 | 0.061 |
| [test-outputs.R](testthat/test-outputs.R#L98)                                 | outputs             | test.JT.Power.type3              | PASS   | 18 | 1.574 |
| [test-outputs.R](testthat/test-outputs.R#L149)                                | outputs             | test.JT.WT                       | PASS   |  6 | 0.186 |
| [test-plot\_inputs.R](testthat/test-plot_inputs.R#L4)                         | plot inputs         | test.plot.gsDesign.plottype      | PASS   |  4 | 0.005 |
| [test-plot\_inputs.R](testthat/test-plot_inputs.R#L11)                        | plot inputs         | test.plot.gsProbability.plottype | PASS   |  4 | 0.005 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L4)                             | sf inputs           | test.sfTDist.param               | PASS   |  4 | 0.004 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L13_L15)                        | sf inputs           | test.sfTDist.param               | PASS   |  1 | 0.000 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L19)                            | sf inputs           | test.sfpower.param               | PASS   |  3 | 0.003 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L25)                            | sf inputs           | test.sfnorm.param                | PASS   |  2 | 0.002 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L33)                            | sf inputs           | test.sfnorm.param                | PASS   |  2 | 0.001 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L38)                            | sf inputs           | test.sflogistic.param            | PASS   |  2 | 0.002 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L46)                            | sf inputs           | test.sflogistic.param            | PASS   |  2 | 0.002 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L51)                            | sf inputs           | test.sfHSD.param                 | PASS   |  4 | 0.003 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L58)                            | sf inputs           | test.sfexp.param                 | PASS   |  4 | 0.003 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L65)                            | sf inputs           | test.sfcauchy.param              | PASS   |  2 | 0.002 |
| [test-sf\_inputs.R](testthat/test-sf_inputs.R#L73)                            | sf inputs           | test.sfcauchy.param              | PASS   |  2 | 0.002 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                               |
| :------- | :---------------------------------- |
| Version  | R version 3.5.1 (2018-07-02)        |
| Platform | x86\_64-apple-darwin15.6.0 (64-bit) |
| Running  | macOS 10.14.2                       |
| Language | en\_US                              |
| Timezone | America/Chicago                     |

| Package  | Version    |
| :------- | :--------- |
| testthat | 2.0.0.9000 |
| covr     | 3.2.0      |
| covrpage | 0.0.69     |

</details>

<!--- Final Status : pass --->
