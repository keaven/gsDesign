# Version 3.1.1, May, 2020

This is my first release to CRAN since 2016 since I moved the repository from RForge to github/keaven.
There is little functionality change and much modernization, in an effort to align with current expectations.

# Test environments

All are on github

- Windows (latest)
- MacOS (latest)
- MacOS latest (devel)
- Ubuntu-16.04 (release)

# R CMD check results


# Continuous integration
- pkgdown web site at github.io
- R CMD check running on github
- Unit testing coverage report

# Summary of package updates

- sequentialPvalue() is new functionality to enable an adjusted p-value approach for group sequential design
- gsDesign() has new arguments `usTime` and `lsTime` that have allow more flexibility in group sequential
boundary derivation
- hGraph() is used to enable illustration of the **gMCP** package with group sequential design
- Vignettes have been replaced
- Unit testing has been added to and transformed from **RUnit** to **testthat**
