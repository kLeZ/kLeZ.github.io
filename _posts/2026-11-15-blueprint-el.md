---
title: "blueprint.el: documentare l'architettura, prima e dopo il codice"
tags:
- sviluppo-software
- emacs
- org-mode
- llm
- architettura-software
category: progetto
date: 2026-11-15 01:56:06+01:00
---

Oggi vi presento [blueprint.el](https://github.com/kLeZ/blueprint.el), un pacchetto Emacs che ho scritto per un lavoro che faccio spesso e che, diciamo, non fa impazzire nessuno: ricostruire la documentazione architetturale di sistemi software che non ce l'hanno, partendo dal codice. È nato lì, ma il metodo che si porta dietro vale anche dall'altra parte, quando il codice non c'è ancora e l'architettura la stai progettando. È tutto testo, tutto Org, e si usa benissimo anche a mano. Però è pensato per una squadra: più persone, o più agenti, che ci lavorano sopra insieme, ognuno sul suo pezzo, lasciando a chi coordina solo le decisioni.

E ne vado fiero, lo dico subito. Un lavoro del genere, in Word, è semplicemente impensabile, e blueprint mi ha dato un modo efficace e centrato sull'obiettivo di organizzarlo, che tanto, in un modo o nell'altro, va organizzato comunque.

{% include more.html %}

## Il problema

Chi fa l'architetto o il consulente su sistemi esistenti la scena la conosce a memoria. Arrivi sul progetto, chiedi la documentazione, e ti consegnano un wiki fermo a tre anni fa, un paio di diagrammi disegnati a mano da qualcuno che lì non lavora più da un pezzo, e il codice. Il codice è l'unica fonte che dice la verità, e da lì va ricostruito tutto: quali sono i componenti, come si parlano, cosa fanno per il business, su che infrastruttura girano e quali rischi si portano dietro.

Io di assessment ne ho fatti un bel po', ormai ho una certa esperienza. Arrivi e nella maggior parte dei casi non sai nemmeno dove sia il problema: in un caso il problema non era né il software né la documentazione (il software forse sì, ma diciamo che nel suo essere vetusto comunque era scritto decentemente e funzionava come ci si aspetterebbe), quanto piuttosto la gestione aziendale. L'azienda era letteralmente nata intorno al software, che era il suo core business, e le persone che lo sviluppavano non solo non avevano un backup umano che gli consentisse quantomeno di ammalarsi o andare in ferie, ma non avevano nemmeno dei processi per l'aggiornamento delle competenze. Praticamente nel 2020 sviluppavano ancora come fosse il '98.

Un altro assessment mi portò a scoprire che la documentazione non è che non ci fosse, ce n'era anche troppa, ma era sparsa in pizzini e file Excel in ogni dove, comprese cartelle né versionate né sincronizzate sui pc aziendali dei consulenti che vi lavoravano. Praticamente il disordine e il caos regnavano talmente tanto che il cliente si lamentava di mancanza di documentazione quando il problema era di *governance*.

Un altro ancora aveva il classico software core business che veniva mantenuto da 30 anni, pieno zeppo di decisioni, ripensamenti, normative che nel frattempo sono riuscite a nascere e morire e processi funzionali a dir poco *machiavellici*. Senza uno straccio di documentazione, ovviamente. Ricostruire tutto in casi come questo significa andare a fare l'archeologo, l'archivista, il codicologo che però invece di codici del XVI secolo ha davanti codice al massimo di fine anni '90 (del XX secolo).

In tutti questi casi, sapere prima di tutto *cosa* documentare e solo dopo *come* documentarlo è fondamentale, e blueprint mi ha aiutato tantissimo in alcune di queste situazioni (non in tutte, perché ai tempi delle prime non esisteva ancora, ma per la mia esperienza so per certo che sarebbe stato utile in ognuna). E strumenti che facciano questo, semplicemente, non ce ne sono.

Puoi prendere Word, ma anche lo stesso Emacs con org-mode, e sono solo strumenti di scrittura. Uno strumento che aiuti nel censimento, che organizzi le aree in maniera netta, che dia un modello preconfezionato che si possa imparare a conoscere e che possa anche guidare le fasi iniziali della scoperta, che possa seguire anche i filoni non funzionali e non tecnici che spesso ci si trova a dover gestire, è uno strumento completo e una metodologia prima che un software. La parte più importante di blueprint è il metodo, poi il modello e infine il software che li tiene insieme e li arricchisce. E il metodo, in pratica, è tutto quello che ho imparato progettando sistemi complessi e ricostruendone la documentazione a posteriori, condensato in una struttura di file.

Lo stesso problema, visto dall'altra parte, ce l'ha chi un sistema lo sta progettando adesso. Il primo giorno la documentazione non c'è comunque, e se non la imposti con un metodo ti ritrovi tra dieci anni come in uno di quei tre casi, solo che stavolta il codice da cui partire per l'assessment l'hai scritto tu.

Per dare una forma al risultato uso [arc42](https://arc42.org/), un modello di documentazione architetturale diviso in sezioni standard, e la sua scomposizione è la parte fondamentale del modello di blueprint, perché ogni sezione ti dice anche quale diagramma serve e per chi. I diagrammi li faccio con due notazioni insieme: il [modello C4](https://c4model.com/), che descrive un sistema a livelli di zoom crescente (contesto, container, componenti) ed è il più comodo per la panoramica di alto livello, e [UML](https://www.omg.org/spec/UML/) per il dettaglio. Però arc42, C4 e UML sono metodi: ti dicono cosa scrivere e come disegnarlo, non come tenere in piedi un documento di centinaia di pagine scritto da più persone, o da più agenti, nello stesso momento. Quello resta un problema tuo, ed è esattamente il problema che blueprint risolve.

## Da Python a Elisp

La prima versione era uno script Python, `scaffold.py`, che generava la struttura dei documenti, gestiva i componenti, il glossario e un rapporto sui punti aperti, e alla fine chiamava Pandoc per l'export. Funzionava, e pure bene. Solo che tutto il resto del lavoro lo facevo già dentro Emacs, e ogni volta mi ritrovavo a uscire dall'editor per lanciare uno script che apriva, leggeva e riscriveva dei file Org, cioè esattamente quello che Org sa fare da solo da più di vent'anni. Praticamente un giro dell'oca per tornare alla casella di partenza.

Così l'ho riscritto in Emacs Lisp, con quattro paletti che ho messo nel README fin dal primo giorno. Parità completa di funzioni con lo script, senza la scusa del "per ora è un prototipo, poi vediamo" (sappiamo tutti come va a finire). Elisp fatto come si deve, che vuol dire lavorare sull'albero sintattico di Org con `org-element` invece che a colpi di espressioni regolari, e usare l'exporter di Org al posto di Pandoc. Nessuna dipendenza obbligatoria oltre a Emacs 29 e Transient, che in Emacs c'è già, mentre PlantUML e Graphviz servono solo se i diagrammi li vuoi anche disegnati. E tutto in testo semplice, versionabile, senza database né servizi esterni di mezzo.

Strada facendo è cambiato anche il nome. "scaffold" sapeva troppo di generatore di CRUD, mentre "blueprint" dice meglio quello che è: uno strumento per ragionare sull'architettura di un sistema.

## Com'è fatto un progetto

Un progetto si inizializza nella cartella del lavoro, e quello che ne esce è questo:

```text
master.org
glossary.org
references.org
enterprise/
  context.org
  dependencies.org
nfr/
  quality-scenarios.org
  constraints.org
  risks.org
.blueprint/
  blueprint-version.org
  components/
    ordini/
      arc42.org
      functional.org
      infrastructure.org
```

Il documento finale è `master.org`, che si tira dentro tutti gli altri file con le direttive `#+INCLUDE:`. È diviso in sei parti, e ognuna ha il suo pubblico dichiarato: le premesse sono per tutti, l'architettura enterprise per dirigenti e architetti senior, l'architettura per componente per chi sviluppa, le specifiche funzionali per analisti e product owner, il censimento infrastrutturale per chi gestisce i server, e infine requisiti non funzionali, vincoli e rischi per architetti e management. Così ognuno si legge la sua parte senza doversi sciroppare tutto il resto.

Il cuore di tutto sono i componenti. Ognuno ha la sua cartella con tre file autonomi: `arc42.org` per l'architettura, `functional.org` per le specifiche funzionali e le regole di business, `infrastructure.org` per il censimento di macchine, rete e accessi. Le dipendenze tra componenti si dichiarano con una riga in testa al file:

```org
#+BLUEPRINT_DEPENDS: auth database cache
```

Da queste righe blueprint genera il diagramma C4 dei container in [PlantUML](https://plantuml.com/) e un grafo delle dipendenze in Graphviz, con i nodi colorati in base allo stato di salute di ogni componente. Il diagramma delle dipendenze, quindi, non lo disegna nessuno a mano, e non invecchia mentre il codice cambia.

Tutti gli altri diagrammi seguono la scomposizione di arc42, e ognuno ha il suo posto nel template del componente. C4 dà la panoramica: il diagramma di contesto sta nella sezione sul perimetro, quello dei container nei building block, e il livello dei componenti arriva quando la complessità lo chiede. Il dettaglio invece lo dà UML. Ogni flusso a runtime ha un diagramma dei casi d'uso, per chi non è tecnico, e uno di sequenza, per i team tecnici, e i processi di business con più attori diventano diagrammi di attività con una corsia per attore. Nel mio lavoro ci aggiungo i diagrammi entità-relazione del modello dati e quelli di stato per i flussi più contorti. Messi insieme, C4 al secondo o al terzo livello e UML descrivono un componente con un livello di dettaglio impressionante. Ed è tutto PlantUML dentro blocchi sorgente Org, cioè testo, versionato insieme a tutto il resto; due comandi, `blueprint-runtime-add-flow` e `blueprint-runtime-add-process`, ti creano la sottosezione di un flusso o di un processo con i diagrammi già impostati.

I template dei documenti non sono cablati nel pacchetto, perché durante un assessment le strutture cambiano di continuo. blueprint li cerca in tre posti, in quest'ordine: la cartella del progetto, la configurazione personale, e solo alla fine i template di sistema che arrivano col pacchetto. Vince il primo che trova, e se quello di sistema non ti basta lo cloni nel progetto e lo adatti a quel lavoro specifico.

## Il punteggio di salute

Mentre scrivi un documento del genere lasci punti aperti dappertutto: cose da verificare, domande per il cliente, sezioni da rivedere. blueprint li tratta come marcatori nel testo, e a ognuno dà un peso:

| Marcatore          | Significato                                            | Peso |
| ------------------ | ------------------------------------------------------ | ---: |
| `FIXME`            | qualcosa di sbagliato da correggere                    |    4 |
| `QUESTION`         | una domanda aperta                                     |    3 |
| `TBD`              | da definire                                            |    2 |
| `[DA VALIDARE]`    | scritto ma non ancora verificato con il cliente        |    1 |
| `[DA REVISIONARE]` | da rileggere                                           |    1 |
| `[FINDING]`        | una discrepanza trovata (un risultato dell'assessment) |    0 |

{% katexmm %}

La somma dei pesi è la penalità, $p$. Il punteggio però non deve crollare solo perché il documento cresce, quindi la penalità si confronta con la dimensione del testo: con $W$ parole esportate e un punto di "credito" ogni 100 parole, cioè $U = W/100$, il punteggio $s$ è

$$s = \operatorname{round}\left(100 \cdot \frac{U}{U + p}\right)$$

Un documento di 10.000 parole ha $U = 100$: con 20 punti di penalità sta a 83, e lo stesso documento con 100 punti scende a 50. Contano solo i marcatori nel testo che l'export mostra davvero, quindi quelli nei commenti, nei blocchi di codice o nelle sezioni escluse non pesano.

{% endkatexmm %}

La formula non è nata così. All'inizio il punteggio partiva da 100 e sottraeva penalità assolute senza guardare quanto testo c'era intorno, e su un documento ormai bello corposo stava inchiodato a 37. Come buona parte del piano recente del pacchetto, la correzione è venuta fuori usandolo.

Nel README lo dico subito: è più un incentivo a chiudere i punti aperti che una metrica rigorosa. Però funziona, e il quadrante SVG che lo mostra lo puoi pure far vedere al cliente durante una revisione.

## A mano, come Magit

Tutto passa da un menu [Transient](https://docs.magit.vc/transient/) su `C-c b`, lo stesso sistema di menu di Magit: premi un tasto e vedi tutti i comandi raggruppati per argomento, senza doverti ricordare decine di scorciatoie dopo due settimane che il progetto non lo apri.

Poi c'è una dashboard à la Magit, con una riga per componente e una per ogni altro file del documento: responsabile, tecnologia, perimetro, conteggio dei marcatori, penalità, punteggio. Con `RET` apri il file della riga. C'è una modalità che mostra solo i componenti che hanno bisogno di attenzione, un comando per la routine del mattino che dalla dashboard ti porta al documento da modificare in pochi tasti, procedure guidate per creare progetto e componenti, la gestione di glossario, riferimenti, domande aperte e decisioni architetturali (ADR), un linter, e l'export in PDF, ODT, HTML e DOCX. L'ODT rispetta il template aziendale indicato in `master.org`, ed è quello che uso quasi sempre, perché i clienti il documento lo vogliono col loro modello, e guai a toccarglielo.

## Prima del codice

blueprint è nato per fare l'archeologo, ma la sua struttura è così poco invasiva che sta benissimo dentro il repository dei sorgenti: lanci `M-x blueprint-init` in una cartella `docs/` e la documentazione vive accanto al codice, versionata insieme a lui. Da lì diventa uno strumento di progettazione. I marcatori cambiano significato senza cambiare peso: un `TBD` è un pezzo ancora da progettare, una `QUESTION` è una domanda da fare al product owner, e il punteggio di salute ti dice quanto del sistema è ancora da decidere.

Si sposa bene anche con un processo agile. Creare un componente e descriverlo al livello di dettaglio che blueprint propone è esattamente la documentazione che si produce da uno sprint all'altro, e che si passa allo sviluppo quando è completa, cioè quando nel componente non restano più `TBD` né `QUESTION`. Secondo me partire con blueprint su un progetto nuovo porta vantaggi enormi, anche se finora l'ho collaudato per bene solo sugli assessment.

## Con uno sciame di agenti

blueprint non contiene un modello linguistico. C'è un'integrazione opzionale con Ollama in locale per qualche suggerimento, ma è un accessorio. Quello che lo rende adatto agli agenti è la forma, la stessa che serve a una squadra di persone che lavora in parallelo: gli agenti sono il caso estremo, tanti e velocissimi.

### Zone separate

Tre file per componente, un file per ogni parte trasversale, e in ogni file sezioni e tag riconoscibili. Un agente si prende i tre file di un componente e ci lavora per conto suo, un altro fa lo stesso su un altro componente, un terzo si occupa di glossario e fonti. Non si pestano i piedi perché non toccano gli stessi file, e se proprio due mettono mano allo stesso file, git se ne accorge.

### Tutto da riga di comando

Gli agenti di programmazione vivono in una shell, e ogni funzione di blueprint si chiama da lì, senza nemmeno aprire Emacs:

```bash
emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el \
  --eval '(blueprint-add-component "ordini")'

emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el \
  --eval '(blueprint-add-question "ordini" "Chi autorizza il rimborso?")'
```

### L'agente si controlla da solo

Poi ci sono i comandi pensati per la CI, che stampano il risultato ed escono con un codice preciso: 0 se va tutto bene, 1 se ci sono avvisi, 2 se ci sono errori.

```bash
BP="emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el"
$BP -f blueprint-ci-lint         # sezioni mancanti, dipendenze appese
$BP -f blueprint-ci-validate     # lint, salute, dipendenze
$BP -f blueprint-ci-export       # il documento finale
$BP -f blueprint-ci-export-json  # rapporto in JSON
```

L'ultimo scrive un rapporto in JSON con il punteggio di salute, i marcatori di ogni componente, le dipendenze e gli avvisi del linter. Per un agente è una fotografia del progetto in un formato che legge al volo.

### I marcatori dicono cosa manca

Un `TBD` dice all'agente cosa resta da scrivere, un `[DA VALIDARE]` cosa ha scritto senza poterlo verificare. Una `QUESTION`, invece, è il punto in cui l'agente si ferma e la palla torna a una persona: chi autorizza un rimborso, quale dei due flussi è quello vero, se quel server fa ancora parte del perimetro. Tutto il resto può andare avanti da solo.

## Con o senza agenti

Anche facendo tutto a mano, blueprint è sicuramente meglio che aprire Word e iniziare a scrivere. Del resto si tratta di documenti che possono arrivare a qualche centinaio di pagine (ricordo che la versione italiana di Dr. Jekyll e Mr. Hyde ne fa poco più di 300). Word non è di certo lo strumento adeguato per manoscritti di quella mole. Ma anche con Emacs e blueprint ci vuole comunque un'eternità, perché il lavoro grosso di scoperta e di stesura del testo sta lì a prescindere da quale strumento usi.

Secondo me, con blueprint, i tempi si possono anche dimezzare, e già questo mi basta per dire che è un buon progetto. Integrato nei processi giusti può fare la differenza, e può aiutare a fare un assessment, che di suo è un lavoro brutto, come lo fanno *quelli bravi*.

Domani, quando questa dannata bolla sarà scoppiata, si spera in un mondo migliore e su una Terra ancora sana, e gli agenti AI saranno meno disponibili (perché costeranno finalmente quanto devono, visto che oggi le aziende che ce li affittano ce li danno *in perdita*), questa resterà comunque una struttura organizzativa che funziona con un team di esseri umani, sia per un assessment a posteriori sia per mantenere la documentazione del proprio progetto (il metodo blueprint funziona anche meglio su un progetto *green field*).

## Scritto con un agente

blueprint l'ho scritto lavorando con un agente, e il repository se lo porta addosso: dei 62 commit fatti dal 22 febbraio 2026, 17 hanno Claude come autore. Oggi sono circa 9.600 righe di Elisp divise in 36 file, più 29 file di test con ERT, il framework di test che Emacs si porta già in pancia.

Nel repository c'è anche tutto quello che serve a un agente per lavorarci: un `AGENTS.md` con i comandi per lanciare i test e le regole del progetto, un `CONTEXT.org` con lo stato del lavoro, un `PLAN.org` con quello che resta da fare, e le decisioni architetturali in `docs/adr/`. Sono gli stessi file che servono a me per riprendere in mano il lavoro dopo settimane, ed è proprio per questo che funzionano anche per l'agente.

Io notoriamente sono uno che gli agenti li tratta male: passo dal ricordare loro che sono delle "dannate macchine" o "dannati pezzi di ferraglia arrugginita" al minacciarli di cambiare provider, fino a sottolineare, più spesso di quanto sia edificante ammettere, che l'umano sono io e loro sono degli idioti patentati. Non lo faccio per sadismo (beh, un po' forse sì, magari per divertimento, come con Eliza quando ero piccolo) ma perché vanno corretti e non capiscono molto bene le sfumature, quindi bisogna essere diretti, pignoli, espliciti. Spesso mi viene ricordato da mia moglie che io sono così, solo che lei lo fa sottolineando come questo sia un difetto, e in più comanda lei a casa, come tutte le donne in tutte le case d'Italia, quindi in quel caso l'harness sarei io (ma con meno insulti, per fortuna).

Ma con Claude il capo sono io (come diceva Napoleone) e quindi sono io che decido quando si attacca, quando il suo codice non va bene e quando è meglio che si faccia una passeggiata perché il codice che ha scritto fa schifo.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8" markdown="1">
![Fotogramma degli Aristogatti. Napoleone, il segugio, ripreso dal basso davanti alla porta di legno di un fienile, di notte: sopracciglia aggrottate, muso in alto, l'aria di chi ha appena deciso che si attacca.]({% link media/2026-11-15/aristocats-disneyscreencaps.com-2110.webp %}){: .img-fluid }
*"Il capo sono io, e sono io che decido quando si attacca. All'attacco!" Napoleone in* Gli Aristogatti *(1970), regia di Wolfgang Reitherman, Walt Disney Productions.*
</div>
</div>

## Cosa manca

Il punteggio di salute è semplice di proposito, e chi cerca una metrica seria di qualità della documentazione deve guardare altrove. Il pacchetto è giovane e lo mantengo da solo. Template e metodologia sono in italiano, perché è la lingua in cui lavoro: codice e README sono in inglese, ma chi volesse usarlo in un'altra lingua dovrebbe partire dai template.

Il repository è su GitHub, con licenza MIT. Nella cartella `examples/` trovate un assessment completo su un sistema di gestione del magazzino inventato di sana pianta, con i suoi diagrammi e l'export in ODT.

## Per archeologi e progettisti

Se anche voi vi ritrovate a fare gli archeologi su codice di fine anni '90, con un cliente che vuole sapere cosa ha in casa e nessuno che se lo ricordi più, provatelo. E se invece state partendo con un progetto nuovo, provatelo a maggior ragione: un `blueprint-init` nella cartella `docs/` del repository, e la documentazione cresce insieme al codice invece di doverla ricostruire tra dieci anni. Funziona anche senza agenti, a mano, con il menu e la dashboard. Nella mia testa l'ordine resta quello che ho scritto all'inizio: prima il metodo, poi il modello, poi il software, e solo alla fine, forse, gli agenti. Se partite dallo sciame senza aver capito il modello, vi ritrovate con un sacco di file scritti in fretta e nessuna idea di cosa ci sia dentro, che è esattamente la situazione da cui eravate partiti.

Le segnalazioni e le proposte su GitHub le leggo tutte. E se qualcuno lo usa su un assessment suo, o su un progetto che parte da zero, mi farebbe davvero piacere saperlo, anche solo per capire quali delle mie fisse servono a tutti e quali sono soltanto mie.

## Fonti

- [blueprint.el](https://github.com/kLeZ/blueprint.el), repository su GitHub, con README e `USAGE.org`.
- [arc42](https://arc42.org/), modello di documentazione architetturale.
- [Il modello C4](https://c4model.com/) di Simon Brown.
- [UML](https://www.omg.org/spec/UML/), la specifica dell'Object Management Group.
- [PlantUML](https://plantuml.com/), diagrammi da testo.
- [Transient](https://docs.magit.vc/transient/), il sistema di menu di Magit.
