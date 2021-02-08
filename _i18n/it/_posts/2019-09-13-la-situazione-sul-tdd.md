---
title: "La situazione sul TDD"
tags: 
date: 2019-09-13 19:00:57+02:00
---

Il TDD è una di quelle metodologie che più spesso viene bistrattata qui in Italia. Spesso si sente definire questo approccio come *troppo costoso* o peggio come *fallimentare*.  
Molto spesso la "colpa" va al budget, sempre troppo risicato quantunque esso sia, ma qui si sa che la coperta viene commissionata su misura per un watusso e poi arrotolata fino a non coprirci neanche un pigmeo. E quello deve bastarti, altra non ne srotolano.

Al di là delle facili critiche e delle superficiali battute tragicomiche, il fatto è che c'è molto ancora da fare per convincere i più biechi antagonisti di questa tecnica che vale la pena *iniziare* a fare dei test un componente necessario di ogni progetto.

{% include more.html %}

## Cosa è il TDD

Quindi cos'è il TDD? TDD è un acronimo che significa *Test Driven Development*; è una metodologia che ci consente di guidare lo sviluppo tramite i test, che sembra complicato ma non lo è.

Guidare lo sviluppo tramite i test significa essenzialmente che i test vanno **progettati bene**, perché dovranno coprire ad alto livello tutti i casi d'uso richiesti dal committente del software.

> Un test alla fine non è altro che la spiegazione con verifica passo passo di una funzione del software usando il software stesso.

Esistono diversi tipi di test che si usano per diversi scopi e in diversi contesti, e servono per allargare via via il cono di visibilità sul sistema. Vediamoli.

### Unit test

I test unitari o *unit test* sono i componenti principali di una qualsiasi *suite* di test. Con uno *unit test* andiamo a verificare il funzionamento di singole unità di codice, singoli metodi o singole funzioni, che dovrebbero fare una sola cosa e dovrebbero farla bene. Questo rientra nel [Clean Code]({% post_url 2019-03-28-spaghetti-code-its-that-bad %}), l'abbiamo già trattato.

### Integration test

A dispetto di quanto si pensa, non servono per verificare l'integrazione del sistema con altri sistemi, bensì servono per verificare che ogni componente del sistema sia correttamente integrato con gli altri. Inoltre gli *integration test* si usano anche per verificare che il sistema risponda correttamente ai requisiti funzionali (cioè che faccia ciò che è richiesto dal committente).

### Validation test

I test di validazione (solitamente manuali) sono test che validano il comportamento generale del sistema; sono chiamati anche test *end-to-end* o con l'acronimo **E2E**. In alcuni casi è possibile che anche questi test trovino spazio nella *suite* dei test del software da eseguire automaticamente, ma non è sempre così.

## Il solito Uncle Bob a illuminarmi la strada

Quando morirà, spero il più tardi possibile, probabilmente mi sentirò smarrito e piangerò, come fosse stato mio padre. Beh, dal punto di vista puramente tecnico mi ha insegnato e mi insegna ancora tutto quello che sa, esattamente come farebbe un padre. Oh, non c'è un rapporto diretto, quello che insegna a me lo insegna a tutti tramite [Twitter](https://twitter.com/unclebobmartin), [il suo blog](https://blog.cleancoder.com/) e i suoi libri.

