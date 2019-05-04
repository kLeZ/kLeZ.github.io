---
title: "DevOps: 2 anni dopo"
tags: 
date: 2019-05-04 18:56:31+02:00
---

Oggi parlo di *DevOps*, argomento a me caro, chi mi conosce di persona sa quanto posso essere un *serial killer di **cabbasisi*** su questo argomento.

Introduco brevemente l'argomento dicendo che si tratta di una metodologia di organizzazione del lavoro strettamente legata all'informatica e che si presta molto bene per determinati gruppi di lavoro, determinati progetti e determinate aziende.

{% include more.html %}

## Storia breve (ma non triste)

*DevOps* è una metodologia che nasce nell'ambito di una più forte specializzazione di *Agile* [all'inglese,  ˈædʒaɪl] nel mondo dell'informatica.

In pratica si pone l'obiettivo di sottrarre frizione al lavoro in ogni fase della costruzione di software, sponsorizzando, agevolando e in qualche caso forzando l'applicazione di standard di qualità molto elevati.

Non solo, si pone anche l'obiettivo (necessario) di ridefinire i ruoli partendo da una visione più di alto livello rispetto alle altre metodologie, dando quindi un ruolo chiave nella costruzione di software anche a chi dovrà successivamente assicurarne l'operatività (che fortunatamente è posto in modo ben chiaro non debba essere il team di sviluppo, i *Devs*).

Nasce in seno a questa metodologia una figura chiave che prima aveva un ruolo molto meno centrale in azienda e relativamente al progetto: l'*architetto*. Non che prima questo ruolo non esistesse, capiamoci: l'architetto è sempre esistito, ma spesso (sempre, a memoria mia) non era definito così, al di là di Matrix :grin:. Il nome che ho sentito usare più spesso era progettista, tra l'altro in qualche caso questo ruolo era "fuso" con quello di *project manager* o di *senior analyst*, ma forse in qualche caso può anche starci.

Paese che vai, usanze che trovi, questo mi sembra ormai assodato. Questa frase mi serve per chiarire che parlo della mia esperienza di oltre dieci anni e del "mondo informatico" romano, sono abbastanza sicuro che in altri paesi e forse anche in altre realtà italiane si sia parlato di *DevOps* e di architetti prima rispetto a Roma (perlomeno per la mia esperienza).

Avevo detto breve, **quindi passo alla ciccia**.

## Cosa sono Dev e Ops

Entro nel merito analizzando la parola, chiaramente un neologismo creato unendo due parole che hanno un loro significato ma che unite spiegano brevemente di cosa parliamo.

In modo poco fantasioso, il *Dev* è lo sviluppatore [dall'inglese, developer], la faccia di fronte (dal mio punto di vista) della medaglia, colui che produce di fatto il software.

Dall'altro lato l'*Ops* (a cui è stato cambiato nome) è il sistemista o l'operatore [la traduzione non è letterale, Ops sta per operations], cioè colui che segue l'operatività del software e dell'infrastruttura che lo contorna.

Al di là dei termini molto *markettari* che si usano e degli strumenti di sviluppo e di controllo esistenti, questa metodologia aiuta a riorganizzare la squadra di lavoro, definire ruoli ben precisi che sono cardine attivo della metodologia, e di fatto a rendere più efficiente e a "oliare" gli ingranaggi del lavoro quotidiano della produzione di software.

Per come la vedo io, adottando questa metodologia di lavoro l'azienda stessa acquisisce un processo standard e stabile, delle procedure e una nomenclatura conosciuta, e questo aiuta molto a ridurre la frizione quando nuovo personale (sia esso impiegato o dirigente) entra in azienda.

## Il ruolo chiave dell'architetto

L'architetto, è ciò che da sempre ho voluto fare nella vita, la mia massima aspirazione. Motivo per cui sono così legato a questa metodologia.

L'architetto in ottica *DevOps* ha il ruolo fondamentale di colui che copre il lavoro creativo e scientifico al tempo stesso della progettazione del sistema.

Progettare un sistema non è per nulla un esercizio scolastico: è necessaria la conoscenza approfondita dell'ambiente di lavoro, delle tecnologie da utilizzare, degli standard internazionali, delle *policy* (in italiano, politiche, inteso come quell'insieme di regole interne imposte da chi utilizzerà il software e da chi deve svilupparlo) e bisogna avere un occhio di riguardo per il futuro per evitare che il software diventi obsoleto troppo in fretta.

