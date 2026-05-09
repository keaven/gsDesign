# Prompt Templates

## Template 1: New Seasonal Rare-Event Vignette

Copy/paste and edit values in brackets:

```text
Create a new gsDesign vignette at vignettes/[VignetteName].Rmd for a [clinical context] rare-event study with exact binomial spending bounds.

Requirements:
1) Use a main example with:
   - null effect [null scale/values]
   - alternative effect [alt scale/values]
   - one-sided alpha [alpha], beta [beta]
   - randomization ratio [ratio]
   - seasonal event rate [rate] over [season length]
   - dropout [dropout %] modeled as exponential over the season
2) Use three looks at spending times 1/3, 2/3, 1.
3) Use efficacy spending function sfHSD with gamma = 1 (Pocock-like).
4) Build design via gsSurv -> toInteger (if needed) -> toBinomialExact.
5) Demonstrate repeatedPValueBinomialExact() and sequentialPValueBinomialExact().
6) Add a blinded information-adaptive option after season 1 (and optionally season 2):
   - allow increased enrollment for subsequent seasons when events are low
   - keep spending fractions fixed
7) Add simulation:
   - lightweight runnable chunk for package builds
   - eval=FALSE offline template for larger runs (e.g., Type I error 20000, power 3500)
8) Keep code and runtime package-friendly.
9) Update _pkgdown.yml article listing to include the new vignette.
10) Do not update NEWS.md unless requested.

Important constraints:
- Spending denominator must be planned final events.
- Do not renormalize spending denominator when observed final events exceed plan.
- Enforce at most one look with n.I >= planned final events.

After editing:
- Render the vignette locally and fix any errors.
- Report changed files and summarize results.
```

## Template 2: Extend Existing Exact-Binomial Vignette

```text
Update vignette [path] to add exact-binomial repeated and sequential p-value sections.

Required additions:
- One concise subsection demonstrating repeatedPValueBinomialExact() and sequentialPValueBinomialExact().
- A short interpretation paragraph tied to non-binding futility and spending control.
- One lightweight simulation or diagnostic chunk validating operating behavior.
- One eval=FALSE chunk showing how to run larger offline simulations.

Method rules:
- Keep spending time based on planned final events.
- At most one analysis may have n.I >= planned final events.

After editing:
- Re-render the vignette and report output status.
```
