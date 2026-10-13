---
lang: it
title: "Margaret Hamilton. Cosa porta all'ingegneria, perché è una figura importante (e non perché è una donna)"
tags:
- ingegneria-del-software
- informatica
- storia
- società
date: 2026-10-13 13:24:31+02:00
---

Margaret Hamilton è morta il 30 settembre, a 90 anni. Il MIT l'ha scritto una settimana dopo, e da allora è tornata a girare quella foto: lei giovane, gli occhiali grandi, in piedi accanto a una pila di carta alta quanto lei. La didascalia che di solito le attaccano dice che quello è il codice che ha portato l'uomo sulla Luna, e che l'ha scritto lei.

La foto è vera. La didascalia molto meno, e la versione vera è una storia migliore. Io faccio l'architetto software, e una buona parte del mio mestiere consiste nel dare per scontato che prima o poi qualcuno sbaglierà (io per primo). Quell'idea ha un'origine precisa e sopra c'è il suo nome. Le devo un pezzo fatto bene, con le fonti, comprese quelle che non le fanno comodo.

Esce oggi, 13 ottobre, e la data casca a cecio, come si dice dalle mie parti. Il secondo martedì di ottobre è l'*Ada Lovelace Day*, la giornata che dal 2009 ricorda il lavoro delle donne nella scienza e nella tecnologia (l'ha inventata Suw Charman-Anderson, perché di modelli femminili in giro se ne vedevano pochi). Di solito in queste ricorrenze ci si scambia santini. Io preferisco scrivere.

{% include more.html %}

## In quella pila c'è il lavoro di centinaia di persone

{: .text-center }
![Margaret Hamilton nel 1969, in piedi accanto a una pila di listati stampati del software di bordo di Apollo, alta quanto lei]({% link /media/2026-10-13/margaret-hamilton-listati-apollo-1969.jpg %}){: .img-fluid }

*Margaret Hamilton nel 1969 accanto ai listati del software di bordo di Apollo. Foto del Draper Laboratory, restauro di Adam Cuerden, pubblico dominio, via Wikimedia Commons.*

Parto dalla carta. La didascalia del MIT, che la foto ce l'ha in archivio, dice che sono i *listati* del software delle due squadre di bordo, quella del modulo lunare e quella del modulo di comando, fotografati nel 1969. Don Eyles, uno degli autori del codice dell'allunaggio, ricorda che il listato di un solo programma era spesso una quindicina di centimetri. Fai tu il conto di quanti programmi e quante revisioni ci stanno in una pila così.

Non l'ha scritto tutto lei, dunque. Da architetto questa parte la conosco bene: scrivo molti più documenti che codice, e il software che esce dal mio gruppo resta roba mia, nel bene e soprattutto nel male. Se lei guidava quel lavoro, quella pila è sua. Che ne abbia battuto un centesimo o la metà cambia poco.

Un dettaglio, già che ci siamo. Quel codice era scritto a mano nel senso più letterale:

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> We would write things by hand on coding sheets, then we would give them to keypunchers who would punch them.

A penna su moduli prestampati, poi qualcun altro batteva le schede. Su quel qualcun altro ci torno più avanti.

