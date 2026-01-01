# Documentazione per Agenti Claude

> 📋 Questo documento fornisce contesto e linee guida per agenti Claude che lavorano su questo progetto in future sessioni.

---

## 🎯 Contesto Progetto

### Cosa è klez.me
**klez.me** è il sito personale di Alessandro 'kLeZ' Accardo, sviluppatore software italiano.

- **Tipo**: Blog personale + portfolio professionale
- **Tecnologia**: Jekyll (static site generator)
- **Hosting**: GitHub Pages
- **Deployment**: GitHub Actions (auto-deploy da `dev` → `master`)

### Obiettivi del Proprietario
1. **Personal Branding**: Visibilità professionale per recruiting
2. **SEO**: Essere trovato quando cercano developer con le sue competenze
3. **Performance**: Sito veloce = competenza tecnica dimostrata
4. **Privacy**: Nessun tracking, no ads, GDPR compliant
5. **Controllo**: Proprietà totale dei dati, nessuna dipendenza vendor

### Cosa NON è il Progetto
- ❌ Non è un social network
- ❌ Non è un sito e-commerce
- ❌ Non è un'applicazione web complessa
- ❌ Non serve traffico di massa (è un portfolio professionale)

---

## 🌳 Struttura Repository

### Branch Model

```
dev (sorgente)
 ├── _config.yml          # Configurazione Jekyll
 ├── _posts/              # Post blog (markdown)
 ├── _layouts/            # Template HTML
 ├── _includes/           # Componenti riusabili
 ├── _sass/               # SCSS/SASS (per ora Bootstrap, da rimuovere)
 ├── assets/              # CSS, JS, immagini
 ├── _pages/              # Pagine statiche (About, CV, etc.)
 └── Gemfile              # Dipendenze Ruby/Jekyll

master (pubblicato)
 ├── index.html           # Compilato da Jekyll
 ├── 2025/01/01/post/     # Post compilati
 ├── assets/              # Asset processati
 └── feed.xml             # RSS feed
```

**IMPORTANTE**:
- ✅ **Lavora SEMPRE sul branch `dev`** (sorgente)
- ❌ **MAI toccare direttamente `master`** (è auto-generato da CI/CD)
- 🔄 Il workflow è: `dev` → push → GitHub Actions build → `master` deploy

### File Importanti

#### Configurazione
- `_config.yml`: Configurazione principale Jekyll
- `Gemfile`: Dipendenze Ruby

#### Layout/Template
- `_layouts/default.html`: Layout principale
- `_layouts/post.html`: Template per post blog
- `_includes/head.html`: Metadata, CSS imports
- `_includes/footer.html`: Footer del sito
- `_includes/navbar.html`: Navigazione

#### Stili
- `_sass/bootkyll/`: Stili Bootstrap (DA RIMUOVERE nel progetto)
- `assets/main.scss`: Entry point CSS

#### Post
- `_posts/YYYY-MM-DD-titolo.md`: Post blog
- Frontmatter standard:
  ```yaml
  ---
  title: "Titolo Post"
  layout: post
  date: YYYY-MM-DD
  categories: [categoria]
  ---
  ```

---

## 📋 Piano di Implementazione Attivo

**Vedi**: `IMPLEMENTATION_PLAN.md` per dettagli completi.

### Obiettivi Principali (Ordine Priorità)

1. **🔴 Web Semantico** (h-card, Schema.org) → SEO + recruiting
2. **🔴 Performance** (rimuovere Bootstrap, CSS custom) → velocità
3. **🟡 Commenti Mastodon** (sostituire Disqus) → privacy
4. **🟡 Progressive Enhancement** (meno JavaScript) → accessibilità
5. **🟢 Build in the Open** (progetti, changelog) → credibilità

### Fasi Implementazione

- **Fase 1**: Foundation Semantica (~5h)
- **Fase 2**: Performance Revolution (~15h)
- **Fase 3**: Commenti Mastodon (~5h)
- **Fase 4**: Progressive Enhancement (~5h)
- **Fase 5**: Build in the Open (ongoing)

**Stato Attuale**: Da iniziare (baseline esistente)

---

## 🛠️ Stack Tecnologico

### Attuale (Baseline)
- Jekyll 4.x
- Bootstrap 4.x (DA RIMUOVERE)
- FontAwesome 5.x (DA RIMUOVERE)
- Staticman (commenti, DEPRECATO)
- jQuery (DA RIMUOVERE)

### Target (Goal)
- Jekyll 4.x ✅
- CSS Grid + Flexbox custom ✅
- SVG inline ✅
- Mastodon API (commenti) ✅
- Vanilla JavaScript minimal ✅

