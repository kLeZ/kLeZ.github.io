# AGENTS.md

Guidance for AI agents (and humans) working on **kLeZ.github.io** — the source of
**https://klez.me**, the personal website of Alessandro "kLeZ" Accardo.

> This file documents the `dev` branch. Read it before making changes.

---

## 1. What this project is

A **statically generated personal website built with [Jekyll]** and continuously
deployed by GitHub Actions. It deliberately runs Jekyll *outside* the GitHub Pages
plugin sandbox: a dedicated CI pipeline builds the site, so the full Jekyll plugin
ecosystem (custom plugins, arbitrary gems) is available — at the cost of needing the
pipeline below to publish.

- **Generator:** Jekyll `3.9.3` (see `Gemfile.lock`)
- **Ruby:** `3.2.3` locally (`.ruby-version`); CI pins `3.2.0`
- **Markdown:** `kramdown` (+ GFM parser) · **Highlighter:** `rouge`
- **Styles:** Sass in `_sass/` + `assets/main.scss`, compiled compressed
- **Math:** KaTeX (`jekyll-katex`) · **Emoji:** `jemoji` + custom self-hosted emoji
- **Analytics:** GoatCounter (`klez.goatcounter.com`)
- **Comments:** Staticman (currently disabled via `comments.enabled: false`)
- **Domain:** `CNAME` → `klez.me`
- **Licensing:** code GNU GPL v3; content CC-BY-NC-ND 4.0

---

## 2. Branching & deployment model — READ THIS FIRST

| Branch    | Role                                                                 |
|-----------|----------------------------------------------------------------------|
| `dev`     | **Working branch.** All work happens here.                           |
| `master`  | **Publication only.** Holds the *built* `_site` output.              |

**Rules:**
- Every feature branch **MUST** be cut from `dev` and **merge back into `dev`**.
- **Never commit by hand to `master`** — it is written *only* by the CI `deploy` job.
- Pushing to `dev` triggers a production build + deploy to `master`.

---

## 3. CI/CD pipeline (`.github/workflows/main.yaml`)

Triggered by **push to `dev`** (ignoring `LICENSE`/`README.md`) or `workflow_dispatch`.
Two jobs:

1. **`build`**
   - Checks out `dev` **with submodules** (`submodules: true`).
   - Sets up Ruby `3.2.0` with bundler cache.
   - Runs `./_scripts/build` with `JEKYLL_ENV=production` and injects build metadata
     (`COMMIT_SHA`, `COMMIT_MESSAGE`, `BUILD_NUMBER`, `BUILD_ID`, `BUILD_WEB_URL`) into
     `_data/ci-status.yml`.
   - Date-stamps `_site/` and uploads it as the `site-release` artifact.
2. **`deploy`**
   - Checks out `master`, downloads the `site-release` artifact, removes the previous
     `deployed*` stamp, `git add -A`, commits `"Deployed new klez.me version"`, pushes.

→ **`master` is generated output. Treat it as build artifacts, not source.**

---

## 4. Repository layout

| Path                | Purpose                                                                 |
|---------------------|-------------------------------------------------------------------------|
| `_config.yml`       | Jekyll config (site metadata, plugins, KaTeX, GoatCounter, defaults).   |
| `_layouts/`         | `default`, `page`, `post`, `profile-page`.                              |
| `_includes/`        | Partials: `head`, `header`, `navbar`, `footer`, `posts`, `card`, `social`, `staticman-comments-new`, `embed-youtube`, `more`, … |
| `_data/`            | `author.yml`, `navigation.yml`, `social.yml`, `ci-status.yml` (CI-generated). |
| `_pages/`           | Standalone pages (`about`, `contatti`, `cv`, `blog`, `eventi`, `build.html`, `404.html`, long-form articles). Included via `include: [_pages]`. |
| `_posts/`           | Blog posts, named `YYYY-MM-DD-title.md`. Permalink `/:year/:month/:day/:title/`. |
| `_drafts/`          | Work-in-progress posts as `*.draft` files (see authoring flow).         |
| `_templates/`       | `post.md` scaffold used by the draft script.                            |
| `_xp/`              | `xp` **collection** (CV / experience cards), e.g. `xp-001.md`.          |
| `_sass/`            | Sass partials (`sass_dir`, compressed output).                          |
| `_plugins/`         | **Git submodules**: `premonition` (admonitions) and `SgEExt` (emoji extractor). |
| `_scripts/`         | Build/serve/draft/publish/emoji helpers (see below).                    |
| `assets/`           | bootstrap, fontawesome-free, jquery, popper, reveal.js, katex, `main.scss`, `main.js`, `theme-toggle.js`, images. |
| `apps/`             | Small standalone HTML apps (e.g. `contapapa.html`).                     |
| `lf/`               | Long-form HTML content (e.g. Kubernetes/testing articles).             |
| `media/`            | Media assets.                                                           |
| `CNAME`             | Custom domain (`klez.me`).                                              |

