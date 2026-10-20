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
- **`tags`** — a YAML list. Use existing tags where possible (overview at
  `/tag/by-letter/`): every tag gets a page at `/tag/<slug>/`, and tags that differ only
  in case or accents (`Linux`/`linux`) end up on the same page. Tags also
  drive the "Articoli correlati" block under each post (the 3 most recent
  posts sharing a tag), so a post without tags gets no related posts.
- **`series:`** — optional series id, for posts published in parts. See
  "Series" below.
- **`date`** — full timestamp with timezone offset; `publish` fills it in.
- **`toc:`** — set to a path to render a table-of-contents aside (optional).
- **`lang:`** — only set if a *single page* is in another language; the site
  default is `it` (from `_config.yml`), and files under a language folder
  (`_posts/en/`, `_pages/en/`) take that folder's language whatever they say.
- **`image:`** — optional Open Graph image for that post; otherwise the site
  default (`/assets/img/home-bg.jpg`) is used.

### Series

Posts in parts share a `series:` id; the id is declared once in
`_data/series.yml`:

```yaml
social-media-considered-harmful:
  title: "Social media considered harmful. Forse..."
  description: >-
    Testo introduttivo in Markdown per la pagina /serie/<id>/.
  parts: 5        # optional: planned parts, while the series is still running
```

The English title and description go in `_data/locales/en.yml`:

```yaml
series_translations:
  social-media-considered-harmful:
    title: "Social media considered harmful. Maybe..."
    description: >-
      Introduction in Markdown for /en/serie/<id>/.
```

Parts are ordered by publication `date`. The post layout then shows the list
of all parts at the top (collapsible) and links to the previous and next part
at the bottom; `/serie/<id>/` lists the whole series and `/serie/` all series.
The English translation inherits `series:` from the Italian original if it
does not set its own.

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

#### Quotes in another language

Quotes in an Italian post are always in Italian. The original text may follow inside the same `citation` block, below the translation, marked with the `citation-original` class and its `lang`:

```markdown
> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://example.org/source]
> Il software di sistema era in comune fra modulo di comando e LEM. [...] Era eseguito da tutti.
>
> The systems software was shared by the command module software and the LEM software. [...] Everybody went through it.
> {: .citation-original lang="en"}
```

The original renders smaller, in italics and muted, under a thin rule, with a badge showing the language code (style in `_sass/bootkyll/_blockquote.scss`). The `lang` attribute also lets screen readers switch pronunciation.

The translation is idiomatic, not literal: with the original right below it, it can be interpretive and should read as natural Italian. No calques. In a technical context use the technical jargon ("everybody went through it", said of shared system code, is "era eseguito da tutti"). Mark stress with italics when the spoken reading would otherwise change the meaning ("il lobbying non c'entra *niente* con le mazzette"). Do not repeat the translation in the paragraph right after the quote.

The `translate` script handles these blocks: when the original is already in the target language (an English quote in a post translated into English), it drops the Italian translation and the IAL before calling the model and keeps only the original; otherwise the prompt tells the model to keep the original and its IAL verbatim.

### Footnotes

Kramdown footnotes: a `[^1]` marker in the text and the definition, one paragraph on one line, anywhere in the file (by convention at the end):

```markdown
Ho fatto ordine in quella *mazzumàja*[^1].

[^1]: **mazzumàja**: voce del dialetto civitavecchiese, [...]. Vedi Autore, [Titolo](https://example.org/source), Testata, 30 luglio 2024.
```

Kramdown renders every note at the end of the post, in `<div class="footnotes">`. The style lives in `_sass/bootkyll/_footnotes.scss`: a bordered box of its own, smaller and muted, under a "Note" label ("Notes" on English pages, via `:lang(en)`), with the note you jumped to highlighted. A new site language needs its own `:lang()` label there.

### Heading anchors

