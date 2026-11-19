---
title: "La configurazione di Emacs come documento"
tags:
- emacs
- org-mode
- literate-programming
category: guida
date: 2026-11-19 20:37:36+01:00
---

La mia configurazione di Emacs è un documento Org di circa diecimila righe, scritto in italiano e in prima persona, che all'avvio Emacs legge, smonta ed esegue. La mantengo da una decina d'anni, e se in tutto questo tempo non è diventata una discarica di `setq` copiati da qualche forum il merito è del literate programming: ogni pezzo di codice sta accanto al motivo per cui esiste, e il motivo lo ritrovo quando mi serve.

Dopo [Emacs nell'età della magia]({% post_url 2026-11-16-emacs-nell-eta-della-magia %}) qualcuno mi ha chiesto di vederla. Adesso si può: una copia anonimizzata sta in un [gist](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a), in [italiano](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a#file-config-it-org) e in [inglese](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a#file-config-en-org), e tutti gli estratti di questa pagina vengono da lì. Clienti, datore di lavoro e dati personali sono sostituiti da segnaposto che iniziano con `REDACTED-`, il resto è il file vero.

{% include more.html %}

## Perché un documento

Del literate programming ho già scritto in un [post dedicato]({% post_url 2025-04-20-literate-programming-org-mode %}). Applicato a una configurazione che vive per anni, il vantaggio diventa concreto: una configurazione Emacs è un deposito di decisioni (perché questo pacchetto e non l'altro, perché quella variabile ha quel valore strano, perché quella riga deve stare prima di quell'altra), e nel codice nudo le decisioni non si vedono. Dopo sei mesi non se le ricorda nessuno, me compreso. In un documento invece stanno scritte accanto al codice, e quando cambio idea riscrivo il paragrafo insieme al blocco.

### Sei giri di rasoio

Questa configurazione non è sempre stata così lunga e complessa, e a dire la verità non è nemmeno sempre stata un file Org.

La storia parte da lontano, intorno al 2009 (quasi diciott'anni fa, quindi i ricordi sono un po' sfumati). Avevo da poco avviato il progetto [freax](https://github.com/kLeZ/freax-os) (povera idea, morta lì, dopo avermi fatto studiare parecchio), ed erano gli anni in cui studiavo, e anche molto, i compilatori, sulla mia ormai logora copia del [Dragon Book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools).

Da buon nerd, e *[yak shaver](https://projects.csail.mit.edu/gsb/old-archive/gsb-archive/gsb2000-02-11.html)* di livello epico quale sono sempre stato, dal Dragon Book, che usa il Pascal come esempio, arrivo a [Wirth](https://people.inf.ethz.ch/wirth/), e da Wirth al [professor Knuth](https://www-cs-faculty.stanford.edu/~knuth/) e alla sua epopea, [TAOCP](https://www-cs-faculty.stanford.edu/~knuth/taocp.html). Da lì alla storia di Knuth più in generale (grande informatico, una persona che ammiro sinceramente) è bastato un giro di rasoio, o magari due. Leggendo le altre fatiche del professore mi imbatto presto in WEB e [CWEB](https://www-cs-faculty.stanford.edu/~knuth/cweb.html), poi in [noweb](https://www.cs.tufts.edu/~nr/noweb/), e quindi nel [literate programming](https://www-cs-faculty.stanford.edu/~knuth/lp.html).

Affascinato da un paradigma per me così esotico, leggo tutto quello che posso (siamo al quinto giro di rasoio, ed ero partito dai compilatori) e arrivo a chiedermi quali implementazioni del literate programming esistano. Org è una di queste, [org-babel](https://orgmode.org/worg/org-contrib/babel/) per la precisione.

Alla sesta rasoiata mi chiedo se non si possa fare la stessa cosa con la configurazione di Emacs. Fino ad allora l'avevo mantenuta a mano, con una quantità di commenti impressionante per uno script di configurazione, che spesso però non bastavano comunque. Trovo un paio di altri emacser che, come sto facendo io adesso, avevano deciso di condividere il loro approccio con il mondo, ed entro nella tana del bianconiglio. Mi è piaciuta, ci sto bene dentro, ci ho messo anche le tendine.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-6 text-center" markdown="1">
![Vignetta di xkcd. Qualcuno chiede a un tizio seduto al computer su cosa stia lavorando. Lui risponde: sto cercando di sistemare i problemi che ho creato quando ho cercato di sistemare i problemi che ho creato quando ho cercato di sistemare i problemi che ho creato quando...]({% link media/2026-11-19/guide/xkcd-1739-fixing_problems.png %}){: .img-fluid }

*Un giro di rasoio qualsiasi, visto da fuori. [xkcd 1739, "Fixing Problems"](https://xkcd.com/1739/), di Randall Munroe, licenza CC BY-NC 2.5.*
</div>
</div>

Dentro ci ho portato prima la configurazione che avevo: qualche pacchetto configurato a mano, tutto installato con [`M-x package-install`](https://www.gnu.org/software/emacs/manual/html_node/emacs/Package-Installation.html), e al limite qualche `(add-to-list 'load-path ...)` per i pacchetti scaricati a mano da [EmacsWiki](https://www.emacswiki.org/) e siti del genere. Poi ho cercato un modo per togliere anche l'installazione manuale, prima con [use-package](https://github.com/jwiegley/use-package) e [MELPA](https://melpa.org/), poi con [straight](https://github.com/radian-software/straight.el). Questo mi ha portato a riscrivere tutta la configurazione con le installazioni dentro il documento, e da quel momento posso scrivere *perché* installo un pacchetto, oltre che come. Quando la situazione si è stabilizzata ho voluto renderla anche riproducibile, e da lì sono arrivati tutti i giri sull'avvio di Emacs e su Docker.

Da quel rewrite in Org, quello che mi ha fatto abbandonare per sempre la gestione manuale dei pacchetti, sono passati circa dieci anni. [Doom](https://github.com/doomemacs/doomemacs) l'ho scoperto decisamente dopo, quando avevo già una situazione paragonabile, e non mi ci sono nemmeno avvicinato: non ne ho bisogno, e sarebbe l'ennesimo rewrite.

Grazie a due vecchi barboni (Knuth e [Stallman](https://stallman.org/), con affetto) oggi scrivo in un editor, con un approccio decisamente inusuale, per mantenere la configurazione dell'editor stesso. Se non è un divertentissimo *yak shaving* questo, non so cosa lo possa essere.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8 text-center" markdown="1">
![Vignetta di xkcd. Alcuni programmatori discutono di quale editor usino i veri programmatori, citando nano, vim, emacs e cat; uno dice di usare una farfalla, che sbattendo le ali devia i raggi cosmici in modo da scrivere i bit giusti sul disco; un altro risponde che c'è un comando di Emacs anche per quello.]({% link media/2026-11-19/guide/xkcd-378-real_programmers.png %}){: .img-fluid }

*Sì, `M-x butterfly` esiste davvero. [xkcd 378, "Real Programmers"](https://xkcd.com/378/), di Randall Munroe, licenza CC BY-NC 2.5.*
</div>
</div>

## Com'è fatto, dentro

Tutto parte da una riga nell'intestazione del documento:

```org
#+PROPERTY: header-args:emacs-lisp :tangle yes :results silent :comments link
```

Vuol dire che ogni blocco di Emacs Lisp, salvo indicazione contraria, finisce nel file estratto (`:tangle yes`), e che accanto a ogni blocco estratto Org lascia un link alla sezione da cui viene (`:comments link`). Il resto del documento è prosa con il codice in mezzo, nel punto in cui serve al discorso. Una sezione qualsiasi, nel sorgente, ha questa faccia:

```org
** Tenere Customize fuori da init.el

=init.el= deve restare quello materializzato più sopra, e nient'altro. Emacs
però, quando salva una variabile via Customize, scrive un blocco
=custom-set-variables= in fondo a =custom-file=, e se =custom-file= è =nil=
(il default) usa =user-init-file=, cioè proprio =init.el=.

...

#+BEGIN_SRC emacs-lisp
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
#+END_SRC
```

E nel `config.el` estratto lo stesso blocco diventa:

```elisp
;; [[file:config.org::*Tenere Customize fuori da init.el][Tenere Customize fuori da init.el:1]]
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
;; Tenere Customize fuori da init.el:1 ends here
```

Quei commenti sono link Org veri. In `config.el` non ci guardo quasi mai, ma se ci finisco durante un debug, `M-x org-babel-tangle-jump-to-org` dal blocco mi riporta alla sezione del documento, e di solito al paragrafo che spiega perché quella riga è lì. Il backtrace diventa una citazione bibliografica, più o meno.

Il documento non produce solo `config.el`. Basta chiedergli quali altri file genera:

```bash
$ grep -oE '^#\+BEGIN_SRC [a-z-]+ :tangle [^ ]+' config.org | grep -v ':tangle \(yes\|no\)'
#+BEGIN_SRC emacs-lisp :tangle early-init.el
#+BEGIN_SRC emacs-lisp :tangle init.el
#+BEGIN_SRC text :tangle .gitignore
#+BEGIN_SRC dockerfile :tangle Dockerfile
#+BEGIN_SRC text :tangle .dockerignore
#+BEGIN_SRC emacs-lisp :tangle docker-grammatiche.el
#+BEGIN_SRC bash :tangle docker-entrypoint.sh
#+BEGIN_SRC bash :tangle docker-emacs.sh
```

Otto file, più `config.el`. Il punto d'ingresso, il file che isola la configurazione dalla distribuzione, il `.gitignore`, l'immagine container con i suoi script: ognuno sta nel capitolo che lo spiega, e `C-c C-v t` li rigenera tutti. Nessuno di questi file si modifica a mano: chi vuole cambiarli, li cambia nel documento.

I capitoli seguono l'ordine di esecuzione, perché i blocchi vengono estratti ed eseguiti nell'ordine in cui compaiono e un capitolo può usare solo quello che è stato definito prima. Le righe sono arrotondate:

| Capitolo | Cosa c'è dentro | Righe |
| --- | --- | ---: |
| Introduzione | literate programming, come si lavora sul documento | ~180 |
| Prologo | ordine di avvio, `early-init.el`, `init.el`, garbage collector | ~400 |
| Bootstrap | straight.el, use-package, Org incluso in Emacs | ~190 |
| Accesso rapido e utility | `C-c s` per aprire il documento, funzioni riusate, prerequisiti di sistema | ~670 |
| Estetica e usabilità | tema, modeline, which-key, Treemacs, server | ~860 |
| Org-mode | agenda, capture, refile, matrice di Eisenhower, archivio | ~900 |
| Org-babel | linguaggi eseguibili, PlantUML, Ditaa, LaTeX | ~500 |
| org-roam | secondo cervello, journal, ricerca full-text | ~360 |
| Scrittura tecnica | Pandoc, Typst, ODT e DOCX, reveal.js | ~920 |
| AI e LLM | registro dei modelli, gptel, agenti | ~940 |
| Development | tree-sitter, minibuffer, completamento, Eglot, Magit | ~800 |
| Container | Dockerfile e script di avvio | ~320 |
| Cheatsheet | dati curati a mano e capitolo generato | ~3.000 |
| Epilogo | garbage collector, tempo di avvio, aggiornamento dei pacchetti | ~80 |

Quasi un terzo è il cheatsheet, che ha una guida tutta sua.

## L'avvio, passo per passo

Prima di arrivare al documento, Emacs passa da un paio di file che non controllo io, e uno dei due mi è costato un altro giro di rasoio, stavolta dentro `startup.el`.

![Sequenza di avvio: Emacs parte come daemon con --no-site-file; senza quell'opzione caricherebbe site-start.el della distribuzione, prima di early-init.el. Poi early-init.el toglie site-lisp dal load-path, alza il GC al massimo e spegne package.el; init.el carica Org e chiama org-babel-load-file; se config.org è più nuovo di config.el lo estrae di nuovo. config.el esegue i capitoli in ordine: prologo, bootstrap di straight e use-package, capitoli per area (un pacchetto mai clonato viene clonato al commit del lockfile), epilogo. Alla fine emacs-startup-hook stampa il tempo di avvio.]({% link media/2026-11-19/guide/g1-sequenza-avvio.svg %}){: .img-fluid }

### Il daemon salta `site-start.el`

Le distribuzioni installano pacchetti Emacs in `site-lisp` e li attivano con `site-start.el`, che Emacs carica prima di qualunque file dell'utente. Prima, proprio. La docstring di `site-run-file` documenta l'ordine (prima `site-start.el`, poi `early-init.el`, poi `init.el`) e il codice di `startup.el` lo conferma. Quindi `(setq site-run-file nil)` in `early-init.el`, consiglio che gira parecchio, non fa niente: quando viene letto, `site-start.el` è già passato. L'unico modo per saltarlo è l'opzione `--no-site-file` sulla riga di comando.

Il mio Emacs gira come servizio systemd, e l'unità la sovrascrivo con un drop-in in `~/.config/systemd/user/emacs.service.d/override.conf`:

```systemd
[Service]
ExecStart=
ExecStart=/usr/bin/emacs --fg-daemon --no-site-file
```

La riga `ExecStart=` vuota non è un refuso: systemd accetta più `ExecStart` solo nei servizi `Type=oneshot`, quindi prima azzero quello dell'unità di sistema e poi metto il mio. Il blocco sta nel documento con `:tangle no`, perché quel file vive fuori dal repository, ma la spiegazione sta lì con il resto.

### `early-init.el` e il caso which-key

Saltare `site-start.el` non basta, perché `site-lisp` resta nel `load-path` e i pacchetti della distribuzione restano lì, pronti a farsi caricare. Me ne sono accorto con which-key. Emacs 31 lo include alla 3.6.1, e io ero convinto di usare quella. openSUSE però installava anche il suo pacchetto `emacs-which-key`, fermo alla 3.6.0, e `site-lisp` veniva prima nel `load-path` della directory dei pacchetti inclusi: caricavo quello della distribuzione senza saperlo. Su un'altra macchina, con un'altra distribuzione, avrei avuto un'altra versione, o nessuna.

Da lì è nato `early-init.el`, che nel documento ha il suo blocco con `:tangle early-init.el`:

```elisp
;; Toglie ogni directory site-lisp dal load-path. Senza questo, i pacchetti
;; Emacs della distribuzione fanno da fallback silenzioso per tutto quello che
;; straight non fornisce, e la configurazione si comporta in modo diverso a
;; seconda della macchina su cui gira.
(let (pulito)
  (dolist (dir load-path)
    (unless (string-match-p "/site-lisp" dir)
      (push dir pulito)))
  (setq load-path (nreverse pulito)))

;; Lo impostava site-start.el di openSUSE, che il daemon non carica (--no-site-file).
;; Senza, ogni avviso della compilazione nativa asincrona apre il buffer *Warnings*.
(setq native-comp-async-report-warnings-errors 'silent)

;; GC generoso durante l'avvio: qui serve gia', prima che init.el parta.
(setq gc-cons-threshold most-positive-fixnum)

;; straight.el gestisce i pacchetti, package.el non deve nemmeno inizializzarsi.
(setq package-enable-at-startup nil)
```

Il `setq` di `native-comp-async-report-warnings-errors` è il prezzo di `--no-site-file`. Quello che `site-start.el` faceva e che mi serviva lo rimetto io, e il documento elenca una per una le cose che ho deciso di *non* rimettere, con il motivo.

### `init.el`, generato dal documento

`init.el` sono due righe di codice vero:

```org
#+BEGIN_SRC emacs-lisp :tangle init.el :comments no :mkdirp yes
;;; init.el --- Carica configurazione literate da config.org  -*- lexical-binding: t; -*-
;; ...
(require 'org)
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
#+END_SRC
```

Sono due apposta: se qualcosa va storto nel documento, il punto d'ingresso resta così semplice che il debug si fa a occhio. `org-babel-load-file` confronta le date di `config.org` e `config.el`, rifà il tangle solo se il documento è più nuovo e poi carica il risultato. Finché non tocco il documento, Emacs non riprocessa niente.

L'header del blocco è la parte interessante: `:tangle init.el` fa sì che il documento contenga il file che lo carica. Se perdo `init.el`, lo rigenero dal documento. Ha qualcosa del barone di Münchhausen che si tira fuori dalla palude per il codino, ma funziona.

## Pacchetti con il lockfile

Per i pacchetti uso [straight.el](https://github.com/radian-software/straight.el). `package.el` scarica archivi da un repository centrale e dà l'ultima versione disponibile in quel momento; straight clona i repository git dei pacchetti e sa a quale commit stanno. Dopo il bootstrap, due righe lo collegano a `use-package`:

```elisp
;; Installa use-package tramite straight
(straight-use-package 'use-package)

;; Configura use-package per usare straight come backend di default
;; Questo rende implicito :straight t in ogni dichiarazione use-package
(setq straight-use-package-by-default t)
```

Da qui in poi ogni `use-package` nel documento è anche un'istruzione di installazione. Il pacchetto si dichiara nel capitolo che lo spiega, non in un elenco in testa al file.

Il pezzo che rende tutto riproducibile è `straight/versions/default.el`, il lockfile, con l'hash del commit di ognuno dei circa cento pacchetti:

```elisp
(("ace-window" . "77115afc1b0b9f633084cf7479c767988106c196")
 ("acp.el" . "2959da5fa8657da17a78ac6ceef303a50e3e69de")
 ("adoc-mode" . "0a09281d337a2512858c096225b60d9e7a0e7911")
 ...
```

Lo committo insieme al documento. Quando straight clona un pacchetto che non ha ancora, fa il checkout del commit scritto lì, quindi su una macchina nuova i pacchetti arrivano alle stesse versioni di casa. Per aggiornare c'è un comando solo, nell'epilogo, e finché non lo lancio non cambia niente:

```elisp
(defun my/update-packages ()
  "Aggiorna tutti i pacchetti gestiti da straight.el. ..."
  (interactive)
  ;; ...
  (straight-remove-unused-repos)
  (straight-pull-all)
  (straight-rebuild-all)
  (straight-freeze-versions t)
  (message "Aggiornamento completato. Riavvio in corso...")
  (restart-emacs))
```

### Quello che Emacs ha già

Con Org e straight c'è un problema noto. `org-babel-load-file` usa l'Org incluso in Emacs per leggere il documento, quindi quello si carica per forza prima di tutto il resto; se poi straight ne scarica un altro, Org avvisa del *version mismatch* con un messaggio lunghissimo e molto educato, che elenca le quattro cause più probabili. In una configurazione literate è quasi sempre la prima. La soluzione più semplice è non combattere:

```elisp
;;; Corregge il mismatch di versione di Org built-in evitando il download da parte di straight
(use-package org
  :ensure nil
  :straight (:type built-in))

;;; Transient built-in in Emacs 30+ è troppo vecchio, forza straight a scaricarlo da MELPA
(use-package transient
  :straight (:type git :host github :repo "magit/transient"))
```

Transient fa il percorso opposto: Magit corre più veloce dei rilasci di Emacs, quindi lo prendo da git. E per i pacchetti che Emacs 31 include a una versione uguale o più recente di MELPA c'è una variabile apposta, che a differenza di `:straight (:type built-in)` vale anche quando il pacchetto arriva come dipendenza di un altro:

```elisp
;; Emacs 31 fornisce questi pacchetti a versione uguale o superiore a quella su MELPA.
;; Aggiungendoli qui straight li salta sia come dichiarazione diretta sia come
;; dipendenza di altri pacchetti (jsonrpc arriva da eglot-java).
(dolist (pkg '(which-key editorconfig jsonrpc))
  (add-to-list 'straight-built-in-pseudo-packages pkg))
```

C'è di nuovo which-key, e non per caso: è lo stesso giro di verifiche che mi ha portato a `early-init.el`.

## Prologo ed epilogo

Il garbage collector durante l'avvio cambia soglia tre volte, e ognuna sta in un punto diverso: `most-positive-fixnum` in `early-init.el`, 100 MB nel prologo, il default storico di circa 800 kB nell'epilogo (un valore dei tempi in cui, secondo i maligni, EMACS stava per *Eight Megabytes And Constantly Swapping*).

```elisp
;; Prologo
(setq gc-cons-threshold 100000000)

(defvar emacs-start-time (current-time)
  "Timestamp dell'inizio del processo di inizializzazione.")

;; ... tutti gli altri capitoli ...

;; Epilogo
(setq gc-cons-threshold 800000)

(add-hook 'emacs-startup-hook
          (lambda ()
            (let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
              (message "Emacs caricato in %.3f secondi con %d garbage collections."
                       elapsed
                       gcs-done))))
```

Il messaggio finale serve a una cosa sola: accorgermi subito quando un pacchetto nuovo raddoppia il tempo di avvio. La misura parte dal prologo e non da `before-init-time`, quindi non conta `early-init.el` e il caricamento di Org; per confrontare un avvio con l'altro va bene così.

## La stessa configurazione, in un container

Con `early-init.el` la configurazione non dipende più da `site-lisp`, ma dipende ancora da cosa c'è installato: Java, pandoc, typst, un compilatore C. Su una macchina dove non posso installare niente (quella di un cliente, un server senza root) quelle cose non ci sono. Per quei posti il documento genera anche il `Dockerfile` e gli script di un'immagine container, con Emacs, i prerequisiti di sistema e l'intero albero dei pacchetti già clonato e compilato. Fuori, come volumi, restano `~/org`, `~/.gnupg` e `~/.password-store`; le chiavi API arrivano da variabili d'ambiente e nell'immagine non vengono mai scritte. Chi dice che Emacs è un ottimo sistema operativo a cui manca solo un buon editor, adesso ha un argomento in più, visto che ha pure la sua immagine container.

Il passaggio delicato è la build, perché un'immagine che clona pacchetti dalla rete dà due ambienti diversi a un mese di distanza. Il `Dockerfile`, estratto dal capitolo Container, risolve così:

```dockerfile
# Provisioning: fissa le versioni dal lockfile, poi carica la configurazione
# per intero. Questo clona e compila i pacchetti, scarica i jar di PlantUML,
# Ditaa e Lombok, e compila le grammatiche tree-sitter. Alla fine dell'immagine
# non serve piu' la rete per partire.
# Nota: i cloni shallow (straight-vc-git-default-clone-depth 1) farebbero
# risparmiare 340 MB di storia git, ma rompono straight-thaw-versions, che
# ha bisogno di "git branch --track" e in batch fallisce senza rimedio.
# La riproducibilità dal lockfile vale più dello spazio: cloni interi.
RUN emacs --batch -l ~/.emacs.d/early-init.el -l ~/.emacs.d/init.el \
          --eval '(straight-thaw-versions)'
```

Lo stesso lockfile della macchina di casa, quindi le stesse versioni. Il capitolo racconta anche la prima build fallita: l'immagine base aveva Emacs 30.2, sull'host la 31.1 arriva da un repository OBS che avevo configurato tanto tempo fa da essermene dimenticato, e un `add-hook` innocuo è esploso quando straight ha aperto il primo file elisp da compilare.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-6 text-center" markdown="1">
![Vignetta di xkcd. Il grafico "teoria" mostra che automatizzare un compito richiede un po' di lavoro e poi libera tempo; il grafico "realtà" mostra che il lavoro per automatizzare cresce senza fine e il compito originale non viene mai fatto.]({% link media/2026-11-19/guide/xkcd-1319-automation.png %}){: .img-fluid }

*Chiunque abbia una configurazione Emacs riconosce il secondo grafico. Il capitolo Container ne è un esempio da manuale. [xkcd 1319, "Automation"](https://xkcd.com/1319/), di Randall Munroe, licenza CC BY-NC 2.5.*
</div>
</div>

## Le istruzioni per l'agente

Da circa un anno la configurazione la modifico spesso insieme a un agente LLM. Su dieci anni di lavoro è l'ultimo arrivato, e mi ha fatto andare più veloce, non mi ha reso capace di farlo. Un agente su un documento di diecimila righe fa danni con la stessa velocità con cui fa cose utili, se nessuno gli dice come è fatto il posto.

Nella cartella della configurazione c'è un `AGENTS.md`, in inglese, che non pubblico. Contiene i fatti stabili del repository, quelli che darei a un collega nuovo il primo giorno: si modifica sempre `config.org` e mai `config.el`; la prosa è in italiano, in prima persona, con la mia voce; un pacchetto nuovo va nel capitolo che tratta quell'argomento, con il paragrafo che lo spiega prima del blocco; i percorsi passano da `expand-file-name`. C'è la tabella dei prefissi di tastiera riservati (`C-c n` per org-roam, `C-c l` per l'IA, `C-c m` per la matrice di Eisenhower e così via), perché altrimenti ogni comando nuovo finisce sul primo tasto libero e dopo qualche mese la tastiera diventa una *slot machine*: premi una combinazione e non sai cosa esce, magari è il giro fortunato e azzecchi la funzione, magari hai perso e scateni tutt'altro. E ci sono i due comandi batch che l'agente deve lanciare prima di dire che una modifica funziona, cioè il tangle e un avvio completo di prova. In fondo, la lista degli errori già fatti: per esempio, mai `batch-byte-compile` su `config.el`, che senza `init.el` non avvia straight e produce cinquanta errori finti che un agente zelante si metterebbe a "correggere".

Il commit resta mio, dopo aver provato la modifica in una sessione vera: il batch dice che la configurazione si carica, non che fa quello che volevo.

Il pezzo che conta di più però non sta nella cartella. È il system prompt, le istruzioni generali che valgono per ogni sessione e per ogni progetto: come scrivere, quando fermarsi a chiedere, cosa non decidere da solo, quanto spingersi. Non lo pubblico. Ma se c'è una cosa da fare con un LLM, locale o in cloud che sia, è scriversi il proprio: è quello che tara il livello a cui lo strumento esegue, molto più del modello scelto.

## Anche in slide

Essendo un documento, si esporta: HTML, PDF, ODT, Markdown e presentazioni [reveal.js](https://revealjs.com/) con [org-re-reveal](https://gitlab.com/oer/org-re-reveal). Nel testo ci sono circa 260 righe `#+REVEAL: split` che spezzano le sezioni lunghe in più slide, e `C-c C-e R R` fa il resto. reveal.js lo gestisce straight come un pacchetto qualsiasi, e il commit lo fissa il lockfile come per tutti gli altri, così le presentazioni funzionano anche offline:

```elisp
(straight-use-package
 '(reveal :type git
          :host github
          :repo "hakimel/reveal.js"
          :files ("*.html" "*.js" "css" "dist" "plugin")))
```

Fino a poco tempo fa nella recipe c'era anche un `:ref "4.5.0"`, con il commento "tag specifico bloccato per stabilità". Peccato che `:ref` sia sintassi di elpaca: straight conosce solo le keyword di `straight-vc-git-keywords` e le altre le ignora senza dire niente. Il README lo scrive chiaro, per fissare un commit si usa il lockfile. Intanto reveal.js è salito tranquillo alla 6, un `my/update-packages` dopo l'altro, e io ero convinto di averlo fermo alla 4.5.

Quando un collega mi chiede come faccio a tenere in piedi una roba del genere, aprire la configurazione in slide e scorrerla insieme risponde meglio di qualunque spiegazione.

## Fonti

- Donald E. Knuth, ["Literate Programming"](https://doi.org/10.1093/comjnl/27.2.97), *The Computer Journal* 27(2), 1984, pp. 97-111.
- Eric Schulte, Dan Davison, Thomas Dye, Carsten Dominik, ["A Multi-Language Computing Environment for Literate Programming and Reproducible Research"](https://doi.org/10.18637/jss.v046.i03), *Journal of Statistical Software* 46(3), 2012: il paper di org-babel.
- Jeremy H. Brown, ["Yak Shaving"](https://projects.csail.mit.edu/gsb/old-archive/gsb-archive/gsb2000-02-11.html), mail all'AI Lab del MIT, 11 febbraio 2000: l'origine del termine, attribuito a Carlin Vieri.
- [Gist con `config.org` anonimizzato](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a), in italiano e in inglese.
- [Org mode, "Extracting Source Code" (tangle)](https://orgmode.org/manual/Extracting-Source-Code.html), manuale di Org.
- [GNU Emacs Lisp Reference Manual, "Startup Summary"](https://www.gnu.org/software/emacs/manual/html_node/elisp/Startup-Summary.html), ordine di caricamento dei file di avvio.
- [systemd.service, `ExecStart=`](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#ExecStart=), azzeramento e comandi multipli.
- [straight.el](https://github.com/radian-software/straight.el), gestore di pacchetti basato su git, sezione sui lockfile.
- [org-re-reveal](https://gitlab.com/oer/org-re-reveal) e [reveal.js](https://revealjs.com/).
- Randall Munroe, ["Automation"](https://xkcd.com/1319/), xkcd 1319, CC BY-NC 2.5.
- Randall Munroe, ["Fixing Problems"](https://xkcd.com/1739/), xkcd 1739, CC BY-NC 2.5.
- Randall Munroe, ["Real Programmers"](https://xkcd.com/378/), xkcd 378, CC BY-NC 2.5.
