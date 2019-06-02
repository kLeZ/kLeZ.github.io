---
title: "FLOSSness di una distro Android"
tags: 
date: 2019-05-27 20:37:41+02:00
---

Da molto tempo ormai sono un utilizzatore di *Android* in versioni alternative alle *ROM* cosiddette *stock*.

Ora, dopo parecchio tempo passato a valutare la situazione, sono pronto per dare il mio giudizio sullo stato di salute di progetti *FLOSS* che possono regalarci un po' di *open source* nella nostra vita quotidiana al fianco del nostro *smartphone*.

{% include more.html %}

## Definizioni

Comincio la trattazione definendo un paio di termini e concetti che ho usato qui sopra.

### Cos'è una ROM

Di fatto una ROM è un termine preso in prestito dal gergo "antico" dei firmware.

Una volta il firmware era in sola lettura per il dispositivo che lo eseguiva (*read-only*) e di conseguenza l'aggiornamento doveva essere eseguito forzando il chip a recepire una nuova scrittura tramite un apposito strumento chiamato "programmatore".

> info ""
> *ROM* quindi significa "*read-only memory*" cioè memoria in sola
> lettura. Parlo di gergo "antico" proprio perché ad oggi le
> memorie dei dispositivi "*embedded*" non sono più in sola
> lettura.

### Cos'è il FLOSS

> info ""
> Il termine è un acronimo che usa anche una parola che
> effettivamente non esiste nel vocabolario inglese
> e che si traduce a grandi linee con:  
> "***Free Libre Open Source Software***".

