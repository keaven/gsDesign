# gsDesign 3.6.4 (July, 2024)

## Improvements

We have made the spending function summary output more readable and informative.

- Text summaries for spending functions with multiple parameters are now
  properly formatted. For instance, `a b = 0.5 1.5` is now displayed as
  `a = 0.5, b = 1.5` (@jdblischak, #162).
- The `summary()` method for `sfLDOF()` no longer includes the redundant
  `none = 1` in its output (@jdblischak, #159).

## Documentation

- Added a note about using a positive scalar for `sfupar` in `sfLDOF()`
  to create a generalized O'Brien-Fleming spending function
  (@keaven, [52cc711](https://github.com/keaven/gsDesign/commit/52cc711),
  [99996b](https://github.com/keaven/gsDesign/commit/99996b)).
- Improved math rendering in our pkgdown site vignettes by switching to KaTeX,
  which is now supported in pkgdown 2.1.0 (@nanxstats, #161).
- Standardized vignette titles and headings by using h2 as the base level
  and adopting sentence case throughout (@nanxstats, #158).

# gsDesign 3.6.3 (July, 2024)

## New features

- Implemented conditional error spending functions `sfXG1()`, `sfXG2()`,
  and `sfXG3()` based on Xi and Gallo (2019).
  See `vignette("ConditionalErrorSpending")` for details and reproduced
  examples from the literature (@keaven, #147. Thanks, @xidongdxi,
  for comments on vignette).

## Improvements

- Enhanced `eEvents()` with input validation to ensure `lambda` is not `NULL`
  (@keaven, [97f629d](https://github.com/keaven/gsDesign/commit/97f629d)).

## Testing

- Added independent testing for `gsSurvCalendar()` (@myeongjong, #144).
- Expanded test coverage for `gsBinomialExact()` (@menglu2, #143).

# gsDesign 3.6.2 (April, 2024)

## Documentation

- Add new vignette on conditional power and conditional error,
  see `vignette("ConditionalPowerPlot")`
  ([beb2957](https://github.com/keaven/gsDesign/commit/beb2957),
  [727fe20](https://github.com/keaven/gsDesign/commit/727fe20),
  [57394fe](https://github.com/keaven/gsDesign/commit/57394fe)).
- Fix roxygen2 warning and use magrittr pipes in vignette for consistency (#131).

## Testing

- Move independently programmed functions for validation as
  standard test helper files (#130).

# gsDesign 3.6.1 (February, 2024)

## New features

- `gsBoundSummary()` now has the `as_rtf()` method implemented to generate
  RTF outputs for bound summary tables (@wangben718, #107).
- `plotgsPower()` gets new arguments `offset` and `titleAnalysisLegend`
  to enable more flexible and accurate power plots (`plottype = 2`)
  (@jdblischak, #121, #123).

## Improvements

- The plotting functions now use `dplyr::reframe()` to replace
  `dplyr::summarize()` when performing grouped `cumsum()` (@jdblischak, #114).
- The plotting functions are updated to use the `.data` pronoun from rlang
  with `ggplot2::aes()`. This simplifies the code and follows the
  recommended practice when using ggplot2 in packages (@jdblischak, #124).
- `hGraph()` now uses named `guide` argument in the `scale_fill_manual()` call
  to be compatible with ggplot2 3.5.0 (@teunbrand, #115).
  **Note**: this function has been deprecated and moved to gMCPLite
  since gsDesign 3.4.0. It will be removed from gsDesign in a future version.
  Please use `gMCPLite::hGraph()` instead.

## Documentation

- `vignettes("SurvivalOverview")` is updated with more details and
  minor corrections (@keaven, #126).
- Fix equation syntax in plotting function documentation to render
  math symbols properly (@keaven, #118).

# gsDesign 3.6.0 (November, 2023)

## Breaking changes

- `gsSurv()` and `nSurv()` have updated default values for `T` and `minfup`
  so that function calls with no arguments will run. Legacy code with `T`
  or `minfup` not explicitly specified could break (#105).

## New features

- `gsSurvCalendar()` function added to enable group sequential design for
  time-to-event outcomes using calendar timing of interim analysis
  specification (#105).
- `as_rtf()` method for `gsBinomialExact()` objects added,
  enable RTF table outputs for standard word processing software (#102).

## Improvements

- `toBinomialExact()` and `gsBinomialExact()`: fix error checking in bound
  computations, improve documentation and error messages (#105).
- `print.gsSurv()`: Improve the display of targeted events (very minor).
  The boundary crossing probability computations did not change.
  The need is made evident by the addition of the `toInteger()` function (#105).
- `toInteger()`: Fix the documentation and execution based on the `ratio` argument (#105).
- Update the vaccine efficacy, Poisson mixture model, and toInteger vignettes (#105).
- Standardize and improve roxygen2 documentation (#104).

# gsDesign 3.5.0 (July, 2023)

- `sfPower()` now allows a wider parameter range (0, 15].
- `toInteger()` function added to convert `gsDesign` or `gsSurv` classes
  to integer sample size and event counts.
- `toBinomialExact()` function added to convert time-to-event bounds to
  exact binomial for low event rate studies.
- Added "A Gentle Introduction to Group Sequential Design" vignette for
  an introduction to asymptotics for group sequential design.
- `as_table()` and `as_gt()` methods for `gsBinomialExact` objects added,
  as described in the new "Binomial SPRT" vignette.
- In `plot.ssrCP()`, the `hat` syntax in the mathematical expression is revised,
  resolving labeling issues.
- `ggplot2::qplot()` usage replaced due to its deprecation in ggplot2 3.4.0.
- Link update for the gsDesign manual in the documentation,
  now directly pointing to the gsDesign technical manual bookdown project.
- Introduced a new hex sticker logo.

# gsDesign 3.4.0 (October, 2022)

- Removed restriction on `gsCP()` interim test statistic zi (#63).
- Removed gMCP dependency. Updated vignettes and linked to vignettes in gMCPLite (#69).
- Added deprecation warning to `hGraph()` and suggested using `gMCPLite::hGraph()` instead (#70).
- Moved ggplot2 from `Depends` to `Imports` (#56).

# gsDesign 3.3.0 (May, 2022)

- Addition of vignettes
  - Demonstrate cure model and calendar-based analysis timing for time-to-event endpoint design
  - Vaccine efficacy design using spending bounds and exact binomial boundary crossing probabilities
- Minor fix to labeling in print.gsProbability
- Fixed error in sfStep
- Updates to reduce R CMD check and other minor issues

# gsDesign 3.2.2 (January, 2022)

- Use `inherits()` instead of `is()` to determine if an object is an instance of a class, when appropriate
- Correctly close graphics device in unit tests to avoid plot output file not found issues
- Minor fixes to hGraph() for multiplicity graphs
- Minor fix to nBinomial() when odds-ratio scale specified to resolve user issue
- Minor changes to vignettes

# gsDesign 3.2.1 (July, 2021)

- Changed gt package usage in a vignette due to deprecated gt function
- Replied to minor comments from CRAN reviewer (no functionality impact)
- Minor update to DESCRIPTION citing Jennison and Turnbull reference

# gsDesign 3.2.0 (January, 2021)

- Substantially updated unit testing to increase code coverage above 80%
- Updated error checking messages to print function where check fails
- Removed dependencies on plyr packages
- Updated github actions

# gsDesign 3.1.1 (May, 2020)

- Vignettes updated
- Added `hGraph()` to support ggplot2 versions of multiplicity graphs
- Eliminated unnecessary check from `sequentialPValue`
- Targeted release to CRAN
- Removed dependencies on reshape2, plyr
- Updated continuous integration
- Updated license

# gsDesign 3.1.0 (April, 2019)

- Addition of pkgdown web site
- Updated unit testing to from RUnit to testthat
- Converted to roxygen2 generation of help files
- Converted vignettes to R Markdown
- Added Travis-CI and Appveyor support
- Added `sequentialPValue` function
- Backwards compatible addition of spending time capabilities to `gsDesign` and `gsSurv`

# gsDesign 3.0-5 (January, 2018)

- Registered C routines
- Fixed "gsbound"
- Replaced "array" by "rep" calls to avoid `R CMD check` warnings

# gsDesign 3.0-4 (September, 2017)

- First Github-based release
- Cleaned up documentation for `nBinomial1Sample()`
- Updated documentation and code (including one default value for an argument) for `nBinomial1Sample()` to improve error handling and clarity
- Updated `sfLDOF()` to generalize with rho parameter; still backwards compatible for Lan-DeMets O'Brien-Fleming

# gsDesign 3.0-3

- Introduced spending time as a separate concept from information time to enable concepts such as calendar-based spending functions. The only user function changed is the `gsDesign()` function and the change is the addition of the parameters `usTime` and `lsTime`; default behavior is backwards compatible.

# gsDesign 3.0-2 (February, 2016)

- Simplified conditional power section of gsDesignManual.pdf in doc directory
- Corrected basic calculation in `gsCP()`
- Eliminated deprecated ggplot2 function `opts()`

# gsDesign 3.0-1 (January, 2016)

- More changes to comply with R standards (in NAMESPACE - `importFrom` statements - and DESCRIPTION - adding plyr to imports) ensuring appropriate references.
- Deleted link in documentation that no longer exists (gsBinomialExact.Rd).
- Last planned RForge-based release; moving to Github.

# gsDesign 3.0-0 (December, 2015)

- Updated xtable extension to meet R standards for extensions.
- Fixed `xtable.gsSurv` and `print.gsSurv` to work with 1-sided designs
- Update to calls to ggplot to replace show_guide (deprecated) with `show.legend` arguments where used in `ggplot2::geom_text` calls; no user impact
- Minor typo fixed in `sfLogistic` help file
- Cleaned up "imports" and "depends" in an effort to be an R "good citizen"
- Registered S3 methods in NAMESPACE

# gsDesign 2.9-4

- Minor edit to package description to comply with R standards

# gsDesign 2.9-3 (November, 2014)

- Added `sfTrimmed` as likely preferred spending function approach to skipping early or all interim efficacy analyses; this also can adjust bound when final analysis is performed with less than maximum planned information. Updated `help(sfTrimmed)` to demonstrate these capabilities.
- Added `sfGapped`, which is primarily intended to eliminate futility analyses later in a study; see `help(sfGapped)` for an example
- Added `summary.spendfn()` to provide textual summary of spending functions; this simplified the print function for gsDesign objects
- Added `sfStep()` which can be used to set an interim spend when the exact amount of information is unknown; an example of how this can be misused is provided in the help file
- Fixed rounding so that `gsBoundSummary`, `xtable.gsSurv` and `summary.gsDesign` are consistent for `gsSurv` objects
