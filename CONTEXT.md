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

This repository uses a **single long-lived branch**, `master` (the default
branch), which is the **source of truth**: Jekyll source, scripts, config, and
the CI definition. There is no separate deploy branch — the built site is
published straight to GitHub Pages as a deployment artifact (Pages **Source =
"GitHub Actions"**).

CI/CD (`.github/workflows/main.yaml`) is triggered **on push to `master`** (and
manual `workflow_dispatch`):

1. **build** job — checks out the repo (with submodules), sets up Ruby, runs
   `bundle install`, then `./_scripts/build`, and uploads `_site/` with
   `actions/upload-pages-artifact`.
2. **deploy** job — publishes that artifact with `actions/deploy-pages` to the
   `github-pages` environment. Nothing is committed back to the repo.

Implications:
- **Branching follows a content/source matrix** (see
  [`AGENTS.md`](AGENTS.md#golden-rules)): pure blog content (`_posts/`,
  `_drafts/`, `_xp/`, `_pages/`, content assets) authored on the owner's own
  machine is committed directly to `master`; site-source/feature/fix changes — or
  any change not originating from the owner's machine (e.g. Claude Code on the
  web) — go on a short-lived branch off `master` + PR. Mixed content+source
  counts as source.
- The CI workflow does **not** run on `pull_request` events, only on push to
  `master`. PRs therefore show no project CI status — that is expected.

## Toolchain

- **Ruby**: `3.3.6`, pinned in `.ruby-version` and used by CI, the dev
  container and the Claude Code hook. Jekyll 4.4 needs Ruby >= 2.7; 3.3 is the
  version tested here.
- **Bundler / gems**: declared in `Gemfile`, locked in `Gemfile.lock`
  (`BUNDLED WITH 2.4.10`). Jekyll 4.4.1 + plugins (sitemap, katex, seo-tag
  2.9, jemoji, tidy, postfiles, ...). `html-proofer` is
  used for link/asset testing. Bundler 4 rewrites `BUNDLED WITH`: run
  `bundle _2.4.10_ …` when a newer Bundler is the default.
- **Sass**: Dart Sass via `jekyll-sass-converter` 3 (`sass-embedded`). The
  sources use the module system (`@use`, `sass:color`, `sass:math`): every
  partial in `_sass/bootkyll/` loads `variables`/`mixins` itself, and
  `_sass/bootkyll.scss` lists the partials in cascade order. No `@import`, no
  global colour functions: the build prints no deprecation warnings. Source maps
  are off (`sass.sourcemap: never`).
- **Local plugins** in `_plugins/`: `i18n.rb` (see "Languages"),
  `blog_archive.rb` (see "Blog indexes") and `git_metadata.rb`
  (`site.git.last_commit` for `/build.html`, replacing the unmaintained
  `jekyll-git_metadata` gem, which required Jekyll 3).
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
- **`jekyll doctor` is part of the build** (`_scripts/build`) and fails it on
  errors, URL conflicts included: two pages with the same permalink (e.g. an
  English page that forgot its `/en/` prefix) stop the build.
- **`jekyll-tidy` + seo-tag `image`.** Setting `image:` in front matter makes
  `jekyll-seo-tag` emit JSON-LD that `jekyll-tidy`'s htmlbeautifier rejects
  (`Unmatched sequence`), breaking the build. The default `og:image` is therefore
  added manually in `_includes/head.html`, not via a seo-tag `image` default.
- **Dotfiles aren't published.** Jekyll skips paths starting with `.`, so
  `/.well-known/` is served only because `.well-known` is listed under
  `include:` in `_config.yml`. See [`ACCESS-FILES.md`](ACCESS-FILES.md).

## Directory layout (on `master`)

