---
title: "Spaghetti Code: It's **that** bad"
tags:
- spaghetti code
- bad practices
date: 2019-03-28 13:25:43+01:00
---

Ho sempre lottato contro le cattive pratiche, chi mi conosce lo sa.  
Ho sempre parteggiato per il codice di qualità, con la forte convinzione che questo possa essere un vantaggio strategico per il progetto e l'azienda che ne è proprietaria.

Proprio per questi motivi ancora oggi, da 12 anni, non riesco a comprendere perché certi *project owners* abbiano sempre l'idea di risparmiare il budget dello sviluppo tagliando sulla qualità. Che poi risparmiare sulla qualità non significa niente, non è che a comando siccome ti pagano di meno puoi fare un lavoro schifoso. E infatti, per forzare il programmatore a produrre codice schifoso spingono sul fattore tempo (che è sempre poco).

{% include more.html %}

# TRY

## Definizioni ed esempi

Schematico come sono, difficilmente comincio a trattare un argomento senza essere sicuro che per tutti gli interlocutori il cielo sia veramente blu.

Il cielo è blu, quindi, e lo _spaghetti code_ è una cosa che **capita a tutti**, anche ai migliori.

Riconoscerlo è facile: avete mai sbagliato una stima per causa dell'incertezza che provate per un progetto? Avete mai provato quella sensazione per cui avete quasi paura a modificare una parte del software? Pensate mai che "*Sarebbe meglio riscriverlo*"?

Se presentate uno di questi segni, ecco, siete in presenza di *spaghetti code*, che lo vogliate o meno.

## Riscriviamolo?!

Eh. Sarebbe bello. In un mondo ideale, in cui il tempo è estremamente espanso e i soldi non esistono (o non servono più a niente), forse, **forse** potrebbe essere un'idea, che non sarebbe comunque la migliore delle idee perché finiresti per produrre una nuova applicazione piena di *spaghetti code*, esattamente come la precedente. Non se ne esce così.

