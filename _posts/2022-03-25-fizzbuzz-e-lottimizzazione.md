---
title: "FizzBuzz e l'ottimizzazione"
tags: 
date: 2022-03-25 19:57:13+00:00
---

Oggi vorrei parlarvi di un algoritmo.

Di norma un algoritmo talmente semplice da essere usato durante i colloqui per la valutazione della capacità _minima_ di scrivere e leggere codice che comprenda il minimo indispensabile di logica, matematica e pensiero critico.

L'algoritmo consiste nell'implementare una funzione che dati i numeri da 1 a 100 faccia quanto segue:

- stampi la stringa "_Fizz_" quando il numero è un multiplo di 3
- stampi la stringa "_Buzz_" quando il numero è un multiplo di 5
- stampi la stringa "_FizzBuzz_" quando il numero è un multiplo di 3 o 5
- stampi il numero quando non è un multiplo di 3 né di 5

Semplice semplice. Ma allora perché ne parlo?

{% include more.html %}

Ne parlo perché da un occhio esperto permette di valutare la lentezza _matematica_ di un operatore in particolare, il modulo.

E quindi mi permette di parlare di ottimizzazioni di basso livello.

## L'implementazione scolastica

A livello di studio, si usa il modulo per questo tipo di problema. Il listato che segue è l'implementazione completa.

```java
for (int i = 1; i <= 100; i++) {
	if (i % 15 == 0) {
		System.out.println("FizzBuzz");
	} else if (i % 5 == 0) {
		System.out.println("Buzz");
	} else if (i % 3 == 0) {
		System.out.println("Fizz");
	} else {
		System.out.println(i);
	}
}
```

Questa è l'implementazione, banale un ciclo e 4 if con delle operazioni di modulo. Ma il modulo è un'operazione lenta.

