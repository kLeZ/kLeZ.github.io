---
title: "Le basi dello sviluppo"
tags: 
date: 2021-02-12 16:16:59+01:00
---

Ultimamente mi trovo spesso a leggere di sviluppatori che non conoscono determinati acronimi, o che si ritrovano a chiamarsi "sviluppatori" senza sapere cosa effettivamente significhi sviluppare software.

E come al solito mi *triggero* sulle basi e vado dritto come un pesce all'amo tentando di sviscerare un argomento che molti altri più bravi di me hanno tentato di sviscerare in libri interi spesso riuscendoci solo in parte.

Mi ripeto sempre che è una cattiva idea usare un blog per parlare di un argomento così vasto e che i grandi come **Uncle Bob** e **Kent Beck** si rivolterebbero nella tomba se ne avessero una.

Ma siccome sono entrambi ancora vivi, non temo questa reazione e quindi *sbaglio* con piacere, sperando anche di fare cosa gradita a quei 3 scappati di casa che leggono questo sito.

Inizio, dopo l'inizio, dicendo che le basi dello sviluppo di software sono tante, e lo sviluppo di software è un'arte complessa che merita tempo per lo studio e dedizione per la materia, mancanti le quali il software non può essere sviluppato oppure può esserlo ma sarà brutto, poco performante, difficile da mantenere e probabilmente pieno di problemi.

E soprattutto, un software sviluppato senza conoscere le basi sarà consegnato in ritardo, **sempre**. Qui non ci sono deroghe.

{% include more.html %}

## La base fra le basi: studiare

Non c'è dubbio che il settore informatico sia in continuo, apparentemente caotico movimento. E in ogni ambiente in cui il movimento è continuo e caotico la sopravvivenza è data da un'unica legge: _chi si ferma è perduto_.

Di certo ci sarà chi pensa che si può tirare avanti con una singola tecnologia per tutta la propria carriera, e probabilmente è vero se si restringe il campo: in particolari ambiti, solo su alcuni progetti, per certi clienti e certe tecnologie probabilmente è possibile fare la stessa cosa tutta la vita.  
Un esempio lampante è dato dal COBOL, che ancora oggi viene usato in ambienti *mainframe* dopo 50 anni o più di sviluppo.

Non augurerei comunque a nessuno di leggere quel codice, considerando che inizialmente i COBOListi venivano pagati a righe di codice (LoC). Immagina che porcaio di righe di 4 caratteri c'erano.

Per non fermarsi, un buon programmatore al passo coi tempi deve studiare. Studiare le nuove tecnologie, si, ma anche (e soprattutto) le basi.

Perché, se devo davvero dire cosa mi abbia aiutato a spaziare così tanto su tecnologie così diverse, ecco, sarebbe questo.

Per parafrasare (a mio favore) un famoso adagio:

> citation "Proverbio Cinese (forse attribuibile a Confucio)"
> Dai un pesce a un uomo e lo nutrirai per un giorno.
> 
> Insegnagli a pescare e lo nutrirai per tutta la vita.

La mia versione è questa:

> citation "kLeZ"
> Dai una tecnologia a un uomo e lavorerà un decennio (*forse, se non è un framework JavaScript*).
> 
> Insegnagli le basi e lavorerà per sempre (*oppure svilupperà un framework JavaScript al mese*).

Il concetto è questo: conoscere le basi è come saper pescare.

Ma studiare non è un consiglio sufficiente, perché la prima domanda è: studiare, ok, ma cosa?

## I principi formali

Nella scienza dell'informatica, ancora meglio nell'ingegneria del software, esistono molti "guru" (veri, non come il mago Otelma) che si propongono di racchiudere i loro molti anni di esperienza in alcune pratiche considerate di successo.

Spesso il processo prevede che questi super-tecnici stilino due elenchi, uno con le pratiche che sicuramente sono sbagliate e, partendo da questo, un elenco di pratiche che sicuramente hanno avuto una percentuale di successo sufficientemente alta.

Loro stessi sperimentano in prima persona questi principi prima di raccoglierli in dei testi che poi saranno utili ad altri professionisti o aspiranti tali del settore.

