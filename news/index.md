# Changelog

## gsDesign 3.8.0 (December 2025)

### New features

- [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  now displays calendar time for `gsNB` objects from the gsDesignNB
  package when analysis times are provided
  ([@keaven](https://github.com/keaven),
  [\#229](https://github.com/keaven/gsDesign/issues/229),
  [\#233](https://github.com/keaven/gsDesign/issues/233)).

### Improvements

- `plotgsPower()` now uses `linewidth` instead of deprecated `size`
  aesthetic for
  [`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)
  calls, avoiding ggplot2 (\>= 3.4.0) warnings
  ([@nanxstats](https://github.com/nanxstats),
  [\#217](https://github.com/keaven/gsDesign/issues/217)).

### Bug fixes

- [`sfXG3()`](https://keaven.github.io/gsDesign/reference/sfXG.md) now
  correctly reports its name as “Xi-Gallo, method 3” instead of
  “Xi-Gallo, method 1” ([@DMuriuki](https://github.com/DMuriuki),
  [\#223](https://github.com/keaven/gsDesign/issues/223)).
- Fixed base plotting for conditional power (`plottype = 4`) so labels
  passed to [`text()`](https://rdrr.io/r/graphics/text.html) match the
  plotted points. This prevents r-devel (R 4.6.0) truncation warnings
  and keeps vdiffr snapshots bitwise reproducible across R versions
  ([@nanxstats](https://github.com/nanxstats),
  [\#231](https://github.com/keaven/gsDesign/issues/231)).

### Testing

- Added independent unit tests for
  [`sfXG1()`](https://keaven.github.io/gsDesign/reference/sfXG.md),
  [`sfXG2()`](https://keaven.github.io/gsDesign/reference/sfXG.md), and
  [`sfXG3()`](https://keaven.github.io/gsDesign/reference/sfXG.md)
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#223](https://github.com/keaven/gsDesign/issues/223)).
- Added independent unit tests for
  [`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md)
  and
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md)
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#224](https://github.com/keaven/gsDesign/issues/224)).
- Updated
  [`as_gt()`](https://keaven.github.io/gsDesign/reference/as_gt.md)
  snapshot tests for gt 1.1.0 compatibility
  ([@nanxstats](https://github.com/nanxstats),
  [\#221](https://github.com/keaven/gsDesign/issues/221)).
- Snapshot files are now included in the built package to satisfy
  testthat (\>= 3.3.0) requirements
  ([@jdblischak](https://github.com/jdblischak),
  [\#227](https://github.com/keaven/gsDesign/issues/227)).
- Reduced visual regression test output verbosity by wrapping base
  graphics plotting expressions in
  [`capture.output()`](https://rdrr.io/r/utils/capture.output.html)
  ([@nanxstats](https://github.com/nanxstats),
  [\#217](https://github.com/keaven/gsDesign/issues/217)).

### Documentation

- [`nNormal()`](https://keaven.github.io/gsDesign/reference/nNormal.md)
  now links to
  [`vignette("nNormal")`](https://keaven.github.io/gsDesign/articles/nNormal.md)
  in its See Also section for the full derivation and examples
  ([@keaven](https://github.com/keaven),
  [\#220](https://github.com/keaven/gsDesign/issues/220)).

### Maintenance

- Added `workflow_dispatch` trigger to `R CMD check` workflow for easier
  testing on forks ([@jdblischak](https://github.com/jdblischak),
  [\#225](https://github.com/keaven/gsDesign/issues/225)).

## gsDesign 3.7.0 (August 2025)

CRAN release: 2025-08-25

### Breaking changes

- `hGraph()` has been formally removed from gsDesign
  ([@nanxstats](https://github.com/nanxstats),
  [\#215](https://github.com/keaven/gsDesign/issues/215)). It was
  soft-deprecated in gsDesign 3.4.0 and moved to gMCPLite. Use
  `gMCPLite::hGraph()` instead.

  This change also preemptively fixes an `R CMD check` issue with
  ggplot2 (\>= 4.0.0) that would otherwise require declaring MASS as an
  explicit dependency (tidyverse/ggplot2#6578).

### Testing

- Added independent unit tests for `gsAdaptSim()` and `gsSimulate()`
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#212](https://github.com/keaven/gsDesign/issues/212)).
- Added independent unit tests for
  [`binomialPowerTable()`](https://keaven.github.io/gsDesign/reference/binomialPowerTable.md)
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#214](https://github.com/keaven/gsDesign/issues/214)).

## gsDesign 3.6.9 (June 2025)

CRAN release: 2025-06-25

### Documentation

- Added new vignette
  [`vignette("binomialTwoSample")`](https://keaven.github.io/gsDesign/articles/binomialTwoSample.md)
  for binomial two-arm trial design and analysis
  ([@keaven](https://github.com/keaven),
  [\#202](https://github.com/keaven/gsDesign/issues/202)). Covers
  superiority, non-inferiority, and super-superiority designs using
  risk-difference methods. Includes sample size calculations, power
  analysis, and protocol wording with both asymptotic approximations and
  simulation approaches.

### New features

- New function
  [`binomialPowerTable()`](https://keaven.github.io/gsDesign/reference/binomialPowerTable.md)
  generates power tables across control rates and treatment effects.
  Supports both analytical calculations and fast simulation for exact
  results.

## gsDesign 3.6.8 (May 2025)

CRAN release: 2025-05-21

### Bug fixes

- [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  (as updated in gsDesign 3.6.6) did not consider spending time for
  alternate alpha levels when the `alpha` argument was specified. This
  issue has been resolved; `lsTime` and `usTime` are now correctly used
  for updated bounds with these alternate alpha levels
  ([@keaven](https://github.com/keaven),
  [\#203](https://github.com/keaven/gsDesign/issues/203)).

### Testing

- Added independent unit tests for
  [`as_gt()`](https://keaven.github.io/gsDesign/reference/as_gt.md)
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#196](https://github.com/keaven/gsDesign/issues/196)).

### Documentation

- Switched the pkgdown math renderer from KaTeX to MathJaX for improved
  compatibility, as the MathJaX support was improved in pkgdown 2.1.2
  ([@nanxstats](https://github.com/nanxstats),
  [\#200](https://github.com/keaven/gsDesign/issues/200)).
- Added Research Organization Registry (ROR) ID to `DESCRIPTION`
  ([@jdblischak](https://github.com/jdblischak),
  [\#201](https://github.com/keaven/gsDesign/issues/201)).

## gsDesign 3.6.7 (March 2025)

CRAN release: 2025-03-03

### Improvements

- All plots in vignettes are now generated by the native SVG device for
  sharper appearance and fewer package dependencies
  ([@nanxstats](https://github.com/nanxstats),
  [\#188](https://github.com/keaven/gsDesign/issues/188)).

### Testing

- Add independent unit tests for
  [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  ([@DMuriuki](https://github.com/DMuriuki),
  [\#186](https://github.com/keaven/gsDesign/issues/186)).

## gsDesign 3.6.6 (February 2025)

CRAN release: 2025-02-11

### New features

- [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  gains a new argument `alpha` to assemble a summary table with multiple
  efficacy boundaries ([@keaven](https://github.com/keaven),
  [\#183](https://github.com/keaven/gsDesign/issues/183)).

### Testing

- Add essential unit tests for
  [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
  ([@keaven](https://github.com/keaven),
  [\#178](https://github.com/keaven/gsDesign/issues/178)).
- Refactor graphical tests with
  [`vdiffr::expect_doppelganger()`](https://vdiffr.r-lib.org/reference/expect_doppelganger.html)
  ([@nanxstats](https://github.com/nanxstats),
  [\#176](https://github.com/keaven/gsDesign/issues/176)).
- Use `CODECOV_TOKEN` to fix code coverage uploads
  ([@jdblischak](https://github.com/jdblischak),
  [\#179](https://github.com/keaven/gsDesign/issues/179)).

### Documentation

- Add more details to the parameter `r` for controlling numerical
  integration grid points ([@nanxstats](https://github.com/nanxstats),
  [\#181](https://github.com/keaven/gsDesign/issues/181)).

## gsDesign 3.6.5 (November 2024)

CRAN release: 2024-11-14

### Improvements

- [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  (introduced in gsDesign 3.5.0) is updated to match broader,
  non-gsDesign conventions for deriving integer sample size and event
  counts ([@keaven](https://github.com/keaven),
  [\#172](https://github.com/keaven/gsDesign/issues/172)).

  This update may result in different outputs compared to previous
  versions. Users who use this function should review the updated
  function documentation
  ([`?toInteger`](https://keaven.github.io/gsDesign/reference/toInteger.md))
  and
  [`vignette("toInteger")`](https://keaven.github.io/gsDesign/articles/toInteger.md)
  for details.

### Testing

- Add snapshot tests for
  [`as_rtf()`](https://keaven.github.io/gsDesign/reference/as_rtf.md)
  methods ([@DMuriuki](https://github.com/DMuriuki),
  [\#168](https://github.com/keaven/gsDesign/issues/168)).

### Documentation

- Add the `cph` role to the `Authors@R` field following best practices
  ([@nanxstats](https://github.com/nanxstats),
  [\#166](https://github.com/keaven/gsDesign/issues/166)).

## gsDesign 3.6.4 (July 2024)

CRAN release: 2024-07-26

### Improvements

We have made the spending function summary output more readable and
informative.

- Text summaries for spending functions with multiple parameters are now
  properly formatted. For instance, `a b = 0.5 1.5` is now displayed as
  `a = 0.5, b = 1.5` ([@jdblischak](https://github.com/jdblischak),
  [\#162](https://github.com/keaven/gsDesign/issues/162)).
- The [`summary()`](https://rdrr.io/r/base/summary.html) method for
  [`sfLDOF()`](https://keaven.github.io/gsDesign/reference/sfLDOF.md) no
  longer includes the redundant `none = 1` in its output
  ([@jdblischak](https://github.com/jdblischak),
  [\#159](https://github.com/keaven/gsDesign/issues/159)).

### Documentation

- Added a note about using a positive scalar for `sfupar` in
  [`sfLDOF()`](https://keaven.github.io/gsDesign/reference/sfLDOF.md) to
  create a generalized O’Brien-Fleming spending function
  ([@keaven](https://github.com/keaven),
  [52cc711](https://github.com/keaven/gsDesign/commit/52cc711),
  [99996b](https://github.com/keaven/gsDesign/commit/99996b)).
- Improved math rendering in our pkgdown site vignettes by switching to
  KaTeX, which is now supported in pkgdown 2.1.0
  ([@nanxstats](https://github.com/nanxstats),
  [\#161](https://github.com/keaven/gsDesign/issues/161)).
- Standardized vignette titles and headings by using h2 as the base
  level and adopting sentence case throughout
  ([@nanxstats](https://github.com/nanxstats),
  [\#158](https://github.com/keaven/gsDesign/issues/158)).

## gsDesign 3.6.3 (July 2024)

CRAN release: 2024-07-09

### New features

- Implemented conditional error spending functions
  [`sfXG1()`](https://keaven.github.io/gsDesign/reference/sfXG.md),
  [`sfXG2()`](https://keaven.github.io/gsDesign/reference/sfXG.md), and
  [`sfXG3()`](https://keaven.github.io/gsDesign/reference/sfXG.md) based
  on Xi and Gallo (2019). See
  [`vignette("ConditionalErrorSpending")`](https://keaven.github.io/gsDesign/articles/ConditionalErrorSpending.md)
  for details and reproduced examples from the literature
  ([@keaven](https://github.com/keaven),
  [\#147](https://github.com/keaven/gsDesign/issues/147). Thanks,
  [@xidongdxi](https://github.com/xidongdxi), for comments on vignette).

### Improvements

- Enhanced
  [`eEvents()`](https://keaven.github.io/gsDesign/reference/eEvents.md)
  with input validation to ensure `lambda` is not `NULL`
  ([@keaven](https://github.com/keaven),
  [97f629d](https://github.com/keaven/gsDesign/commit/97f629d)).

### Testing

- Added independent testing for
  [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
  ([@myeongjong](https://github.com/myeongjong),
  [\#144](https://github.com/keaven/gsDesign/issues/144)).
- Expanded test coverage for
  [`gsBinomialExact()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  ([@menglu2](https://github.com/menglu2),
  [\#143](https://github.com/keaven/gsDesign/issues/143)).

## gsDesign 3.6.2 (April 2024)

CRAN release: 2024-04-09

### Documentation

- Add new vignette on conditional power and conditional error, see
  [`vignette("ConditionalPowerPlot")`](https://keaven.github.io/gsDesign/articles/ConditionalPowerPlot.md)
  ([beb2957](https://github.com/keaven/gsDesign/commit/beb2957),
  [727fe20](https://github.com/keaven/gsDesign/commit/727fe20),
  [57394fe](https://github.com/keaven/gsDesign/commit/57394fe)).
- Fix roxygen2 warning and use magrittr pipes in vignette for
  consistency ([\#131](https://github.com/keaven/gsDesign/issues/131)).

### Testing

- Move independently programmed functions for validation as standard
  test helper files
  ([\#130](https://github.com/keaven/gsDesign/issues/130)).

## gsDesign 3.6.1 (February 2024)

CRAN release: 2024-02-13

### New features

- [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  now has the
  [`as_rtf()`](https://keaven.github.io/gsDesign/reference/as_rtf.md)
  method implemented to generate RTF outputs for bound summary tables
  ([@wangben718](https://github.com/wangben718),
  [\#107](https://github.com/keaven/gsDesign/issues/107)).
- `plotgsPower()` gets new arguments `offset` and `titleAnalysisLegend`
  to enable more flexible and accurate power plots (`plottype = 2`)
  ([@jdblischak](https://github.com/jdblischak),
  [\#121](https://github.com/keaven/gsDesign/issues/121),
  [\#123](https://github.com/keaven/gsDesign/issues/123)).

### Improvements

- The plotting functions now use
  [`dplyr::reframe()`](https://dplyr.tidyverse.org/reference/reframe.html)
  to replace
  [`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  when performing grouped
  [`cumsum()`](https://rdrr.io/r/base/cumsum.html)
  ([@jdblischak](https://github.com/jdblischak),
  [\#114](https://github.com/keaven/gsDesign/issues/114)).
- The plotting functions are updated to use the `.data` pronoun from
  rlang with
  [`ggplot2::aes()`](https://ggplot2.tidyverse.org/reference/aes.html).
  This simplifies the code and follows the recommended practice when
  using ggplot2 in packages
  ([@jdblischak](https://github.com/jdblischak),
  [\#124](https://github.com/keaven/gsDesign/issues/124)).
- `hGraph()` now uses named `guide` argument in the
  [`scale_fill_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)
  call to be compatible with ggplot2 3.5.0
  ([@teunbrand](https://github.com/teunbrand),
  [\#115](https://github.com/keaven/gsDesign/issues/115)). **Note**:
  this function has been deprecated and moved to gMCPLite since gsDesign
  3.4.0. It will be removed from gsDesign in a future version. Please
  use `gMCPLite::hGraph()` instead.

### Documentation

- `vignettes("SurvivalOverview")` is updated with more details and minor
  corrections ([@keaven](https://github.com/keaven),
  [\#126](https://github.com/keaven/gsDesign/issues/126)).
- Fix equation syntax in plotting function documentation to render math
  symbols properly ([@keaven](https://github.com/keaven),
  [\#118](https://github.com/keaven/gsDesign/issues/118)).

## gsDesign 3.6.0 (November 2023)

CRAN release: 2023-11-12

### Breaking changes

- [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
  [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) have
  updated default values for `T` and `minfup` so that function calls
  with no arguments will run. Legacy code with `T` or `minfup` not
  explicitly specified could break
  ([\#105](https://github.com/keaven/gsDesign/issues/105)).

### New features

- [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
  function added to enable group sequential design for time-to-event
  outcomes using calendar timing of interim analysis specification
  ([\#105](https://github.com/keaven/gsDesign/issues/105)).
- [`as_rtf()`](https://keaven.github.io/gsDesign/reference/as_rtf.md)
  method for
  [`gsBinomialExact()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  objects added, enable RTF table outputs for standard word processing
  software ([\#102](https://github.com/keaven/gsDesign/issues/102)).

### Improvements

- [`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md)
  and
  [`gsBinomialExact()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md):
  fix error checking in bound computations, improve documentation and
  error messages
  ([\#105](https://github.com/keaven/gsDesign/issues/105)).
- [`print.gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md):
  Improve the display of targeted events (very minor). The boundary
  crossing probability computations did not change. The need is made
  evident by the addition of the
  [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  function ([\#105](https://github.com/keaven/gsDesign/issues/105)).
- [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md):
  Fix the documentation and execution based on the `ratio` argument
  ([\#105](https://github.com/keaven/gsDesign/issues/105)).
- Update the vaccine efficacy, Poisson mixture model, and toInteger
  vignettes ([\#105](https://github.com/keaven/gsDesign/issues/105)).
- Standardize and improve roxygen2 documentation
  ([\#104](https://github.com/keaven/gsDesign/issues/104)).

## gsDesign 3.5.0 (July 2023)

CRAN release: 2023-07-19

- [`sfPower()`](https://keaven.github.io/gsDesign/reference/sfPower.md)
  now allows a wider parameter range (0, 15\].
- [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  function added to convert `gsDesign` or `gsSurv` classes to integer
  sample size and event counts.
- [`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md)
  function added to convert time-to-event bounds to exact binomial for
  low event rate studies.
- Added “A Gentle Introduction to Group Sequential Design” vignette for
  an introduction to asymptotics for group sequential design.
- [`as_table()`](https://keaven.github.io/gsDesign/reference/as_table.md)
  and [`as_gt()`](https://keaven.github.io/gsDesign/reference/as_gt.md)
  methods for `gsBinomialExact` objects added, as described in the new
  “Binomial SPRT” vignette.
- In
  [`plot.ssrCP()`](https://keaven.github.io/gsDesign/reference/ssrCP.md),
  the `hat` syntax in the mathematical expression is revised, resolving
  labeling issues.
- [`ggplot2::qplot()`](https://ggplot2.tidyverse.org/reference/qplot.html)
  usage replaced due to its deprecation in ggplot2 3.4.0.
- Link update for the gsDesign manual in the documentation, now directly
  pointing to the gsDesign technical manual bookdown project.
- Introduced a new hex sticker logo.

## gsDesign 3.4.0 (October 2022)

CRAN release: 2022-10-12

- Removed restriction on
  [`gsCP()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  interim test statistic zi
  ([\#63](https://github.com/keaven/gsDesign/issues/63)).
- Removed gMCP dependency. Updated vignettes and linked to vignettes in
  gMCPLite ([\#69](https://github.com/keaven/gsDesign/issues/69)).
- Added deprecation warning to `hGraph()` and suggested using
  `gMCPLite::hGraph()` instead
  ([\#70](https://github.com/keaven/gsDesign/issues/70)).
- Moved ggplot2 from `Depends` to `Imports`
  ([\#56](https://github.com/keaven/gsDesign/issues/56)).

## gsDesign 3.3.0 (May 2022)

CRAN release: 2022-05-27

- Addition of vignettes
  - Demonstrate cure model and calendar-based analysis timing for
    time-to-event endpoint design
  - Vaccine efficacy design using spending bounds and exact binomial
    boundary crossing probabilities
- Minor fix to labeling in print.gsProbability
- Fixed error in sfStep
- Updates to reduce R CMD check and other minor issues

## gsDesign 3.2.2 (January 2022)

CRAN release: 2022-02-02

- Use [`inherits()`](https://rdrr.io/r/base/class.html) instead of
  `is()` to determine if an object is an instance of a class, when
  appropriate
- Correctly close graphics device in unit tests to avoid plot output
  file not found issues
- Minor fixes to hGraph() for multiplicity graphs
- Minor fix to nBinomial() when odds-ratio scale specified to resolve
  user issue
- Minor changes to vignettes

## gsDesign 3.2.1 (July 2021)

CRAN release: 2021-07-12

- Changed gt package usage in a vignette due to deprecated gt function
- Replied to minor comments from CRAN reviewer (no functionality impact)
- Minor update to DESCRIPTION citing Jennison and Turnbull reference

## gsDesign 3.2.0 (January 2021)

CRAN release: 2021-03-13

- Substantially updated unit testing to increase code coverage above 80%
- Updated error checking messages to print function where check fails
- Removed dependencies on plyr packages
- Updated github actions

## gsDesign 3.1.1 (May 2020)

CRAN release: 2020-05-07

- Vignettes updated
- Added `hGraph()` to support ggplot2 versions of multiplicity graphs
- Eliminated unnecessary check from `sequentialPValue`
- Targeted release to CRAN
- Removed dependencies on reshape2, plyr
- Updated continuous integration
- Updated license

## gsDesign 3.1.0 (April 2019)

- Addition of pkgdown web site
- Updated unit testing to from RUnit to testthat
- Converted to roxygen2 generation of help files
- Converted vignettes to R Markdown
- Added Travis-CI and Appveyor support
- Added `sequentialPValue` function
- Backwards compatible addition of spending time capabilities to
  `gsDesign` and `gsSurv`

## gsDesign 3.0-5 (January 2018)

- Registered C routines
- Fixed “gsbound”
- Replaced “array” by “rep” calls to avoid `R CMD check` warnings

## gsDesign 3.0-4 (September 2017)

- First Github-based release
- Cleaned up documentation for
  [`nBinomial1Sample()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
- Updated documentation and code (including one default value for an
  argument) for
  [`nBinomial1Sample()`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
  to improve error handling and clarity
- Updated
  [`sfLDOF()`](https://keaven.github.io/gsDesign/reference/sfLDOF.md) to
  generalize with rho parameter; still backwards compatible for
  Lan-DeMets O’Brien-Fleming

## gsDesign 3.0-3

- Introduced spending time as a separate concept from information time
  to enable concepts such as calendar-based spending functions. The only
  user function changed is the
  [`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
  function and the change is the addition of the parameters `usTime` and
  `lsTime`; default behavior is backwards compatible.

## gsDesign 3.0-2 (February 2016)

- Simplified conditional power section of gsDesignManual.pdf in doc
  directory
- Corrected basic calculation in
  [`gsCP()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
- Eliminated deprecated ggplot2 function `opts()`

## gsDesign 3.0-1 (January 2016)

CRAN release: 2016-02-01

- More changes to comply with R standards (in NAMESPACE - `importFrom`
  statements - and DESCRIPTION - adding plyr to imports) ensuring
  appropriate references.
- Deleted link in documentation that no longer exists
  (gsBinomialExact.Rd).
- Last planned RForge-based release; moving to Github.

## gsDesign 3.0-0 (December 2015)

- Updated xtable extension to meet R standards for extensions.
- Fixed `xtable.gsSurv` and `print.gsSurv` to work with 1-sided designs
- Update to calls to ggplot to replace show_guide (deprecated) with
  `show.legend` arguments where used in
  [`ggplot2::geom_text`](https://ggplot2.tidyverse.org/reference/geom_text.html)
  calls; no user impact
- Minor typo fixed in `sfLogistic` help file
- Cleaned up “imports” and “depends” in an effort to be an R “good
  citizen”
- Registered S3 methods in NAMESPACE

## gsDesign 2.9-4

- Minor edit to package description to comply with R standards

## gsDesign 2.9-3 (November 2014)

CRAN release: 2014-11-10

- Added `sfTrimmed` as likely preferred spending function approach to
  skipping early or all interim efficacy analyses; this also can adjust
  bound when final analysis is performed with less than maximum planned
  information. Updated
  [`help(sfTrimmed)`](https://keaven.github.io/gsDesign/reference/sfSpecial.md)
  to demonstrate these capabilities.
- Added `sfGapped`, which is primarily intended to eliminate futility
  analyses later in a study; see
  [`help(sfGapped)`](https://keaven.github.io/gsDesign/reference/sfSpecial.md)
  for an example
- Added
  [`summary.spendfn()`](https://keaven.github.io/gsDesign/reference/spendingFunction.md)
  to provide textual summary of spending functions; this simplified the
  print function for gsDesign objects
- Added
  [`sfStep()`](https://keaven.github.io/gsDesign/reference/sfLinear.md)
  which can be used to set an interim spend when the exact amount of
  information is unknown; an example of how this can be misused is
  provided in the help file
- Fixed rounding so that `gsBoundSummary`, `xtable.gsSurv` and
  `summary.gsDesign` are consistent for `gsSurv` objects
