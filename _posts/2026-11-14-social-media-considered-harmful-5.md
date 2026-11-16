---
lang: it
title: "Social media considered harmful. Forse... (5/5): Chi governa e chi paga"
series: social-media-considered-harmful
tags:
- societa
- politica
- big-tech
- social-network
- software-libero
- unione-europea
date: 2026-11-14 08:46:05+00:00
category: saggio
---

Nel febbraio del 2025 IFTAS, l'organizzazione senza scopo di lucro che forniva al Fediverso strumenti condivisi per la sicurezza e la moderazione, ha annunciato di non avere più nemmeno un finanziamento garantito, e nelle settimane successive ha spento buona parte dei suoi servizi. Non aveva sbagliato niente di tecnico. Viveva di donazioni e contributi, e quando i soldi sono finiti il lavoro che faceva per tutti è rimasto senza nessuno che lo pagasse. Per tutto il 2025 le servivano circa 1,2 milioni di dollari. Meta, a Bruxelles, spende circa 10 milioni di euro l'anno per farsi lisciare il pelo dai legislatori, e la sicurezza di un'intera rete è morta per una cifra che a Meta basta per poco più di un mese.

Nelle puntate precedenti ho raccontato che [lo sapevano]({% link _posts/2026-10-18-social-media-considered-harmful-1.md %}), che chi ha provato a [fermarli]({% link _posts/2026-10-23-social-media-considered-harmful-2.md %}) ci è riuscito poco, che per [sopravvivere]({% link _posts/2026-11-01-social-media-considered-harmful-3.md %}) oggi il lavoro tocca a chi li usa, e come potrebbe essere fatto [un social umano]({% link _posts/2026-11-07-social-media-considered-harmful-4.md %}). In quest'ultima puntata provo a rispondere alla domanda che IFTAS rende concreta, cioè chi paga un social del genere, e chi impedisce a chi lo governa di diventare l'ennesimo padrone.

{% include more.html %}

## Un muro solo non basta

Ogni limite, preso da solo, si aggira. Un tetto alla pubblicità lo aggira chi controlla il software che lo applica, una licenza la aggira chi ha gli avvocati per interpretarla, uno statuto lo aggira chi compra la maggioranza di chi vota. La storia delle piattaforme è piena di regole rispettate alla lettera e svuotate nella sostanza, e di amministratori delegati che piagnucolano in diretta davanti al Congresso americano, con la faccia da cane bastonato (o da robot rettiliano), e poi, come raccontano i loro stessi documenti interni, tornano in ufficio a segare ogni correzione che rischi di far scendere l'engagement. Un attore motivato, con abbastanza soldi in gioco, trova sempre il punto debole di una difesa isolata.

Per questo l'idea su cui ho costruito questa parte è una cerchia di limiti che si tengono fra loro, la forma giuridica, le regole, il software e la buona fede che si può verificare, messi in modo che ognuno sorregga gli altri. Funziona come le sabbie mobili, dove più si spinge su un punto, più si affonda negli altri, e chi provasse a forzarne uno per far crescere il capitale si troverebbe a dover rompere anche tutti quelli intorno. È anche la parte che mi è costata di più, perché ogni scelta di questa puntata ne ha richieste altre due per non lasciare un buco, e alcune idee che mi sembravano buone le ho dovute buttare.

## Chi scrive il software

Il software lo scriverebbe e lo manterrebbe una fondazione europea senza scopo di lucro, con la licenza AGPL, quella che obbliga chi modifica il programma e lo fa usare in rete a pubblicare le proprie modifiche.

La mia prima idea era un'altra, e non era una bella idea. Volevo una licenza scritta apposta, che permettesse di installare un'istanza solo versando alla fondazione una percentuale degli incassi, che vietasse qualunque modifica non accettata nel software ufficiale (una modifica rifiutata andava tolta), che vietasse di riusare il codice altrove e che concedesse i diritti per un tempo limitato, da rinnovare. Sulla carta proteggeva il progetto da tutto, compresi i fork, le copie del software che un gruppo di persone porta avanti per conto suo. In pratica consegnava tutto il potere alla fondazione, e la trasformava nell'unico punto da conquistare, perché chi se la fosse presa, con un consiglio comprato o una legge cambiata, avrebbe avuto in mano l'intera rete, senza che nessuno potesse andarsene portandosi dietro il codice. Una licenza del genere, per giunta, non sarebbe stata nemmeno libera.

