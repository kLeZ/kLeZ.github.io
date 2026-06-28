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
