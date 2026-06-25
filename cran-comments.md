# Version 3.10.0 June, 2026

This is a feature and maintenance release.

# Test environments

All are on GitHub Actions at github.com/keaven/gsDesign:

- Windows (latest)
- macOS (latest)
- Ubuntu (latest), R release
- Ubuntu (latest), R devel
- Ubuntu (latest), R oldrel-1

# R CMD check results

Local `R CMD check --as-cran` on macOS Tahoe 26.5.1 with R 4.5.2:

0 errors | 1 warning | 2 notes

The warning is from R's `R_ext/Boolean.h` header with Apple clang 21:
`unknown warning group '-Wfixed-enum-extension'`.

The notes are local environment issues:

- unable to verify current time
- HTML manual validation skipped because local HTML Tidy is not recent enough