Con l'AGPL il fork resterebbe sempre possibile, ed è proprio questa la via d'uscita se la fondazione venisse catturata. Il controllo, invece di stare nel diritto d'autore, si sposterebbe sulla certificazione, cioè su un marchio e su un contratto. Chiunque potrebbe prendere il codice e farci quello che vuole, ma solo chi usa il software ufficiale, o modifiche accettate nel software ufficiale, potrebbe dirsi certificato, comparire per primo nella stazione e ospitare ragazzi. Il fork resterebbe legale, solo che fuori dalla certificazione.

## Chi certifica

La certificazione la rilascerebbe un ente separato dalla fondazione, titolare del marchio. Due strutture da mantenere invece di una sono un mal di testa in più, ma è il prezzo per non mettere nelle stesse mani chi scrive le regole e chi controlla che vengano rispettate.

Il problema vero era un altro. Nella [seconda puntata]({% link _posts/2026-10-23-social-media-considered-harmful-2.md %}) ho criticato le verifiche del *Digital Services Act*, che l'articolo 37 fa pagare alle piattaforme stesse, perché un revisore pagato da chi deve controllare ha ogni interesse a non scontentarlo. È come far scegliere e pagare l'arbitro alla squadra di casa, e poi fingere di stupirsi se i rigori li fischia sempre dalla stessa parte. In Italia, per questo genere di cose, abbiamo un nome, e non è "verifica indipendente". Un certificatore pagato dalle istanze che certifica avrebbe esattamente lo stesso conflitto. Per questo, nel mio progetto, chi giudica non incasserebbe niente da chi viene giudicato. Le istanze pagherebbero un solo contributo alla fondazione, come condizione del contratto di certificazione, e la fondazione girerebbe al certificatore una quota fissa delle sue entrate, scritta nello statuto e garantita per più anni, senza poterla ridurre a piacere. Il consiglio del certificatore non lo nominerebbe la fondazione, altrimenti la separazione sarebbe solo sulla carta.

Anche qui all'inizio avevo pensato a un'altra soluzione, un certificatore "quasi controllato" dalla fondazione, con dentro un operatore di riferimento, cioè la principale istanza della rete, a fare da contrappeso. Era un errore, perché un unico operatore con un posto garantito diventa l'unico da comprare per ottenere quel potere, e regala alla più grande delle istanze un privilegio scritto nello statuto, l'opposto di una stazione dove nessun treno vale più degli altri.

Il certificatore, poi, non dovrebbe fidarsi solo delle carte. Il codice sarebbe aperto, ed era la condizione che chiedevo per una verifica seria. Le piattaforme di oggi il loro codice lo fanno vedere ai revisori più o meno come un casinò lascia smontare ai clienti le slot machine per controllare se sono truccate. La garanzia più forte, però, arriverebbe da un'altra parte. Gli annunci viaggerebbero nel protocollo, e li mostrerebbero app con il codice aperto, che saprebbero contarli. Un'istanza che superasse il tetto giornaliero per un utente verrebbe scoperta dall'app di quell'utente, che potrebbe rifiutare gli annunci in eccesso e segnalarlo. Così nessuna istanza potrebbe alzare la pubblicità per qualche mese, incassare e riabbassarla poco prima di un controllo, perché il controllo lo farebbe, ogni giorno, il telefono di chi la usa. Anche il tetto sarebbe blindato, perché gli operatori potrebbero regolare quanti annunci mostrare e quando, ma solo verso il basso, e il software rifiuterebbe di funzionare sopra il limite.

## Quis custodiet ipsos custodes?

Chi impedisce che fondazione e certificatore si mettano d'accordo, o che qualcuno compri l'una e strangoli l'altro tagliandogli i fondi?

La mia risposta è un garante, cioè un soggetto terzo e disinteressato che non incassa niente dalla rete e ha un solo potere, il veto su poche clausole dello statuto, quelle blindate. Sarebbero le clausole che reggono tutta la cerchia: la quota che finanzia il certificatore, il tetto alla pubblicità, i parametri della formula del contributo, l'età minima e la definizione di utente attivo. Chiunque prendesse il controllo della fondazione potrebbe cambiare tutto il resto, ma non queste, senza il suo assenso. È un meccanismo che il diritto societario conosce da tempo con il nome di *golden share*, e qui l'azione d'oro la terrebbe chi, per costruzione, nella rete non ha interessi economici. Una specie rara, lo so, soprattutto nei dintorni della Silicon Valley, dove perfino il comitato che giudica le decisioni di Meta sui contenuti lo paga Meta, che è il modo californiano di chiedere all'oste se il vino è buono.

