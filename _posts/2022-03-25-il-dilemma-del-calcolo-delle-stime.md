---
title: "Il dilemma del calcolo delle stime"
tags: 
date: 2022-03-25 09:39:26+00:00
---

Di norma direi che il calcolo delle stime è qualcosa che facciamo tutti i giorni e che quindi almeno sulla carta ogni programmatore dovrebbe saper farlo.

Di norma direi anche che ci dovrebbe essere una procedura, una *best practice* una formula che possa calcolare una stima.

Siamo programmatori, quindi siamo ingegneri (più o meno)!

{% include more.html %}

Invece questo argomento rimane complesso e basato su esperienza e capacità personali di chi sta tentando di tirare fuori un numero.

Oltretutto, quella che dovrebbe essere solo un'informazione di massima utile per avere un'idea *a spanne* dei tempi di realizzazione diventa spesso la *deadline*, ma questa è un'altra storia, oppure **un altro rant**, se volete.

## Refs

Navigando su [*Hacker News*](https://news.ycombinator.com/) ho trovato questa perla, che qualcuno ha deciso di condividere rianimandola tramite archive.org.

Se volete il link trovato su Hacker News e la perla in questione, [qui](https://news.ycombinator.com/item?id=28667174) e [qua](https://web.archive.org/web/20170603123809/http://www.tuicool.com:80/articles/7niyym) trovate tutto.

Di seguito rielaboro a modo mio, come sempre.

## L'idea geniale

L'idea è una ulteriore *best practice*, ma in forma di formula e non di additivo statistico, come mi insegnò un mio capo un tempo.

La regola aurea è:

> citation "#AltDevBlogADay"
> Moltiplica sempre le tue stime per π

Qualcuno - un progettista, il tuo *team leader*, un amico, tua madre - ti chiede di fare qualcosa. Tu rifletti, prendi appunti, consideri il requisito e fai un piano e, auspicabilmente, una stima.

Ma le cose cambiano. Esce fuori che c'erano informazioni che il tuo *qualcuno* ha trascurato di menzionare, e mentre lavoravi hai avuto alcune idee per migliorarlo ulteriormente. Di fatto la quantità di lavoro è aumentata, hai più cose da fare.

Ovviamente, non va tutto liscio. Quando mai. Il primo tentativo è stato un fallimento, però hai imparato qualcosa. Poi col secondo tentativo hai accelerato e hai lasciato indietro le *best practice* architetturali che poi ti hanno portato alla necessità di fare *refactoring*. Hai impiegato due giorni in più per cercare una soluzione alternativa. Alla fine, il percorso per portare a casa il risultato è come una strada di montagna, tutta storta e piena di buche (dalle mie parti diremmo è come la strada di [Tolfa](https://it.wikipedia.org/wiki/Tolfa), stesso concetto :grin:).

Quindi, quanto è durato il lavoro rispetto al piano originale?

Eccoti qui col problema in mano o "_col sorcio in bocca_": qualunque cosa pensi quando inizi, dopo l'analisi, la progettazione, le discussioni, i prototipi, i fallimenti, i test, l'abbandono dei requisiti e tutte le altre fasi del processo creativo, l'avrai indubbiamente fatto *π volte* quanto avevi pianificato inizialmente.

Ora, qualcuno potrebbe mettere in dubbio il mio rigore matematico, e perfino contestare quella che ritengo essere la conclusione incontrovertibile. Le persone possono affermare che il moltiplicatore corretto non è in effetti π, ma che è piuttosto 2, o √2, o [e](https://it.wikipedia.org/wiki/E_(costante_matematica)), o il rapporto aureo [φ](https://it.wikipedia.org/wiki/Sezione_aurea). Però sicuramente nessuno va in giro dicendo che il moltiplicatore sia inferiore a 1.

> Indipendentemente dalle tue inclinazioni numerologiche, il punto è che devi darti il ​​permesso di ammettere che, quando inizi un progetto, non hai il quadro completo, non sai come andranno le cose e c'è del lavoro da fare di cui non hai nessuna idea o indizi.
> Nessuna quantità di pianificazione e analisi delle attività può cambiarlo, quindi non provarci neanche. Invece, concediti un plausibile cuscinetto e impegnati a portare avanti il lavoro.

Ah. Sai quella TODO List che hai scritto lo scorso weekend? Ti sei chiesto perché di quelle cose ne hai portate a casa solo circa un terzo?

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8" markdown="1">
![Coincidenze-Non-Credo]({% link /media/2022-03-25/il-dilemma-del-calcolo-delle-stime/coincidenza-non-credo.jpg %}){: .img-fluid }
</div>
</div>
