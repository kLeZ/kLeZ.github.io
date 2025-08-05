---
title: "Java: quando il codice racconta 30 anni di errori e rivoluzioni"
tags:
- java
- filosofia
- evoluzione
date: 2025-08-05 14:43:55+02:00
---

Oggi voglio raccontarvi una storia. Non una di quelle storie edificanti sui "pionieri visionari" che troviamo nei manuali, ma la storia vera e cruda di come Java sia passato da linguaggio che ti odiava cordialmente a linguaggio che cerca almeno di capirti. È la storia di 30 anni di errori, testardaggine, rivoluzioni silenziose e quello che alla fine si rivela essere il più grande esperimento di ingegneria sociale mai tentato su 9 milioni di programmatori.

{% include more.html %}

Se hai iniziato a programmare in Java dopo il 2010, probabilmente non hai mai visto certe brutture. Se invece hai vissuto Java 1.0, sai quanto male si potesse stare. E se sei come me, che ho iniziato quando Vector era ancora considerato "best practice", beh... abbiamo visto cose che voi umani non potreste immaginare.

Ma diciamo le cose come stanno: Java nasce il 23 gennaio 1996 con un'ossessione malata per la sicurezza. E quando dico malata, intendo proprio patologica. James Gosling e il suo team avevano assistito ai massacri del C++, dove un puntatore sbagliato mandava in crash l'intero sistema, dove la gestione manuale della memoria era come giocare a Russian Roulette bendati, dove il multithreading era una disciplina esoterica per masochisti con tendenze suicide.

La loro risposta fu quella che oggi chiameremmo "helicopter parenting" applicato al design di linguaggi: tutto automatico, tutto sicuro, tutto controllato, tutto deciso per te. Non ci fidiamo di te neanche a respirare da solo.

Ecco perché Vector e Hashtable erano sincronizzati per default. Non era una scelta tecnica, era una dichiarazione filosofica: "Il multithreading è così pericoloso che lo rendiamo obbligatorio ovunque, anche quando non serve". Il fatto che questo rallentasse anche le applicazioni single-thread era considerato un prezzo accettabile per la sicurezza. I progettisti di Sun avevano una visione apocalittica del futuro: ogni applicazione sarebbe stata multi-thread, ogni oggetto sarebbe stato condiviso, ogni accesso concorrente sarebbe stato una potenziale catastrofe.

```java
Vector items = new Vector();
items.addElement("item1");
items.addElement(new Integer(42)); // Mix di tipi? Normale all'epoca
for (int i = 0; i < items.size(); i++) {
    Object item = items.elementAt(i); // Tutto è Object
    String str = (String) item; // Preghiera e cast
}
```

Questo codice incarnava perfettamente la filosofia Java 1.0: paternalismo tecnologico allo stato puro. Non potevi scegliere il tipo di sincronizzazione, non potevi evitare i cast, non potevi nemmeno fidarti che un elemento di una collezione fosse del tipo che pensavi. Java decideva per te, sempre.

E poi c'era Date. Madonna santa, la classe Date. Se devo nominare l'API più odiosa mai partorita dalla mente umana, Date di Java 1.0 vince a mani basse. Era come se l'avessero progettata apposta per farti bestemmiare in lingue che non sapevi neanche di conoscere:

```java
Date christmas = new Date();
christmas.setYear(2023 - 1900); // Perché -1900? Perché MAGIA!
christmas.setMonth(11); // Dicembre è 11, non 12. Logico, no?
christmas.setDate(25); // Ma il giorno è 1-based. Coerenza? Mai sentita.
```

Ogni volta che vedevo questo codice, una parte della mia anima moriva. Date era mutabile (quindi poteva essere modificata alle tue spalle), SimpleDateFormat non era thread-safe (quindi condividerlo tra thread era come giocare alla roulette russa), ed entrambi sembravano progettati da qualcuno che odiava profondamente sia il tempo che l'umanità.

Il garbage collector Serial di Java 1.0 seguiva la stessa logica del "papà sa meglio": "La gestione della memoria è troppo complicata per voi mortali, quindi la facciamo noi. Non importa se fermiamo tutto per secondi interi, almeno non avrete memory leak". Era la filosofia del "meglio paralizzato che morto", portata all'estremo del ridicolo.