In questo articolo, cito solo tre principi (qualcuno di più in realtà, capirete nel corso dell'articolo).

## DRY (Don't Repeat Yourself)

Questo principio viene da un ottimo libro, uno dei *must read* dell'artigiano del software di qualità.

Parlo di [Il pragmatic programmer](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/), un libro che mi ha dato tante soddisfazioni, e che racchiude tra i tanti consigli un principio *pragmatico*: **Non Ripeterti**.

Non Ripeterti ([Don't Repeat Yourself, DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself)) è un principio che sintetizza il concetto del riuso di codice.  
O meglio, gli autori del libro in realtà parlano in senso molto più generale dello sforzo di avere sempre un singolo elemento della conoscenza in un solo punto.

> citation "Andy Hunt and Dave Thomas, The Pragmatic Programmer"
> Every piece of knowledge must have a single, unambiguous, authoritative representation within a system

Ma ciò su cui voglio soffermarmi io è l'applicazione di questo principio alla pratica della scrittura di codice.

Questo principio è efficace nella stesura del codice se si pensa al fatto che puntare a riusare il codice ti porta a scrivere codice più pulito, generico e flessibile, proprio perché sai che potresti usarlo in contesti in cui certe premesse non sono più valide.

E quindi ti porta a scrivere del codice di fatto di qualità più alta, pronto per il mondo esterno, usabile e magari già usato da porogrammatori differenti da te, che si sa potrebbero essere *diversamente simpatici*.

{: .text-center }
![Violent-Psychopath]({% link /media/2021-02-12/le-basi-dello-sviluppo/violent-psychopath.jpg %}){: .w-50 .img-fluid }

Il principio però, come mi è capitato di vedere altre volte può portare a un eccesso.

Ho visto parecchi neofiti approcciare alla programmazione e ho notato che quasi tutti sono passati dal primo banale approccio del *pattern copia-incolla*, la pratica sconsigliata dagli autori del principio DRY, a non duplicare più nulla, rendendo inutilmente super complicati i metodi che scrivevano in una **eccessiva** ottica di riutilizzo.

> Vabbè ma prima mi dici che non devo duplicare il codice poi mi dici che non duplicarlo porta a codice complesso! Deciditi!

E infatti è qui il punto, l'equilibrio. Ne parleremo parecchio.

{: .text-center }
![Thanos-Balance]({% link /media/2021-02-12/le-basi-dello-sviluppo/393-balance-thanos.JPG %}){: .w-50 .img-fluid }

Il concetto è quello di genericizzare quando c'è possibilità di farlo senza complicare molto il codice. Mi verrebbe da dire troppo, ma poi dovrei spiegare come si capisce quando il codice è troppo complicato, e c'è un altro guru di cui ho parlato spesso che ha scritto libri interi sull'argomento.

Tipicamente comunque, un codice è troppo complicato quando qualcuno senza conoscenza del contesto lo legge senza capire bene quale sia il suo risultato.

{: .justify-content-center .mb-5 }
{% include embed-youtube.html video_id="E8z3EecNuEI" classes="embed-responsive-16by9 w-50" %}

## YAGNI (You Aren't Gonna Need It)

Un altro principio fondamentale ci viene dagli originali ideatori della pratica *Agile* dell'*Extreme Programming* ([XP](https://en.wikipedia.org/wiki/Extreme_programming)).

[Ron Jeffries](https://en.wikipedia.org/wiki/Ron_Jeffries) ci regala questa perla, in cui ci spiega (in uno *slogan* praticamente) che non si deve cedere alla pratica diffusa di sviluppare cose perché si pensa possano essere utili **in futuro**.

Rientrando in quello che a Roma potrebbe essere il nostro proverbiale "Non si sa mai", ecco Ron e i suoi colleghi [Ward Cunningham](https://en.wikipedia.org/wiki/Ward_Cunningham) e [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck) (mica due tizi qualsiasi) che ci spiegano che al software questo adagio è meglio non applicarlo.

È meglio perché nell'ottica *Agile* di rilasciare più *feature* possibile il più in fretta possibile, spendere del tempo per anticipare delle necessità **eventuali** non è il modo migliore di spendere quel tempo perché tanto [You aren't gonna need it, YAGNI](https://en.wikipedia.org/wiki/You_aren't_gonna_need_it), appunto.

> Always implement things when you actually need them, never when you just foresee that you need them.

## SOLID

Il meglio viene alla fine, come sempre. SOLID però, mi spiace per te, non è un principio (o meglio, non uno solo), bensì cinque.

[SOLID](https://en.wikipedia.org/wiki/SOLID) è un acronimo, quindi andiamo lettera per lettera, concetto per concetto, in ordine.

### Single responsibility principle (SRP)

Questo principio indica che ogni componente del sistema abbia una e una sola responsabilità. Di fatto è il principio alla base dell'incapsulamento.

> A class should only have a single responsibility, that is, only changes to one part of the software's specification should be able to affect the specification of the class.

Nella mia esperienza ho visto moltissimi progetti, e un curiosamente molto alto numero di *God Class*, cioè classi che nel software fanno *praticamente* ogni cosa, o quasi. Spesso sono anche *Singleton*, motivo per cui questo pattern è diventato un anti-pattern per molti, me compreso.

C'è poco altro da spiegare: una classe deve fare una sola cosa e farla bene, In questo modo si riesce anche a rispettare il principio DRY, perché ogni classe diventa la *single source of truth* (la singola sorgente della verità) per quel determinato comportamento o quella parte della conoscenza.

### Open-Closed Principle (OCP)

Questo principio spiega che un componente dovrebbe sempre essere aperto alle estensioni (qui il nostro "non si sa mai" è ammesso) ma chiusa per le modifiche.

> Software entities should be open for extension, but closed for modification.

Questo principio porta con sé almeno due verità implicite:

- Più modifichi e più bug introduci (*potenzialmente*)
- Un componente non sarà mai scolpito nella pietra, i requisiti evolvono e il software con essi

Anche qui, spesso ho visto classi che magari facevano una sola cosa, ma che erano dipendenza di molti altri componenti del sistema e venivano spesso modificate per supportare ulteriori comportamenti. Più spesso di quanto si pensi, aggiungere ulteriori comportamenti potrebbe portare a rompere i comportamenti esistenti, e quindi rompere le funzionalità esistenti.

Dietro questo principio, come dietro a ogni principio c'è la volontà forte di spendere la maggior quantità di tempo possibile nello sviluppo di nuove funzionalità piuttosto che nella risoluzione dei problemi, perché quest'ultima non porta valore aggiunto al software (se non un software con meno problemi).

Quindi, bisogna sempre stare attenti a non sviluppare classi che debbano essere modificate spesso, e questa è proprio la campanella che devi ascoltare per capire se il principio è rispettato o meno.

### Liskov Substitution Principle (LSP)

Ok, qui entriamo nel vivo della programmazione orientata agli oggetti ([OOP](https://en.wikipedia.org/wiki/Object-oriented_programming)).

Questo principio ci spiega che se un tipo B è un sottotipo di A, allora gli oggetti di tipo A devono poter essere sostituibili da oggetti di tipo B senza alterare il comportamento del programma.

> Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.

Dipendentemente dal linguaggio che usi, potresti avere più o meno problemi con questo principio.

Io sono stato relativamente fortunato a trovarmi poco di fronte a violazioni di questo tipo.

C'è da dire che spesso ho visto progettazioni ingenue in cui si utilizzavano praticamente solo classi concrete tra di loro, e questo anche se non direttamente vìola questo principio.

### Interface segregation principle (ISP)

Anche qui si parla di OOP. E anche qui si parla di SRP.

> Ma scusa?! L'SRP l'avevamo già trattato! Questo non è DRY!

Potrebbe sembrare che si parli di SRP, ed effettivamente questo principio è molto simile.

Ma la sua valenza è fondamentale, perché qui non si tratta di far fare a un'interfaccia più cose, bensì si tratta di evitare le *God Class* che necessariamente risulterebbero dall'implementazione di una interfaccia con troppi metodi.

Infatti il principio enuncia questo:

> Many client-specific interfaces are better than one general-purpose interface.

Quindi, per puntualizzare, un client dovrebbe utilizzare una interfaccia di cui usa tutti i metodi (o quasi, qualche piccola deroga c'è), in contrapposizione con quelle interfacce piene di metodi di cui un client ne usa solo una piccola parte.

Questo è fondamentale anche per evitare di esporre dei componenti a dei comportamenti fuorvianti magari perché indotte da dei metodi che hanno degli effetti collaterali non voluti o non gestiti.

### Dependency Inversion Priciple (DIP)

Qui parliamo sempre di progettazione del codice. Il principio si focalizza sulla scelta di progettazione di usare classi astratte o interfacce al posto di implementazioni concrete quando si introduce una dipendenza in un componente.

> A. High-level modules should not depend on low-level modules. Both should depend on abstractions (e.g., interfaces).
> B. Abstractions should not depend on details. Details (concrete implementations) should depend on abstractions.


Si tratta sostanzialmente di disaccoppiare i componenti in maniera tale da non dipendere da una implementazione concreta.

Questo è particolarmente utile quando si sceglie a un certo punto di reimplementare un componente per cambiarne il comportamento.

Se infatti avendo come dipendenza una interfaccia a noi basta iniettare l'implementazione corretta e il software continua a funzionare a dovere, nel momento in cui la dipendenza è una implementazione concreta io non ho possibilità di usare il polimorfismo (e quindi il principio di sostituzione di Liskov) per sostituire l'implementazione e cambiare il comportamento.

Questo principio definisce anche un ulteriore concetto, che è la *direzione* delle dipendenze.

Su questo argomento, l'autore di questo principio ci tiene a sottolineare che i moduli di alto livello non dovrebbero dipendere da moduli di basso livello.

L'inversione sta nel fatto che se entrambi i moduli, quello di basso livello e quello di alto livello, dipendono da un'astrazione, di fatto abbiamo invertito la dipendenza che invece tende intuitivamente ad avere moduli di alto livello che dipendono dai dettagli implementativi.

## Conclusioni

I principi sono fondamentali, sono le basi su cui si dovrebbero fondare le competenze di un programmatore.

Conoscere l'ennesimo luccicante faramework non solo non è sufficiente a definirsi buoni programmatori, ma non è neanche utile se poi questo framework viene usato senza che questi principi siano ben saldi nella mente dello sviluppatore che lo usa.

Pensa a quanto è brutto (e pieno di *bug*, e lento) il codice scritto senza avere cognizione di causa di questi fondamentali precetti.
