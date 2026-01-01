# IndieWeb Learning Path - Piano di Apprendimento Concentrico

> 📚 Questo documento è il tuo percorso di apprendimento pratico per trasformare klez.me in un sito IndieWeb completo.
> Ogni livello introduce concetti nuovi costruendo sopra quelli precedenti.

---

## 🎯 Struttura del Percorso

Il percorso è organizzato in **cerchi concentrici**, dal core verso l'esterno:

```
┌─────────────────────────────────────────┐
│  6. Progressive Enhancement             │
│  ┌───────────────────────────────────┐  │
│  │  5. Handcraft CSS & Design        │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  4. Fediverse & Federation  │  │  │
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │  3. Webmentions       │  │  │  │
│  │  │  │  ┌─────────────────┐  │  │  │  │
│  │  │  │  │  2. Identity    │  │  │  │  │
│  │  │  │  │  ┌───────────┐  │  │  │  │  │
│  │  │  │  │  │ 1. Markup │  │  │  │  │  │
│  │  │  │  │  │ Semantico │  │  │  │  │  │
│  │  │  │  │  └───────────┘  │  │  │  │  │
│  │  │  │  └─────────────────┘  │  │  │  │
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## 📖 Livello 1: Il Semantic Web - Markup Semantico con Microformats2

### 🎓 Concetti Core

Il **Semantic Web** è l'idea di dare significato ai dati sul web in modo che sia leggibile dalle macchine.
Invece di vedere solo "Alessandro Accardo", una macchina può capire che è una **persona** con proprietà specifiche.

#### Perché è importante?
- I motori di ricerca capiscono meglio i tuoi contenuti
- Altri siti possono interagire automaticamente con il tuo
- Le tue informazioni diventano parte del "web dei dati"

### 🛠️ I Microformats2

I **microformats2** sono classi CSS speciali che aggiungono significato semantico all'HTML esistente.

#### Le tre classi fondamentali per un blog:

1. **h-card** - Rappresenta una persona o organizzazione
2. **h-entry** - Rappresenta un articolo/post
3. **h-feed** - Rappresenta una lista di post

### 📝 Stato Attuale di klez.me

```html
<!-- ATTUALE: Nessun markup semantico -->
<div class="author">
  <img src="/avatar.jpg">
  <span>Alessandro 'kLeZ' Accardo</span>
</div>
```

### ✨ Obiettivo Livello 1

```html
<!-- OBIETTIVO: Con microformats2 -->
<div class="h-card">
  <img class="u-photo" src="/avatar.jpg" alt="kLeZ">
  <span class="p-name">Alessandro 'kLeZ' Accardo</span>
  <a class="u-url" href="https://klez.me">klez.me</a>
  <span class="p-note">Italian Developer & Blogger</span>
</div>
```

### 🔧 Task Pratici Livello 1

- [ ] 1.1 - Aggiungere h-card alla pagina About
- [ ] 1.2 - Convertire i post in h-entry
- [ ] 1.3 - Aggiungere h-feed alla homepage
- [ ] 1.4 - Testare con indiewebify.me

### 📚 Risorse
- [Microformats2 Wiki](http://microformats.org/wiki/microformats2)
- [IndieWebify.me - Validator](https://indiewebify.me/)

---

## 📖 Livello 2: IndieWeb Identity - Essere Proprietari della Propria Identità

### 🎓 Concetti Core

L'**identità IndieWeb** significa che il TUO dominio (klez.me) è la tua identità online, non Twitter, Facebook o altri social.

#### Elementi chiave:
1. **rel-me** - Collegamenti verificati ai tuoi profili social
2. **IndieAuth** - Usare il tuo dominio per fare login
3. **Web Sign-In** - Il tuo sito diventa il tuo "passaporto" online

### 🛠️ rel-me: Verifica Bidirezionale

Il tag `rel-me` crea un collegamento verificato tra il tuo sito e i tuoi profili social.

```html
<!-- Nel tuo sito -->
<a rel="me" href="https://github.com/kLeZ">GitHub</a>
<a rel="me" href="https://twitter.com/kLeZhAcK">Twitter</a>

<!-- Nei profili social, deve esserci un link al tuo sito -->
```

### 📝 Stato Attuale di klez.me

Il tuo `_data/social.yml` ha già i link, ma mancano i tag `rel-me`.

### ✨ Obiettivo Livello 2

```html
<!-- Footer o sidebar -->
<ul class="social-links">
  <li><a rel="me" href="https://github.com/kLeZ">GitHub</a></li>
  <li><a rel="me" href="https://twitter.com/kLeZhAcK">Twitter</a></li>
