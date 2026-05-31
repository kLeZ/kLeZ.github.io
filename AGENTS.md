# AGENTS.md

> Operating guide for AI agents (and humans) working in this repository.
> Read this together with [`CONTEXT.md`](CONTEXT.md), which explains the
> project architecture, branch model, and toolchain.
>
> Task-specific companions: [`AUTHORING.md`](AUTHORING.md) (writing posts),
> [`ACCESS-FILES.md`](ACCESS-FILES.md) (robots/sitemap/security.txt/llms.txt &
> friends), [`SPEC-AUDIT.md`](SPEC-AUDIT.md) (standards-compliance audit).

## Maintenance contract (MANDATORY)

**For ANY change of ANY kind** — a feature, a bug fix, a refactor, a content
edit, a tooling/config tweak, a dependency bump, or a change of context — you
**MUST** update:

1. This file (`AGENTS.md`) — if workflow, commands, or conventions change.
2. [`CONTEXT.md`](CONTEXT.md) — if architecture, layout, toolchain, or context
   changes.
3. **Every other relevant document** (e.g. `README.md`, inline docs, comments).

This is not optional. Treat the docs as part of the change: a change is "done"
only when the documentation that describes it is true again. If a change makes
any statement in these files inaccurate, fix the statement in the same commit.
Write these files in **English** and keep them human-readable.

## Golden rules

- **Develop on `dev`** (or a branch based on `dev`). `dev` holds the source.
- **Never edit or target `master`.** It is the machine-generated deploy output.
  Pull requests MUST use `base: dev`.
- **Never commit build artifacts.** `_site/`, `vendor/`, `.bundle/`,
  `.jekyll-cache/`, etc. are git-ignored — keep them that way.
- **Keep `Gemfile.lock` stable.** Don't let an incidental `bundle install`
  bump locked versions; revert unintended lockfile drift before committing.
- Match the surrounding style of files you touch.

## Environment setup

Requirements: Ruby `3.2.x` (NOT 3.3+, see CONTEXT.md), Bundler, Node.js,
Python 3, and a **UTF-8 locale**.

```bash
git submodule update --init --recursive   # premonition + SgEExt plugins
bundle config set --local path vendor/bundle
bundle install
export LANG=C.UTF-8 LC_ALL=C.UTF-8         # required for html-proofer/Nokogiri
```

On **Claude Code on the web**, the SessionStart hook
(`.claude/hooks/session-start.sh`) does all of the above automatically:
it pins Ruby 3.2.6 via rbenv, sets the UTF-8 locale, initializes submodules,
runs `bundle install`, and persists `RBENV_VERSION`/`LANG`/`LC_ALL` for the
session. It only runs when `CLAUDE_CODE_REMOTE=true`. If you change the build,
dependencies, or required env, **update that hook too**.

## Common commands

All commands assume the environment above (UTF-8 locale + Ruby 3.2.x).

| Task                 | Command                                                  |
| -------------------- | -------------------------------------------------------- |
| Lint / sanity check  | `bundle exec jekyll doctor`                              |
| Build (CI-style)     | `CI=true ./_scripts/build`                               |
| Build (plain)        | `bundle exec jekyll build`                               |
| Test (links/assets)  | `bundle exec htmlproofer ./_site --disable-external`     |
| Serve locally        | `bash ./_scripts/serve`  (livereload + drafts)           |
| New draft            | `bash ./_scripts/draft "My Post Title"`                  |
| Publish drafts       | `bash ./_scripts/publish`                                |
| Regenerate emojis    | `bash ./_scripts/emojis`                                 |

Notes on `_scripts/`:
- `build` — runs `jekyll doctor`, then builds. In CI (`CI=true`) it writes
  `_data/ci-status.yml` and runs `jekyll build`; otherwise it publishes drafts,
  regenerates emojis, builds with `--drafts --trace`. It finishes with
  `htmlproofer ./_site --disable-external`.
- `draft` — scaffolds `_drafts/<slug>.md.draft` from `_templates/post.md`.
- `publish` — promotes `_drafts/*.draft` into dated `_posts/` entries.
- `emojis` — extracts emoji shortcodes from posts into `assets/img/emoji/`
  (Python 3 + the SgEExt submodule).

## Validating a change before pushing

At minimum run the lint + build + test trio and confirm `htmlproofer` actually
checks a non-zero number of links (if it reports "0 internal links", your
locale is not UTF-8):

```bash
bundle exec jekyll doctor \
  && bundle exec jekyll build \
  && bundle exec htmlproofer ./_site --disable-external
```

## Git & PR conventions

- Branch off `dev`; push your feature branch; open PRs against `dev`.
- CI runs only on push to `dev`, so PRs won't show project CI status — verify
  locally instead (see above).
- Don't open a PR unless asked. Don't push to branches you weren't asked to.