Accanto al garante metterei un collegio degli operatori, con voce sui criteri di certificazione e sulla formula, perché chi gestisce le istanze sa meglio di chiunque cosa costa moderare e quanto pesa un obbligo. Il collegio però non voterebbe mai sulla certificazione di una singola istanza, né la propria né quella di un concorrente, altrimenti ritroveremmo il conflitto che abbiamo appena tolto dal certificatore.

## Gli obblighi di chi modera

Nella puntata scorsa ho scritto che la moderazione la farebbero le persone. La certificazione dovrebbe trasformare questo principio in obblighi precisi, che sarebbero cinque.

Il primo è avere moderatori in proporzione agli utenti, con un rapporto minimo fissato nei criteri di certificazione, perché un'istanza da centomila iscritti moderata da due volontari la sera è di fatto un'istanza non moderata. Il secondo riguarda le segnalazioni, che andrebbero gestite entro un tempo massimo, con una decisione motivata e la possibilità di fare ricorso. Il terzo chiede regole pubbliche, scritte prima, uguali per tutti, così che nessuno venga punito per una norma inventata dopo. Il quarto è l'isolamento coordinato delle istanze che ospitano abusi, attraverso un servizio condiviso da tutta la rete, cioè proprio il genere di lavoro che faceva IFTAS. Il quinto protegge chi resta senza casa, perché un'istanza che chiude dovrebbe avvisare per tempo i suoi utenti, e permettere a tutti di portarsi via contatti e contenuti su un'altra istanza.

Niente di tutto questo è inventato da zero. Dal 2019 Mastodon, nella sua pagina ufficiale, elenca solo i server che sottoscrivono un impegno, il *Mastodon Server Covenant*, che ne chiede quattro: moderazione attiva contro razzismo, sessismo, omofobia e transfobia, backup quotidiani, almeno un'altra persona con accesso d'emergenza al server e almeno tre mesi di preavviso prima della chiusura. È una certificazione in embrione, senza un ente separato, senza verifiche e senza soldi, ma dimostra che l'idea regge anche in una rete che diffida di ogni centro.

La differenza con IFTAS starebbe nei soldi, perché il servizio d'isolamento vivrebbe di una quota fissa di quello che la rete incassa.

## Chi paga

Le istanze si manterrebbero da sole, e ognuna sceglierebbe liberamente come, con una o più fonti mescolate fra loro. Ci sarebbero istanze a pagamento con servizi in più, fra cui, per esempio, l'assenza di pubblicità. Ci sarebbero istanze gratuite pagate da enti pubblici, come quelle di un comune o di un'università, che a mio parere dovrebbero essere le più comuni, perché un social è la piazza dove si forma l'opinione pubblica, l'agorà della Magna Grecia dove si discuteva di politica ma anche del prezzo del pane e del pesce, e una piazza la paga la comunità. E ci sarebbero istanze private gratuite, sostenute da donazioni e da pubblicità.

La pubblicità sarebbe quella della puntata scorsa, mai profilata, sempre dichiarata e sotto un tetto giornaliero per utente. Le aziende avrebbero anche il proprio profilo, con post che arrivano solo a chi ha scelto di seguirle, e potrebbero pagare per un rilancio, una spinta simile all'*hype* di YouTube, con cui un post viene proposto anche a chi non lo segue. Ogni rilancio ricevuto conterebbe come un annuncio, dentro il tetto di chi lo riceve, e anche chi rilancia avrebbe un limite suo, pochi rilanci per periodo, perché resti un gesto raro.

Il tetto per utente è quello che rende tutto il resto possibile. Superata la soglia giornaliera, ogni minuto in più passato sul social non porterebbe un centesimo, e le entrate di un'istanza crescerebbero solo con il numero dei suoi utenti. Per questo, se si vuole evitare che un'istanza diventi un'altra Meta, bisogna far pagare la crescita. Meta, del resto, è l'azienda che ha preso la voglia di ritrovare i compagni del liceo e l'ha trasformata in un'asta quotidiana della nostra attenzione, con noi come carne al banco e senza nemmeno la percentuale sul venduto.

## Una formula per chi cresce troppo

Ogni istanza certificata pagherebbe alla fondazione un contributo calcolato sui propri incassi, con un'aliquota che sale con il numero di utenti. Un'istanza senza entrate, come quella di un'associazione che vive di quote dei soci, non pagherebbe niente. Una piccola pagherebbe poco, una grande molto di più, e da un certo punto in poi ogni nuovo iscritto costerebbe all'istanza più di quanto le fa guadagnare. Nessuna regola vieterebbe di crescere oltre, ma la crescita smetterebbe di convenire.

