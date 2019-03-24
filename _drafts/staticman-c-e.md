---
title: Staticman c'è!
tags: staticman heroku
#date: 
---

Ecco lo sperato secondo articolo su [Staticman](https://staticman.net), finalmente ho qualcosa da scrivere!

Le difficoltà ci sono state, ma devo dire che pensavo peggio, alla fine mi ci è voluta solo mezza giornata di lavoro per tirare su la baracca.  
Anche se con un mucchio di se e ma e però, comunque il componente regge e io **non ho speso un euro**. Vittoria per me, _ma amara_.

{% include more.html %}

## Le basi: errori di programmazione per un progetto disorganizzato e fuori rotta

Il progetto Staticman, come ho detto [altre volte]({% post_url 2019-03-21-staticman %}) è interessante, lo è _molto_, ma rimane dietro la barriera dell'interessante non riuscendo a fuggire dal blocco dei progetti destinati a morire. E se non cambia rotta **succederà**.

Inizio col dire che come ogni progetto molto piccolo le informazioni sono poche e difficili da reperire (anche dal sito "ufficiale"), questo perché lo vediamo nella sua fase embrionale. Il problema esiste perché il suo autore, il portoghese [Eduardo Bouças](https://eduardoboucas.com/), si è trovato a dover gestire una situazione che probabilmente non pensava di dover gestire, cioè una massa critica di utenti che ha permesso a questo progetto di uscire dalla bolla di invisibilità che copre ogni software prima che degli utenti si accorgano della sua esistenza e della sua (_spesso relativa_) utilità, esattamente come ancora succede al mio [Wash Ideas](https://klez.me/wash-ideas).

Dal punto di vista puramente tecnico, ha incontrato e incontra ancora delle crisi di performance che lo hanno portato a un cambio netto di implementazione e di approccio, come [notificato nelle _issues_](https://github.com/eduardoboucas/staticman/issues/243) dagli utenti stessi.

Dal punto di vista organizzativo invece, vedo un tecnico con un approccio _minimal working piece_ al servizio, un approccio che devo dire a me non piace.