In termini spiccioli parlo di tutto il software che non solo è *open source* (mi aspetto che tu sappia cos'è, altrimenti [sappilo][open source]) ma anche libero, nei termini *free* *as in freedom*, rafforzato da una parola squisitamente presa in prestito dalle lingue neolatine, *libre* che vuol dire "libero".

## La piattaforma

> citation ""
> Android non è solo Android.

Il sistema che vedi ogni giorno non è un solo sistema, ma di fatto è più un *ecosistema*.

Probabilmente l'hai intuito già solo notando la grande diversità delle varie "incarnazioni" di Android, così come vengono chiamate da quegli orrendi giornalisti mediocri che di informatica, *open source* e **Linux** non ne sanno assolutamente nulla, e che con pochezza grammaticale reinventano un termine che invece esiste ed è di uso comune nell'ambito tecnico.

Il termine che da ora in poi userò, e che dovrai usare anche tu per onorare i poveri tecnici che ogni giorno dedicano la loro vita a costruire qualcosa con cui tu eventualmente puoi farti *selfie* da postare su *Instagram*, è "*distribuzione*", o *distro* per gli amici.

### Cos'è una distribuzione

Lo so che i *cos'è* rientrano tutti nella sezione appena conclusa, e so che questo è il paragrafo in cui si parla della ciccia, dopo aver chiarito il dizionario di base di comune accordo. Però è necessario spiegare cos'è una distribuzione, così ti sarà chiaro anche perché parlo di Android come piattaforma.

Una distribuzione è in linea di massima una selezione di software che concorrono a costituire un sistema operativo, più o meno completo nel software preinstallato.

Partendo dalla base, Android di fatto è un sistema basato su Linux, re troneggiante della definizione di "*distro*", questo è il primo strato.

Lo strato successivo è il software di base per rendere questa *distro* Linux funzionante al minimo indispensabile per poter eseguire un programma, quindi dispositivo pienamente funzionante ma con solo un terminale a disposizione (in alcuni casi neanche quello).

Nello strato successivo troviamo tutta una serie di altri software specifici di Android, più una serie di librerie scritte appositamente per questa piattaforma, che vanno dalla configurazione del modem al processo che esegue le onnipresenti (e onnipotenti) Apps. Questo costituisce il sistema Android minimale, adatto solo a "partire" e visualizzare una scritta sullo schermo: "Hello world!".

Sopra a questo strato minimo, che costituisce il sistema di base e il *Native Development Kit*, vengono poggiate tutte le Apps.  
Se ve lo steste chiedendo, anche l'intera interfaccia utente di Android è un'App, è quella che vedete nominata come "UI Sistema" o "System UI".

Questo, al netto di molte altre cose che ho volutamente tralasciato per necessità prosastica, è quello che è contenuto nel progetto *[AOSP]*, l'*Android Open Source Project*.

AOSP, quindi, è la nostra Piattaforma nonché, volendo essere fiscali, anche una *distro* Linux.

I vari sistemi basati su AOSP che trovi installati sui dispositivi che teniamo sempre in tasca sono distribuzioni, o *distro*.

## Definizione di FLOSSness

Ma cosa rende *FLOSS* una *distro* Android? In molti danno la loro personale definizione. Anche io voglio darne una, vorrei chiarire i punti su cui tutti sono d'accordo e vorrei aggiungere qualche punto che io ritengo fondamentale per evitare che questo sia l'ennesimo inno all'*open source* inutilizzabile che si trova spesso in giro.

Aderire ai principi *FLOSS* per una *distro* significa accettare che tutto il software installato nel dispositivo sia libero.

E già questo è estremamente complicato considerando anche solo i driver per tutto l'hardware proprietario che è contenuto nel dispositivo.

Per me però un dispositivo è veramente *FLOSS* solo quando anche i servizi che vengono invocati dalle app sono liberi, così come i sistemi operativi e le infrastrutture coinvolte.

E questo è **impossibile** a meno di mantenere la propria infrastruttura, costruirsi i propri *smartphone* e farlo solo con [open hardware].

## La verità sta nel *merito*

Di solito direi che la verità sta nel mezzo. Ma in questo caso il mezzo è il compromesso, e il compromesso a mio modesto parere non è abbastanza soddisfacente per essere accettato.

Per mio limite accetto l'impossibilità di costruirmi e gestirmi l'hardware e il firmware, posso fare qualcosa solo da AOSP in su.  
Posto che AOSP è effettivamente *open source*, dovrei a questo punto essere in grado di definirmi soddisfatto della mia *non perfetta* FLOSSness. E invece no.

Perché AOSP da sola o *Lineage OS*, ex *Cyanogen Mod*, che seguo da sempre, o qualunque altra *distro open source* non sono molto utilizzabili così come sono.

La prima *feature* che manca, e davvero si sente tantissimo, è l'*App Store*, quella famosa app che magari non apri così spesso ma che ti serve necessariamente qualora tu voglia **installare un'app**. Ecco, diciamo che la *distro* si salva solo nel momento in cui le app che usi ogni giorno sono preinstallate, e normalmente non è così.

Mancano da morire anche i servizi di localizzazione; Si perché il GPS, che è un pezzettino di hardware da qualche parte nel tuo telefono, da solo sembra non essere sufficiente a garantire che i servizi di localizzazione funzionino a dovere. E ovviamente insieme ai servizi di localizzazione è persa anche l'app di navigazione e mappe.

Una delle *feature* più sottovalutate di sempre, e anche questa mancante ovviamente, è la sincronizzazione con un servizio di *Cloud Storage*; Chiaramente è mancante anche il servizio stesso.

Con molta fatica, negli anni sono riuscito a venire a capo di alcuni di questi punti, ma il merito della soluzione non è mio. La comunità in questi anni è stata piuttosto prolifica nella produzione di app per Android, una su tutte [F-Droid] che pone le basi per una *community* Android *FLOSS* coesa e compatta nella creazione di una *distro* Android **veramente** *FLOSS*, quantomeno nel software.

Il mio *setup* di base comprende queste app:

* [F-Droid](https://f-droid.org/)
* [DAVx<sup>5</sup>](https://f-droid.org/packages/at.bitfire.davdroid/)
* [OpenKeychain](https://f-droid.org/it/packages/org.sufficientlysecure.keychain/)
* [Password Store](https://f-droid.org/it/packages/com.zeapo.pwdstore/) (su questa app ho aneddoti, arriveranno :grin:)
* [K9-Mail](https://f-droid.org/it/packages/com.fsck.k9/)
* [Nextcloud](https://f-droid.org/it/packages/com.nextcloud.client/)
* [Markor](https://f-droid.org/it/packages/net.gsantner.markor/)
* [MGit](https://f-droid.org/it/packages/com.manichord.mgit)

Queste e alcune altre app mi aiutano a non sentire (troppo) la mancanza di *BigG* & co. e mi aiutano a rendere il mio *smartphone* qualcosa di utile piuttosto che renderlo un costoso soprammobile.

Purtroppo siamo ancora in una fase in cui quello che ho fatto io per avere qualcosa di effettivamente usabile richiede grossi sforzi di studio della materia e alcuni compromessi, accettando talvolta semplicemente di non poter fare qualcosa (pochissime operazioni, te lo assicuro, e spesso il motivo non è tecnologico ma etico).

### Uno spiraglio di luce (forse)

Fortunatamente alcuni altri *geek* come me si sono uniti per costruire qualcosa di usabile, qualcosa però che sia "pronto all'uso" piuttosto che l'ennesima ROM da "cucinare" e "solo per smanettoni". Questo *team* ha come obiettivo ultimo una esperienza utente e una facilità di installazione appetibili per l'utente medio, mantenendo però la loro vocazione verso il software libero e la protezione della privacy. Questo include ovviamente l'erosione dei servizi Google in ogni punto del sistema e il passaggio a qualcosa di cui si possa avere più fiducia.

Non ne parlo oltre perché non ne voglio fare una sponsorizzazione, ma comunque sono vicino al progetto e ne sono anche un utente attivo.  
Se per qualche motivo hai maturato curiosità verso questo nuovo sistema, ecco il sito ufficiale di [/e/].

## Conclusioni

Non c'è molto da concludere, visto che la soluzione è molto in divenire. Però posso trarre alcune lezioni da questo ragionamento fatto sul blog.

Innanzi tutto, apprezzo molto lo stato già molto buono dell'ecosistema di alternative libere alle app molto più consumistiche, liberticide e lesive della privacy presenti nello store libero [F-Droid].

Poi, sono molto contento dell'integrazione sempre più buona di servizi protettivi della privacy che stanno nascendo e che crescono sempre più rapidamente, e di questo ne giova particolarmente l'esperienza utente, che ha finalmente anche dei servizi liberi e non solo delle app libere.

Staremo a vedere quanto ancora potranno migliorare le cose grazie a una così bella e ricca community.


[open source]: https://it.wikipedia.org/wiki/Open_source
[AOSP]: https://it.wikipedia.org/wiki/Android#Android_Open_Source_Project
[open hardware]: https://it.wikipedia.org/wiki/Hardware_libero
[F-Droid]: https://it.wikipedia.org/wiki/F-Droid
[/e/]: https://e.foundation
