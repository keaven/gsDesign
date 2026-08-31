# Version 3.11.1 August, 2026

This patch release reduces test-suite runtime while retaining coverage for the
same exported functionality. The default tests now use smaller stress-test
grids, fewer Monte Carlo iterations, and toy exact-binomial p-value event
counts. Larger stress-test settings remain available by setting
`GSDESIGN_RUN_STRESS_TESTS=true`.

# Test environments

GitHub Actions at github.com/keaven/gsDesign:

- macOS (latest), R release
- Windows (latest), R release
- Ubuntu (latest), R devel
- Ubuntu (latest), R release
- Ubuntu (latest), R oldrel-1

Local `R CMD check --as-cran` on macOS with R 4.6.1:

0 errors | 0 warnings | 1 note

The note is only from the local HTML manual validation tool:
`tidy` does not look recent enough. All package checks, examples, tests,
vignettes, and PDF manual checks passed.

# Reverse dependencies

There are 8 reverse dependencies in Depends, Imports, or LinkingTo on CRAN:
gsbDesign, gsDesign2, gsDesignNB, gsDesignTune, gsearly, gsMeanFreq,
randomizeR, ssutil.

All 8 were checked against this release. Seven completed with status OK.
randomizeR completed with one pre-existing NOTE for unescaped braces in its
own `makeDesignMatrix.Rd` documentation. There were no new reverse-dependency
problems attributable to gsDesign. This patch release changes tests only, so
the existing revdep results still apply.

No breaking API changes were made in this release. Existing exported
interfaces remain compatible.
