---
title: IHC e ransomware
tags: ihc ransomware talk hackers camping
date: 2019-03-19 21:23:01+01:00
---

Sono profondamente in ritardo, lo so.  
Sono stato a questo campeggio qualcosa come 7 mesi e mezzo fa, e andava riportato, ma non sapevo dove quindi non l'ho fatto; non me ne vogliate.

Iniziamo dall'inizio. IHC significa _Italian Hackers' Camp_, e il genitivo sassone è una di quelle cose di cui in IHE (_Italian Hackers' Embassy_) abbiamo discusso di più. Come da tradizione di ogni gruppo hacker che va a soffermarsi sul dettaglio. Questo è un po' _hacking_ alla fine.

IHC è un evento biennale che si è tenuto per la prima volta nel 2018 a Padova, se ti interessa vai sul [sito di IHC](https://ihc.camp).

La community intorno a IHC e IHE, e soprattutto l'associazione che ha ideato, organizza e promuove la community e il campo, sono di quegli agglomerati molto attivi e pieni di gente bellissima.

In quel di Padova, tra il 2 e il 5 di agosto, ho partecipato a questo bellissimo evento, mi sono divertito e ho imparato veramente tante cose, ho conosciuto della bella gente e non ultimo ho tenuto un talk, che è poi il motivo del titolo di questo post.

Il talk verteva sulla tematica dei malware, dei ransomware nello specifico, dando alcuni numeri e spiegando in parole semplici cosa sono e come si diffondono. Ripropongo qui il transcript, il materiale preparatorio, le fonti e la presentazione. In calce alla pagina troverai anche il video del talk, disponibile comunque su YouTube nel [canale di IHC2018](https://www.youtube.com/channel/UCV9Dbt9F5pg1qWA1By-1tJg).
<!--more-->

## Ransomware, efficacia alle stelle: un po' di numeri, vettori e target più un extra

Il livello di rischio legato a questo tipo di malware, che ormai di nuovo non ha davvero più nulla, è attualmente tra i più altri finora registrati. L'infezione si attesta in crescita anche nel primo trimestre 2018.

La cosa che più sconvolge di questa categoria di malware, è la quasi totale assenza di soluzioni _post_ infezione; l'unica strada realistica attualmente percorribile è la prevenzione, non solo a mezzo di anti-malware, che poco possono contro questa estesa minaccia, ma anche (e soprattutto) con dei metodi più _rudimentali_ come il backup dei dati su sistemi e/o supporti di storage esterni all'host infetto.

Navigheremo tra le pieghe della negligenza, analizzeremo vettori e target, dai più consueti ai più insoliti, e ricreeremo il brainstorm creativo che permette agli hacker senza scrupoli di creare questi veri e propri gioielli dell'ingegneria sociale divenuti oramai anche piuttosto remunerativi.

### Efficacia e alcuni dati

Di fatto questo metodo è l'unico che garantisce la salvaguardia dei dati, a patto che l'utente sia molto **molto** attento alla gestione dei dati, cosa che spesso non accade (e non solo per i privati o le PMI [piccole medie imprese; ndr]).

Solo nello scorso anno la frequenza di infezioni ai danni di privati è passata da **0,05 i/s nel Q1 2017** a **0,1 i/s nel Q3 2017**, di fatto ottenendo una **crescita del 100%**.
Per lo stesso periodo di riferimento le aziende sono state colpite **ogni 40 s nel Q3 2017**, crescendo di fatto anche qui di **oltre il 100%**.

Per completare il ciclo di statistiche appena evidenziato, fino allo scorso anno (e sicuramente in aumento quest'anno, staremo a vedere) **il 60% dei payload (6 su 10) erano ransomware**.

Visto che si parla di hacking e non è una conferenza di McAfee o Kaspersky, vediamo qualcosa di più interessante dei numeri.

Scavando un minimo di più la cosa che appare evidente (e interessante!) è la nascita di "aziende" specializzate in ransomware. Di fatto, esattamente come succede con servizi leciti, esistono dei servizi in abbonamento che permettono di configurare e lanciare una campagna di estorsioni digitali: dei veri e propri **RaaS**, in puro stile _cloud_.

La cosa interessante da questo punto di vista è il design di architetture, infrastrutture e moduli che è in realtà tipico del lavoro _enterprise_ e molto desueto nel mondo hacker, che di solito è più basato sulla sperimentazione e sull'artigianato digitale.
Insomma, con questa nuova minaccia l'approccio è molto più _corporation_ che nella quasi totalità delle altre minacce presenti in rete.

### Vettori: *canonici* e *insoliti*

Esempi tipici di vettori sono le iper sottovalutate email che con delle tecniche di _social engineering_ spesso "artistiche" e grossolane riescono comunque a infettare centinaia di migliaia di vittime (**scimmie** è un termine tecnico spesso usato come sinonimo in questi casi).

Noi di solito archiviamo il caso con un **PEBCAK** e con una serie di meritati insulti al primate di turno.

Diversamente capita per chi invece è ingenuamente invogliato a scaricare ed eseguire il malware. Alcuni vettori piuttosto insoliti colpiscono le ignare (e ingenue) vittime che invece di passare attraverso ore e ore di sudato _gaming_ preferiscono una **mod** per _cheattare_ e immancabilmente vengono puniti per il tentativo.

Un esempio reale di questo vettore piuttosto insolito è una "mod" per Minecraft che era addirittura a pagamento e funzionante e che una settimana dopo l'installazione attivava il malware (probabilmente per cifrare ogni cosa lentamente evitando di essere rilevato).

### Target: *canonici* e *insoliti*

Considerata la necessità computazionale dei ransomware, i target soliti sono i PC piuttosto che dispositivi mobili o embedded (_IoT_ , per i più hipster), per quanto comunque non manca chi tenta di entrare nella nicchia di business del device ransom, attualmente non molto praticata ma probabilmente piuttosto redditizia.

Tra i target soliti sicuramente i più colpiti sono i PC aziendali, per l'ovvia probabilità di archiviare dati più importanti di una cartella piena di mkv o di mp3 o di semplici (e probabilmente poco importanti) fogli di calcolo contenenti il bilancio domestico.

Tra i target insoliti, per contro, ci sono tutti i sistemi di _cloud storage_ che, per ora, sono considerati sicuri (e vengono sistematicamente usati per i backup).

Per quanto Google sia sicuramente più capace e sistematica nel fare i backup alle vostre foto, per evitare la perdita di dati, che sono più importanti per loro che per noi, tendo a non fidarmi troppo dei computer altrui preferendo ricorrere al vecchio hard disk esterno che torna offline appena terminato il backup.

Non posso non guardare in avanti verso altri tipi di **ransom attack** più pericolosi che prevedono l'attacco ai _big data_ sempre più personali legati all'IoT. Non ci sono ancora dati in merito, ma penso che ne sentiremo parlare.

C'è una pletora di dati, legati alle cosiddette _smart home_ e che vengono grossolanamente tenuti in casa senza particolari protezioni o meccanismi di backup automatico. Immaginate se il vostro pannello **command & control** che controlla frigorifero, tapparelle, allarmi, serratura di casa (!!) e magari anche la porta del garage perdesse ogni informazione (o che queste siano cifrate): probabilmente vi ritrovereste a non poter entrare in casa vostra e l'unico modo per tornare a farlo sarebbe pagare un riscatto per far tornare al loro posto tutti i dati.  
Questo è ovviamente piuttosto fantascientifico (e strizza l'occhio verso Mr. Robot) ma è perfettamente realizzabile con la attuale tecnologia.

Immaginate cosa succederebbe se questo tipo di attacco fosse portato verso gli **Amazon Go** o verso i loro kit per _smart home_, **Echo** e **Key**.

## Esempio pratico: *Super Mario: Ransom for Peach*

Riprendendo l'idea della mod di Minecraft e qualche altro spunto da alcuni film ormai di culto (Jumanji e Saw) porto un esempio pratico.

Un videogioco, l'ennesimo capitolo di **Super Mario**, in cui però quello che succede è che **Bowser** (lo storico _villain_) cifra tutti i tuoi dati in cloud (**GDrive**) e l'unico modo per decifrarli è trovare **Peach** e finire il gioco.

Questo sarebbe un modo piuttosto _divertente e sadico_ di sviluppare un ransomware, e l'attacco di ingegneria sociale alla base riuscirebbe con una probabilità piuttosto elevata, considerando il fatto che oggi la funzione di salvataggio in cloud è pressoché ubiqua e che quindi qualsiasi ignaro giocatore darebbe il proprio consenso.

Con la possibilità di leggere e scrivere liberamente (perfino autorizzati legalmente dal proprietario!), e con degli SDK molto ben fatti, sarebbe relativamente semplice e comodo produrre un software di questo tipo usando un qualsiasi linguaggio di alto livello (C# o Java) e delle piattaforme di sviluppo molto consolidate (LibGDX o Unity3D).

## Final thoughts: *dati a rischio, la causa è l'anello debole (ovviamente)*

{: .text-center }
![AIDS-Trojan]({% link /media/2019-03-19/ihc-e-ransomware/AIDS-Trojan.jpg %}){: .img-fluid }

Non siamo nuovi a questa minaccia, la cui prima apparizione risale addirittura al 1989, anno in cui il Dott. Popp, *evolutionary biologist* della Harvard University, inviò **20.000 floppy** disk ad alcuni partecipanti alla conferenza internazionale sull'AIDS. Il malware è stato ovviamente soprannominato *The AIDS Trojan* e *PC Cyborg*, per la tecnica di ingegneria sociale usata per lo *spreading*.

Dopo **90 riavvii**, il malware nascondeva tutte le directory e cifrava tutti i nomi dei file, chiedendo un riscatto di **$ 189.00** da inviare a mezzo posta alla *PC Cyborg Corp.* con base a Panama.

## Risorse su cui ho studiato e da cui ho preso dati e immagini

Queste sono le risorse che ho usato per preparare il talk, e da cui ho preso i dati che cito.  
Malwarebytes ha pubblicato un report (come ogni anno) in cui spiega nel dettaglio quali sono i vettori comuni e dettaglia addirittura fino ad arrivare alle CVE.  
Il pdf è disponibile previa registrazione, motivo per cui pur avendolo non posso condividerlo.

* [Sensors Tech - Q1 2018 Malware Report: Ransomware Dethroned by Cryptominers](https://sensorstechforum.com/q1-2018-malware-report-ransomware-dethroned-cryptominers/)
* [SecureList - IT threat evolution Q1 2018. Statistics](https://securelist.com/it-threat-evolution-q1-2018-statistics/85541/)
* [Datto - Common Types of Ransomware](https://www.datto.com/blog/common-types-of-ransomware)
* [Symantec - ISTR 2018](https://www.symantec.com/security-center/threat-report)
* [Fortinet Threat Landscape Report Reveals an Evolution of Malware to Exploit Cryptocurrencies](https://www.fortinet.com/corporate/about-us/newsroom/press-releases/2018/fortinet-threat-landscape-report-reveals-an-evolution-of-malware.html)
* [TrendMicro - 3 reasons the ransomware threat will continue in 2018](https://blog.trendmicro.com/3-reasons-the-ransomware-threat-will-continue-in-2018/)
* [MalwareBytes - Malwarebytes Annual State of Malware Report Reveals Ransomware Detections Increased More Than 90 Percent](https://press.malwarebytes.com/2018/01/25/malwarebytes-annual-state-malware-report-reveals-ransomware-detections-increased-90-percent/)
* [2017 Ransomware Trend Report and Forecast for 2018](https://blog.360totalsecurity.com/en/2017-ransomware-trend-report-2018-forecast/)

## Il talk per intero (grazie @IvoErMejo) e le slide a corredo

[Ransomware: minaccia alle stelle]({% link /media/2019-03-19/ihc-e-ransomware/ransomware.odp %})

{: .embed-responsive-16by9 }
{% include embed-youtube.html video_id="svUxYlMNtLw" %}