Beh, diciamo che [Joel](https://www.joelonsoftware.com) ci da una mano, e uno spunto su cui riflettere, **direttamente dal 2000**, mica l'altro ieri. Non so quante volte l'ho letto [questo](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) articolo e non so quante volte ho visto fare e rifare questo stesso errore che ormai **ben 19 anni fa** qualcuno ci ha messo in guardia dal fare. E non un qualcuno qualunque, Joel Spolsky cofondatore e CEO di [**Stack Overflow**](https://stackoverflow.com).

Beh, c'è qualche caso limite, pure qui da uno che può permettersi di raccontare [la sua personale storia](https://signalvnoise.com/posts/3856-the-big-rewrite-revisited) di *Rewrite from Scratch* in cui però la battaglia l'ha vinta. Alla fine parliamo di **DHH** a.k.a. *David Hansson*, CTO e cofondatore di Basecamp, un altro autorevole, per avere il contraddittorio, alla fine.

Il punto però è un altro: tu puoi anche riscrivere il software, ma il tuo *cono di incertezza* ti porterà a sbagliare la stima di almeno un fattore di 4.  
La buona soluzione in caso si voglia pensare a un *Big Rewrite* in realtà è non riscrivere il software ma correggerlo iterativamente. Questo ci porta al passo successivo.

#CATCH

## Regole di base

Prima fra tutte le regole: segui attentamente e senza eccezioni questo elenco, è veramente l'unico modo per uscire, molto lentamente ma efficacemente, dallo *spaghetti code*.

### La regola del *boy scout*

> Lascia il bosco in cui sei stato **meglio** di come l'hai trovato

Ogni volta che trovi un pezzo di codice brutto, mentre modifichi una funzione o una struttura, effettua un *refactoring*, correggi quel codice, **può fare solo bene a te, al software e al team**.

E non credere a chi ti dice che il tempo di fare *refactoring* non c'è (anche se questo è il tuo capo), il *refactoring* è parte integrante del lavoro di sviluppo, esattamente come i test di base e la compilazione: va fatto sempre e comunque, come quando vai al bagno dopo pranzo.

> Il *refactoring* è parte integrante del lavoro di sviluppo, esattamente come i test di base e la compilazione

### Scrivi degli Unit Test

> Metti in quarantena lo *spaghetti code*

Per ogni funzione o struttura che vai a modificare, è facile creare degli *unit test* che possono darti la sicurezza che ti serve su cosa fa effettivamente il modulo che hai di fronte.

I vantaggi sono molti:

* consolidi la logica attuale, guadagnando sicurezza di ciò che il modulo esegue, come e perché
* comprendi meglio il codice che hai di fronte: scrivendo degli *unit test* potresti scoprire logiche nascoste o casi limite
* se fai una modifica e questa lede la logica attuale i test falliranno, in questo modo sai subito se introduci delle regressioni nel funzionamento oppure no

Dal punto di vista del management, lasciarti fare questi test a loro farà **guadagnare tempo e soldi**, mi spiego subito.

Guadagneranno tempo perché essendo tu più confidente nella stima delle modifiche (perché avrai degli *unit test* che ti aiuteranno a non introdurre altri difetti) sarai più spesso *on time*, come piace dirlo a loro, cioè all'interno della stima.

Guadagneranno soldi perché l'applicazione continuerà a produrre valore mentre diventerà via via più semplice da modificare, e diventerà anche più veloce da modificare il che permetterà loro di stanziare meno budget per le modifiche di quanto avrebbero fatto prima, potendolo reinvestire in altre modifiche e aumentando ancora il valore dell'applicazione.

> Insomma, il *refactoring* è uno strumento saggio per aumentare la produttività del team, **un buon manager deve** non solo accettarlo, ma **consigliarlo**.

### Concentrati sulla qualità e sulla semplicità

Mantieni semplici le tue funzioni, ovunque la logica comincia a diventare distorta o confusa spendi tempo per spezzare i metodi e renderli più leggibili.

Attieniti sotto alle 20 righe di codice per ogni funzione, ma sarebbe meglio che le istruzioni fossero ancora meno, e se puoi evita le diramazioni.

Ogni volta che devi scrivere una funzione che potrebbe accettare un parametro booleano, non farlo!  
Immagina di dover scrivere una funzione che accenda o spenga una lampadina, potresti essere tentato di scrivere una cosa simile:

~~~javascript
function turn(isOn) {
	if (isOn) {
		// turn on the lightbulb
	} else {
		// turn off the lightbulb
	}
}
~~~

**Sbagliato!**

Questo contribuisce a diminuire la leggibilità del codice, e la scarsa leggibilità porta all'incertezza sulla propria capacità di effettuare modifiche.

Dovresti usare un approccio più semplice a una funzione come questa:

~~~javascript
function turnOn() {
	// turn on the lightbulb
}

function turnOff() {
	// turn off the lightbulb
}
~~~

## Segui lo Zio Bob

C'è sempre la possibilità di seguire le parole dei grandi luminari del proprio settore, uno tra questi nel *nostro* settore è [Robert "*Uncle Bob*" Martin](https://blog.cleancoder.com/).

*Uncle Bob* fa un'analogia perfetta per spiegare l'importanza della qualità.

> Pensa alla cena: puoi cucinare più velocemente se eviti di lavare i piatti. Alla fine però, rimarrai a corto di piatti. Lasciarli da una parte ora significa solo che dovrai lavarli dopo, oppure puoi "appaltare" questo lavoro andando a cena fuori, che però costa molto di più che cucinare a casa.

## Alcuni consigli per fare *refactoring* e per scrivere buon codice

- Le funzioni dovrebbero avere un nome che descrive esattamente cosa fanno
	+ I nomi lunghi vanno benissimo
	+ La scelta del nome non dovrebbe portarti via lo stesso tempo di quando hai dato il nome a tuo figlio
		* Se capita questo, probabilmente hai davanti una funzione che può essere spezzata in due o più parti
- Le funzioni dovrebbero fare una cosa e farla bene
	+ Quando una funzione fa una cosa fatta bene senza effetti collaterali, sarai più portato a riutilizzarla
	+ Capisci che una funzione fa una sola cosa fatta bene quando non puoi più spezzarla in funzioni più semplici
- Il codice all'interno di una funzione dovrebbe essere tutto allo stesso livello di astrazione
	+ Se stai scrivendo logica di business, non dovresti fare manipolazione di stringhe o accesso ai dati nella stessa funzione
	+ Facendo questo potrai leggere il codice dal livello di astrazione più alto in giù, andando in profondità quando necessario per trovare un errore o per una modifica
	+ Le funzioni scritte bene dovrebbero essere lette come degli elenchi puntati
- Le funzioni non dovrebbero superare le 20 righe di codice
	+ Anche 20 è comunque un numero un po' alto, tenta di tenere tutto entro 10 righe o meno
	+ In questo modo sarà più facile per il tuo cervello leggere e trovare i problemi
	+ Questo approccio forza il codice a essere modulare
	+ Se hai un blocco di codice dentro a un'istruzione di controllo (*if/else/while, ecc.*) quel codice dovrebbe essere spostato dentro a una funzione -- `if function() else someOtherFunction()`
- Le funzioni dovrebbero massimo 3 parametri, idealmente 0 o 1
	+ È difficile ricordare l'ordine degli argomenti se ne hai più di 3, questo rende il codice  più passibile di difetti e lo rende anche più complicato da leggere
	+ Se hai più di 3 parametri probabilmente puoi raggrupparli in una struttura. Per esempio se hai un metodo `login(String username, String password)`, questo può facilmente diventare `login(Credentials credentials)` dove *Credentials* è un oggetto con uno *username* e una *password*, che ne promuove il riuso
	+ Evita i parametri booleani -- per esempio invece di una funzione `boolean turn(Boolean isOn)` usa due funzioni separate ch chiarifichino le tue intenzioni: `turnOn()` e `turnOff()`
- Le funzioni dovrebbero lanciare eccezioni anziché ritornare messaggi e codici di errore

# FINALLY

In conclusione, si può sempre tornare indietro da una situazione a *spaghetti code*, si può sempre decidere di migliorare le cose piuttosto che adattarsi passivamente al caos.

Il mio consiglio è di non demordere in presenza di software di questo tipo, e portare avanti l'idea di un software migliore ignorando chi ci dice che non è possibile o i manager che ci "spiegano" che il tempo per questi miglioramenti *cosmetici* non c'è.

> Fate *refactoring*, non fate spaghetti.
> <footer><cite>kLeZ</cite></footer>
