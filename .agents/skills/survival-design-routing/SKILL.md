---
name: survival-design-routing
description: Choose the appropriate gsDesign survival or exact-binomial workflow when requests involve calendar-time interim analyses, event- or information-driven survival looks, seasonal rare-event exact-binomial monitoring, or explicit randomization ratios; covers when to use gsSurvCalendar(), gsSurv(), simBinomialSeasonalExact(), and toBinomialExact().
---

# gsDesign survival design routing

- If a request specifies analyses by calendar dates or months from trial start
  or enrollment opening, use `gsSurvCalendar(calendarTime = ...)`.
  Example: "add an interim analysis 24 months after enrollment opens" means
  include `24` in `calendarTime`.
- When changing only analysis timing, preserve the original design
  specifications unless the user asks to change them.
- Use `gsSurv()` when timing is event-driven or specified by information
  fractions rather than fixed calendar times.
- Very low planned event counts, such as fewer than 100 total events, can be
  a cue to discuss exact-binomial rare-event methods, but do not switch
  solely because counts are low.
- Use `simBinomialSeasonalExact()` and `toBinomialExact()` when the
  endpoint/workflow is seasonal rare-event exact-binomial monitoring;
  otherwise keep the appropriate survival design function.
- Set `ratio` explicitly when randomization is specified; `ratio = 1` means
  equal experimental:control randomization.
