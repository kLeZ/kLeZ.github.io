---
title: Grazie Travis CI, meno grazie a GitHub
tags: [ "travis-ci", "github", "questo blog", deployment ]
date: 2019-03-14 20:05:00+01:00
---

Sta sera ho quasi avuto il _panico_, quello che si prova quando **sminchi**[^1] produzione, quello che hai quando sai di averla fatta te la _cazzata_, il commit maledetto che non ci doveva stare.

{% include more.html %}

Fortunatamente Travis CI è un ottimo prodotto. GitHub Pages lo è un po' meno.

Non sapere il perché la build fallisce **dentro GitHub**, perché lui comunque effettua una build del tuo sito già bello e costruito dal buon Travis, non è una bella cosa, lo è ancora meno quando cerchi l'informazione e non la trovi.

Si perché se c'è una cosa che ci insegnano da piccoli a noi informatici è che devi cercare i log per capire cosa non va. E i log non c'erano, nemmeno l'ombra. Maledetto, mi dici che ti fallisce la build e non mi dici perché.

A questo punto ho avuto l'illuminazione: posso escludere GitHub dalla build e fargli mangiare il sito già cotto da TravisCI? Fortunatamente la risposta a questa domanda era si, GitHub permette di pubblicare siti statici direttamente su master.  
Quindi potevo semplicemente riconfigurare TravisCI in modo da fargli fare il deploy solo della cartella di output e non di tutto il repo come facevo prima.

1 a 1 palla al centro, che dalla mia parte ho avuto un buon assist di TravisCI ma un pessimo autogol di GitHub.

Anche oggi produzione è salva e mi sono meritato la cena, buona notte.

[^1]: **sminchiare**: termine tecnico del vocabolario informatico che indica l'operazione di rompere inesorabilmente e completamente l'ambiente di produzione