Every `##`-`######` heading gets a "§" link to itself before its text (hanging in the left margin on wide screens), shown when the heading is hovered (always, dimmed, on touch screens), so a reader can copy the link to a section. Nothing to write: `_plugins/heading_anchors.rb` adds it at build time to the ids kramdown generates from the heading text, so changing a heading changes its link. To keep a stable link, set the id by hand with an IAL: `## Un titolo {#id-stabile}`. Style in `_sass/bootkyll/_heading-anchors.scss`, label for screen readers in `heading_anchor` of `_data/locales/<lang>.yml`.

### Math (KaTeX)

Inline `$...$` and display `$$...$$` are rendered by `jekyll-katex` at build
time. `throw_error: true` — bad LaTeX fails the build, so check your formulas.

### Emoji

Use `:shortcode:` emoji (e.g. `:rocket:`). Emoji are **self-hosted**: after
introducing a new shortcode, regenerate the images with
`bash ./_scripts/emojis` (needs Python 3 + the SgEExt submodule), which writes
to `assets/img/emoji/`. It collects the shortcodes from `_posts/` (translations included) and `_drafts/`, so a draft previews with its emoji too. Times such as `12:34:56` also match the pattern and show up as "not found" warnings: harmless.

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
- **Sources quoted** with `citation` premonition blocks, linking the original; foreign-language quotes translated into Italian, with the original below (see "Quotes in another language").
- A clear arc: hook → what happened → why it matters *to you* → broader point.

When an agent writes "in kLeZ's style", match *this* — concrete, opinionated,
Italian, human. Don't flatten it into neutral corporate prose.

### Style

Descriptive, not aspirational. Derived from published posts and from hand edits made on drafts. The site carries several kinds of writing and they do not share a tone. Pick the register first, then apply the shared rules.

#### Registers

| Register   | Use for                                                    | Marker                                                         |
| ---------- | ---------------------------------------------------------- | -------------------------------------------------------------- |
| Polemic    | Political and social criticism, institutional abuse, rants | Position declared up front, invective allowed                  |
| Takedown   | Dismantling one specific argument, article or claim        | Attacks the reasoning, names the author, stays on the evidence |
| Technical  | Languages, tooling, architecture, methodology, explainers  | Curiosity, no invective, worked examples                       |
| Personal   | Loss, memory, private milestones                           | No irony, no structure, no sources                             |
| Reflective | Open-ended thinking, AI, philosophy of the craft           | Uncertainty stays unresolved                                   |

When a post mixes registers, they are segregated by section, not blended inside a paragraph. A polemic can contain a technical section; that section obeys the technical rules while it lasts.

#### Shared foundation

First person singular, always. The writer is present, takes a position and says so.

The reader is addressed as "tu", a single person, not an audience. "Lo so cosa stai pensando", "guarda meglio lo strumento". Never "il lettore", never "si potrebbe osservare".

Spoken lexicon, written syntax. Short sentences, short paragraphs, one-line paragraphs where the line has to land. The sentences are built, not dumped: the spoken quality lives in the word choice and the rhythm, not in broken grammar.

No authorial stage directions. Do not explain your own word choices, do not announce what you are about to do, do not comment on your own text while writing it. If a word is deliberate, it shows.

Openings are conversational and state the subject immediately: "Oggi parlo di evoluzione dei linguaggi di programmazione, tema a me caro". Hook, then the excerpt separator.

Section headings are short, sentence case, and assertive. If a section answers a question, the heading gives the answer: "Ma allora non è terrorismo", not "Ma allora perché non è terrorismo?". The question, if useful, opens the body and the answer is the first line.

Endings stay open. No summary, no moral, no "in conclusione". The last line is an image or a flat statement that leaves the reader thinking.

#### Mechanics

**Digits for data**, spelled-out numbers only when the figure is a rhetorical beat meant to be read slowly. `16.000 caselle`, `45.000 utenze`, `1500 siti`, but "Diciassette milioni." and "quattro milioni e trecentomila schede". Dot as thousands separator. Metric units.

**Blockquotes carry evidence**: the cited document, the official record, the statutory extract, set apart from the reasoning with line breaks. Also used for the final line of a post when that line is the verdict.

**Bold marks the word that carries the refutation**, never whole sentences. "causa del decesso **non accertata**, nesso **non stabilito**". Two or three per section at most.

