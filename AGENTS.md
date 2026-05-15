# gsDesign Agent Instructions

Use these instructions when working in the `keaven/gsDesign` R package.

## Repository Workflow

- Check `git status --short --branch` before edits, staging, committing, or pulling.
- Preserve unrelated user changes. Do not revert generated or user-edited files unless asked.
- Prefer `rg` for code searches.
- When an issue branch starts with a number, infer the likely GitHub issue from that number, but verify exact issue metadata when needed.

## gsDesign Function Selection

- If a request specifies analyses by calendar dates or months from trial start or enrollment opening, use `gsSurvCalendar(calendarTime = ...)`.
  Example: "add an interim analysis 24 months after enrollment opens" means include `24` in `calendarTime`.
- When changing only analysis timing, preserve the original design specifications unless the user asks to change them.
- Use `gsSurv()` when timing is event-driven or specified by information fractions rather than fixed calendar times.
- Very low planned event counts, such as fewer than 100 total events, can be a cue to discuss exact-binomial rare-event methods, but do not switch solely because counts are low.
- Use `simBinomialSeasonalExact()` and `toBinomialExact()` when the endpoint/workflow is seasonal rare-event exact-binomial monitoring; otherwise keep the appropriate survival design function.
- Set `ratio` explicitly when randomization is specified; `ratio = 1` means equal experimental:control randomization.

## Version And NEWS

- For development work after a release, bump `DESCRIPTION` to the next `.900x` version.
  Example: `3.9.1` becomes `3.9.1.9000`; if already `.9000`, increment to `.9001`.
- Add concise entries to the top `# gsDesign (development version)` section of `NEWS.md`.
- Use the existing headings such as `## Bug fixes`, `## Documentation`, and `## Testing`.
- Include the issue number when known, for example `(#264)`.

## Testing

- Run focused `testthat::test_file()` checks for touched areas before broad tests.
- Before release-style commits, run:

```r
pkgload::load_all(".")
testthat::test_dir("tests/testthat")
```

- Full test runs may delete RTF snapshots under `tests/testthat/_snaps/independent-test-as_rtf/`. Restore unintended snapshot deletions before committing.
- Run `git diff --check` before staging or committing.
- When changing `DESCRIPTION`, verify:

```r
pkgload::load_all(".")
as.character(utils::packageVersion("gsDesign"))
```

## pkgdown

- Rebuild local pkgdown with:

```r
pkgdown::build_site()
```

- pkgdown writes to `docs/`, which is ignored in this checkout. Do not expect generated site files in `git status` unless ignore rules change.

## Commit And Push

- Stage only intentional source, documentation, tests, NEWS, and version changes.
- Use concise issue-focused commit messages.
- Push the current branch explicitly with `git push origin <branch-name>`.
