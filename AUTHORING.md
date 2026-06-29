# AUTHORING.md — how to write posts on this site

> Guide for **humans and AI agents** writing blog posts (and pages) for
> klez.me. Read together with [`AGENTS.md`](AGENTS.md) (workflow/commands) and
> [`CONTEXT.md`](CONTEXT.md) (architecture).
>
> Posts are written in **Italian** (the site's language). These instructions are
> in English to match the repo's other docs; the *content* you write is Italian.

---

## 1. The draft → post flow

The repo separates work-in-progress (`_drafts/`) from published posts
(`_posts/`).

```bash
# 1. Scaffold a draft from the template (_templates/post.md):
JEKYLL_EDITOR=vim bash ./_scripts/draft "Titolo Del Mio Post"
#    -> creates _drafts/titolo-del-mio-post.md.draft with the title pre-filled
#       and an `##date: __CURRENT_DATE` placeholder (commented out).

# 2. Write. Preview locally with drafts shown:
bash ./_scripts/serve            # livereload, includes --drafts

# 3. Publish: promote every _drafts/*.draft into a dated _posts/ entry:
bash ./_scripts/publish
#    -> renames to _posts/YYYY-MM-DD-<slug>.md, substitutes today's date,
#       and un-comments the `date:` line.
```

Notes:
- `./_scripts/build` runs `publish` automatically in **local** (non-CI) mode, so
  a local build also promotes drafts. **CI does not publish drafts** — only
  files already in `_posts/` are deployed.
- **Agents:** you may create the `_posts/YYYY-MM-DD-<slug>.md` file directly
  (skipping the scripts) as long as you follow the naming and front-matter rules
  below. Prefer a real `_posts/` file when the post is meant to ship.

### File naming
- Posts live in `_posts/` named `YYYY-MM-DD-<slug>.md` (kebab-case, ASCII slug).
- Permalink is `/:year/:month/:day/:title/` (set globally; don't override).
- Drafts live in `_drafts/` as `<slug>.md.draft`.

---

## 2. Front matter

Minimal post front matter (the `post` layout is applied automatically):

```yaml
---
title: "Il titolo del post"
tags:
- software-libero
- linux
date: 2026-05-31 14:37:42+02:00   # added by publish; keep tz offset
---
```

- **`title`** — required. Rendered as the post heading by the layout, so **do
  not** repeat an `# H1` in the body (see §4).
- **`tags`** — a YAML list. Use existing tags where possible.
- **`date`** — full timestamp with timezone offset; `publish` fills it in.
- **`toc:`** — set to a path to render a table-of-contents aside (optional).
- **`lang:`** — only set if a *single page* is in another language; the site
  default is `it` (from `_config.yml`).
- **`image:`** — optional Open Graph image for that post; otherwise the site
  default (`/assets/img/home-bg.jpg`) is used.

---

## 3. Excerpt / "read more"

The home and blog lists show an excerpt. Mark the cut with the include:

```markdown
Primo paragrafo che fa da excerpt in homepage.

{% include more.html %}

Resto dell'articolo...
```

`show_excerpts: true` and `excerpt_separator: "{% include more.html %}"` are set
globally — everything **before** the separator is the excerpt.

---

## 4. Headings & structure

- **Do not write a top-level `# H1`** in the body: the layout already renders the
  post title (as the page's main heading). Start your sections at `##`.
- Keep a sensible nesting (`##` → `###`); don't skip levels.

---

## 5. Markdown features available

Markdown is **kramdown** (+ GFM). On top of plain Markdown you have:

### Kramdown attribute lists (IAL)
Attach CSS classes/ids to the preceding block:
```markdown
![Didascalia](/media/2026-05-31/foto.jpg){: .img-fluid }

{: .text-center }
> Un blocco centrato.
```

### Media & internal links
Use Liquid tags so paths are validated at build time (htmlproofer checks them):
```markdown
![alt testuale]({% link /media/2026-02-03/immagine.jpg %}){: .img-fluid }
[un'altra pagina]({% link _pages/about.md %})
```
Always provide **alt text** for images (accessibility + SEO).

### Admonitions (premonition plugin)
A premonition block is a Markdown blockquote whose **first line** is special:
`> [type] "Title" [optional-cite-url]`. Available types include `note`, `info`,
`warning`, `error`, and **`citation`** (renders a quote with a source link):

```markdown
> citation "Bruce Dubbs" [https://example.org/source]
> To me LFS is about learning how a system works.
```

To disable the header box, use an empty title: `> warning ""`.

### Math (KaTeX)
Inline `$...$` and display `$$...$$` are rendered by `jekyll-katex` at build
time. `throw_error: true` — bad LaTeX fails the build, so check your formulas.

### Emoji
Use `:shortcode:` emoji (e.g. `:rocket:`). Emoji are **self-hosted**: after
introducing a new shortcode, regenerate the images with
`bash ./_scripts/emojis` (needs Python 3 + the SgEExt submodule), which writes
to `assets/img/emoji/`.

### Code
Fenced code blocks are highlighted by **rouge**:
````markdown
```bash
echo "ciao"
```
````

---

## 6. Voice & style (house style)

The blog is first-person, Italian, direct and opinionated. Looking at existing
posts, the recognisable traits are:

- **Personal and political** — free software, hacker culture, anti-Big-Tech;
  arguments grounded in personal anecdotes ("mi è capitato l'anno scorso…").
- **Short, punchy paragraphs.** One idea each. Frequent one-line paragraphs for
  emphasis.
- **Direct address to the reader** ("Lo so cosa stai pensando.") and rhetorical
  questions that the post then answers.
- **Emphasis with `*italics*`**; occasional strong language for effect — kept
  deliberate, not gratuitous.
- **Sources quoted** with `citation` premonition blocks, linking the original.
- A clear arc: hook → what happened → why it matters *to you* → broader point.

When an agent writes "in kLeZ's style", match *this* — concrete, opinionated,
Italian, human. Don't flatten it into neutral corporate prose.

---

## 7. Before you ship a post

```bash
# Build the site the way CI does and check links/images:
CI=true ./_scripts/build
# or, manually:
bundle exec jekyll build && bundle exec htmlproofer ./_site --disable-external
```
Confirm: the post builds, images resolve, KaTeX doesn't error, and the excerpt
cut is where you want it. A pure post written on your own machine is committed
**directly to `master`**. Use a short-lived branch off `master` + PR only if the
change also touches site source (layouts, config, scripts, …) or doesn't come
from your machine (e.g. a draft generated by Claude Code on the web). See
[`AGENTS.md`](AGENTS.md) for the full matrix.

## 8. Translations (IT → EN)

The site is bilingual via **jekyll-polyglot**: Italian is the default language and
lives at the root (`/about/`), English lives under `/en/` (`/en/about/`). Pages and
posts **without an English translation fall back to the Italian content** under `/en/`
automatically — so the site is always complete; you translate incrementally.

- **UI strings** (menu, footer, "Read more", …) live in `_data/locales/{it,en}.yml`
  and the per-language nav in `_data/navigation/{it,en}.yml`. Edit these by hand.
- **Content** (pages, and later posts) is translated by an LLM, not by hand. The
  Italian file is the source of truth; an English sibling is generated with
  `lang: en` and the **same `permalink`** (polyglot adds the `/en/` prefix).
- The English variety is **British** (UK spelling/idiom, no Americanisms) — enforced by
  the translation prompt. Everything technical (URL, `html lang`, `hreflang`, `og:locale`,
  switcher) stays the generic `en`; only the prose register is British. The switcher shows
  flags (Union Jack for English, tricolore for Italian) from `_data/languages.yml`.

#### Language convention & direction (`lang` is mandatory)

Every page/post carries an explicit `lang: it|en`. **Convention: root = Italian files,
`_posts/en/` (and `_pages/en/`) = English files — always**, regardless of which language an
article was *written* in first.

`translate` is **bidirectional** and picks the direction from the source file's `lang`:
- **Italian-native**: write `_posts/AAAA-MM-GG-slug.md` (`lang: it`) → `translate` it →
  `_posts/en/…` (British English).
- **English-native**: write the article (even at the root, `lang: en`) → `translate` it →
  it **`git mv`s the source into `_posts/en/`** and generates the Italian translation at the
  root (`lang: it`). The prompts live in `_scripts/i18n/{prompt.md,register.en.md,register.it.md}`.

Invariant: a file **without `source_sha` is an original** and is never overwritten; a file
**with `source_sha` is a translation**, regenerated when its source changes. This prevents
round-trip corruption. Until a translation exists, polyglot serves the single existing
language at both URLs (fallback works in **both** directions).

### Running the translator

```bash
pip install requests pyyaml
export OPENROUTER_API_KEY="sk-or-..."          # free account on openrouter.ai
# optional: default is "openrouter/free" (auto-router, never 404s on a dead slug).
# For higher quality, pick a specific free model — verify it on openrouter.ai/models
# (Free filter), e.g. deepseek/deepseek-r1:free or meta-llama/llama-4-maverick:free.
export TRANSLATE_MODEL="deepseek/deepseek-r1:free"

./_scripts/translate _pages/about.md _pages/privacy.md
./_scripts/translate --dry-run _pages/cv.md    # show what it would do, no API call
./_scripts/translate --force _pages/about.md   # re-translate even if unchanged
```

- The prompt and glossary live in `_scripts/i18n/`. Add technical terms to
  `glossary.yml` to keep them consistent (or untranslated) across all content.
- **Guards**: after translating, the script checks that headings, links, code
  blocks and `$$` math match the source. On failure it retries once, then writes
  the file with `translation_review: true` so you can spot it.
- **Idempotency**: the English file stores a `source_sha`. Re-running skips files
  whose Italian source hasn't changed, so your manual fixes are preserved. It also
  skips English files that lack a `source_sha` (assumed hand-edited).
- **Always proof-read** the output — the LLM is good but not infallible, especially
  on heavily structured pages (e.g. the CV).

> Pages whose body is pulled from `_pages/include/…` (about, cv) need their include
> files translated too; point the English page at an English include.

### Cross-references: use URLs, not `{% link %}` / `{% post_url %}`

To link **another page or post**, write its plain root-relative **permalink URL**
(`[testo](/cv/)`, `[testo](/2019/03/21/staticman/)`), *not* `{% link %}` / `{% post_url %}`.
Reason: polyglot keeps one document per URL per language build, so a translated target's
Italian source leaves the English build and `{% link %}` (which resolves by source path)
breaks on pages served as fallback under `/en/`. Plain URLs are language-agnostic — polyglot
prefixes them to `/en/…` automatically and they fall back correctly. Broken links are caught
by `htmlproofer` at build time.

Exception: for **static assets** (`/media/…` images), keep `{% link /media/… %}` — it is
safe in every language and gives you build-time validation that the file exists.

### Known limitations

- `jekyll doctor` is incompatible with polyglot and is run non-fatally in
  `_scripts/build`.
- `sitemap.xml` lists only default-language (IT) URLs; English pages are discovered
  via the `hreflang` alternates emitted in each page's `<head>`.
- Untranslated pages served as IT fallback under `/en/` keep a self-canonical;
  `hreflang` signals the language relationship to search engines.
