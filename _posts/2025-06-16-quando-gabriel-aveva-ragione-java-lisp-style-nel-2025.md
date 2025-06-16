---
title: "Quando Gabriel Aveva Ragione: Java Lisp-Style nel 2025"
tags:
- linguaggi
- saggi brevi
- java
- lisp
date: 2025-06-16 15:49:11+02:00
---

Oggi parlo di evoluzione dei linguaggi di programmazione, tema a me caro, chi mi conosce di persona sa quanto mi diverta seguire l'evoluzione tecnica degli strumenti che uso quotidianamente. L'occasione me l'ha data la rilettura di un pezzo di Richard Gabriel del 2003, ["The Art of Lisp & Writing"](https://www.dreamsongs.com/ArtOfLisp.html), che inizialmente avevo catalogato come "ennesima difesa d'ufficio di Lisp da parte di un fan sfegatato". Poi ho scoperto un dettaglio che cambia tutto: l'articolo è stato scritto come introduzione al libro "Successful Lisp" di David Lamkins nel 2003.

{% include more.html %}

Improvvisamente tutto ha senso. Gabriel non stava confrontando Lisp moderno con Java moderno, stava confrontando Lisp del 2003 con Java 1.4 del 2003. E da quella prospettiva, capiamoci, Gabriel aveva sostanzialmente ragione su tutto. Java 1.4 era effettivamente rigido, verboso, e richiedeva pianificazione anticipata di tipo e strutture. L'idea di sviluppo esplorativo con Java 1.4 era francamente masochistica.

La cosa interessante è che ora, 22 anni dopo, possiamo usare Gabriel come una specie di "specifica dei requisiti" per vedere quanto Java si sia evoluto. Ogni critica che muoveva a Java nel 2003 è diventata, senza volerlo, un test case per misurare i progressi del linguaggio. E i risultati, devo dire, sono sorprendentemente positivi.

## La Profezia Auto-Realizzante di Gabriel

Gabriel nel 2003 descriveva Lisp come un "medium" per l'esplorazione computazionale, in contrasto con Java come "linguaggio" per descrivere programmi finiti. La sua argomentazione centrale era che per fare sviluppo esplorativo servono strumenti che permettano cambiamenti rapidi e frequenti senza costringere a "pinnare decisioni troppo presto".

In pratica Gabriel stava descrivendo quella che oggi chiamiamo metodologia REPL-driven development: iniziare con un'idea minima, testarla immediatamente, scoprire nuovi requisiti, evolvere gradualmente mantenendo sempre il sistema funzionante. Nel 2003 questa metodologia era effettivamente molto più naturale in Lisp che in Java.

Il punto è che Gabriel non stava semplicemente difendendo Lisp, stava identificando caratteristiche essenziali per lo sviluppo moderno. E questi requisiti sono diventati, nei 20 anni successivi, driver di evoluzione per praticamente tutti i linguaggi mainstream, Java incluso.

Proviamo a vedere cosa succede quando applico la metodologia "Gabriel style" con Java moderno. Partiamo da un esempio che nel 2003 sarebbe stato impensabile e oggi è routine:

```java
// Inizio esplorativo - accetto qualsiasi cosa e vedo cosa succede
public Object process(Object input) {
    System.out.println("Processing: " + input);
    return input;
}

// Scopro che mi servono comportamenti specifici, evolvo gradualmente
public Object process(Object input) {
    return switch (input) {
        case String s -> s.toUpperCase();
        case Number n -> n.doubleValue() * 2;
        case List<?> list -> list.size();
        default -> "Unknown: " + input;
    };
}
```

Questo non è più Java 1.4. È Java 21 con pattern matching, type inference, e una flessibilità che nel 2003 Gabriel poteva solo sognare per linguaggi staticamente tipizzati.

## La Metodologia REPL Applicata a Java

Una delle critiche principali di Gabriel era che Java costringeva a definire tutto upfront - tipi, interfacce, gerarchie - prima di poter testare qualsiasi funzionalità. Nel 2003 era vero. Oggi Java ha JShell, un REPL completo che permette sviluppo esplorativo identico a quello che Gabriel descriveva per Lisp.

Il workflow che propongo è questo: iniziare con JShell per esplorare l'idea, poi migrare gradualmente verso codice strutturato quando i requisiti si stabilizzano. È esattamente la metodologia "flow + revision" che Gabriel descriveva, ma applicata a un linguaggio con type safety.

```java
// In JShell - esplorazione libera
var data = List.of("hello", 42, List.of(1, 2, 3));
data.stream().map(x -> process(x)).forEach(System.out::println);

// Scopro pattern interessanti, cristallizo in codice
public class DataProcessor {
    public <T> Object process(T input) {
        return switch (input) {
            case String s -> processText(s);
            case Number n -> processNumber(n);
            case List<?> l -> processList(l);
            default -> processGeneric(input);
        };
    }
}
```

