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

- **Develop on a short-lived branch off `master`.** `master` is the single
  long-lived branch and holds the source. Pull requests MUST use `base: master`.
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

On **terminal** (vim, nano, etc.), workspace setup is fully automatic:
`.devcontainer/init.sh` runs as Docker ENTRYPOINT after volume mount and handles
submodule init + `bundle install` without any manual steps. Use `make`:
```bash
make build    # first time or after Dockerfile changes (~5-10 min, compiles Ruby)
make shell    # interactive shell
make serve    # Jekyll serve → http://localhost:4000
```

On **VS Code standard**, "Reopen in Container" works out of the box with
`ms-vscode-remote.remote-containers` (Microsoft Marketplace). Zero extra config.

On **VSCodium**, `ms-vscode-remote.remote-containers` fails with 404 (hard-coded
Microsoft CDN URL, incompatible with VSCodium builds, not on Open VSX). Use
`DDorch.codium-devcontainer` + `jeanp413.open-remote-ssh` from Open VSX instead —
both install directly from the VSCodium Extensions sidebar. Fallback: `make up`
(SSH daemon on port 2222) + Remote SSH to `dev@localhost:2222`.

On **Emacs**, run `make up` then open `/docker:klez-me-daemon:/workspace/` via
TRAMP (Emacs 29+ built-in `tramp-container.el`; Emacs <29: install `docker-tramp`
from MELPA). SSH alternative: `/ssh:dev@localhost#2222:/workspace/`.

See CONTEXT.md for full workflow details for each client.

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

- Branch off `master`; push your feature branch; open PRs against `master`.
- CI runs only on push to `master`, so PRs won't show project CI status — verify
  locally instead (see above).
- Don't open a PR unless asked. Don't push to branches you weren't asked to.
