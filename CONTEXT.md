# CONTEXT.md

> Repository context for both humans and AI agents.
> **MANDATORY:** Any change of any kind — feature, fix, refactor, content,
> tooling, context, or configuration — requires updating this file,
> [`AGENTS.md`](AGENTS.md), and every other relevant document so they stay
> truthful. See the "Maintenance contract" section below.

## What this is

This is the source of **klez.me** — the personal (static) website of
Alessandro "kLeZ" Accardo. It is built with **Jekyll** and continuously
deployed via **GitHub Actions**. The end-to-end flow is fully automated: write
Markdown, push, and the public site updates within minutes.

- Public URL: https://klez.me (see `CNAME`)
- Repo: https://github.com/kLeZ/kLeZ.github.io
- Licensing: GNU GPL v3 for site code, CC-BY-NC-ND 4.0 for content.

## Branch architecture & CI/CD

This repository uses **two long-lived branches with different roles**:

| Branch   | Role                                                                 |
| -------- | -------------------------------------------------------------------- |
| `dev`    | **Source of truth.** Jekyll source, scripts, config, CI definition.  |
| `master` | **Deploy target only.** Contains the built static output (`_site/`). |

CI/CD (`.github/workflows/main.yaml`) is triggered **only on push to `dev`**:

1. **build** job — checks out `dev` (with submodules), sets up Ruby, runs
   `bundle install`, then `./_scripts/build`, and uploads `_site/` as an
   artifact.
2. **deploy** job — checks out `master`, downloads the `_site/` artifact, and
   commits/pushes it back to `master` (the "Deployed new klez.me version"
   commits).

Implications:
- **Develop on `dev`** (or a branch based on it). Pull requests must target
  `dev`, **never `master`**.
- Never hand-edit `master`; it is machine-generated.
- The CI workflow does **not** run on `pull_request` events, only on push to
  `dev`. PRs therefore show no project CI status — that is expected.

## Toolchain

- **Ruby**: project pins `3.2.3` via `.ruby-version`; CI uses `3.2.0`. Any
  Ruby `3.2.x` works. **Ruby `3.3+` does NOT work** with the pinned
  Jekyll 3.9.x (a `logger` API change breaks `jekyll`).
- **Bundler / gems**: declared in `Gemfile`, locked in `Gemfile.lock`
  (`BUNDLED WITH 2.4.10`). Jekyll 3.9.3 + plugins (feed, katex, seo-tag,
  jemoji, tidy, git_metadata, postfiles, ...). `html-proofer` is used for
  link/asset testing.
- **Git submodules** (`.gitmodules`): two Jekyll plugins live as submodules
  under `_plugins/` and MUST be initialized before building:
  - `_plugins/premonition` (https://github.com/kLeZ/premonition.git)
  - `_plugins/SgEExt` (https://github.com/HorlogeSkynet/SgEExt.git)
- **Node.js** is used by some build steps; **Python 3** is used by the emoji
  extractor (`_scripts/emojis` → `SgEExt/sgeext.py`).

### Known gotchas

- **UTF-8 locale required.** `html-proofer` (via Nokogiri) reads pages with the
  process default encoding. Without a UTF-8 locale (`LANG`/`LC_ALL`), pages are
  read as US-ASCII, Nokogiri throws `Encoding::InvalidByteSequenceError`, and
  the proofer silently checks **0 links** while still exiting `0`. Always run
  with `LANG=C.UTF-8 LC_ALL=C.UTF-8` (or another UTF-8 locale).
- **Ruby 3.3+ incompatibility** — see Toolchain above.

## Directory layout (on `dev`)

```
_config.yml        Jekyll configuration (site metadata, plugins, sass, katex...)
_data/             Site data (incl. CI status written during build)
_drafts/           Unpublished drafts (*.draft via _scripts/draft)
_includes/         Liquid partials
_layouts/          Page layouts
_pages/            Standalone pages
_plugins/          Ruby plugins + submodules (premonition, SgEExt)
_posts/            Published blog posts
_sass/             Sass sources (compiled, style: compressed)
_scripts/          Build/dev helper scripts (see AGENTS.md)
_templates/        Templates (e.g. post.md used by _scripts/draft)
_xp/               "xp" collection
apps/ lf/ media/   Content / assets
assets/            Static assets (katex, emoji output, images, reveal.js...)
.github/workflows/ CI/CD (main.yaml)
.claude/           Claude Code config: SessionStart hook + settings
```

## Claude Code on the web

A SessionStart hook (`.claude/hooks/session-start.sh`, registered in
`.claude/settings.json`) prepares the toolchain for remote web sessions: it
pins Ruby 3.2.6 via rbenv, sets a UTF-8 locale, initializes submodules, and
runs `bundle install`. It only runs when `CLAUDE_CODE_REMOTE=true`. See
[`AGENTS.md`](AGENTS.md) for how to work in this environment.

## Maintenance contract

Keeping these docs accurate is **not optional**. Read the rules in
[`AGENTS.md`](AGENTS.md#maintenance-contract-mandatory).