Il bello è che posso mantenere la flessibilità di Lisp (accetto qualsiasi tipo, scopro comportamenti a runtime) con la sicurezza di Java (se sbaglio qualcosa me lo dice il compilatore, non l'utente finale).

## Metaprogrammazione Controllata

Gabriel nel 2003 citava come vantaggio di Lisp la possibilità di modificare classi e comportamenti a runtime. Java 1.4 non permetteva nulla del genere. Java moderno, diciamo, ha trovato un compromesso elegante attraverso method handles, lambda expressions, e dependency injection.

Invece di modificare classi esistenti (che può creare problemi di manutenibilità), Java moderno permette composizione dinamica di comportamenti:

```java
// Sistema configurabile a runtime - equivalente alla flessibilità Lisp
Map<String, Function<Object, String>> processors = new HashMap<>();

// Registro comportamenti dinamicamente
public void configureProcessor(String name, String expression) {
    Function<Object, String> processor = switch (expression) {
        case "toString" -> Object::toString;
        case "describe" -> obj -> obj.getClass().getSimpleName() + ": " + obj;
        case "count" -> obj -> "Length: " + obj.toString().length();
        default -> obj -> "Unknown processor for " + obj;
    };
    processors.put(name, processor);
}

// Uso esattamente come farei in Lisp
public String process(Object data, String processorName) {
    return processors.getOrDefault(processorName, Object::toString).apply(data);
}
```

Non è identico alla metaprogrammazione Lisp, ma per il 90% dei casi pratici è equivalente. E ha il vantaggio che quando qualcuno modifica il comportamento di un processor, lo fa esplicitamente e tracciabilmente.

## Il Principio di Postel Applicato

Gabriel citava il principio di Postel ("liberal in what you accept, conservative in what you send") come esempio di flessibilità necessaria. Java 1.4 era rigidamente conservativo in tutto. Java moderno permette di applicare questo principio elegantemente:

```java
// Liberale nell'accettare input
public Result processRequest(Object request) {
    try {
        return switch (request) {
            case Map<?, ?> map -> processMap(map);
            case String json -> processJson(json);
            case byte[] bytes -> processBytes(bytes);
            default -> processGeneric(request);
        };
    } catch (Exception e) {
        return Result.error("Could not process: " + e.getMessage());
    }
}

// Conservativo nell'output
public record Result(boolean success, String data, String error) {
    public static Result ok(String data) { return new Result(true, data, null); }
    public static Result error(String error) { return new Result(false, null, error); }
}
```

Questo codice è "robusto" esattamente nel senso che Gabriel intendeva: accetta praticamente qualsiasi input sensato, gestisce gracefully situazioni impreviste, ma mantiene un contratto di output chiaro e type-safe.

## I Limiti Rimangono (E Va Bene Così)

Capiamoci, non sto dicendo che Java 2025 sia diventato Lisp. Ci sono ancora differenze fondamentali. Java non ha homoiconicità (codice come dati), la metaprogrammazione è più limitata, e il sistema di tipi, per quanto flessibile, rimane più rigido di quello di Lisp.

Ma Gabriel nel 2003 non stava criticando questi aspetti teorici. Stava criticando l'impossibilità pratica di fare sviluppo esplorativo con Java. E questa impossibilità, purtroppo per i fan di Lisp, non esiste più.

Al di là di questo, molte delle "limitazioni" che Gabriel attribuiva alla tipizzazione statica si sono rivelate, con il senno di poi, vantaggi nascosti. La possibilità di refactoring automatico, l'IDE support, la documentazione vivente che rappresenta il sistema di tipi - queste sono capacità che Lisp può invidiare a Java.

## L'Evoluzione Convergente

La cosa più interessante è che negli ultimi 20 anni abbiamo assistito a una convergenza evolutiva impressionante. I linguaggi dinamici hanno aggiunto type hints e static analysis (Python, JavaScript), mentre i linguaggi statici hanno aggiunto type inference e flessibilità runtime (Java, C#, Rust).

Il risultato è che oggi la scelta tra linguaggi è meno una questione di capacità fondamentali e più una questione di trade-off specifici e preferenze di team. Posso fare sviluppo esplorativo tanto in Java quanto in Lisp, ma con compromessi diversi tra safety e flessibilità.

Gabriel aveva ragione quando diceva che la programmazione è un'arte che richiede strumenti flessibili. Ma si sbagliava (comprensibilmente, dato il contesto del 2003) quando pensava che questa flessibilità fosse monopolio dei linguaggi dinamici.

Oggi possiamo dire che l'intuizione di Gabriel era corretta ma la sua implementazione era limitata dagli strumenti disponibili nel 2003. La buona notizia è che i suoi "requisiti" sono diventati standard di fatto per praticamente tutti i linguaggi moderni.

Non smentisco che Lisp rimanga un linguaggio affascinante con capacità uniche, né tanto meno voglio negare che per certi domini possa essere ancora la scelta migliore. Però, ovvio che c'era un però, l'epoca in cui la scelta del linguaggio determinava se potevi fare o meno sviluppo esplorativo è definitivamente finita.

E forse è proprio questo il messaggio più importante: che l'arte della programmazione, come diceva Gabriel, risiede nel programmatore più che nello strumento. Oggi abbiamo strumenti così potenti e flessibili che la differenza la fa davvero l'abilità del musicista, non la marca del violino.