---

## 🎨 Convenzioni e Best Practices

### Git Workflow

1. **Branch Naming**: `claude/<descrizione>-<session-id>`
   - Esempio: `claude/semantic-markup-abc123`
   - **CRITICO**: Session ID DEVE matchare per push authorization

2. **Commit Messages**: Italiano, descrittivi
   ```
   Aggiungi h-card alla pagina About

   - Implementa microformats2 h-card
   - Include foto, nome, job title, bio
   - Aggiunge rel-me per GitHub e LinkedIn
   ```

3. **Prima di Committare**:
   - Leggi sempre i file che modifichi
   - Testa localmente se possibile
   - Verifica che Jekyll compili

### Coding Standards

#### HTML/Liquid
```liquid
{%- comment -%}
Usa tag Liquid con whitespace control quando appropriato
{%- endcomment -%}

<div class="h-card">
  <img class="u-photo" src="{{ site.author.avatar }}" alt="kLeZ">
  <h1 class="p-name">{{ site.author.name }}</h1>
</div>
```

#### CSS
```css
/* Usa CSS custom properties per design system */
:root {
  --color-primary: #2c3e50;
  --color-secondary: #3498db;
  --spacing-unit: 1rem;
  --font-family-base: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* Mobile-first, progressive enhancement */
.container {
  width: 100%;
  padding: var(--spacing-unit);
}

@media (min-width: 768px) {
  .container {
    max-width: 750px;
    margin: 0 auto;
  }
}
```

#### JavaScript
```javascript
// Vanilla JS, nessuna dipendenza
// Progressive enhancement (funziona senza JS)

if ('fetch' in window) {
  // Feature detection
  fetchMastodonComments(postUrl);
}
```

### Semantic HTML

**Sempre usa tag HTML5 semantici**:
```html
<article class="h-entry">
  <header>
    <h1 class="p-name">Titolo Post</h1>
    <time class="dt-published" datetime="2025-01-01">1 Gennaio 2025</time>
  </header>

  <div class="e-content">
    <!-- Contenuto post -->
  </div>

  <footer>
    <p>Autore: <span class="p-author h-card">kLeZ</span></p>
  </footer>
</article>
```

---

## 🧪 Testing e Validazione

### Prima di Committare

1. **Jekyll Build Test**:
   ```bash
   bundle exec jekyll build
   # Verifica che compili senza errori
   ```

2. **Serve Locale**:
   ```bash
   bundle exec jekyll serve
   # Testa su http://localhost:4000
   ```

### Dopo Deploy

