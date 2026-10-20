---
title: "Ho rotto il BIOS cercando di aggiustare GRUB"
tags:
- linux
- opensuse
- uefi
- selinux
- firmware
date: 2026-10-20 13:59:23+00:00
---

Questa è la storia di un venerdì sera in cui volevo solo vedere un film sul portatile di mia moglie, nel lettone con tutta la famiglia. E invece i dannati servizi di streaming, se non sei aggiornato alle cazzo di beta dei cazzo di browser, che deve immancabilmente essere Google Chrome, non Chromium, non Opera, non i vari miei browser più strani, come Falkon o Konqueror, ma nemmeno Firefox eh, non partono nemmeno. Non ci sono web standard o DRM abilitati e funzionanti che tengano. **Perché no**, e basta. Non chiedere, fatti gli affari tuoi. E paga un abbonamento sempre più alto per un servizio sempre più scadente pieno di serie e film di qualità discutibile. Sono 50 euro, grazie.

Quindi ho deciso di aggiornare il portatile, o meglio, di *migrarlo*. Di venerdì sera. Non ho imparato un cazzo da 20 anni di onorato servizio. E poi ho passato un sabato mattina a rimettere insieme, un pezzo alla volta, tutto quello che avevo immancabilmente rotto, imparando strada facendo un sacco di cose sul firmware UEFI che in tanti anni di Linux non avevo mai avuto bisogno di sapere (e che, a essere sincero, avrei fatto volentieri a meno di scoprire, soprattutto così).

Alla fine il portatile è tornato a funzionare, con SELinux in enforcing e il tasto F2 che apre di nuovo il BIOS. E a ridarmi il BIOS è stato un CRC32 nascosto in una variabile UEFI che con ogni probabilità non hai mai guardato nemmeno tu. Ma nemmeno sua madre l'avrà mai guardata. Come deve essere successo al progettista Lenovo che non ha pensato a un ripristino del BIOS, guardandolo la prima volta deve aver detto "bello de zia".

{% include more.html %}

## Venerdì sera, tutto sotto controllo

Il portatile è un Lenovo V15-ADA: Ryzen 3 3250U, 8 GB di RAM, un NVMe SK Hynix da 256 GB e un firmware Insyde che di nome fa E8CN27WW (non lo inviterei alla mia festa). Sul disco c'è openSUSE Leap 15.6 con il partizionamento di una volta: `/boot` separato in ext2, l'ESP in FAT, lo swap e una root Btrfs con tutti i subvolume del caso. Niente di esotico, insomma. Con openSUSE, Btrfs e Secure Boot avevo già avuto i miei [incubi nel 2013]({% post_url en/2013-08-01-a-nightmare-to-remember-not-the-dream-theaters-song-btrfs-vs-me-pt1 %}), e a quanto pare non avevamo ancora finito di conoscerci.

Prima di arrivare alla migrazione, però, ho provato la strada corta. `zypper update` non aveva niente da aggiornare, `flatpak update` nemmeno (Chrome sta su Flatpak), e anche il repository Packman, aggiunto apposta per avere codec e DRM più freschi, non ha cambiato di una virgola la situazione. A un certo punto ho capito che erano i repository di Leap 15.6 a essere rimasti indietro, e che per uscirne avrei dovuto capire cosa mancasse, pescare pacchetti a mano e aggiungere qualche repository in più: tutta roba che non avevo nessuna voglia di fare, e che col senno di poi sarebbe stata infinitamente più facile di quello che è successo dopo. La migrazione a Leap 16 la rimandavo da mesi, prima o poi andava fatta, e quel venerdì sera mi è sembrata l'occasione buona.

Leap 16 è uscita l'autunno scorso e porta con sé un bel salto: il kernel passa dalla serie 6.4 alla 6.12, AppArmor lascia il posto a SELinux, e per chi arriva dalla 15.6 c'è uno strumento ufficiale, `opensuse-migration-tool`, che promette di fare tutto lui. Lo lanci, scegli la versione, aspetti che finisca e riavvii. Così ho fatto, e il primo avvio è andato liscio come l'olio, se non fosse per una riga che GRUB mi ha sputato in faccia prima di caricare il kernel:

{: .text-center }
![Lo schermo del portatile al primo avvio dopo la migrazione: GRUB stampa "errore: ../../grub-core/fs/btrfs.c:303:not a Btrfs filesystem." e subito dopo carica comunque kernel e initrd di openSUSE Leap 16.0]({% link /media/2026-10-20/grub-errore-btrfs.jpg %}){: .img-fluid .w-75 }

```text
errore: ../../grub-core/fs/btrfs.c:303:not a Btrfs filesystem.
  Avvio di "openSUSE Leap 16.0" in corso

Loading Linux 6.12.0-160000.38-default ...
Loading initial ramdisk ...
```

Oggi lo so che quella riga, con ogni probabilità, non voleva dire niente: è una `search` che prova a leggere come Btrfs una partizione che **non è** Btrfs, fallisce e passa alla successiva, tanto che subito sotto kernel e ramdisk vengono caricati come se nulla fosse. Ma venerdì sera, con un salto di versione appena fatto e quella parola, *errore*, piantata lì in cima allo schermo, l'istinto ha avuto la meglio sul buonsenso, e ho fatto quello che fa chiunque abbia un minimo di confidenza con openSUSE e nessuna voglia di approfondire alle undici di sera: ho lanciato `update-bootloader --reinit`, che rigenera la configurazione del bootloader e lo reinstalla sull'ESP.

