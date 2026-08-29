---
title: "Monorepo, GitFarm e il debito che non pubblicano"
tags:
- architettura
- big-tech
- git
- ingegneria-del-software
date: 2026-08-29 13:34:42+00:00
---

Sabato mattina, caffè, InfoQ. Uber ha costruito GitFarm, un servizio che esegue le operazioni git al posto del client. Nessun clone locale: si chiama una API gRPC, dall'altra parte c'è un repository già pronto, e torna solo il risultato dell'operazione. Il motivo sta nei numeri che pubblicano loro. Clonare il monorepo Go di Uber richiede circa quindici minuti, sei core, 32 GB di memoria e più di 40 GB di disco.

Se il clone costa 40 GB e un quarto d'ora, il problema non è il clone.

Questa storia dei monorepo mi gira in testa da anni, ed è l'ennesimo articolo che pontifica sull'argomento senza mai arrivare al punto. La posizione da cui parto è sempre la stessa: il monorepo non serve a niente. Non ho mai trovato una ragione per tenere quattrocento cose in un posto solo, e ogni volta che qualcuno me ne dà una si sfalda appena la gratti.

Solo che è una posizione che non ho mai messo alla prova sul serio, e una convinzione che non provi a rompere non è una convinzione, è un pregiudizio. Quindi stamattina ho provato a romperla per bene, leggendo le fonti primarie invece dei commenti su Hacker News.

Si è rotta in un punto solo. Ed è quello che ho trovato guardando cosa restava in piedi che vale la pena raccontare.

{% include more.html %}

## GitFarm non lo hanno costruito per gli sviluppatori

Prima di prendermela con qualcuno, però, conviene guardare bene cosa hanno costruito. Perché è costruito bene.

GitFarm espone le operazioni git dietro una API gRPC. Un gateway autentica e autorizza, poi instrada verso cluster che eseguono i comandi git standard dentro sandbox effimere. Il backend tiene cloni bare sincronizzati con l'upstream, per push e con fetch periodici, e mantiene pool di checkout e di container già caldi. Quando arriva una richiesta, monta un checkout pre-riscaldato in una sandbox libera invece di clonare da zero. Il risultato dichiarato è un checkout completo sotto i 500 millisecondi, contro cold start di dieci-quindici minuti.

Il dettaglio che cambia la lettura è chi sono i clienti. I sistemi di automazione di Uber invocano git milioni di volte al giorno. Il servizio di code ownership girava su sei host e consumava più di 70 core e 400 GB di memoria; dopo GitFarm sta in 16 core e 32 GB, con l'avvio sceso da quindici-venti minuti a meno di uno. Il servizio di compliance auditing processa fra 10.000 e 20.000 eventi l'ora attraversando 9.000 repository, e la latenza mediana è passata da 110-160 secondi a 20-30.

Nessuno di questi è un essere umano che apre un editor. Sono bot: CI, scanner, auditor, e da oggi agenti. Nessuno di loro ha bisogno di una copia di lavoro persistente, ed è per questo che il pooling funziona. GitFarm non risolve un problema di layout del repository. Risolve un problema di caching e multi-tenancy, e lo risolve bene.

E il caso più costoso che citano, quello dei 9.000 repository, è un problema *da multirepo*. Il compliance scanner deve toccare novemila repo distinti perché sono distinti. GitFarm aiuta di più lì che sul monorepo.

## Uber non ha un monorepo, ne ha sei

E qui arriva il primo punto in cui la vulgata si scolla dai fatti pubblicati, che è anche il punto in cui ho cominciato a sospettare di aver capito male io.

Uber non ha "il" monorepo. Ha un monorepo per stack linguistico: Go, Java, Python, Web, Android, iOS. E in parallelo migliaia di repository separati, altrimenti quel compliance scanner non avrebbe novemila cose da guardare.

Vale anche per l'esempio archetipico. Il paper con cui Google ha raccontato il proprio modello dà i numeri di gennaio 2015: circa un miliardo di file, 86 TB di dati, due miliardi di righe di codice in nove milioni di file sorgente, circa 35 milioni di commit in diciotto anni. Come termine di paragone, il paper confronta con il kernel Linux, che allora stava sui 15 milioni di righe in 40.000 file.