Volevo una formula sola, per quanto complessa, che dati i numeri restituisca la cifra dovuta, e non un elenco di scaglioni e di eccezioni da commercialista. Le tabelle a scaglioni creano soglie su cui conviene fermarsi appena sotto (basta chiedere a qualunque partita IVA in regime forfettario quanto lavora volentieri a dicembre, quando è a un passo dagli 85.000 euro), mentre una funzione continua non ha gradini da sfruttare. Non è un'idea strana come può sembrare. In Germania l'imposta sul reddito è scritta nella legge come una serie di formule, polinomi che danno l'imposta dovuta in ogni fascia di reddito, e nell'economia pubblica c'è un filone di studi, a partire da Heathcote, Storesletten e Violante, che descrive un intero sistema fiscale progressivo con una funzione e due soli parametri.

A parole, funzionerebbe così. Ogni istanza verserebbe una percentuale dei propri incassi, e quella percentuale dipenderebbe solo da quanti utenti ha. Per un'istanza piccola sarebbe minima, uguale per tutte, quanto basta a mantenere la fondazione. Man mano che gli utenti crescono salirebbe, prima piano e poi sempre più in fretta, senza mai arrivare al 100%.

{% katexmm %}

Nelle formule, $R$ sono gli incassi annui dell'istanza e $U$ i suoi utenti attivi, contati entrambi sull'intero gruppo che la controlla. $a_{\min}$ è l'aliquota di base, quella che paga un'istanza minuscola. $U_0$ è una dimensione di riferimento, espressa in numero di utenti, che fissa la scala della curva. $k$, un numero maggiore di 1, dice quanto è ripida la salita: più è alto, più a lungo le istanze piccole restano vicine all'aliquota di base, e più netto è il muro quando arriva. La lettera $e$ è il numero di Nepero, la base degli esponenziali, e qui serve solo a disegnare una curva che parte piatta, sale e poi si appiattisce di nuovo sotto il 100%. L'aliquota media, cioè la percentuale degli incassi da versare, sarebbe

$$a(U) = a_{\min} + (1 - a_{\min})\left(1 - e^{-(U/U_0)^k}\right)$$

Il pezzo fra parentesi tonde grandi vale zero quando gli utenti sono zero e si avvicina a uno quando sono molti più di $U_0$. Moltiplicato per $1 - a_{\min}$, cioè per quello che manca all'aliquota di base per arrivare al 100%, porta l'aliquota da $a_{\min}$ fin quasi al 100%, senza mai toccarlo. Il contributo dovuto è semplicemente gli incassi per l'aliquota, e scritto per intero è la formula principale di tutto il meccanismo, quella che dati gli incassi e gli utenti restituisce la cifra da versare:

$$F(R, U) = R \cdot a(U) = R \left[ a_{\min} + (1 - a_{\min})\left(1 - e^{-(U/U_0)^k}\right) \right]$$

La formula ha qualche proprietà che a me piace. Se gli incassi sono zero, il contributo è zero. Per le istanze piccole l'aliquota resta vicina a quella di base, e poi accelera. Non supera mai il 100% degli incassi, quindi nessuno paga più di quanto incassa.

Conta però di più un'altra grandezza, l'aliquota marginale, cioè quanta parte degli incassi portati da un utente in più se ne va in contributo. È più alta di quella media, perché quando un utente in più fa salire l'aliquota, l'aliquota nuova si applica a tutti gli incassi dell'istanza, compresi quelli degli utenti che c'erano già. Se ogni utente porta in media gli stessi incassi, e con il tetto alla pubblicità per utente è un'approssimazione ragionevole, l'aliquota marginale è la derivata, cioè la velocità con cui cresce il prodotto fra utenti e aliquota media a ogni utente in più:

$$m(U) = \frac{d}{dU}\bigl[U \cdot a(U)\bigr]$$

A un certo punto l'aliquota marginale supera il 100%. Da lì in poi un nuovo utente fa salire il contributo più di quanto faccia salire gli incassi, e crescere significa perdere soldi. In pratica il muro arriva anche prima, quando l'aliquota marginale raggiunge il margine che l'istanza guadagna su ogni utente. Per dare un'idea, con un'aliquota di base del 2% e $k = 2$, i numeri sarebbero questi (la dimensione è in frazioni di $U_0$, quindi 0,5 vuol dire metà di $U_0$):

