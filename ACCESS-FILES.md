# ACCESS-FILES.md — anonymously-accessible instruction & discovery files

> A guide, for **humans and AI agents**, to the small public files that sit at
> the root or under `/.well-known/` and tell automated clients — search
> crawlers, browsers, feed readers, security researchers, and LLM agents — how
> to treat this site.
>
> Read together with [`AGENTS.md`](AGENTS.md) and [`CONTEXT.md`](CONTEXT.md).
> If you add, remove, or change one of these files, **update this document in
> the same commit** (the maintenance contract applies).

---

## 1. Why these files exist

None of them render anything for a human visitor. They exist so that *machines*
can discover and respect the site without guessing:

- **Discoverability** — crawlers and agents find content fast (`sitemap.xml`,
  `feed.xml`, `llms.txt`) instead of spidering blindly.
- **Control** — you state what may be fetched and by whom (`robots.txt`).
- **Trust & safety** — you publish a vulnerability-reporting channel
  (`/.well-known/security.txt`).
- **Integration** — browsers and OSes get install metadata
  (`manifest.webmanifest`, favicons).

They are **cheap to ship and cheap to keep truthful**, and the payoff is being
legible to the automated half of the web. For a personal/professional site
whose goal includes *being found* (by people, search engines, and the AI agents
that increasingly mediate discovery), they are worth the few lines they cost.

---

## 2. How Jekyll serves them here (the three gotchas)

1. **Dotfiles are skipped by default.** Jekyll ignores files and directories
   starting with `.`, so `/.well-known/` is **not** published unless its path is
   listed under `include:` in `_config.yml`. It is:
   ```yaml
   include:
       - _pages
       - .well-known
   ```
