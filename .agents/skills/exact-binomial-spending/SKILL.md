---
name: exact-binomial-spending
description: Build and document exact binomial group sequential designs with spending in gsDesign. Use when the user mentions toBinomialExact, gsBinomialExact, repeatedPValueBinomialExact, sequentialPValueBinomialExact, simBinomialSeasonalExact, vaccine/prevention efficacy with seasonal looks, or blinded information-based adaptation with fixed spending fractions.
---

# Exact Binomial Spending Workflow

Use this skill for exact-binomial-with-spending design, analysis, testing, and vignette authoring in this repository.

## When To Apply

Apply this skill when the task includes one or more of:

- `toBinomialExact()`, `gsBinomialExact()`, or exact event-count bounds.
- `repeatedPValueBinomialExact()` or `sequentialPValueBinomialExact()`.
- `simBinomialSeasonalExact()` for seasonal fixed/adaptive simulation summaries.
- Spending functions for exact binomial monitoring.
- Seasonal vaccine/prevention workflows with analyses by season.
- Blinded information-adaptive enrollment updates with fixed spending fractions.
- New vignette authoring for exact binomial spending scenarios.

## Repository Conventions To Preserve

1. **Spending denominator is planned final events**
- Compute spending time relative to planned final event count.
- Do not change the denominator when observed events exceed plan.
- If explicit overrides are needed, use `usTime`/`lsTime` consistent with
  `gsDesign()`/`gsSurv()` conventions.

2. **Single look at or beyond final planned events**
- Enforce at most one analysis with `n.I >= planned_final_events`.
- Rationale: spending functions already saturate at the first `t >= 1`.

3. **Exact efficacy control under non-binding futility**
- For Type I calculations of efficacy bounds, ignore non-binding futility.
- If reporting futility behavior from simulation, treat futility stopping
  probability separately from non-binding Type I error.

4. **Public vs internal API**
- Keep user-facing functions exported and documented.
- Keep low-level bound helpers internal (`@keywords internal`, `@noRd`) unless explicitly requested.

5. **Official update path at analysis time**
- Use `toBinomialExact(gsD, observedEvents = ...)` for analysis-time exact bound updates.
- For explicit spending-time control, use
  `toBinomialExact(gsD, observedEvents = ..., usTime = ..., lsTime = ...)`.
- For selective futility designs, preserve `testLower` intent from `gsSurv()`.
- If simulation needs bound checks at fixed alpha, prefer public wrappers/helpers over `gsDesign:::` in user-facing examples whenever practical.

## Standard Implementation Pattern

1. Build time-to-event scaffold with `gsSurv(...)` and chosen spending function.
2. Convert timing/counts to integer events (`toInteger(...)` as needed).
3. Convert to exact binomial bounds with `toBinomialExact(...)`.
4. Compute exact p-values with:
   - `repeatedPValueBinomialExact(...)`
   - `sequentialPValueBinomialExact(...)`
5. For seasonal simulation studies, prefer `simBinomialSeasonalExact(...)`
   instead of embedding large custom simulation helpers directly in vignettes.
6. Add focused tests for:
   - input validation,
   - spending-time constraints,
   - coherence (`sequential == min(repeated)`),
   - behavior under planned and updated event counts.
7. Regenerate docs and namespace with roxygen.

## Vignette Authoring Pattern

For exact-binomial spending vignettes, include:

1. **Assumptions section**
- Clinical context, null/alternative effect scale, event/dropout assumptions.

2. **Design section**
- Planned seasonal looks and spending times.
- Exact boundary derivation and spending checks.

3. **Inference section**
- Demonstrate repeated and sequential exact p-values on plausible observed counts.
- Include a short demo of `toBinomialExact(observedEvents = ...)` for
  analysis-time bound updates.

4. **Adaptive extension**
- Blinded update rule for future enrollment/information.
- Keep spending fractions unchanged.
- If final-look full spending is desired under under-run, use
  `maxSpend = TRUE` (or `final_full_spending = TRUE` in simulation helper).

5. **Simulation section**
- Prefer package simulation helpers (for example, `simBinomialSeasonalExact()`).
- Lightweight runnable chunk for package builds.
- `eval=FALSE` offline template for larger runs.
- Present both efficacy crossing probability and futility stopping probability;
  when quoting Type I error under non-binding futility, label that explicitly.

6. **Operational note**
- Defer `NEWS.md` updates until feature batch is stable, unless the user asks otherwise.

## Prompt Templates

Use ready-to-copy prompts from:

- [examples.md](examples.md)