Al riavvio successivo il portatile non è più ripartito.

## Una shell di emergenza che non ti dà la shell

systemd arrivava più o meno a metà strada e poi si piantava sul mount di `/boot`, trascinandosi dietro tutto il resto:

```text
[FAILED] Failed to mount /boot.
See 'systemctl status boot.mount' for details.
[DEPEND] Dependency failed for /boot/efi.
[DEPEND] Dependency failed for Local File Systems.
```

Fin qui niente di drammatico, perché in questi casi l'emergency mode serve proprio a questo: ti chiede la password di root, ti dà una shell e tu sistemi. Solo che la password veniva accettata e subito dopo `sulogin` mi rispondeva che non riusciva a caricare né `/bin/bash` né `/bin/sh`, e premendo Ctrl-D per riprovare si tornava esattamente allo stesso punto. Era passata la mezzanotte, e io stavo fissando uno schermo che mi chiedeva la password per poi dirmi che non aveva niente da darmi in cambio.

Il piano B era il menu di GRUB, dove avrei potuto aggiungere qualche parametro alla riga del kernel e vedere cosa succedeva. Peccato che a un certo punto, per non aspettare qualche secondo a ogni accensione (un'eternità, evidentemente), avessi impostato `GRUB_TIMEOUT=0`, e il menu quindi non compariva mai. GRUB in realtà un messaggio lo mostra, "Please press 't' to show the boot menu on this console", e per un attimo mi è sembrato la via d'uscita; poi ho scoperto che è una voce nascosta che SUSE aggiunge al menu per passare alla console di testo, e che funziona solo quando il menu è visibile, cioè mai, con il timeout a zero. Ho provato anche con Esc e con Shift tenuti premuti durante l'avvio, senza nessun risultato.

Alle due di notte, con gli occhi che si chiudevano da soli e la sensazione di aver girato a vuoto per tre ore, ho alzato bandiera bianca e sono andato a dormire, consolandomi con l'idea che restava la chiavetta, che a un me mezzo addormentato e col morale sotto terra sembrava la parte facile. Del resto non mi aveva mai deluso, ne ho recuperati a centinaia di sistemi solo con una chiavetta o un cd con SystemRescue. La prima versione di sysresc che usai era tipo la 2 o la 3. Ora siamo alla 13. Quanti ricordi (traumatici).

## Le chiavette che tornano sul disco

Alle sette del mattino ero già sveglio e su in soffitta, dove ho il mio PC e il laboratorio con tutti gli attrezzi, pronto a ricominciare da dove avevo lasciato. Ho scaricato la ISO offline di Leap 16, 4,2 GB, l'ho scritta su una chiavetta con un `dd` volantissimo, ho premuto F12 all'accensione e ho scelto la USB. Il portatile ha stampato qualcosa di illeggibile per mezzo secondo e poi ha inesorabilmente fatto come voleva, ha avviato openSUSE dal disco, fino alla solita emergency mode non funzionante (dannato SELinux, hai rovinato le distro Linux!).

Ho pensato a Secure Boot, perché Leap 16 porta con sé uno shim più recente che in teoria può revocare i bootloader più vecchi e far rifiutare le live, e sono andato a disabilitarlo nel Setup. Al riavvio successivo Secure Boot era di nuovo abilitato, come se non avessi toccato niente. Ci ho riprovato con altre live, e alla fine anche con SystemRescue, che con shim non ha niente a che fare, e il risultato era sempre lo stesso: il firmware fingeva di avviare la chiavetta e poi ripiegava sul disco.

È lì che mi sono demotivato sul serio. Non partiva più niente, nemmeno le live, il Setup ignorava quello che gli chiedevo, e il portatile sembrava aver deciso che l'unica cosa che avrebbe mai avviato era un sistema rotto. A Claude, il modello linguistico di Anthropic che uso spesso come compagno di ragionamento e a cui da qualche ora andavo raccontando i progressi (pochi), dal PC e dal telefono, con le foto dello schermo fatte al volo, ho scritto più o meno così: "mi sto un po' disperando".

Il primo indizio vero, però, l'ho trovato guardando le voci di boot. Nel menu di avvio di F12 c'erano quattro voci `opensuse-secureboot` identiche, una sotto l'altra, e nella scheda Boot del Setup i nomi delle altre voci si allungavano ripetendo se stessi: "USB HDD: VendorCo ProductCode VendorCo ProductCode VendorCo..." e il nome del disco ripetuto decine di volte, come un disco rotto (nel senso del vinile, stavolta).

{: .text-center }
![La scheda Boot del Lenovo Setup Utility: sotto la voce opensuse-secureboot, il nome della chiavetta USB ripete "VendorCo ProductCode" per cinque righe e quello del disco NVMe, SKHynix_HFM256GDHTNI-87A0B, compare più di venti volte]({% link /media/2026-10-20/setup-voci-di-boot-ripetute.jpg %}){: .img-fluid .w-75 }

## La NVRAM era piena

Le variabili UEFI, cioè le voci di boot, l'ordine di avvio, le impostazioni e perfino le chiavi di Secure Boot, vivono in una piccola regione della flash del firmware. Piccola davvero, e su molti firmware lo spazio di una variabile cancellata torna libero solo quando il firmware decide di compattare la regione, cioè quando gli pare.

La ricostruzione a cui sono arrivato, e che dall'esterno del firmware non posso verificare fino in fondo, è questa: scegliere un dispositivo da F12 richiede una scrittura in NVRAM (con ogni probabilità la variabile `BootNext`), e se la scrittura fallisce il firmware non si lamenta, segue il `BootOrder` normale e parte dal disco. L'impostazione di Secure Boot è anche lei una variabile, e se il firmware non riesce a scriverla al riavvio rilegge quella vecchia. Quattro voci duplicate, nomi corrotti e impostazioni che non si salvano: tutto tornava, se la NVRAM era piena.

Per provarlo l'idea più semplice era anche la più brutale: se il firmware ripiega sempre sul disco, togliamogli il disco. Sul banco del laboratorio ho smontato il fondo del portatile, ho scollegato la batteria interna e ho tolto l'NVMe, poi ho riacceso con la chiavetta di SystemRescue inserita, e SystemRescue è partita al primo colpo. "Mi sa che era proprio la NVRAM piena", ho scritto, ed ero contento come non mi capitava da ore.

Per un attimo ho anche pensato di furbeggiare, avviare la live senza disco e infilare l'NVMe a caldo una volta partita, e per fortuna prima di farlo ho chiesto: l'M.2 di un portatile consumer non è progettato per l'hot plug, e il massimo che avrei ottenuto, nel caso migliore, era un disco non rilevato.

## Ho pulito troppo

Da SystemRescue, con `efibootmgr`, ho cominciato a fare pulizia con lo zelo di chi finalmente ha trovato il colpevole. Ho cancellato le voci `opensuse-secureboot` duplicate, quelle con i nomi corrotti e un bel po' di altre che non riconoscevo, e ricordo di aver tolto `Boot000A`, `000B`, `000C` e una serie tra `0011` e `0016`, forse anche `0017` e `0018`. È rimasta solo `Boot0000`, la voce di openSUSE, e mi sono subito sentito soddisfatto di aver fatto ordine in quella *mazzumàja*[^1].

Poi ho rimontato l'NVMe, ho riacceso, e il portatile si è piantato sul logo Lenovo, senza il beep che di solito accompagna F2 e F12, con la ventola che girava a tutta *callàra*[^2] e nient'altro. Ho aspettato più di cinque minuti, pensando al training della memoria che i Ryzen rifanno dopo che si è scollegata la batteria, ma il logo restava lì immobile, e a quel punto la paura di aver fatto un danno serio era concreta. Senza chiavetta, per fortuna, il portatile ripartiva dal disco (rotto, ma ripartiva), mentre premendo F12 si bloccava di nuovo sul logo. Il BIOS, semplicemente, sembrava non esistere più.

È stato ragionando su quel "sembrava" che mi è venuto il dubbio giusto: e se il BIOS di Lenovo fosse anche lui un programma EFI, registrato tra le voci di boot? E se una delle voci che avevo cancellato fosse proprio quella? La risposta era sì, su entrambi i fronti. Su molti Lenovo, e su questo di sicuro, il Setup e il menu di avvio sono registrati in NVRAM come voci `Boot####` di tipo applicazione, con un percorso del tipo `FvFile(<GUID>)` che punta a un modulo dentro il firmware, e io quelle voci le avevo cancellate insieme alla spazzatura.

La conferma è arrivata da un comando che non avevo mai usato in vita mia. Da SystemRescue, sempre senza disco, ho lanciato:

```bash
systemctl reboot --firmware-setup
```

Questo comando non passa da nessuna voce di boot: imposta un bit nella variabile `OsIndications`, e al riavvio è il firmware stesso a entrare nel Setup. E nel Setup ci entrava, eccome. Il codice era tutto lì, intatto, mancavano solo i puntatori per raggiungerlo dai tasti. Ho provato anche F9 (Setup Defaults) seguito da F10, nella speranza che il firmware ricreasse le sue voci da solo, ma non è successo.

La cosa che mi ha fatto più arrabbiare l'ho scoperta dopo, leggendo la specifica UEFI, che questo caso lo prevede: ogni tasto rapido si porta dietro il CRC della voce che deve lanciare, e se il CRC non torna, perché la voce è cambiata o perché non c'è più, il tasto va ignorato.

> citation "UEFI Specification 2.10, 3.1.6" [https://uefi.org/specs/UEFI/2.10/03_Boot_Manager.html#launching-boot-load-options-using-hot-keys]
> Se i CRC-32 non coincidono, l'opzione del tasto viene ignorata.
>
> If the CRC-32s do not match this value, then this key option is ignored.
> {: .citation-original lang="en"}

Il firmware di questo portatile, invece di ignorarlo e andare avanti col boot, si pianta.

## Due cose da fare

A quel punto avevo due problemi ben distinti, e li ho messi in fila: rimettere in piedi openSUSE, e rimettere al loro posto le applicazioni del firmware.

Per il primo mi serviva una live che partisse con il disco montato, e l'idea che ho avuto è stata semplice e un po' perversa: se cancello anche `Boot0000`, il firmware non ha più nessuna voce che punti al disco, e a quel punto deve per forza partire dalla chiavetta. Prima ho fotografato l'output di `efibootmgr -v`, per avere sottomano i dati necessari a ricreare la voce (la partizione dell'ESP, il suo GUID, il percorso di `shim.efi`), poi l'ho cancellata, ho rimontato il disco, e SystemRescue è partita con l'NVMe al suo posto. F2 ancora no, ma era già qualcosa.

Per il secondo, onestamente, non avevo la più pallida idea di come fare, e l'ho messo da parte.

## Dentro il sistema, a caccia del colpevole

Da SystemRescue ho montato la root Btrfs senza opzioni, che su openSUSE significa montare il subvolume di default, cioè lo snapshot attivo, e poi `/var` a parte, perché è un subvolume in quella installazione e mi serviva per leggere qualche log:

```bash
mount /dev/nvme0n1p4 /mnt
mount -o subvol=@/var /dev/nvme0n1p4 /mnt/var
```

Il journal persistente non c'era, perché il sistema usa rsyslog e `/var/log/journal` non esiste, ma in `/var/log/boot.log` c'era tutto il boot fallito, con il suo `Failed to mount /boot` in bella vista. Ero convinto che il colpevole fosse `fstab` e che l'UUID di `/boot` non corrispondesse più a quello della partizione, ma il primo `lsblk` mi ha dato torto, perché gli UUID coincidevano perfettamente.

Il dettaglio interessante l'ho trovato nella configurazione del kernel. Leap 16 non ha più il driver ext2: ha `CONFIG_EXT4_USE_FOR_EXT2=y`, che significa che le partizioni ext2 le monta il driver ext4, e quel driver è un modulo (`ext4.ko.zst`) che va caricato al momento del mount. I subvolume Btrfs montavano senza problemi perché il driver btrfs sta già nell'initrd; `/boot` aveva bisogno di caricare un modulo, e non ci riusciva.

Sapevo che la migrazione aveva attivato SELinux, quindi sono andato a contare i rifiuti nell'audit log:

```bash
grep -c 'avc: denied' /mnt/var/log/audit/audit.log
0
```

Zero. E allora mi sono messo a cercare altrove: `/bin` e `/sbin`, che mi aspettavo fossero symlink a `/usr` e che invece sono directory vere, `modprobe` che magari non si trovava più, un usrmerge fatto a metà dalla migrazione. I binari c'erano tutti, al loro posto, e la cosa non tornava. Poi, su suggerimento di Claude, ho cambiato pattern:

```bash
grep -c 'type=AVC' /mnt/var/log/audit/audit.log
373
```

Nell'audit log, dopo `avc:` ci sono *due* spazi, e io ne avevo scritto uno. :facepalm:

<div class="row justify-content-center" markdown="1">
<div class="col-6 col-md-3" markdown="1">
![Meme: il capitano Picard di Star Trek, seduto sulla sua poltrona sul ponte dell'Enterprise, si copre la faccia con una mano]({% link /media/2026-10-20/facepalm-picard.jpg %}){: .img-fluid }
</div>
</div>

## SELinux senza etichette

SELinux, nato alla NSA (e si vede: solo un americano imparanoiato poteva concepire un mostro tentacolare di quella portata), assegna a ogni file un'etichetta, il cosiddetto *contesto*, che sta negli attributi estesi del filesystem, e la policy decide chi può fare cosa in base a quelle etichette. Un file che un'etichetta non ce l'ha risulta `unlabeled_t`, e in enforcing con un file `unlabeled_t` non si fa praticamente niente.

Le note di rilascio di Leap 16 spiegano che, finita la migrazione, lo strumento propone di passare da AppArmor a SELinux, e sul mio sistema `/etc/selinux/config` diceva `SELINUX=enforcing`. Il filesystem, però, non l'aveva etichettato nessuno. Il rimedio da manuale è un file vuoto, `/.autorelabel`, che al boot successivo dovrebbe far rietichettare tutto.

Da SystemRescue ho messo SELinux in permissive, ho creato `/.autorelabel`, ho finalmente riportato `GRUB_TIMEOUT` a 5 secondi, ho rigenerato la configurazione di GRUB dal chroot e ho ricreato la voce di boot che avevo cancellato:

```bash
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /mnt/etc/selinux/config
touch /mnt/.autorelabel
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /mnt/etc/default/grub
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot/efi
for d in dev proc sys run; do mount --rbind /$d /mnt/$d; done
chroot /mnt grub2-mkconfig -o /boot/grub2/grub.cfg
efibootmgr -c -d /dev/nvme0n1 -p 2 -L opensuse-secureboot -l '\EFI\opensuse\shim.efi'
```

Tolta la chiavetta e riavviato, openSUSE è ripartito. Erano le due del pomeriggio, e dopo tre ore di notte e una mattinata intera passate a inseguire indizi, vedere comparire il desktop di Leap 16 mi ha dato una carica che non mi aspettavo, tanto che avrei attaccato subito la parte che fino a quel momento mi faceva più paura, se non fosse che avevo da fare, e il BIOS, per qualche ora, ha dovuto aspettare.

## Il CRC nella tastiera

Al portatile sono tornato la sera, con la testa più fresca e un BIOS che continuava a non rispondere né a F2 né a F12. Ho provato a leggere la flash del firmware con `flashrom -p internal -r`, che non ha trovato nessun dispositivo, e ho cercato un aggiornamento su LVFS, dove questo modello non c'è (Discover me l'avrebbe proposto da tempo, altrimenti). Lenovo distribuisce l'aggiornamento del BIOS solo come eseguibile Windows, e lì, chiedendomi come fosse possibile che non esistesse uno strumento di recovery per una cosa del genere, ho toccato il secondo momento di sconforto della giornata.

Qui Claude è stato fondamentale. Mi ha fatto notare che i tasti rapidi del firmware sono a loro volta variabili UEFI, le `Key####`, e che quelle io non le avevo toccate. La loro struttura è nella specifica, alla sezione 3.1.6:

```c
typedef struct _EFI_KEY_OPTION {
  EFI_BOOT_KEY_DATA  KeyData;
  UINT32             BootOptionCrc;
  UINT16             BootOption;
  // EFI_INPUT_KEY   Keys[];
} EFI_KEY_OPTION;
```

`BootOption` è il numero della voce di boot da lanciare quando premi il tasto, e `BootOptionCrc` è il CRC32 dell'intera voce. Questo è l'inizio di `Key0000`, letto da `/sys/firmware/efi/efivars` (i primi quattro byte sono gli attributi della variabile, che il kernel aggiunge in testa):

```text
07 00 00 00  00 00 00 40  65 51 24 76  0a 00  0c 00 00 00
attributi    KeyData      CRC          Boot   F2
```

CRC `0x76245165`, voce `Boot000A`, tasto F2 (scan code `0x0C`), e in coda, sempre dentro `Key0000`, Insyde ci ha messo anche una stringa: "Press <F2> to enter Setup, <F12> to enter MultiBoot Menu. Please Wait...". Messe in fila, le tre variabili dicevano questo:

| Variabile | Tasto | Voce     | CRC32      |
| --------- | ----- | -------- | ---------- |
| `Key0000` | F2    | Boot000A | `76245165` |
| `Key0001` | F12   | Boot000B | `a79047d5` |
| `Key0002` | Esc   | Boot000C | `748d0198` |

In altre parole il firmware, per ogni voce che avevo cancellato, mi aveva lasciato in mano un'impronta. Con l'impronta potevo costruire una voce candidata e sapere con certezza, prima di scrivere un solo byte in NVRAM, se era quella giusta. La strada più sicura per riavere il BIOS, e non avrei mai pensato di dirlo, era il brute force.

Una voce di boot (`EFI_LOAD_OPTION`, sezione 3.1.3 della specifica) è fatta di quattro pezzi, più eventuali dati opzionali in coda: gli attributi, la lunghezza del percorso, una descrizione in UTF-16 e il percorso del dispositivo, che per un'applicazione del firmware è un nodo `FvFile` con il GUID del modulo. Le incognite quindi erano tre: gli attributi, che hanno pochi valori plausibili, la descrizione ("Setup"? "Boot Menu"? "MultiBoot Menu"?) e il GUID, che è un numero a 128 bit e da indovinare a caso non si indovina.

I GUID dei moduli però stanno dentro l'immagine del firmware, e l'immagine del firmware sta dentro l'aggiornamento di Lenovo. Ho scaricato `e8cn41ww.exe` e l'ho aperto con `7z`: dentro c'erano gli strumenti di flash per Windows, un altro eseguibile che `7z` non riusciva ad aprire (il flasher di Insyde) e soprattutto `BIOS.cap`, 8,6 MB, cioè l'immagine del BIOS con un'intestazione capsule davanti. UEFIExtract, dal progetto UEFITool, l'ha masticata lamentandosi di qualche `unaligned volume` e mi ha restituito l'elenco dei moduli, 432 GUID.

Lo script per la ricerca l'ha scritto Claude, in pochi minuti, e prima di passarmelo l'ha provato su dati sintetici costruiti apposta, cosa che da solo, sinceramente, starei ancora facendo. Il cuore è un ciclo:

```python
import struct, uuid, zlib

def load_option(attrs, desc, guid):
    fvfile = struct.pack("<BBH", 0x04, 0x06, 20) + uuid.UUID(guid).bytes_le
    path = fvfile + b"\x7f\xff\x04\x00"  # FvFile(GUID) + End
    return (struct.pack("<IH", attrs, len(path))
            + desc.encode("utf-16-le") + b"\0\0" + path)

targets = {0x76245165: "Boot000A", 0xa79047d5: "Boot000B", 0x748d0198: "Boot000C"}

for attrs in (0x0, 0x1, 0x8, 0x9, 0x100, 0x101, 0x108, 0x109):
    for desc in descriptions:  # "Setup", "Boot Menu", ...
        for guid in guids:     # the 432 GUIDs from UEFIExtract
            crc = zlib.crc32(load_option(attrs, desc, guid))
            if crc in targets:
                print(targets[crc], hex(attrs), desc, guid)
```

Lo script vero prova ogni voce due volte, senza niente in coda e con il GUID del modulo ripetuto nei dati opzionali, e con 20 descrizioni candidate fanno 138.240 combinazioni (8 x 20 x 432 x 2), che passano in pochi secondi. Al primo tentativo sono uscite queste due righe:

```text
FOUND crc=76245165 MATCH Key0000 -> Boot000A attrs=0x1 desc='Setup' path=FvFile(721c8b66-426c-4e86-8e99-3457c46ab0b9) optdata=0 bytes -> saved recovered/Boot000A.bin
FOUND crc=a79047d5 MATCH Key0001 -> Boot000B attrs=0x1 desc='Boot Menu' path=FvFile(86488440-41bb-42c7-93ac-450fbf7766bf) optdata=0 bytes -> saved recovered/Boot000B.bin
```

Quelle due righe da sole valevano la giornata. Il GUID del Setup, tra l'altro, è lo stesso che compare nelle voci "Setup" dei ThinkPad, e i moduli venivano dal BIOS E8CN41WW mentre le voci originali le aveva create il mio E8CN27WW: il CRC che combacia dice anche che tra le due versioni quei GUID non sono cambiati.

Prima di scrivere qualsiasi cosa ho salvato tutte le variabili, scoprendo che `cp` su efivarfs fallisce con un poco rassicurante "Operazione di seek non consentita", perché quel filesystem il seek non lo supporta, mentre `cat`, che legge in sequenza, funziona benissimo:

```bash
cd /sys/firmware/efi/efivars
for f in *; do cat "$f" > ~/efivars-backup/"$f"; done
```

Poi ho scritto le due voci. `efibootmgr` crea voci che puntano a un file su una partizione, non a un modulo del firmware, quindi la scrittura la fa lo script stesso, che prima ricalcola il CRC e si rifiuta di andare avanti se non coincide con quello della `Key####`, e senza `--yes` si limita a una prova a vuoto:

```bash
efi_hotkeys.py write 000A recovered/Boot000A.bin
efi_hotkeys.py write 000A recovered/Boot000A.bin --yes
efi_hotkeys.py write 000B recovered/Boot000B.bin
efi_hotkeys.py write 000B recovered/Boot000B.bin --yes
```

Con l'emozione questi quattro li ho incollati tutti insieme, e ne è partito uno solo, la prova a vuoto, ovviamente. Rilanciati come si deve, ho controllato con `efibootmgr -v` che ci fossero entrambe le voci, e ho riavviato. F2 ha aperto il Setup. Al riavvio successivo F12 ha aperto il menu di avvio. Funzionavano entrambi.

## Esc, la voce che non torna

`Boot000C`, quella del tasto Esc, invece non è uscita, e ci ho provato parecchio. Ho allargato la ricerca a 3.090 descrizioni candidate, quasi tutte stringhe UTF-16 pescate nei moduli decompressi, con 14 combinazioni di attributi, per 37 milioni di candidati; poi a percorsi `FvVol/FvFile` con tutte le coppie di GUID, 60 milioni; poi ai GUID letti direttamente dagli header dei file nel binario, per recuperare anche i volumi che UEFIExtract segnalava come disallineati e forse saltava, 3.200 GUID e 277 milioni di candidati. Ho provato percorsi `File(\EFI\...)` come quello della voce "Lenovo Recovery System" che il firmware aveva ricreato da solo, e perfino il bit `0x80` negli attributi, che la specifica non definisce e che il firmware ha messo sulla voce del disco ricreata da lui, insieme ai 16 byte di dati opzionali che quella voce si porta dietro.

Niente. O quella voce conteneva qualcosa che dal firmware non si ricava, per esempio il percorso hardware di un dispositivo, o puntava a un modulo che c'era nel 27WW e nel 41WW non c'è più. Il CRC ti dice se una risposta è giusta, ma non ti aiuta a trovarla. Mi sono fermato lì.

Purtroppo, non c'è stato modo di accedere a "*Lenovo Recovery System*" nemmeno scrivendo a mano BootNext. Chissà se quel programma EFI avrebbe potuto risolvere la situazione. Non credo che lo saprò mai.

## SELinux, l'ultimo giro

Restava SELinux da riportare in enforcing, e volevo chiudere. Il sistema partiva in permissive, dove i rifiuti vengono registrati senza bloccare niente, quindi era il momento giusto per vedere cosa avrebbe bloccato una volta riattivato, e i rifiuti che sono usciti mi hanno detto che il relabel non era mai avvenuto:

```text
avc:  denied  { entrypoint } for comm="(systemd)" path="/usr/lib/systemd/systemd"
  scontext=unconfined_u:unconfined_r:unconfined_t:s0
  tcontext=system_u:object_r:unlabeled_t:s0 tclass=file permissive=1

avc:  denied  { module_load } for comm="modprobe"
  path="/usr/lib/modules/6.12.0-160000.38-default/kernel/sound/core/snd-seq-device.ko.zst"
  scontext=system_u:system_r:kernel_t:s0
  tcontext=system_u:object_r:unlabeled_t:s0 tclass=system permissive=1
```

`ls -Z /usr/lib/systemd/systemd` rispondeva con un punto interrogativo, e `/.autorelabel` era ancora lì, intonso. Secondo un thread del forum di openSUSE, su MicroOS il relabel lo fa partire `/etc/selinux/.autorelabel`, non `/.autorelabel`; se valga anche per Leap 16 non l'ho verificato, e ti consiglio di verificarlo tu prima di fidarti di quel file.

Messa in fila, la catena che aveva rotto il boot era questa: `systemd` non ha l'etichetta `init_exec_t`, quindi all'avvio PID 1 non passa nel suo dominio `init_t` e resta in `kernel_t` insieme a tutto quello che lancia; in enforcing `kernel_t` non può caricare un modulo `unlabeled_t`, quindi niente `ext4.ko` e niente `/boot`; e `sulogin` non può eseguire una `/bin/bash` che è `unlabeled_t` anche lei, da cui la shell di emergenza senza shell.

Una cosa però non l'ho capita: perché il primo avvio dopo la migrazione sia andato bene, e il guasto sia comparso solo dopo `update-bootloader --reinit`. Le righe `Command line` del kernel in `/var/log/messages` sono identiche prima e dopo la migrazione (`quiet mitigations=auto`, nessun parametro SELinux), e quella del boot fallito lì non c'è, perché rsyslog non è mai partito. Qualcosa è cambiato, e non so cosa.

`audit2why`, davanti a quei rifiuti, suggerisce candidamente di usare `audit2allow` per generare un modulo di policy che li permetta, che sarebbe stato il modo perfetto per nascondere il problema invece di risolverlo: alla policy non mancava nessuna regola, ai file mancavano le etichette. Il relabel l'ho fatto a mano, escludendo gli snapshot, che sono tanti e non vanno toccati, e l'ESP, che è FAT e le etichette non le può avere:

```bash
restorecon -RF -e /.snapshots -e /boot/efi /
rm -f /.autorelabel
reboot
```

Al riavvio `ps -Z -p 1` mostrava `init_t` e i file `unlabeled_t` erano spariti dai log. Ho rimesso `SELINUX=enforcing` e ho riavviato un altro paio di volte: `getenforce` rispondeva `Enforcing` e `ausearch -m avc -ts boot` non trovava niente. Un'ultima prova con F2 e con F12, il Setup e il menu di avvio si sono aperti tutti e due, e ho chiuso il portatile.

## Un firmware di vetro

Ripensandoci a mente fredda, quelle tre voci non avrei dovuto poterle cancellare, o almeno cancellarle non avrebbe dovuto piantare la macchina. Su questo portatile le voci con cui il firmware apre il proprio Setup e quelle che il sistema operativo aggiunge per avviarsi stanno nella stessa lista, con lo stesso formato e gli stessi permessi, e a distinguerle c'è solo il percorso, `FvFile(...)` da una parte e `HD(...)/File(...)` dall'altra. `efibootmgr -B`, da root, cancella le une e le altre senza fare domande.

Quella lista vive in una memoria minuscola che si riempie: la riempiono i bootloader che aggiungono voci a ogni reinstallazione, la riempie il firmware con le voci dei dispositivi che vede, e su questo modello la riempie anche con nomi che si ripetono a cascata. Quando è piena il firmware non te lo dice, semplicemente non salva quello che gli chiedi, e sullo schermo non compare nulla che spieghi perché. Non è nemmeno una novità: nel 2013 alcuni portatili Samsung non si accendevano più quando la NVRAM superava la metà dello spazio, e da allora il kernel Linux controlla lo spazio libero prima di scriverci. Tredici anni dopo questo firmware con la NVRAM piena almeno si accende, e si limita a ignorarti.

Per uscirne ho dovuto sapere che esiste `OsIndications`, smontare il fondo del portatile e togliere il disco, leggere la specifica UEFI, estrarre un'immagine del firmware da un eseguibile Windows e lanciare qualche milione di tentativi. Chi non ha voglia o modo di fare tutto questo porta il portatile in assistenza e si sente dire che il BIOS è rotto, e infatti su Winraid c'è un utente con un IdeaPad 3 che monta lo stesso BIOS E8CN, con lo stesso identico sintomo su F2, e la sua discussione si chiude con il consiglio di contattare Lenovo.

## Un modello linguistico, con criterio

L'avventura l'ho vissuta io, con le mani sul portatile e le decisioni che toccavano a me, ma senza Claude il BIOS lo starei ancora cercando. È stato lui a vedere che il CRC delle `Key####` poteva fare da verifica e a scrivere lo script che l'ha sfruttata; ha anche sbagliato strada più di una volta (Secure Boot, l'usrmerge), e nessuno dei due si è accorto in tempo che stavo cancellando il Setup. Funziona quando le sue risposte si possono controllare, e il CRC è il caso ideale, perché ogni voce ricostruita la confermava la firma stessa prima che scrivessi un solo byte: usato senza criterio, lo stesso modello mi avrebbe fatto finito di distruggere il firmware UEFI e mi avrebbe fatto generare un modulo SELinux con `audit2allow`, sempre che fossi riuscito ad arrivare ad un sistema funzionante.

