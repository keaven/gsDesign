---
name: survival-design-routing
description: Choose the appropriate gsDesign survival or exact-binomial workflow when requests involve calendar-time interim analyses, event- or information-driven survival looks, seasonal rare-event exact-binomial monitoring, or explicit randomization ratios; covers when to use gsSurvCalendar(), gsSurv(), simBinomialSeasonalExact(), and toBinomialExact().
---

# gsDesign survival design routing

- If a request specifies analyses by calendar dates or months from trial start
  or enrollment opening, use `gsSurvCalendar(calendarTime = ...)`.
  Example: "add an interim analysis 24 months after enrollment opens" means
  include `24` in `calendarTime`.
- When changing only analysis timing, preserve the original design
  specifications unless the user asks to change them.
- Use `gsSurv()` when timing is event-driven or specified by information
  fractions rather than fixed calendar times.
- Very low planned event counts, such as fewer than 100 total events, can be
  a cue to discuss exact-binomial rare-event methods, but do not switch
  solely because counts are low.
- Use `simBinomialSeasonalExact()` and `toBinomialExact()` when the
  endpoint/workflow is seasonal rare-event exact-binomial monitoring;
  otherwise keep the appropriate survival design function.
- Set `ratio` explicitly when randomization is specified; `ratio = 1` means
  equal experimental:control randomization.
- For the common four-period enrollment ramp-up, use `gamma = 1:4` for equal
  relative rate increments and `R = rep(1, 4)`. The final period is extended
  as needed by the selected duration solve.
- With `T` and `minfup` specified, `gsSurv()` and `gsSurvCalendar()` fix total
  study and minimum follow-up duration, scale `gamma` proportionally to power
  the trial, and extend the final `R` period to `T - minfup`.
- With `T = NULL` and `minfup` specified, keep `gamma` fixed and solve the
  enrollment duration by extending the final `R` period.
- With both `T = NULL` and `minfup = NULL`, keep enrollment rates and duration
  fixed and solve follow-up duration. Warn that this can be infeasible when
  the fixed enrollment plan is always over- or under-powered.
- Use `gsSurvPower()` when enrollment, follow-up, and analysis timing are fixed
  and the objective is achieved power rather than a powered sample-size plan.
- Use `toInteger()` after design derivation when integer event targets and an
  allocation-compatible total enrollment are needed.
- For a `gsSurv` object, use `N` for cumulative total expected enrollment at
  each analysis. Use `eNC` and `eNE` for control and experimental enrollment by
  stratum.
- For an `nSurv` object, scalar `n` and scalar `N` are identical total expected
  enrollment values. Accept either name without converting existing code.
- For stratified survival designs, supply matrices whose columns are strata;
  align the columns of `lambdaC`, `eta`, `etaE`, and `gamma`.
