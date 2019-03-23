---
date: 2010-03-29 11:44:42+01:00
layout: post
slug: lfs-ovvero-come-crearsi-la-propria-distro-gnulinux-da-zero
title: LFS ovvero come crearsi la propria distro GNU/Linux da zero
categories:
- Diario
tags:
- importato dal vecchio blog
- informatica
- lfs
- Linux
---

Salve a tutti,
Oggi m'è venuto in mente un progetto che non molto tempo fa stavo abbandonando, il mio personale LFS. L'avevo iniziato col mio amico di vecchia data ma poi per impegni universitari non ha più avuto tempo di proseguire la cosa, quindi per ora vado da solo ma sono sicuro che appena avrà un momento libero mi aiuterà.

{% include more.html %}

LFS è l'acronimo per Linux From Scratch tradotto Linux da Zero. Cioè mi scarico i sorgenti dei tool GNU mi scarico il sorgente del kernel e mi compilo tutto a mano.
L'utilità se sei un utilizzatore è praticamente inesistente ma se vuoi creare una distro è un ottimo punto di partenza per creare qualcosa di mai visto prima, altrimenti la mia idea è che tanto poi se ti basi su una distro finisci per rifare il vestito a quella distro e a cambiargli le mutande poi per il resto è sempre lei.
Faccio un esempio di quello che dico: immaginate due amici con la passione per l'informatica e in particolare per linux che decidono di darsi battaglia per la creazione di una distro. Uno dei due si basa su openSuSE e inizia già col sistema precompilato, gli RPM il server X già configurato ecc ecc. L'altro invece decide di partire da zero e si scarica il manuale di linux from scratch e tutti i sorgenti. Dopo due mesi di lungo lavoro i due decidono di installare le due distro su un portatile in dual boot e di portarle al loro professore di sistemi operativi dell'università. Il professore notando e valutando i due sistemi probabilmente dirà: "Bravi ragazzi sono entrambe buone distro, solo un paio di cose avrei da puntualizzarvi: (ragazzo suse) tu hai creato una bella distro complimenti stabile veloce sicura... ma mi sembra di aver già visto le sue caratteristiche in openSuSE non sarà basata proprio su quella? (ragazzo LFS) Ottimo bravo è velocissima ma il sistema in se è un po' vecchiotto, effettivamente questo la rende molto stabile ma non ti interessano le ultime versioni dei software? Comunque complimenti le caratteristiche della tua distro non le ho riconosciute in nessun'altra quindi immagino che tu debba ricevere un ulteriore plauso per aver compilato tutto a mano. Bravi ragazzi complimenti!".
Ecco questo piccolo dialogo (monologo per la verità) era per spiegarvi il perché mi butto in un'avventura come questa ricca di difficoltà ma anche di insegnamenti utili e esperienza.

Beh dato che non ho ancora cominciato a compilare Torvalds, Tanembaum e Stallman direi che è meglio finirla qui con questo Nerd Attack (si si leggetelo come un Art Attack) e cominciare veramente l'avventura!

Ciao ciao a tutti,
kLeZ.