```
_config.yml        Jekyll configuration (site metadata, plugins, sass, katex...)
_data/             Site data (incl. CI status written during build)
_drafts/           Unpublished drafts (*.draft via _scripts/draft)
_includes/         Liquid partials
_layouts/          Page layouts
_pages/            Standalone pages
_plugins/          Ruby plugins (i18n, blog_archive, git_metadata) + submodules (premonition, SgEExt)
_posts/            Published blog posts
_sass/             Sass sources (compiled, style: compressed)
_scripts/          Build/dev helper scripts (see AGENTS.md)
_templates/        Templates (e.g. post.md used by _scripts/draft)
_xp/               "xp" collection
apps/ lf/ media/   Content / assets
assets/            Static assets (katex, emoji output, images, reveal.js, minisearch,
                   search.js...)
search.json        Full-text search index (Liquid-rendered, one per language)
.well-known/       Standard discovery files (security.txt); see ACCESS-FILES.md
robots.txt         Crawler policy + sitemap pointer (Liquid-rendered)
llms.txt           Curated index for LLM agents (Liquid-rendered)
manifest.webmanifest  PWA manifest (Liquid-rendered)
favicon.ico        Site favicon (root)
.github/workflows/ CI/CD (main.yaml)
.claude/           Claude Code config: SessionStart hook + settings
.devcontainer/     Dev container config (devcontainer.json + Dockerfile + init.sh)
docker-compose.yml Dev/daemon services for the local dev container (see AGENTS.md)
```

`sitemap.xml` and a minimal fallback `robots.txt` are generated by
`jekyll-sitemap`; the three Atom feeds by `_includes/atom.xml` (see
"Languages"). Our hand-written `robots.txt`
overrides the generated one. Details in [`ACCESS-FILES.md`](ACCESS-FILES.md).

## Languages

Italian is the default language, at the root; English lives under `/en/`. One
Jekyll process builds both (`_plugins/i18n.rb`, no gem; jekyll-polyglot was
removed).

- **Language of a file**: `lang` in front matter. `_config.yml` defaults give
  `it` everywhere and `en` (plus `locale: en`) under `_posts/en/` and
  `_pages/en/`. English posts get `/en/:year/:month/:day/:title/` from the same
  defaults; English pages carry an explicit `/en/...` permalink. URLs are never
  rewritten after rendering.
- **Translations** are paired by path without the language folder
  (`_posts/x.md` <-> `_posts/en/x.md`, `_pages/about.md` <-> `_pages/en/about.md`);
  `i18n_key` in front matter forces a pairing. A translation may therefore set
  its own `slug` (`/en/2026/09/17/the-sitemap-that-reports-itself/`).
  `page.translations` maps each language to `{url, title, lang}` and drives:
  the `hreflang`/`x-default` links in `<head>`, the navbar language switcher
  (`_includes/lang-switcher.html`: to the translation, or to that language's
  home when there is none) and the block under the post title
  (`_includes/post-languages.html`): shown when a post has two or more
  versions, one link per version ("Leggi in italiano" / "Read in English",
  flag + text in the target language, current one marked `aria-current`).
- **Interface pages** with `localize: true` (home, blog, tag overviews, series,
  search page and `search.json`) are cloned under `/en/`; `title_en` sets the
  clone's title. Generated pages (pagination, tags, series) are built per
  language by `blog_archive.rb`.
- **Listings** use `site.data.i18n.posts[lang]`: one entry per post, newest
  first, in the page's language when that version exists, otherwise in the
  language it was written in, with an "In italiano" / "In English" badge
  (`_includes/lang-badge.html`) and `lang` on its title and excerpt.
- **Links in templates** go through the `i18n_url` filter:
  `{{ '/blog/' | i18n_url: page.lang | relative_url }}` gives `/en/blog/` on
  English pages when that page exists, `/blog/` otherwise (e.g. `/cv/`, which
  has no English version). In content, `{% link %}`/`{% post_url %}` work in
  both languages; point them at the version in the page's language.
- **No copies.** An untranslated page exists in one language only. The URLs
  polyglot used to serve copies at (`/en/<url>` for Italian pages,
  `/<url>` for English-only posts) are redirect stubs (`_layouts/redirect.html`:
  meta refresh, canonical to the target, `noindex`, out of the sitemap) to the
  translation if there is one, else to the original.
- **Feeds** (Atom, `_includes/atom.xml`, `_pages/feeds/`): `/feed.xml` every
  post in every language, `/it/feed.xml` Italian only, `/en/feed.xml` English
  only; `feed_posts_limit` entries each. All three are linked in `<head>`.