Come descritto [qui](https://cs.stackexchange.com/questions/12931/complexity-of-taking-mod) e [qui](https://en.wikipedia.org/wiki/Computational_complexity_of_mathematical_operations), siamo di fronte a una complessità di `O(M(n))` che è veramente parecchio. Mi sono chiesto se fosse possibile ottimizzare.

ho messo quindi in piedi un programma, che ho raffinato in varie iterazioni, che potete vedere a questo [GIST](https://gist.github.com/kLeZ/c1b3b387521747bd732c32a5834146b7).

Di seguito vi commento la versione finale.

## Le righe di boilerplate

C'è molto boilerplate in questo codice, materialmente perché volevo quantificare le differenze di approccio in dei benchmark, a partire dalla stessa jvm.

Di conseguenza ho costruito dei runnable con i quattro metodi che ho implementato per calcolare il fizzbuzz e intorno c'è tutta un'impalcatura di misurazione delle prestazioni di elaborazione dell'algoritmo.

Ho fatto tutto *in casa* perché volevo azzerare le dipendenze.

Di fatto questo codice gira senza dipendenze sulla jvm, è autocontenuto, proprio per permettere anche ad altri di farlo girare facilmente, scambiando solo il file col codice.

Qui spiego, pezzo per pezzo tutto il codice, partendo dalle costanti in cima.


## Le costanti

Questa costante rappresenta lo "standard" output, per avere comunque l'output degli algoritmi evitando però le scritture dirette su console, che risultano lente.

L'ho fatto per velocizzare le computazioni, visto che alla fine questo codice verrà eseguito 1M di volte.

```java
	public static final StringBuilder OUT = new StringBuilder();
```

Costanti che controllano cosa e quando stampare sull'output.

```java
	public static final boolean PRINT_AT_LAST = true;
	public static final boolean PRINT_FIZZ_BUZZ = false;
```

Le famigerate costanti FizzBuzz, solo perché a un certo punto sono stato curioso di cambiare questi valori in modo coerente per sperimentare come si sarebbe comportato l'algoritmo. Del resto il compilatore queste costanti le riscrive *inline* quindi è una fatica in più che ho fatto, ma solo per amore della scienza e della sperimentazione!

```java
	public static final int FIZZ = 3;
	public static final int BUZZ = 5;
	public static final int FIZZ_BUZZ = 15;
```

Queste due costanti rappresentano il numero di iterazioni per l'algoritmo FizzBuzz (cioè i numeri da valutare per stampare Fizz, Buzz oppure FizzBuzz).

```java
	public static final int MIN_FIZZ_BUZZ = 1;
	public static final int MAX_FIZZ_BUZZ = 100;
```

Poco da dire. Queste sono le costanti che stampo "*a schermo*".

```java
	public static final String FIZZ_STRING = "Fizz";
	public static final String BUZZ_STRING = "Buzz";
	public static final String FIZZ_BUZZ_STRING = "FizzBuzz";
```

Questa costante invece rappresenta il numero di esecuzioni per ogni algoritmo.

Si tratta di un numero molto alto proprio perché vogliamo tagliare i picchi statistici e vogliamo oltrepassare anche il tema dell'ottimizzazione del bytecode effettuata dalla JVM sul nostro codice. In statistica e nel benchmarking, più volte si effettua il test di esecuzione con registrazione dei tempi e più ci si avvicina alle reali prestazioni dell'algoritmo. Un milione di iterazioni mi sono sembrate "*abbastanza*".

```java
	public static final int ITERATIONS = 1_000_000;
```

## Il main

Stampo la versione.

```java
		System.out.println(version());
```

Salvo l'istante in cui il programma "parte".

```java
		final long startProgram = System.nanoTime();
```

Creo una mappa con tutti e quattro i metodi. Questa mappa verrà usata nelle 1M di iterazioni.

Mi creo una mappa per avere vita facile nell'iterazione, è una tecnica che ho spesso usato e che mi piace parecchio, ovviamente non è l'unica tecnica per facilitare il lavoro di iterazione dinamica, ma a me piace e funziona bene.

```java
		final Map<Runnable, List<Long>> waysTimes = new HashMap<>();
		waysTimes.put(Scratch::way1, new ArrayList<>());
		waysTimes.put(Scratch::way2, new ArrayList<>());
		waysTimes.put(Scratch::way3, new ArrayList<>());
		waysTimes.put(() -> Scratch.way4(MIN_FIZZ_BUZZ, MAX_FIZZ_BUZZ), new ArrayList<>());
```

## L'iterazione

L'iterazione funziona così: per un milione di volte, per ogni implementazione, salva l'istante di partenza, esegui l'algoritmo, salva in una lista la differenza tra istanti di tempo, cioè il tempo trascorso *durante* il `.run()`.

Alla fine dell'esecuzione di ognuna delle implementazioni, se non è il caso di stampare l'output di FizzBuzz (praticamente solo per motivi di debug)

```java
		for (int i = 0; i < ITERATIONS; i++) {
			for (Map.Entry<Runnable, List<Long>> entry : waysTimes.entrySet()) {
				final long start;
				start = System.nanoTime();
				entry.getKey().run();
				entry.getValue().add(System.nanoTime() - start);
			}
			if (!PRINT_FIZZ_BUZZ)
				OUT.delete(0, OUT.length());
		}
```

## Il calcolo dei risultati del benchmark

Di seguito le istruzioni che collezionano le statistiche dei tempi di esecuzione delle varie esecuzioni degli algoritmi.

Quello che faccio materialmente è collezionare degli oggetti `LongSummaryStatistics`, uno per ogni algoritmo eseguito.

Questo è possibile perché per ogni iterazione vado a salvare la durata dell'esecuzione in una lista per ogni implementazione (`entry.getValue().add(System.nanoTime() - start)`).

```java
		final List<LongSummaryStatistics> statistics = waysTimes.values()
				.stream()
				.map(l -> l.stream().collect(LongSummaryStatistics::new, LongSummaryStatistics::accept, LongSummaryStatistics::combine))
				.collect(Collectors.toList());
```

Qui il calcolo del minimo dei tempi mediani di tutte le statistiche. Questa informazione indica quale è la durata minima tra tutti i tempi medi (quindi all'interno della media ponderata). Praticamente l'esecuzione più performante.

```java
		final double minOfAvgs = statistics.stream()
				.mapToDouble(LongSummaryStatistics::getAverage)
				.min()
				.orElse(0D);
```

A questo punto mi vado a cercare quale implementazione ha totalizzato il risultato migliore, cioè il minimo dei mediani calcolato prima.

```java
		String minOfAvgsName = "Ukn";
		for (int k = 0; k < statistics.size(); k++) {
			final LongSummaryStatistics statistic = statistics.get(k);
			final double average = statistic.getAverage();
			if (average == minOfAvgs) {
				minOfAvgsName = String.format("Way%d", k + 1);
				break;
			}
		}
		println(System.lineSeparator());
```

Infine, stampo tutti i tempi e le statistiche.

```java
		for (int k = 0; k < statistics.size(); k++) {
			final LongSummaryStatistics statistic = statistics.get(k);
			final double average = statistic.getAverage();
			printf("Way%d had an avg of %f ns%n", k + 1, average);
		}
		printf("Min of avgs is %f ns and belongs to %s%n", minOfAvgs, minOfAvgsName);
		printf("Program ran for %f ms%n", (System.nanoTime() - startProgram) / 1000_000D);
		flush();
```

## Le funzioni di appoggio (che sono tante)

Queste funzioni sono solo di appoggio all'esecuzione, ma sono fondamentali per avere un minimo di leggibilità nel codice principale.

```java
	private static void flush() {
		if (PRINT_AT_LAST)
			System.out.println(OUT);
		OUT.delete(0, OUT.length());
	}

	private static void printf(final String format, final Object... args) {
		if (PRINT_AT_LAST)
			OUT.append(String.format(format, args));
		else
			System.out.printf(format, args);
	}

	private static void print(final String s) {
		if (PRINT_AT_LAST)
			OUT.append(s);
		else
			System.out.print(s);
	}

	private static void println(final int i) {
		if (PRINT_AT_LAST)
			OUT.append(i)
					.append(System.lineSeparator());
		else
			System.out.println(i);
	}

	private static void println(final String s) {
		if (PRINT_AT_LAST)
			OUT.append(s)
					.append(System.lineSeparator());
		else
			System.out.println(s);
	}

	private static void println() {
		if (PRINT_AT_LAST)
			OUT.append(System.lineSeparator());
		else
			System.out.println();
	}
```

## Gli algoritmi

Gli algoritmi devono seguire la logica dell'algoritmo FizzBuzz.

L'algoritmo specifica che, dato un insieme di numeri, per ogni numero se questo è multiplo di 3 stampa **Fizz**, se invece è multiplo di 5 stampa **Buzz**, se è multiplo di 3 o 5 (quindi se è multiplo del minimo comune multiplo di 3 e 5 che è 15) stampo **FizzBuzz**, altrimenti stampa il numero.

## Prima implementazione

La prima implementazione è quella *scolastica*.

```java
	private static void way1() {
		for (int i = MIN_FIZZ_BUZZ; i <= MAX_FIZZ_BUZZ; i++) {
			if (i % FIZZ_BUZZ == 0) {
				println(FIZZ_BUZZ_STRING);
			} else if (i % BUZZ == 0) {
				println(BUZZ_STRING);
			} else if (i % FIZZ == 0) {
				println(FIZZ_STRING);
			} else {
				println(i);
			}
		}
	}
```

## Seconda implementazione

Nella seconda implementazione faccio una considerazione: è possibile escludere il terzo ramo del condizionale?

Si, semplicemente stampando Fizz per multipli di 3 e Buzz per multipli di 5 senza andare a capo.

Di conseguenza per multipli di 3 o 5 (quindi del m.c.m. 15), alla fine ho stampato sia fizz che buzz.

Per andare a capo, oppure per stampare il numero e completare il requisito mi appoggio a una variabile booleana per sapere se ho stampato qualcosa. Se questo è successo semplicemente vado a capo, altrimenti stampo il numero. Stesso risultato, ma con un ramo condizionale in meno e quindi plausibilmente con un calcolo in meno.

```java
	private static void way2() {
		for (int i = MIN_FIZZ_BUZZ; i <= MAX_FIZZ_BUZZ; i++) {
			boolean status = false;
			if (i % FIZZ == 0) {
				print(FIZZ_STRING);
				status = true;
			}
			if (i % BUZZ == 0) {
				print(BUZZ_STRING);
				status = true;
			}
			if (status) {
				println();
			} else {
				println(i);
			}
		}
	}
```

## Terza implementazione

In questa implementazione mi faccio venire ancora un altro dubbio. *E se l'operazione di modulo fosse più lenta di un incremento?*

Del resto i calcolatori sono ottimizzati per calcolare addizioni, utilizzando delle istruzioni macchina come `ADD RAX, RBX` dove si aggiunge il valore contenuto nel registro `RBX` al numero (contatore) presente in `RAX`.

Il modulo è un'operazione di divisione che ritorna il resto intero della divisione, che è particolarmente onerosa per i calcolatori, anche più moderni. Ma questa è un'altra storia che parla di Assembly e architetture dei calcolatori (Grazie Torlone!).

Di conseguenza riscrivo l'algoritmo per evitare l'uso dell'operazione di modulo, usando piuttosto dei contatori che posso *resettare* una volta arrivati al risultato.

Quindi l'algoritmo di fatto recita questo:

Per ogni iterazione incremento i contatori `temp3` e `temp5`, a prescindere.

Poi controllo se `temp3` è uguale a 3: se lo è stampo **Fizz** e resetto il contatore a 0.

Poi controllo se `temp5` è uguale a 5: se lo è stampo **Buzz** e resetto il contatore a 0.

Il resto del meccanismo è lo stesso della seconda implementazione, uso un booleano per capire se devo andare a capo o stampare il numero corrente. In questo modo gestisco anche il caso **FizzBuzz**.

```java
	private static void way3() {
		int temp3 = 0, temp5 = 0;
		for (int i = MIN_FIZZ_BUZZ; i <= MAX_FIZZ_BUZZ; i++) {
			boolean status = false;
			temp3++;
			temp5++;
			if (temp3 == FIZZ) {
				print(FIZZ_STRING);
				status = true;
				temp3 = 0;
			}
			if (temp5 == BUZZ) {
				print(BUZZ_STRING);
				status = true;
				temp5 = 0;
			}
			if (status) {
				println();
			} else {
				println(i);
			}
		}
	}
```

### Quarta implementazione

Questa è un bonus. A questo punto ho messo in dubbio anche le prestazioni del ciclo for.

Di conseguenza ho pensato di implementare una funzione ricorsiva escludendo l'iterazione per capire se parte del problema di prestazioni potesse essere dovuta al ciclo.

```java
	private static void way4(final int start, final int end) {
		if (start <= end) {
			boolean mod3 = (start % FIZZ) == 0;
			boolean mod5 = (start % BUZZ) == 0;
			if (mod3 && mod5) {
				println(FIZZ_BUZZ_STRING);
			} else if (mod5) {
				println(BUZZ_STRING);
			} else if (mod3) {
				println(FIZZ_STRING);
			} else {
				println(start);
			}
			way4(start + 1, end);
		}
	}
```

## I risultati

Durante i miei test questo è quello che ho totalizzato sulla mia attuale macchina.

```
Red Hat, Inc. OpenJDK 64-Bit Server VM 1.8.0_282 25.282-b08 52.0

Way1 had an avg of 2836,285100 ns
Way2 had an avg of 2899,041900 ns
Way3 had an avg of 2668,671600 ns
Way4 had an avg of 3179,854900 ns
Min of avgs is 2668,671600 ns and belongs to Way3

Program ran for 12715,462100 ms
```

Il computer utilizzato ha queste specifiche:

```
Intel(R) Core(TM) i7-6500U CPU @ 2.50GHz

Velocità di base:   2,59 GHz
Processori fisici:  1
Cores:              2
Processori logici:  4
Virtualizzazione:   Disabilitato
Supporto Hyper-V:   Sì
Cache L1:           128 KB
Cache L2:           512 KB
Cache L3:           4,0 MB
```

Quindi in conclusione questo percorso mi ha permesso di comprendere che l'operazione di modulo è effettivamente **lenta**.

E oltretutto ho sperimentato che la ricorsione è più onerosa (almeno in Java) dell'iterazione.