## Dannati superficiali

Le tre voci le ho cancellate io, e lo dico senza attenuanti: `efibootmgr -v` le mostrava, bastava leggerle. Però un firmware progettato con un *minimo* di cura non si fa togliere il Setup da uno che fa pulizia nella lista di boot. Il mio portatile Asus, che sto usando in questo momento, non ce le ha le boot entry di macchina modificabili. Brava Asus, per una volta.

Ma come ti è venuto in mente, a te progettista di Lenovo (o di Insyde, che il firmware lo scrive mentre Lenovo lo configura e ci mette il logo, e la colpa ve la dividete in una proporzione che non conosco), di mettere il tasto del BIOS tra le voci di boot, in una lista che il sistema operativo può cancellare? Di legarlo a un CRC e poi, quando il CRC non torna, piantare la macchina invece di ignorare il tasto come dice la specifica che dovresti implementare? E se proprio dovevi farlo così, era chiedere troppo un firmware che le sue voci se le ricostruisce da solo?

Che poi, è successo a me per errore, e la maggior parte dei problemi di questo tipo sono dovuti a errore umano, per carità. Ma un malware qualunque con permessi di amministratore poteva danneggiare completamente una macchina senza troppi sforzi. Poi vallo a recuperare senza portarlo in assistenza, che bisogna riflashare via UART il chip, sempre se non lo bruci prima nel tentativo. Ah, ben inteso che non serve SYSTEM eh, a Windows di UEFI non frega niente, la "cosa" che lo modifica è solo un programma che ha bisogno di accesso all'hardware, Administrator va più che bene.

