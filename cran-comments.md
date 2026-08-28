# Version 3.11.0 August, 2026

This minor release expands survival-design planning and power evaluation,
including calendar-time analysis rules and sensitivity scenarios. It also adds
minimum median follow-up summaries and extends exact-binomial and sequential
p-value support for non-binding futility and harm monitoring.

# Test environments

GitHub Actions at github.com/keaven/gsDesign (all pass):

- macOS (latest), R release
- Windows (latest), R release
- Ubuntu (latest), R devel
- Ubuntu (latest), R release
- Ubuntu (latest), R oldrel-1

Local `R CMD check --as-cran` on macOS Tahoe 26.6.2 with R 4.6.1:

0 errors | 0 warnings | 1 note

The local-only NOTE reports that HTML validation was skipped because the
installed HTML Tidy is not recent enough. This is an environment/tooling note,
not a package-content issue.

# Reverse dependencies

There are 8 reverse dependencies in Depends, Imports, or LinkingTo on CRAN:
gsbDesign, gsDesign2, gsDesignNB, gsDesignTune, gsearly, gsMeanFreq,
randomizeR, ssutil.

All 8 were checked against this release. Seven completed with status OK.
randomizeR completed with one pre-existing NOTE for unescaped braces in its
own `makeDesignMatrix.Rd` documentation. There were no new reverse-dependency
problems attributable to gsDesign. The later `gsSurvPower()` reconstruction
and timing updates (#311, #314) do not change previously exported interfaces
used by these reverse dependencies, so the existing revdep results still
apply.

No breaking API changes were made in this release. Existing exported
interfaces remain compatible; new output components are additive.