**Bold-labelled lists** only when the list is a rapid-fire indictment: `**Guerra**:`, `**Welfare**:`, `**Carceri**:`. Works inside a blockquote. Outside that case, avoid lists.

**Numbered steps for dismantling someone's syllogism**: number the moves 1. 2. 3., then count them out loud.

**Italics are frequent**, on single words, to mark irony, implied quotation or vocal stress: un caso *scomodo*, con un *minimo* di coerenza, molti molti molti *nemici*. Italics do the work intonation does in speech. Also for untranslated technical terms: *notice and takedown*, *overblocking*, *delisting*.

Backticks for domains, filenames, commands, protocol states.

Sarcastic parentheticals are the signature device: "(ah no, loro no, sono americani...)", "(e non avrebbe potuto, no?)", "(magari un pelo più deficienti, ma sempre esseri umani)". The parenthesis holds either the objection the reader is already forming, or the joke that punctures the solemnity of the main clause.

Escalation by accumulation: write the sentence, then add one that raises. The second wave is nastier than the first and is often exclamative.

Avoid the three-beat construction with terminal repetition ("È la supercazzola. Prematurata con scappellamento a destra, ma pur sempre una supercazzola."). Compress to one line. Sentence fragments for effect: one per section, not three per paragraph.

#### Polemic

Purpose: political and social criticism, abuse of power, institutional hypocrisy.

Position declared in the opening, not revealed at the end. Simulated even-handedness is worse than open bias.

Profanity is deliberate, never decorative. Four or five instances in a long post, all at points of emphasis, never two in the same paragraph. A section heading may carry one if that section is the peak of the anger.

Vulgarity goes to the invective, never to the analysis. In reconstructive and technical passages the register rises: "denaro" not "soldi", "servizio tecnico" not "servizietto". Chummy diminutives in argumentative passages weaken them and get cut.

Personal attacks target public conduct and rest on a documented fact. The fact does the work, the adjective finishes it: "nel 2016 lo chiamava truffatore, poi è stato promosso" outweighs any insult. Collective abuse of a ruling class is fine and is not actionable, because it is judgment, not assertion of fact. Attributing a specific crime to a named individual is not fine, no matter how obvious it looks. Where the record supports the inference but not the label, lay out the record and let the reader draw it.

Power is described in monarchic vocabulary: rulers *regnano*, subjects bow to the king, the sanctioned party is *sgradita al Re*. The metaphor is used, never explained.

Enemies are named. Proud Boys, Truth, Fox, the NRA. Prudent circumlocutions get replaced with the name.

#### Takedown

Purpose: dismantling one specific article, claim or methodology.

The target is named and linked. The quarrel is with the reasoning, not the person: methodological error, correlation mistaken for causation, missing evidence, moved goalposts.

Opens with the encounter, in scene: where you were, what you were reading, what made you stop. "Ieri mattina stavo scrollando LinkedIn - già, lo so, pessima idea - quando..."

Sarcasm is aimed at the argument. One flourish of contempt at the start buys the right to be scrupulous for the rest of the piece, and the scrupulousness is what wins it.

The opposing argument is reconstructed accurately, in its strongest form, before being taken apart. If the target got something right, say so first.

#### Technical

Purpose: languages, tooling, architecture, methodology, explainers.

Curiosity is the driving tone, and enthusiasm about the subject is allowed here and nowhere else. Openings often admit a change of mind: filed something as a fanboy defence, then found the detail that changes everything.

No invective, no political framing unless the subject is political. Jokes are lighter and fewer, usually self-deprecating.

Working code, real commands, real file paths. Concrete over abstract. Claims about behaviour are verified before being written, and where a claim is unverified it is flagged as such.

Prerequisites before conclusions. Terms defined on first use. Nesting no deeper than three heading levels.

Uncertainty is stated plainly. "Non ne sono sicuro, verificalo" is acceptable; false confidence is not.

#### Personal

Purpose: loss, memory, private milestones.

Everything above is suspended. No irony, no sarcasm, no parentheticals, no wordplay, no headings, no sources, no formatting devices.

