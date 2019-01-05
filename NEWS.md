3.0-1, January, 2016
- More changes to comply with R standards (in NAMESPACE - importFrom statements - and DESCRIPTION - adding plyr to imports) ensuring appropriate references.
- Deleted link in documentation that no longer exists (gsBinomialExact.Rd).


3.0-0, December, 2015
- Updated xtable extension to meet R standards for extensions. 
- Fixed xtable.gsSurv and print.gsSurv to work with 1-sided designs
- Update to calls to ggplot to replace show_guide (deprecated) with show.legend arguments where used in geom_text (function from ggplot2 package) calls; no user impact
- Minor typo fixed in sfLogistic help file
- Cleaned up "imports" and "depends" in an effort to be an R "good citizen"
- Registered S3 methods in NAMESPACE

2.9-4
- Minor edit to package description to comply with R standards

2.9-3, November, 2014
- Added sfTrimmed as likely preferred spending function approach to skipping early or all interim efficacy analyses; this also can adjust bound when final analysis is performed with less than maximum planned information. Updated help(sfTrimmed) to demonstrate these capabilities.
- Added sfGapped, which is primarily intended to eliminate futility analyses later in a study; see help(sfGapped) for an example
- Added summary.spendfn to provide textual summary of spending functions; this simplified the print function for gsDesign objects
- Added sfStep which can be used to set an interim spend when the exact amount of information is unknown; an example of how this can be misused is provided in the help file.
- Fixed rounding so that gsBoundSummary, xtable.gsSurv and summary.gsDesign are consistent for gsSurv objects