Invece, a voler fare le cose fatte per bene, le alternative c'erano tutte, e costavano pochissimo:

- **Tasti nel firmware**: F2 gestito dal codice del firmware senza passare da una variabile, esattamente come succede con `OsIndications`, che infatti ha funzionato anche a lista vuota.
- **Ricostruzione**: al boot, se mancano le voci del firmware, rimetterle. Sui ThinkPad, a sentire chi ci ha provato, le cancelli e al boot successivo sono di nuovo lì, quindi in Lenovo qualcuno lo sa fare benissimo.
- **Default veri**: F9 che rimette a posto anche le voci, e non solo le impostazioni.
- **Un tasto fisico**: un pulsante o un forellino per la graffetta che porti al Setup senza leggere niente dalla NVRAM. Molti IdeaPad il pulsante ce l'hanno, il Novo, ma l'utente di Winraid racconta che dal menu Novo la voce "BIOS Setup" lo rimanda al menu di avvio, cioè che anche il bottone di emergenza passa dallo stesso punto fragile. E io posso confermarlo perché ci ho provato pure io.
- **Errori visibili**: se la NVRAM è piena, scriverlo. Una riga sullo schermo, niente di più.

Niente di tutto questo è difficile. Era solo più comodo trattare il Setup come una voce di boot qualunque, visto che la specifica lo permette, e non pensare a cosa succede quando qualcuno la cancella. Si chiama superficialità, e la paga l'utente finale.

