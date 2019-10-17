---
title: "PyTorch, la promessa del deep learning?"
tags: 
date: 2019-10-17 10:42:30+02:00
---

Recentemente mi sono appassionato al *Machine Learning*.

Per chi non sapesse cos'è, il *machine learning* è una tecnologia (un insieme di tecnologie, in realtà) che permette calcoli piuttosto complessi in modo relativamente semplice e, cosa estremamente più importante, che può **imparare** dai dati che gli vengono somministrati.

Questo permette di effettuare calcoli complessi sempre più precisi fino a un tasso di fallimento che rasenta lo zero, un fattore necessario per mansioni complicate e critiche come il riconoscimento delle semantico immagini e l'elaborazione statistica.

{% include more.html %}

## Lo standard *de facto*

Nel settore c'è già una specie di standard, una tecnologia che è consuetudine imparare a usare se si vuole sviluppare questo tipo di software. Parlo di una libreria sviluppata da **Google**, che si chiama [TensorFlow](https://www.tensorflow.org/).

TensorFlow è una ottima libreria, potente e flessibile che permette di sviluppare delle ottime reti neurali. Ma, c'è un ma.

## La competizione si fa dura

Si compete sempre molto nella Silicon Valley, e le grandi aziende sono maestre della competizione tecnologica.

Facebook, che tecnologicamente non è da meno di Google in quanto a ingegneri, ha deciso di buttarsi nella mischia con qualcosa di simile al quasi monopolista TensorFlow. La loro creazione si chiama [PyTorch](https://pytorch.org/).

PyTorch si presenta più come un *framework*, meno come una libreria, a differenza di TesorFlow. Questo significa che è più comodo e relativamente più semplice da utilizzare, perdendo però un minimo di flessibilità.

## Il guadagno della dinamicità

Questa flessibilità apparentemente persa è guadagnata nuovamente e con gli interessi grazie alla possibilità di PyTorch di gestire i nodi del grafo in maniera dinamica, utilizzando un metodo chiamato *auto-differenziazione in modalità inversa*.

Questo guadagno è ancora più utile quando si tratta di effettuare il debugging della rete neurale, reso semplice e comodo dai soliti strumenti utilizzati per gli altri programmi python.

Un ulteriore guadagno portato da PyTorch è la parallelizzazione dei dati praticamente automatica, che permette di utilizzare GPU multiple con praticamente nessuno sforzo.

## Il miglior python a oggetti che un data scientist possa desiderare

PyTorch somiglia molto a un qualsiasi framework python ben strutturato, e soprattutto è organizzato ad oggetti.

In sostanza, PyTorch promette piuttosto bene essendo molto integrato sia con la filosofia del linguaggio che con i paradigmi funzionale e a oggetti.
