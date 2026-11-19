---
title: "The Emacs configuration as a document"
date: 2026-11-19 20:37:36+01:00
source_sha: c313054b4a0b259f
---

My Emacs configuration is an Org document of about ten thousand lines, written in Italian and in the first person, which Emacs reads, takes apart and runs at startup. I have been maintaining it for a decade or so, and if in all that time it hasn't turned into a landfill of `setq`s copied from some forum, the credit goes to literate programming: every piece of code sits next to the reason it exists, and I find that reason again when I need it.

After [Emacs in the age of magic]({% post_url en/2026-11-16-emacs-nell-eta-della-magia %}) someone asked to see it. Now you can: an anonymised copy lives in a [gist](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a), in [Italian](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a#file-config-it-org) and in [English](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a#file-config-en-org), and every excerpt on this page comes from there. Clients, employer and personal data are replaced by placeholders starting with `REDACTED-`; the rest is the real file.

{% include more.html %}

## Why a document

I have already written about literate programming in a [dedicated post]({% post_url 2025-04-20-literate-programming-org-mode %}). Applied to a configuration that lives for years, the advantage becomes concrete: an Emacs configuration is a store of decisions (why this package and not the other one, why that variable has that odd value, why that line has to come before that other one), and in bare code the decisions are invisible. After six months nobody remembers them, me included. In a document, instead, they are written down next to the code, and when I change my mind I rewrite the paragraph along with the block.

### Six strokes of the razor

This configuration hasn't always been this long and complex, and to tell the truth it hasn't always been an Org file either.

The story goes back a long way, to around 2009 (almost eighteen years ago, so the memories are a bit hazy). I had recently started the [freax](https://github.com/kLeZ/freax-os) project (poor idea, it died right there, after making me study quite a lot), and those were the years when I was studying compilers, and studying them hard, on my now battered copy of the [Dragon Book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools).

Being a proper nerd, and the epic-level *[yak shaver](https://projects.csail.mit.edu/gsb/old-archive/gsb-archive/gsb2000-02-11.html)* I have always been, from the Dragon Book, which uses Pascal for its examples, I get to [Wirth](https://people.inf.ethz.ch/wirth/), and from Wirth to [Professor Knuth](https://www-cs-faculty.stanford.edu/~knuth/) and his epic, [TAOCP](https://www-cs-faculty.stanford.edu/~knuth/taocp.html). From there to Knuth's story more generally (a great computer scientist, someone I sincerely admire) took just one stroke of the razor, maybe two. Reading the professor's other labours I soon stumble upon WEB and [CWEB](https://www-cs-faculty.stanford.edu/~knuth/cweb.html), then [noweb](https://www.cs.tufts.edu/~nr/noweb/), and so to [literate programming](https://www-cs-faculty.stanford.edu/~knuth/lp.html).

Fascinated by a paradigm so exotic to me, I read everything I can (we are at the fifth stroke of the razor, and I had started from compilers) and end up wondering which implementations of literate programming exist. Org is one of them, [org-babel](https://orgmode.org/worg/org-contrib/babel/) to be precise.

At the sixth stroke I wonder whether the same thing couldn't be done with the Emacs configuration. Until then I had maintained it by hand, with an impressive amount of comments for a configuration script, which often still weren't enough. I find a couple of other emacsers who, as I am doing now, had decided to share their approach with the world, and down the rabbit hole I go. I liked it, I'm comfortable in there, I've even put up curtains.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-6 text-center" markdown="1">
![xkcd comic. Someone asks a guy sitting at a computer what he's working on. He replies: I'm trying to fix the problems I created when I tried to fix the problems I created when I tried to fix the problems I created when...]({% link media/2026-11-19/guide/xkcd-1739-fixing_problems.png %}){: .img-fluid }

*Any old stroke of the razor, seen from the outside. [xkcd 1739, "Fixing Problems"](https://xkcd.com/1739/), by Randall Munroe, licence CC BY-NC 2.5.*
</div>
</div>

First I brought in the configuration I already had: a few packages configured by hand, everything installed with [`M-x package-install`](https://www.gnu.org/software/emacs/manual/html_node/emacs/Package-Installation.html), and at most the odd `(add-to-list 'load-path ...)` for packages downloaded by hand from [EmacsWiki](https://www.emacswiki.org/) and sites like that. Then I looked for a way to get rid of manual installation too, first with [use-package](https://github.com/jwiegley/use-package) and [MELPA](https://melpa.org/), then with [straight](https://github.com/radian-software/straight.el). That led me to rewrite the whole configuration with the installations inside the document, and from then on I can write *why* I install a package, not just how. Once things had settled I wanted to make it reproducible as well, and that's where all the rounds on Emacs startup and Docker came from.

Since that rewrite in Org, the one that made me abandon manual package management for good, about ten years have passed. I discovered [Doom](https://github.com/doomemacs/doomemacs) much later, when I already had something comparable, and I didn't even go near it: I don't need it, and it would be yet another rewrite.

Thanks to two old beardies (Knuth and [Stallman](https://stallman.org/), with affection) today I write in an editor, with a decidedly unusual approach, to maintain the configuration of that very editor. If this isn't a thoroughly entertaining bit of *yak shaving*, I don't know what is.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8 text-center" markdown="1">
![xkcd comic. Some programmers argue about which editor real programmers use, mentioning nano, vim, emacs and cat; one says he uses a butterfly, whose flapping wings deflect cosmic rays so as to write the right bits to the disk; another replies that there's an Emacs command for that too.]({% link media/2026-11-19/guide/xkcd-378-real_programmers.png %}){: .img-fluid }

*Yes, `M-x butterfly` really exists. [xkcd 378, "Real Programmers"](https://xkcd.com/378/), by Randall Munroe, licence CC BY-NC 2.5.*
</div>
</div>

## How it's built, on the inside

It all starts from one line in the document header:

```org
#+PROPERTY: header-args:emacs-lisp :tangle yes :results silent :comments link
```

It means that every Emacs Lisp block, unless stated otherwise, ends up in the extracted file (`:tangle yes`), and that next to every extracted block Org leaves a link to the section it came from (`:comments link`). The rest of the document is prose with the code in between, at the point where the discussion needs it. Any given section, in the source, looks like this:

```org
** Keeping Customize out of init.el

=init.el= must remain the one materialized above, and nothing else.
However, when Emacs saves a variable via Customize, it writes a
=custom-set-variables= block at the end of =custom-file=, and if
=custom-file= is =nil= (the default) it uses =user-init-file=, that is
=init.el= itself.

...

#+BEGIN_SRC emacs-lisp
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
#+END_SRC
```

And in the extracted `config.el` the same block becomes:

```elisp
;; [[file:config.org::*Keeping Customize out of init.el][Keeping Customize out of init.el:1]]
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
;; Keeping Customize out of init.el:1 ends here
```

Those comments are real Org links. I hardly ever look at `config.el`, but if I end up there while debugging, `M-x org-babel-tangle-jump-to-org` from the block takes me back to the section of the document, and usually to the paragraph explaining why that line is there. The backtrace becomes a bibliographic citation, more or less.

The document doesn't only produce `config.el`. Just ask it which other files it generates:

```bash
$ grep -oE '^#\+BEGIN_SRC [a-z-]+ :tangle [^ ]+' config.org | grep -v ':tangle \(yes\|no\)'
#+BEGIN_SRC emacs-lisp :tangle early-init.el
#+BEGIN_SRC emacs-lisp :tangle init.el
#+BEGIN_SRC text :tangle .gitignore
#+BEGIN_SRC dockerfile :tangle Dockerfile
#+BEGIN_SRC text :tangle .dockerignore
#+BEGIN_SRC emacs-lisp :tangle docker-grammatiche.el
#+BEGIN_SRC bash :tangle docker-entrypoint.sh
#+BEGIN_SRC bash :tangle docker-emacs.sh
```

Eight files, plus `config.el`. The entry point, the file that isolates the configuration from the distribution, the `.gitignore`, the container image with its scripts: each one sits in the chapter that explains it, and `C-c C-v t` regenerates them all. None of these files is edited by hand: anyone who wants to change them changes them in the document.

The chapters follow execution order, because blocks are extracted and run in the order they appear and a chapter can only use what was defined before it. Line counts are rounded:

| Chapter | What's inside | Lines |
| --- | --- | ---: |
| Introduction | literate programming, how to work on the document | ~180 |
| Prologue | startup order, `early-init.el`, `init.el`, garbage collector | ~400 |
| Bootstrap | straight.el, use-package, Org bundled with Emacs | ~190 |
| Quick access and utilities | `C-c s` to open the document, reused functions, system prerequisites | ~670 |
| Look and usability | theme, modeline, which-key, Treemacs, server | ~860 |
| Org-mode | agenda, capture, refile, Eisenhower matrix, archive | ~900 |
| Org-babel | executable languages, PlantUML, Ditaa, LaTeX | ~500 |
| org-roam | second brain, journal, full-text search | ~360 |
| Technical writing | Pandoc, Typst, ODT and DOCX, reveal.js | ~920 |
| AI and LLMs | model registry, gptel, agents | ~940 |
| Development | tree-sitter, minibuffer, completion, Eglot, Magit | ~800 |
| Container | Dockerfile and startup scripts | ~320 |
| Cheatsheet | hand-curated data and generated chapter | ~3,000 |
| Epilogue | garbage collector, startup time, package updates | ~80 |

Almost a third of it is the cheatsheet, which has a guide all of its own.

## Startup, step by step

Before reaching the document, Emacs goes through a couple of files I don't control, and one of them cost me yet another stroke of the razor, this time inside `startup.el`.

![Startup sequence: Emacs starts as a daemon with --no-site-file; without that option it would load the distribution's site-start.el, before early-init.el. Then early-init.el removes site-lisp from the load-path, raises the GC to the maximum and switches off package.el; init.el loads Org and calls org-babel-load-file; if config.org is newer than config.el it extracts it again. config.el runs the chapters in order: prologue, straight and use-package bootstrap, chapters by area (a package never cloned gets cloned at the lockfile commit), epilogue. At the end emacs-startup-hook prints the startup time.]({% link media/2026-11-19/guide/g1-sequenza-avvio.svg %}){: .img-fluid }

### The daemon skips `site-start.el`

Distributions install Emacs packages in `site-lisp` and activate them with `site-start.el`, which Emacs loads before any user file. Before, full stop. The docstring of `site-run-file` documents the order (first `site-start.el`, then `early-init.el`, then `init.el`) and the code in `startup.el` confirms it. So `(setq site-run-file nil)` in `early-init.el`, a tip that does the rounds quite a bit, does nothing: by the time it's read, `site-start.el` has already been and gone. The only way to skip it is the `--no-site-file` option on the command line.

My Emacs runs as a systemd service, and I override the unit with a drop-in in `~/.config/systemd/user/emacs.service.d/override.conf`:

```systemd
[Service]
ExecStart=
ExecStart=/usr/bin/emacs --fg-daemon --no-site-file
```

The empty `ExecStart=` line is not a typo: systemd only accepts multiple `ExecStart`s in `Type=oneshot` services, so first I clear the one from the system unit and then I put in mine. The block sits in the document with `:tangle no`, because that file lives outside the repository, but the explanation sits there with everything else.

### `early-init.el` and the which-key affair

Skipping `site-start.el` isn't enough, because `site-lisp` stays in the `load-path` and the distribution's packages stay there, ready to be loaded. I noticed with which-key. Emacs 31 bundles it at 3.6.1, and I was convinced I was using that one. openSUSE, however, also installed its own `emacs-which-key` package, stuck at 3.6.0, and `site-lisp` came before the bundled packages directory in the `load-path`: I was loading the distribution's one without knowing it. On another machine, with another distribution, I would have had another version, or none at all.

That's how `early-init.el` was born, which has its own block in the document with `:tangle early-init.el`:

```elisp
;; Removes every site-lisp directory from the load-path. Without this, the
;; distribution's Emacs packages act as a silent fallback for everything
;; straight does not provide, and the configuration behaves differently
;; depending on the machine it runs on.
(let (pulito)
  (dolist (dir load-path)
    (unless (string-match-p "/site-lisp" dir)
      (push dir pulito)))
  (setq load-path (nreverse pulito)))

;; It was set by openSUSE's site-start.el, which the daemon does not load (--no-site-file).
;; Without it, every warning from asynchronous native compilation opens the *Warnings* buffer.
(setq native-comp-async-report-warnings-errors 'silent)

;; Generous GC during startup: it is already needed here, before init.el starts.
(setq gc-cons-threshold most-positive-fixnum)

;; straight.el manages the packages, package.el must not even initialize.
(setq package-enable-at-startup nil)
```

The `setq` of `native-comp-async-report-warnings-errors` is the price of `--no-site-file`. Whatever `site-start.el` did that I needed, I put back myself, and the document lists one by one the things I decided *not* to put back, with the reason.

### `init.el`, generated by the document

`init.el` is two lines of actual code:

```org
#+BEGIN_SRC emacs-lisp :tangle init.el :comments no :mkdirp yes
;;; init.el --- Loads the literate configuration from config.org  -*- lexical-binding: t; -*-
;; ...
(require 'org)
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
#+END_SRC
```

Two on purpose: if something goes wrong in the document, the entry point stays so simple you can debug it by eye. `org-babel-load-file` compares the dates of `config.org` and `config.el`, redoes the tangle only if the document is newer and then loads the result. As long as I don't touch the document, Emacs reprocesses nothing.

The block header is the interesting part: `:tangle init.el` means the document contains the file that loads it. If I lose `init.el`, I regenerate it from the document. There's something of Baron Munchausen pulling himself out of the swamp by his own pigtail about it, but it works.

## Packages with a lockfile

For packages I use [straight.el](https://github.com/radian-software/straight.el). `package.el` downloads archives from a central repository and gives you the latest version available at that moment; straight clones the packages' git repositories and knows which commit they're at. After the bootstrap, two lines hook it up to `use-package`:

```elisp
;; Install use-package via straight
(straight-use-package 'use-package)

;; Configure use-package to use straight as the default backend
;; This makes :straight t implicit in every use-package declaration
(setq straight-use-package-by-default t)
```

From here on every `use-package` in the document is also an installation instruction. A package is declared in the chapter that explains it, not in a list at the top of the file.

The piece that makes everything reproducible is `straight/versions/default.el`, the lockfile, with the commit hash of each of the hundred or so packages:

```elisp
(("ace-window" . "77115afc1b0b9f633084cf7479c767988106c196")
 ("acp.el" . "2959da5fa8657da17a78ac6ceef303a50e3e69de")
 ("adoc-mode" . "0a09281d337a2512858c096225b60d9e7a0e7911")
 ...
```

I commit it together with the document. When straight clones a package it doesn't have yet, it checks out the commit written there, so on a new machine the packages arrive at the same versions as at home. To update there's a single command, in the epilogue, and until I run it nothing changes:

```elisp
(defun my/update-packages ()
  "Update all packages managed by straight.el. ..."
  (interactive)
  ;; ...
  (straight-remove-unused-repos)
  (straight-pull-all)
  (straight-rebuild-all)
  (straight-freeze-versions t)
  (message "Update completed. Restarting...")
  (restart-emacs))
```

### What Emacs already has

With Org and straight there's a well-known problem. `org-babel-load-file` uses the Org bundled with Emacs to read the document, so that one necessarily gets loaded before everything else; if straight then downloads another one, Org warns of a *version mismatch* with a very long and very polite message listing the four most likely causes. In a literate configuration it's almost always the first one. The simplest solution is not to fight it:

```elisp
;;; Fixes the built-in Org version mismatch by preventing straight from downloading it
(use-package org
  :ensure nil
  :straight (:type built-in))

;;; The built-in Transient in Emacs 30+ is too old, force straight to download it from MELPA
(use-package transient
  :straight (:type git :host github :repo "magit/transient"))
```

Transient goes the opposite way: Magit moves faster than Emacs releases, so I take it from git. And for the packages Emacs 31 bundles at a version equal to or newer than MELPA's there's a dedicated variable, which, unlike `:straight (:type built-in)`, also applies when the package comes in as a dependency of another one:

```elisp
;; Emacs 31 provides these packages at a version equal to or higher than the one on MELPA.
;; By adding them here straight skips them both as a direct declaration and as a
;; dependency of other packages (jsonrpc comes from eglot-java).
(dolist (pkg '(which-key editorconfig jsonrpc))
  (add-to-list 'straight-built-in-pseudo-packages pkg))
```

which-key again, and not by chance: it's the same round of checks that led me to `early-init.el`.

## Prologue and epilogue

The garbage collector changes threshold three times during startup, and each one sits in a different place: `most-positive-fixnum` in `early-init.el`, 100 MB in the prologue, the historical default of about 800 kB in the epilogue (a value from the days when, according to wagging tongues, EMACS stood for *Eight Megabytes And Constantly Swapping*).

```elisp
;; Prologue
(setq gc-cons-threshold 100000000)

(defvar emacs-start-time (current-time)
  "Timestamp of the start of the initialization process.")

;; ... all the other chapters ...

;; Epilogue
(setq gc-cons-threshold 800000)

(add-hook 'emacs-startup-hook
          (lambda ()
            (let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
              (message "Emacs loaded in %.3f seconds with %d garbage collections."
                       elapsed
                       gcs-done))))
```

The final message serves one purpose only: noticing straight away when a new package doubles the startup time. The measurement starts from the prologue and not from `before-init-time`, so it doesn't count `early-init.el` and the loading of Org; for comparing one startup with another, that's fine.

## The same configuration, in a container

With `early-init.el` the configuration no longer depends on `site-lisp`, but it still depends on what's installed: Java, pandoc, typst, a C compiler. On a machine where I can't install anything (a client's, a server without root) those things aren't there. For those places the document also generates the `Dockerfile` and the scripts for a container image, with Emacs, the system prerequisites and the entire package tree already cloned and compiled. Outside, as volumes, stay `~/org`, `~/.gnupg` and `~/.password-store`; API keys arrive via environment variables and are never written into the image. Anyone who says Emacs is a great operating system lacking only a decent editor now has one more argument, seeing as it even has its own container image.

The delicate step is the build, because an image that clones packages from the network gives you two different environments a month apart. The `Dockerfile`, extracted from the Container chapter, solves it like this:

```dockerfile
# Provisioning: pin the versions from the lockfile, then load the whole
# configuration. This clones and compiles the packages, downloads the PlantUML,
# Ditaa and Lombok jars, and compiles the tree-sitter grammars. At the end the
# image no longer needs the network to start.
# Note: shallow clones (straight-vc-git-default-clone-depth 1) would
# save 340 MB of git history, but they break straight-thaw-versions, which
# needs "git branch --track" and in batch fails with no remedy.
# Reproducibility from the lockfile is worth more than space: full clones.
RUN emacs --batch -l ~/.emacs.d/early-init.el -l ~/.emacs.d/init.el \
          --eval '(straight-thaw-versions)'
```

The same lockfile as the machine at home, so the same versions. The chapter also tells the story of the first failed build: the base image had Emacs 30.2, while on the host 31.1 comes from an OBS repository I had set up so long ago I'd forgotten about it, and an innocuous `add-hook` blew up when straight opened the first elisp file to compile.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-6 text-center" markdown="1">
![xkcd comic. The "theory" graph shows that automating a task takes some work and then frees up time; the "reality" graph shows that the work of automating grows without end and the original task never gets done.]({% link media/2026-11-19/guide/xkcd-1319-automation.png %}){: .img-fluid }

*Anyone with an Emacs configuration recognises the second graph. The Container chapter is a textbook example. [xkcd 1319, "Automation"](https://xkcd.com/1319/), by Randall Munroe, licence CC BY-NC 2.5.*
</div>
</div>

## Instructions for the agent

For about a year now I've often been editing the configuration together with an LLM agent. Out of ten years of work it's the latest arrival, and it has made me go faster; it hasn't made me able to do it. An agent on a ten-thousand-line document does damage as fast as it does useful things, if nobody tells it how the place is laid out.

In the configuration folder there's an `AGENTS.md`, in English, which I don't publish. It contains the stable facts of the repository, the ones I'd give a new colleague on day one: you always edit `config.org` and never `config.el`; the prose is in Italian, in the first person, in my voice; a new package goes in the chapter that covers that topic, with the paragraph explaining it before the block; paths go through `expand-file-name`. There's the table of reserved key prefixes (`C-c n` for org-roam, `C-c l` for AI, `C-c m` for the Eisenhower matrix and so on), because otherwise every new command lands on the first free key and after a few months the keyboard turns into a *fruit machine*: you press a combination and you don't know what comes out; maybe it's your lucky spin and you hit the right function, maybe you've lost and you unleash something else entirely. And there are the two batch commands the agent must run before saying a change works, namely the tangle and a full test startup. At the bottom, the list of mistakes already made: for example, never `batch-byte-compile` on `config.el`, which without `init.el` doesn't start straight and produces fifty fake errors that an overzealous agent would set about "fixing".

The commit stays mine, after trying the change in a real session: the batch tells you the configuration loads, not that it does what I wanted.

The piece that matters most, though, isn't in the folder. It's the system prompt, the general instructions that apply to every session and every project: how to write, when to stop and ask, what not to decide on its own, how far to go. I don't publish it. But if there's one thing to do with an LLM, local or in the cloud, it's to write your own: that's what calibrates the level at which the tool performs, far more than the model you pick.

## In slides, too

Being a document, it exports: HTML, PDF, ODT, Markdown and [reveal.js](https://revealjs.com/) presentations with [org-re-reveal](https://gitlab.com/oer/org-re-reveal). The text has about 260 `#+REVEAL: split` lines that break long sections into several slides, and `C-c C-e R R` does the rest. reveal.js is handled by straight like any other package, and the lockfile pins its commit like all the others, so the presentations work offline too:

```elisp
(straight-use-package
 '(reveal :type git
          :host github
          :repo "hakimel/reveal.js"
          :files ("*.html" "*.js" "css" "dist" "plugin")))
```

Until recently the recipe also had a `:ref "4.5.0"`, with the comment "specific tag pinned for stability". Shame that `:ref` is elpaca syntax: straight only knows the keywords in `straight-vc-git-keywords` and silently ignores the rest. The README spells it out: to pin a commit you use the lockfile. Meanwhile reveal.js had quietly climbed to 6, one `my/update-packages` after another, and I was convinced I had it frozen at 4.5.

When a colleague asks me how I keep a contraption like this standing, opening the configuration as slides and scrolling through it together answers better than any explanation.

## Sources

- Donald E. Knuth, ["Literate Programming"](https://doi.org/10.1093/comjnl/27.2.97), *The Computer Journal* 27(2), 1984, pp. 97-111.
- Eric Schulte, Dan Davison, Thomas Dye, Carsten Dominik, ["A Multi-Language Computing Environment for Literate Programming and Reproducible Research"](https://doi.org/10.18637/jss.v046.i03), *Journal of Statistical Software* 46(3), 2012: the org-babel paper.
- Jeremy H. Brown, ["Yak Shaving"](https://projects.csail.mit.edu/gsb/old-archive/gsb-archive/gsb2000-02-11.html), email to the MIT AI Lab, 11 February 2000: the origin of the term, attributed to Carlin Vieri.
- [Gist with the anonymised `config.org`](https://gist.github.com/kLeZ/90fa00738ae44a0d8efc73e10d3e597a), in Italian and in English.
- [Org mode, "Extracting Source Code" (tangle)](https://orgmode.org/manual/Extracting-Source-Code.html), Org manual.
- [GNU Emacs Lisp Reference Manual, "Startup Summary"](https://www.gnu.org/software/emacs/manual/html_node/elisp/Startup-Summary.html), loading order of the startup files.
- [systemd.service, `ExecStart=`](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#ExecStart=), clearing and multiple commands.
- [straight.el](https://github.com/radian-software/straight.el), git-based package manager, section on lockfiles.
- [org-re-reveal](https://gitlab.com/oer/org-re-reveal) and [reveal.js](https://revealjs.com/).
- Randall Munroe, ["Automation"](https://xkcd.com/1319/), xkcd 1319, CC BY-NC 2.5.
- Randall Munroe, ["Fixing Problems"](https://xkcd.com/1739/), xkcd 1739, CC BY-NC 2.5.
- Randall Munroe, ["Real Programmers"](https://xkcd.com/378/), xkcd 378, CC BY-NC 2.5.
