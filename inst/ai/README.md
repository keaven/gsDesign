# gsDesign AI Workflow Instructions

This directory contains coding-agent instruction files for working on
`gsDesign` development tasks.

The installed package path can be found with:

```r
system.file("ai", package = "gsDesign")
```

Suggested uses:

- Copy `AGENTS.md` to a repository root for Codex-style coding agents.
- Copy `CLAUDE.md` to a repository root for Claude Code.
- Copy `GEMINI.md` to a repository root for Gemini CLI.
- Copy `copilot-instructions.md` to `.github/copilot-instructions.md`.
- Copy `gemini-styleguide.md` to `.gemini/styleguide.md`.

These files are not full statistical methods documentation. They are workflow
prompts for coding agents so routine package-development tasks use consistent
testing, NEWS, version, pkgdown, commit, and push practices. They also include
brief function-selection guidance, such as using `gsSurvCalendar()` when a
request specifies analyses at calendar months after enrollment opens, while
preserving the original design specifications unless the user asks to change
them. Very low planned event counts can cue a discussion of exact-binomial
rare-event methods, but should not by itself override a calendar-timed survival
design request.