Ma già con Java 1.2, iniziarono a emergere le prime crepe in questa muraglia paternalistica. Le Collection Framework introdussero ArrayList e HashMap non sincronizzati, affiancati da Collections.synchronizedList() per quando la sincronizzazione serviva davvero. Era un piccolo passo per il codice, ma un grande passo per l'umanità dei programmatori: per la prima volta, Java ammetteva che il programmatore potesse essere abbastanza intelligente da scegliere.

```java
List items = new ArrayList(); // Scelta: velocità
List safeItems = Collections.synchronizedList(new ArrayList()); // Scelta: sicurezza
```

Questa non era solo una questione di prestazioni. Era l'inizio di un nuovo contratto sociale tra linguaggio e programmatore: "Ti diamo gli strumenti, tu scegli come usarli". Il gruppo di sviluppo stava iniziando a capire che la flessibilità era più importante della protezione totale.

Il Parallel GC che arrivò con Java 1.2 rifletteva lo stesso cambio di mentalità. Invece di imporre una strategia unica di garbage collection, iniziarono a sperimentare con approcci diversi. Era l'ammissione implicita che il Serial GC non era la soluzione universale che avevano immaginato.

Con Java 1.4 e NIO, assistiamo al primo vero atto di fiducia verso il programmatore. L'I/O non bloccante era complesso come assemblare un mobile IKEA senza istruzioni, ostico come una conversazione con l'ex, pieno di insidie come un campo minato:

```java
Selector selector = Selector.open();
SocketChannel channel = SocketChannel.open();
channel.configureBlocking(false);
channel.register(selector, SelectionKey.OP_READ);
```

Questo codice era l'antitesi totale della filosofia Java 1.0. Era complesso, richiedeva comprensione profonda, poteva facilmente essere usato male. Ma i progettisti lo inclusero comunque, perché stavano iniziando a capire una cosa fondamentale: nascondere la complessità sotto il tappeto non la elimina, la sposta solo nel posto più scomodo possibile.

E poi arrivò la vera rivoluzione filosofica con Java 5. I generics non erano solo una funzionalità tecnica, erano una dichiarazione di guerra al paternalismo: "Ci fidiamo di voi abbastanza da darvi un sistema di tipi più sofisticato". Era l'ammissione che i programmatori potevano gestire la complessità aggiuntiva in cambio di maggiore sicurezza e espressività.

```java
List<String> items = new ArrayList<String>();
// Il programmatore dichiara l'intenzione, il compilatore la verifica
```

Il passaggio da cast runtime a controlli compile-time rappresentava un cambio filosofico più profondo di una crisi di mezza età: da "proteggiamo il programmatore nascondendo i problemi sotto il materasso" a "aiutiamo il programmatore a identificare i problemi prima che facciano danni". Era la nascita di una collaborazione vera tra linguaggio e sviluppatore, come Batman e Robin, ma senza i mutandoni.

Le annotazioni di Java 5 portarono questa filosofia ancora più avanti. Invece di nascondere metadati nel codice o in file esterni, li esponevano direttamente:

```java
@Override
public String toString() { return "Person"; }
```

Era un'ammissione che il programmatore non solo poteva gestire metadati espliciti, ma che questi potevano rendere il codice più chiaro e verificabile. Le annotazioni trasformarono Java da linguaggio che nascondeva l'intenzione a linguaggio che la celebrava.

Gli enum di Java 5 demolirono il modello "typesafe enum" che tutti usavamo, sostituendolo con una soluzione nativa. Ma la vera lezione non era tecnica: era che il linguaggio poteva e doveva imparare dalle convenzioni della comunità, codificandole invece di ignorarle.

Il periodo Java 6-7 fu di consolidamento, ma le poche novità mostravano una tendenza chiara come l'acqua di montagna. Il try-with-resources di Java 7 era l'esempio perfetto di come la filosofia fosse cambiata da "paternalismo tossico" a "collaborazione intelligente":

```java
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
    // Il compilatore si occupa della chiusura automatica
}
```

Non era paternalismo ("non ci fidiamo a lasciarti gestire le risorse perché sei un idiota") ma collaborazione ("ti diamo uno strumento che rende impossibile dimenticare di chiudere le risorse perché siamo tutti umani"). La differenza è sottile come un filo di ragno ma fondamentale come l'ossigeno: non toglieva controllo al programmatore, gli dava un modo migliore di esprimere l'intenzione.

