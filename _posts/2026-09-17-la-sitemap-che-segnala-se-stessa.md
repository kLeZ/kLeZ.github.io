---
lang: it
title: "La sitemap che segnala se stessa"
tags:
- sicurezza
- osint
- scam
- hacking
date: 2026-09-17 10:20:00+02:00
---

Sabato 12 settembre, dopo cena, ho aperto la posta e ci ho trovato una mail arrivata alle 22:39. Oggetto `Medium Risk: Sensitive Paths Disclosed via Sitemap on https://klez.me`, mittente "White Hat 66" (`hsafe240@gmail.com`). Dentro c'era un report di sicurezza sul mio blog, con *severity*, *bug name*, *PoC URL*, *impact* e *suggested fix*, e in fondo la richiesta di un premio. La prima reazione è stata un ghigno di sfida, e la voglia di trovare il tizio per dirgliene quattro.

{% include more.html %}

## Il bug non esiste

Secondo il report, la mia `sitemap.xml` contiene URL di aree che *sembrano* amministrative, interne o comunque non destinate al pubblico. Il testo originale dice *areas that appear to be administrative*, e quell'*appear* è la parola più onesta della mail. Quali siano queste aree, la mail non lo dice. Non c'è un solo path nella segnalazione, e come prova c'è il link alla sitemap stessa.

