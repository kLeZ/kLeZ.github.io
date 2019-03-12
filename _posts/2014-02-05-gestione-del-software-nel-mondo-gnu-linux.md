---
date: 2014-02-05 18:09:06+00:00
layout: post
slug: gestione-del-software-nel-mondo-gnu-linux
title: Gestione del software nel mondo GNU/Linux - parte 1
categories:
- Linux
- Package Management
---

This article is written in my native language, Italian, but you will find a translation ASAP (As Soon As Possible). Sorry for this. Questo argomento è, a dire la verità, credo tra i più discussi e spinosi in assoluto, io qui tenterò di dare forma alla nebulosa che compone questa tematica e getterò una base (spero) per qualcosa di più ampio.
<!--more-->

# La confusione parte dalle basi

La base di tutto è il formato da usare. Se ne sono dette di tutti i colori su quale sia il formato migliore in assoluto, mentre la Linux Foundation standardizzava il formato RPM, prima Red Hat Package Manager e ora RPM Package Manager (ricorsivo).
Si potrebbe anche qui discutere delle ere sui due formati _faggot_ per eccellenza: RPM e DEB, ma non lo farò. Mi limiterò a dire che ognuno dei due formati introduce novità sull'argomento ma che porta anche gravi danni allo stesso. Per RPM il danno è più concettuale che sistemistico: RPM è l'estensione del file (.rpm), ma è anche il nome del formato (RPM), ed è anche il nome del Package Manager (sempre, rpm), senza contare gli innumerevoli usi impropri dell'acronimo. Insomma quando si parla di RPM non si sa mai se si sta parlando del file, del formato, del programma o di qualcos'altro. Il formato DEB dal canto suo introduce un problema ben più grave dal mio punto di vista: la frammentazione. Da quando il formato è nato, per opera della "bastian contrario" comunità di Debian, questo formato ha tentato sempre di _rubare_ adozioni a RPM mettendo in atto una vera e propria guerra, per nulla salutare ai formati o a Linux e al mondo libero in generale, tutto solo per "essere diversi". Ogni volta c'era qualche Debian-enthusiast che voleva necessariamente coinvolgere tutto il mondo linux nella loro totalitaria visione debian-centrica dell'universo, a partire dal loro package manager, dpkg. C'è da dire che non ci vuole uno scienziato a capire che il formato è perfetto sotto certi aspetti (lato utente medio) ma totalmente privo di funzionalità basilari se lo si guarda dal punto di vista di chi sa cosa diamine sia veramente la gestione del software, come i bonzi utilizzatori di slackware (i quali sanno **veramente** cosa sia gestire un pacchetto).

Sull'argomento della definizione di un formato, molti hanno provato a dare una definizione e _tutti_ sono caduti nel farlo nella morsa della necessità. Potremmo provarci anche noi, mantenendoci leggeri senza irrigidirci troppo su quello che già c'è o sulle regole da seguire, proviamo solo a pensare a **cosa** è necessario ad un formato per gestire tutti i casi esistenti (consci del fatto che in un modo o nell'altro tutti i formati di successo **possono** gestire ogni pacchetto esistente).
[Wikipedia](https://en.wikipedia.org/wiki/Linux_package_formats) prova a dare una definizione di formato:


<blockquote>_A package format is a type of archive containing files and additional metadata found on packages._</blockquote>


Partendo da questa (molto) **semplicistica** definizione proviamo a capire cosa dovrebbe offrire un formato nel 2014:



	
  1. I file da installare; O al limite i sorgenti. È necessario che il **vero** contenuto stia nel pacchetto, questa è una ovvietà, ma per eccesso di zelo, va detta.

	
  2. Un manifest; Quello contenente i metadati, ce l'hanno tutti ed è indispensabile, quindi è dentro.


Ok, sono finite le parti ovvie, quelle che implementano tutti, completamente o in parte. C'è dell'altro, ma prima è doveroso trattare l'argomento del manifest, visto che parlare di manifest è come parlare di ricette: troppe versioni, praticamente tutte discordanti, ognuno ha la sua. Ma qual'è il manifest perfetto (o quanto meno il più completo possibile)?


### «Un Manifest per domarli. Un Manifest per trovarli. Un Manifest per ghermirli e nel buio incatenarli…»


Dato che la mia trattazione non è un mero confronto di formato tra manifest, mi limiterò a citare le informazioni dei principali formati e elencherò quello che un manifest dovrebbe avere, sulla base di quello che è possibile leggere dagli articoli ufficiali.



	
  * Il [PKGBUILD](https://wiki.archlinux.org/index.php/Pkgbuild) di **Arch** è sicuramente tra i più semplici. Include tutte le informazioni di base che un manifest dovrebbe avere, ma il manifest è il minore dei problemi di un buon formato.

	
  * L'[EBuild](http://devmanual.gentoo.org/ebuild-writing/file-format/index.html) di **Gentoo** invece è molto, molto complesso e non incoraggia i packager in erba a usarlo, a discapito della comunità e della quantità di pacchetti effettivamente disponibili. Anche se poi chi usa Gentoo è comunque un utente **molto** avanzato e quindi difficilmente necessita di un tool di assistenza per compilare i sorgenti di un software.

	
  * [RPM](https://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-rpm-overview.html#id662040) di **Red Hat & Fedora, openSuSE, Mandriva e soci** è largamente usato nelle maggiori distribuzioni (soprattutto quelle commerciali), ha un manifest relativamente semplice e strutturato, è un progetto molto maturo e ha molte funzionalità in più.

	
  * [DEB](http://www.debian.org/doc/debian-policy/ch-controlfields.html) di **Debian, Ubuntu e derivate** è un formato nato semplice e diventato complesso con gli anni a causa dell'approccio "_write first, think later_" tipico dei giovani smanettoni (e studenti universitari), che sono i principali e tipici utilizzatori di questo formato, approdato al cospetto del grande pubblico solo "a causa" di ubuntu. Ciò è dimostrato dalla estremamente carente documentazione, tipica del progetto e opposta alla linea di condotta di progetti come Arch, smanettoni ma saggi che mettono a disposizione degli utenti una delle documentazioni online più complete e ricche, senza farlo per mestiere.


Il manifest tipico quindi dovrebbe essere un formato **semplice da scrivere**, come ci insegnano i saggi di Arch, molto ben strutturato per essere **scriptabile**, come ci insegnano i supertecnici di Gentoo (che, se avete letto la documentazione, generano il manifest a partire dall'ebuild), **solido maturo e flessibile**, come hanno dimostrato negli anni i milioni di contributori delle distro più note basate/derivate/ispirate su/a Red Hat, e che sia **semplice** da includere in un pacchetto, senza troppe sovrastrutture che complicano inutilmente il lavoro, come ci ha insegnato la comunità di Debian.

Qui finiamo la prima parte, la seconda (di una lunga serie) arriverà a breve, delineando quello che potrebbe essere il manifest _assoluto_, solo in senso puramente scientifico, cioè rendendo ciò che è elencato qui sopra una specie di formato _abbozzato male_.