Inoltre bisogna essere scientifici nel garantire una struttura solida e comoda sia da sviluppare che da monitorare per difetti e possibili problemi di operatività, che sia resiliente e che permetta delle veloci riparazioni quando si verificano malfunzionamenti.

Non è un mestiere per sprovveduti, diciamo.

L'architetto pensa a tutto questo, e aggiusta il tiro mano a mano che il software cresce. Chi dice che l'architetto arriva e progetta il tutto, e poi dopo cambia progetto, non ha ben capito come si fa a essere un buon architetto.

Da quello che ho imparato dai vari libri che trattano l'argomento e dalla mia esperienza l'architetto è soprattutto un buon procrastinatore di decisioni e un buon equilibrista del compromesso.  
Il compromesso va cercato ogni qual volta c'è necessità di piegare ambiente, strumenti, librerie, il linguaggio stesso, alle esigenze dell'architettura; mentre procrastinare serve proprio a darsi il tempo di raccogliere informazioni utili, per poter progettare un'architettura migliore, senza dover necessariamente smontare tutto ogni volta che arriva un nuovo requisito.

L'architetto insomma diventa un ruolo talmente importante da potersi definire fondamentale, al punto che diventa centrale più del *project manager* nella metodologia *DevOps*.

## Gli strumenti

Da smanettone sono sempre stato attratto in maniera particolare dagli strumenti, e il mio personale approccio è di non cominciare mai qualcosa senza prima aver acquisito almeno gli strumenti di base.  
*DevOps* in questo è dalla mia parte partendo molto spesso proprio da questi.

Di strumenti ce ne sono veramente un'infinità, tutti ottimi e perfezionati nel tempo. Proprio per questo motivo vorrei porre l'attenzione più che su uno strumento o un brand in particolare, su determinate categorie di strumenti per me fondamentali e che definiscono il mio modo ideale di lavorare.

### I test

A prescindere dal linguaggio, dalla piattaforma, dalle librerie e dai sistemi utilizzati, i test per me e per questa metodologia sono fondamentali (e fondamentalmente ignorati dai più).

Sui test si basa tutto il mondo della *Continuous Integration* e su questo, a catena, si basa la *Continuous Deployment*.

Questo la dovrebbe dire lunga su quanto siano importanti i test.

Parlo genericamente di test e non di un tipo particolare di test perché tutti equamente sono importanti.

I **test di unità**, i più famosi, sono estremamente importanti perché consentono di acquisire sicurezza sulla corretta implementazione dei casi d'uso del software, permettendo in realtà anche un *refactoring* sicuro del codice nel momento in cui ce ne sia bisogno.

Scrivere ed eseguire dei test di unità consente di essere sicuri che l'unità di codice sottoposta a test sia fondamentalmente esente da difetti per quello specifico insieme di casi d'uso, non male se si pensa di voler implementare dei test per ogni caso d'uso estratto dai requisiti.

Non meno importanti sono i **test di integrazione**, che permettono di sottoporre a test non più singole unità di codice ma interi moduli del sistema, per acquisire sicurezza sul corretto funzionamento di un modulo in interazione con il resto del sistema.

I test non verificano solo il corretto funzionamento dei moduli e la validità della logica applicativa: esistono anche tecniche per sottoporre a test pezzi importanti del software che non sono legati all'interazione tra moduli o alla logica applicativa; esistono altre tipologie di test che verificano diversi altri aspetti dei sistemi.

Il **test della UI** verifica che l'interfaccia abbia un aspetto e un comportamento coerente, cosa necessaria considerando il ruolo fondamentale della stessa per l'utente. Non solo: effettuare i test sulle interfacce aiuta a ridurre il numero di difetti rilevati, che spesso riguardano proprio quest'ultima piuttosto che elementi di logica applicativa.

In ultimo, ma di certo non per importanza, i **test di sicurezza**, o *vulnerability assessment*, che verificano che l'applicazione sia esente da difetti che ne compromettano la sicurezza, in termini di protezione dei dati, accesso non autorizzato e operazioni pericolose sul sistema o altri sistemi a esso collegati.

Ognuno di questi test può essere scritto come codice e ne può essere automatizzata l'esecuzione tramite uno strumento di *Continuous integration* che, come dice il nome, integra in continuazione il codice prodotto allertando nel momento in cui uno o più di questi test fallisca.