1. **Semantic Markup**:
   - [IndieWebify.me](https://indiewebify.me/)
   - [Microformats Validator](https://indiewebify.me/validate-h-card/)

2. **Schema.org**:
   - [Google Rich Results Test](https://search.google.com/test/rich-results)
   - [Schema.org Validator](https://validator.schema.org/)

3. **Performance**:
   - [Lighthouse CI](https://developers.google.com/web/tools/lighthouse)
   - Target: 95+ Performance, 100 Accessibility
   - [WebPageTest](https://www.webpagetest.org/)

4. **HTML Validity**:
   - [W3C Validator](https://validator.w3.org/)

5. **CSS Validity**:
   - [CSS Validator](https://jigsaw.w3.org/css-validator/)

---

## 🚫 Cosa NON Fare

### ❌ Anti-Pattern da Evitare

1. **Non lavorare su `master`**
   - È auto-generato, ogni modifica sarà sovrascritta

2. **Non aggiungere framework JavaScript**
   - No React, Vue, Angular
   - Solo Vanilla JS minimal

3. **Non aggiungere dipendenze CSS**
   - L'obiettivo è RIMUOVERE Bootstrap, non aggiungere altro
   - Scrivi CSS custom

4. **Non usare jQuery**
   - Vanilla JS moderno è sufficiente
   - `querySelector`, `fetch`, etc.

5. **Non aggiungere tracking/analytics invasivi**
   - GoatCounter è già presente (privacy-friendly)
   - No Google Analytics, Facebook Pixel, etc.

6. **Non implementare login/auth**
   - È un sito statico, no backend
   - IndieAuth è opzionale e per futuro

7. **Non over-engineer**
   - Keep it simple
   - Solo ciò che serve davvero

### ⚠️ Attenzione a:

- **Bootstrap removal**: Rimuovi gradualmente, non tutto in una volta
- **Breaking changes**: Testa sempre prima di committare
- **Mobile-first**: Testa sempre su mobile (responsive)
- **Accessibility**: Screen reader, keyboard navigation
- **Performance budget**: CSS <20KB, JS <15KB

---

## 📚 Risorse Utili

### Documentazione Tecnica

- [Jekyll Docs](https://jekyllrb.com/docs/)
- [Liquid Template Language](https://shopify.github.io/liquid/)
- [Microformats2](http://microformats.org/wiki/microformats2)
- [Schema.org](https://schema.org/)
- [MDN Web Docs](https://developer.mozilla.org/)

### Tools & Validators

- [IndieWebify.me](https://indiewebify.me/) - Semantic markup validation
- [Google Rich Results](https://search.google.com/test/rich-results) - Schema.org test
- [Lighthouse CI](https://developers.google.com/web/tools/lighthouse) - Performance
- [Can I Use](https://caniuse.com/) - Browser compatibility

### Design Inspiration

- [Every Layout](https://every-layout.dev/) - CSS layout patterns
- [Modern CSS Solutions](https://moderncss.dev/) - CSS senza framework
- [CSS Grid Generator](https://cssgrid-generator.netlify.app/)

### Community

- [IndieWeb Wiki](https://indieweb.org/)
- [Fediverse](https://fediverse.party/)
- [Fosstodon](https://fosstodon.org/) - Mastodon instance tech-friendly

---

## 🤖 Linee Guida per Agenti

### Quando Inizi una Nuova Sessione

1. **Leggi questo file** (AGENTS.md) per contesto
2. **Leggi IMPLEMENTATION_PLAN.md** per capire obiettivi
3. **Verifica branch**: Sei su branch da `dev`?
4. **Chiedi conferma** prima di grandi refactoring
5. **TodoWrite**: Usa per tracciare progresso

### Workflow Raccomandato

```
1. Leggi file rilevanti (Read tool)
2. Pianifica con TodoWrite
3. Implementa modifiche (Edit/Write)
4. Testa se possibile
5. Commit con messaggio descrittivo
6. Push sul branch
```

### Comunicazione con l'Utente

**Il proprietario (kLeZ) è**:
- ✅ Pragmatico (vuole ROI concreto)
- ✅ Privacy-conscious (no tracking)
- ✅ Performance-oriented (sito veloce)
- ✅ Tecnicamente competente (puoi essere tecnico)
- ❌ NON interessato a social/webmentions per network
- ❌ NON vuole over-engineering

**Stile comunicazione**:
- Sii diretto e onesto
- Spiega benefici concreti (non teoria)
- Mostra metriche (before/after)
- Chiedi se qualcosa non è chiaro

### Se l'Utente Chiede Qualcosa Fuori Scope

**Esempi**:
- "Aggiungi login con password"
  → Spiega che è sito statico, proponi alternative (IndieAuth)

- "Integra database per commenti"
  → Spiega che rompe architettura statica, proponi Mastodon API

- "Aggiungi React"
  → Contrario agli obiettivi (performance, semplicità)

**Approccio**:
1. Spiega perché non è allineato con obiettivi
2. Proponi alternative più semplici
3. Se insiste, chiedi conferma esplicita

---

## 🎯 Current Task Context

### Se Non Sai da Dove Iniziare

1. **Verifica stato progetto**:
   ```bash
   git status
   git log --oneline -10
   ```

2. **Controlla IMPLEMENTATION_PLAN.md**:
   - Quale fase siamo?
   - Quali task sono completati?

3. **Chiedi all'utente**:
   - "Vuoi continuare da dove eravamo rimasti?"
   - "Quale obiettivo è prioritario per te ora?"

### Quick Reference - Obiettivi Prioritari

Se l'utente dice "inizia con qualcosa utile":

1. **Fase 1, Task 1.1**: h-card nella pagina About (1h, alto ROI)
2. **Fase 2, Task 2.1-2.2**: Audit CSS + Design system (2h, fondazione)
3. **Fase 3, Task 3.1-3.3**: Setup Mastodon comments (2h, risolve privacy)

---

## 📞 Contatti e Support

**Proprietario**: Alessandro 'kLeZ' Accardo
- **Sito**: https://klez.me
- **GitHub**: https://github.com/kLeZ
- **Twitter**: @kLeZhAcK (raramente usato)

**Repository**: https://github.com/kLeZ/kLeZ.github.io

**Issues**: Usa GitHub Issues per bug o feature request

---

## 🔄 Changelog di Questo Documento

- **2025-01-01**: Creazione iniziale con contesto completo progetto
  - Aggiunto contesto obiettivi e scope
  - Documentato branch model e stack tecnologico
  - Definito convenzioni e best practices
  - Linee guida per agenti Claude

---

**Ultimo aggiornamento**: 2025-01-01
**Versione**: 1.0
**Autore**: Claude (con input kLeZ)
