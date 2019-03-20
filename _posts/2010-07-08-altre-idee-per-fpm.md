---
date: 2010-07-08 21:27:12+00:00
layout: post
slug: altre-idee-per-fpm
title: Altre idee per FPM
categories:
- Diario
- Linux
- Package Management
- Riflessioni
tags:
- Freax
- importato dal vecchio blog
---

Ciao a tutti, oggi vorrei condividere con voi alcune idee che mi sono venute in mente riguardo a fpm.

<!--more-->
[read more](){: .invisible #read-more }
{: .m-0 .invisible .zero-size }

Voi sapete (e se non lo sapete andatelo a leggere nella pagina di Freax Package Manager in questo blog) che io sto scrivendo un package manager e sto compilando una distribuzione linux. Ora la mia distro è effettivamente difficilotta da compilare e vorrei quindi alleviare il problema grazie al mio fpm. Ho pensato: quale miglior modo di facilitare la compilazione del software della distro se non un package manager che è fatto apposta per compilare e installare software? Allora ho pensato e se invece volessi farla io la compilazione? Certo mi piacerebbe avere la vita facile ma vorrei scegliere alcune cose sulla configurazione del software e allora come fare?
Allora ho pensato a quattro modalità: La tutorial, cioè una shell con un help in alto che ricorda i comandi da dare per la compilazione, configurazione e installazione del software con magari alcuni tip da chi ci è già passato e alcuni esempi e consigli sulla configurazione; La semiautomatica, in cui l'utente sceglie solo alcuni parametri delle configurazioni del software e il resto lo fa fpm; e la automatica in cui l'unica cosa che l'utente sceglie sono i pacchetti e il resto è demandato al software. Questo sia da interfaccia grafica che da riga di comando (e potrebbe tornarmi utile come installer della distro). Punto anche a far divenire fpm un must per i kernel a codice aperto come darwin, bsd, linux, hurd, minix e tutte le altre, in modo che tutte possano avere un punto di riferimento grazie al quale il software può essere installato con poca fatica ovunque. Forse un giorno cercherò di supportare windows chissà, e magari la battaglia dei sistemi operativi che ormai si combatte più a suon di software che a suon di caratteristiche finirà con l'adozione di un unico formato che gira da tutte le parti. Ma ora basta sto divagando troppo, quindi direi che è il momento di staccare e fantasticare nei sogni, se ne farò. Buona notte a tutti e, soprattutto in questo periodo di calura, che il pinguino sia con voi dal vangelo secondo Torvalds.