Java 8 rappresentò la rottura definitiva con la filosofia originale. L'introduzione della programmazione funzionale non era solo un'aggiunta di funzionalità, era un'ammissione che il paradigma object-oriented puro non era sufficiente per tutti i problemi. Era Java che diceva: "Abbiamo sbagliato a pensare che tutto dovesse essere un oggetto".

```java
people.stream()
    .filter(person -> person.getAge() > 30)
    .map(person -> person.getName().toUpperCase())
    .collect(Collectors.toList());
```

Gli stream rappresentavano un cambio di paradigma da imperativo a dichiarativo, da "come fare" a "cosa fare". Ma più profondamente, rappresentavano la fiducia che i programmatori potessero gestire un modello mentale più astratto in cambio di codice più espressivo.

Optional fu ancora più rivoluzionario dal punto di vista filosofico, tipo la scoperta che la Terra non è piatta:

```java
public Optional<String> getCustomerCity(Long customerId) {
    return customerRepository.findById(customerId)
        .map(Customer::getAddress)
        .map(Address::getCity);
}
```

Era l'ammissione che nascondere la possibilità di valori null era stato un errore colossale, come nascondere le chiavi dell'auto a un adolescente. Invece di "proteggere" il programmatore dai null, Optional li rendeva espliciti e gestibili. Era un perfetto esempio della nuova filosofia: collaborazione trasparente invece di protezione opaca.

Le lambda di Java 8 completarono questa trasformazione meglio di un makeover televisivo. Permettere funzioni come cittadini di prima classe significava abbandonare completamente l'ortodossia object-oriented originale. Era Java che ammetteva: "I paradigmi sono strumenti, non religioni. E noi non siamo più fondamentalisti".

Nel frattempo, l'evoluzione dei garbage collector rifletteva lo stesso cambio di mentalità. Da un GC unico e universale ("una taglia va bene per tutti, come i cappelli da baseball"), si passò a un ecosistema di GC specializzati: G1 per bassa latenza, Parallel per velocità di elaborazione pura, CMS per reattività. Era l'ammissione che non esiste una soluzione perfetta per tutti i casi d'uso, come non esiste una scarpa perfetta per tutti i piedi.

Java 9 e il Project Jigsaw rappresentarono forse il tentativo più ambizioso (e coraggioso) di applicare la nuova filosofia. I moduli erano un sistema complesso come una centrale nucleare, potente come un reattore a fusione, che richiedeva comprensione profonda:

```java
module com.example.myapp {
    requires java.base;
    exports com.example.myapp.api;
}
```

Era Java che diceva: "Vi diamo un sistema di modularità di livello enterprise, anche se è complesso da imparare come il cinese mandarino e vi farà bestemmiare in ostrogoto". Il fatto che molti sviluppatori l'abbiano ignorato come un parente fastidioso non cambia la filosofia sottostante: meglio dare strumenti potenti che possono essere ignorati, che non darli affatto e lamentarsi dopo.

Con i moduli arrivarono anche gli strumenti per creare distribuzioni personalizzate. jlink permetteva di costruire runtime Java su misura, contenenti solo i moduli necessari:

```bash
jlink --module-path $JAVA_HOME/jmods:myapp.jar \
      --add-modules com.example.myapp \
      --output myapp-runtime
```

Era l'ammissione finale che Java monolitico non era sempre la risposta giusta. Meglio dare la possibilità di personalizzare che imporre una soluzione universale.

L'introduzione di var in Java 10 fu quasi simbolica. Era l'ammissione finale che la verbosità non era sinonimo di chiarezza:

```java
var complexMap = new HashMap<String, List<String>>();
```

Per un linguaggio nato con l'ossessione della dichiaratività esplicita, permettere l'inferenza di tipo era una rivoluzione. Era Java che finalmente diceva: "Ci fidiamo di voi abbastanza da lasciare che il compilatore deduca ciò che è ovvio".

Java 11 consolidò molte di queste idee, aggiungendo strumenti più moderni come HttpClient:

```java
HttpClient client = HttpClient.newHttpClient();
HttpResponse<String> response = client.send(
    HttpRequest.newBuilder().uri(URI.create("https://api.example.com")).build(),
    HttpResponse.BodyHandlers.ofString()
);
```