Short. Plain words. Long breathless clauses linked by commas are fine here and only here, because that is how grief actually comes out.

Nothing is explained and no lesson is drawn. The piece stops when the writer stops.

No editing pass for style. Whatever was written in that state stands.

#### Reflective

Purpose: open-ended thinking, AI, the philosophy of the craft.

Starts from a concrete trigger, usually something read, and follows where it goes. Digression is the point.

Uncertainty stays unresolved at the end. No verdict, no framework, no numbered takeaways.

Self-questioning is genuine and specific, not a rhetorical pose. If the honest answer is "non lo so", that is the ending.

#### Sources

Every register except Personal ends with a Fonti section: direct links, primary source preferred over the outlet reporting it.

Institutional claims are attributed ("secondo il Dipartimento di Stato"), never adopted.

Concede what holds, explicitly and without softening, before dismantling it. A hostile reader should find their own best argument already written into the piece, and already defused.

Always separate the established fact from the conclusion someone hangs on it: "Ho verificato che su una piattaforma c'è un post. Punto. Questo è il fatto." Then show the leap.

Verify first, insult after. A partisan piece survives only if the facts are unassailable.

Numbers, dates and legal citations exact. Statute names, article numbers, case citations, percentages to the reported figure.

#### Never

Trattini lunghi. Use commas, parentheses, or two short hyphens.

Curly quotes, emoji, decorative unicode.

Section summaries, "in sintesi", key takeaways, conclusions that restate the article.

Mandatory hopeful endings. If the conclusion is that it will go badly, write that it will go badly.

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

## 8. Translations

The site is multilingual via `_plugins/i18n.rb` (details in [`CONTEXT.md`](CONTEXT.md), "Languages"): Italian is the default language and lives at the root (`/about/`), English lives under `/en/` (`/en/about/`). A page or post exists **only in the languages it is written or translated in**: there are no copies. English listings show Italian-only posts with an "In Italian" badge (and vice versa), and the old `/en/` copy URLs redirect to the original. You translate incrementally, and some posts are never translated.

- **UI strings** (menu, footer, "Read more", ...) live in `_data/locales/<lang>.yml` and the per-language nav in `_data/navigation/<lang>.yml`. Edit these by hand.
- **Content** is translated by an LLM with `_scripts/translate`, then proof-read. The original is the source of truth; the translation is generated next to it in the other language's folder. The language folder gives the translation its `lang`, `locale` and URL prefix (posts get `/en/...` from `_config.yml`, pages get `/en` prepended to their permalink), so the translation keeps the original's permalink.
- **Translated slugs**: an English post may set `slug:` to get an English URL (`slug: the-sitemap-that-reports-itself` -> `/en/2026/09/17/the-sitemap-that-reports-itself/`). The pairing with the original goes by file name, so nothing else changes; the previous `/en/` URL becomes a redirect to the new one automatically.
- When a post or page exists in more than one language, a block under its title links every version ("Leggi in italiano" / "Read in English").
- The English variety is **British** (UK spelling/idiom, no Americanisms), enforced by the translation prompt. Everything technical (URL, `html lang`, `hreflang`, `og:locale`, switcher) stays the generic `en`; only the prose register is British. The switcher shows flags (Union Jack for English, tricolore for Italian) from `language.flag` in `_data/locales/<lang>.yml`.

### Language convention & direction

**Root = files in the default language (Italian), `_posts/<lang>/` and `_pages/<lang>/` = files in `<lang>`, always**, whichever language an article was written in first. The folder decides a file's language, both for the site and for `translate`. An article written in English goes in `_posts/en/`; if you write it at the root with `lang: en`, `translate` first moves it there with `git mv`.

### Adding a language

