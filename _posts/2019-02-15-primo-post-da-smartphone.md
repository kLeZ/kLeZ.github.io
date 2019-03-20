---
title: "Primo post da smartphone"
date: 2019-02-15 20:53:10 +0100
tags: [github, travisci, jekyll, android, markor, mgit]
---
Questo post viene direttamente dallo smartphone. Neanche uno particolarmente moddato, né tanto meno sono stato così "_hacky_" da portarmi dietro un ambiente ruby+jekyll.  
Ma allora come ho fatto? L'ho compilato sul PC per poi pubblicarlo?  
No! Ovviamente. Altrimenti che lo scriverei a fare: i post servono per raccontare qualcosa di nuovo o di diverso, le banalità ci vergogniamo a pubblicarle (per fortuna!).  

<!--more-->
[read more](){: .invisible #read-more }
{: .m-0 .invisible .zero-size }

## L'idea

Ieri è stato il **Free Software Day**, non sapevo che lo fosse, per me è sempre stato _San Valentino_, come per tutti.  
Invece l'amata [FSFE] ha tirato fuori dal cilindro una iniziativa interessante e stimolante, a cui ho voluto partecipare nel mio piccolo: il Free Software Day.  
Si trattava (o almeno è stato così per me) di esprimere il tuo _amore_ verso gli sviluppatori dei software che utilizzi, sostanzialmente come avviene per San Valentino. Un piccolo gesto per te ma, e lo dico da sviluppatore, enorme per chi sviluppa, dal punto di vista della motivazione.  
Ovviamente la buona FSFE ha messo a disposizione i propri mezzi e dei bellissimi artwork per l'evento. La missione era di condividere uno degli artwork con un link al sito dell'iniziativa [#ilovefs] sul proprio sito o blog o _whatever_ e poi ribaltarlo sui social media per aumentare l'audience.  
Ma io non avevo un sito, un blog si ma inutilizzato da tempo.

Da qui l'idea: mi faccio il sito.  
Si ma come? Dove? Quanto tempo ci metto?  
Non wordpress, altrimenti tanto valeva rispolverare il blog _"elettronicamente tuo"_, e non mi andava.  
Quindi ho pensato: GitHub permette **a gratis** di avere un sito statico presso di loro, completamente _ridondato_ e versionato (ovviamente) con **git**. Ma deve essere statico. E quindi la primissima versione (che potete anche andare a trovare, visto che è tutto sotto VCS) era una index.html con una banale struttura HTML 5 e - _udite udite_ - **bootstrap 4.3**, del quale sono rimasto piacevolmente sorpreso quando ho appreso che quel poco di CSS che pensavo di dover scrivere (e che avevo scritto) non serviva assolutamente a nulla.  
Quindi il mio bellissimo (si fa per dire) omaggio al free software l'ho dato tramite la pubblicazione FI questa semplice quanto efficace paginetta su GitHub Pages.

## Il restyling
Oggi però, terminato lo scopo della giornata di festa, ho deciso di dare a questo _attrezzo_ una struttura più "degna": in fondo è sempre il mio sito personale. Allora mi è venuto in mente un mio vecchio progettino di studio lasciato a morire nei meandri del mio PC. Tentavo di capire cosa fosse e come funzionasse Jekyll, un generatore statico, e come mi capita pressoché ogni volta avevo deciso di comprendere facendo.  
Però avere un sito statico non mi è mai piaciuto: hai sempre necessità di un PC per modificare e pubblicare, perché che tu lo voglia o no scrivere codice su un dispositivo diverso dal PC _fa schifo_. E io spesso ho possibilità di scrivere qualcosa, buttare giù i miei pensieri, condividere qualcosa, solo durante il viaggio casa-lavoro che passo sui mezzi. E in quel tragitto ho solo uno smartphone, non un PC. Quindi da pigro e amante del concetto di cross-device fino alla morte, ho cercato una soluzione che mi permettesse di scrivere dallo smartphone, esattamente quello che sto facendo ora.

## Fase finale
Il sistema scelto è [GitHub] + [Jekyll] + [TravisCI].  
TravisCI mi ha permesso di coprire _l'ultimo miglio_, cioè la parte in cui c'è un aggiornamento nel markdown gestito da Jekyll (aggiungo un post, ad esempio) e il sito statico viene rigenerato e pubblicato. E ci ho messo molto poco a mettere in piedi la baracca.  
Lato "server" siamo pronti! Abbiamo un sito pubblico (grazie a GitHub), abbiamo un motore che processa documenti semplici e li traduce in pagine HTML ben formate e con un aspetto grafico omogeneo (Jekyll) e abbiamo un meccanismo automatico che si sveglia quando _sente_ le modifiche, genera tutto e pubblica sul sito (TravisCI).

## I client
È quasi superfluo parlare del PC, tecnicamente sono sufficienti git e emacs, per comodità posso usare Visual Studio Code (_per quanto sia prodotto da Microsoft e per quanto sia un'app electron, è veramente un ottimo prodotto_), ma non è il PC che è interessante.  
Sullo smartphone (Android, e solo con [f-droid] a disposizione) ho installato [MGit], un ottimo client git con cui posso comunicare con GitHub per scaricare il sorgente del sito per poi modificarlo e caricarlo aggiornato su GitHub pronto per TravisCI, e [Markor], un ottimo editor markdown che posso usare per scrivere.  
Il flusso è questo:
1. Sincronizzo la mia copia di sviluppo con GitHub
2. Creo un nuovo file markdown dove mi serve (si lavora sempre sul branche **dev**)
3. Finito l'editing del testo, salvo faccio il commit delle modifiche e carico tutto su GitHub.
4. TravisCI fa la magia e dopo qualche secondo ho tutto online

Forse, e dico forse, il post è finito e posso pubblicare, questo è il flusso anche se ci sono delle cose che vanno migliorate, come la possibilità di auto popolare un header vuoto per ogni post. E ancora non ho esplorato le possibilità di modifica del layout di Jekyll.

A presto altri aggiornamenti.

[FSFE]: https://fsfe.org
[#ilovefs]: https://ilovefs.org
[GitHub]: https://GitHub.com
[Jekyll]: https://jekyllrb.com
[TravisCI]: https://travis-ci.org
[F-Droid]: https://f-droid.org/
[MGit]: https://manichord.com/projects/mgit.html
[Markor]: https://gsantner.net/project/markor.html