2. **Front matter turns a static file into a template.** A file with a YAML
   front-matter block (even an empty `---` / `---`) is processed by Liquid, so
   you can write `{{ site.url }}`, loop over `site.posts`, etc. Without front
   matter the file is copied verbatim. **YAML front-matter values are *not*
   themselves run through Liquid** — compute dynamic values *in the body*, not in
   the front matter (this bit us once with `security.txt`'s `Expires`).
3. **Some plugins emit their own version.** `jekyll-sitemap` generates
   `sitemap.xml` and a minimal `robots.txt` *only if you don't provide your
   own*. Our hand-written `robots.txt` takes precedence over the generated one.

---

## 3. The files in this repository

| File | Status | Standard / source | Generated how |
| ---- | ------ | ----------------- | ------------- |
| `robots.txt` | classic, expected | RFC 9309 | hand-written, Liquid (sitemap URL) |
| `sitemap.xml` | classic, expected | sitemaps.org | `jekyll-sitemap` plugin (automatic) |
| `feed.xml` | classic, expected | Atom (RFC 4287) | `jekyll-feed` plugin (automatic) |
| `/.well-known/security.txt` | standard | RFC 9116 | hand-written, Liquid (`Expires` auto) |
| `llms.txt` | emerging convention | llmstxt.org | hand-written, Liquid (lists posts) |
| `manifest.webmanifest` | standard | W3C App Manifest | hand-written, Liquid |
| `favicon.ico` | classic, expected | de-facto | static file at repo root |

### 3.1 `robots.txt` *(RFC 9309)*
Plain-text file at the site root telling crawlers which paths they may fetch and
where the sitemap is. Ours **allows everything** and explicitly **allows named
AI crawlers** (GPTBot, ClaudeBot, PerplexityBot, Google-Extended, …) — being
indexed by AI search/discovery is intentional here. To opt a bot **out**, add:
```
User-agent: GPTBot
Disallow: /
```
*Maintain:* edit by hand when you want to allow/deny a path or a new bot. The
`Sitemap:` line is rendered from `site.url`, so it follows the domain
automatically.

### 3.2 `sitemap.xml` *(sitemaps.org)*
XML list of canonical URLs with `lastmod`. Fully automatic via `jekyll-sitemap`
— **no maintenance**. New posts/pages appear on the next build. To exclude a
page, set `sitemap: false` in its front matter.

### 3.3 `feed.xml` *(Atom)*
Subscription feed produced by `jekyll-feed`, advertised in `<head>` via
`{% feed_meta %}` (`rel="alternate"`). Automatic. Keep `title`/`description`
accurate in `_config.yml`.

### 3.4 `/.well-known/security.txt` *(RFC 9116)*
Machine-readable security-contact file under the IANA-registered `/.well-known/`
prefix (RFC 8615). Tells researchers how to report a vulnerability.
- `Contact:` is rendered from `_data/author.yml` (`email`).
- **`Expires:` is required and must be in the future.** We compute it at build
  time as *build date + ~1 year* (`site.time | date: "%s" | plus: 31557600 |
  date: …`), so **every deploy refreshes it** and it never silently expires.
- *Maintain:* normally nothing — it self-renews on each build. If you add a PGP
  key, add an `Encryption:` line and consider signing the file.

### 3.5 `llms.txt` *(emerging convention — llmstxt.org)*
A curated Markdown index at the root that gives LLM agents a fast, clean map of
the site (summary + key links + recent posts) instead of scraping HTML. **Not a
ratified standard**, but cheap and increasingly read by agents. Ours:
- States, in English, that the author is an Italian developer open to remote
  work — this file doubles as a discovery surface for agents acting on behalf of
  recruiters/companies.
- Auto-lists the 15 most recent posts via Liquid, so it stays fresh on its own.
- *Maintain:* update the intro/summary when the site's focus changes; the post
  list is automatic. Optionally add `llms-full.txt` (full concatenated content)
  later — only worth it for small sites.

### 3.6 `manifest.webmanifest` *(W3C Web App Manifest)*
JSON describing how the site installs as a PWA (name, colours, icons, display).
Linked from `<head>` via `rel="manifest"`.
- **Known limitation:** `icons` currently points to `favicon.ico` as a stopgap.
  For a real installable PWA, add **192×192** and **512×512** PNG icons (include
  one with `"purpose": "maskable"`) and list them here.
- *Maintain:* keep `theme_color`/`background_color` in sync with the
  `<meta name="theme-color">` values in `_includes/head.html`.

### 3.7 Favicons
`favicon.ico` lives at the repo root and is linked explicitly from `<head>`
(plus an `apple-touch-icon`, also pointing at the ICO for now). *Improvement:*
ship an **SVG** favicon and proper PNG touch/maskable icons.

---

## 4. Files we deliberately do NOT ship (yet)

| File | Why not (today) |
| ---- | --------------- |
| `humans.txt` | Nice-to-have credits file; trivial to add if wanted. |
| `/.well-known/change-password` | No user accounts / login. |
| `/.well-known/webfinger` | Not self-hosting a Fediverse identity (Mastodon is on `mastodon.uno`). Revisit if you ever host your own. |
| `apple-app-site-association`, `assetlinks.json` | No native mobile apps. |
| `/.well-known/api-catalog`, `openid-configuration` | No public API / not an OIDC provider. |
| `llms-full.txt` | Optional companion to `llms.txt`; add only if agents want full text. |

If a reason changes (e.g. you build an app, or self-host ActivityPub), add the
corresponding file and document it in §3.

---

## 5. The near future — how to approach what's coming

The "machine-readable web" is moving fast, especially around AI agents. New
conventions appear monthly; most are **draft**, cheap, and low-risk to adopt
early. Keep an eye on:

- **AI-preference signals in `robots.txt`** — *Content-Signals* / the IETF
  **AI Preferences (aipref)** work let you say *search vs. ingest vs. train*
  per crawler, not just allow/deny. When it stabilises, encode the author's
  stance here (e.g. allow search & answer, restrict training) instead of a blunt
  allow/disallow.
- **Agent discovery files** — `/.well-known/agent-card.json` (A2A protocol),
  MCP/`tool` discovery, NLWeb/`agents.json` (conversational endpoints). Relevant
  only if the site exposes *tools or agentic behaviour*; for a content site,
  `llms.txt` + structured data is enough for now.
- **Verifiable bot identity** — **Web Bot Auth** (RFC 9421 HTTP Message
  Signatures) lets good bots prove who they are. Server-side only; not actionable
  on GitHub Pages without a proxy.
- **DNS-level discovery** — **DNS-AID** (SVCB/HTTPS records under
  `_agents.<domain>`). Pairs with DNSSEC. A registrar/DNS concern, not a repo
  file.
- **HTTP `Link` headers** for discovery (sitemap, feed, llms.txt) — better than
  `<head>` links for agents that never parse HTML, but **require custom response
  headers**, which **GitHub Pages cannot set**. Needs a CDN/proxy (e.g.
  Cloudflare) in front. Track this together with the security headers (HSTS,
  CSP, …) noted in [`SPEC-AUDIT.md`](SPEC-AUDIT.md).

**Guiding principles** (old standards and new alike):

1. **Prefer real standards** (RFC / W3C / IANA registry) over hype. Adopt
   emerging conventions only when they are cheap and reversible.
2. **Keep URLs stable.** These files are public contracts; agents cache them.
   Don't move or rename them casually.
3. **Make them self-maintaining where possible** (Liquid from `_config.yml` /
   `_data` / `site.posts`), so they can't drift out of date.
4. **Document every one** here, with its status and how it's generated.
5. **Respect the visitor.** Discovery files should never leak private data or
   set tracking. They describe the site; they don't surveil the reader.

---

## 6. Checklist: adding a new access file

1. Decide root vs `/.well-known/`. If under `/.well-known/`, ensure
   `.well-known` is in `include:` (it is).
2. Add front matter (`---`/`---`) **only if** you need Liquid; compute dynamic
   values in the *body*, never in the front-matter YAML.
3. Pull dynamic values from `_config.yml` / `_data/*` so there's a single source
   of truth.
4. Build and confirm the file is emitted under `_site/` and renders correctly
   (`bundle exec jekyll build`).
5. If it's referenced from HTML (e.g. a `<link>`), run `htmlproofer` so the
   reference isn't broken.
6. Add a row to §3 (or §4) of this file **in the same commit**.