- **Sitemap**: `jekyll-sitemap` now lists both languages.
- **Strings**: interface text in `_data/locales/{it,en}.yml`, menus in
  `_data/navigation/{it,en}.yml`, language names/flags/link labels in
  `_data/languages.yml`. Templates read them with `page.lang`.

## Blog indexes: pagination, tags, series, search

Everything is generated at build time; the only client-side part is the
full-text search, which runs in the browser on a static index. No external
service is involved.

- **`_plugins/blog_archive.rb`** (custom generator, no extra gem):
  - **Pagination.** Any page with `paginate: true` in its front matter gets a
    `paginator` object (keys as in jekyll-paginate). Page 1 keeps the page's
    permalink, page N is `<permalink>page/N/`. Used by the home (`/`, `/page/N/`)
    and `/blog/` (`/blog/page/N/`). Page size: `pagination.per_page` in
    `_config.yml` (or `paginate: <n>` on the page). Pages after the first are out
    of the sitemap; `jekyll-seo-tag` adds "Pagina N di M" to their title
    (`seo_page_of` in `_data/locales/`) and emits `rel=prev/next`.
  - **Tags.** One paginated page per tag at `/tag/<slug>/` (slug: Jekyll
    `slugify`, mode `latin`; spellings differing only in case/accents share a
    page). The overview has one static page per ordering, all rendering
    `_includes/tag-index.html` (tags in CSS columns: 2 on phones and tablets,
    3 from 992px; sort switch made of plain links, no JavaScript):
    `/tag/by-letter/` (A-Z, `site.data.tag_index[lang]`, also used by the
    search filter), `/tag/by-letter/desc/` (Z-A) and `/tag/by-n-posts/` (most
    used first, `site.data.tag_ranking[lang]`); only the first is in the
    sitemap. `/tag/` itself redirects to `/tag/by-letter/` (`layout:
    redirect`). Tags whose
    slug is `by-letter` or `by-n-posts` would collide; the build warns. Tags in post cards and in
    the post footer link to these pages (`_includes/tag-list.html`).
  - **Series.** Posts with `series: <id>` form a series, ordered by date;
    metadata (title, description, planned `parts`; `title_en`/`description_en`
    for the English pages) in `_data/series.yml`.
    `site.data.series_index[lang]` feeds `_includes/series-nav.html` (in the post
    layout: full list of parts at the top, previous/next chain at the bottom),
    the per-series page `/serie/<id>/` and the overview `_pages/serie.html`.
    Each series also carries `first_date`, `last_date` and `gaps` (days since
    the previous part); `_includes/series-meta.html` turns them into "3
    articoli · dal … al …, nell'arco di 4 mesi", and the series page shows the
    parts as a vertical timeline with date and gap per part, plus a placeholder
    for the parts still to come when `parts` is set.
  - **Related posts.** Each post gets `related_by_tag`: the most recent posts
    of its language's list sharing at least one tag with it (tags compared by
    slug), excluding itself, its translations and the other parts of its
    series. `_includes/related-posts.html` shows
    them under the article; how many is `related_posts` in `_config.yml`
    (default 3, `0` hides the block).
  - **Per language.** Everything above is built once per language from
    `site.data.i18n.posts[lang]` (non-default languages under `/<lang>/`), and
    a translation without `series:` stays in its original's series.
- **Search** (`/cerca/`, `_pages/cerca.html`): a plain GET form (`q`, `tag`),
  also in the navbar (on desktop only the icon, which opens `/cerca/`; the
  field shows in the collapsed mobile menu). `search.json` holds title, date, tags, excerpt and full
  plain text of every post of the page's language list (`/search.json`,
  `/en/search.json`; excluded from `jekyll-tidy`). `assets/search.js` indexes it
  with **MiniSearch** 7.2.0 (vendored and minified, `assets/minisearch/`, MIT): prefix + fuzzy
  matching, accent-insensitive, title and tags boosted, AND between words,
  optional tag filter; results are rendered client-side and the URL keeps
  `?q=&tag=`, so searches are linkable. Without JavaScript the page points to
  the tag pages. Both scripts load only on pages with `search: true`.
