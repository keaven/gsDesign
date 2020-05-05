# Version 3.1.1, May, 2020

This is my first release to CRAN since 2016 since I moved the repository from RForge to github/keaven.
There is little functionality change and much modernization, in an effort to align with current expectations.

Expectation is that all is backwards compatible.

# Test environments

All are on github

- Windows (latest)
- MacOS (latest)
- MacOS latest (devel)
- Ubuntu-16.04 (release)

# R CMD check results

0 errors | 0 warnings | 0 notes

The following seems to have no impact:
Writing NAMESPACE
Warning: [/Users/keaven/github/gsDesign/R/hgraph.r:1] @title Missing name
Writing NAMESPACE
Warning: Topic 'xtable': no parameters to inherit with @inheritParams

# Reverse dependencies

Not checked, but there are only 6 packages depending on gsDesign.
Given complete backwards compatibility, no breaks are expected.

Reverse depends:	coprimary, gsbDesign
Reverse suggests:	ADCT, gscounts, ph2bye, ph2mult