Non era solo un'API migliore, era l'ammissione che le API originali di Java erano inadeguate per il mondo moderno. Era Java che diceva: "Sbagliamo, impariamo, miglioriamo".

Le switch expression di Java 12-13 continuarono questa tendenza:

```java
String result = switch (day) {
    case MONDAY, FRIDAY -> "Giorno intenso";
    case TUESDAY -> "Giorno tranquillo";
    default -> "Giorno normale";
};
```

Più concise, meno soggette a errori (niente break dimenticati), più funzionali. Era l'evoluzione naturale del pensiero "collaboriamo con il programmatore invece di costringerlo a verbosità inutile".

I text block di Java 13 eliminarono anni di frustrazione con le stringhe multi-riga:

```java
String json = """
    {
      "name": "John",
      "age": 30
    }
    """;
```

JSON, SQL, HTML finalmente leggibili nel codice. Era l'ammissione che la sintassi delle stringhe di Java 1.0 era inadeguata per il mondo moderno.

I record di Java 14 completarono un altro cerchio filosofico. Java era nato con l'idea che tutto dovesse essere un oggetto complesso con comportamenti. I record ammettevano che a volte i dati sono semplicemente dati:

```java
public record Person(String name, int age, String email) {}
```

Era l'abbandono del dogma "tutto deve avere metodi" in favore di un approccio più pragmatico: i dati sono importanti quanto i comportamenti, e meritano rappresentazioni dedicate.

Le sealed class di Java 17 rappresentarono un altro tipo di fiducia nel programmatore. Invece di nascondere le gerarchie di tipi, le rendevano esplicite e controllabili:

```java
public sealed abstract class Shape permits Circle, Rectangle {
    // Il programmatore dichiara esplicitamente tutte le implementazioni possibili
}
```

Era Java che diceva: "Vi diamo il controllo totale sulla vostra gerarchia di tipi, e confidiamo nel fatto che lo userete saggiamente".

Nel frattempo, la guerra dei garbage collector si intensificava. Shenandoah di Red Hat prometteva pause sub-millisecondo:

```bash
java -XX:+UseShenandoahGC MyApp
# Pause GC < 1ms, indipendentemente dalla dimensione dell'heap
```

Oracle rispose con ZGC, ancora più aggressivo:

```bash
java -XX:+UseZGC MyApp
# Pause < 10ms, heap fino a 16TB
```

Era la competizione a portare benefici: invece di un garbage collector unico imposto dall'alto, c'era scelta basata sulle necessità specifiche.

I virtual thread di Java 19 rappresentano forse l'esempio più perfetto della nuova filosofia Java, come la sintesi perfetta di una sinfonia. Invece di costringere i programmatori a scegliere tra semplicità (thread platform) e scalabilità (programmazione asincrona da mal di testa), offrono entrambe come un buffet all-you-can-eat:

```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    for (int i = 0; i < 10000; i++) {
        executor.submit(() -> {
            try {
                Thread.sleep(Duration.ofSeconds(1));
                // Codice sincrono che scala come asincrono, magia pura
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });
    }
}
```

È la sintesi perfetta di 30 anni di evoluzione: uno strumento potente che non sacrifica la semplicità, che collabora con il programmatore invece di sostituirsi a lui come un genitore invadente.

Il pattern matching moderno chiude il cerchio iniziato con i cast del terrore di Java 1.0:

```java
return switch (obj) {
    case String s -> "String of length " + s.length();
    case Integer i -> "Integer with value " + i;
    case null -> "null value";
    default -> "Unknown type";
};
```

Da cast manuali e madonne a pattern matching che non sbaglia mai. È la differenza tra "non ci fidiamo neanche a farti scegliere i calzini" e "ecco gli strumenti giusti, facci vedere cosa sai fare".

L'evoluzione degli strumenti di sviluppo riflette la stessa filosofia. Da javac spartano che dava errori criptici, siamo passati a IDE intelligenti che predicono l'intenzione del programmatore. Da JUnit con ereditarietà obbligatoria a framework basati su annotazioni che rispettano la struttura del tuo codice:

