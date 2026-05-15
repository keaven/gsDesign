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

These files are not statistical methods documentation. They are workflow
prompts for coding agents so routine package-development tasks use consistent
testing, NEWS, version, pkgdown, commit, and push practices.
