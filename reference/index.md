# Package index

## Group Sequential Computation

For an overview of the gsDesign package, see
[`vignette("gsDesignPackageOverview")`](https://keaven.github.io/gsDesign/articles/gsDesignPackageOverview.md).

- [`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
  [`xtable(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
  : Design Derivation
- [`plot(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md)
  [`plot(`*`<gsProbability>`*`)`](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md)
  : Plots for group sequential designs
- [`gsProbability()`](https://keaven.github.io/gsDesign/reference/gsProbability.md)
  [`print(`*`<gsProbability>`*`)`](https://keaven.github.io/gsDesign/reference/gsProbability.md)
  : Boundary Crossing Probabilities
- [`gsBound()`](https://keaven.github.io/gsDesign/reference/gsBound.md)
  [`gsBound1()`](https://keaven.github.io/gsDesign/reference/gsBound.md)
  : Boundary derivation - low level
- [`sequentialPValue()`](https://keaven.github.io/gsDesign/reference/sequentiaPValue.md)
  : Sequential p-value computation

## Design Characterization

- [`summary(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`xprint()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsBoundSummary>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBValue()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsDelta()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsRR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsCPz()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  : Bound Summary and Z-transformations
- [`xtable`](https://keaven.github.io/gsDesign/reference/xtable.md) :
  xtable

## Normal Endpoint Design

- [`nNormal()`](https://keaven.github.io/gsDesign/reference/nNormal.md)
  : Normal distribution sample size (2-sample)

## Binomial Endpoint Design

- [`ciBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
  [`nBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
  [`simBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
  [`testBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
  [`varBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
  : Testing, Confidence Intervals, Sample Size and Power for Comparing
  Two Binomial Rates
- [`summary(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`xprint()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsBoundSummary>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBValue()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsDelta()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsRR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsCPz()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  : Bound Summary and Z-transformations
- [`binomialPowerTable()`](https://keaven.github.io/gsDesign/reference/binomialPowerTable.md)
  : Power Table for Binomial Tests

## Time-to-Event Endpoint Design

- [`print(`*`<nSurvival>`*`)`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  [`nSurvival()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  [`nEvents()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  [`zn2hr()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  [`hrn2z()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  [`hrz2n()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
  : Time-to-event sample size calculation (Lachin-Foulkes)
- [`print(`*`<nSurv>`*`)`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`tEventsIA()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`nEventsIA()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`print(`*`<gsSurv>`*`)`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  [`xtable(`*`<gsSurv>`*`)`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  : Advanced time-to-event sample size calculation
- [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
  : Time-to-event endpoint design with calendar timing of analyses
- [`summary(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`xprint()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsBoundSummary>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBValue()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsDelta()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsRR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsCPz()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  : Bound Summary and Z-transformations
- [`eEvents()`](https://keaven.github.io/gsDesign/reference/eEvents.md)
  [`print(`*`<eEvents>`*`)`](https://keaven.github.io/gsDesign/reference/eEvents.md)
  : Expected number of events for a time-to-event study
- [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  : Translate group sequential design to integer events (survival
  designs) or sample size (other designs)

## Vaccine/Prevention Efficacy

- [`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md)
  : Translate survival design bounds to exact binomial bounds

## Spending Functions

For an overview of spending functions, see
[`vignette("SpendingFunctionOverview")`](https://keaven.github.io/gsDesign/articles/SpendingFunctionOverview.md).

- [`summary(`*`<spendfn>`*`)`](https://keaven.github.io/gsDesign/reference/spendingFunction.md)
  [`spendingFunction()`](https://keaven.github.io/gsDesign/reference/spendingFunction.md)
  : Spending Function
- [`sfLDOF()`](https://keaven.github.io/gsDesign/reference/sfLDOF.md)
  [`sfLDPocock()`](https://keaven.github.io/gsDesign/reference/sfLDOF.md)
  : Lan-DeMets Spending function overview
- [`sfHSD()`](https://keaven.github.io/gsDesign/reference/sfHSD.md) :
  Hwang-Shih-DeCani Spending Function
- [`sfPower()`](https://keaven.github.io/gsDesign/reference/sfPower.md)
  : Kim-DeMets (power) Spending Function
- [`sfExponential()`](https://keaven.github.io/gsDesign/reference/sfExponential.md)
  : Exponential Spending Function
- [`sfLogistic()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  [`sfBetaDist()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  [`sfCauchy()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  [`sfExtremeValue()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  [`sfExtremeValue2()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  [`sfNormal()`](https://keaven.github.io/gsDesign/reference/sfDistribution.md)
  : Two-parameter Spending Function Families
- [`sfTDist()`](https://keaven.github.io/gsDesign/reference/sfTDist.md)
  : t-distribution Spending Function
- [`sfLinear()`](https://keaven.github.io/gsDesign/reference/sfLinear.md)
  [`sfStep()`](https://keaven.github.io/gsDesign/reference/sfLinear.md)
  : Piecewise Linear and Step Function Spending Functions
- [`sfPoints()`](https://keaven.github.io/gsDesign/reference/sfPoints.md)
  : Pointwise Spending Function
- [`sfTruncated()`](https://keaven.github.io/gsDesign/reference/sfSpecial.md)
  [`sfTrimmed()`](https://keaven.github.io/gsDesign/reference/sfSpecial.md)
  [`sfGapped()`](https://keaven.github.io/gsDesign/reference/sfSpecial.md)
  : Truncated, trimmed and gapped spending functions
- [`sfXG1()`](https://keaven.github.io/gsDesign/reference/sfXG.md)
  [`sfXG2()`](https://keaven.github.io/gsDesign/reference/sfXG.md)
  [`sfXG3()`](https://keaven.github.io/gsDesign/reference/sfXG.md) : Xi
  and Gallo conditional error spending functions

## Conditional and Predictive Power

- [`gsCP()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  [`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  [`gsPI()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  [`gsPosterior()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  [`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  [`gsCPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md) :
  Conditional and Predictive Power, Overall and Conditional Probability
  of Success
- [`summary(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsDesign>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`xprint()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`print(`*`<gsBoundSummary>`*`)`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsBValue()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsDelta()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsRR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  [`gsCPz()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  : Bound Summary and Z-transformations
- [`gsBoundCP()`](https://keaven.github.io/gsDesign/reference/gsBoundCP.md)
  : Conditional Power at Interim Boundaries
- [`normalGrid()`](https://keaven.github.io/gsDesign/reference/normalGrid.md)
  : Normal Density Grid
- [`gsDensity()`](https://keaven.github.io/gsDesign/reference/gsDensity.md)
  : Group sequential design interim density function

## Sample Size Adaptation

- [`condPower()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`ssrCP()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`plot(`*`<ssrCP>`*`)`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`z2NC()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`z2Z()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`z2Fisher()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  [`Power.ssrCP()`](https://keaven.github.io/gsDesign/reference/ssrCP.md)
  : Sample size re-estimation based on conditional power

## Single Arm Binomial Design

- [`gsBinomialExact()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  [`binomialSPRT()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  [`plot(`*`<gsBinomialExact>`*`)`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  [`plot(`*`<binomialSPRT>`*`)`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  [`nBinomial1Sample()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  : One-Sample Binomial Routines

## Input Checking

- [`checkLengths()`](https://keaven.github.io/gsDesign/reference/checkScalar.md)
  [`checkRange()`](https://keaven.github.io/gsDesign/reference/checkScalar.md)
  [`checkScalar()`](https://keaven.github.io/gsDesign/reference/checkScalar.md)
  [`checkVector()`](https://keaven.github.io/gsDesign/reference/checkScalar.md)
  [`isInteger()`](https://keaven.github.io/gsDesign/reference/checkScalar.md)
  : Utility functions to verify variable properties

## Summary tables

- [`as_table()`](https://keaven.github.io/gsDesign/reference/as_table.md)
  : Create a summary table
- [`as_gt()`](https://keaven.github.io/gsDesign/reference/as_gt.md) :
  Convert a summary table object to a gt object
- [`as_rtf()`](https://keaven.github.io/gsDesign/reference/as_rtf.md) :
  Save a summary table object as an RTF file
