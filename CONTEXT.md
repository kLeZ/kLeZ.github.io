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
- Site language: **Italian** (`lang: it`, `locale: it_IT` in `_config.yml`).

### Companion docs

- [`AUTHORING.md`](AUTHORING.md) — how to write posts/pages (humans + agents).
- [`ACCESS-FILES.md`](ACCESS-FILES.md) — the anonymously-accessible discovery
  files (`robots.txt`, `sitemap.xml`, `security.txt`, `llms.txt`, manifest, …):
  why they exist and how they're generated/maintained here.
- [`SPEC-AUDIT.md`](SPEC-AUDIT.md) — audit of the live site against
  specification.website's 128-rule checklist (in Italian).

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
  (`BUNDLED WITH 2.4.10`). Jekyll 3.9.3 + plugins (feed, sitemap, katex,
  seo-tag, jemoji, tidy, git_metadata, postfiles, ...). `html-proofer` is used
  for link/asset testing.
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
- **`jekyll-tidy` + seo-tag `image`.** Setting `image:` in front matter makes
  `jekyll-seo-tag` emit JSON-LD that `jekyll-tidy`'s htmlbeautifier rejects
  (`Unmatched sequence`), breaking the build. The default `og:image` is therefore
  added manually in `_includes/head.html`, not via a seo-tag `image` default.
- **Dotfiles aren't published.** Jekyll skips paths starting with `.`, so
  `/.well-known/` is served only because `.well-known` is listed under
  `include:` in `_config.yml`. See [`ACCESS-FILES.md`](ACCESS-FILES.md).

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
.well-known/       Standard discovery files (security.txt); see ACCESS-FILES.md
robots.txt         Crawler policy + sitemap pointer (Liquid-rendered)
llms.txt           Curated index for LLM agents (Liquid-rendered)
manifest.webmanifest  PWA manifest (Liquid-rendered)
favicon.ico        Site favicon (root)
.github/workflows/ CI/CD (main.yaml)
.claude/           Claude Code config: SessionStart hook + settings
.devcontainer/     Dev container config (devcontainer.json + setup.sh)
```

`sitemap.xml` and a minimal fallback `robots.txt` are generated by
`jekyll-sitemap`; `feed.xml` by `jekyll-feed`. Our hand-written `robots.txt`
overrides the generated one. Details in [`ACCESS-FILES.md`](ACCESS-FILES.md).

## Dev container (sviluppo locale)

L'ambiente dev è definito in `.devcontainer/` e supporta tre workflow: terminale,
VSCodium e Emacs (TRAMP). Tutti partono dalla stessa immagine Docker.

### Architettura

- **Immagine base**: `debian:bookworm-slim` — nessuna dipendenza da vendor specifici;
  ciclo di vita lungo e stabile.
- **Ruby**: installato via **rbenv** (system-wide in `/usr/local/rbenv`), stesso tool
  del hook `session-start.sh`. Per migrare versione: cambia `.ruby-version` e
  ricostruisci l'immagine (`make build`).
- **Node.js** e **Python 3**: installati nel Dockerfile (necessari per `execjs` gem
  e `_scripts/emojis`).
- **Bundler 2.4.10**: installato nel Dockerfile, pinned a quanto dichiarato in
  `Gemfile.lock`.
- **Setup automatico** (`ENTRYPOINT`): Docker monta i volumi *prima* di eseguire
  l'ENTRYPOINT. `.devcontainer/init.sh` gira ad ogni avvio e in modo idempotente
  inizializza i submodule e installa i gem (solo se mancanti). Nessun comando
  manuale richiesto.
- **Utente `dev` (UID 1000)**: i file creati nel workspace appartengono all'utente
  host con lo stesso UID (primo utente tipico su Linux).

### Workflow terminale (make / docker compose)

```bash
make build          # build immagine (prima volta, ~5-10 min per compilazione Ruby)
make shell          # shell interattiva nel container (vim, nano, ecc.)
make serve          # Jekyll serve → http://localhost:4000
make draft TITLE="Titolo"   # nuovo draft
make publish        # promuovi draft in _posts/
make help           # lista tutti i target
```

Equivalente senza Make:
```bash
docker compose build
docker compose run --rm dev bash
docker compose run --rm --service-ports dev bash _scripts/serve
```

### Workflow VS Code standard

Estensione richiesta: [`ms-vscode-remote.remote-containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
(disponibile nel Marketplace Microsoft, già inclusa in VS Code Remote Development Pack).

Workflow: apri la cartella del progetto → VS Code mostra "Reopen in Container" →
clicca → build automatico + avvio + setup workspace in un unico passo. Zero
configurazione aggiuntiva.

### Workflow VSCodium

`ms-vscode-remote.remote-containers` **non funziona in VSCodium**: usa URL
hard-coded sul CDN Microsoft (`update.code.visualstudio.com`) con commit hash di VS
Code, che non corrispondono ai build VSCodium → 404. Non è risolvibile lato
container né tramite impostazioni.

Soluzione: due estensioni da Open VSX (installabili direttamente in VSCodium):

1. [`DDorch.codium-devcontainer`](https://open-vsx.org/extension/DDorch/codium-devcontainer) —
   legge `devcontainer.json`, fa build + avvio container, si connette via SSH
2. [`jeanp413.open-remote-ssh`](https://open-vsx.org/extension/jeanp413/open-remote-ssh) —
   dipendenza di DDorch; gestisce la connessione SSH scaricando il server da
   GitHub Releases di VSCodium (non da Microsoft)

Workflow: installa entrambe le estensioni → apri la cartella → usa il comando
"Open in Container" di DDorch. Nessuna modifica a `~/.ssh/config` richiesta.

**Fallback** (se DDorch non funziona):
```bash
make up   # avvia il container daemon SSH su porta 2222
```
In VSCodium: Remote SSH → inserisci `dev@localhost:2222` → apri `/workspace`.
Per fermare: `make down`.

### Workflow Emacs (TRAMP)

Avvia il container daemon:
```bash
make up   # avvia klez-me-daemon con SSH su porta 2222
```

In Emacs, **metodo Docker** (più semplice, nessun SSH richiesto):
```
C-x C-f /docker:klez-me-daemon:/workspace/
```
Emacs 29+: `tramp-container.el` è built-in (nessun pacchetto aggiuntivo).
Emacs <29: installa `docker-tramp` da MELPA.

**Metodo SSH** (alternativa):
```
C-x C-f /ssh:dev@localhost#2222:/workspace/
```

Per fermare il container: `make down`.

## Claude Code on the web

A SessionStart hook (`.claude/hooks/session-start.sh`, registered in
`.claude/settings.json`) prepares the toolchain for remote web sessions: it
pins Ruby 3.2.6 via rbenv, sets a UTF-8 locale, initializes submodules, and
runs `bundle install`. It only runs when `CLAUDE_CODE_REMOTE=true`. See
[`AGENTS.md`](AGENTS.md) for how to work in this environment.

## Maintenance contract

Keeping these docs accurate is **not optional**. Read the rules in
[`AGENTS.md`](AGENTS.md#maintenance-contract-mandatory).