</ul>
```

### 🔧 Task Pratici Livello 2

- [ ] 2.1 - Aggiungere rel-me ai link social
- [ ] 2.2 - Verificare i link nei profili social
- [ ] 2.3 - Testare con IndieAuth.com
- [ ] 2.4 - (Opzionale) Implementare endpoint IndieAuth

### 📚 Risorse
- [RelMeAuth](https://microformats.org/wiki/RelMeAuth)
- [IndieAuth.com](https://indieauth.com/)

---

## 📖 Livello 3: Webmentions - Conversazioni Distribuite

### 🎓 Concetti Core

Le **Webmentions** sono l'equivalente IndieWeb dei commenti, like e repost, ma distribuiti.
Invece di commentare su un sito centralizzato, scrivi sul TUO sito e invii una notifica.

#### Come funziona:
1. Scrivi un post sul tuo sito che risponde/cita un altro post
2. Il tuo sito invia una "webmention" al sito citato
3. Il sito citato mostra il tuo commento come discussione

### 🛠️ Componenti Webmentions

1. **Endpoint Discovery** - Dove ricevi le webmentions
2. **Sending** - Inviare webmentions quando citi altri
3. **Receiving** - Ricevere e mostrare webmentions
4. **Verification** - Verificare che le webmentions siano autentiche

### 📝 Stato Attuale di klez.me

Usi Staticman per i commenti (centralizzato, non IndieWeb).

### ✨ Obiettivo Livello 3

```html
<!-- Nel <head> -->
<link rel="webmention" href="https://webmention.io/klez.me/webmention">

<!-- Nei post -->
<div class="webmentions">
  <h3>Discussioni</h3>
  <!-- Lista di webmentions ricevute -->
</div>
```

### 🔧 Task Pratici Livello 3

- [ ] 3.1 - Registrarsi su webmention.io
- [ ] 3.2 - Aggiungere endpoint webmention al sito
- [ ] 3.3 - Implementare display delle webmentions ricevute
- [ ] 3.4 - (Avanzato) Implementare invio automatico

### 📚 Risorse
- [Webmention.io](https://webmention.io/)
- [Webmention Spec](https://www.w3.org/TR/webmention/)

---

## 📖 Livello 4: Fediverso & Federation - Entrare nel Web Distribuito

### 🎓 Concetti Core

Il **Fediverso** (Fediverse) è una rete di siti/servizi interconnessi che comunicano tramite protocolli aperti.

#### Concetti chiave:
- **ActivityPub** - Protocollo per social network distribuiti (Mastodon, Pixelfed, etc.)
- **Federation** - Server indipendenti che si parlano
- **POSSE** - Publish on your Own Site, Syndicate Everywhere
- **PESOS** - Publish Elsewhere, Syndicate on your Own Site

### 🛠️ ActivityPub vs IndieWeb

- **IndieWeb**: Focus su siti personali, protocolli semplici (Webmention)
- **ActivityPub**: Focus su app server-to-server (Mastodon, Lemmy)
- **Bridging**: Puoi far parlare i due mondi!

### 📝 Obiettivo Livello 4

1. Far sì che i tuoi post appaiano automaticamente su Mastodon/Fediverse
2. Ricevere risposte dal Fediverso come webmentions
3. Usare **Bridgy** per connettere IndieWeb e Fediverso

### 🔧 Task Pratici Livello 4

- [ ] 4.1 - Configurare Bridgy per syndication
- [ ] 4.2 - Aggiungere link di syndication ai post
- [ ] 4.3 - Esplorare Mastodon/Fediverse integrations
- [ ] 4.4 - (Avanzato) Implementare ActivityPub endpoint

### 📚 Risorse
- [Bridgy](https://brid.gy/)
- [ActivityPub Spec](https://www.w3.org/TR/activitypub/)
- [Fediverse Overview](https://fediverse.party/)

---

## 📖 Livello 5: Handcraft CSS - Design Senza Framework

### 🎓 Concetti Core

Il movimento **Handcraft Web** promuove:
- CSS scritto a mano, non framework
- Design unico e personale
- Controllo totale sul codice
- File più leggeri e veloci

#### Perché evitare Bootstrap?
- **Peso**: Bootstrap è ~150KB minified
- **Genericità**: Tutti i siti Bootstrap sembrano uguali
- **Complessità**: Classi utility infinite
- **Over-engineering**: Usi il 10% delle feature

### 🛠️ CSS Moderno: Le Alternative

#### CSS Grid
```css
.container {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  gap: 20px;
}
```

#### CSS Flexbox
```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

#### CSS Custom Properties
```css
:root {
  --color-primary: #2c3e50;
  --spacing-unit: 1rem;
}

.card {
  background: var(--color-primary);
  padding: var(--spacing-unit);
}
```

### 📝 Stato Attuale di klez.me

- Bootstrap (150KB+)
- FontAwesome (80KB+)
- Dipendenze JavaScript per responsive

### ✨ Obiettivo Livello 5

- CSS custom da ~15-20KB
- Layout CSS Grid/Flexbox nativi
- Icone SVG inline o CSS puro
- Zero dipendenze CSS

