---
title: "Git submodules: una feature spettacolare e sottovalutata"
tags:
    - best practice
    - git
    - modularity
date: 2019-04-11 08:07:47+02:00
---

Oggi parlo di Git, e in particolare di una feature di questo indispensabile strumento che spesso viene sottovalutata o non considerata a dovere nell'organizzazione del codice.

{% include more.html %}

## Cosa è

Un _submodule_, come dice la [documentazione ufficiale] è un _repository_ git inserito nel _working tree_ di un altro _repository_ git, come dipendenza.

A tutti sarà capitato di avere una libreria usata in più progetti, o addirittura comune all'organizzazione. Ecco, i _submodule_ servono proprio a questo. Permettono di specificare che un determinato percorso è in realtà un _repository_ separato, che deve essere scaricato e mantenuto aggiornato di volta in volta.

Chiaramente esistono ottimi sistemi che evitano l'esigenza di questa funzione, ma non è sempre così.

Nel caso in cui io stia sviluppando in **Java** avrei **Maven** o **Gradle**, ottimi tool di gestione delle dipendenze.  
Nel caso in cui io stia sviluppando in **C#** avrei **NuGet**, anch'esso ottimo.  
Così via anche con **Python**, **Ruby**, **Perl**.

Ma non sempre ho a disposizione questi strumenti, oppure non posso o non voglio pubblicare.

> info ""
> Esempio pratico: questo blog.  
> In questo blog utilizzo molti _plugin_, potrai vederli nel _[Gemfile]_ o nel [file di configurazione].

Per due di questi però (uno effettivamente non è un _plugin_ ma sorvoliamo), ho dovuto usare dei _submodule_. Andiamo con ordine.

### Premonition

Premonition è un ottimo _plugin_ per Jekyll che mi aiuta a scrivere meno codice quando sto scrivendo un articolo, momento in cui di fatto io voglio scrivere il minor quantitativo di parole strettamente formali e conformi possibile (soprattutto perché la sintassi formale ha bisogno di delimitatori per aiutare il _parser_, e i caratteri speciali usati di solito non sono così semplici da scrivere su uno smartphone).

> citation ""
> I caratteri speciali usati di solito non sono così semplici da scrivere su uno smartphone

Proprio il blocco di citazione che vedi qua sopra è opera di _premonition_, o quantomeno della mia variante, ma ci arrivo.  
_Premonition_ mi aiuta a usare blocchi di citazione (_blockquote_, in HTML) e a dargli uno stile grafico che sia semantico rispetto al contenuto. Di base offre quattro tipi di citazioni:

> note ""
> Questo è un blocco di citazione con stile "_note_"

---

> info ""
> Questo è un blocco di citazione con stile "_info_"

---

> warning ""
> Questo è un blocco di citazione con stile "_warning_"

---

> error ""
> Questo è un blocco di citazione con stile "_error_"

E il blocco sopra? Quello con le "virgolette"? Ecco, quello e un'altra piccolezza sono la mia modifica.

Per contribuire all'_open source_ come di solito mi preme fare, ho deciso di _forkare_ il progetto e fare le mie modifiche, mandando poi una _Pull request_ all'owner del progetto (che onestamente sembra non lo stia più sviluppando). Quindi, se prima potevo scaricare la gemma con l'ottimo sistema integrato in _Ruby_, adesso non posso più farlo, perché devo usare la mia versione "di sviluppo", fino a che la mia modifica non verrà pubblicata.

Visto che Jekyll è in grado di accettare _plugin_ nell'apposita cartella decido di ficcare il sorgente di premonition li dentro, un paio di test in locale e funziona tutto.

### SgEExt

Integrando un altro plugin, JEmoji, mi imbatto in un qualcosa che non mi piace, JEmoji pesca le _png_ delle emoji da githubassets.com, e io non voglio che lo faccia perché non voglio connessioni esterne al mio dominio (fatta eccezione per il badge "live" di TravisCI).

Cercando in rete una soluzione trovo uno script _python_ che fa al caso mio: scarica le emoji da githubassets.com e le riversa nella mia cartella di asset.

Ma io non voglio che un domani questo script, presente su github, venga aggiornato senza la possibilità di accedere facilmente agli aggiornamenti. Quindi anche per questo script, che di fatto non ho modificato, clono il _repository_, faccio due test in locale e tutto funziona.

### La questione

Soddisfatto, anche dell'[articolo precedente a questo]({% post_url 2019-04-09-aggiornamenti-sulla-direttiva-per-il-copyright %}), decido che è il caso di pubblicare tutto in "produzione". Git **add**, **commit** e **push** e sono "live" (sempre live).

Arriva una mail però in cui Travis mi avvisa che la _build_ è fallita, i log affermano che c'è un problema nel trovare un file **SASS**, "{...}/premonition.scss".

Non intuendo quello che succede controllo e capisco che Git (giustamente) non pubblica i _repository_ che si trovano all'interno di altri _repository_. Quindi penso a una soluzione e subito mi viene in mente la parola "_submodule_".

Raccolgo informazioni dallo smartphone (l'unico strumento a mia disposizione in quel momento) e decido di provare quello che la documentazione mi racconta, molto alla cieca.

Creo il file _.gitmodules_, ci metto dentro le due sezioni relative ai due _repository_ da includere stando attento alla posizione nel _working tree_ e alla _url_ inserita e provo un _commit_ correttivo.

Potete verificare voi stessi quale unica modifica ho fatto tramite il comando `git diff 958006..bae173`: risulterà che ho aggiunto il file _.gitmodules_ e ho inserito il supporto ai _submodule_ in Travis (dovrebbe essere già attivo di default, ma non volevo eccedere di sicurezza).

Va tutto molto bene per fortuna e ho il mio post online (cruciale la data, visto che il 15 di questo mese si voterà definitivamente la direttiva).

Totale della correzione: circa 15 minuti (operativi) dalla notifica del fallimento della _build_ all'implementazione della soluzione. In realtà il tempo reale è stato molto di più, ho pubblicato e sono stato notificato del fallimento sul treno, e ho potuto risolvere solo in pausa pranzo.

### Conclusione

Questo vi racconta quanto questa funzione di Git sia semplice da usare e da capire, e vi dà un'idea di quanto possa essere utile e potente come strumento quando la struttura del progetto sia particolare (e neanche tanto poi).

> citation "kLeZ"
> Usate quanto più possibile le funzioni dei vostri strumenti senza avere paura, a qualsiasi livello, è importante non tralasciare mai questo aspetto vitale che ci evita tante complicazioni inutili (come avere un progetto comune che viene copia-incollato ovunque e si disallinea a T con 0).

[documentazione ufficiale]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[Gemfile]: {{site.repo | append: "/blob/dev/Gemfile"}}
[file di configurazione]: {{site.repo | append: "/blob/dev/_config.yml"}}