Lo Zio ha pubblicato, ormai molte lune or sono[^1], [questo interessante articolo](https://blog.cleancoder.com/uncle-bob/2016/03/19/GivingUpOnTDD.html) in cui analizza [un altro articolo](https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/), quello di nientemeno che [Ian Sommerville](https://en.wikipedia.org/wiki/Ian_Sommerville_(academic)) uno dei più stimati professori di Ingegneria del Software, non uno qualunque, ecco.

L'articolo analizza punto per punto le critiche di Sommerville bollandolo alla fine come neofita, a ragione tra l'altro.

## Sommerville's issue

I problemi di Sommerville sono di certo una spiccata lentezza nell'apprendere la metodologia unita a una progettazione probabilmente ricca di compromessi.  
Capita spesso di scendere a dei compromessi che imbruttiscono il codice, ma non dovremmo lasciarci tentare da queste scorciatoie perché il prezzo è sempre la qualità del codice, l'architettura e di conseguenza la difficoltà nello svolgere task semplici come scrivere un test o effettuare una modifica al comportamento.

La prima critica mossa verso il TDD riguarda il primo dei problemi che incontrano i neofiti nell'approccio alla disciplina.

### Il problema dei Test fragili

Un po' sto traducendo da Uncle Bob, ma va bene lo stesso (almeno per me).

Sommerville asserisce che il TDD rende conservativi riguardo al software, cioè rende chi adotta questo approccio molto avverso all'applicazione di cambiamenti nel software.

La risposta dello Zio ovviamente riguarda l'architettura; un software su cui si ha avversione ad applicare modifiche è un software mal progettato. E io sono assolutamente d'accordo. Aggiungo qualcosa di mio riprendendo esattamente la frase di Sommerville.

> citation "Ian Sommerville" [https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/]
> 
> Because you want to ensure that you always pass the majority of tests,
> you tend to think about this when you change and extend the program.
> You therefore are more reluctant to make large-scale changes that will lead to the failure of lots of tests.
> Psychologically, you become conservative to avoid breaking lots of tests.

Sostanzialmente, sembrerebbe che Sommerville abbia sperimentato quello che ci porta tutti a pensare di abbandonare il TDD, inizialmente.

Siccome, in quanto programmatori, siamo pigri, meno "fatica" facciamo per ottenere il risultato e più siamo contenti.

Dato questo e dato che la nostra disciplina premia la pigrizia, impariamo ben presto a conservare il più possibile l'energia che abbiamo, tentando di percorrere strade anche non battute ma più brevi per risolvere il nostro problema.

E Ian questo lo sa molto bene, non a caso ha insegnato Ingegneria del Software per svariati anni.

La pigrizia è ciò che ci ha portato ad avere sistemi sempre più automatici, e la pigrizia ha portato Sommerville a "fallire" con il TDD.

Quello che dice in parte è corretto, psicologicamente **sei portato a diventare** conservativo, ma solo perché scrivere test è un lavoro particolarmente noioso, che diventa relativamente meno noioso solo quando i test vengono usati per sviluppare la progettazione del sistema a partire dai casi d'uso. La parte incorretta è quella che dà pigramente e impunemente la colpa ai test e al TDD.

Non è per il TDD che trovi noioso scrivere i test, è perché sei pigro! Un'arma estremamente utile in certi casi, ma altrettanto affilata se usata contro di te. Ho dato del pigro a Sommerville, si.

Tanto più che Sommerville parla di *modifiche al sistema che rompono i test*, cosa **inammissibile** nel TDD, dove sono sempre i test i primi a essere modificati, mai l'opposto.

Su questo punto Sommerville sembra soffermarsi un po' di più e stabilisce un nuovo concetto:

> citation "Ian Sommerville" [https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/]
> 
> The most serious problem for me is that it encourages a focus on
> sorting out detail to pass tests rather than looking at the
> program as a whole. I started programming at a time where
> computer time was limited and you had to spend time looking at
> and thinking about the program as a whole. I think this leads to
> more elegant and better structured programs. But, with TDD, you
> dive into the detail in different parts of the program and
> rarely step back and look at the big picture.

Qui in pratica sta dicendo che i test, su cui siamo concentrati, ci costringono a soffermarci sui dettagli senza pensare alla *big picture*, anzi abbandonandola e dimenticandola.

Anche questo errore è relativo alla sua condizione di neofita dell'approccio, che lo porta a faticare molto per comprendere la nuova metodologia e i nuovi artefatti su cui sta lavorando perdendo di fatto la rotta sulla *big picture* ma non a causa dei test, bensì a causa del suo essere un neofita.

### Il problema della progettazione testabile

> citation "Ian Sommerville" [https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/]
> 
> It is easier to test some program designs than others.
> Sometimes, the best design is one that’s hard to test
> so you are more reluctant to take this approach because you
> know that you’ll spend a lot more time designing and writing
> tests (which I, for one, quite a boring thing to do)

Qui Robert si arrabbia un po' e ha ragione.

Io mi arrabbio un po' di più (sapete, la giovane età :grin:) e ho ragione pure io.

**Certo** che certi componenti sono più difficili da testare di altri, certo.  
Ogni dispositivo di IO è difficile da testare, no?

Immagina di dover testare le interazioni di un dispositivo VR, o di una fotocamera con sensore di profondità (videocamere 3D), quale sarebbe l'approccio per testarlo? Quali sarebbero i test specifici?

In quali condizioni saremmo soddisfatti dei test tanto da accettare il software?

Si tratta di domande molto complicate a cui rispondere, **ovviamente**. La parola che sbaglia tantissimo è *designs*, non sono *certe architetture* ad essere più difficili di altre, sono i *design* sbagliati che non sono testabili, per vari motivi.  
Sempre su questo punto aggiungo che **di solito** la difficoltà di scrivere dei buoni test è data da una **mancanza** di architettura piuttosto che da una cattiva architettura.  
Lo Zio Bob non si spinge fino all'affermare che ci sia una *totale mancanza di architettura*, perché per lui non può esistere un software **senza architettura**, per me si.  
Per me un software può essere stato scritto senza pensare a un'architettura, e si nota immediatamente, di conseguenza è molto semplice cadere nel baratro dell'impossibilità o della estrema difficoltà nell'implementazione dei test.

Questo è uno dei capisaldi di *Uncle Bob* che però io mi sono sentito di mettere in dubbio. Per lui anche l'assenza di architettura è un'architettura, e dal punto di vista pratico ha ragione. Ma dal punto di vista della progettazione cosciente e consapevole, secondo me, determinati software non hanno un'architettura, dove per "non hanno un'architettura" intendo che chi ha sviluppato questi software non aveva in mente alcuna idea o convenzione o pattern ben preciso e ha scritto, secondo me, *di getto*, cioè non consapevolmente.

Per chiudere su Sommerville, qui lui ha fatto un errore da neofita sul TDD: l'architettura di un progetto TDD va pensata, e i componenti devono essere progettati col chiaro scopo di testarli, ora o in futuro.

Cito *Uncle Bob* direttamente, ma perché in questo caso mi ha davvero tolto le parole di bocca (o i caratteri da sotto alle dita).

> citation "Robert 'Uncle Bob' Martin" [https://blog.cleancoder.com/uncle-bob/2016/03/19/GivingUpOnTDD.html]
> 
> Any design that is hard to test is crap. Pure crap.

### Il problema del proiettile magico

A questo punto, i pensieri di Sommerville sono talmente confusi sul TDD che non riesce più a distinguerne il confine.  
E inizia a pensare che il TDD debba essere una panacea che, solo per il fatto di essere stata applicata a un progetto, lo rende già migliore.  
E lo fa in queste poche righe in cui argomenta malissimo.

> citation "Ian Sommerville" [https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/]
> 
> In my experience, lots of program failures arise because the
> data being processed is not what’s expected by the programmer.
> It’s really hard to write ‘bad data’ tests that accurately
> reflect the real bad data you will have to process because you
> have to be a domain expert to understand the data. The ‘purist’
> approach here, of course, is that you design data validation
> checks so that you never have to process bad data. But the
> reality is that it’s often hard to specify what ‘correct data’
> means and sometimes you have to simply process the data you’ve
> got rather than the data that you’d like to have.

Ovviamente la sua lamentela sui dati è non solo realistica, ma reale. Ma non ha nulla a che fare col TDD.

In che modo una metodologia che ti aiuta a formalizzare dei test e verificare il funzionamento di un software potrebbe aiutarti o addirittura risolvere il problema che hai con i dati non validi?

In quale modo il TDD dovrebbe anticipare tutti i casi su cui non hai ancora ragionato?

> citation "kLeZ"
> 
> Il TDD non sostituisce la progettazione;  
> Il TDD non cura una pessima architettura;  
> Il TDD non scriverà per te i tuoi requisiti e le tue validazioni
> sui dati e sugli algoritmi.

L'unico modo per gestire dati non validi in un software è anticipare in fase di progettazione quanti più casi non validi possibile, e il TDD al limite ci è di aiuto come *strumento* per scrivere i test che verificano il comportamento del sistema in presenza di quei dati non validi che abbiamo teorizzato possano esistere.

Una cosa giusta però Sommerville l'ha scritta alla fine, che però non riguarda direttamente il TDD ma l'attitudine alla meccanizzazione delle operazioni che è tipica del programmatore pigro tipico.

> citation "Ian Sommerville" [https://iansommerville.com/systems-software-and-technology/2016/03/17/giving-up-on-test-first-development/]
> 
> Think-first rather than test-first is the way to go.

Ha ragione, le scimmie prima o poi scriveranno anche dei buoni test, e allora a noi resterà solo la capacità di pensare per distinguerci da loro.

[^1]: nel 2016, 3 anni e mezzo fa.
