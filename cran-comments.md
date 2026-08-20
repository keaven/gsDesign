# Version 3.10.1 July, 2026

This is a patch release fixing independent selection of futility and harm
bounds at group sequential analyses.

# Test environments

GitHub Actions at github.com/keaven/gsDesign (all pass):

- macOS (latest), R release
- Windows (latest), R release
- Ubuntu (latest), R devel
- Ubuntu (latest), R release
- Ubuntu (latest), R oldrel-1

Local `R CMD check --as-cran` on macOS Tahoe 26.5.2 with R 4.6.1:

0 errors | 0 warnings | 1 note

The local-only NOTE reports that HTML validation was skipped because the
installed HTML Tidy is not recent enough. This is an environment/tooling note,
not a package-content issue.

# Reverse dependencies

There are 8 reverse dependencies in Depends, Imports, or LinkingTo on CRAN:
gsbDesign, gsDesign2, gsDesignNB, gsDesignTune, gsearly, gsMeanFreq,
randomizeR, ssutil.

No breaking API changes were made in this release. All existing exported
functions retain their prior interfaces.