1. Add its code to `languages:` in `_config.yml` (not to `i18n_legacy_languages`).
2. Create `_data/locales/<lang>.yml`, starting from `en.yml`: `language` (flag, name, link labels, `og:locale`), `language_names`, the interface strings, `page_translations` (titles of home, blog, tags, series, search) and `series_translations`. Add the language to `language_names` in `en.yml` too: the translation prompt takes the language names from there.
3. Optionally `_data/navigation/<lang>.yml` (otherwise the Italian menu is used), `assets/img/flags/<flag>.svg`, and `_scripts/i18n/register.<lang>.md` with notes on the variety and register of that language for the translator.
4. Translate files into it with `_scripts/translate`, or put translated files in `_posts/<lang>/` and `_pages/<lang>/` by hand.

Nothing else changes: pages, layouts and the other locale files stay as they are (they show the new language under its own name until their `language_names` lists it). The language gets its feeds (`/<lang>/feed.xml`, `/<lang>/rss.xml`) and its entry in the footer feed menus by itself.

### Running the translator

```bash
export OPENROUTER_API_KEY=...        # https://openrouter.ai/settings/keys
make translate _posts/2026-10-20-new-post.md           # in the dev container
make translate _posts/2026-10-20-new-post.md OPTS=-n   # options go in OPTS: make would take -n for itself

_scripts/translate _posts/2026-10-20-new-post.md       # the same, run directly; into every other language
_scripts/translate -t en _posts/2026-10-20-new-post.md # only into English
_scripts/translate -n _posts/*.md                      # dry run: what would be translated or skipped
_scripts/translate -f _pages/about.md                  # again, even if the source has not changed

TRANSLATE_ADAPTER=claude _scripts/translate _posts/en/2013-07-30-x.md   # via Claude Code instead of OpenRouter
```

