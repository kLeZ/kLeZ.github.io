---
title: Transazioni distribuite saghe e code
tags: spring eventi
date: 2019-07-27 12:56:10+02:00
---

Venerdì scorso ho tenuto un *talk* interno alla mia azienda sulle basi (molto basi) del framework Spring.  
Mi sono concentrato poco sui dettagli, ho preferito puntare verso le potenzialità del framework e le *feature* più innovative e interessanti, con un occhio buono al cloud, vera punta di diamante di tutta la tecnologia Spring.

{% include more.html %}

Subito dopo il *talk* un mio collega mi ha chiesto informazioni su una tematica particolare.

La sua domanda era relativa a delle tecniche, in particolare a librerie e/o pattern di Spring per poter gestire quella che io adesso ho imparato a chiamare "Transazione distribuita". Non ne avevamo individuato il nome lì per lì.

Da architetto ho già risolto questa problematica in *Java* tramite l'uso di *EJB transazionali*, quindi con *JavaEE*, ma mai mi ero posto il problema della transazionalità sui microservizi, liquidando il problema con un accorpamento nel servizio di tutto quello che ritengo atomico durante la scrittura di dati.

> Ma questo pone dei problemi di flessibilità dell'architettura, nonché di scalabilità del sistema.

Ho intuitivamente risposto tramite una nascente metodologia che Spring implementa che è il *Reactive Programming* (Spring implementa le librerie WebFlux).  
Questo paradigma di programmazione cambia completamente l'applicazione ma permette di rispondere a quelle esigenze.

Però per la sua problematica non gliel'ho consigliato perché altrimenti avrebbero dovuto riscrivere tutto il sistema.  
E noi consulenti non *possiamo* riscrivere tutto il sistema.

Non contento personalmente della risposta ho studiato la problematica e ho compreso un pattern architetturale adatto ai sistemi distribuiti che ancora non conoscevo, il pattern [Saga](https://microservices.io/patterns/data/saga.html).

Spring non implementa nulla direttamente, ma è possibile implementarlo sia con una coda (tipo *RabbitMQ* o *ActiveMQ*) sia con un framework chiamato *AxonIQ*, che comprende anche un orchestratore della transazione distribuita (che probabilmente gestisce una coda di messaggi interna, quindi siamo sempre li).

Personalmente, penso che propenderei verso una soluzione più "casereccia" implementando una coda per caso d'uso, non ci ho ancora ragionato per bene.

> Certo è, che ho da studiare qualcosina durante le vacanze :grin:.

Ringrazio il mio collega per la particolare domanda che mi ha spinto a studiare un argomento così interessante!
