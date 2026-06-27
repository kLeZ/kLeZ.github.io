# SPEC-AUDIT.md — Audit di klez.me contro The Website Specification

> Audit del sito **https://klez.me** (sorgente: branch `dev` di questo repository)
> rispetto alla checklist di **[The Website Specification](https://specification.website)**:
> **128 regole in 10 categorie**, interrogate via il suo MCP server
> (`https://mcp.specification.website/mcp`).
>
> **Data audit:** 2026-05-31 · **Branch analizzato:** `dev` (allineato) · **Tipo:** solo report, nessuna modifica applicata.

---

## 1. Metodologia e legenda

Le evidenze provengono da **due fonti**:

1. **Sorgente** del branch `dev` (`_config.yml`, `_layouts/`, `_includes/`, `Gemfile`, `_pages/`, `_sass/`, ecc.).
2. **Sito live** `https://klez.me`: header HTTP, negoziazione TLS/ALPN, presenza di
   `/robots.txt`, `/sitemap.xml`, `/feed.xml`, `/.well-known/*`, gestione 404, redirect.

### Legenda stato

| Stato | Significato |
|-------|-------------|
| ✅ **Pass** | Regola soddisfatta (1 punto). |
| ⚠️ **Parziale** | Parzialmente soddisfatta / presente ma con difetti (0,5 punti). |
| ❌ **Fail** | Non soddisfatta (0 punti). |
| ❓ **Da verificare** | Non verificabile in questo contesto (es. contrasto colore, Core Web Vitals sul campo, record DNS dietro proxy). Esclusa dal punteggio. |
| ➖ **N/D** | Non applicabile a un sito statico personale monolingua (es. OIDC, login, multilingua). Esclusa dal punteggio. |

### Note importanti sul contesto di misura

- **TLS inspection del sandbox.** L'egress proxy dell'ambiente intercetta il TLS
  (il certificato presentato ha issuer `Anthropic … TLS Inspection CA`). Gli **header
  HTTP** restituiti sono comunque quelli reali pass-through di GitHub Pages
  (`server: GitHub.com`, Fastly/Varnish), quindi affidabili; ma **certificato di
  origine, catena e cipher reali non sono direttamente verificabili** da qui. I
  record DNS (CAA/DNSSEC) non sono risolvibili dietro il proxy → `❓`.
- **Limite di GitHub Pages.** Il sito è ospitato su GitHub Pages, che **non consente
  header HTTP custom**. Tutta la famiglia di header di sicurezza (HSTS, CSP,
  `X-Content-Type-Options`, `X-Frame-Options`/`frame-ancestors`, `Referrer-Policy`,
  `Permissions-Policy`) e gli header `Link`/`Cache-Control` per asset **non sono
  impostabili senza un layer davanti** (es. Cloudflare). Questo spiega — e in parte
  giustifica architetturalmente — gran parte dei `❌` nella categoria Security/Performance.

---

## 2. Punteggio sintetico

Il punteggio è calcolato **sugli item applicabili e verificabili** (esclusi `❓` e `➖`).

| Categoria | Punti | Applicabili | % | Distribuzione su totale |
|-----------|:-----:|:-----------:|:--:|--------------------------|
| Foundations | 9,5 | 14 | 68% | 8✅ 3⚠️ 3❌ |
| SEO | 6,5 | 10 | 65% | 6✅ 1⚠️ 3❌ · 3➖ |
| Accessibility | 6,0 | 12 | 50% | 5✅ 2⚠️ 5❌ · 4❓ 4➖ |
| Security | 1,5 | 9 | 17% | 1✅ 1⚠️ 7❌ · 2❓ 1➖ |
| Well-Known URIs | 0,0 | 2 | 0% | 2❌ · 7➖ |
| Agent Readiness | 3,0 | 9 | 33% | 2✅ 2⚠️ 5❌ · 9➖ |
| Performance | 3,0 | 14 | 21% | 1✅ 4⚠️ 9❌ · 2❓ 3➖ |
| Privacy | 4,0 | 5 | 80% | 4✅ 1❌ · 1➖ |
| Resilience | 1,0 | 2 | 50% | 1✅ 1❌ · 1❓ 2➖ |
| Internationalisation | 3,0 | 5 | 60% | 1✅ 4⚠️ · 7➖ |
| **TOTALE** | **37,5** | **82** | **≈46%** | — |

**Distribuzione su tutte le 128 regole:**
**29 ✅ Pass · 17 ⚠️ Parziale · 36 ❌ Fail · 9 ❓ Da verificare · 37 ➖ Non applicabile.**

> Lettura: dei 128 item, 37 non si applicano a un sito statico personale monolingua e
> 9 non sono verificabili da qui; sugli **82 effettivamente in scope** il sito ottiene
> **37,5 punti (≈46%)**. I punti deboli concentrati sono **Security**, **Performance** e
> **Agent Readiness/Well-Known** — in buona parte riconducibili al fatto che GitHub Pages
> non permette header custom né file di discovery non generati dal sito.

---

## 3. Dettaglio per categoria

### 3.1 Foundations (14) — 9,5/14

| # | Regola (stato spec) | Stato | Evidenza | Raccomandazione |
|---|---------------------|:-----:|----------|-----------------|
| 1 | HTML doctype *(required)* | ✅ | Home: prima riga `<!doctype html>`. | — |
| 2 | `lang` su `<html>` *(required)* | ⚠️ | `_layouts/default.html:2` → `lang="{{ page.lang \| default: site.lang \| default: "en" }}"`; `site.lang` **non** è in `_config.yml`, quindi live è `<html lang="en">` su sito **italiano**. | Impostare `lang: it` in `_config.yml` (vedi §4 raccomandazione #1). |
| 3 | `<meta charset>` *(required)* | ✅ | `_includes/head.html` → `<meta charset="utf-8" />`. | — |
| 4 | `<meta viewport>` *(required)* | ✅ | `width=device-width, initial-scale=1`; non disabilita lo zoom. | — |
| 5 | `<title>` *(required)* | ✅ | Un solo `<title>` non vuoto generato da `{% seo %}`. | — |
| 6 | `<meta name="description">` *(recommended)* | ✅ | Presente (da `jekyll-seo-tag`). | Differenziare la description per pagina/post. |
| 7 | Canonical URL *(recommended)* | ✅ | `<link rel="canonical" href="https://klez.me/">`. | — |
| 8 | Favicon e app icon *(recommended)* | ⚠️ | Solo `/favicon.ico` (200, per convenzione GitHub Pages). Nessun `<link rel="icon">` SVG, `apple-touch-icon`, né icona maskable nel `<head>`. | Aggiungere favicon SVG, `apple-touch-icon`, e icona maskable per PWA. |
| 9 | `<meta name="theme-color">` *(recommended)* | ❌ | Assente nel `<head>`. | Aggiungere `theme-color` (con varianti light/dark via `media`). |
| 10 | `<meta name="color-scheme">` *(recommended)* | ❌ | Assente, **nonostante** il sito abbia un toggle light/dark. | Aggiungere `<meta name="color-scheme" content="light dark">` (riduce il flash). |
| 11 | Open Graph *(recommended)* | ⚠️ | `og:title/description/url/site_name/type` presenti, ma **manca `og:image`** e `og:locale` è `en_US` (errato per sito IT). | Configurare un'immagine di default e `og:locale: it_IT`. |
| 12 | Feed discovery `rel="alternate"` *(recommended)* | ✅ | `<link rel="alternate" type="application/atom+xml" href="/feed.xml">`. | — |
| 13 | Feed content hygiene *(recommended)* | ✅ | `/feed.xml` (200): `<link rel="self">`, `<id>` stabili, `<updated>` presenti (Atom ben formato da `jekyll-feed`). | — |
| 14 | Popover API *(recommended)* | ❌ | Usa modali/tooltip Bootstrap+jQuery, non la Popover API nativa. | Bassa priorità: valutare la Popover API per nuovi componenti. |

### 3.2 SEO (13) — 6,5/10

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | robots.txt *(recommended)* | ❌ | `https://klez.me/robots.txt` → **404**; nessun file nel repo. | Aggiungere `robots.txt` con riferimento alla sitemap. |
| 2 | XML sitemaps *(recommended)* | ❌ | `/sitemap.xml` → **404**; gem `jekyll-sitemap` **assente** dal `Gemfile`. | Aggiungere `jekyll-sitemap` ai plugin. |
| 3 | Sitemap index *(recommended)* | ➖ | Sito ben sotto i 50.000 URL. | N/D finché non serve. |
| 4 | Image/Video sitemap *(optional)* | ➖ | — | N/D. |
| 5 | URL structure *(recommended)* | ✅ | Permalink `/:year/:month/:day/:title/`, minuscolo e con trattini. | — |
| 6 | Redirect 301/302/308 *(required)* | ✅ | `http://klez.me` → **301** → `https://klez.me/`; nessuna catena. | — |
| 7 | Soft 404 *(avoid)* | ✅ | URL inesistente restituisce **HTTP 404** reale (non 200). | — |
| 8 | Meta robots / X-Robots-Tag *(required)* | ✅ | Pagine pubbliche indicizzabili di default; nessun `noindex` accidentale né staging esposto. | — |
| 9 | Heading hierarchy *(required)* | ⚠️ | Home contiene **2× `<h1>`** (masthead + `id="title"`); gerarchia h1→h2 ok ma il doppio h1 è ambiguo. | Mantenere un solo `<h1>` per pagina. |
| 10 | Internal linking *(recommended)* | ✅ | Navbar + card linkano ai post. | — |
| 11 | Structured data JSON-LD *(recommended)* | ✅ | 1 blocco `application/ld+json` con `@type` `WebSite` + `Person` (da `jekyll-seo-tag`). | Arricchire con `BlogPosting`/`Article` per i post. |
| 12 | Breadcrumbs *(recommended)* | ❌ | Nessun markup `BreadcrumbList` né breadcrumb UI. | Aggiungere breadcrumb + JSON-LD nelle pagine profonde. |
| 13 | IndexNow *(optional)* | ➖ | — | N/D. |

### 3.3 Accessibility (20) — 6,0/12

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Colour contrast *(required)* | ❓ | Non misurabile senza rendering. | Verificare con strumento (es. axe/Lighthouse), specie sul masthead con immagine di sfondo. |
| 2 | Image alt text *(required)* | ✅ | Home: 4/4 `<img>` con `alt`; `_pages/404.html` → `alt="Obi Wan Kenobi gif"`. | Mantenere la disciplina su nuovi contenuti. |
| 3 | Form labels *(required)* | ➖ | Nessun form attivo (commenti Staticman disabilitati). | N/D. |
| 4 | Keyboard navigation *(required)* | ❓ | Richiede test manuale. | Verificare ordine focus su navbar/toggle tema. |
| 5 | Visible focus indicators *(required)* | ❓ | Dipende dal CSS; non verificabile staticamente. | Verificare che il focus sia visibile e non rimosso senza sostituto. |
| 6 | Skip links *(recommended)* | ❌ | Nessun link "salta al contenuto" come primo elemento focusabile. | Aggiungere uno skip-link verso `<main>`. |
| 7 | Semantic HTML & landmarks *(required)* | ✅ | `<header> <nav> <main aria-label> <footer> <article> <section>` presenti. | — |
| 8 | ARIA — prima regola *(recommended)* | ✅ | Uso parco; `<main aria-label="Content">`. | — |
| 9 | Descriptive link text *(required)* | ⚠️ | Navbar descrittiva, ma gli excerpt usano un link "more"/continua potenzialmente generico. | Usare testo link descrittivo al posto di "more". |
| 10 | Empty links/buttons *(avoid)* | ⚠️ | Icone social FontAwesome: da confermare la presenza di nome accessibile. | Aggiungere `aria-label` alle icone-link prive di testo. |
| 11 | Accessible form errors *(required)* | ➖ | Nessun form. | N/D. |
| 12 | Document & parts language *(required)* | ❌ | `<html lang="en">` su sito italiano → lingua del documento errata (vedi Foundations #2 e i18n). | Correggere `lang` a `it`. |
| 13 | Reduced motion *(required)* | ❌ | Nessun `prefers-reduced-motion` in `_sass`/`assets`; presenti animazioni (reveal.js, transizioni). | Aggiungere blocco `@media (prefers-reduced-motion: reduce)`. |
| 14 | Accessibility overlays *(avoid)* | ✅ | Nessun overlay di "accessibilità" di terze parti. | — |
| 15 | Captions & transcripts *(required)* | ➖ | Nessun video self-hosted (solo embed YouTube). | N/D. |
| 16 | Accessible data tables *(required)* | ➖ | Nessuna tabella dati significativa rilevata. | N/D (verificare nei long-form). |
| 17 | Touch target size *(required)* | ❓ | Non misurabile staticamente. | Verificare target ≥24×24px (navbar, social, toggle). |
| 18 | Hidden until found *(recommended)* | ❌ | Non utilizzato. | Bassa priorità. |
| 19 | Native interactive elements *(recommended)* | ✅ | Usa `<button>`, `<a>`, `<details>`. | — |
| 20 | CSS state & relational selectors *(recommended)* | ❌ | Pattern non adottato (toggle via JS). | Bassa priorità. |

### 3.4 Security (12) — 1,5/9

> ⚠️ **Contesto:** GitHub Pages non consente header HTTP custom. HSTS, CSP, X-CTO,
> frame-ancestors, Referrer-Policy e Permissions-Policy **richiederebbero un proxy
> davanti** (es. Cloudflare) per essere implementati. Senza quello, restano `❌`
> strutturali, non semplici dimenticanze.

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | HTTPS e TLS *(required)* | ✅ | TLS 1.3 negoziato (ALPN h2); `http` → 301 → `https`. *(Cert d'origine non ispezionabile dietro il proxy.)* | — |
| 2 | HSTS *(required)* | ❌ | Nessun header `Strict-Transport-Security`. | Impostare HSTS via proxy/CDN (richiede layer davanti a Pages). |
| 3 | Content Security Policy *(recommended)* | ❌ | Nessun header `Content-Security-Policy`. | Definire una CSP (via proxy o `<meta http-equiv>` come ripiego parziale). |
| 4 | `/.well-known/security.txt` *(recommended)* | ❌ | `/.well-known/security.txt` → **404**; directory assente. | Pubblicare `security.txt` (contatto, scadenza). Facile e ad alto valore. |
| 5 | `X-Content-Type-Options: nosniff` *(required)* | ❌ | Header assente. | Impostare via proxy/CDN. |
| 6 | Clickjacking (frame-ancestors/XFO) *(required)* | ❌ | Nessun `X-Frame-Options`/`frame-ancestors`. | Impostare via proxy/CDN. |
| 7 | Referrer-Policy *(recommended)* | ❌ | Header assente. | Impostare `strict-origin-when-cross-origin` via proxy. |
| 8 | Permissions-Policy *(recommended)* | ❌ | Header assente. | Disabilitare feature non usate via proxy. |
| 9 | Subresource Integrity *(recommended)* | ⚠️ | Asset JS/CSS principali self-hosted (no SRI necessario); l'unico esterno (`gc.zgo.at/count.js`) è senza `integrity`. | Aggiungere `integrity`+`crossorigin` allo script GoatCounter. |
| 10 | Cookie attributes *(required)* | ➖ | Il sito **non imposta cookie** (GoatCounter è cookieless). | N/D (conforme per assenza). |
| 11 | DNS CAA records *(recommended)* | ❓ | DNS non risolvibile dietro il proxy. | Verificare/aggiungere record CAA per `klez.me`. |
| 12 | DNSSEC *(optional)* | ❓ | DNS non risolvibile dietro il proxy. | Valutare con il registrar. |

### 3.5 Well-Known URIs (9) — 0,0/2

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Well-known URIs overview *(recommended)* | ❌ | Nessuna directory `/.well-known/` (tutto 404). | Introdurre almeno `security.txt` (vedi Security #4). |
| 2 | `/.well-known/change-password` *(optional)* | ➖ | Nessun login/account. | N/D. |
| 3 | `/.well-known/openid-configuration` *(optional)* | ➖ | Non è un IdP OIDC. | N/D. |
| 4 | `/.well-known/api-catalog` *(recommended)* | ❌ | Assente. | Bassa priorità per sito personale. |
| 5 | `/.well-known/webfinger` *(optional)* | ➖ | Nessun host Fediverse. | N/D (utile solo se si self-hosta ActivityPub). |
| 6 | `apple-app-site-association` *(optional)* | ➖ | Nessuna app iOS. | N/D. |
| 7 | `assetlinks.json` *(optional)* | ➖ | Nessuna app Android. | N/D. |
| 8 | `/.well-known/nodeinfo` *(optional)* | ➖ | Non è una piattaforma federata. | N/D. |
| 9 | `/.well-known/traffic-advice` *(optional)* | ➖ | — | N/D. |

### 3.6 Agent Readiness (18) — 3,0/9

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Agent readiness overview *(recommended)* | ⚠️ | URL stabili + JSON-LD presenti, ma mancano robots.txt, sitemap e llms.txt. | Colmare i gap sotto. |
| 2 | `/llms.txt` *(recommended)* | ❌ | `/llms.txt` → **404**. | Generare un `llms.txt` con indice dei contenuti chiave. |
| 3 | `/llms-full.txt` *(optional)* | ➖ | — | N/D. |
| 4 | Per-page Markdown endpoints *(recommended)* | ❌ | Solo HTML; nessun `.md` per pagina. | Bassa priorità; valutare esposizione sorgenti `.md`. |
| 5 | robots.txt per AI crawler *(recommended)* | ❌ | Nessun robots.txt → nessuna policy per crawler AI. | Definire policy per user-agent AI nel robots.txt. |
| 6 | Content Signals in robots.txt *(optional)* | ➖ | — | N/D (emergente). |
| 7 | Web Bot Auth *(optional)* | ➖ | — | N/D. |
| 8 | Stable URLs *(required)* | ✅ | Permalink date-based stabili. | — |
| 9 | Structured data for agents *(recommended)* | ✅ | JSON-LD schema.org (WebSite/Person). | Arricchire con `BlogPosting`. |
| 10 | Machine-readable formats *(recommended)* | ⚠️ | Feed Atom presente; mancano sitemap e formati per pagina. | Aggiungere sitemap; valutare JSON Feed. |
| 11 | HTTP Link headers per discovery *(recommended)* | ❌ | Nessun header `Link` (limite GitHub Pages). | Richiede proxy/CDN. |
| 12 | MCP & tool discovery *(optional)* | ➖ | — | N/D. |
| 13 | A2A agent cards *(optional)* | ➖ | — | N/D. |
| 14 | Agent Skills discovery *(recommended)* | ❌ | Assente (convenzione emergente). | Bassa priorità. |
| 15 | DNS-AID *(optional)* | ➖ | — | N/D. |
| 16 | NLWeb *(optional)* | ➖ | — | N/D. |
| 17 | WebMCP *(optional)* | ➖ | — | N/D. |
| 18 | Schemamap *(optional)* | ➖ | — | N/D. |

### 3.7 Performance (19) — 3,0/14

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Core Web Vitals *(required)* | ❓ | Nessun dato di campo; home ~126 KB HTML, 70 card, jQuery+Bootstrap+FontAwesome JS. | Misurare con Lighthouse/CrUX; probabile margine su LCP/CLS. |
| 2 | Image optimisation *(required)* | ❌ | Immagini repo solo `.jpg/.png/.gif` (no WebP/AVIF); `<img>` senza `width`/`height`. | Servire WebP/AVIF; aggiungere dimensioni esplicite (CLS). |
| 3 | Lazy loading *(recommended)* | ❌ | Nessun `loading="lazy"` sulle immagini. | Aggiungere `loading="lazy"` (tranne LCP). |
| 4 | Preload/prefetch/preconnect *(recommended)* | ❌ | Nessun resource hint. | `preconnect` a `gc.zgo.at`; preload del CSS/LCP critico. |
| 5 | Cache-Control *(required)* | ⚠️ | Tutto servito con `cache-control: max-age=600`; asset senza `immutable`/cache lunga. | Senza fingerprinting+proxy non migliorabile su Pages; valutare CDN. |
| 6 | No-Vary-Search *(recommended)* | ➖ | Nessun parametro query rilevante. | N/D. |
| 7 | Compression *(required)* | ✅ | `content-encoding: gzip` (brotli assente lato Pages, ma gzip ok). | — |
| 8 | Web font loading *(recommended)* | ⚠️ | FontAwesome caricato come CSS+JS; nessun `font-display` esplicito. | Sottoinsiemare/`font-display: swap`; rimuovere il JS di FontAwesome se non serve. |
| 9 | Critical CSS *(recommended)* | ❌ | 6 fogli CSS render-blocking nel `<head>` (bootstrap×3, fontawesome, katex, main). | Inline del critical CSS; differire il resto. |
| 10 | Script loading *(recommended)* | ⚠️ | 7 script locali (`jquery 3.3.1`, popper, bootstrap, fontawesome, ecc.) senza `defer`/`async` (`_includes/scripts.html`), a fine body. | Aggiungere `defer`; rivalutare jQuery/FontAwesome-JS. |
| 11 | HTTP/2 e HTTP/3 *(recommended)* | ⚠️ | HTTP/2 attivo (ALPN h2); **nessun `alt-svc`** → niente HTTP/3 (limite Pages). | Richiede CDN con HTTP/3. |
| 12 | Speculation Rules *(recommended)* | ❌ | Non utilizzate. | Bassa priorità. |
| 13 | Resource hints overview *(recommended)* | ❌ | Nessun hint. | Vedi #4. |
| 14 | View Transitions *(recommended)* | ❌ | Non utilizzate. | Bassa priorità. |
| 15 | BFCache *(recommended)* | ❓ | Probabilmente eleggibile (sito statico), non verificato. | Verificare assenza di `unload` handler. |
| 16 | Visibility-aware rendering *(recommended)* | ❌ | `content-visibility` non usato (utile con 70 card). | Valutare `content-visibility: auto` sulle card. |
| 17 | CSS containment *(optional)* | ➖ | — | N/D. |
| 18 | Scroll-driven animations *(optional)* | ➖ | — | N/D. |
| 19 | Scrollbar gutter *(recommended)* | ❌ | `scrollbar-gutter` non impostato. | Bassa priorità (`scrollbar-gutter: stable`). |

### 3.8 Privacy (6) — 4,0/5

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Privacy policy *(required)* | ❌ | Nessuna pagina privacy in `_pages/`. | Aggiungere una pagina Privacy (cosa raccoglie GoatCounter, base giuridica). |
| 2 | Cookie consent *(required)* | ✅ | Nessun cookie non essenziale impostato (GoatCounter cookieless) → consenso non dovuto. | — |
| 3 | Global Privacy Control *(recommended)* | ➖ | Nessuna vendita/condivisione di dati. | N/D. |
| 4 | Third-party scripts *(recommended)* | ✅ | Unico script esterno: GoatCounter (`gc.zgo.at`), caricato `async`; resto self-hosted. | Aggiungere SRI (vedi Security #9). |
| 5 | Privacy-respecting analytics *(recommended)* | ✅ | GoatCounter: aggregato, cookieless. | — |
| 6 | Data minimisation *(recommended)* | ✅ | Sito statico, nessuna raccolta dati oltre l'analytics aggregato. | — |

### 3.9 Resilience (5) — 1,0/2

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | Custom error pages (404/500) *(required)* | ✅ | `_pages/404.html` (`permalink: /404.html`); URL inesistente → **HTTP 404** corretto con pagina custom. | Localizzare il testo del 404 in italiano. |
| 2 | Maintenance pages & 503 *(recommended)* | ➖ | Hosting statico, nessuna modalità manutenzione. | N/D. |
| 3 | Offline support / service worker *(optional)* | ➖ | Nessun service worker. | N/D (opzionale). |
| 4 | Web app manifest *(recommended)* | ❌ | `/manifest.json` e `/site.webmanifest` → **404**; nessun `<link rel="manifest">`. | Aggiungere un web app manifest. |
| 5 | Monitoring & uptime *(recommended)* | ❓ | Non verificabile dal repo (operativo/esterno). | Configurare monitoraggio esterno + status page. |

### 3.10 Internationalisation (12) — 3,0/5

> 🎯 **Tema trasversale n.1:** l'intero sito è dichiarato `lang="en"` ma i contenuti
> sono in **italiano** (e i metadati `<head>` sono in inglese). È la singola incoerenza
> più pervasiva, con impatto su i18n, Accessibility (#12) e Foundations (#2).

| # | Regola | Stato | Evidenza | Raccomandazione |
|---|--------|:-----:|----------|-----------------|
| 1 | International URL structure *(recommended)* | ➖ | Sito monolingua. | N/D. |
| 2 | hreflang *(recommended)* | ➖ | Sito monolingua. | N/D. |
| 3 | Localised page metadata *(recommended)* | ⚠️ | `title`/`description`/`og:*` in **inglese** su contenuti italiani; `og:locale=en_US`. | Allineare i metadati alla lingua reale (it). |
| 4 | hreflang in XML sitemap *(optional)* | ➖ | — | N/D. |
| 5 | Evitare redirect auto IP-based *(avoid)* | ✅ | Nessun redirect per lingua/geo. | — |
| 6 | `lang` su contenuto inline *(required)* | ⚠️ | Nessun `lang` inline sui termini stranieri; problema a monte è il `lang` di documento errato. | Dopo aver corretto `lang: it`, marcare i termini EN inline con `lang="en"`. |
| 7 | Language switcher *(recommended)* | ➖ | Monolingua. | N/D. |
| 8 | RTL & bidirezionale *(recommended)* | ➖ | Lingua LTR. | N/D. |
| 9 | Writing modes / CJK *(optional)* | ➖ | — | N/D. |
| 10 | Locale-aware content *(recommended)* | ⚠️ | `timezone: Europe/Rome` impostato; formattazione date/numeri non verificata come locale-IT. | Verificare formato date in italiano. |
| 11 | Plural rules *(recommended)* | ⚠️ | Presente `liquid_pluralize`, ma è pluralizzazione in stile inglese. | Verificare la correttezza dei plurali in italiano. |
| 12 | Internationalised Domain Names *(optional)* | ➖ | `klez.me` è ASCII. | N/D. |

---

## 4. Top raccomandazioni prioritizzate

Ordinate per **rapporto valore/sforzo**. Le prime quattro sono fix di sorgente
semplici, ad alto impatto e interamente nel controllo del repository (GitHub Pages).

| # | Azione | Categoria/i | Impatto | Sforzo |
|---|--------|-------------|:-------:|:------:|
| 1 | **Impostare la lingua corretta**: `lang: it` in `_config.yml` (e `og:locale: it_IT`); allineare i metadati `<head>` all'italiano. | i18n, Accessibility, Foundations | Alto | Basso |
| 2 | **Aggiungere `jekyll-sitemap`** (genera `/sitemap.xml`). | SEO, Agent Readiness | Alto | Basso |
| 3 | **Aggiungere `robots.txt`** (con riferimento alla sitemap e policy per crawler AI). | SEO, Agent Readiness | Alto | Basso |
| 4 | **Pubblicare `/.well-known/security.txt`**. | Security, Well-Known | Medio | Basso |
| 5 | **Aggiungere `/llms.txt`** con indice dei contenuti chiave. | Agent Readiness | Medio | Basso |
| 6 | **Completare il `<head>`**: `theme-color`, `color-scheme`, `og:image`, favicon SVG + `apple-touch-icon` + manifest. | Foundations, Resilience | Medio | Basso/Medio |
| 7 | **Accessibilità**: skip-link verso `<main>`, `@media (prefers-reduced-motion)`, `aria-label` sulle icone-link, un solo `<h1>`/pagina. | Accessibility, SEO | Medio | Medio |
| 8 | **Performance**: `defer` sugli script, `loading="lazy"` + `width`/`height` sulle immagini, WebP/AVIF, rivalutare jQuery/FontAwesome-JS, inline critical CSS. | Performance | Alto | Medio/Alto |
| 9 | **Aggiungere una pagina Privacy** (anche minimale: GoatCounter, base giuridica). | Privacy | Medio | Basso |
| 10 | **Header di sicurezza** (HSTS, CSP, X-CTO, frame-ancestors, Referrer-Policy, Permissions-Policy) e **HTTP/3** + cache lunga per asset: richiedono un **proxy/CDN davanti a GitHub Pages** (es. Cloudflare). Decisione architetturale. | Security, Performance | Alto | Alto |

### Nota architetturale

I gap più gravi di **Security** e parte di **Performance** non sono risolvibili
restando su GitHub Pages "puro", che non consente header HTTP custom. La leva
strutturale è anteporre una **CDN/proxy** (es. Cloudflare) che inietti gli header
di sicurezza, abiliti HTTP/3 e brotli, e gestisca cache e `Link` header. Tutto il
resto (lingua, sitemap, robots, security.txt, llms.txt, metadati, accessibilità,
ottimizzazione asset) è realizzabile **interamente nel sorgente** del branch `dev`.

---

*Report generato contro la checklist a 128 regole di The Website Specification
(interrogata via MCP). Solo analisi: nessuna modifica funzionale applicata al sito.*
