---
title: "Il software che non puoi smontare"
tags:
- linux
- systemd
- lfs
- software-libero
date: 2026-02-03 14:37:42+02:00
---

Nel 2010 scrivevo su questo blog che volevo costruirmi una distro Linux da zero con LFS. Avevo vent'anni e pensavo che capire come funziona un sistema fosse un mio diritto. Bastava volerlo. Mi scarico i sorgenti, compilo tutto a mano, alla fine ho qualcosa di mio che capisco pezzo per pezzo. "Un'avventura ricca di difficoltà ma anche di insegnamenti utili e esperienza", scrivevo.

L'entusiasmo di chi non sa ancora quanto è profonda la tana del coniglio. Ma l'entusiasmo è fondamentale per avere la voglia di capire, di conoscere, di scoprire. È la base della cultura hacker, è la base delle persone curiose che compongono il substrato su cui il free software è cresciuto e fiorito bello come è sempre stato, è l'humus in cui sono cresciuto io.

Oltre all'entusiasmo però servono possibilità. LFS e Linux hanno spopolato tra hacker, attivisti e curiosi proprio perché sono sempre stati sistemi aperti, documentati, comprensibili se hai voglia di spenderti (l'entusiasmo, appunto).

Non poteva essere lo stesso nel mondo Microsoft, perché Windows non puoi analizzarlo, non puoi smontarlo, non puoi studiarlo per capire qualcosa. Puoi *hackerarlo*, certo, ma non capisci mai intimamente la sua struttura a meno di non studiare come un matto, entrare in Microsoft nel team Windows e poter finalmente aprire i sorgenti. Senza vomitare.