Per chi sviluppa avere a disposizione una buona suite di test e un sistema attivo di *continuous integration* significa avere la sicurezza che il codice prodotto in ogni momento è esente (o quasi) da difetti.  
Questo di fatto diminuisce tantissimo la frizione che verrebbe altrimenti prodotta dalla notifica di difetti durante la scrittura di una nuova funzione del software.

### CI/CD

Molto *markettaro* vero? Beh, questa è la sigla che troverete cercando sistemi o servizi che forniscano funzionalità di *Continuous Integration* e *Continuous Deployment* (quest'ultimo a volte viene impropriamente chiamato *Continuous Delivery*).

Entrando in ottica di *DevOps* si capisce come il più possibile della catena di produzione di software debba essere automatizzata.

L'automazione, per come si è evoluto il mercato finora, riguarda la correlazione stretta tra i sistemi che permettono di gestire le revisioni del codice e i sistemi che questo codice lo prendono e lo testano, lo impacchettano e lo installano negli ambienti di collaudo (anche chiamato *quality assurance* o **QA**) e produzione o esercizio.

Dopo che uno sviluppatore ha scritto (e si spera anche testato) il codice relativo a una correzione o a una nuova funzionalità, questo viene inviato al sistema di revisione che lo archivia.  
Automaticamente il sistema di integrazione continua, legato al sistema di gestione delle revisioni, scarica l'ultima revisione ed esegue tutti i test disponibili.  
Se i test vanno a buon fine, vine prodotto un pacchetto a partire dai moduli che sono stati sottoposti a test che viene passato al sistema di pubblicazione continua, che installa la nuova versione dei moduli nei vari ambienti.

Più queste procedure sono automatiche, meno tempo sarà necessario per vedere le ultime modifiche in ambiente di esercizio, e l'obiettivo sembra essere proprio questo.  
Per me lo è.

## La situazione da noi

Il mondo sta cambiando e sembra che Roma, anche se come ruota di scorta, stia cambiando insieme al mondo.

Pochi anni fa non si parlava molto di *DevOps* ma neanche di *Agile*, sintomo di una gestione pressappochista dei progetti da parte di clienti, aziende, manager.

Da qualche anno a questa parte invece non si fa altro che parlarne, iniziano a uscire dalle tane persone che dicono di avere decine di anni di esperienza con questa metodologia e in un attimo il mondo sembra un posto migliore per chi sviluppa software.

Ma non è tutto oro quello che luccica, purtroppo.

### Racconto la mia esperienza

Lavoravo per una grossa società come consulente, al fianco di un'altra enorme e rinomata società nella produzione di questo software; il nostro cliente comune era un importante gruppo italiano, che ci commissionò un software piuttosto importante per l'azienda cliente.

Purtroppo non sono stato coinvolto nelle primissime decisioni del progetto, quelle fondamentali.

Il progetto parte in pompa magna con la promessa che *«sta volta facciamo le cose per bene, non come l'altra volta»*.

Nell'offerta che ha poi vinto la gara d'appalto c'era la **garanzia** che sarebbe stata usata la metodologia ***Agile*** per la gestione di tutto il progetto, che sarebbero stati usati tutti gli **ultimissimi strumenti di automatizzazione** del processo di produzione, e che sarebbero dovuti essere scritti addirittura i **test di unità, di integrazione, di interfaccia** e una suite specifica di test per la ***quality assurance***, l'assicurazione che il codice stesso rispetti determinati standard di qualità.

> Purtroppo, questo è servito solo per alzare il valore dell'offerta commerciale e nulla di tutto questo è stato fatto.

Non di meno, sono comunque riuscito a implementare alcuni punti che mi premevano particolarmente, come una buona *continuous integration* e alcuni test su dei file di configurazione critici per il sistema.

### Morale

> Purtroppo sembra troppo bello per essere vero, e nella maggior parte dei casi lo è.

Non smentisco che esistano delle situazioni virtuose in cui questo viene fatto qui a Roma, né tanto meno voglio negare l'interesse del mercato e soprattutto dei clienti verso questo approccio più formale alla produzione di software che risolve tutti questi problemi.

Però, ovvio che c'era un però, qui ancora se ne parla troppo poco e si sfrutta veramente troppo poco il ritorno commerciale che si è venuto a creare intorno a tutta la metodologia e agli strumenti di automatizzazione.

Da tecnico parlando ai tecnici, mi sento sempre di spingere il più possibile l'utilizzo di queste tecniche, buone pratiche e metodologie per facilitare a noi la produzione del software e al cliente l'adozione di software nuovo e **veramente** funzionante, se possibile senza difetti.
