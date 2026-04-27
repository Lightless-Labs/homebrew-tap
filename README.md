# Lightless Labs Homebrew tap

Homebrew formulae for Lightless Labs tools.

## Install middens

```bash
brew install lightless-labs/tap/middens
```

`middens` is currently published for Apple Silicon macOS, x86_64 Linux, and arm64 Linux.
Intel macOS is not in the initial binary matrix because the free public `macos-13` runner spent its afternoon cosplaying a black hole.

The formula recommends [`uv`](https://docs.astral.sh/uv/) for Python-backed analysis techniques, but does not require it. Without `uv`, `middens` can still run Rust-only workflows.