Sedici anni dopo, LFS ha [annunciato](https://lists.linuxfromscratch.org/sympa/arc/lfs-announce/2026-02/msg00000.html) che non manterrà più la versione System V.

E permettetemi di dire che *questo mi fa incazzare*, non tanto per l'annuncio di cui condivido pensieri e parole con Dubbs, ma per il contesto più ampio in cui questo evento cade (nulla avviene nel vuoto).

{% include more.html %}

## Che è successo

Bruce Dubbs mantiene LFS da anni. Il primo febbraio ha scritto alla mailing list:

> citation "Bruce Dubbs" [https://lists.linuxfromscratch.org/sympa/arc/lfs-announce/2026-02/msg00000.html]
> To me LFS is about learning how a system works. Understanding the boot process is a big part of that.

LFS esiste dal '99. Ventisette anni. Non è una distro da usare tutti i giorni. È un manuale. Ti prende per mano e ti guida nella compilazione di ogni singolo pezzo del sistema operativo. Dalla toolchain al kernel, dal bootloader ai servizi di base. Chi finisce LFS non ha solo un sistema funzionante. Ha capito cosa succede quando preme il pulsante di accensione.

Capiva.

D'ora in poi LFS documenta solo systemd. System V, il sistema di init che ha accompagnato Unix e Linux per decenni, sparisce. Chi vuole imparare come funziona un init semplice dovrà arrangiarsi.

## Perché

Bruce indica due motivi.

Il primo è il carico di lavoro. LFS è un progetto di volontari. Mantenere due versioni parallele — systemd e System V — è diventato impossibile. Non è solo raddoppiare la documentazione. I due sistemi non sono più intercambiabili. Le dipendenze si sono intrecciate. Ogni nuovo pacchetto va testato due volte. Ogni aggiornamento può rompere qualcosa da una parte o dall'altra. I workaround si accumulano. I volontari si stancano.

Mi ricordo perfettamente quando durante la mia prima LFS a metà percorso ho cambiato il sistema per la gestione dell'hardware togliendo udev per fare le cose con uno scriptino che mi piaceva di più. Scomodo per una *distro full-fledged*, difficile da mantenere su scala, tutto vero, ma per me avere il pieno controllo di come l'hardware viene mappato, come gli IRQ vengono assegnati, come vengono creati i dispositivi a blocchi e come vengono legati i driver ai moduli generici e agli stessi dispositivi a blocchi era fondamentale, per capire che succede quando connetti una chiavetta. Udev è bellissimo eh, funziona da paura. Se non ti interessa capire come il sistema operativo comunica con l'hardware lato user space, cioè cosa succede quando attacchi una chiavetta al PC.

Il secondo motivo è peggio. GNOME e KDE ora richiedono funzionalità che solo systemd fornisce. Vuoi costruirti un desktop moderno? Ti serve systemd. Non c'è alternativa praticabile. Il lock-in si è propagato verso l'alto nello stack. Non è più solo il sistema di init. È tutto quello che ci sta sopra.

Bruce non nasconde il fastidio:

> citation "Bruce Dubbs" [https://lists.linuxfromscratch.org/sympa/arc/lfs-announce/2026-02/msg00000.html]
> I do not like this decision. [...] we will be losing some things I consider important. However, the decision needs to be made.

Bruce non è un nostalgico che rimpiange i bei tempi andati. È uno che ha dedicato anni della sua vita a insegnare come funzionano i sistemi.

## I numeri

Ecco il dato che mi ha fermato:

> citation "Bruce Dubbs" [https://lists.linuxfromscratch.org/sympa/arc/lfs-announce/2026-02/msg00000.html]
> systemd is about 1678 C files plus many data files. System V is 22 C files plus about 50 short bash scripts and data files.

1678 contro 22.

Lascia che affondi. 1678 file di codice C. Più file di configurazione, unit, timer, socket, target. Contro 22 file C e una cinquantina di script bash.

Con 22 file potevi leggere tutto. Potevi aprire ogni file, seguire il flusso dall'inizio alla fine, capire cosa fa ogni riga. Potevi tenere il sistema in testa. Modificarlo. Romperlo e ripararlo. Era un esercizio alla portata di una persona sola con tempo e curiosità.

Con 1678 no. Non perché sei stupido o pigro. Perché nessuno tiene in testa 1678 file. Neanche chi li ha scritti. A quel punto non stai più capendo un sistema. Ti stai fidando di un sistema.

Un sistema tra l'altro molto complesso, perché mentre con SysV tu dovevi studiare un software che fa da init system, con systemd tu studi uno stack intero che fa *anche* init. E filtrare la "parte init" dal resto su systemd non è banale. Puoi provarci, aspetto qui che io ho già dato (ampiamente).

## L'ecosistema

systemd non è un semplice sistema di init. È diventato un ecosistema. C'è systemd-logind per la gestione delle sessioni. systemd-networkd per la rete. systemd-resolved per il DNS. systemd-timesyncd per la sincronizzazione del tempo. journald per i log. udev per i device. Ogni pezzo ha le sue configurazioni, le sue convenzioni, le sue interazioni con gli altri pezzi.

È un progetto ambizioso. Ha cercato di standardizzare e modernizzare l'infrastruttura di base di Linux. Ha risolto problemi veri: l'avvio parallelo dei servizi, la gestione delle dipendenze, l'integrazione con cgroups, la standardizzazione dei log. Funzionalità che servono, specialmente su server complessi e container.

Ma è opaco. Se qualcosa non funziona, non puoi aprire uno script e leggere cosa fa. Devi navigare un labirinto di unit, dipendenze, target, slice. Devi fidarti che qualcun altro abbia capito al posto tuo.

Mi è capitato l'anno scorso. Il portatile non si spegneva. Restava appeso su "A stop job is running" per due minuti prima di arrendersi. Con SysV avrei aperto lo script di shutdown, letto cosa faceva, trovato il problema. Con systemd ho passato un'ora a cercare tra journalctl, systemctl list-jobs, analisi dei target. Alla fine ho trovato il colpevole: un servizio che non rispondeva al SIGTERM. Ma il percorso per arrivarci è stato tortuoso. Non impossibile. Tortuoso. Praticamente, come dicono dalle mie parti, *un dito nel c\*lo*.

## Il punto

Non mi interessa stabilire se systemd è buono o cattivo. È una discussione da forum del 2014. L'ho già fatta, mi sono stancato.

Mi interessa una cosa diversa.

Nel 2010, quando scrivevo quel post su LFS, davo per scontato che capire fosse possibile. Era lì, la possibilità. Bastava volerlo abbastanza. Ti scaricavi i sorgenti, seguivi il manuale, compilavi tutto. Alla fine avevi un sistema che capivi. Pezzo per pezzo.

Sedici anni dopo quella possibilità si è ristretta. Non è sparita. È più stretta, è più complicata, è più opaca e offuscata da sistemi che certo sono *enterprise-grade* ma che non sono *student-grade* o *hackable*. Sicuramente, non è democratica. Al diavolo alle Big Tech che vogliono "democratizzare" tutto, coi loro sistemi opachi che di democratico hanno solo il *consumo* dei loro sistemi, non certo i sistemi stessi. Hanno imparato dai maestri del Big Tech, Microsoft, e il loro processo 3E, "Embrace, Extend, Extinguish", ma applicato al *free software*.

LFS era la prova che capire era alla portata di un singolo. Il sentiero che potevi percorrere se volevi andare fino in fondo. Adesso quel sentiero passa per 1678 file C e un ecosistema di componenti interdipendenti.

Mi era capitato con Samba, un progetto enorme e complicatissimo, che a un certo punto ho semplicemente smesso di leggere e ho deciso che fidarmi era l'unica soluzione. È un mostro. Ma systemd non è Samba, non puoi NON installarlo. Samba si, se non ti serve accedere alle Share di rete Windows che magari è un'esigenza di nicchia, o puoi usare un FuseFS per accedere alle share di rete, ce ne sono alcuni carini per cose spot, se non ti serve avere tutte le mega funzionalità di Samba (tra cui integrazione con Active Directory).

systemd no, non ha alternative valide, non puoi avere un drop-in replacement decente, il resto del sistema deve essere consapevole che sotto *non c'è* systemd, perché non basta rimpiazzarlo, serve *comunicare a tutti* che non è lui l'init system. Con Samba non serve, hai una cartella, qualcuno l'avrà montata (smbmount, mount -o fusefs qualcosa, qualche altro software), tu la navighi e accedi ai file.

La cosa che mi inquieta è che è successo gradualmente. Nessuno l'ha deciso. È il risultato di mille piccole decisioni prese da mille persone diverse, ognuna razionale nel suo contesto. Sommate insieme producono un effetto che nessuno aveva pianificato.

## Chi scrive il codice

systemd è un progetto sponsorizzato da Red Hat. I suoi sviluppatori sono in larga parte dipendenti di aziende. Le feature che vengono implementate rispondono a esigenze enterprise: gestione di container, orchestrazione di servizi complessi, integrazione con stack cloud.

Sono esigenze legittime. Ma non sono le tue esigenze quando vuoi capire perché il portatile ci mette 30 secondi a spegnersi. Non sono le mie esigenze quando voglio sapere cosa succede al boot.

Non sto suggerendo una cospirazione. È più banale. È come funziona l'economia del software libero oggi. Chi paga gli sviluppatori decide le priorità. E chi paga, oggi, sono le grandi aziende. Le conseguenze le subiamo tutti. Ma non tutti abbiamo voce in capitolo.

Il codice è aperto. Puoi leggerlo. La direzione la decidono altri. E fa schifo.

## LFS è di nicchia

Lo so cosa stai pensando. LFS è di nicchia. Quanti lo completano davvero? Mille persone all'anno? Diecimila? È irrilevante rispetto ai milioni che usano Ubuntu senza sapere cos'è un init.

Vero.

Ma il valore di LFS non stava nei numeri. Stava nel fatto che esisteva. Era la prova che capire era possibile. Il sentiero che qualcuno poteva percorrere se voleva andare fino in fondo.

Ho conosciuto gente che ha fatto LFS. Non erano geni. Erano persone normali con tempo e curiosità. Studenti, hobbisti, sysadmin che volevano capire cosa c'era sotto. Alcuni ci hanno messo mesi. Altri hanno mollato a metà e ripreso l'anno dopo. Nessuno di loro è diventato un kernel developer. Ma tutti hanno capito qualcosa che prima non capivano.

Quel percorso esisteva. Era accessibile. Non facile, ma accessibile.

Quando quel sentiero si restringe, non perdiamo solo chi lo percorreva. Perdiamo la possibilità stessa. L'idea che il sistema sotto i nostri piedi sia comprensibile, modificabile, nostro in un senso che va oltre il mero utilizzo.

Ah, "nostro" non intendo di noi addetti ai lavori. Maintainer, sviluppatori kernel, gente che legge codice C a colazione - quelli se la cavano comunque. Chi ha perso è lo studente al terzo anno di Ingegneria che apre il Tanenbaum e vuole andare più a fondo. Lo smanettone curioso. Quello che magari non vuole finire consulente-schiavo in qualche ditta di body rental.

## La complessità è inevitabile?

Altra obiezione ovvia. I sistemi crescono. L'hardware diventa più potente. Le aspettative aumentano. La complessità è inevitabile.

In parte è vero. Ma 22 file contro 1678 non è crescita organica. È un ordine di grandezza (o anche due). È passare da qualcosa che un individuo può dominare a qualcosa che richiede un'organizzazione.

E poi c'è la questione di cosa conta come "complessità necessaria". systemd ha aggiunto funzionalità che SysV non aveva. Avvio parallelo. Gestione delle dipendenze. Socket activation. Cgroups integration. Sono cose utili.

Ma alcune di quelle funzionalità esistono da anni in sistemi molto più piccoli. s6 fa socket activation. runit fa supervisione dei processi. OpenRC gestisce le dipendenze. Lo fanno con meno codice, meno astrazione, meno opacità.

La differenza è nell'ambizione. systemd vuole essere tutto: init, logger, network manager, DNS resolver, time sync, login manager. Vuole standardizzare l'intera infrastruttura di base. Non è strettamente necessario per far partire un computer. Ma è utile se gestisci un datacenter.

Faccio una domanda che può chiarire meglio il punto: _tutta quella complessità serve **a te**? È necessaria per i tuoi casi d'uso? O serve ai casi d'uso di Red Hat e dei suoi clienti enterprise?

Non ho una risposta. (Beh, una ce l'avrei, ma non voglio denunzie-querele da colossi del tech)

## Cosa resta

Non voglio chiudere in modo apocalittico, perché non è questa la situazione. Il software libero non è morto. Linux non è morto. La possibilità di capire non è sparita. È solo tutto molto, molto, molto (ordini di grandezza) più complesso.

Esistono alternative. Void Linux usa runit. Alpine usa OpenRC. Artix e Devuan offrono scelte multiple. Progetti come s6 e dinit dimostrano che un sistema di init può essere potente senza essere mastodontico. Sono sistemi che puoi leggere, capire, modificare. Esistono ancora.

Ho usato Void per un paio d'anni. runit è elegante. Tre fasi: setup, run, finish. Ogni servizio è una directory con uno script. Vuoi sapere cosa fa? Apri lo script. Vuoi cambiarlo? Editi lo script. Nessuna magia, nessun database binario, nessuna astrazione che nasconde cosa succede.

Poi sono tornato a una distro mainstream per questioni pratiche. Hardware nuovo, driver proprietari, software che richiedeva systemd. La solita storia.

E NVIDIA. Dio quanto odio NVIDIA. Fuck NVIDIA.

![Linus Torvalds - Fuck NVIDIA]({% link /media/2026-02-03/linus-torvalds-fuck-nvidia.gif %}){: .img-fluid }

Esistono persone che mantengono viva la semplicità. Spesso con poco riconoscimento e meno soldi. Sono comunità piccole. A volte ruvide. A volte elitarie nel modo sbagliato.

Anche restando nel mondo systemd, capire è ancora possibile. La documentazione è buona. I sorgenti sono aperti. Non è impossibile. È solo molto più difficile di prima.

E "molto più difficile" significa, in pratica, che meno gente lo farà. Capire diventa un'attività da specialisti. Non più da curiosi. Non più da ventenni con tempo e voglia di smontare le cose.

## Una serie

Questo è il primo post di una serie. Non so ancora quanti saranno. L'idea è esplorare cosa sta succedendo al software libero. Non dal punto di vista degli attivisti - quelli sono già convinti. Dal punto di vista di chi usa Linux tutti i giorni senza farsi troppe domande.

Non voglio fare prediche. Non voglio convincere nessuno che systemd è il male o che bisogna tornare a SysV. Non mi interessa. Mi interessa porre domande che forse non ti sei mai posto. O che non ci poniamo abbastanza come comunità.

Tipo: il codice è aperto, ma chi decide cosa ci finisce dentro? Le licenze sono libere, ma chi ha le risorse per contribuire? Il sistema è tuo, ma quanto ne capisci davvero?

Quello che mi chiedo: quanto capisci del sistema che usi? Quanto potresti capire, se volessi?

Nel prossimo post parlerò di un altro livello. Chi decide cosa può girare sulla tua macchina. Secure Boot, firmware blob, Intel ME. Perché avere root non significa avere il controllo.

E chiudo con una domanda: quanto è ipocrita sbandierare la GPLv3, baluardo della libertà di hacking, in progetti guidati da chi del profitto fa l'unico scopo di esistenza?

La mia risposta, visto che è casa mia: molto. C'è una parola per chi predica libertà mentre costruisce gabbie. Non la scrivo io. La lascio a chi l'aveva capita oltre settant'anni fa:

{: .text-center }
> citation "George Orwell - 1984, slogan del Partito inciso sul Ministero della Verità" [https://it.wikipedia.org/wiki/1984_(romanzo)]
> Freedom is Slavery

![War is Peace - Freedom is Slavery - Ignorance is Strength]({% link /media/2026-02-03/1984-party-slogans.jpg %}){: .img-fluid }
{: .text-center }