---

## 5. Local development

```bash
# One-time / after clone:
git submodule update --init --recursive   # required: _plugins/* are submodules
bundle install

# Serve with live reload + drafts:
./_scripts/serve            # bundle exec jekyll serve --livereload --drafts

# Full build as CI does it (doctor + build + htmlproofer):
./_scripts/build
```

- The custom plugins live in `_plugins/premonition` and `_plugins/SgEExt`; **the build
  fails or misbehaves without `git submodule update --init`**.
- `./_scripts/build` runs `jekyll doctor`, builds, then `htmlproofer ./_site
  --disable-external` (external links are not checked). Locally it also runs `publish`
  and `emojis` first and builds `--drafts --trace`.
- `.gitpod.yml` mirrors this: `bundle install && ./_scripts/build`, then `./_scripts/serve`.

---

## 6. Content authoring

**New post (recommended flow):**
```bash
JEKYLL_EDITOR=vim ./_scripts/draft "My Post Title"
# creates _drafts/my-post-title.md.draft from _templates/post.md
```
- Draft files use the `*.draft` extension and an `##date: __CURRENT_DATE` placeholder.
- `./_scripts/publish` promotes every `_drafts/*.draft` into
  `_posts/YYYY-MM-DD-<name>.md`, substituting the current date and un-commenting `date:`.
  (`build` runs this automatically in local, non-CI mode.)

**Conventions:**
- Posts: front matter `title`, `tags`; layout `post` is applied by default.
- Excerpt separator is `{% include more.html %}` (`show_excerpts: true`).
- KaTeX for math, `:emoji:` shortcodes for emoji.
- `_scripts/emojis` regenerates self-hosted emoji into `assets/img/emoji/` using
  `SgEExt` (needs `python3`); run it when you introduce new emoji shortcodes.
- `xp` collection items (`_xp/*.md`) follow `_xp/template.md` (capture blocks for
  title/subtitle/card/footer; `published: false` until ready).
- Theme: light/dark/system toggle via `assets/theme-toggle.js`; an inline script in
  `_includes/head.html` sets `data-theme` before paint to avoid FOUC.

---

## 7. Plugins

**Core gems (`Gemfile`, `:jekyll_plugins` group):** `jekyll-feed`, `jekyll-tidy`,
`jekyll-katex`, `liquid_reading_time`, `liquid_pluralize`, `jekyll-git_metadata`,
`jekyll-seo-tag`, `jemoji`, `jekyll-postfiles`.
Tooling gems: `html-proofer`, `kramdown` + `kramdown-parser-gfm`, `execjs`, `webrick`.

**Custom submodules (`_plugins/`):** `premonition`, `SgEExt`.

> Note: there is **no `jekyll-sitemap`** gem; SEO meta is provided by `jekyll-seo-tag`
> (`{% seo %}` in `_includes/head.html`) and the Atom feed by `jekyll-feed`
> (`{% feed_meta %}`).

---

## 8. Gotchas for agents

- **Always init submodules** before building — easy to forget, breaks the build.
- **Do not touch `master`**; push work to `dev` (or a feature branch off `dev`).
- CI sets `JEKYLL_ENV=production`; behavior can differ from local builds.
- `_data/ci-status.yml` is **generated in CI** — don't hand-edit meaningful values.
- htmlproofer runs with `--disable-external`, so broken *external* links won't fail CI;
  internal links and images **will**.
- Site `url` is `https://klez.me`; `baseurl` is empty.
- `_config.yml` changes require a server restart (not picked up by live reload).