### 🔧 Task Pratici Livello 5

- [ ] 5.1 - Analizzare il layout attuale (cosa serve davvero?)
- [ ] 5.2 - Creare sistema di design con CSS custom properties
- [ ] 5.3 - Ricreare navbar con Flexbox
- [ ] 5.4 - Ricreare grid layout con CSS Grid
- [ ] 5.5 - Sostituire icone FontAwesome con SVG
- [ ] 5.6 - Rimuovere Bootstrap completamente

### 📚 Risorse
- [CSS Grid Generator](https://cssgrid-generator.netlify.app/)
- [Every Layout](https://every-layout.dev/)
- [Modern CSS Solutions](https://moderncss.dev/)

---

## 📖 Livello 6: Progressive Enhancement - Meno JavaScript, Più HTML/CSS

### 🎓 Concetti Core

**Progressive Enhancement**: costruire dal basso verso l'alto
1. **Base**: HTML semantico funzionante
2. **Miglioramento**: CSS per stile
3. **Extra**: JavaScript solo dove necessario

#### Principi:
- Il sito deve funzionare senza JavaScript
- JavaScript aggiunge solo convenienza
- Usa HTML/CSS moderno invece di JS quando possibile

### 🛠️ HTML/CSS Moderni vs JavaScript

#### ❌ Vecchio modo (JavaScript)
```javascript
// Accordion con JS
button.addEventListener('click', () => {
  content.classList.toggle('open');
});
```

#### ✅ Nuovo modo (HTML/CSS)
```html
<details>
  <summary>Clicca per espandere</summary>
  <p>Contenuto nascosto, senza JavaScript!</p>
</details>
```

### 📝 Cosa Eliminare dal Sito

- jQuery (se presente)
- Bootstrap JavaScript
- Script per mobile menu (usa CSS)
- Script per modali (usa `<dialog>`)

### 🔧 Task Pratici Livello 6

- [ ] 6.1 - Audit JavaScript: cosa è veramente necessario?
- [ ] 6.2 - Convertire menu mobile in CSS-only
- [ ] 6.3 - Usare `<details>` per contenuti espandibili
- [ ] 6.4 - Usare `<dialog>` per modali
- [ ] 6.5 - Form validation con HTML5 (no JS)
- [ ] 6.6 - Smooth scroll con CSS `scroll-behavior`

### 📚 Risorse
- [You Might Not Need JavaScript](https://youmightnotneedjs.com/)
- [HTML5 Doctor](http://html5doctor.com/)
- [Can I Use](https://caniuse.com/)

---

## 🗓️ Piano di Implementazione Suggerito

### Fase 1: Fondamenta Semantic (Livelli 1-2)
**Obiettivo**: Il tuo sito parla il linguaggio del web semantico
- Settimana 1-2: Livello 1 (Microformats)
- Settimana 3: Livello 2 (Identity)

### Fase 2: Socialità Distribuita (Livello 3-4)
**Obiettivo**: Il tuo sito può conversare con altri siti
- Settimana 4-5: Livello 3 (Webmentions)
- Settimana 6: Livello 4 (Fediverso)

### Fase 3: Handcraft Revolution (Livelli 5-6)
**Obiettivo**: Sito leggero, veloce, unico
- Settimana 7-9: Livello 5 (CSS handcraft)
- Settimana 10: Livello 6 (Progressive enhancement)

---

## 📊 Metriche di Successo

### Prima della Trasformazione
- ❌ Nessun markup semantico
- ❌ Identità dipendente da social
- ❌ ~250KB di CSS/JS framework
- ❌ Commenti centralizzati (Staticman)
- ❌ Sito generico Bootstrap

### Dopo la Trasformazione
- ✅ Microformats2 completi
- ✅ Identità IndieWeb verificata
- ✅ ~20KB CSS custom
- ✅ Webmentions funzionanti
- ✅ Design unico handcraft
- ✅ Funziona senza JavaScript

---

## 🚀 Prossimi Passi

1. **Leggi** il Livello 1 per capire i concetti
2. **Chiedi** se qualcosa non è chiaro
3. **Inizia** con il primo task (1.1 - h-card sulla pagina About)
4. **Testa** con gli strumenti suggeriti
5. **Procedi** al task successivo

---

## 📚 Glossario Rapido

- **Microformats**: Classi CSS che aggiungono significato semantico
- **h-card**: Microformat per persone/organizzazioni
- **h-entry**: Microformat per post/articoli
- **rel-me**: Tag HTML per verificare identità
- **Webmention**: Notifica che un sito ha citato il tuo
- **POSSE**: Pubblica sul tuo sito, syndica altrove
- **Fediverso**: Network di social distribuiti (Mastodon, etc.)
- **Progressive Enhancement**: Costruire dal basso (HTML → CSS → JS)

---

**Pronto per iniziare? Partiamo dal Livello 1! 🎯**