`translate` takes the files to translate and translates each into every other language in `languages:`. It is meant for one new article at a time, or for a list of posts you pick: the ones you never want translated you just never pass. It needs `bash`, `curl`, `jq`, [`yq`](https://github.com/mikefarah/yq) v4 (mikefarah's, not the Python `yq` that some distributions package under the same name), `perl` and Python 3 with PyYAML, all in the dev container. `make translate` runs it there and passes `OPENROUTER_API_KEY` and the `TRANSLATE_*` variables from your shell (by name, so the key does not show up in the command line). `translate-claude` needs the `claude` CLI and its login, which the container does not have: use it on the host. Each run prints, per file, the model's token usage and cost and the time taken, and at the end how many files were translated, need review, were skipped or failed. It exits non-zero if any failed.

It is a bash script that runs small programs in `_scripts/i18n/`, each with a usage line at the top:

| Program | Does |
| ------- | ---- |
| `prep TGT` | points `{% link %}` and `{% post_url %}` at the TGT version when one exists; in a quote whose original is already in TGT keeps only the original |
| `translate-openrouter SRC TGT`, `translate-claude SRC TGT`, `translate-replay SRC TGT` | the adapters: text on stdin, translation on stdout, a failure exits non-zero and nothing is written |
| `prompt SRC TGT` | the system prompt the adapters send: `prompt.md` with the language names, `register.<TGT>.md` and `glossary.yml` filled in |
| `clean` | ASCII punctuation, no code fence around the whole reply, one final newline |
| `assemble` | the source's front matter with the translated `title`, `subtitle`, `description`, `summary`, `excerpt` and a `source_sha`, then the translated body |
| `check` | headings, links, code fences, `$$` and Liquid tags as many as in the source, no number of the source missing, valid front matter |

- **Adapters.** `TRANSLATE_ADAPTER` picks one: `openrouter` (default), `claude`, `replay`. Adding another provider or harness (Ollama, opencode, another API) means writing one `translate-<name>` script with the same contract.
  - `translate-openrouter`: OpenRouter's chat API. `TRANSLATE_MODEL` (default `anthropic/claude-opus-5.5`), `TRANSLATE_REASONING` (default `low`), `TRANSLATE_PROVIDER` to pin one host, `TRANSLATE_MAX_TOKENS` (default about twice the input, so a looping model fails fast instead of emptying the credit). Estimated from the token counts of the tests: about $0.07 for a median post (6,000 characters), about $0.40 for the longest (49,000).
  - `translate-claude`: the Claude Code CLI on its own login (a claude.ai subscription costs nothing per call). `TRANSLATE_MODEL` (default `claude-opus-5-5`), `TRANSLATE_REASONING` (default `medium`). It runs `claude -p` from an empty directory without setting sources, tools or MCP servers; otherwise the user's and the project's CLAUDE.md and settings (about 15k tokens, "reply in Italian" included) go into the prompt.
  - `translate-replay`: prints the file in `TRANSLATE_REPLAY` instead of calling a model, to try the rest of the pipeline for free.
- **Model and reasoning.** Chosen in October 2026 on seven hard Italian passages and two English ones (supercazzola, a Truth/rutto pun, Roman dialect, "boomer quadratico medio", a Blade Runner quote...) translated by several models and scored against criteria written beforehand. A small test: one or two samples per model, scored by someone who knew which model wrote what. Opus 5.5 adapted best. Fable 5.1 was as good at 2.6x the price. GPT-6 Astra and Sol, Kimi K3, GLM 5.3 and DeepSeek V4 Pro were behind Opus on the hard passages. Mistral Large 4 looped. Qwen 3.8 Max was not tried: the account's zero-data-retention setting on OpenRouter excludes every host that serves it. More reasoning did not give better adaptations: OpenRouter's `medium` spent three times the reasoning of `low` and missed as much. The same word means different things to different adapters, though: with Claude Code's `--effort low` Opus does not think at all and misses most of the hard jokes, so `translate-claude` defaults to `medium`. Each run misses some jokes, at any level: proof-reading stays your job.
- **The prompt** (`_scripts/i18n/prompt.md`) asks for an adaptation, the way a dubbing adapter works on a comedy: what each sentence does, not its words; jokes, irony, subtext and register kept; idioms and cultural references replaced by ones that do the same job in the target language; facts, numbers, names and positions unchanged, nothing added or removed. `register.en.md` sets British English; `register.it.md` notes that the English originals were written by a non-native speaker, so the Italian may restore the intended tone where the English implies it. `glossary.yml` holds terms kept verbatim (`keep`) and fixed Italian/English renderings (`terms`).
- **The whole file goes to the model** in one request, front matter included: that is what was tested. Of the front matter that comes back only the five fields above are used; everything else, and the YAML itself, comes from the source.
- **Review flag.** When `check` finds a problem, or a front matter field came back untranslated, the file is still written, with `translation_review: true` (`<!-- translation_review -->` in a file without front matter), and the problems are printed. Remove the flag after you have checked.
- **Idempotency.** A translation stores the `source_sha` of the original it was made from (in a `<!-- source_sha: ... -->` comment for a file without front matter, such as an include). A translation whose original has not changed is skipped, so your fixes to it stay until the original changes; `-f` translates it again. A file **without** `source_sha` is an original, or a translation you took over: it is never overwritten, not even with `-f`. A file with `source_sha` is never used as a source, and neither is a page with `localize: true` (home, blog, tags, series, search): `_plugins/i18n.rb` already builds it in every language, so a translated copy would land on the same URL; its title goes in `page_translations` of `_data/locales/<lang>.yml`.
- **Partials.** A page that pulls in other Markdown files (`include_relative`, `right_content`, `left_content`, `toc`, as about and cv do) has them translated too.
- **Not handled**: plain internal URLs (`[...](/2026/08/27/x/)`) are not rewritten to the translated post; they lead to the original, which is correct but not ideal (use `{% post_url %}`, which is rewritten). Tags stay in the original language.

### Cross-references

`{% link %}` and `{% post_url %}` work in both languages and are validated at build
time. Point them at the version in the language of the page you are writing
(`{% link _pages/en/contatti.md %}`, `{% post_url en/2026-09-17-la-sitemap-che-segnala-se-stessa %}`);
when there is no translation, link the original. `translate` does this for you:
it rewrites each tag to the target-language version when one exists. Plain URLs
(`/cv/`) also work, but are not rewritten per language. `htmlproofer` catches
broken links.

### Known limitations

- Series titles and descriptions come from `_data/series.yml`: English pages use
  `series_translations` in `_data/locales/en.yml`, falling back to the Italian
  text when an entry is missing. Add both when you create a series.
