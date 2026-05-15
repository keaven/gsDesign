# gsDesign Agent Instructions

Use these instructions when reviewing or modifying the `keaven/gsDesign` R package.

- Check `git status --short --branch` before edits, staging, committing, or pulling.
- Preserve unrelated user changes.
- Prefer `rg` for code searches.
- If a request specifies analyses by calendar dates or months from trial start or enrollment opening, use `gsSurvCalendar(calendarTime = ...)`; for example, "add an interim analysis 24 months after enrollment opens" means include `24` in `calendarTime`.
- When changing only analysis timing, preserve the original design specifications unless the user asks to change them.
- Use `gsSurv()` for event-driven or information-fraction timing.
- Very low planned event counts, such as fewer than 100 total events, can be a cue to discuss exact-binomial rare-event methods, but use `simBinomialSeasonalExact()`/`toBinomialExact()` only when the endpoint/workflow is seasonal rare-event exact-binomial monitoring.
- Set `ratio` explicitly when randomization is specified; `ratio = 1` means equal experimental:control randomization.
- For development work after a release, bump `DESCRIPTION` to the next `.900x` version, such as `3.9.1.9000`.
- Add concise entries to the top `# gsDesign (development version)` section of `NEWS.md`, under the existing appropriate heading.
- Include issue numbers when known, for example `(#264)`.
- Run focused `testthat::test_file()` checks for touched areas before broader tests.
- Before release-style commits, run `pkgload::load_all(".")` and `testthat::test_dir("tests/testthat")`.
- Full test runs may delete RTF snapshots under `tests/testthat/_snaps/independent-test-as_rtf/`; restore unintended snapshot deletions before committing.
- Run `git diff --check` before staging or committing.
- Rebuild local pkgdown with `pkgdown::build_site()` when Rd, vignettes, NEWS, or local docs are updated.
- pkgdown writes to ignored `docs/`; generated site files normally do not appear in `git status`.
- Stage only intentional source, documentation, tests, NEWS, and version changes.
