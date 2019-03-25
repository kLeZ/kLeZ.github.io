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

Dal punto di vista puramente tecnico, ha incontrato e incontra ancora delle crisi di prestazioni che lo hanno portato a un cambio netto di implementazione e di approccio, come [notificato nelle _issues_](https://github.com/eduardoboucas/staticman/issues/243) dagli utenti stessi. Vedo un tecnico con un approccio _minimal working piece_[^1] al servizio, un approccio che devo dire a me non piace.

Dal punto di vista organizzativo invece, poca è la documentazione del progetto, e minore ancora è la voglia di strutturare il lavoro in maniera adeguata, per far funzionare senza (troppi) disservizi questo software. Neanche dopo aver ricevuto uno sponsor, neanche dopo che qualche decina di persone ha iniziato a lavorare sul progetto, Eduardo ha dimostrato di voler fare di meglio: attualmente non c'è la minima ombra di organizzazione del team, degli sviluppi, non c'è una direzione, né delle _milestone_, né a dire la verità sembra esserci la volontà piena di far vedere la luce a questo piccolo progetto.

Tornando alla documentazione estremamente carente, sul sito ufficiale di Staticman si trovano informazioni per *configurare* (se mai ci sia la possibilità di riuscirci) quello che viene specificato come l'*endpoint* **v2** mentre, [come sembra dalle issues](https://github.com/eduardoboucas/staticman/issues/278), gli endpoint v1 e v2 dovrebbero essere deprecati in favore dell'endpoint v3, che però non vuol saperne di funzionare adeguatamente e su cui chiaramente non c'è documentazione ufficiale per configurazione e manutenzione.

Inoltre, come se non bastasse, una volta scaricato il sorgente per configurare la mia istanza su Heroku (grazie al [post](https://vincenttam.gitlab.io/post/2018-09-16-staticman-powered-gitlab-pages/2/) non preciso ma almeno esistente sull'internet di Vincent Tam) sono riuscito anche a trovare un errore di programmazione che non avrebbe dovuto esserci, e che fortunatamente mi ha portato via solo mezz'ora, considerato tutto.

Questo è il prima:
```javascript
  const github = new GitHub({
    username: req.params.username,
    repository: req.params.repository,
    branch: req.params.branch,
    token: config.get('githubToken')
  })
```

Questo è il dopo:
```javascript
  const github = new GitHub({
    branch: req.params.branch,
    repository: req.params.repository,
    username: req.params.username,
    version: req.params.version,
    token: config.get('githubToken')
  })
```


[^1]: Concetto coniato da me in questa occasione, significa progettare solo il minimo della funzionalità, senza pensare a tematiche di buona progettazione come scalabilità e prestazioni.