Sentire proprio del codice scritto da altri capita a chiunque, di mestiere, progetti più di quanto programmi. Progettare vuol dire descrivere come deve funzionare una cosa e consegnare la descrizione a chi la costruirà (con gli edifici si vede meglio: l'architetto, del palazzo, non posa nemmeno un mattone).

A me è successo anni fa, su un lavoro di cui non posso dire né il nome né il cliente. C'era da rifare un vecchio programma desktop rimasto senza manutenzione. Mi hanno dato un fascicolo di schermate in bianco e nero, non numerate e senza documentazione, e un ragazzo alle prime armi: "Devi rifarlo in tre mesi, ti aiuta lui." Per tre mesi ho fatto il formatore, il progettista, il programmatore e quello che va alle riunioni a capire cosa vuole davvero il cliente (spoiler: non lo sa nemmeno lui). Abbiamo consegnato in tempo. Il codice lo scriveva soprattutto lui, io correggevo, e di mio lì dentro ci sarà stato meno del 30% delle righe. Era comunque roba mia.

La pila della foto era roba sua allo stesso modo. Solo che la mia non doveva portare nessuno sulla Luna.

## Ha cominciato dove un errore faceva suonare le sirene

Nasce a Paoli, Indiana, nel 1936. Si laurea in matematica, con filosofia come seconda materia, all'Earlham College nel 1958. Di informatica non ha studiato niente, per l'ottimo motivo che non esisteva niente da studiare.

Nel 1959 arriva al MIT e finisce a lavorare con il meteorologo Edward Lorenz su un LGP-30, un calcolatore a valvole grande come una scrivania e rumoroso come un aereo a elica. Quando doveva correggere un programma srotolava il nastro perforato lungo il corridoio e lo modificava con una matita appuntita: un buco per fare un 1, un pezzo di scotch per fare uno 0. A Lorenz la cosa divertiva parecchio.

Nel 1961 passa al Lincoln Laboratory, sul sistema di difesa aerea SAGE. Lì succede la cosa che secondo me spiega tutto il resto. Quando un programma mandava in crash il calcolatore, la macchina lo faceva sapere a tutto l'edificio con sirene e suoni da nave nella nebbia. Operatori e programmatori arrivavano di corsa a vedere *di chi* era il programma. Lo racconta lei, e aggiunge che non era un segreto chi fosse il colpevole, visto che stava in piedi davanti alla console.

Prova a immaginare il tuo ultimo bug in produzione annunciato così.

## Teneva insieme il codice di tutti

Nel 1965 entra all'Instrumentation Laboratory del MIT, che ha il contratto NASA per il software di bordo di Apollo. Il primo incarico glielo danno perché è l'ultima arrivata: scrivere il programma che parte se una missione senza equipaggio abortisce, tanto non abortirà mai. Lei lo chiama *ForgetIt*. La missione abortisce, il programma gira, e lei diventa, parole sue, un'esperta nel giro di una notte.

Da lì si sposta su quello che chiamavano *software di sistema*. Ed è qui che la storia mi suona familiare. I due veicoli, il modulo di comando e il modulo lunare, avevano due programmi distinti, ma una parte del codice era comune: lo schedulatore, il riavvio, gli allarmi, le routine che gestiscono lo schermo dell'astronauta. Nel sorgente di Apollo 11, che oggi sta su GitHub, ho contato 49 moduli con lo stesso nome nei due programmi. In 25 di questi, tolti i commenti, cambia meno di una riga su dieci, e lo schedulatore e le routine dei display sono uguali per il 98% e oltre. In uno di questi c'è la documentazione per chi lo deve usare, e quel qualcuno viene chiamato *the user*.

Una libreria, in pratica, con il suo manuale. E chi mantiene una libreria usata da tutti sa come va a finire.

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> The systems software was shared by the command module software and the LEM software. [...] Everybody went through it.

Il suo gruppo era di circa 100 persone. Intorno ce n'erano altre 300 o 400, ingegneri di guida e di navigazione che consegnavano il proprio pezzo, e che lei chiamava *guests*, ospiti (in privato, precisa). Gli ospiti pensavano al proprio algoritmo e basta: non gli interessava se la loro priorità pestava i piedi a quella di un altro, o se usavano la stessa memoria di qualcun altro nello stesso momento. A quello doveva pensare lei.

Una volta ha messo una sua modifica nell'area di sistema direttamente nel rilascio del giorno e ha rotto i programmi di tutti. Se li è ritrovati in fila fuori dalla porta. Da quell'errore ha tirato fuori due regole: le modifiche si provano prima in una versione separata, e ogni giorno parte un promemoria che dice cosa è entrato nel rilascio. Quei promemoria esistono ancora. Uno, del 2 maggio 1968, comincia così:

> citation "M. Hamilton, COLOSSUS Memo #56, 2 maggio 1968" [https://www.ibiblio.org/apollo/Documents/COL56.pdf]
> Revision 200 was BAD.

Seguono venti modifiche numerate. Chiunque abbia scritto un changelog riconosce il genere.

Poi c'è il codice. Nel listato del modulo di comando che ha volato su Apollo 11, accanto al flag che governa i *priority display*, cioè gli avvisi che scavalcano qualunque altra schermata, il commento rimanda a una persona:

```
PDSPFLAG	=	063D		# CAN'T INTERRUPT	SEE M. HAMILTON
					# PRIORITY DISPLAY
```

Sta nel file [`ERASABLE_ASSIGNMENTS`](https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/ERASABLE_ASSIGNMENTS.agc) di Comanche 055. Le due colonne dicono cosa vuol dire il flag acceso e cosa vuol dire spento. Per il secondo caso la documentazione è: chiedi a lei.

Il ciclo di navigazione in volo propulso dello stesso programma porta in testa `MOD NO. 00 BY M.HAMILTON DEC.12, 1966`. E la pagina delle approvazioni, datata 28 marzo 1969, la indica come *Colossus Programming Leader*, responsabile della programmazione del modulo di comando.

Su un punto la sua memoria e le carte non coincidono, lo scrivo per dovere di cronaca. Lei ricorda di aver preso in mano tutto il software di bordo, lander compreso, intorno ad Apollo 8, cioè a fine 1968 (e lo dice proprio, di date assolute non ne ricorda, solo relative). Le carte del marzo e del luglio 1969 parlano ancora del solo modulo di comando. Nel 1971 firma come direttrice di tutta la programmazione di volo. Da qualche parte fra quelle date la responsabilità è diventata sua per intero, e onestamente non so dire il giorno.

## Sua figlia ha trovato il bug prima degli astronauti

Lavorava di notte e nei fine settimana, e si portava dietro la figlia Lauren, ancora bambina. Lauren la guardava giocare a fare l'astronauta sul simulatore e voleva giocare anche lei. Un giorno preme dei tasti e la missione simulata va giù.

Aveva selezionato `P01`, il programma di prelancio, in pieno volo. Due programmi si erano messi a usare la stessa memoria.

Hamilton chiede di aggiungere un controllo: se qualcuno seleziona `P01` in volo, il software rifiuta. Le rispondono di no. Gli astronauti sono addestrati, quell'errore non lo faranno mai. Le concedono una nota nella documentazione.

Dicembre 1968, Apollo 8, la prima volta che un equipaggio va intorno alla Luna. Jim Lovell seleziona `P01` in volo. I dati di navigazione spariscono. A Cambridge sono in tre chini sui listati a cercare cosa è successo, e lei dice che è il bug di Lauren. Era il bug di Lauren. La correzione entra dalla missione successiva.

Di tutta la storia questo è il pezzo più solido e quello che mi riguarda di più. Progettare partendo dal presupposto che l'utente sbaglierà, anche se è il pilota collaudatore più addestrato del pianeta, oggi è una banalità. Nel 1968 era la proposta di una programmatrice, bocciata dai capi.

{: .text-center }
![Meme: una donna al microfono, con la scritta "Me explaining how to use the program", guarda una seconda donna, etichettata "User", che lecca l'esterno di una tazza etichettata "the program"]({% link /media/2026-10-13/meme-utente-e-programma.png %}){: .img-fluid }

## Il 20 luglio non ha salvato la missione da sola

La scena la conosci. A pochi minuti dall'allunaggio il computer del modulo lunare accende un allarme, 1202, e poi altri quattro. Houston dà il via libera, Armstrong atterra.

La versione eroica dice che il software di Hamilton salvò la missione. La ripercorro con ordine, perché quello che resta in piedi alla fine le basta e avanza.

Il computer era sovraccarico perché qualcosa gli stava rubando circa il 13% del tempo di calcolo. Eyles ha ricostruito la causa in un saggio del 2004: un documento di interfaccia fra il sistema di guida del MIT e un apparato Grumman chiedeva che due alimentazioni avessero la stessa frequenza e si dimenticava di chiedere la stessa fase. Il difetto era stato visto ai collaudi, annotato e lasciato lì. Hamilton, nel 1971 e ancora nel 2009, lo attribuisce a un errore nella procedura degli astronauti. Su questo ha ragione Eyles, che ha i documenti.

Il computer non si è piantato per due ragioni. La prima è lo schedulatore a priorità, che è di Hal Laning: Eyles scrive che lo progettò senza avere nessun esempio a cui ispirarsi, ed è ancora un buon progetto. La seconda è la *protezione dal riavvio*: il software ripartiva dall'ultimo punto sicuro e lasciava cadere i compiti meno urgenti. Era stata pensata per i guasti elettrici e contro il sovraccarico ha funzionato per un effetto in parte imprevisto, come ammette lo stesso Eyles.

Il via libera lo diedero Steve Bales e Jack Garman a Houston, insieme a Russ Larson, l'uomo del MIT in sala. Da Cambridge non ci fu il tempo di dire niente. Hamilton era nella sala di collegamento del laboratorio, ad ascoltare.

Cosa c'entra lei, allora. Qui devo applicare a lei lo stesso metro che applico agli altri.

Hamilton ha sempre raccontato che quel giorno gli allarmi arrivarono all'equipaggio come *priority display*, e i priority display erano un meccanismo suo. Che fossero suoi è documentato: nell'indice dei promemoria del laboratorio ne risulta uno a suo nome, del 27 febbraio 1968, intitolato "COLOSSUS Priority Displays" (purtroppo non ho trovato il testo in rete, ma l'indice dell'archivio lo elenca con numero, data e autrice, e quindi l'ho inserito), le routine dei display stanno nella parte di codice comune ai due veicoli, e nel listato del modulo di comando il flag relativo rimanda a lei. Sua, per come la racconta, era anche la soluzione al problema più sottile: come fa l'astronauta a sapere a quale schermata sta rispondendo, se gliene compare una nuova sotto le dita. Prima di premere, conta fino a cinque.

Che il 20 luglio gli allarmi siano passati di lì, invece, non l'ho trovato. Eyles racconta che si accese la spia `PROG` e che fu Aldrin a chiedere il codice, digitando verbo 5 nome 9. E nel listato del modulo lunare la routine che scatta in quel caso, `BAILOUT`, accende la spia e fa ripartire il software. Il commento dice che l'allarme accende la luce *ma non mostra niente*. Il priority display è un'altra strada, e a leggere quel codice per il 1202 non viene presa. Non sono un esperto di quell'assembly, quindi prendila come la lettura di uno del mestiere e non come una perizia.

Resta il riavvio, che è la cosa che ha tenuto in piedi il computer e che stava nell'area di sistema, cioè in casa sua. Chi abbia scritto quali righe, dalle fonti che ho letto, non si evince. La storia ufficiale del MIT sul software, del 1971, in quasi trecento pagine non nomina mai Hamilton, né Laning, né Eyles.

## Il mito le ha regalato il lavoro degli altri

Qui la faccenda si fa strana, perché Hamilton è stata trattata male due volte, in due direzioni opposte.

La prima volta le hanno tolto. Il lavoro con Lorenz, quello del nastro e della matita, è il lavoro da cui è nata la teoria del caos. Lorenz la ringraziò nei suoi articoli, come ringraziò Ellen Fetter, la programmatrice che Hamilton aveva assunto e formato al suo posto: "Special thanks are due to Miss Ellen Fetter for handling the many numerical computations". Una riga, con il *Miss* davanti. Chi ha raccontato il caos nei cinquant'anni successivi ha tolto anche quella. Le due sono riemerse nel 2017, quando un geofisico del MIT ha riletto i ringraziamenti e si è chiesto chi diavolo fosse Ellen Fetter.

Con Apollo è andata allo stesso modo. La storia del software scritta dal MIT nel 1971 non nomina né lei, né Laning, né Eyles e chiude con un equanime "whatever kudos are due belong to us all". Quella della NASA del 1988, nelle pagine sul software di Apollo che ho letto, cita i controllori di Houston e nessuno dei tre. Nel 2003, quando la NASA finalmente la premia, il funzionario che l'ha candidata dichiara di essersi stupito scoprendo che nessuno l'aveva mai fatto prima.

La seconda volta le hanno dato, e le hanno dato roba non sua. Quando la foto è diventata virale è partito il risarcimento all'ingrosso: ha scritto lei il codice della Luna, ha inventato lei lo schedulatore a priorità, ha coniato lei l'espressione *software engineering*. La motivazione della Medaglia presidenziale della libertà, nel 2016, parla di lei che scrive "the code that helped America set foot on the moon". Wikipedia, mentre scrivo, dice ancora che il termine l'ha coniato lei.

Non l'ha coniato lei. Compare negli annunci di una rivista di settore nel giugno 1965, lo usa Anthony Oettinger nella lettera del presidente dell'ACM dell'agosto 1966, e la conferenza NATO del 1968 lo mette in circolazione.

La cosa notevole è che lei non l'ha mai preteso. È più prudente di tutti i suoi ammiratori:

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> It was a term that had not been heard about at Draper. Had it been heard about in Russia or somewhere else? Who knows.

Anche i colleghi hanno fatto la loro parte. Eyles, in cinquantanovemila caratteri sull'allunaggio, non la nomina mai. Lei, in tre ore di intervista, non nomina mai lui e nemmeno Laning. Ci ho cercato una lite onestamente, perché sembrava avessero discusso, e non l'ho trovata. Ho trovato due persone che raccontano la stessa impresa ciascuna da dentro il proprio gruppo: lui ricorda il suo algoritmo, lei ricorda il sistema che teneva insieme gli algoritmi degli altri. Il lavoro di integrazione ha questo difetto: quando funziona, non lascia niente da raccontare.

## L'ingegneria del software era una battuta

Al laboratorio c'erano gli ingegneri veri, quelli dell'hardware e dell'aeronautica, e poi c'erano *the programmers*. La parola non aveva il peso che ha oggi. Indicava quelli che prendevano le decisioni degli ingegneri e le facevano girare su una macchina, più o meno come *computers*, vent'anni prima, indicava le donne che facevano i calcoli. Lei lo dice senza giri di parole: eravamo cittadini di serie B.

Lavorando alle simulazioni si accorge che i problemi del suo gruppo e quelli dell'hardware si somigliano, e che c'è una parte di lavoro, chi interrompe chi e con quale priorità, di cui gli ingegneri non si occupano. Propone di chiamare le due parti *hardware engineering* e *software engineering*. Gli ingegneri la trovano una battuta divertente. "Ecco di nuovo Margaret con la sua ingegneria del software."

Poi, in una riunione affollata, uno dei guru dell'hardware si alza e dice che Margaret ha ragione, che quello che fanno i programmatori è ingegneria quanto la loro, e che è ora di formalizzarla. Nell'intervista, a cinquant'anni di distanza, quando arriva a questo punto le viene da piangere.

Quello che ha fatto dopo è coerente fino alla testardaggine. Due aziende, Higher Order Software nel 1976 e Hamilton Technologies dieci anni dopo, e un linguaggio di modellazione, USL, tutti costruiti sulla stessa idea: gli errori si tengono fuori dal sistema per come il sistema è definito, prima ancora di cercarli con i test. Non mi risulta che abbia conquistato il mercato. L'idea, in compenso, sta dentro ogni revisione del codice, ogni controllo sull'input, ogni sistema che degrada invece di cadere, cioè dentro il mio lavoro di tutti i giorni.

## Era una donna in un laboratorio di uomini

Tutto quello che ho scritto fin qui succede in un posto e in un tempo precisi, e senza quelli non si capisce perché intorno a lei ci sia tanta confusione.

Entra al laboratorio nel 1965. La legge federale sulla parità di paga ha due anni, quella sui diritti civili ne ha uno. Nel 1963 al MIT ci sono circa 240 donne in tutto l'istituto, 120 delle quali studentesse dei corsi di laurea, e il primo dormitorio femminile del campus è appena stato inaugurato. Fino al 1974 una banca può legalmente chiedere a una donna la firma del marito per concederle un prestito.

Sotto la sua firma, sul programma che va sulla Luna, ci sono sei approvazioni. Sei uomini. "All guys", dice lei, e tutti ingegneri.

Scopre che alcuni colleghi guadagnano il doppio delle donne, e quando chiede perché le spiegano che le donne si sposano e le mantiene il marito. Una sua collaboratrice va alla cassa di credito del MIT per un prestito e le chiedono la firma del coniuge. Hamilton ci va di persona e domanda se a un uomo chiederebbero la firma della moglie. La regola, che era una regola del cazzo anche per quegli anni, viene cambiata. Ironicamente, gli uomini del comitato le danno ragione, mentre un paio di donne obiettano che secondo loro il marito dovrebbe approvare. Così, per sentirsi ancora parte del patriarcato.

E poi c'è la persona che punzonava le sue schede. Una donna nera, con uno o due figli, che perforando il codice le trovava pure degli errori. Hamilton racconta che in seguito ha studiato ed è diventata medico, o avvocato. Non ne dice il nome. Nel 1967, primo anno per cui esiste il dato, una donna nera che lavorava a tempo pieno negli Stati Uniti prendeva 43 centesimi per ogni dollaro pagato a un uomo bianco. Quella donna, di fatto, faceva revisione del codice di Apollo.

Devo essere onesto su una cosa, perché lei lo era. Hamilton non si è mai raccontata come una vittima. Dice che allora la distinzione si sentiva meno di quanto si creda, che se lavoravi bene ti davano più responsabilità, e che per certi versi oggi è peggio, perché il bullismo è anonimo e non sai a chi rispondere. Sua figlia ricorda di aver ricevuto da lei la certezza che di barriere non ce ne fossero. Io le credo, anche perché il suo era un ambiente tutto sommato privilegiato, acculturato, pieno di menti brillanti, meno avvezzo a certe idee animalesche. E credo anche che una persona possa attraversare un sistema truccato a testa alta senza che il sistema smetta di essere truccato.

Non è un caso isolato, e gli altri sono ben noti. Nel 1946 l'ENIAC viene presentato alla stampa senza una parola sulle sei donne che lo avevano programmato. Lise Meitner spiega la fissione nucleare e il Nobel del 1944 va solo a Otto Hahn. Chien-Shiung Wu dimostra in laboratorio la violazione della parità e il Nobel del 1957 va ai due teorici che l'avevano ipotizzata. La Foto 51 di Rosalind Franklin arriva sotto gli occhi di Watson senza che lei ne sappia niente, e uno studio uscito pochi giorni fa mostra che lei la struttura a elica l'aveva già ricavata dalla foto 49, che aveva una macchia. La famosa 51 era la ripetizione *in bella*, fatta apposta.

A loro il merito è stato tolto e basta. A Hamilton è stato tolto, poi restituito con gli interessi, a mio avviso sbagliando doppiamente. In tutti e due i casi qualcun altro ha deciso che cosa la storia avrebbe dovuto dire di lei.

## Quello che le dobbiamo

Ha passato sessant'anni a dire una cosa sola: le persone sbagliano, tutte, e un sistema serio anticipa l'errore e lo previene. Gli astronauti sbagliano. I programmatori sbagliano, lei compresa, con la fila fuori dalla porta. Chi scrive le specifiche sbaglia e si dimentica di citare *la fase*.

Ci aggiungo io che sbaglia anche chi scrive la storia, per pigrizia quando la cancella e per troppo affetto quando la gonfia.

Margaret Hamilton è una figura importante per il lavoro che ha fatto. Non per una foto, e non perché era una donna.

## Fonti

- [Necrologio del MIT, 7 ottobre 2026](https://news.mit.edu/2026/margaret-hamilton-computing-pioneer-dies-1007)
- [Storia orale di Margaret Hamilton, Computer History Museum, intervista di David C. Brock, 13 aprile 2017](https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf)
- [Sorgente di Apollo 11, Comanche 055 e Luminary 099](https://github.com/chrislgarry/Apollo-11)
- [Pagina delle approvazioni di Comanche 055, 28 marzo 1969](https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/CONTRACT_AND_APPROVALS.agc)
- [COLOSSUS Memo #56, 2 maggio 1968](https://www.ibiblio.org/apollo/Documents/COL56.pdf) e [archivio dei documenti del progetto Virtual AGC](https://www.ibiblio.org/apollo/links.html)
- [Margaret H. Hamilton, "What the Errors Tell Us", IEEE Software, 2018](https://wehackthemoon.com/sites/default/files/2019-07/what-the-errors-tell-us-3%20%281%29.pdf)
- [MIT News, "Recalling the 'Giant Leap'", 2009](https://news.mit.edu/2009/apollo-vign-0717)
- [Don Eyles, "Tales from the Lunar Module Guidance Computer", 2004](https://www.doneyles.com/LM/Tales.html)
- [R-700, "MIT's Role in Project Apollo", vol. V, "The Software Effort", 1971](https://www.ibiblio.org/apollo/hrst/archive/1137.pdf)
- [James Tomayko, "Computers in Spaceflight: The NASA Experience", cap. 2, 1988](https://web.archive.org/web/2020/https://history.nasa.gov/computers/Ch2-6.html)
- [Comunicato NASA sul premio del 2003](https://nasa.gov/wp-content/uploads/static/history/alsj/a11/a11Hamilton.html)
- [Joshua Sokol, "The Hidden Heroines of Chaos", Quanta Magazine, 2019](https://www.quantamagazine.org/hidden-heroines-of-chaos-ellen-fetter-and-margaret-hamilton-20190520/)
- [Bertrand Meyer, "The origin of 'software engineering'"](https://bertrandmeyer.com/2013/04/04/the-origin-of-software-engineering/)
- [Paul Ceruzzi, "The 'Rope Mother' Margaret Hamilton", National Air and Space Museum, 2016](https://airandspace.si.edu/stories/editorial/rope-mother-margaret-hamilton)
- [MIT, comunicato dell'ottobre 1963 sulle studentesse](https://cdn.libraries.mit.edu/dissemination/diponline/AC0069_NewReleases/NewsRelease_1960/AC0069_1963/AC0069_196310_020.pdf)
- [Census Bureau, redditi del 1967](https://www.census.gov/library/publications/1969/demo/p60-60.html) e [National Women's Law Center](https://nwlc.org/?p=80733) per il dato sui 43 centesimi
- [IEEE Spectrum, le programmatrici dell'ENIAC](https://spectrum.ieee.org/untold-history-of-ai-invisible-woman-programmed-americas-first-electronic-computer)
- [APS News, Lee, Yang e Wu](https://www.aps.org/apsnews/2022/09/lee-yang-parity)
- [Embryo Project, "Photograph 51"](https://embryo.asu.edu/pages/photograph-51-rosalind-franklin-1952) e [King's College London, 9 ottobre 2026, sulla foto 49](https://www.kcl.ac.uk/news/rosalind-franklin-deliberately-created-photo-51-after-earlier-photograph-revealed-dnas-structure)
- [Equal Pay Act del 1963](https://www.eeoc.gov/statutes/equal-pay-act-1963), [Titolo VII del Civil Rights Act del 1964](https://www.eeoc.gov/statutes/title-vii-civil-rights-act-1964) e [Smithsonian, sull'Equal Credit Opportunity Act del 1974](https://www.smithsonianmag.com/blogs/smithsonian-american-womens-history-museum/2024/10/28/voices-on-independence-four-oral-histories-about-building-womens-economic-power/)
- [Ada Lovelace Day, data e origine](https://www.timeanddate.com/holidays/fun/ada-lovelace-day)
- [La foto su Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Margaret_Hamilton_-_restoration.jpg)
