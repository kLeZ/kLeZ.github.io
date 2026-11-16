---
title: "Emacs nell'età della magia"
tags:
- sviluppo-software
- ia
- emacs
- org-mode
- llm
category: saggio
date: 2026-11-16 10:28:00+01:00
---

Oggi vi parlo di Emacs, e di un testo che lo dà per spacciato proprio adesso che, secondo me, sta per vivere la sua stagione migliore. Si intitola [*Emacs In the Age Of Magic*](https://commandlinesystems.com/magic.txt), è un file di testo puro di quasi duemila parole, e sostiene che gli agenti di programmazione abbiano spazzato via in un colpo solo tutti i vantaggi su cui noi utenti Emacs abbiamo campato per decenni.

L'ho segnato un giovedì mattina, alle otto e mezza, nella lista delle cose di cui scrivere, con una nota che diceva più o meno: un articolo su come ho organizzato la mia vita e il mio lavoro con Emacs, Org e Claude, e questo testo come spunto. Doveva essere uno spunto. È diventato un bersaglio.

Io la penso esattamente al contrario. Un software che ha mezzo secolo sulle spalle ed è ancora vivo proprio perché si lascia piegare a qualunque cosa, in un'epoca in cui un'IA ti riscrive da zero qualunque programma che non si lascia piegare, ha davanti un rinascimento, altro che pensione.

{% include more.html %}

## Cosa dice, preso sul serio

Il testo merita di essere ricostruito per bene, perché non è il solito sfogo da forum. Parte da lontanissimo: l'era digitale come l'epoca in cui un transistor sigillato ti dà sempre la stessa uscita a parità di ingresso, i sistemi esperti che i programmatori guardavano dall'alto in basso, la divisione tra Cambridge e Murray Hill raccontata da Richard Gabriel, il Lisp dell'accademia contro il C dell'industria. Dopo questa premessa, che lo stesso autore definisce "prolissa" (e su questo non gli si può dare torto), arriva finalmente a Emacs.

> citation "Emacs In the Age Of Magic" [https://commandlinesystems.com/magic.txt]
> Velocità di scrittura, personalizzazione, l'espressività del Lisp: ogni vantaggio che rivendicavamo è svanito nel momento in cui abbiamo smesso di scrivere e abbiamo cominciato a dire all'IA cosa volevamo. Forse ci sentivamo al sicuro, presentandoci con una pistola a una rissa con i coltelli, ma adesso tutti mandano un drone.
>
> Editing speed, customization, the expressiveness of LISP: every advantage we claimed vanished the moment we stopped typing and started telling the AI what we wanted. We may have felt safe bringing a gun to a knife fight, but now everyone's just sending a drone.
> {: .citation-original lang="en"}

L'esempio che fa è Magit, e qui ha ragione da vendere. Il balletto di `C-x g`, `S`, `c c`, il messaggio di commit scritto di corsa e `C-c C-c` per chiudere era il nostro piccolo vanto. Oggi Claude Code ti propone un "commit" in grigio dopo ogni blocco di modifiche, e basta un *tab-return*. Chiunque abbia usato un agente per più di una settimana sa che è così.

Poi racconta due casi di studio, con un sarcasmo che a tratti mi ha fatto proprio ridere. Il primo è `excali-mode.el`, cioè Excalidraw portato sul nuovo widget canvas di Emacs. L'autore si immagina come sia andata: il ragazzo chiede a Qwen di usare il canvas, il modello gli propone un browser integrato, il ragazzo insiste, e alla fine il modello si reimplementa l'intero stack di Excalidraw strato per strato, da JavaScript a Elisp, dal Canvas del browser a Cairo e Pango. Il secondo è `cooked.el`: su r/emacs si discute di come avere un terminale che si comporti come un buffer di testo, e qualche giorno dopo un liceale pubblica la sua soluzione, con dentro un emulatore di terminale completo scritto in Rust. L'autore la chiama "un Boeing costruito in giardino quando volevi solo disegnare una cloche nuova", e anche qui ha ragione: sono esercizi assurdi, che nessuno si sarebbe mai sognato di tentare quando il codice si pagava in ore di lavoro.

> citation "Emacs In the Age Of Magic" [https://commandlinesystems.com/magic.txt]
> Che ironia: l'IA ha capovolto l'obiettivo di Stallman, la libertà del software. Avere un computer che fa qualunque cosa la tua immaginazione riesca a pensare: questa sì che è libertà. L'unico problema è che non avrai idea di come funziona. Nessuno ce l'ha.
>
> The irony is rich that AI has turned Stallman's goal of software freedom on its head. Having your computer do whatever your imagination can think up -- that's real freedom. The only catch is you'll have no idea how it works. No one does.
> {: .citation-original lang="en"}

Il testo non è firmato, però il sito che lo ospita promuove [commercial-emacs](https://github.com/commercial-emacs/commercial-emacs), un fork di GNU Emacs con Gnus non bloccante, la gestione dei processi riscritta e un garbage collector che sposta gli oggetti in memoria, ancora sperimentale, e vende consulenza su Emacs come piattaforma. Se chi scrive è la stessa persona che lavora sul fork, come dal sito sembra, il pessimismo viene da uno che su Emacs ci ha investito parecchio, e va preso sul serio. Ed è proprio per questo che il punto dove secondo me sbaglia vale la pena di guardarlo da vicino.

## Il drone va a coltelli

Per come la leggo io, il ragionamento non si ferma a Emacs. Se l'editor che vive nel terminale ha perso i suoi vantaggi perché basta dire all'agente cosa vuoi, il passo successivo è che li abbia persi tutto il terminale: la shell, `grep`, `find`, `sed`, le mille utility a riga di comando che uno come me usa da vent'anni. Il testo non lo scrive con queste parole, ma la metafora del drone va a parare lì: le CLI sono roba da vecchi, tanto adesso c'è la chat.

Il punto debole, però, sta proprio nell'esempio che ha scelto. Quel *tab-return* lancia `git commit`. Il drone, quando arriva sul campo, tira fuori i coltelli.

Claude Code è un programma a riga di comando. Il suo strumento principale è una shell, e sul mio computer lavora esattamente come lavorerebbe un sistemista paziente e velocissimo: legge i file con `cat` e `sed`, cerca con `grep`, si muove con `find`, interroga GitLab con `glab` e GitHub con `gh`, scarica pagine con `curl` e le filtra con `jq`. Quando deve leggere o modificare i miei task in Org chiama `emacsclient --eval` e parla con l'Emacs che ho già acceso. Della riga di comando, l'agente è diventato l'utente più accanito che ci sia.

![Diagramma: io chiedo una cosa a Claude Code, che è un programma a riga di comando; con un tab-return Claude Code passa dalla shell, e dalla shell usa cat, sed, grep e find, git, glab e gh, curl e jq, ed emacsclient --eval, che parla con l'Emacs già acceso dove stanno i miei task in Org.]({% link media/2026-11-15/saggio/drone-coltelli.svg %}){: .img-fluid }

Non è un caso. La riga di comando è fatta di programmi che leggono testo e scrivono testo, si compongono in una pipe e si documentano da soli con una pagina di manuale: è la forma di interfaccia più vicina al modo in cui ragiona un modello linguistico. Un programma che parla solo con bottoni e finestre, per un agente, è un muro, o al massimo uno screenshot da interpretare, mentre un programma che legge e scrive testo è una porta spalancata.

Qui il discorso torna su Emacs, che di questa idea è la versione estrema. Tutto è un buffer di testo, ogni azione è una funzione con un nome, e ogni funzione si può chiamare da fuori. Per un agente Emacs è il terminale più ricco che esista.

![Vignetta di xkcd. Davanti a una bomba, un personaggio deve scrivere un comando tar valido al primo colpo per disinnescarla, e non ricorda le opzioni.]({% link media/2026-11-15/saggio/xkcd-1168-tar.png %}){: .img-fluid }

*Una cosa va riconosciuta al drone: le opzioni di `tar` se le ricorda. [xkcd 1168, "tar"](https://xkcd.com/1168/), di Randall Munroe, licenza CC BY-NC 2.5.*

## Piegare o riscrivere

Quando chiedere a un'IA di riscriverti un programma da zero costa poco, ogni software si ritrova davanti alla stessa domanda: lo pieghi, o lo rifai?

A inizio ottobre Brandon Thomas ha pubblicato [ArtCraft](https://thedieline.com/artcraft-launches-an-open-source-ai-powered-alternative-to-adobes-creative-cloud/), una suite open source di sette applicazioni che vogliono prendere il posto di quelle di Adobe, da Photoshop a Premiere, da Illustrator ad Acrobat. È scritta in Rust, con Claude, e dopo un paio di settimane il solo PhotoCraft aveva già circa 67.500 stelle su GitHub. È ancora un'alfa, gli stessi autori dicono che per il lavoro professionale non basta, e tra i suoi limiti c'è (non me lo sono inventato) la compatibilità con i plugin. Il motivo dichiarato sono gli abbonamenti, ma secondo me sotto c'è anche altro. Photoshop i plugin li ha, ma dentro il recinto che decide Adobe: non puoi prendere il programma e piegarlo a quello che serve a te. Se Adobe avesse permesso di estendere la suite in modo arbitrario, buona parte di quella frustrazione sarebbe finita in estensioni invece che in una riscrittura, e ArtCraft oggi non esisterebbe, o sarebbe un progetto un po' meno virale di così.

E non è una questione di software chiuso contro software libero. LibreOffice è libero, ma è un monolite: le estensioni passano dalle API UNO, scriverne una è un progetto a sé, usarle non è proprio una passeggiata, e nel 2026 un negozio delle estensioni decente ancora non c'è. Se LibreOffice si fosse lasciato piegare come Emacs, oggi, con un agente in mano, sarebbe lo strumento del secolo. Invece chi vuole un programma di scrittura fatto a modo suo chiede a un agente di scriversene uno nuovo.

Emacs sta all'altro capo. Ogni funzione si può ridefinire mentre gira, ogni variabile si può cambiare, ogni tasto rimappare, e con un *advice* puoi infilarti prima, dopo o al posto di qualunque comando, compresi quelli che non hai scritto tu. È l'estensione arbitraria presa alla lettera. Emacs non lo devi riscrivere: lo pieghi.

Per decenni, però, piegarlo aveva un prezzo. Chiunque abbia provato a usarlo sul serio conosce la curva di apprendimento, quella dei meme con la linea che sale in verticale e poi torna indietro su sé stessa. Un sacco di gente ha mollato, perché per fargli fare le cose dovevi imparare Elisp, leggerti il manuale, buttare i fine settimana dietro alla configurazione e accettare che il tuo editor fosse un cantiere senza fine. Il vantaggio che rivendicavano gli utenti Emacs era reale, ma era il vantaggio di chi il biglietto l'aveva pagato, e la maggior parte delle persone, giustamente, aveva altro da fare.

![Grafico scherzoso delle curve di apprendimento degli editor. Il Blocco note resta piatto in basso; VS Code sale dolcemente; vi è un muro verticale con la nota "prima devi uscire da vi"; Emacs sale facendo una serie di riccioli all'indietro, con la nota "stavi configurando Emacs"; Emacs con un agente, tratteggiato, sale ripido e senza riccioli fin quasi in cima.]({% link media/2026-11-15/saggio/curve-di-apprendimento.svg %}){: .img-fluid }

Gli agenti il prezzo del biglietto l'hanno abbattuto, e il valore l'hanno lasciato dov'era. Se piegare un programma ti costa dieci minuti invece di un weekend, ci guadagna di più il software che si lascia piegare di più, e da cinquant'anni nessun software si lascia piegare quanto Emacs. La plasmabilità, che era il suo difetto da spiegare ai colleghi, nell'epoca in cui qualunque programma si può riscrivere da zero diventa un superpotere: tutti gli altri li rifai, lui lo cambi.

L'autore direbbe, e in parte lo dice citando l'articolo *The Emacsification of Software*, che a quel punto ognuno avrà il suo piccolo Emacs e si farà generare il visualizzatore di Markdown come piace a lui, il client di posta come piace a lui, ed Emacs perderà l'esclusiva. È l'obiezione più seria di tutto il testo, ed è esattamente quello che succede ai programmi che non si lasciano piegare: ArtCraft ne è l'esempio più fresco. Secondo me, però, la risposta sta nella differenza tra un programma e un ambiente.

Il programma usa e getta che l'agente ti scrive in dieci minuti è un'isola. Ha le sue scorciatoie, il suo formato di file, il suo modo di salvare le impostazioni, e non sa niente degli altri programmi usa e getta che ti sei fatto fare la settimana prima. Ogni isola in più è un pezzo di complessità che ti devi tenere in testa tu. In Emacs lo stesso lavoro finisce dentro un ambiente che c'era già, con gli stessi buffer, gli stessi tasti, la stessa ricerca e gli stessi file Org dove stanno i miei appunti e i miei task, e il pezzo nuovo si incastra con quelli vecchi invece di mettersi di fianco.

In Emacs, poi, la documentazione sta dentro l'editor stesso: un agente gli può chiedere cosa fa una funzione, a che tasto è legato un comando, quali variabili ha una modalità, e la risposta è sempre quella vera, del codice che sta girando in quel momento. Non deve tirare a indovinare, ed è lo stesso motivo per cui con la shell lavora bene e con un'interfaccia grafica male.

E c'è un dettaglio che all'autore sfugge: i suoi due esempi di spreco, `excali-mode.el` e `cooked.el`, sono pacchetti Emacs. Chi li ha scritti aveva a disposizione quella che lui chiama "una macchina divina", poteva farsi generare qualunque applicazione, e ha scelto di scriverla per Emacs. Le scelte tecniche sono discutibili, e il sarcasmo dell'autore ci sta tutto, ma restano il prodotto di gente che, con un agente in mano, ha deciso di costruire dentro Emacs.

## Una configurazione scritta a quattro mani

La mia prova ce l'ho sulla scrivania, ed è il file `config.org` che sta in `~/.emacs.d`.

La mia configurazione di Emacs è un documento in *literate programming* da anni, e su questo blog vi ho già raccontato [perché per me è il modo giusto di scrivere codice che deve durare]({% post_url 2025-04-20-literate-programming-org-mode %}). Il codice Elisp sta dentro blocchi sorgente, e la prosa intorno spiega cosa fa ogni pezzo e soprattutto perché l'ho scelto. All'avvio Emacs tira fuori il codice e lo esegue.

Il 7 novembre 2025 l'ho riscritta da capo insieme a Claude Code: un solo commit, circa 9.500 righe nuove. Oggi `config.org` supera le 10.000 righe, in italiano, in prima persona e con la mia voce. Nella stessa cartella c'è un `AGENTS.md` che spiega a qualunque agente come è fatta: si modifica solo il documento e mai il file generato, i pacchetti si installano in un certo modo, e prima di dire che una modifica funziona si lanciano due comandi precisi in batch. Sono le stesse regole che darei a un collega nuovo il primo giorno.

Più della quantità, però, conta che l'agente mi ha aperto strade che da solo non avrei percorso. Un esempio è il cheatsheet che si apre con `F7`. Volevo un modo per ricordarmi i comandi che uso poco, e il classico which-key non mi bastava, perché risponde alla domanda "cosa c'è legato a questo tasto" e a me serviva "come si fa questa cosa". Ne è uscito un cheatsheet con i comandi scelti a mano, diviso per argomento, che ti mostra prima le sezioni che servono nel buffer in cui sei. I tasti non li scrive nessuno a mano: li legge Emacs dalle keymap vere nel momento in cui apro la vista, quindi se cambio un binding il cheatsheet si aggiorna da solo. Dallo stesso elenco viene fuori il capitolo di riferimento in fondo a `config.org`, e un comando di controllo mi avvisa quando definisco un tasto e mi scordo di censirlo.

La cosa buffa è che la soluzione che avevo in testa io era un'altra: un menu Transient per ogni area, come quello che già usavo per l'IA. Ne abbiamo discusso come si discute una decisione di architettura, con un ADR e una matrice di Pugh, e i menu hanno perso: davano la scoperta e l'esecuzione, ma non un quadro d'insieme, e avrei dovuto scriverne e mantenerne uno per ogni area. I dati curati costavano di più da costruire e quasi niente da mantenere. È finita più due a meno uno, e ha vinto la strada che io non avevo nemmeno considerato.

Niente di tutto questo sarebbe possibile se Emacs non ti lasciasse mettere le mani dappertutto. Il cheatsheet funziona perché Emacs sa sempre, in ogni momento, quale tasto porta a quale comando, e lo dice a chiunque glielo chieda. Il codice l'ha scritto l'agente, ma la possibilità c'era già da decenni: mancava solo qualcuno con il tempo di sfruttarla.

Come è fatta la configurazione, pezzo per pezzo, lo racconto in una serie di guide che escono nelle prossime settimane: la configurazione come documento, il cheatsheet, i task, il secondo cervello, l'IA, la scrittura e l'IDE.

## La matrice di Eisenhower, sette anni dopo

Il cheatsheet è una cosa a cui da solo non avrei mai pensato. L'esempio che mi convince di più, però, riguarda una cosa che avevo già e che funzionava pure male.

Nel 2019 ho [ripubblicato qui un articolo di Tom Purl]({% post_url en/2019-10-22-using-the-eisenhower-matrix-in-emacs-org-mode %}) su come usare la matrice di Eisenhower in Org mode: due tag, `important` e `urgent`, e quattro ricerche nell'agenda, una per quadrante, da aprire una alla volta. Le ho copiate nella mia configurazione a dicembre di quell'anno e me le sono trascinate dietro per anni.

Erano quattro viste separate, da aprire una alla volta, e il quadro d'insieme dovevo ricomporlo a mente. Il quadro a mente, alle otto di mattina, prima del caffè, non me lo ricompongo, e infatti per anni la matrice l'ho guardata molto meno di quanto le avessi promesso.

Con la riscrittura del 2025 quelle righe sono rimaste nella vecchia configurazione, che non carico più, e al loro posto è spuntata una funzione che costruiva un buffer di puro testo: icona, età, titolo. Leggibile, ma inutile, perché nessuna riga sapeva da quale task veniva, e su un file con una settantina di task aperti per cambiare stato a uno dovevo andarmelo a ripescare a mano. Infatti ho smesso di usarla.

A settembre di quest'anno ci sono tornato sopra, e stavolta sono partito da quello che ci dovevo fare: una vista in sola lettura dove ogni azione su una riga finisce nel file da cui viene il task. La decisione è passata da un ADR con tre alternative (costruire la vista sull'agenda di Org, usare org-super-agenda, scrivermi una modalità tutta mia), confrontate con una matrice di Pugh rispetto alla versione che c'era. Ho scelto la prima, che non aggiunge dipendenze e si porta dietro tutti i comandi dell'agenda.

Oggi `C-c m` mi apre la matrice del file in cui sono. Ogni quadrante ha il suo titolo colorato e il numero di task, e accanto a ogni task ci sono l'età in giorni (gialla oltre i 30, rossa oltre i 90) e la voce padre al posto del percorso completo. Dentro un quadrante vengono prima i task in corso, poi quelli che ho scelto per i prossimi giorni, poi tutto il resto. I tasti da `1` a `4` spostano il task sotto il cursore nel quadrante corrispondente, e tutti gli altri comandi dell'agenda (cambiare stato, pianificare, aprire il task) lavorano direttamente sul file.

Due problemi sono saltati fuori solo provandola. L'agenda di Org tiene i riferimenti tra righe e task in una variabile globale, quindi bastava aprire un'altra agenda perché le righe della matrice puntassero nel vuoto. E Org ridipinge ogni riga con la face di default, cancellando i colori dell'età. Tutti e due sono spiegati in `config.org`, accanto al codice che li aggira.

La lista di testo era venuta fuori da una riscrittura di diecimila righe in cui la matrice era un dettaglio tra mille. La versione che uso adesso è nata da un requisito scritto, da un confronto tra alternative fatto prima di scrivere una riga di codice e da una scelta mia, con la spiegazione accanto a ogni blocco. L'agente era lo stesso, è cambiato il modo in cui ci ho lavorato io.

Oggi la apro ogni mattina, durante la revisione. Per ogni quadrante scelgo i NEXT, con un tetto preciso (tre in Q1, tre in Q2, uno in Q3, cinque in Q4), e l'agente della routine del mattino me li propone già: io confermo, sposto, scarto. Il colore dell'età fa il resto. Un task rosso in Q2 è una decisione che sto rimandando da più di tre mesi, e vederlo rosso tutte le mattine, prima o poi, fa il suo effetto.

## Un pacchetto fatto per uno sciame

Il secondo pezzo di prova è [blueprint.el](https://github.com/kLeZ/blueprint.el), un pacchetto che ho scritto per un lavoro che mi capita spesso di fare: ricostruire la documentazione architetturale di sistemi software che non ce l'hanno, partendo dal codice.

È nato come script Python. A un certo punto mi sono accorto che tutto il flusso di lavoro viveva già dentro Emacs e Org, e che chiamare Python per manipolare file che Org sa gestire da solo era un passaggio inutile. Così l'ho riscritto in Elisp, o meglio, di fatto l'ha riscritto un agente: oggi sono circa 9.600 righe di Elisp in 36 file, più 29 file di test.

In pratica il codice l'ha scritto lui e le decisioni le ho prese io: cosa fare, come strutturarlo, quando il suo codice non andava bene e quando era il caso che si facesse una passeggiata. Il rapporto, diciamo, non è paritario, e nel [post dedicato a blueprint.el]({% post_url 2026-11-15-blueprint-el %}) racconto anche con che tono glielo ricordo.

Qui però mi interessa soprattutto per chi è fatto. blueprint non usa un modello linguistico al suo interno (c'è un'integrazione opzionale con Ollama, ma è un accessorio). Lo chiamo *agentico* perché è progettato per essere usato da più agenti in modo concorrente. Ogni componente del sistema documentato ha tre file separati, uno per l'architettura, uno per le specifiche funzionali e uno per l'infrastruttura, e le parti trasversali (rischi, vincoli, glossario, fonti, decisioni) hanno i loro file. Ogni file è una zona che un agente si può prendere in carico senza pestare i piedi agli altri. I punti aperti sono marcatori nel testo, come `QUESTION` o `TBD`, che il pacchetto conta per calcolare un punteggio di salute del documento, e per un agente sono già la lista di quello che resta da fare. E ogni funzione si può chiamare da riga di comando con `emacs --batch`, mentre lint, validazione ed export escono con codici precisi.

Lo stesso pacchetto si usa benissimo anche a mano, da un menu Transient sotto `C-c b`, come si userebbe Magit, ma con più agenti che ci lavorano sopra in parallelo, ognuno nella sua zona, rende molto di più. A chi lo usa restano le decisioni: una `QUESTION` è il punto in cui l'agente si ferma e la palla torna a una persona.

Il resto, dalla struttura dei file al punteggio di salute, fino ai comandi che un agente chiama da riga di comando, sta nel [post dedicato a blueprint.el]({% post_url 2026-11-15-blueprint-el %}).

Anche qui Emacs fa quello che ha sempre fatto: testo, funzioni con un nome, tutto richiamabile da fuori. Solo che adesso dall'altra parte c'è qualcuno capace di sfruttarlo a velocità industriale.

## Sapere come funziona

Resta la frase finale del testo, quella che mi ha dato più fastidio, anche perché in parte la penso come lui: "Non avrai idea di come funziona. Nessuno ce l'ha."

Ho scritto un post intero, [Il software che non puoi smontare]({% post_url 2026-02-03-il-software-che-non-puoi-smontare %}), su quanto mi irriti usare sistemi che non posso capire, e sarei incoerente se adesso difendessi un pacchetto da migliaia di righe scritto in gran parte da un agente facendo finta che il problema non ci sia. Il problema c'è, e `excali-mode.el` ne è il caso perfetto: un'applicazione intera tradotta da un modello in un altro linguaggio, di cui con ogni probabilità nessun essere umano conosce ogni riga.

Secondo me, però, il non capire dipende da come lavori più che dallo strumento che usi. Se chiedi a un agente di generarti un programma e lo usi senza guardarlo, non saprai mai come funziona, che tu stia usando Emacs o qualunque altra cosa. Se invece lo fai lavorare dentro un documento che leggi, il discorso cambia.

La mia configurazione è scritta in modo che ogni blocco di codice abbia accanto un paragrafo che spiega perché è lì. Quando l'agente aggiunge qualcosa, aggiunge anche la spiegazione, nella mia lingua, e io la leggo. Le regole con cui lavora stanno in un file che posso aprire quando voglio. blueprint ha i suoi test, i suoi ADR e un `AGENTS.md` che dice all'agente cosa può fare e cosa no. È tutto testo, tutto sotto controllo di versione, e lo leggo con lo stesso editor con cui sto scrivendo questo post.

Knuth il *literate programming* l'ha inventato negli anni Ottanta per costringere i programmatori a spiegare il proprio codice a un essere umano. Quarant'anni dopo, la stessa disciplina mi serve per costringere un agente a spiegare il suo codice a me, e il posto dove quella spiegazione si scrive è Org mode, che sta dentro Emacs.

Non leggo tutto, e sarebbe ridicolo dire il contrario. Leggo sempre la prosa che l'agente scrive accanto al codice, perché è lì che si vede se ha capito cosa doveva fare. Leggo i diff dei pezzi che toccano le cose a cui tengo, cioè i miei dati, i miei task e tutto quello che ha a che fare con la sicurezza, e leggo i test. Il codice di routine, quello che fa esattamente quello che la spiegazione dice, lo leggo a campione. È lo stesso patto che avrei con un collega bravo: mi fido, ma la porta resta aperta e controllo quando voglio.

Su una cosa l'autore ha ragione: un computer che fa qualunque cosa l'immaginazione riesca a pensare è una forma di libertà. Solo che è la stessa promessa che Emacs fa dal 1976, quando era ancora un pacchetto di macro per TECO. La differenza è che oggi quella libertà costa dieci minuti invece di dieci anni, e io la spesa me la segno in un file Org.

## Fonti

- *Emacs In the Age Of Magic*, testo non firmato, [commandlinesystems.com/magic.txt](https://commandlinesystems.com/magic.txt).
- Command Line Systems, pagina di presentazione di commercial-emacs, [commandlinesystems.com](https://commandlinesystems.com/); repository [commercial-emacs/commercial-emacs](https://github.com/commercial-emacs/commercial-emacs).
- Rudy Sanchez, ["ArtCraft Launches an Open-Source, AI-Powered Alternative to Adobe's Creative Cloud"](https://thedieline.com/artcraft-launches-an-open-source-ai-powered-alternative-to-adobes-creative-cloud/), Dieline, 8 ottobre 2026; Design Compass, ["ArtCraft, a free Adobe alternative program created by an individual"](https://designcompass.org/en/2026/10/19/artcraft-open-source-adobe-alternatives/), 19 ottobre 2026, per le stelle su GitHub e lo stato di alfa.
- [blueprint.el](https://github.com/kLeZ/blueprint.el), repository su GitHub.
- Tom Purl, "Using The Eisenhower Matrix In Emacs Org-Mode", [ripubblicato su questo blog]({% post_url en/2019-10-22-using-the-eisenhower-matrix-in-emacs-org-mode %}) nel 2019.
- Randall Munroe, ["tar"](https://xkcd.com/1168/), xkcd 1168, CC BY-NC 2.5.
- Donald E. Knuth, "Literate Programming", *The Computer Journal*, 27(2), 1984, pp. 97-111.