Il blog l'ho costruito io, con Jekyll, un generatore di siti statici: le pagine vengono generate una volta sola e GitHub Pages le serve così come sono, senza codice applicativo in esecuzione e senza nessun login. Un pannello di amministrazione non c'è, e non avrebbe dove stare. Nella sitemap ci sono i post, `/about/`, `/cv/`, `/contatti/`, `/privacy/` e qualche slide dei corsi in `/lf/`, cioè pagine pubbliche elencate apposta perché i motori di ricerca le trovino, che è il motivo per cui una sitemap esiste ([protocollo su sitemaps.org](https://www.sitemaps.org/protocol.html)).

La sezione *impact* sostiene che il file "directly points attackers to non-public or sensitive areas". Messa accanto all'assenza di path, la frase fa capire come è nato il report. Qualcuno, o più probabilmente qualcosa, ha trovato `klez.me/sitemap.xml` e ha registrato l'esistenza del file come vulnerabilità, senza leggerlo. Uno strumento per cui il bug è che la sitemap esista è uno strumento mediocre, e chi lo usa per chiedere soldi non ha riletto nemmeno quello che gli ha sputato fuori. Bastava aprire il sorgente della home, dove c'è scritto `<meta name="generator" content="Jekyll v3.9.3" />` in chiaro.

La prosa sembra uscita da un modello linguistico, con tutti i campi al loro posto e nessun dettaglio che riguardi davvero il mio sito. La firma, White Hat 66, ha la solennità di un *gamertag*. In chiusura, sotto la voce "White Hat Note", arriva la richiesta:

> citation "White Hat 66"
> We would appreciate hearing about reward or acknowledgment you may offer.

## Beg bounty, non bug bounty

Troy Hunt la chiama [*beg bounty*](https://www.troyhunt.com/beg-bounties/), la taglia chiesta per elemosina. Si prende una configurazione qualsiasi, nei suoi esempi un record DMARC mancante o un header di sicurezza assente, la si impacchetta nel linguaggio di una *vulnerability disclosure* e la si manda a chi un programma di bug bounty non ce l'ha, sperando che paghi per chiudere la faccenda. Secondo [NWS Digital](https://www.nwsdigital.com/Blog/Is-that-Scary-Website-Security-Warning-Email-Legit) chi lo fa prende di mira le organizzazioni piccole, dove spesso non c'è nessuno in grado di distinguere una vulnerabilità da un file pubblico.

È una tentata truffa. L'articolo 640 del codice penale:

> citation "Codice penale, art. 640, comma 1" [https://www.brocardi.it/codice-penale/libro-secondo/titolo-xiii/capo-ii/art640.html]
> Chiunque, con artifizi o raggiri, inducendo taluno in errore, procura a sé o ad altri un ingiusto profitto con altrui danno, è punito con la reclusione da sei mesi a tre anni e con la multa da euro 51 a euro 1.032.

E l'articolo 56:

> citation "Codice penale, art. 56, comma 1" [https://www.brocardi.it/codice-penale/libro-primo/titolo-iii/capo-i/art56.html]
> Chi compie atti idonei, diretti in modo non equivoco a commettere un delitto, risponde di delitto tentato, se l'azione non si compie o l'evento non si verifica.

Il report inventato è l'artifizio, il premio per una vulnerabilità che non esiste è il profitto ingiusto. Con me non ha funzionato, ed è per questo che la truffa resta *tentata*.

Non ho pagato e non ho risposto. Una risposta, anche solo per dire di no, avrebbe confermato che dietro l'indirizzo c'è qualcuno che legge, e quindi un indirizzo su cui riprovarci.

## L'infrastruttura dietro l'indirizzo

Quella notte, senza felpa e senza cappuccio, mi sono messo a leggere gli header.

SPF, DKIM e DMARC risultano validi per `gmail.com`, quindi il messaggio è partito davvero da un account Gmail autenticato e non è spoofing. Il `Message-Id` è `<6aa5b897.e862d496.39e5c9.6c94@mx.google.com>`, l'invio a `smtp.gmail.com` è delle 20:39:51 UTC (le 22:39 in Italia) e ProtonMail ha ricevuto la mail sette secondi dopo.

Il primo dei tre header `Received`, quello più in basso, riporta l'indirizzo del client che si è autenticato su Gmail:

```text
Received: from [192.168.100.57] ([153.117.18.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33ea4fsm15029442f8f.21.2026.09.12.13.39.50
        for <klez@pm.me>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 13:39:51 -0700 (PDT)
```

`192.168.100.57` è l'indirizzo privato della macchina, dietro un NAT; `153.117.18.172` è l'indirizzo pubblico con cui è uscita su Internet. Il registro APNIC assegna quel blocco a Cyber Internet Services Pvt Ltd, provider pakistano noto come Cybernet, e il prefisso `153.117.18.0/24` è annunciato dall'AS9541. Secondo ip-api.com l'indirizzo non appartiene a una VPN, a un proxy o a un servizio di hosting, e la geolocalizzazione lo colloca a Karachi (con la precisione che hanno le geolocalizzazioni).

Al momento del controllo l'IP non compariva in Spamhaus ZEN, SpamCop e Barracuda, ma questo dice poco. Quelle liste si alimentano in buona parte con quello che vedono i server di posta in ingresso, e ai server di destinazione questa mail è arrivata dagli IP di Google.

Mi sono fermato qui, a IP, provider e sistema autonomo.

## Cosa ho fatto

In nottata il piano che mi piaceva di più era un altro: aprire qualche casella usa e getta su Guerrilla Mail e stirarlo un po' (trattandosi di un criminale mi sembrava una gran bella idea, e ancora adesso non mi dispiace). Poi sono andato a dormire, e la mattina dopo ho deciso per questo post e per due segnalazioni.

La prima è andata all'*abuse desk* di Cybernet, `noc-abuse@cyber.net.pk`, l'indirizzo che APNIC indica per quel blocco, con data e ora dell'invio, `Message-Id`, la riga `Received` qui sopra e la disponibilità a inoltrare il messaggio completo. La seconda è andata a Google con il modulo per segnalare gli abusi di Gmail, perché l'account è loro. Non so se qualcuno le leggerà.

Se ti arriva una mail simile, questi sono i segnali:

```text
Subject:  "<Severity> Risk: Sensitive Paths Disclosed via Sitemap on <domain>"
Claim:    sitemap.xml espone aree amministrative o interne
PoC:      l'URL di sitemap.xml, senza un solo path sensibile indicato
Ask:      "reward or acknowledgment" nella nota di chiusura
```

## Lo stesso copione al W3C

Negli archivi pubblici delle mailing list del W3C c'è un thread di dicembre 2024 con la stessa struttura. Un mittente Gmail aveva mandato a ottobre un "Vulnerability Report" sull'*email spoofing* di `w3.org`, con i consigli di rito su DMARC e SPF, e a dicembre è tornato a chiedere conferma "about the reported vulnerability and its bounty reward". Vulnerabilità diversa e altro nome in firma, ma la richiesta è la stessa, e il DMARC da sistemare è proprio uno degli esempi di Troy Hunt.

## Hacker, cracker e cappelli

Nel 1983 esce *WarGames*, con un ragazzo che dal computer di camera sua arriva a un sistema militare, e nello stesso anno un gruppo di adolescenti di Milwaukee, i 414s, finisce sui giornali per essere entrato in diversi sistemi, compreso quello del Memorial Sloan Kettering di New York. Uno di loro va sulla copertina di Newsweek. Per buona parte del pubblico americano quella è la prima volta che si sente parlare di *hacker*, e la parola arriva già con il significato che ha ancora oggi nei telegiornali, dove nel frattempo il ragazzino si è messo il cappuccio.

Nel giro, *hacker* voleva dire un'altra cosa. La RFC 1392 del 1993, un glossario per gli utenti di Internet, lo definisce "a person who delights in having an intimate understanding of the internal workings of a system", uno che si diverte a capire come funziona una macchina dall'interno. Verso la metà degli anni Ottanta, per difendersi dall'uso che ne facevano i giornali, gli hacker avevano coniato *cracker*, una parola apposta per chi entra nei sistemi altrui senza permesso, e anche quella è finita nel glossario.

*Cracker* non ha mai attecchito. Fuori dal giro non la usa nessuno, e in Italia fa pensare ai cracker da sgranocchiare prima che a uno che ti entra nel server. Una parola che sa di merendina sui giornali non funziona.

Ha vinto un'altra immagine, presa dai western, dove il buono porta il cappello bianco e il cattivo quello nero. *White hat* e *black hat* sono entrati nel lessico di chi si occupa di sicurezza, e più tardi si è aggiunto *grey hat* per chi entra senza permesso ma senza intenzioni criminali, e spesso poi avvisa. Oggi, fuori dal settore, "hacker buono" si dice white hat, e lo capiscono tutti.

Il cappello bianco è servito anche a dare un nome presentabile a un lavoro. Un'azienda un *hacker* in casa lo fa entrare malvolentieri, un *white hat* lo mette a contratto. Le taglie sui bug c'erano già prima: nel 1983 Hunter & Ready prometteva un Maggiolino Volkswagen a chi trovava un bug nel suo sistema operativo VRTX ("Get a bug if you find a bug"), e il 10 ottobre 1995 Netscape ha cominciato a pagare chi trovava falle di sicurezza nella beta di Navigator 2.0. Da lì sono venuti i programmi di bug bounty di oggi, con piattaforme che fanno da intermediarie tra aziende e ricercatori e regole scritte.

Chi si mette quel cappello accetta quelle regole. Cerchi vulnerabilità dove qualcuno ti ha dato il permesso di cercarle, dentro uno *scope* scritto, classifichi quello che trovi per *severity* e lo segnali seguendo una *disclosure* coordinata. Se c'è un programma vieni pagato secondo le sue condizioni, di solito solo per finding validi e non già segnalati da altri. Se un programma non c'è puoi segnalare lo stesso, ma soldi non ne chiedi.

## Il cappello di White Hat 66

Chiedere soldi per una sitemap è truffa spicciola, roba da lavavetri al semaforo che ti pulisce il parabrezza senza che tu glielo chieda e poi allunga la mano. Mi fa molto più incazzare la firma.

White Hat 66 si è messo la divisa del bagnino per girare tra gli asciugamani a sfilare portafogli. Il nome che si appunta addosso è quello che ha tirato fuori un mestiere dalla cronaca nera, e lui infrange proprio la regola che separa un white hat da un truffatore: nessuno gli ha chiesto niente, vulnerabilità non ne ha trovate, e vuole essere pagato lo stesso.

Ha preso la forma di un programma di bug bounty, ci ha tolto il programma e si è tenuto la *fattura*.

A un truffatore di mezza tacca un nome vale l'altro, lo so. Solo che per rendere rispettabile quel nome ci sono voluti decenni, e ogni mail come questa lo svaluta un po', perché *white hat* e *bounty* diventano *moneta falsa* in mano a chi le spende per farsi pagare una sitemap.

## La parte che fa male

Della sitemap non mi importa niente, è un file XML che mi genera uno script. Quello che difendo è la parola, e quello che ci sta sotto. [Nel 2010](/2010/03/29/lfs-ovvero-come-crearsi-la-propria-distro-gnulinux-da-zero/) mi compilavo una distro da zero con LFS per capire cosa succede quando premi il tasto di accensione, e [a febbraio](/2026/02/03/il-software-che-non-puoi-smontare/) ci sono tornato sopra, quando LFS ha smesso di documentare System V. Smontare per capire, e lasciare smontabile quello che costruisci: da lì viene tutto il resto, licenze libere comprese.

Su quel terreno uno con un account Gmail è l'ultimo dei problemi. Le stesse parole se le prendono aziende con un ufficio legale e un budget di comunicazione, e le svuotano con comodo. *Open source* è diventata una fase del ciclo di vita commerciale: Elastic passa da Apache 2.0 a SSPL e licenza Elastic nel gennaio 2021, HashiCorp da MPL alla Business Source License nell'agosto 2023, Redis da BSD a RSALv2 e SSPL nel marzo 2024. La motivazione dichiarata è sempre quella, i cloud provider che rivendono il lavoro altrui senza restituire niente, e non è campata per aria. Il risultato è sempre lo stesso: la comunità rifà il lavoro da fuori, con OpenSearch, OpenTofu e Valkey.

Redis però l'ha scritto chiaro, e gliene do atto:

> citation "Redis, 20 marzo 2024" [https://redis.io/blog/redis-adopts-dual-source-available-licensing/]
> First, we openly acknowledge that this change means Redis is no longer open source under the OSI definition.

La libertà del software è diventata un parametro che si aggiusta quando il fatturato lo richiede. *Hacker*, intanto, è finita nei titoli di lavoro: *growth hacker*, parola coniata da Sean Ellis nel 2010 per chi ha come stella polare la crescita delle iscrizioni. Stessa radice, senso ribaltato, e nessuno che se ne scandalizzi.

Quello che si perde per strada è la parte filosofica, che poi era il motore di tutto: l'idea che capire come funziona una cosa sia un diritto, e che il software si apra come si apre il cofano di una macchina. Se quell'idea la svuoti, resta un mercato di servizi con dentro qualche parola vintage buona per il marketing.

Una mail come quella di White Hat 66 fa ridere per dieci minuti, poi fa incazzare, e alla fine fa male, perché è la versione da quattro soldi di un furto che qualcun altro sta facendo all'ingrosso, con gli avvocati pagati e i comunicati stampa.

White Hat 66, se leggi: il cappello non era della tua taglia. Ma la taglia gliel'hanno cambiata altri, molto prima di te.

## Fonti

- Sitemaps.org, [protocollo XML dei sitemap](https://www.sitemaps.org/protocol.html)
- Troy Hunt, [Beg Bounties](https://www.troyhunt.com/beg-bounties/), 8 novembre 2021
- NWS Digital, [Is that Scary Website Security Warning Email Legit?](https://www.nwsdigital.com/Blog/Is-that-Scary-Website-Security-Warning-Email-Legit), 29 dicembre 2021
- Codice penale, [art. 640](https://www.brocardi.it/codice-penale/libro-secondo/titolo-xiii/capo-ii/art640.html) e [art. 56](https://www.brocardi.it/codice-penale/libro-primo/titolo-iii/capo-i/art56.html), testo su Brocardi
- APNIC, [RDAP per 153.117.18.172](https://rdap.apnic.net/ip/153.117.18.172), e RIPE Stat, [prefix overview dello stesso indirizzo](https://stat.ripe.net/data/prefix-overview/data.json?resource=153.117.18.172)
- W3C, [thread pubblico del dicembre 2024](https://lists.w3.org/Archives/Public/public-website-redesign/2024Dec/0003.html)
- Alex Orlando, [The Story of the 414s](https://www.discovermagazine.com/the-story-of-the-414s-the-milwaukee-teenagers-who-became-hacking-pioneers-41882), Discover Magazine, 10 ottobre 2020
- [RFC 1392, Internet Users' Glossary](https://www.rfc-editor.org/rfc/rfc1392.txt), gennaio 1993, e [Wikipedia, Security hacker](https://en.wikipedia.org/wiki/Security_hacker), che riporta la voce "cracker" del Jargon File
- Cadre, [Winning Bug Wars: From Volkswagen Beetles to Million Dollar Bug Bounties](https://blog.cadre.net/winning-bug-wars-from-volkswagen-beetles-to-million-dollar-bug-bounties), 27 agosto 2020, ed Esben Friis-Jensen, [The History of Bug Bounty Programs](https://www.cobalt.io/blog/the-history-of-bug-bounty-programs), Cobalt, 11 aprile 2014
- Shay Banon, [Doubling down on open, Part II](https://www.elastic.co/blog/licensing-change), Elastic, 14 gennaio 2021
- HashiCorp, [HashiCorp adopts Business Source License](https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license), 10 agosto 2023
- Redis, [Redis Adopts Dual Source-Available Licensing](https://redis.io/blog/redis-adopts-dual-source-available-licensing/), 20 marzo 2024
- Sean Ellis, [Find a Growth Hacker for Your Startup](https://www.startup-marketing.com/where-are-all-the-growth-hackers/), 26 luglio 2010
