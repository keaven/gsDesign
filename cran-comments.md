# Version 3.10.0 July, 2026

This is a feature and maintenance release.

# Test environments

GitHub Actions at github.com/keaven/gsDesign (all pass):

- macOS (latest), R release
- Windows (latest), R release
- Ubuntu (latest), R devel
- Ubuntu (latest), R release
- Ubuntu (latest), R oldrel-1

Local `R CMD check --as-cran` on macOS Tahoe 26.5.2 with R 4.5.0:

0 errors | 0 warnings | 0 notes

(One local-only WARNING from R's own `R_ext/Boolean.h` header with
Apple clang 21: `unknown warning group '-Wfixed-enum-extension'`.
Two local-only NOTEs: "unable to verify current time" and HTML Tidy
version too old. None of these appear on CRAN infrastructure.)

# Reverse dependencies

There are 8 reverse dependencies on CRAN:
gsbDesign, gsDesign2, gsDesignNB, gsDesignTune, gsearly, gsMeanFreq,
randomizeR, ssutil.

No breaking API changes were made in this release. All existing
exported functions retain their prior interfaces.
