# gsDesign Agent Instructions

Use these instructions when reviewing or modifying the `keaven/gsDesign` R package.

- Check `git status --short --branch` before edits, staging, committing, or pulling.
- Preserve unrelated user changes.
- Prefer `rg` for code searches.
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