- **Dates.** Jekyll's `date` filter prints English month names. Every visible date (post header, cards, series,
  related posts, footer build time, build page) uses the plugin's
  `local_date` filter ("21 febbraio 2010", `local_date: "time"` adds the hour;
  month names from `months` in `_data/locales/<lang>.yml`); durations use
  `span_label` ("8 giorni", "4 mesi"). `datetime` attributes stay ISO 8601.

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
- **Permessi / UID-GID**: l'ENTRYPOINT parte come root, **riconcilia l'uid/gid
  dell'utente `dev` a quelli dell'host** (`HOST_UID`/`HOST_GID`, default 1000) e poi
  **scende a `dev` via `gosu`** (con `HOME=/home/dev`) sia per il setup sia per il
  comando. Risultato: ogni file prodotto (`vendor/`, `_site/`, `_drafts/*.draft`, …) è
  di proprietà dell'host su *ogni* percorso (make, VS Code, VSCodium, Emacs). In
  modalità daemon `sshd` resta root (lo richiede), ma le sessioni SSH entrano come
  `dev`. `HOST_UID`/`HOST_GID` arrivano da `docker-compose.yml` (il `Makefile` li
  esporta da `id -u`/`id -g`) e da `devcontainer.json` (`${localEnv:UID/GID}`; sul
  percorso codium l'IDE di solito non esporta `UID`/`GID`, quindi vale il default
  1000 — corretto per l'host attuale).
- **`_scripts/` nel PATH**: dentro il container `serve`, `draft "…"`, `publish`,
  `build`, `emojis` sono invocabili nudi da qualsiasi cartella.
- **Auto-serve** (`AUTO_SERVE=1`, attivo su daemon/devcontainer): all'avvio del
  container Jekyll serve parte in background (output nei log del container,
  `make logs`); http://localhost:4000 risponde appena finisce il primo build
  (qualche minuto alla prima esecuzione per via di post/katex/emoji, poi i rebuild
  sono di ~2s). I one-shot da `make` non lo attivano.
- **Pulizia una-tantum**: se in passato si sono creati `vendor/`, `_site/`,
  `.jekyll-cache/`, `.bundle/` di proprietà root, rimuoverli una volta
  (`sudo rm -rf vendor _site .jekyll-cache .bundle`) prima del nuovo avvio: sono
  git-ignored e rigenerati come utente host.

### Workflow terminale (make / docker compose)

```bash
make build          # build immagine (prima volta, ~5-10 min per compilazione Ruby)
make shell          # shell interattiva nel container (vim, nano, ecc.)
make serve          # Jekyll serve → http://localhost:4000
make draft TITLE="Titolo"   # nuovo draft
make publish        # promuovi draft in _posts/
make verify         # Jekyll build + htmlproofer nel container (nessun side effect sui draft)
make help           # lista tutti i target
```

Se il container daemon è già attivo (`make up` / VSCodium / Emacs), `make
shell/draft/publish/emojis/verify` vengono **eseguiti dentro quel container** (`docker
compose exec`, non un nuovo container) per evitare il conflitto sulla porta 4000;
`make serve` segnala che il server è già su grazie all'auto-serve.

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

> **Nota su permessi/auto-serve con DDorch.** DDorch costruisce una *propria*
> immagine e può sostituire l'`ENTRYPOINT`, quindi `init.sh` (riconciliazione
> UID/GID, drop a `dev`, auto-serve, setup submodule/gem) potrebbe **non girare**
> su questo percorso. Su un host con UID/GID 1000 i file creati dall'editor restano
> comunque di proprietà dell'host (`remoteUser: dev`), ma setup e auto-serve vanno
> avviati a mano. Il percorso che **garantisce** il comportamento descritto sopra è
> il fallback `make up` (daemon SSH), verificato end-to-end. Alla prima apertura con
> DDorch, controlla l'ownership con `ls -ln _drafts` / `ls -ldn vendor`.

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
pins Ruby 3.3.6 via rbenv, sets a UTF-8 locale, initializes submodules, and
runs `bundle install`. It only runs when `CLAUDE_CODE_REMOTE=true`. See
[`AGENTS.md`](AGENTS.md) for how to work in this environment.

## Maintenance contract

Keeping these docs accurate is **not optional**. Read the rules in
[`AGENTS.md`](AGENTS.md#maintenance-contract-mandatory).