```java
// JUnit 3 - ereditarietà forzata
public class MyTest extends TestCase {
    public void testSomething() {
        assertEquals("expected", actual);
    }
}

// JUnit 4+ - annotazioni collaborative
public class MyTest {
    @Test
    public void testSomething() {
        assertEquals("expected", actual);
    }
}
```

Persino l'ecosistema più ampio riflette questo cambio. Maven standardizzò il processo di build ma lasciò flessibilità nella configurazione. Gradle andò oltre, rendendo il processo di build stesso programmabile. Spring Boot automatizzò la configurazione ma lasciò tutti i punti di estensione necessari:

```java
@RestController
public class HelloController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello World";
    }
}
```

Un'annotazione e hai un web server. Nel 2000 servivano 50 righe di XML e 3 file war.

I garbage collector moderni come ZGC e Shenandoah rappresentano l'apice di questa evoluzione: pause sub-millisecondo anche con heap multi-terabyte, senza richiedere cambiamenti al codice applicativo. È la collaborazione perfetta: la JVM si occupa di prestazioni estreme, il programmatore si concentra sulla logica di business.

Ma il futuro è già qui, e stavolta è vero (non come quando ce lo dicevano nel 2000). Le Foreign Function & Memory API, dopo anni di sviluppo come Project Panama e più preview di un film Marvel, sono diventate stabili con Java 22 nel marzo 2024. Non sono più preview, sono production-ready come un panettone a Natale:

```java
// Java 22+ - FFM API finalmente adulta
Linker linker = Linker.nativeLinker();
SymbolLookup stdlib = linker.defaultLookup();
MemorySegment strlenAddress = stdlib.find("strlen").orElseThrow();

FunctionDescriptor descriptor = FunctionDescriptor.of(
    ValueLayout.JAVA_LONG, 
    ValueLayout.ADDRESS
);
MethodHandle strlen = linker.downcallHandle(strlenAddress, descriptor);

try (Arena offHeap = Arena.ofConfined()) {
    MemorySegment str = offHeap.allocateUtf8String("Hello FFM!");
    long len = (long) strlen.invoke(str);
    System.out.println("Length: " + len);
}
```

È l'integrazione perfetta di sicurezza e potenza: accesso diretto al codice nativo, gestione automatica della memoria con Arena, prestazioni 4-5 volte superiori a JNI. È Java che finalmente dice: "Ti diamo il controllo totale, ma con tutti i guard rail necessari. Divertiti ma non farti male".

Java 24, uscito proprio questo marzo 2025, porta questa filosofia a livelli che sarebbero sembrati fantascienza nel 1995. Con i suoi 24 JEP (un record che nemmeno i Pearl Jam!), rappresenta il culmine di anni di evoluzione. I virtual thread finalmente non si bloccano più sui synchronized - il problema del "pinning" è stato risolto come si risolve un Cubo di Rubik: con pazienza, ingegno e parecchie bestemmie (probabilmente):

```java 
// Java 24 - virtual threads liberi finalmente!
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    for (int i = 0; i < 1000000; i++) {
        executor.submit(() -> {
            synchronized (sharedResource) {
                // Prima il thread platform si bloccava, ora è libero!
                doBlockingIO();
            }
        });
    }
}
```

La Stream Gatherers API è finalmente stabile, e puoi scrivere operazioni stream custom che prima richiedevano la laurea in contorsionismo mentale:

```java
// Java 24 - stream operations su misura
List<String> result = stream
    .gather(windowFixed(3)) // Finestre di 3 elementi
    .gather(scan(() -> 0, Integer::sum)) // Somma cumulativa
    .map(String::valueOf)
    .toList();
```

E poi ci sono i Compact Object Headers che riducono l'overhead di memoria da 12 a 8 byte per oggetto. Sembra poco, ma per applicazioni con milioni di oggetti è come passare da un SUV a una bicicletta in termini di consumo.

Il supporto per crittografia quantistica-resistente con ML-KEM e ML-DSA prepara Java per un futuro dove i computer quantistici renderanno obsoleta la crittografia attuale. È Java che anticipa problemi che ancora non abbiamo.

E Java 25, il prossimo LTS in arrivo a settembre 2025? Sarà a pochi mesi dal vero trentesimo compleanno (23 gennaio 2026 - data che per me ha un significato speciale oltre a Java), e promette di essere una celebrazione degna. Il pattern matching finalmente funzionerà con i tipi primitivi:

```java
// Java 25 - pattern matching con primitivi
static void test(Object obj) {
    switch (obj) {
        case int i when i > 0 -> System.out.println("Positive int: " + i);
        case double d -> System.out.println("Double: " + d);
        case String s -> System.out.println("String: " + s);
        default -> System.out.println("Something else");
    }
}
```

Le module import declarations semplificheranno la gestione delle dipendenze:

```java
// Java 25 - import di moduli completi
import module java.base;
import module java.sql;
// Tutto il contenuto del modulo disponibile
```

I file sorgente semplificati permetteranno finalmente di scrivere script Java senza classi (finalmente Java-Script *done right*):

```java
// Java 25 - script senza classi
void main() {
    System.out.println("Hello Java 30th anniversary!");
}
```

È Java che ammette: "Non tutto deve essere enterprise-grade. A volte serve solo semplicità".

E all'orizzonte c'è Project Valhalla con i value types, che promettono di rivoluzionare ancora una volta le prestazioni:

```java
// Project Valhalla - futuro
public value class Point {
    private final int x, y;
    
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

// Array di value types - nessun overhead di oggetti
Point[] points = new Point[1000000]; // Packed in memoria, prestazioni native
```

Sarà l'ultimo tassello: oggetti senza identità ma con prestazioni estreme, array densi come in C ma con la sicurezza di Java.

Quello che mi colpisce di più guardando questo percorso dal 1996 al 2025 è quanto sia stata inconsapevole per molto tempo questa evoluzione. I progettisti di Java non si sono svegliati una mattina decidendo di cambiare filosofia. È stato un processo graduale, guidato dai riscontri della comunità, dai limiti dei paradigmi esistenti, dalle necessità del mondo reale.

Ogni funzionalità aggiunta, ogni paradigma introdotto, ogni strumento migliorato ha seguito lo stesso modello: identificare dove la protezione paternalistica limitava più di quanto aiutasse, e sostituirla con strumenti collaborativi più potenti. Da Vector sincronizzato ad ArrayList con scelta di sincronizzazione. Da cast ciechi a generics verificati. Da cicli imperativi a stream dichiarativi. Da thread costosi a virtual thread scalabili. Da JNI pericolosa a FFM API sicura.

Java 2025 è un linguaggio che si fida del programmatore. Non perfettamente, non sempre, ma infinitamente di più del Java 1996. È un linguaggio che dice: "Ti diamo strumenti potenti, tu decidi come usarli". È un linguaggio che preferisce dare scelte anche complesse piuttosto che imporre semplificazioni artificiali.

La lezione più grande di questi 30 anni non è tecnica, è filosofica: i linguaggi migliori non sono quelli che proteggono i programmatori dai loro errori, ma quelli che li aiutano a non commetterli. Non sono quelli che nascondono la complessità, ma quelli che la rendono gestibile. Non sono quelli che impongono paradigmi, ma quelli che offrono gli strumenti giusti per ogni problema.

Java ha imparato questa lezione lentamente, a volte dolorosamente, ma l'ha imparata. E continua a impararla. Ogni nuova versione è un passo ulteriore verso un linguaggio che non ti tratta come un bambino pericoloso, ma come un professionista capace. È stata una lunga strada da Vector a virtual thread, da Date a LocalDate, da JNI a FFM API, ma ne è valsa la pena.

Guardando questa evoluzione trentennale, mi viene in mente una riflessione che sintetizza perfettamente quello che Java è diventato:

> citation "kLeZ"
> Java dovrebbe rendere l'impossibile possibile, il difficile fattibile, il fattibile semplice e il semplice ovvio.

Ed è esattamente quello che è successo: dai cast impossibili da verificare ai generics sicuri, dal multithreading difficile ai virtual thread scalabili, dalla gestione delle date faticosa a LocalDate intuitivo, dalla verbosità ovvia alla concisione moderna.

E la cosa più bella? La storia non è finita. Java 25 sarà LTS, ma Java 26, 27, 28 continueranno a evolvere. Project Valhalla arriverà, nuovi paradigmi emergeranno, nuovi problemi saranno risolti. Perché alla fine, Java non è solo un linguaggio di programmazione: è un ecosistema che cresce, impara e si adatta. È un linguaggio che ha 30 anni ma pensa ancora al futuro.
