# A history of gsDesign

## A continuing purpose

gsDesign brings group sequential methods into an open, programmable
environment for clinical trial design. Its central purpose is not just
to calculate a set of stopping boundaries, but to help statisticians
understand the resulting trial: its power, error spending, expected and
maximum sample size, and the treatment effects and conditional power
associated with its boundaries. That purpose connects the early package
to its more recent survival, exact binomial, and monitoring tools.

This account follows selected developments rather than every release. It
draws on Keaven Anderson’s recollections, the package’s recorded
acknowledgments, release notes, and source history. It is also an
invitation to add the recollections that those records cannot capture.
The history is recorded through September 2026; features identified as
development work should not be assumed to be in an installed CRAN
release.

## Foundations and the early package

The computational history predates the R package. Keaven wrote the
original C code in **1999**, based on the numerical integration routines
described in Jennison and Turnbull’s *Group Sequential Methods with
Applications to Clinical Trials* (Jennison and Turnbull 2000), published
in 2000. Those routines supported multiple methodological papers before
becoming the computational foundation of this initial gsDesign R package
in 2006/2007. The package combines R interfaces with compiled routines
for boundary crossing probabilities and boundary construction, so the
same calculations can support both familiar designs and new ways of
specifying them.

One example is Anderson’s *Optimal Spending Functions for Asymmetric
Group Sequential Designs* (Anderson 2007). Published in **2007**, with a
manuscript received in **2005**, it compared optimized spending function
designs with designs not restricted to a spending function family. The
paper minimized expected sample size, or its square, averaged over a
prior distribution while retaining specified Type I and Type II error
rates. This illustrates an early use of the numerical routines to go
beyond deriving a standard boundary and instead ask which design best
serves a stated objective.

An important organizing idea is error spending. Lan and DeMets (Lan and
DeMets 1983) provided a way to specify cumulative error expenditure as
information accumulates, rather than fixing a boundary only for a single
predetermined analysis schedule. In gsDesign, alpha- and beta-spending
help separate a monitoring policy from its boundaries at particular
analyses. They allow the design to be evaluated at revised information
times, subject to the assumptions of the sequential procedure. This is
flexibility in implementation, not permission for unrestricted
outcome-dependent changes to the design.

This separation also clarifies the idea of **spending time**.
Information-based correlations are still used to define the joint
multivariate normal calculations for boundary crossing, while the error
spending rule itself need not be directly tied to statistical
information. Lan and DeMets illustrated this distinction with
calendar-based spending (Lan and DeMets 1983). The broader spending time
concept has since been used in many trials and is the subject of a
forthcoming publication.

A common application bases spending at each interim analysis on the
minimum of planned and actual information. When minimum follow-up,
accrual, or dropout means that an analysis requires more events than
originally planned, this cap prevents the earlier analysis from spending
alpha as though all of that extra information had been scheduled in
advance. It retains adequate alpha-spending for the final analysis while
still allowing the interim calculation to use the information actually
observed.

