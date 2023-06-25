---
title: "Na na na na na na na na na na na na na na na na, PassMan!"
tags: 
date: 2019-04-19 20:11:14+02:00
---

Oggi che è venerdì voglio raccontare una storia divertente che mi riguarda direttamente, prendetela leggera.

Parliamo di [Passman], un piccolo progetto "*esperimento*" che ho condotto circa 5 anni fa, e devo dire che è stato divertente e interessante.

{% include more.html %}

## Preludio

L'idea nasce da un'esigenza, quella di ricordare un certo numero abbastanza cospicuo di password relativamente complesse.

Inizio a cercare su internet delle soluzioni a quello che secondo me era un problema assolutamente comune per una buona pratica di utilizzo della tecnologia. Ho sempre avuto una password diversa per ogni account creato, del resto mi è sempre sembrato *normale* farlo, e le password erano non molto complesse ma semplici da ricordare, un compromesso tra robustezza e memorizzazione, diciamo.

Inspiegabilmente per me, in giro c'è veramente poco di valido e utile (solo qualche tempo dopo avrei trovato [Unix Pass]) e io avevo alcuni vincoli non di poco conto.

Non volevo utilizzare strumenti *closed source*, non volevo strumenti che fossero *principalmente* desktop o *principalmente* web o *principalmente* estensioni del browser, **volevo una soluzione *passepartout***. Volevo una soluzione che fosse in grado di **sincronizzare** *dove volevo io*, non in un fantomatico "*cloud*" da qualche parte gestito chissà come da chissà chi.

Insomma volevo appoggiarmi il meno possibile a terzi e al *closed source/closed service*.

Inoltre, parametro che filtrava molto pesantemente la scelta, doveva funzionare sul maggior numero di casi d'uso possibili, intesi come il dover funzionare principalmente su linux e browser, possibilmente su shell (non indispensabile) e opzionalmente su altre piattaforme oltre a queste (windows).

Il meglio del mercato erano strumenti come LastPass o KeePass, non entro nel dettaglio perché li ritengo poco utili e poco versatili.

La morale di questa ricerca è stata (dopo un'intera giornata praticamente, divisa in piccole ricerche durante la settimana) che non c'era nulla di veramente valido in circolazione.

**Così ho avuto l'illuminazione.**

## La nascita di PassMan

Di buon impegno decido che devo scrivermelo io il software, perché quello che c'è in giro non è abbastanza valido.

Ormai deciso a fare questa cosa, torno a casa dall'ufficio e, dopo cena, mi metto al pc a iniziare questa cosa.

La piccola progettazione alla base ha voluto che il software avrebbe dovuto essere **web** e in particolare **client**, proprio perché non avevo alcuna intenzione di creare un mostro da dover poi installare da qualche parte. Volevo una cosa leggera, veloce, pratica, e che potesse coprire più piattaforme possibili, il web mi è sembrato la soluzione migliore.

La scelta delle librerie è stata relativamente semplice, ne uso così poche!

L'elenco è breve:

- JQuery
- Bootstrap
- FontAwesome
- KnockoutJS
- OpenPGP.js

Bootstrap e FontAwesome si commentano da sole: due librerie per evitarmi di scrivere la grafica e cercare immagini in giro per internet. Sono stati un enorme *boost* di produttività, lo ammetto.

JQuery era la scelta ovvia da fare per avere una serie di funzionalità che col JavaScript del 2014 avrei solo sognato. Anche qui il *boost* è stato enorme e mi ha permesso di fare veramente tanto in poco tempo.

Knockout è un *framework* molto interessante, che implementa un pattern che in questo particolare progetto è stato un notevole aiuto allo sviluppo e alla progettazione: sto parlando di **MVVM**.

Senza entrare troppo nel dettaglio, quello che [MVVM] abilita è la capacità di aggiornare l'interfaccia osservando i dati che questa deve esporre, e lo fa con un pattern che si chiama *Observer* e una tecnica chiamata *data binding*.

Osservando i dati, l'interfaccia reagisce renderizzando nuovamente la porzione di essa che è impattata dalla modifica. Questo ha aumentato notevolmente la mia produttività non avendo la necessità di gestire i cambiamenti nell'interfaccia.

L'ultima libreria si commenta quasi da sola. OpenPGP.js **ovviamente** è stata utilizzata per garantire una certa sicurezza visto che il dato trattato è una password, *informazione estremamente sensibile*.

PassMan è uno di quegli strumenti che fa una cosa sola e la fa fatta bene insomma, e sta dentro a circa 30 KB (grazie alle librerie che non rientrano nel conto).

Non vi tolgo il dubbio del suo funzionamento, lascio a voi la curiosità di andare a verificare come funziona e se funziona bene.

## La sicurezza

Essendo un applicativo che gira interamente nel browser, non c'è pericolo di vedere le proprie password viaggiare in rete. L'unica cosa che viaggia è l'applicativo stesso, ma comunque la comunicazione è cifrata grazie a GitHub che fornisce le *Pages* e l'accesso in https a queste.

Le password risiedono in memoria, e vengono lette da un file cifrato PGP e "scritte" in un altro file sempre cifrato con PGP.  
Le chiavi di cifratura vengono inserite come primo passo nelle impostazioni, e vengono sempre gestite in memoria, anche qui non c'è comunicazione di rete.

Tutto sommato, per quanto poco ci è voluto a scriverla, è sommariamente "abbastanza" sicura, e il file che viene letto e scritto in memoria, viene sempre gestito lato browser, e alla chiusura dell'applicazione ogni informazione inserita non scaricata nel nuovo file di password, viene perduta.

## Conclusioni

La cosa più divertente da sapere di questa storia è che PassMan è stato scritto interamente in una sola notte, **dalle 8 di sera alle 8 di mattina**, del 22 luglio 2014. Praticamente 12 ore di lavoro hanno portato a questo splendido risultato.

Dopo alcuni ricicli, fisiologici per qualsiasi software, nell'arco effettivo di 10 giorni e lavorando al progetto in ogni minuto libero (pochi, effettivamente), ho completato il progetto. Credo che lo sforzo totale sia stato di circa mezz'ora al giorno per i successivi 8 giorni, per un totale effettivo di circa tre giornate *lavorative* o 24 ore.

Quando ho completato il progetto l'ho usato per qualche tempo, devo dire con parecchia soddisfazione personale. Poi ho scoperto [Unix Pass]. E il mio piccolo progetto è caduto in disuso, visto che l'unico essere umano sulla terra che lo usava smise di farlo.

Ma è stato comunque un divertentissimo esperimento, che mi ha permesso di imparare molto, soprattutto le potenzialità delle applicazioni che vengono eseguite interamente nel browser (alla fine ho utilizzato OpenPGP dentro a un browser).

[Passman]: {{ site.url }}{{ site.baseurl }}/PassMan
[Unix Pass]: https://www.zx2c4.com/projects/password-store/
[MVVM]: https://en.wikipedia.org/wiki/Model–view–viewmodel