Ci sono volute tre ore di notte, una mattinata in soffitta, un'oretta la sera, un cacciavite, la specifica UEFI, un modello linguistico, 138.240 tentativi e una secchiata di madonne trigonometriche volanti per rimettere F2 e F12 al loro posto. Esc, all'accensione, continua a non fare niente. Ma pure prima non ho idea di cosa facesse.

## Fonti

- UEFI Forum, [UEFI Specification 2.10, Boot Manager](https://uefi.org/specs/UEFI/2.10/03_Boot_Manager.html), sezioni 3.1.3 (Load Options) e 3.1.6 (Launching Boot#### Load Options Using Hot Keys)
- openSUSE, [Leap 16.0 Release Notes](https://doc.opensuse.org/release-notes/x86_64/openSUSE/Leap/16.0/html/release-notes-leap-160/), sezione su AppArmor e SELinux dopo la migrazione
- openSUSE Forums, ["Press 't' to show menu on this console"](https://forums.opensuse.org/t/press-t-to-show-menu-on-this-console/165019)
- openSUSE Forums, [Selinux causes system to fail during boot](https://forums.opensuse.org/t/selinux-causes-system-to-fail-during-boot/194254), stesso sintomo di `sulogin` su un'altra macchina, con un'altra causa
- openSUSE Forums, [Selinux full autorelabel on every upgrade](https://forums.opensuse.org/t/selinux-full-autorelabel-on-every-upgrade/194213), per `/etc/selinux/.autorelabel`
- Gavin Clarke, [articolo sui portatili Samsung bloccati dalla NVRAM piena](https://www.theregister.com/2013/03/22/uefi_boot_memory_full/), The Register, 22 marzo 2013
- Fedora Discussion, [Numerous boot options in efibootmgr](https://discussion.fedoraproject.org/t/numerous-boot-options-in-efibootmgr-is-this-normal/140273), con le voci `FvFile` di Setup e Boot Menu di un ThinkPad, che il firmware ricrea se le cancelli
- Winraid, [BIOS Setup Access on Lenovo IdeaPad 3 15ADA05](https://winraid.level1techs.com/t/problem-bios-setup-access-on-lenovo-ideapad-3-15ada05/118373), stesso BIOS E8CN, stesso sintomo su F2 e sul menu Novo, senza soluzione
- Lenovo, [download per IdeaPad 3 15ADA05](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/3-series/ideapad-3-15ada05/downloads), che condivide il BIOS con il V15-ADA
- LongSoft, [UEFITool e UEFIExtract](https://github.com/LongSoft/UEFITool)

[^1]: **mazzumàja**: voce del dialetto civitavecchiese, derivata dal campano *mazzàmma*, termine riferito genericamente al pesce minuto e di scarso pregio commerciale. A Civitavecchia indica tradizionalmente il piccolo pescato eterogeneo utilizzato, tra l'altro, per la preparazione della zuppa di pesce. Per estensione, nel parlato locale, *mazzumàja* viene usato anche per indicare un insieme disordinato o eterogeneo di persone o cose. Vedi Giorgio Corati, [La "mazzumàja". Storia, tradizione e attualità della zuppa di pesce civitavecchiese](https://spazioliberoblog.com/2024/07/30/la-mazzumaja-storia-tradizione-e-attualita-della-zuppa-di-pesce-civitavecchiese-pubblicazione-della-societa-storica-civitavecchiese-in-commemorazione-dei-venti-anni-di-attivita-20/), Spazio Libero, 30 luglio 2024.

[^2]: **a tutta callàra**: espressione del dialetto civitavecchiese che vuol dire "a tutta velocità". La *callàra* è la pentola, o il pentolone, che sta sul fuoco (come *caldaia*, dal latino *caldaria*), quindi andare a tutta callàra significa andare a fuoco massimo.
