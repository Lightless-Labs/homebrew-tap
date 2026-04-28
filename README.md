# Lightless Labs Homebrew tap

Homebrew formulae for Lightless Labs tools.

## middens

[`middens`](https://github.com/Lightless-Labs/third-thoughts/tree/main/middens) is a Rust CLI for analyzing AI coding-agent session logs — basically archaeological fieldwork for Claude Code, Codex, and friends. It parses transcripts, classifies sessions, runs a 23-technique analysis battery, and can export the results as a Jupyter notebook.

It is part of the [Third Thoughts](https://github.com/Lightless-Labs/third-thoughts) research project.

## Install middens

```bash
brew install lightless-labs/tap/middens
```

`middens` is currently published for Apple Silicon macOS, x86_64 Linux, and arm64 Linux.
Intel macOS is not in the initial binary matrix because the free public `macos-13` runner spent its afternoon cosplaying a black hole.

The formula recommends [`uv`](https://docs.astral.sh/uv/) for Python-backed analysis techniques, but does not require it. Without `uv`, `middens` can still run Rust-only workflows.