Keaven Anderson has led the package’s statistical development and
maintenance. The README credits Bill Constantine and Rich Calaway, then
at Revolution Computing, with substantial early development, testing,
and documentation help. These contributions established that
documentation and checking were part of the software, not additions to
it. [Source: recorded
acknowledgments](https://github.com/keaven/gsDesign/blob/277d2361eecfe477629bda0a35bb8b6c6fd0fa44/README.md#a-little-history).

The surviving repository contains gsDesign material from September 2008;
for example, a [manual was added on September
1](https://github.com/keaven/gsDesign/commit/2013facd). The [CRAN source
archive](https://cran.r-project.org/src/contrib/Archive/gsDesign/)
currently starts with version 2.0-5, dated July 1, 2009. Neither the
earliest surviving archive file nor a repository timestamp alone
establishes the first public release date. In particular, the
repository’s 2007 initial commit is an R-Forge template, not evidence of
a gsDesign release in that year.

## Selected milestones

The version labels and descriptions below follow the package release
notes in `NEWS.md`. Release note dates describe the recorded development
history; they are not necessarily identical to the dates of CRAN
publication.

| Period / version | Development | Why it mattered |
|:---|:---|:---|
| 1999 | Original C integration routines written by Anderson | A computational foundation for methodological research and the later R package. |
| 2007 | Optimal spending function paper, submitted in 2005 | Established numerical calculations used to compare and optimize asymmetric designs. |
| 2008–2009 | Early repository material and archived CRAN packages | A durable public record of the software and its documentation. |
| 2012 / 2.7 series | Introduction of [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) | Lachin-Foulkes survival sample size calculations connected to group sequential design, enrollment, dropout, and follow-up. |
| 2014 / 2.9-3 | Trimmed, gapped, and step spending tools | More control over when monitoring is active and how spending is specified. |
| 2017 / 3.0-4 | First GitHub-based release | A transition from the earlier R-Forge workflow. |
| 2019 / 3.1.0 | testthat, roxygen2, R Markdown, and pkgdown | Tests, help, examples, and a website became a more integrated development workflow. |
| 2020–2021 / 3.1.1–3.2.0 | Continuous integration and expanded tests | More systematic checking, with reported coverage above 80% in 3.2.0. |
| 2022–2023 / 3.3.0–3.6.0 | Vaccine efficacy examples, exact binomial conversion, integer conversion, and calendar-time survival designs | More direct connections between statistical designs and trial implementation. |
| 2026 / 3.9.0 | Schoenfeld and Freedman survival sample size options | Easier comparisons with other software while retaining the Lachin-Foulkes default. |
| 2026 / 3.10.0–3.11.0 and subsequent development | Survival scenario evaluation, selective monitoring, harm bounds, and target-based spending calibration | A broader set of design questions built on established computational tools. |

## Making the software easier to maintain and use

The late 2018 and early 2019 modernization was enabled in large part by
Devin Pastoor, Harsh Baid, and Jonathan Sidi at Metrum Research Group.
Version 3.1.0 replaced RUnit testing with testthat, converted help
generation to roxygen2 and vignettes to R Markdown, and added the
pkgdown website. It also added
[`sequentialPValue()`](https://keaven.github.io/gsDesign/reference/sequentiaPValue.md)
and extended spending time capabilities. The changes made worked
examples, testing, and reference documentation easier to maintain
together.

Yilong Zhang contributed the GitHub continuous integration work for
version 3.1.1. Collaboration with Cytel during 2020 expanded the test
suite; the 3.2.0 release notes report coverage above 80%. Coverage is
evidence about which code was exercised, not proof of statistical
correctness. Independent calculations, regression tests, and examination
of design properties remain important complements. [Sources:
acknowledgments](https://github.com/keaven/gsDesign/blob/277d2361eecfe477629bda0a35bb8b6c6fd0fa44/README.md#a-little-history)
and [release
notes](https://github.com/keaven/gsDesign/blob/277d2361eecfe477629bda0a35bb8b6c6fd0fa44/NEWS.md).

Access has also expanded beyond writing R code directly. Anderson
developed the original Shiny interface in extensive collaboration with
John Lueders. Nan Xiao subsequently undertook the interface remake, and
Yihui Xie has made ongoing improvements. This work supports interactive
exploration, saving and reloading designs, and generating reproducible R
code and R Markdown reports. The evolving interface is available as
[gsDesign Explorer](https://rinpharma.shinyapps.io/gsdesign/). The link
points to the maintained application rather than a frozen copy of the
original interface.

The associated book, [*Group Sequential Design in R: A Practical Guide
to the gsDesign Web Interface*](https://keaven.github.io/gsd-shiny/), by
Anderson and Nan Xiao, connects interactive design exploration to the
underlying methods. The complementary [*gsDesign Technical
Manual*](https://keaven.github.io/gsd-tech-manual/) provides a more
detailed account of the package and its calculations.

The people named here are not an exhaustive list. Contributions include
statistical suggestions, bug reports, testing, documentation, interface
work, and maintenance as R and its dependencies change. The [contributor
history](https://github.com/keaven/gsDesign/graphs/contributors) and
individual issues and pull requests provide additional attribution;
commit counts alone do not measure the value of those contributions.

## From statistical information to a trial that can be run

Time-to-event sample size was a major extension of the package. The
[`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
routines were introduced in the **2.7 series in 2012**: the [May 24,
2012 source
addition](https://github.com/keaven/gsDesign/commit/f01001f40807c8c5d65f11133340726398f2d00c)
includes their implementation and documentation describing them as new
in version 2.7.
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
connected the survival sample size calculations in
[`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) to the
group sequential calculations in
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).
This brought enrollment, dropout, calendar time, follow-up, and
stratification into an integrated survival design workflow.

The Lachin-Foulkes framework (Lachin and Foulkes 1986) remains the
default for these sample size calculations. Its implementation is a
distinctive capability of gsDesign, not generally offered by other
survival design packages. This made direct software comparisons
difficult when the other software used a different sample size
approximation. A key **2026 addition, in version 3.9.0**, was therefore
the **Schoenfeld** option: users can select the same method in
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
other software, making comparisons easier to interpret. The less used
**Freedman** method was enabled as well, alongside Bernstein-Lagakos.
Lachin-Foulkes remains the default; the alternatives facilitate
comparisons rather than replace it. The technical manual illustrates
[comparisons with
rpact](https://keaven.github.io/gsd-tech-manual/validate-rpact.html),
which offers Schoenfeld and Freedman but not the gsDesign Lachin-Foulkes
method.

The 2023 releases added
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md),
[`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md),
and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md).
These address different implementation questions: rounding sample sizes
and events, constructing exact event count boundaries for low event rate
studies, and scheduling survival analyses in calendar time. The exact
binomial method with spending was motivated by a user request and is now
available for vaccine and prevention studies. This is a separate
probability model with its own assumptions, not simply a cosmetic
relabeling of a normal boundary; exact boundary crossing calculations
retain the discreteness of the event counts.

In 2026,
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
made evaluation of a specified trial under alternative assumptions more
explicit. Selective efficacy, futility, and harm monitoring expanded the
possible schedules. Subsequent development refined exact conversion and
follow-up calculations, including the distinction between computing
median follow-up at a cutoff and finding a cutoff that achieves a
target. These developments share a practical theme: distinguish the
original design assumptions from what is held fixed when evaluating
another scenario. See the survival overview
([`vignette("SurvivalOverview")`](https://keaven.github.io/gsDesign/articles/SurvivalOverview.md))
and enrollment planning examples
([`vignette("SurvivalEnrollmentPlanning")`](https://keaven.github.io/gsDesign/articles/SurvivalEnrollmentPlanning.md)).

## A growing family of packages

The [gsDesign2 package](https://merck.github.io/gsDesign2/) has been
available for several years, with GitHub releases recorded in 2022. It
extends trial design to settings where treatment effects may vary over
time or across strata, including delayed benefit and other departures
from proportional hazards. Its survival specifications allow stratified
enrollment, event, and dropout assumptions, so non-constant effects can
be considered when deriving and evaluating efficacy and futility bounds.
See its [release
history](https://merck.github.io/gsDesign2/news/index.html) and
[methodological vignettes](https://merck.github.io/gsDesign2/articles/).

The largely AI-developed [gsDesignNB
package](https://keaven.github.io/gsDesignNB/) adds designs for
**recurrent events with negative binomial outcomes** to the family. It
provides sample size, simulation, and interim monitoring tools for event
rates, drawing on gsDesign for spending function and boundary
calculations. Anderson describes its development as another example of
using AI to build on established computational tools. The related
packages extend the range of models and trial questions rather than
requiring every endpoint to be handled by the same design function.

## New questions, established calculations

Recent development allows a statistician to start with an interpretable
interim target and solve for spending function parameters. Examples
include conditional power, posterior predictive power, and approximate
treatment effects at bounds. The result is still a spending function,
with its associated flexibility when the information schedule changes.
It must still be assessed as a complete design, including overall power,
error probabilities, sample size, and effect sizes at the boundaries. A
target achieved at the planned interim need not remain numerically
identical at a different interim information fraction.

The conditional power spending vignette
([`vignette("CPFutilitySpending")`](https://keaven.github.io/gsDesign/articles/CPFutilitySpending.md)),
Dragalin related methods
([`vignette("DragalinFutilitySpending")`](https://keaven.github.io/gsDesign/articles/DragalinFutilitySpending.md)),
and effect-targeted spending vignette
([`vignette("EffectSpending")`](https://keaven.github.io/gsDesign/articles/EffectSpending.md))
document these development features. They illustrate the value of
separating a new calibration problem from the established probability
calculations used to evaluate its answer.

AI-assisted development has become part of this recent history. Anderson
reports that much of the initial CP/PP spending calibration work was
developed interactively with GPT-6 Astra High in Codex over a long
weekend. This is an account of that development experience, not a
measured estimate of productivity or a substitute for validation. The
important enabling resource was the accumulated package: existing
numerical routines, design objects, summaries, examples, and tests. New
calibration code could be checked by reconstructing designs and
evaluating them with existing functions. Such checks are especially
valuable, although shared numerical components also make independent
checks and code review important.

The numerical foundation itself has also been revisited. Nan Xiao used
AI and Lean in [research on the integration
algorithms](https://github.com/nanxstats/gsdesign-research), combining
numerical comparisons and performance measurements with Lean 4 / Mathlib
proofs of properties of the guarded Newton update used in boundary
finding.

The research led to internal optimizations and a faster, more accurate
Gauss-Legendre integration alternative in the benchmarked designs. To
preserve the established numerical behavior for existing users, the new
quadrature is **opt-in**, selected with
`options(gsDesign.quadrature = "gl")`; the default remains `"jt"`, the
Jennison-Turnbull grid. Some internal speed improvements have been
adopted while retaining that default method. Keeping the alternative
optional protects continuity for a long-used package without preventing
users from benefiting from the new algorithms. Details are recorded in
[the integration change](https://github.com/keaven/gsDesign/issues/323)
and [the recursion
optimizations](https://github.com/keaven/gsDesign/issues/322).

## A visual record and an open history

A Gource video of the version control history was linked in [the
proposal for this
vignette](https://github.com/keaven/gsDesign/issues/304). It offers
another way to visualize and explore repository activity. A future
update could accompany this account; repository activity should not be
read as a chronology of scientific ideas or a ranking of contributors.

This first account deliberately leaves room for the original motivation,
early collaborations, and practical experiences that are not captured in
release notes. Corrections and additions are welcome through the issue
tracker. For the current interface and complete changelog, use the
function reference and `NEWS.md` rather than this selective history.

## References

Anderson, Keaven M. 2007. “Optimal Spending Functions for Asymmetric
Group Sequential Designs.” *Biometrical Journal* 49 (3): 337–45.

Jennison, Christopher, and Bruce W. Turnbull. 2000. *Group Sequential
Methods with Applications to Clinical Trials*. Chapman; Hall/CRC.

Lachin, John M., and Mary A. Foulkes. 1986. “Evaluation of Sample Size
and Power for Analyses of Survival with Allowance for Nonuniform Patient
Entry, Losses to Follow-up, Noncompliance, and Stratification.”
*Biometrics* 42: 507–19.

Lan, K. K. G., and David L. DeMets. 1983. “Discrete Sequential
Boundaries for Clinical Trials.” *Biometrika* 70: 659–63.