Nello stesso testo, nero su bianco: i team di Android e Chrome usano git fuori dal repository principale, e la ragione dichiarata è la collaborazione con partner esterni e con l'open source. A questo si aggiungono DeepMind, Waymo e Verily, entità giuridiche distinte con infrastrutture proprie. Ne esce una cosa che nessuno ripete mai: il monorepo di Google non contiene Google.

Il che rende insensata una certa retorica che ho letto anche in tempi recenti, quella sul "taglio globalmente consistente dell'intera azienda". Nessuno ha bisogno che AlphaGo e Meet siano allo stesso commit del 14 marzo, e infatti non lo sono. Prodotti diversi, cicli diversi, contratti API in mezzo.

Quindi di cosa stiamo parlando davvero, quando parliamo di monorepo.

## L'unica proprietà che la disciplina non produce

Il monorepo ha una giustificazione tecnica seria, ed è una sola. Conviene isolarla, perché quasi tutto quello che di solito le viene attribuito intorno è corollario o pubblicità.

La proprietà è il commit atomico attraverso i consumer.

Il caso di scuola: una libreria interna cambia la firma di un metodo, e quel metodo è chiamato da quattrocento moduli. In un repository unico la modifica alla libreria e l'aggiornamento dei quattrocento chiamanti stanno nello stesso commit, e la CI valida l'insieme in una volta. Non esiste alcun istante in cui la libreria è nuova e i chiamanti sono vecchi. Non esiste nemmeno una versione della libreria da negoziare: esiste HEAD.

Spezzato in quattrocento repository, lo stesso cambiamento diventa un altro oggetto. Si pubblica una 2.0.0, si aprono quattrocento pull request di bump, se ne mergiano duecentosessanta in due settimane, novanta in tre mesi, cinquanta mai. Quel residuo non è una pendenza contabile: è il posto esatto dove restano ferme le versioni vulnerabili il giorno che su quella libreria esce una CVE.

Google ha formalizzato la cosa come *one version rule*: nel repository esiste una sola versione di ogni dipendenza, interna o di terze parti. Da sola sarebbe un'imposizione. Quello che la rende praticabile è la contropartita, codificata nelle due direzioni: chi introduce il cambiamento è responsabile di aggiornare tutti i chiamanti, e chi consuma ha la Beyoncé rule, se un comportamento serviva bisognava metterci un test.

Sotto la meccanica c'è una questione di allocazione dei costi, e vale la pena guardarla per quello che è.

In multirepo il costo di un cambiamento incompatibile ricade sui consumer: N team pagano poco ciascuno, in momenti diversi, e nessuno di quei costi compare nel bilancio di chi il cambiamento lo ha introdotto. È un'esternalità nel senso stretto del termine. In monorepo lo stesso costo ricade sul produttore, che paga molto, subito, e lo vede.

Il meccanismo non funziona perché produce persone più disciplinate. Funziona perché sposta il pagatore.  
Rimuovere la necessità di convincere quattrocento team a mettere in sprint la migrazione di qualcun altro è una proprietà strutturale, e in un'organizzazione grande quel tipo di convincimento è esattamente la cosa che riesce peggio, perché richiede un'autorità trasversale che di norma non è assegnata a nessuno.

Anche questa lettura è loro, non un'interpretazione esterna. Il capitolo 22 di *Software Engineering at Google* descrive il finanziamento di un team dedicato alle migrazioni come l'internalizzazione delle esternalità che un mandato non finanziato produce. Usano quella parola.

Resta un ultimo pezzo, che il versionamento semantico non copre e per costruzione non può coprire. La legge di Hyrum: con un numero sufficiente di consumer, ogni comportamento osservabile di un'interfaccia, promesso o no, finisce per essere una dipendenza di qualcuno. Il contratto dichiara le intenzioni, il call graph registra i fatti, e le due cose divergono in modo sistematico. Progettare richiede il primo. Rispondere a un incidente richiede il secondo, e nel monorepo il secondo è una query esatta invece che un'euristica su una code search di cui non si sa se copre tutto.

## Il confine è il grafo di build, non l'azienda

Da qui discende la conclusione che le presentazioni saltano sempre, e che secondo me è la cosa più importante di tutto il discorso.

L'unità del monorepo non è l'organizzazione. È il **dominio di risoluzione**: l'insieme di componenti su cui serve un solo grafo di dipendenze, risolto una volta sola. Un singolo workspace Bazel, un singolo reattore Maven, un GOPATH nell'era in cui i moduli non c'erano.

