---
title: Adventures with Staticman
tags:
- staticman
- commenting system
- poor organization
- open source
date: 2019-03-21 21:22:45+01:00
---

Oggi mi dedico a parlare di [Staticman](https://staticman.net), un sistema di gestione dei commenti open source basato su _node.js_.

Staticman potenzialmente è un gran prodotto, davvero. Sembrerebbe funzionare davvero bene e, seguendo la onnipresente filosofia unix, _fa una cosa e la fa per bene_ (o quasi).  
Il problema è che non funziona, o meglio, funziona **se e solo se** puoi far girare la tua istanza per le tue necessità.

E qui viene il bello.

{% include more.html %}

## In principio fu la luce

Questo sito da cui leggi questo post (o il feed rss a cui ti sei iscritto) è interamente statico, questo lo sai (se non lo sai, [sallo]({% post_url 2019-03-13-an-infinite-journey %})).  
Per carità uso Jekyll non è che mi scrivo gli HTML a mano, uso metodi _moderni_, però la mancanza di dinamicità mi porta anche la mancanza di tutta una serie di strumenti che sono nativamente dinamici, come i commenti sotto ai post.

Un post di fatto si chiama così proprio perché il contenuto viene _postato_ (cioè inviato tramite chiamata post) al server; il che, già di per sé, presuppone di averlo un server. E io chiaramente non ce l'ho. Quindi i commenti non posso averceli sul mio sito. ... O si?

Staticman si propone proprio questo: trova un sistema intelligente per portare i commenti sui blog statici, con un occhio di riguardo verso i siti costruiti con Jekyll e GitHub Pages, coppia simpatica all'autore di questo progetto interessante.

## Il buono, il brutto, il cattivo

Praticamente, ogni volta che posti un commento questo va direttamente a staticman, che ne genera un file che poi è in grado di caricare su GitHub.

Questa operazione fa partire una nuova "_build_" del sito che trova il file col nuovo commento e lo scrive nella pagina statica.

In breve è così che va il giro.

Tutto molto buono, se solo non ci fosse anche il brutto: **l'istanza non funziona**. Si perché dal sito si legge che, _oltre a poter ospitare per conto proprio il servizio_, si può usare l'istanza pubblica messa a disposizione dall'autore, e anzi il suo utilizzo è l'unico documentato e raccomandato.

Vani i tentativi di far funzionare l'istanza pubblica da parte di decine di utenti, come si evince dall'elenco di _issues_ sul repository del progetto.

Addirittura l'autore stesso spiega che il malfunzionamento deriva dalla grande quantità di richieste e dalle scarse risorse offerte dal piano gratuito di [Heroku](https://heroku.com) dove il servizio è ospitato.

Da qui, una presa di coscienza dell'utilizzo tipico, della mole di utenti interessati e dell'errore architetturale che ha portato alla forzata riscrittura dell'intero progetto che ha la stessa funzionalità ma fa un _giro_ diverso, soprattutto verso GitHub.

Il cattivo in questa storia, è comunque lo sviluppatore (attualmente il team si è allargato e i _contributors_ dovrebbero essere mezza dozzina di sparuti utenti _tech savvy_) che non solo **da settembre 2018** non si è preoccupato di far funzionare di nuovo l'istanza vecchia oppure di mettere online una versione stabile seppur scarna della nuova, ma non si è soprattutto preoccupato di aggiornare il sito ufficiale che riporta istruzioni vecchie, non funzionanti e nessuna menzione di tutto questo discorso, che viene fuori scavando molto nelle issues di GitHub (cosa che io ovviamente ho fatto).

## La forza è potente in me

Intestardito dalla volontà di avere un'istanza funzionante, mi sono messo all'opera per cercare informazioni su come e dove ospitare la mia copia del servizio.

Soprattutto, la forza che mi spinge è la necessità di un sistema di commenti, e il progetto nella sua idea mi piace davvero tanto, **davvero**.  
Quindi l'obiettivo è stato cercare un modo per portare a compimento l'opera.

Un volenteroso quanto salvifico utente ha scritto [un post sul suo blog](https://vincenttam.gitlab.io/post/2018-09-16-staticman-powered-gitlab-pages/2/) in cui afferma di aver portato l'intero progetto su GitLab e spiega come fare in passi semplici, affermando che è possibile essere _up 'n' running_ in 15 minuti. Quindici minuti. Con gente che è rimasta 2 settimane in attesa di vedere il sistema dei commenti funzionare con l'istanza pubblica.

Dato il vincolo di non volere nessun sistema _a là disqus_ per mantenere i commenti, dato poi il ruolo mediatico dei commenti, sono convinto che questi come i post li debba gestire tutti io in modo statico, per poter anche effettuare dei backup eventualmente ed essere soprattutto agnostico dalle tecnologie usate, l'unica soluzione in questo momento mi sembra staticman. E lo implementerò, lo prometto.

<<<<<<< HEAD
Altri aggiornamenti probabilmente quando avrò tirato su tutto il sistema.
=======
Altri aggiornamenti probabilmente quando avrò tirato su tutto il sistema.
>>>>>>> draft
