---
name: exact-binomial-spending
description: Build and document exact binomial group sequential designs with spending in gsDesign. Use when the user mentions toBinomialExact, gsBinomialExact, repeatedPValueBinomialExact, sequentialPValueBinomialExact, vaccine/prevention efficacy with seasonal looks, or blinded information-based adaptation with fixed spending fractions.
---

# Exact Binomial Spending Workflow

Use this skill for exact-binomial-with-spending design, analysis, testing, and vignette authoring in this repository.

## When To Apply

Apply this skill when the task includes one or more of:

- `toBinomialExact()`, `gsBinomialExact()`, or exact event-count bounds.
- `repeatedPValueBinomialExact()` or `sequentialPValueBinomialExact()`.
- Spending functions for exact binomial monitoring.
- Seasonal vaccine/prevention workflows with analyses by season.
- Blinded information-adaptive enrollment updates with fixed spending fractions.
- New vignette authoring for exact binomial spending scenarios.

## Repository Conventions To Preserve

1. **Spending denominator is planned final events**
- Compute spending time relative to planned final event count.
- Do not change the denominator when observed events exceed plan.

2. **Single look at or beyond final planned events**
- Enforce at most one analysis with `n.I >= planned_final_events`.
- Rationale: spending functions already saturate at the first `t >= 1`.

3. **Exact efficacy control under non-binding futility**
- For Type I calculations of efficacy bounds, ignore non-binding futility.

4. **Public vs internal API**
- Keep user-facing functions exported and documented.
- Keep low-level bound helpers internal (`@keywords internal`, `@noRd`) unless explicitly requested.

## Standard Implementation Pattern

1. Build time-to-event scaffold with `gsSurv(...)` and chosen spending function.
2. Convert timing/counts to integer events (`toInteger(...)` as needed).
3. Convert to exact binomial bounds with `toBinomialExact(...)`.
4. Compute exact p-values with:
   - `repeatedPValueBinomialExact(...)`
   - `sequentialPValueBinomialExact(...)`
5. Add focused tests for:
   - input validation,
   - spending-time constraints,
   - coherence (`sequential == min(repeated)`),
   - behavior under planned and updated event counts.
6. Regenerate docs and namespace with roxygen.

## Vignette Authoring Pattern

For exact-binomial spending vignettes, include:

1. **Assumptions section**
- Clinical context, null/alternative effect scale, event/dropout assumptions.

2. **Design section**
- Planned seasonal looks and spending times.
- Exact boundary derivation and spending checks.

3. **Inference section**
- Demonstrate repeated and sequential exact p-values on plausible observed counts.

4. **Adaptive extension**
- Blinded update rule for future enrollment/information.
- Keep spending fractions unchanged.

5. **Simulation section**
- Lightweight runnable chunk for package builds.
- `eval=FALSE` offline template for larger runs.

6. **Operational note**
- Defer `NEWS.md` updates until feature batch is stable, unless the user asks otherwise.

## Prompt Templates

Use ready-to-copy prompts from:

- [examples.md](examples.md)