| Utenti, in frazioni di $U_0$ | Aliquota media | Aliquota marginale |
| ---------------------------: | -------------: | -----------------: |
|                          0,1 |           3,0% |               4,9% |
|                          0,2 |           5,8% |              13,4% |
|                          0,3 |          10,4% |              26,6% |
|                          0,5 |          23,7% |              61,8% |
|                          0,7 |          40,0% |              98,8% |
|                            1 |          63,9% |             136,1% |

Con $k = 2$ crescere smette di convenire a circa sette decimi di $U_0$, per l'esattezza a $U_0/\sqrt{2}$, e questo punto dipende solo da $k$, non dall'aliquota di base. Con $k = 3$ le istanze piccole verrebbero risparmiate più a lungo (a 0,3 l'aliquota media sarebbe del 4,6%) e il muro sarebbe più ripido. I valori veri non li scrivo perché dovrebbe essere lo statuto a fissarli insieme alla definizione di utente attivo. Per la stessa ragione $R$ e $U$ andrebbero calcolati sull'intero gruppo che controlla un'istanza, altrimenti basterebbe dividersi in dieci istanze formalmente diverse per pagare come dieci piccole.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8" markdown="1">
![Grafico in funzione degli utenti, in frazioni di U0, con aliquota di base al 2% e k uguale a 2. L'aliquota media sale lentamente verso il 100% senza raggiungerlo. L'aliquota marginale sale più in fretta e incrocia il 100% a circa 0,71, il muro, segnato con un pallino rosso da cui scende una linea tratteggiata fino all'asse. Il peso del rimborso per istanza cresce fino a circa 0,42 proprio in corrispondenza del muro e poi scende, mentre il peso del rimborso per utente scende fin dall'inizio.]({% link media/2026-11-14/formula-contributo.svg %}){: .img-fluid }
</div>
</div>

Il grafico è fatto con LabPlot, un programma libero di KDE per l'analisi dei dati e i grafici, che gira su Linux, Windows e macOS. Il progetto si può [scaricare]({% link media/2026-11-14/formula-contributo.lml %}) e aprire con LabPlot 2.12 o successivo. I parametri stanno nel foglio "parametri", e cambiando il numero all'inizio della formula delle colonne `amin` e `k` le curve si ricalcolano da sole, così si vede dove si sposta il muro. Anche il punto del muro e la linea del massimo vengono dai parametri, quindi si spostano insieme alle curve.

Resta da decidere che fine fanno i soldi in più. La fondazione avrebbe un bilancio fissato dallo statuto, $B$, che comprende la quota del certificatore. Se le istanze versano più di quel bilancio, l'eccedenza in parte finanzierebbe i servizi condivisi, come quello d'isolamento degli abusi, e il resto tornerebbe alle istanze, in proporzione ai loro utenti, perché server, corrente e moderatori costano in proporzione agli utenti. L'eccedenza sarebbe

$$S = \max\Bigl(0, \sum_i F_i - B\Bigr)$$

dove $F_i$ è il contributo della singola istanza $i$, la somma $\sum_i$ li mette insieme tutti, e il massimo fra zero e la differenza dice soltanto che, se i contributi restano sotto il bilancio, non c'è niente da ridistribuire. Ogni istanza riceverebbe una parte dell'eccedenza proporzionale a un peso $w_i$, cioè ai suoi utenti, ciascuno contato per quello che resta all'istanza dopo l'aliquota, $1 - a(U_i)$, quasi per intero nelle istanze piccole e un po' meno in quelle grandi:

$$q_i = S \cdot \frac{w_i}{\sum_j w_j}, \qquad w_i = U_i \bigl(1 - a(U_i)\bigr)$$

Alla fine dell'anno, quello che ogni istanza paga davvero è il contributo meno il rimborso:

$$N_i = F(R_i, U_i) - q_i$$

Dividere per la somma dei pesi di tutte le istanze, $\sum_j w_j$, serve solo a fare in modo che le quote, sommate, diano esattamente l'eccedenza. Il peso cresce con gli utenti, come crescono i costi, ma per ogni utente è un po' più alto nelle istanze piccole, e siccome le grandi pagano un'aliquota più alta e ricevono indietro un po' meno per utente, nel saldo si farebbero carico di una parte del conto delle piccole. È una forma di welfare fra istanze, in cui chi è più forte sostiene chi lo è meno. Una rete federata vive delle sue istanze piccole, la pro loco, l'associazione, la scuola, e tenerle in piedi conviene anche alle grandi, che senza di loro sarebbero solo l'ennesimo social centralizzato con un altro nome. Il peso ha anche un'altra proprietà utile. Smette di crescere proprio dove l'aliquota marginale arriva al 100%, e da lì in poi scende, quindi il rimborso aiuta un'istanza a coprire i costi finché cresce in modo sano, ma praticamente non sposta il punto oltre il quale crescere non conviene più. È una tassa progressiva applicata alla dimensione invece che al reddito, e tutti i calcoli sarebbero funzioni pure, che chiunque può rifare con gli stessi numeri e ottenere lo stesso risultato.

{% endkatexmm %}

## Chi ci ha provato prima

Non sono il primo a pensare a un social diverso, e quelli che ci hanno provato prima hanno lasciato lezioni utili, anche quando sono andati male.

App.net nacque nell'agosto del 2012 come alternativa a Twitter senza pubblicità, pagata dagli abbonamenti di utenti e sviluppatori, con una raccolta fondi che superò i 750.000 dollari da più di 11.000 sostenitori. Nel 2013 divenne gratuito con servizi a pagamento, e nel gennaio 2017 annunciò la chiusura, perché, come ha scritto TechCrunch, semplicemente non guadagnava. Il cofondatore Dalton Caldwell ha osservato che in tanti dicono di volere più privacy e più controllo, ma pochi sono disposti a pagare per averli ("few are willing to pay for it"). Il modello di business era onesto, ma un social vale quante persone ci sono dentro, e chiedere soldi a chi ancora non trova nessuno con cui parlare è una salita durissima.

La frase di Caldwell, letta da questa parte dell'Atlantico, dice molto più di quanto volesse. Per lui la privacy è un servizio in più, che chi ci tiene compra con un sovrapprezzo, ed è la stessa logica con cui Apple ne ha fatto un argomento di vendita per prodotti costosi, un optional da listino, come il sedile riscaldato di un'auto, che chi ha i soldi si compra e gli altri si attaccano al tram. Interessa come bene di consumo, non come diritto. In Europa la protezione dei dati personali è un diritto fondamentale, scritto nella Carta dei diritti dell'Unione accanto al rispetto della vita privata, e pagare per averla sarebbe come pagare per farsi curare al pronto soccorso. Negli Stati Uniti, dove devi pagare anche per non schiattare male su un marciapiede, evidentemente non hanno spirito di auto-preservazione.

Il giurista americano James Whitman, già nel 2004, descriveva due culture della privacy, una europea fondata sulla dignità e una americana fondata sulla libertà dallo Stato, e la distanza si vede nei tribunali. La Corte di giustizia dell'Unione ha annullato due accordi sul trasferimento dei dati verso gli Stati Uniti, nel 2015 e nel 2020, e il terzo, confermato in primo grado nel 2025, è di nuovo davanti alla Corte. Nell'aprile del 2025 la Commissione ha multato Meta per 200 milioni di euro perché il suo modello "paga o acconsenti" non lasciava agli utenti un'alternativa vera alla profilazione. Per un'azienda che nel 2024 ha fatturato 164 miliardi di dollari è meno di mezza giornata di incassi, roba che a Menlo Park non scomoda nemmeno il commercialista, la ritrovano sotto i cuscini del divano, ma almeno il principio è stato messo per iscritto.

Secondo me la distanza è culturale prima che di mercato, e per questo non si colma con un accordo. È anche il motivo per cui in questo social la privacy non si comprerebbe, perché la pubblicità sarebbe non profilata per tutti, e a pagamento si potrebbe togliere la pubblicità, non comprare la riservatezza. È il modello di Proton, il servizio di posta svizzero, che cifra da un capo all'altro anche gli account gratuiti, con lo stesso livello di cifratura dei piani a pagamento ("the same level of encryption as any of our paid plans"), e fa pagare lo spazio e i servizi in più.

Diaspora nel 2010 era il sogno di quattro studenti della New York University, un social distribuito e rispettoso della privacy. Su Kickstarter chiedevano 10.000 dollari, li hanno raggiunti in dodici giorni, e alla fine ne hanno raccolti circa 200.000 da quasi 6.500 sostenitori. Diaspora esiste ancora, oggi lo cura una fondazione, eppure è sempre rimasto di nicchia. Secondo me è rimasto lì perché era difficile da usare, e chi ci arrivava non ci trovava i propri amici. I principi erano giusti, ed è caduto proprio sulle due cose che io metto prima di tutto il resto, la facilità d'uso e le persone.

Orkut è morto in un altro modo, per decisione del suo proprietario. Era il social di Google, nel 2008 fra i siti più visitati in Brasile e in India, e nel 2014 Google lo ha chiuso spiegando che altre sue comunità, come YouTube, Blogger e Google+, crescevano più in fretta. E Google+, la grande promessa per cui valeva la pena sacrificare Orkut, ha fatto la stessa fine meno di cinque anni dopo, che a Mountain View è più o meno l'aspettativa di vita di qualunque cosa non diventi una macchina da pubblicità. Un proprietario con altre priorità è esattamente il problema di governo che fondazione, certificatore e garante dovrebbero impedire.

Minds, infine, è l'esempio di come non farlo. Nato come alternativa "libera" a Facebook, nel 2018 è passato a un gettone sulla blockchain di Ethereum, con cui ricompensava gli utenti per i contenuti e per l'engagement, e che si poteva spendere per dare più visibilità ai propri post. Pagare le persone perché interagiscano di più è la massimizzazione dell'engagement scritta nel modello di business, con il gettone al posto della slot machine. Hanno preso la macchinetta della prima puntata e ci hanno attaccato sopra una blockchain, come se da sola non facesse già abbastanza danni al cervello, e a me sembra semplicemente vergognoso.

E poi c'è IFTAS, da cui sono partito, che insegna che i servizi di cui ha bisogno tutta la rete non possono dipendere dalla generosità di qualcuno, perché la generosità prima o poi finisce.

## Chi metterebbe i primi soldi

Tutto quello che ho descritto si manterrebbe da solo una volta avviato, ma all'inizio qualcuno dovrebbe pagare il software, la stazione e i primi servizi condivisi, prima che esista una sola istanza a versare un contributo. È il momento in cui progetti come questo muoiono, oppure finiscono nelle mani del primo investitore che chiede in cambio di crescere a ogni costo.

Una strada, almeno come prova, in Europa esiste già. A novembre 2026 è partito il progetto pilota di un fondo europeo per le tecnologie libere, l'*EU Sovereign Tech Fund*, guidato dalla Sovereign Tech Agency tedesca nell'ambito del Digital Commons EDIC, il consorzio europeo per i beni comuni digitali, e cofinanziato dall'Unione. Dalla primavera del 2027 dovrebbe scegliere un primo piccolo gruppo di progetti da finanziare. Il fondo, per come è descritto oggi, punta sulle infrastrutture da cui dipende altro software, non sulle applicazioni, quindi il social intero non ci rientrerebbe. Ci rientrerebbero però i pezzi che fanno da infrastruttura per tutti, come il protocollo, la stazione o il servizio condiviso contro gli abusi.

Sarebbe anche la scelta più coerente per un'Europa che non vuole soltanto regolare le piattaforme degli altri, ma prendere una posizione attiva e costruire. Non è l'Europa che abbiamo adesso, lo so, ma le elezioni servono anche a questo.

## Quello che non so risolvere

Alcuni problemi non li ho risolti.

Il primo è la legge. Una fondazione europea può far rispettare un contratto di certificazione in Europa, ma un'istanza in un paese che non riconosce quel contratto avrebbe come unico freno la perdita del marchio. Per la maggior parte delle istanze basterebbe, per un attore deciso a ignorarlo no.

Il secondo è la definizione di utente attivo, da cui dipende tutta la formula. Contare gli account è facile e inutile, perché un account abbandonato non costa niente, e contare chi entra ogni giorno spinge proprio verso quello che il progetto vuole evitare. Una definizione onesta esiste, credo, ma va scritta con cura, e chi ha interesse a truccarla ne avrebbe moltissimo.

Il terzo è la cattura. Ho messo fondazione, certificatore, garante e collegio a controllarsi a vicenda, ma un garante disinteressato oggi può diventare interessato domani. Basta un incarico ben pagato al momento giusto, e la [seconda puntata]({% link _posts/2026-10-23-social-media-considered-harmful-2.md %}) ha un nome e un cognome per raccontarlo. Non conosco un meccanismo che lo impedisca per sempre. Posso solo renderlo costoso.

Il quarto è il rischio che le istanze certificate diventino un recinto, un club chiuso che usa la certificazione per tenere fuori la concorrenza. I criteri pubblici e il fork sempre possibile lo rendono difficile, non impossibile.

E poi niente di tutto questo esiste. È la descrizione di un software, e fra un'idea descritta bene e un social che funziona c'è di mezzo il lavoro di molte persone per molti anni.

## Forse

Questa serie si chiama "considered harmful. Forse..." per una ragione. I social come sono fatti oggi, per come li ho raccontati nelle prime tre puntate, secondo me fanno più male che bene, e lo sanno anche loro. Il "forse" sta tutto nelle ultime due, perché un social che serve le persone invece di sfruttarle si potrebbe costruire, ma richiede di rinunciare a crescere a ogni costo, e di accettare una fatica di progettazione e di governo che le piattaforme di oggi non hanno mai voluto fare, perché a loro conveniva il contrario. E quando conviene il contrario, da quelle parti, l'etica diventa un comunicato stampa, scritto dal marketing, limato dagli avvocati e smentito dalla trimestrale successiva.

## Fonti

- [IFTAS, "Funding challenges and the future of our work", 6 febbraio 2025](https://about.iftas.org/2025/02/06/funding-challenges-and-the-future-of-our-work/)
- [IFTAS, panoramica 2024-2025, con il bilancio previsto per il 2025](https://about.iftas.org/wp-content/uploads/2025/02/2024-2025-IFTAS-Overview.pdf)
- [Euronews, sulla spesa delle big tech per il lobbying a Bruxelles, 29 ottobre 2025](https://www.euronews.com/2025/10/29/big-tech-spending-on-brussels-lobbying-hits-record-high-report-claims)
- [GNU Affero General Public License, versione 3](https://www.gnu.org/licenses/agpl-3.0.html)
- [Regolamento (UE) 2022/2065, Digital Services Act, testo italiano, articolo 37](https://eur-lex.europa.eu/legal-content/IT/TXT/?uri=CELEX:32022R2065)
- [Mastodon Server Covenant](https://joinmastodon.org/covenant)
- [Einkommensteuergesetz, § 32a, tariffa dell'imposta sul reddito](https://www.gesetze-im-internet.de/estg/__32a.html)
- [Heathcote, Storesletten, Violante, "Optimal Tax Progressivity: An Analytical Framework", NBER Working Paper 19899, 2014, poi Quarterly Journal of Economics, 2017](https://www.nber.org/papers/w19899)
- [App.net, Wikipedia](https://en.wikipedia.org/wiki/App.net)
- [TechCrunch, la chiusura di App.net, 12 gennaio 2017](https://techcrunch.com/2017/01/12/app-net-the-ambitious-project-to-build-a-better-twitter-is-finally-dead)
- [Carta dei diritti fondamentali dell'Unione europea, articoli 7 e 8](https://eur-lex.europa.eu/legal-content/IT/TXT/?uri=CELEX:12012P/TXT)
- [James Q. Whitman, "The Two Western Cultures of Privacy: Dignity Versus Liberty", Yale Law Journal, 113(6), 2004](https://yalelawjournal.org/article/the-two-western-cultures-of-privacy-dignity-versus-liberty)
- [heise online, il ricorso contro il Data Privacy Framework arriva alla Corte di giustizia](https://heise.de/-10965203)
- [Commissione europea, "Commission finds Apple and Meta in breach of the Digital Markets Act", 23 aprile 2025](https://digital-markets-act.ec.europa.eu/commission-finds-apple-and-meta-breach-digital-markets-act-2025-04-23_en)
- [Meta, risultati del quarto trimestre e dell'intero 2024, 29 gennaio 2025](https://investor.atmeta.com/investor-news/press-release-details/2025/Meta-Reports-Fourth-Quarter-and-Full-Year-2024-Results/default.aspx)
- [Oversight Board, "Securing Ongoing Funding for the Oversight Board", sul finanziamento del comitato da parte di Meta](https://oversightboard.com/?p=5008)
- [Apple, la pagina sulla privacy](https://www.apple.com/privacy/)
- [Proton Mail, piani e prezzi](https://proton.me/mail/pricing)
- [Diaspora, Wikipedia](https://en.wikipedia.org/wiki/Diaspora_%28social_network%29)
- [Orkut, Wikipedia](https://en.wikipedia.org/wiki/Orkut)
- [TechCrunch, "Google+ for consumers will shut down on April 2nd", 30 gennaio 2019](https://techcrunch.com/2019/01/30/google-for-consumers-will-shut-down-on-april-2nd)
- [CoinDesk, "Blockchain Social Network Minds Is Migrating to Ethereum for Launch", 13 agosto 2018](https://coindesk.com/markets/2018/08/13/blockchain-social-network-minds-is-migrating-to-ethereum-for-launch/)
- [Fortune, su Minds e il suo gettone, 16 settembre 2021](https://fortune.com/2021/09/16/minds-social-network-crypto-balance-sheet-ethereum-bitcoin-usd-coin/)
- [Sovereign Tech Agency, EU Sovereign Tech Fund](https://www.sovereign.tech/programs/eu-sovereign-tech-fund)
- [LabPlot, software libero di KDE per l'analisi dei dati e la visualizzazione](https://labplot.org/)