Ecco perché Uber ne ha uno per linguaggio e non uno per azienda. Il confine coincide con il confine del gestore di dipendenze, non con l'organigramma.

La prova sta dall'altra parte. Il multirepo su scala il punto di coordinamento se lo costruisce sempre, e si chiama manifest. Android ha il manifest di `repo`, Chromium ha i file DEPS, Zephyr ha `west.yml`. Sono file che pinnano uno SHA per ogni componente, in un unico posto, che va aggiornato in modo transazionale perché il sistema resti riproducibile. Cioè un indice globale di versioni. Il monorepo ridotto ai suoi puntatori.

La differenza reale fra i due modelli, una volta tolto il marketing, è che in multirepo la vista globale è un artefatto derivato che può divergere dalla realtà, e in monorepo la vista globale *è* la realtà. La divergenza fra un modello e la cosa modellata non è un problema di disciplina: è una proprietà strutturale dell'avere due copie. La disciplina abbassa il tasso di divergenza. Non la possibilità.

Fin qui il caso a favore, ed è un buon caso. Adesso però guardiamo il conto.

## Il prezzo è alto, ed è quello che non scrivono

Git non ha ACL per path. Non le ha, punto: il controllo di accesso in git è per repository.

Su un monorepo git puro non si contiene niente, si sorveglia soltanto. Un repository che contenga insieme codice con segmentazioni di compliance diverse, dati regolamentati e l'ultima acquisizione ha un problema di sicurezza risolto dalla buona volontà dei reviewer.

Piper invece le ACL ce le ha. Il paper dice che supporta liste di controllo accesso a livello di file, che gli accessi in lettura e scrittura sono loggati, e che un file committato per sbaglio può essere epurato. Sembra la risposta.

Poi c'è la nota a piè di pagina, ed è la riga che non cita mai nessuno: oltre il 99% dei file conservati in Piper è visibile a tutti gli ingegneri Google a tempo pieno.

Il meccanismo esiste e opera su meno dell'uno per cento della codebase. Il paper è esplicito su cosa protegge: file di configurazione importanti e algoritmi critici per il business. Tutto il resto lo vedono tutti, per progetto.

Finché il collettivo è piccolo e coeso funziona benissimo. Con venticinquemila persone che fra loro non si conoscono è una scelta con delle conseguenze, e il posto dove qualcuno le discute non l'ho ancora trovato.

Sul perché Piper esista, poi, circola una convinzione diffusa e sbagliata, che ho avuto anch'io. Non è la sicurezza. Il paper indica come motivazione principale la crescita continua del repository: per più di dieci anni Google ha retto su una singola istanza Perforce ospitata su una macchina sola, con caching custom sopra. Quando Perforce non ha più scalato, hanno scritto un version control system distribuito su dieci datacenter, con Paxos, sopra Spanner.

Il motivo per cui non passano a git è dichiarato con la stessa chiarezza: un clone git copia tutto il contenuto sulla macchina locale, procedura incompatibile con un repository grande, e per adottarlo bisognerebbe spezzare il repository in migliaia di repository separati. Cioè esattamente la cosa di cui si sta discutendo qui, scritta da loro come ipotesi scartata.

Fermati un attimo sulla catena, perché è tutta lì. Lo strumento standard non regge il modello, quindi si riscrive lo strumento. Il nuovo strumento regge il modello, quindi il modello cresce. Il modello cresciuto non è più portabile su niente di standard, quindi lo strumento proprietario diventa obbligatorio per sempre.

Poi c'è la capability. Il monorepo crea per costruzione la possibilità di modificare tutto in un atto, e il capitolo 22 di *Software Engineering at Google* documenta per intero come la governano.

Chi vuole fare una Large-Scale Change compila un documento con motivazione e impatto stimato. Il documento va a una mailing list di circa una dozzina di persone che hanno la supervisione dell'intero processo, e il comitato, per loro stessa ammissione, è stato storicamente molto liberale nel concedere l'approvazione. Poi Rosie genera la modifica globale, la spezza in shard secondo i confini di progetto e li manda in review.

A questo punto il libro scrive una cosa che, se l'avessi scritta io, mi avrebbero dato del polemico esagerato.

