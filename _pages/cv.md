---
layout: profile-page
title: Alessandro Accardo
permalink: /cv/
left_image: /assets/cv-photo.jpeg
right_content: >-
    ## Informazioni personali
    
    Nato a Civitavecchia (RM), il 7 aprile 1987. Residente a Civitavecchia (RM).
      
      
    **Livello di studio**: Diploma Liceo Scientifico Tecnologico presso ITIS G. Marconi, Civitavecchia, 00053, Roma (2001-2006)
    
    
    Attualmente ricopro i ruoli di Senior Developer, Team Leader, Solutions Architect presso [Key 2 Business](http://www.key2.it/).
    
    
    #### [Contattami](/contatti)
    
    
---

## Carriera

{% capture card14 %}
Sviluppo di due microservizi necessari per la presentazione di dati fluidi provenienti da ETL verso una interfaccia di gestione e monitoraggio basata su Angular 7.

Uno dei microservizi è un /BFF/ che espone delle API specifiche e adatte al frontend che serve, il quale è a sua volta un /micro-frontend/.

L'altro servizio è un /data service/ che compie relativamente poche operazioni di business oltre al recupero dei dati, ma che pone la sua complessità nell'utilizzo di un virtualizzatore di database /embedded/ che permette l'aggregazione di molteplici sorgenti dati eterogenee, distribuite e fluide.  
Il recupero dei dati viene effettuato tenendo conto della fluidità dei dati, generando metadati utili al frontend per la costruzione dinamica delle interfacce di visualizzazione e creando delle query e dei mapping dinamici tenendo conto dei metadati generati dinamicamente.
{% endcapture %}
{% include card.html title="Senior Developer" subtitle="Key 2 Business s.r.l. | 28/09/2020 - presente" content=card14 footer="Skills: **Java 8**, **Spring Boot 2**, **Spring Data REST**, **Spring Cloud**, **Docker**, **OpenShift**, **AWS**, **Linux**, **Jenkins**, **SonarQube**, **Teiid**" %}

{% capture card13 %}
Sviluppo e manutenzione di alcuni microservizi per un sistema di automazione e gestione del lavoro burocratico e di burocratizzazione delle operazioni sul campo e delle operazioni finanziarie gestite dal cliente.

Coordinamento di un team distribuito e internazionale, gestione del progetto, task management.  
Progettazione delle soluzioni tenendo conto dei vincoli imposti dall'architettura preesistente e dalle linee guida allo sviluppo fornite dai partner.
{% endcapture %}
{% include card.html title="Team Leader / Senior Developer" subtitle="Key 2 Business s.r.l. | 30/12/2019 - 25/09/2020" content=card13 footer="Skills: **Java 8**, **Spring Boot 2**, **Spring Cloud**, **OpenShift**, **MuleSoft API Gateway**, **Kubernetes**, **EFK (Elasticsearch, Fluentd e Kibana) Stack**, **Resilience4j**, **Twitter Zipkin**, **Kafka**, **Openfeign**, **RabbiMQ**, **JBoss Drools**, **Microservices**" %}

{% capture card12 %}
Progettazione di una soluzione a microservizi basata su Spring Boot e Spring Cloud da ospitare su Azure che permetta l'elaborazione documentale e la gestione dei processi e delle procedure di lavorazione della documentazione in modo sicuro, asincrono e distribuito.  
La soluzione tende a fare largo uso dei servizi offerti dal cloud provider Azure per quanto riguarda l'infrastruttura a supporto dei microservizi, prevedendo comunque degli strati di astrazione che permettano l'eventuale migrazione verso cloud provider differenti, aprendo la strada soprattutto verso Kubernetes.  
Si è posta particolare enfasi nella distribuzione delle operazioni a corredo dei processi per bilanciare il carico di lavoro e per distribuire le funzionalità in modo più omogeneo possibile, per evitare al massimo problematiche di *single point of failure*.  
Ogni operazione è progettata per poter lavorare autonomamente sulla propria porzione di processo limitando al minimo la necessità di coreografie e orchestrazioni tra servizi.  
L'attenzione maggiore è stata posta nel garantire sempre l'integrità delle informazioni sia in transito che in persistenza, tramite la progettazione di comandi che garantiscano l'atomicità delle operazioni di scrittura.

Manutenzione di un sistema monolitico che permetteva l'elaborazione documentale e la gestione dei processi e delle procedure di lavorazione della documentazione in modo sicuro e asincrono.
{% endcapture %}
{% include card.html title="Software Architect / Senior Developer" subtitle="Key 2 Business s.r.l. | 02/09/2019 - 27/12/2019" content=card12 footer="Skills: **Java 8**, **Java 11**, **Spring Boot 2**, **Spring Cloud**, **Azure Cloud**, **Microservices**, **Architectural design**" %}

{% capture card11 %}
Sviluppo e manutenzione di un servizio REST che fa da gateway per pagamenti scritto in PHP 5.6.

Sviluppo e manutenzione di un'applicazione web che permette l'inserimento e la gestione di progetti di natura variabile e che permette di definire sezioni di profondità variabile per la categorizzazione di KPI. I KPI vengono inseriti all'interno delle iniziative, divisi per sezioni, e sulla base dei valori inseriti dai PM vengono calcolati vari parametri di controllo, che permettono delle previsioni sul'andamento del progetto.
{% endcapture %}
{% include card.html title="Senior Developer" subtitle="Key 2 Business s.r.l. | 03/06/2019 - 30/08/2019" content=card11 footer="Skills: **PHP 5.6**, **Symfony 2.8**, **MySql**, **Java 8**, **Spring Boot 2**, **ZKOss**" %}

{% capture card10 %}
Sviluppo e manutenzione di una piattaforma multi-tenant utilizzata da vettori che offrono servizio di corriera (autobus).  
La piattaforma comprende un portale online pubblico per l'acquisto di biglietti, un portale di backoffice con autenticazione per la gestione della piattaforma da parte dei vettori, dei servizi web a corredo del funzionamento e due diverse App per la gestione delle corse utilizzate dagli autisti.

Sviluppo e manutenzione di una applicazione WPF che aiuta degli operatori con un lavoro di produzione tramite una lista di operazioni standard per lotto. L'applicazione viene utilizzata tramite comandi vocali e utilizza un fotocamera Reflex per la cattura delle immagini dei passi significativi nella preparazione dell'unità.
{% endcapture %}
{% include card.html title="Senior Developer, DevOps coach @ Infoservice s.r.l." subtitle="Key 2 Business s.r.l. | 10/12/2018 - 31/05/2019" content=card10 footer="Skills: **ASP.NET MVC 5**, **Sql Server 2016**, **WebApi**, **UWP**, **WPF**, **WCF**, **Web Functions**, **Xamarin**, solution quality" %}

{% capture card9 %}
Ho sviluppato alcune evolutive per una intranet SharePoint 2013 on premises.

Ho progettato e sviluppato un portale **SharePoint Online**, con particolare enfasi nella **progettazione della soluzione e nella stesura di linee guida di sviluppo e standard di sviluppo e qualità del codice**.

Ho sviluppato delle evolutive per un sistema di **streaming in diretta**. In particolare, le evolutive consistevano nell’implementazione dello standard di streaming multimediale **HLS**, con produzione di frammenti audio-video in formato **MPEG2 Transport Stream** contenenti stream video in formato **H.264** e stream audio in formato **AAC+** all’interno del software di Encoding in **C++08**.

Ottimizzazione del consumo di memoria tramite **analisi dei memory leak** e del flusso di esecuzione con particolare enfasi nella progettazione di un flusso estremamente veloce per la necessità di processare i **dati multimediali in real-time**. Inoltre l’evolutiva consisteva anche nell’adeguamento dei vari **player multimediali per browser** utilizzando tecnologie client come **Silverlight**, **Applet Java**, **Flash**, **HTML5 video**, **HLS.js**, **player nativi per Android e iOS**.

Progettazione e sviluppo di una intranet su **SharePoint Online**, con particolare enfasi nella **progettazione della soluzione e nella stesura di linee guida di sviluppo e standard di sviluppo e qualità del codice**, ricoprendo anche i ruoli di **Git Master**, **DevOps Architect** e **Technical Leader**. Nel progetto è stata coinvolta anche **Microsoft** con cui ho collaborato anche per l’implementazione delle funzionalità di **Continuous Integration**, **Continuous Deployment**, **Continuous Delivery**.
{% endcapture %}
{% include card.html title="Seniod Developer @ Cluster Reply" subtitle="Key 2 Business s.r.l. | 19/06/2017 - 30/11/2018" content=card9 footer="Skills: **Sharepoint 2013**, **SharePoint 2016**, **SharePoint Online**, **JavaScript**, **TypeScript**, **Css3**, **HTML**, **NodeJs**, **C#**, **Java**, **C++**, **ActionScript 3**, **Handlebars**, **ReactJS**, **KnockoutJS**, Streaming multimediale, controllo qualità e ottimizzazione del software, **architetture cloud-based su Azure e Office 365**, Azure **WebAPI**, Azure **WebJobs**, Azure **WebFunctions**, code review, code quality, DevOps pipeline, Team leadership, progettazione" %}

{% capture card8 %}
Lavoro svolto sia presso la sede del cliente, sia presso la sede interna.

Sviluppo dell’Appunto Informatizzato per la creazione e gestione degli Appunti dell’Arma.

Sviluppo dei requisiti addizionali richiesti rispetto alla base di partenza del software e installazione e manutenzione degli ambienti presso il cliente.
{% endcapture %}
{% include card.html title="Senior Developer, Team Leader, Solutions Architect @ Arma dei Carabinieri" subtitle="Key 2 Business s.r.l. | 04/04/2016 - 30/06/2017" content=card8 footer="Skills: **Sharepoint 2010**, **JS**, **Css3**, **HTML**, **Java**, **Firma Digitale**, Team leadership, progettazione" %}

{% capture card7 %}
Lavoro svolto sia presso la sede del cliente, sia presso la sede interna.

Sviluppo della Intranet del Ministero della Difesa per la gestione delle loro attività e comunicazioni.

Progettazione della piattaforma e gestione della suite di soluzioni.
{% endcapture %}
{% include card.html title="Senior Developer, Team Leader, Solutions Architect @ Ministero della Difesa - SGD" subtitle="Key 2 Business s.r.l. | 22/06/2015 - 01/09/2017" content=card7 footer="Skills: **Sharepoint 2013**, **JS**, **Css3**, **HTML**, **Bootstrap**, **Jquery**, **JqGrid**, **iTextSharp**, Team leadership, progettazione, formazione" %}

{% capture card6 %}
Formazione di una risorsa junior su tematiche sviluppo web, asp.net, Sharepoint.

Raccolta dei requisiti, analisi, progettazione e gestione del progetto, rapporti col cliente e schedulazione dei task.

Progettazione e mantenimento della soluzione software.

Installazione e configurazione degli ambienti di sviluppo, collaudo e produzione.

Gestione delle risorse assegnate al progetto.

Sviluppo di un applicazione per il ministero per l'automatizzazione della gestione e condivisione delle lettere di comunicazioni tra reparti. Il software è in grado di memorizzare i vari documenti scannerizzati tramite sw client esterno e gestirli in document set, con i sistemi di approvazione e versionamento built-in sharepoint.

I documenti possono: essere ricercati nel sistema, visualizzati direttamente, modificare metadati ed effettuare azioni per la gestione del flusso di lavoro e stato del documento, gestendo permessi custom sui documenti a seconda dell'utente che effettua operazioni.

L'applicazione è anche in grado di supportare framework js esterni con strati di compatibilità su IE 8/9.
{% endcapture %}
{% include card.html title="Senior Developer, Team Leader, Solutions Architect @ Ministero della Difesa - SMD" subtitle="IDA - International Defence Alliance / Key 2 Business s.r.l. | 05/01/2015 - 19/06/2015" content=card6 footer="Skills: **SharePoint 2010**, **FAST Search Server**, **Office Web Apps**, gestione di materiale classificato in ambito militare, Team leadership, formazione, Ciclo di gestione completo del progetto (escluso cost management)" %}

{% capture card5 %}
Ho lavorato come **amministratore di sistema e sviluppatore SharePoint** sia su **MOSS2007** che su **SP2010**. Ho manutenuto la farm SharePoint di Monaco, in Germania, e sviluppato applicazioni personalizzate e componenti per questi sistemi implementando **processi di Business** per il management di **UniCredit**.
{% endcapture %}
{% include card.html title="SharePoint Intermediate/Senior Developer @ UniCredit S.p.A." subtitle="Elit Professionals s.r.l. / Globo Informatica s.r.l. | 28/03/2011 - 31/12/2014" content=card5 footer="Skills: **SharePoint 2007/2010**, **Entity Framework**, **BPM**, **Sql Server 2012**, Law enforcement management BPM" %}

{% capture card4 %}
In **Poste Italiane** ho contribuito a sviluppare un sistema per normalizzare gli indirizzi per l'attività di recapito postale, che è il business centrale di Poste Italiane. La normalizzazione degli indirizzi veniva effettuata seguendo dei concetti matematici applicati alla comparazione tra stringhe, confrontando ogni indirizzo tramite l'algoritmo di **Levenshtein** con il database prenormalizzato mantenuto dallo stesso gruppo.

Successivamente ho sviluppato un **sistema cartografico** di aiuto alle strategie di **marketing** per il riposizionamento degli uffici postali nel territorio italiano e per la gestione generale del territorio ad opera dell'ufficio di toponomastica.

Questo sistema è basato sulla mia personale implementazione di un algoritmo che segue la Legge di Reilly dei modelli gravitazionali (usata nel **geomarketing**), che può calcolare il posto migliore per un ufficio postale nel territorio italiano misurando la zona di copertura del servizio e il bacino d'utenza servito, usando i dati delle microzone ISTAT.

Un altro componente del sistema calcolava invece la **“gita portalettere”**, cioè il percorso del postino sulla base della posta da consegnare. L'algoritmo implementato per risolvere il problema è stato l'algoritmo dei cammini minimi della teoria dei grafi, anche questo gestito e visualizzato sul sistema cartografico da me implementato sulla base di **ESRI ArcGIS** e **Google Maps**.
{% endcapture %}
{% include card.html title="Developer Analyst @ Poste Italiane S.p.A." subtitle="IT Resources s.r.l. | 28/07/2008 - 25/03/2011" content=card4 footer="Skills: **C# 2.0/3.5**, **ASMX**, **WCF**, **ASP.NET**, **ArcGIS**, **Google Maps**, **Bing Maps**, **Sql Server 2005/2008**, **Reporting Services**, Statistics Marketing and Geographical Algorithms, Geocoding and Geolocalization, String comparison algorithms, Address matching based on mathematical formulas, **GIS**" %}

{% capture card3 %}
Per 4 mesi ho sviluppato un servizio web ad alte prestazioni utilizzando **Apache Axis 2**, ad uso e gestione dell'anagrafe canina presso il **Ministero della Salute**.
{% endcapture %}
{% include card.html title="Analista Programmatore @ Accenture S.p.A." subtitle="31/03/2008 - 25/07/2008" content=card3 footer="Skills: **J2EE 1.6**, **Axis 2**" %}

{% capture card2 %}
Per 4 mesi sono stato in **INPDAP**, l'istituto di previdenza sociale per i lavoratori pubblici, in cui ho aiutato a sviluppare un software in **Java** che calcola la cartolarizzazione dei crediti per i finanziamenti concessi ai dipendenti pubblici.
{% endcapture %}
{% include card.html title="Sviluppatore Java @ INPDAP" subtitle="Nike Web Consulting s.r.l. | 03/12/2007 - 28/03/2008" content=card2 footer="Skills: **J2SE 1.6**, **Hibernate**, Multithreading, Statistics and Financial algorithms" %}

{% capture card1 %}
Ho lavorato per 3 mesi come **sviluppatore Java** in un progetto per il **Ministero dell'Economia e della Finanza**, che aveva lo scopo di aiutare gli impiegati pubblici ad accedere al pensionamento anticipato sulla base delle loro necessità, rispondendo a questionari dinamici.
{% endcapture %}
{% include card.html title="Junior Java Developer @ MEF" subtitle="Nike Web Consulting s.r.l. | 19/08/2007 - 28/03/2008" content=card1 footer="Skills: **J2EE 1.5**, **Struts**, **Spring**, **Hibernate**" %}

---
{: .my-5 .bg-success }

## Competenze linguistiche

{: .table .table-striped .table-responsive-md }
| Lingua  | Scritto | Letto | Parlato | Ascoltato |
| ------- | ------- | ----- | ------- | --------- |
| Inglese | C1      | C1    | B2      | B2        |

---
{: .my-5 .bg-success }

## Sistemi Operativi

{: .table .table-striped .table-responsive-sm }
| OS      | Proficiency |
| ------- | ----------- |
| Windows | Expert      |
| Linux   | Expert      |
| Android | Expert      |

## Linguaggi

{: .table .table-striped .table-responsive-sm }
| Linguaggio | Proficiency  |
| ---------- | ------------ |
| Java       | Expert       |
| C#         | Expert       |
| C/C++      | Intermediate |
| Ruby       | Intermediate |
| PHP        | Intermediate |
| Python     | Intermediate |
| Perl       | Intermediate |
| JavaScript | Expert       |
| HTML5      | Expert       |
| CSS3       | Expert       |
| VB         | Intermediate |
| VB.NET     | Intermediate |
| SQL        | Expert       |

<div class="row">
<div class="col" markdown="1">

* **Basi Dati**:
  * SQL Server
  * MySQL
  * PostgreSQL
  * Oracle

</div>
<div class="col" markdown="1">

* **Framework Web**:
  * Struts
  * Ruby On Rails
  * ASP.NET MVC
  * ASP.NET WebForms
  * ReactJS
  * ZKOss
  * Spring MVC
  * Thymeleaf
  * JSF

</div>
<div class="col" markdown="1">

* **Application Server**:
  * IIS
  * Jboss
  * Tomcat
  * WebSphere
  * Glassfish
  * Apache
  * Express

</div>
<div class="col" markdown="1">

* **Librerie e Framework vari**:
  * WCF
  * WPF
  * UWP
  * Spring
  * J2EE
  * Apache Java Framework
  * Jquery
  * Knockout
  * React
  * Underscore
  * Backbone
  * Angular
  * Bootstrap
  * Chart
  * Jquery UI
  * Android
  * Hibernate
  * NHibernate
  * Entity Framework

</div>
</div>