> citation "Hyrum Wright, Software Engineering at Google, cap. 22" [https://abseil.io/resources/swe-book/html/ch22.html]
> local project owners have come to trust infrastructure teams to the point where these changes are often given only cursory review

La review che dovrebbe contenere la capability viene data in modo superficiale, perché chi la dà si fida. E il capitolo prosegue: i proprietari locali hanno imparato che non hanno un diritto di veto sulla LSC complessiva, e la maggior parte degli shard non arriva nemmeno a loro ma a un *global approver*, una persona con diritti di approvazione su qualunque punto del repository, che a sua volta approva con strumenti a pattern matching e guarda a mano solo le anomalie.

In ottica capability-based è il pattern da evitare. Una capacità pericolosa che non serve non la crei a monte, invece di crearla e doverci poi mettere sopra un comitato: il comitato è runtime, la struttura è compile time. E qui la parte runtime, per ammissione loro, è perfunctoria. Nel multirepo nessuno ha bisogno di un comitato per le LSC, perché la LSC non è esprimibile.

C'è il monolithic build, che Skelton e Pais elencano fra i tipi di monolite come costo di flusso reale anche quando i deployable sono migliaia. E soprattutto c'è il monolithic model, cioè la perdita del promemoria che quel confine esiste. Il bounded context resta nell'interfaccia di rete, ma smette di essere percepito, e la percezione dei confini è metà del lavoro di un'architettura.

Non risolve lo skew di runtime, che rimane identico: HEAD è uno stato unico del sorgente, la flotta deployata è eterogenea per costruzione, e parallel change, expand-contract e feature flag restano obbligatori esattamente come prima.

E infine converte un problema distribuito in uno centralizzato, che poi richiede GitFarm per tornare trattabile. Il cerchio si chiude, e la chiusura del cerchio è il prodotto che finisce sul blog.

## Quello che mi è rimasto in mano

A questo punto la posizione di partenza va corretta, e la correggo.

"Il monorepo non serve a niente" è falso. Il commit atomico attraverso i consumer è una proprietà vera, non ottenibile per altra via, e chi la nega sta parlando di una cosa che non ha letto. Su questo avevo torto, e me lo tengo.

Ma guarda dove si rompe, la mia posizione, perché il punto in cui una cosa cede dice più della cosa stessa. Si rompe su una proprietà sola, non su un elenco. Si rompe su un perimetro che è il grafo di build e non l'azienda. E il prezzo di quella proprietà, messo in fila, è questo: un version control system proprietario perché lo standard non regge, un comitato per governare una capacità che nel modello alternativo non esisterebbe proprio, review che loro stessi definiscono superficiali, ACL che esistono e restano inutilizzate sul 99% dei file, e uno strumento nuovo ogni due anni per rendere trattabile la centralizzazione prodotta dal giro precedente.

Quindi la formulazione che sopravvive non è "non serve a niente". È più stretta e molto più interessante: il monorepo risolve poco, e quel poco costa moltissimo.

E adesso la domanda che mi si è aperta sotto, che è il vero motivo per cui sto scrivendo. Se risolve poco, tutto quel tooling per cosa esiste?

Sono tornato sulle motivazioni pubblicate a leggerle una per una, chiedendomi ogni volta di che natura fosse il problema che dicono di risolvere.

La one version rule esiste perché quattrocento team non aggiornano spontaneamente. Problema di coordinamento fra persone.

Le migrazioni centralizzate esistono perché, testuale, a nessuno piacciono i mandati non finanziati, e il libro definisce in nota il mandato non finanziato come un requisito imposto da un'entità esterna senza compensazione. Problema di incentivi fra team.

Il comitato esiste perché, da quando il tooling è migliorato, per un singolo ingegnere è diventato banale scaricare un carico di review su mezza azienda, e serviva qualcuno che ci mettesse una soglia di ponderazione. Problema di allocazione dell'attenzione umana.

Il *global approver* esiste perché mandare uno shard a ogni proprietario locale costa più che far capire la modifica una volta sola a un esperto. Problema di costo di processo.

GitFarm esiste perché migliaia di automazioni concorrono sulle stesse risorse e i clone freddi non scalano. Questo sì che è un problema tecnico, ed è l'unico della lista.

Quattro su cinque non sono problemi di codice. Sono problemi di come si coordinano gruppi di persone che non si conoscono fra loro, e la risposta a tutti e quattro è stata: costruiamo qualcosa che ce lo tolga di mezzo.

## 180 repository e 400 deployment

Fin qui ho citato roba di altri. Adesso il numero mio, che è l'unica cosa che mi autorizza a dire qualcosa.

Io gestisco 180 repository e circa 400 deployment singoli su due ambienti. Codice eterogeneo: frontend, backend, infrastruttura, batch, monoliti veri, roba nuova. Ho automatizzato tutto quello che era automatizzabile: test, CI/CD, bot di aggiornamento delle dipendenze, analisi statica, review semi-automatiche, workflow agentici. Ne vado fiero.

Non ho mai avuto bisogno di un monorepo. Non ho mai avuto bisogno delle ACL per path su git. Non ho mai avuto bisogno di niente che somigli lontanamente a GitFarm.

Questo non è un argomento contro Uber e non ho intenzione di spacciarlo per tale. Uber sta due ordini di grandezza sopra, e a due ordini di grandezza le cose cambiano davvero. È un punto sperimentale, e dice una cosa sola ma la dice con certezza: la soglia oltre cui questi strumenti servono sta *sopra* 180 repository e 400 deployment. Dove esattamente non lo so, e non lo sa nessuno, perché nessuno ha interesse a pubblicarlo.

Tienilo a mente, perché fra due sezioni torna.

## Il dirigente che chiude il prodotto sbagliato

Ti racconto uno scenario, che non è tratto da un caso pubblico e non provo a spacciartelo per tale: è una situazione ricorrente, che chiunque abbia lavorato dentro una struttura grande riconosce.

Un'azienda ha due linee di prodotto: una economica e lenta, una costosa e veloce. Gli indicatori della seconda risultano migliori su tutta la linea, inclusa la soddisfazione percepita dai clienti. Sono migliori perché la raccolta dei dati ha un difetto che nessuno in alto vede: la linea cara viene misurata su un campione autoselezionato di clienti che avevano già scelto di pagare di più. L'amministratore delegato legge la tabella, chiude la linea che "non funziona" e tiene quella che va bene.

Due anni dopo esiste un solo prodotto, che costa come quello caro ed è lento come quello economico.

Il fallimento qui non è di misurazione, o non solo. È che chi aveva il potere di decidere non aveva la conoscenza necessaria a valutare la propria decisione, e chi aveva quella conoscenza stava in periferia e non aveva canale. È il problema della conoscenza dispersa di Hayek: l'informazione rilevante per una scelta non esiste in forma aggregata da nessuna parte, esiste solo distribuita, locale e particolare.

Adesso torna alla sezione sulle Large-Scale Change, e guardala con questi occhi.

A questa obiezione Google ha una risposta, ed è buona, quindi te la riporto per intero prima di attaccarla. Il capitolo 22 sostiene che sono proprio i team di infrastruttura ad avere la conoscenza di dominio necessaria a sistemare centinaia di migliaia di riferimenti, che i team consumer quel contesto non ce l'hanno, e che pretendere che ognuno se lo ricostruisca è globalmente inefficiente. Aggiunge che la centralizzazione accelera il recupero dagli errori, perché gli errori ricadono in poche categorie note per cui il team che guida la migrazione ha già un playbook. È un argomento serio, e in larga parte è vero.

Ma la conoscenza di cui parlano è quella dell'API che cambia. Non è quella dei quattrocento contesti in cui l'API viene chiamata, e quella non è centralizzabile, perché non esiste in forma aggregata da nessuna parte.

Il residuo lo dichiarano loro. Nel caso di studio sulla migrazione da `scoped_ptr` a `std::unique_ptr`, cinquecentomila riferimenti e mesi di lavoro, il libro descrive una coda lunghissima di dipendenze comportamentali sottili, che chiama per nome come l'ennesima manifestazione della legge di Hyrum, più usi dentro codice generato che il tooling automatico non rilevava. Quella coda l'hanno lavorata a mano, man mano che l'infrastruttura di test la faceva emergere.

Il compilatore e i test garantiscono le proprietà verificabili meccanicamente. Non garantiscono nient'altro. E "nient'altro" è dove stanno le decisioni.

## La cultura è capex, se smetti di considerarla un costo

Qui c'è un argomento economico che sento fare di continuo, e che ho fatto anch'io finché non l'ho guardato bene.

Suona così: un tool è capex, si paga una volta e non dimentica; una norma culturale è opex perpetuo con perdita, perché ogni assunzione la diluisce e ogni uscita ne porta via un pezzo. Con un turnover del 20% annuo, in tre anni si è rinnovata metà della popolazione che quella norma la conosceva per averla vissuta. Quindi a scala il tool vince.

L'argomento è sbagliato, e lo è per una ragione tecnica: tratta il turnover come esogeno.

Il turnover non è esogeno. È funzione della qualità dell'ambiente. Un ambiente culturalmente scadente è tossico, un ambiente tossico espelle persone, e ogni persona espulsa porta via conoscenza tacita e obbliga a comprare quella successiva più cara. L'ambiente compare su entrambi i lati dell'equazione e il conto cambia segno.

Guarda le voci. Gallup stima il costo di sostituzione di una persona fra mezza e due volte la retribuzione annua, con la parte alta della forbice occupata dai ruoli senior e specialistici, e SHRM lo colloca fra i sei e i nove mesi di stipendio contando ricerca, rampa e produttività persa. Il premio salariale necessario a trattenere qualcuno in un posto dove si sta male è ricorrente e non produce niente: è il prezzo della tossicità, pagato in busta paga. Nessuna delle due voci compare mai nel business case di una piattaforma interna, mentre il costo del platform team ci compare sempre.

È la stessa asimmetria contabile di tre sezioni fa, quella del monorepo: il costo che si vede finisce nel modello, quello che si spalma sulle persone no.

E l'handbook è un tool anche lui, sia detto per onestà. GitLab non lascia il buon senso al middle management in forma orale: lo codifica in un documento versionato, pubblico, sottoposto a merge request. Applica al processo lo stesso trattamento che si applica al codice. La differenza fra un handbook, una ADR, una checklist, un gate di CI e un compilatore non è di natura, è di posizione su un continuum: quanto quel vincolo si limita a suggerire e quanto invece impedisce.

Il criterio per collocarcisi non l'ho mai visto scritto da nessuna parte, quindi lo scrivo io: costo della violazione moltiplicato per la sua rilevabilità. Violazione economica e visibile subito, quindi cultura e review: naming, stile, scelte di design. Violazione costosa e invisibile per mesi, quindi enforcement meccanico: la CVE non patchata, il segreto committato, la dipendenza che salta un confine di dominio. Mettere le seconde in cultura è ingenuo. Mettere le prime in enforcement è soluzionismo, e in più cancella la memoria del perché.

Un handbook costa qualche mese-uomo. Sapling, GitFarm, Piper e i loro equivalenti costano decine di milioni all'anno fra sviluppo, manutenzione e infrastruttura, perché quella roba poi gira da qualche parte e ha bisogno di cluster.

Non sono alternative. Ma comprarne una sola, con i soldi dell'altra, è una scelta.

## Dopo dieci anni la scelta non c'è più

C'è un motivo per cui questa non è una discussione che si può rifare ogni anno con calma.

I due investimenti sono mutuamente esclusivi nel tempo, perché ognuno produce l'organizzazione che ha bisogno di quel tipo di investimento. La legge di Conway funziona anche al contrario: un'organizzazione con un platform team forte produce architetture che richiedono un platform team forte. Non serve che nessuno lo voglia. Basta il feedback.

Dopo dieci anni di piattaforma non restano né la piattaforma né la cultura. Resta la piattaforma, e un'organizzazione che non sa più funzionare senza. La struttura di potere sopravvive alle persone che l'hanno creata, perché è stata materializzata in un artefatto tecnico che nessuno può più rimuovere senza fermare la produzione.

A quel punto il costo di risanare l'ambiente è altissimo e lo paga chi ci sta dentro, mentre comprare il prossimo drago costa un budget e lo firma un VP in una riunione. Per un manager con orizzonte di due anni la scelta razionale al margine è sempre la stessa, e sarà sempre la stessa, per sempre.

Non lo chiamerei un trade-off. Un trade-off è reversibile.

## Pubblicano lo strumento, non la condizione

Resta da capire perché una cosa del genere non si veda, visto che è tutta scritta nero su bianco nei loro documenti.

Una parte cospicua della letteratura sull'architettura la scrivono loro. Cockcroft è Netflix e poi AWS. Vogels è Amazon. Winters, Potvin e Levenberg sono Google. I paper, i libri O'Reilly, i talk alle QCon: escono da lì dentro, e sono anche buoni, io li ho letti tutti e continuo a leggerli.

Il problema non è che in big tech leggano poco. Il problema è cosa esce e cosa no. Esce lo strumento, perché lo strumento è recruiting, è employer branding, è un talk a una conferenza. Non escono le condizioni organizzative che lo hanno reso necessario, perché quelle sono ammissioni. Non esiste il post di Uber intitolato "quanti anni-uomo ci costa il monorepo". Non esiste quello intitolato "quante CVE stanno nella coda lunga dei nostri novemila repository". Non esiste quello sul turnover del team che ha mantenuto Piper.

Il risultato è un corpus già selezionato sugli strumenti che risolvono problemi endogeni, cioè problemi generati dalle scelte organizzative precedenti dello stesso attore che poi li risolve. Letto senza quel contesto, ne esce che monorepo, Bazel e GitFarm sono lo stato dell'arte, quando sono artefatti di una specifica traiettoria organizzativa.

Il caso che lo dimostra meglio è Prime Video, e lo dimostra due volte.

Nel marzo 2023 il team Video Quality Analysis pubblica un post: hanno riportato il servizio a processo singolo e hanno tagliato i costi di infrastruttura di oltre il 90%. Internet legge "Amazon abbandona i microservizi". Il testo dice un'altra cosa. Dice che il collo di bottiglia principale era l'orchestrazione con Step Functions, che eseguiva molteplici transizioni di stato per ogni secondo di stream, saturava i limiti di account ed è fatturata a transizione. Dice che il problema con S3 era il secondo, non il primo. Dice che il sistema sbatteva contro un limite rigido intorno al 5% del carico atteso, e quel numero non lo cita mai nessuno. E dice che l'architettura di alto livello è rimasta identica, con gli stessi tre componenti, che i detector ora vengono clonati e parametrizzati con sottoinsiemi diversi, e che davanti hanno messo uno strato di orchestrazione leggero per distribuire le richieste.

Hanno collassato l'hot path in un componente atomico e hanno tenuto distribuito tutto il resto. Una correzione di granularità, non un ritorno al monolite. Cockcroft, che in AWS è stato VP, lo ha scritto subito, e ha aggiunto una frase che vale più di tutto questo articolo.

> citation "Adrian Cockcroft" [https://adrianco.medium.com/so-many-bad-takes-what-is-there-to-learn-from-the-prime-video-microservices-to-monolith-story-4bd0970423d4]
> I do think microservices were over sold as the answer to everything

La seconda dimostrazione è che quel post oggi non sta più al suo URL. Ho provato a rileggerlo: `primevideotech.com` redirige a una pagina promozionale di `aboutamazon.com`. Ho dovuto recuperarlo da una copia archiviata del maggio 2023.

La parte che raccontava un errore di progettazione, l'unico documento in cui una big tech ha ammesso in pubblico di aver sbagliato granularità, è sparita dalla circolazione. L'articolo su GitFarm è di ieri e ha già fatto il giro.

Non sto dicendo che l'abbiano tolto per quello, non ne ho la minima prova. Dico che il gradiente esiste, punta sempre nella stessa direzione, e che pesando la letteratura per quanto a lungo resta online il bias peggiora ancora.

## Non è un problema di codice

Una cosa la voglio dire chiara, perché altrimenti questo pezzo diventa il solito sfogo contro le big tech, e non è quello che ho scritto.

GitFarm non risolve un problema inesistente. Quindici minuti e 40 GB esistono, ho letto i numeri, sono veri. Il monorepo una cosa la fa e nessun'altra tecnica la fa al posto suo. Bazel è ingegneria seria. Piper pure. Sapling anche. Quella gente è tecnicamente bravissima, e chi dice il contrario non ha letto niente.

La critica non è "problema inesistente". La critica è: problema reale, in larga parte generato da voi, e che avete scelto di risolvere a valle invece che a monte.

E questa formulazione non la puoi confutare mostrandomi la soluzione, perché la soluzione è la conferma.

Il posto dove sono arrivato stamattina, partito dall'idea che il monorepo fosse una cazzata e finito a leggere le note a piè di pagina del capitolo 22, è questo: le big tech hanno un problema di gestione delle persone, e da vent'anni lo comprano invece di risolverlo. Il monorepo, Piper, Bazel, Sapling, EdenFS, Scalar, GitFarm non sono lo stato dell'arte dell'ingegneria del software. Sono la protesi di un'organizzazione che ha smesso di provare a coordinarsi e ha iniziato a comprare strumenti che coordinino al posto suo.

Tre cose mi farebbero cambiare idea, e le scrivo perché altrimenti quella sopra è solo un'opinione con le note a piè di pagina.

Un business case pubblicato in cui il costo organizzativo dell'alternativa sia stato misurato e pesato, e lo strumento abbia vinto lo stesso. Uno di questi strumenti nato dentro un'organizzazione con turnover basso, autonomia alta e coordinamento sano, dove il problema umano era già risolto e serviva comunque. E una soglia dichiarata: a quanti repository, quanti commit, quanti ingegneri il multirepo si rompe davvero, con i numeri.

Nessuna delle tre esiste in pubblico. E la sezione qui sopra spiega perché non esisterà: quelle tre cose sono ammissioni, e le ammissioni non fanno employer branding.

Se lavori in un posto normale, e con normale intendo qualunque cosa sotto i cinque zeri di ingegneri, la roba da portarsi a casa è una domanda sola da farsi prima di copiare uno di quegli strumenti. Il problema che sto risolvendo è di codice o di persone?

Se è di persone, lo strumento non lo risolve. Lo copre. E te lo ripresenta fra due anni, più grande, con un nome nuovo e un post sul blog aziendale.

## Fonti

- Leela Kumili, [Uber Builds GitFarm to Run Git Operations as a Service for Large-Scale Monorepos](https://www.infoq.com/news/2026/08/uber-gitfarm-git-as-a-service/), InfoQ, 28 agosto 2026, e il [post originale di Uber Engineering](https://www.uber.com/us/en/blog/gitfarm-as-a-service/)
- Rachel Potvin, Josh Levenberg, *Why Google Stores Billions of Lines of Code in a Single Repository*, Communications of the ACM 59(7), 2016, [DOI 10.1145/2854146](https://doi.org/10.1145/2854146)
- Titus Winters, Tom Manshreck, Hyrum Wright, *Software Engineering at Google*, O'Reilly, 2020, ISBN 978-1492082798, capitoli 16, 21, 22. Il testo è leggibile gratuitamente: [capitolo 22, Large-Scale Changes](https://abseil.io/resources/swe-book/html/ch22.html)
- Gallup, *State of the Global Workplace*, e Society for Human Resource Management, sulle stime di costo di sostituzione del personale
- [Hyrum's Law](https://www.hyrumslaw.com/)
- Matthew Skelton, Manuel Pais, *Team Topologies*, IT Revolution Press, 2019, ISBN 978-1942788812, capitolo 6
- Marcin Kolny, *Scaling up the Prime Video audio/video monitoring service and reducing costs by 90%*, Prime Video Tech, 22 marzo 2023. L'URL originale non risolve più; [copia archiviata](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf)
- Adrian Cockcroft, [So many bad takes](https://adrianco.medium.com/so-many-bad-takes-what-is-there-to-learn-from-the-prime-video-microservices-to-monolith-story-4bd0970423d4), Medium, 6 maggio 2023
- Werner Vogels, [Monoliths are not dinosaurs](https://www.allthingsdistributed.com/2023/05/monoliths-are-not-dinosaurs.html), maggio 2023
- Friedrich Hayek, *The Use of Knowledge in Society*, American Economic Review 35(4), 1945
- Melvin Conway, *How Do Committees Invent?*, Datamation, aprile 1968
- David Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules*, CACM 15(12), 1972, [DOI 10.1145/361598.361623](https://doi.org/10.1145/361598.361623)
- Evgeny Morozov, *To Save Everything, Click Here*, PublicAffairs, 2013, ISBN 978-1610391382
- Neal Ford, Mark Richards, Pramod Sadalage, Zhamak Dehghani, *Software Architecture: The Hard Parts*, O'Reilly, 2021, ISBN 978-1492086895
- Alexandra Noonan, [Goodbye Microservices](https://segment.com/blog/goodbye-microservices/), Segment, luglio 2018
