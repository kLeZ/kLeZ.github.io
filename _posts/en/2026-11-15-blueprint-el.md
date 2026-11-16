---
title: "blueprint.el: documenting architecture, before and after the code"
date: 2026-11-15 01:56:06+01:00
source_sha: efd528d0979ce370
---

Today I'm introducing [blueprint.el](https://github.com/kLeZ/blueprint.el), an Emacs package I wrote for a job I do often and that, let's say, nobody is exactly wild about: rebuilding the architectural documentation of software systems that don't have any, starting from the code. That's where it was born, but the method it carries with it works just as well from the other side, when the code doesn't exist yet and you're the one designing the architecture. It's all text, all Org, and it works perfectly well by hand. But it's designed for a team: several people, or several agents, working on it together, each on their own piece, leaving only the decisions to whoever is coordinating.

And I'm proud of it, I'll say that up front. A job like this, in Word, is simply unthinkable, and blueprint gave me an effective, goal-focused way of organising it, and one way or another it has to be organised anyway.

{% include more.html %}

## The problem

Anyone who works as an architect or consultant on existing systems knows the scene by heart. You arrive on the project, you ask for the documentation, and they hand you a wiki frozen three years ago, a couple of hand-drawn diagrams by someone who left ages ago, and the code. The code is the only source that tells the truth, and everything has to be rebuilt from there: what the components are, how they talk to each other, what they do for the business, what infrastructure they run on and what risks they drag along with them.

I've done quite a few assessments by now, I have a fair bit of experience. You arrive and most of the time you don't even know where the problem is: in one case the problem was neither the software nor the documentation (well, the software maybe, but let's say that for all its antiquity it was decently written and worked the way you'd expect), but rather the way the company was run. The company had literally been born around the software, which was its core business, and the people developing it not only had no human backup that would at least let them get ill or go on holiday, they didn't even have any processes for keeping their skills up to date. In 2020 they were basically still developing like it was '98.

Another assessment led me to discover that it wasn't that the documentation didn't exist, there was even too much of it, but it was scattered across scribbled notes and Excel files all over the place, including folders that were neither versioned nor synced on the company PCs of the consultants working there. Disorder and chaos reigned so supreme that the client was complaining about a lack of documentation when the problem was *governance*.

Yet another had the classic core business software that had been maintained for 30 years, chock-full of decisions, second thoughts, regulations that had managed to be born and die in the meantime and functional processes that were *Machiavellian* to say the least. Without a shred of documentation, obviously. Rebuilding everything in cases like this means playing the archaeologist, the archivist, the codicologist who, instead of 16th-century codices, is staring at code from the late '90s at best (of the 20th century).

In all of these cases, knowing first of all *what* to document and only afterwards *how* to document it is essential, and blueprint helped me enormously in some of these situations (not all of them, because back when the first ones happened it didn't exist yet, but from experience I know for certain it would have been useful in every one). And tools that do this simply don't exist.

You can take Word, or even Emacs itself with org-mode, and they're just writing tools. A tool that helps with the inventory, that organises the areas cleanly, that provides a ready-made model you can learn to know and that can also guide the early stages of discovery, that can also follow the non-functional and non-technical threads you so often end up having to deal with, is a complete tool and a methodology before it's a piece of software. The most important part of blueprint is the method, then the model, and finally the software that holds them together and enriches them. And the method, in practice, is everything I've learnt designing complex systems and rebuilding their documentation after the fact, condensed into a file structure.

The same problem, seen from the other side, belongs to anyone designing a system right now. On day one the documentation doesn't exist either, and if you don't set it up with a method you'll find yourself ten years from now in one of those three cases, except this time the code you start the assessment from is code you wrote.

To give the result a shape I use [arc42](https://arc42.org/), an architectural documentation model divided into standard sections, and its breakdown is the fundamental part of blueprint's model, because each section also tells you which diagram is needed and who it's for. I draw the diagrams with two notations together: the [C4 model](https://c4model.com/), which describes a system at increasing levels of zoom (context, container, components) and is the handiest for the high-level overview, and [UML](https://www.omg.org/spec/UML/) for the detail. But arc42, C4 and UML are methods: they tell you what to write and how to draw it, not how to keep standing a document of hundreds of pages written by several people, or several agents, at the same time. That remains your problem, and it's exactly the problem blueprint solves.

## From Python to Elisp

The first version was a Python script, `scaffold.py`, that generated the document structure, managed the components, the glossary and a report on open points, and finally called Pandoc for the export. It worked, and worked well too. Only, I was already doing all the rest of the work inside Emacs, and every time I found myself leaving the editor to run a script that opened, read and rewrote Org files, which is exactly what Org has been able to do on its own for more than twenty years. Basically a round of snakes and ladders that lands you back on square one.

So I rewrote it in Emacs Lisp, with four ground rules I put in the README from day one. Full feature parity with the script, without the "it's just a prototype for now, we'll see later" excuse (we all know how that ends). Proper Elisp, which means working on Org's syntax tree with `org-element` instead of hammering away with regular expressions, and using Org's exporter instead of Pandoc. No mandatory dependencies beyond Emacs 29 and Transient, which already ships with Emacs, while PlantUML and Graphviz are only needed if you want the diagrams actually drawn. And everything in plain text, versionable, with no databases or external services in the way.

Along the way the name changed too. "scaffold" smelled too much of a CRUD generator, whereas "blueprint" says better what it is: a tool for reasoning about the architecture of a system.

## What a project looks like

A project is initialised in the job's folder, and what comes out is this:

```text
master.org
glossary.org
references.org
enterprise/
  context.org
  dependencies.org
nfr/
  quality-scenarios.org
  constraints.org
  risks.org
.blueprint/
  blueprint-version.org
  components/
    ordini/
      arc42.org
      functional.org
      infrastructure.org
```

The final document is `master.org`, which pulls in all the other files with `#+INCLUDE:` directives. It's divided into six parts, and each has its declared audience: the preliminaries are for everyone, the enterprise architecture for executives and senior architects, the per-component architecture for developers, the functional specifications for analysts and product owners, the infrastructure inventory for whoever runs the servers, and finally non-functional requirements, constraints and risks for architects and management. That way everyone reads their own part without having to wade through all the rest.

The heart of it all is the components. Each has its own folder with three self-contained files: `arc42.org` for the architecture, `functional.org` for the functional specifications and business rules, `infrastructure.org` for the inventory of machines, network and access. Dependencies between components are declared with a line at the top of the file:

```org
#+BLUEPRINT_DEPENDS: auth database cache
```

From these lines blueprint generates the C4 container diagram in [PlantUML](https://plantuml.com/) and a dependency graph in Graphviz, with the nodes coloured according to each component's health status. So nobody draws the dependency diagram by hand, and it doesn't go stale while the code changes.

All the other diagrams follow arc42's breakdown, and each has its place in the component template. C4 provides the overview: the context diagram sits in the section on scope, the container diagram in the building blocks, and the component level arrives when the complexity calls for it. The detail, on the other hand, comes from UML. Every runtime flow has a use case diagram, for non-technical people, and a sequence diagram, for the technical teams, and business processes with several actors become activity diagrams with a swimlane per actor. In my work I add entity-relationship diagrams for the data model and state diagrams for the more convoluted flows. Put together, C4 at the second or third level and UML describe a component with an impressive level of detail. And it's all PlantUML inside Org source blocks, which means text, versioned along with everything else; two commands, `blueprint-runtime-add-flow` and `blueprint-runtime-add-process`, create the subsection for a flow or a process with the diagrams already set up.

The document templates aren't hard-wired into the package, because during an assessment the structures change all the time. blueprint looks for them in three places, in this order: the project folder, your personal configuration, and only at the very end the system templates that come with the package. The first one it finds wins, and if the system one isn't enough for you, you clone it into the project and adapt it to that specific job.

## The health score

While you write a document like this you leave open points everywhere: things to check, questions for the client, sections to revisit. blueprint treats them as markers in the text, and gives each one a weight:

| Marker             | Meaning                                                | Weight |
| ------------------ | ------------------------------------------------------ | -----: |
| `FIXME`            | something wrong that needs fixing                      |      4 |
| `QUESTION`         | an open question                                       |      3 |
| `TBD`              | to be defined                                          |      2 |
| `[DA VALIDARE]`    | written but not yet verified with the client           |      1 |
| `[DA REVISIONARE]` | to be reread                                           |      1 |
| `[FINDING]`        | a discrepancy found (a result of the assessment)       |      0 |

{% katexmm %}

The sum of the weights is the penalty, $p$. But the score mustn't collapse just because the document grows, so the penalty is compared with the size of the text: with $W$ exported words and one point of "credit" every 100 words, i.e. $U = W/100$, the score $s$ is

$$s = \operatorname{round}\left(100 \cdot \frac{U}{U + p}\right)$$

A 10,000-word document has $U = 100$: with 20 penalty points it sits at 83, and the same document with 100 points drops to 50. Only the markers in the text that the export actually shows count, so those in comments, code blocks or excluded sections carry no weight.

{% endkatexmm %}

The formula wasn't born like this. At first the score started from 100 and subtracted absolute penalties without looking at how much text there was around them, and on a document that had grown nicely hefty it was stuck at 37. Like a good chunk of the package's recent roadmap, the fix came out of using it.

I say it straight away in the README: it's more an incentive to close the open points than a rigorous metric. But it works, and you can even show the client the SVG gauge that displays it during a review.

## By hand, like Magit

Everything goes through a [Transient](https://docs.magit.vc/transient/) menu on `C-c b`, the same menu system as Magit: you press a key and see all the commands grouped by topic, without having to remember dozens of shortcuts after two weeks of not opening the project.

Then there's a Magit-style dashboard, with one row per component and one for every other file in the document: owner, technology, scope, marker count, penalty, score. `RET` opens the file for that row. There's a mode that shows only the components that need attention, a command for the morning routine that takes you from the dashboard to the document to edit in a few keystrokes, guided procedures for creating projects and components, management of the glossary, references, open questions and architecture decision records (ADRs), a linter, and export to PDF, ODT, HTML and DOCX. The ODT respects the corporate template specified in `master.org`, and it's the one I use almost always, because clients want the document in their own template, and heaven help you if you touch it.

## Before the code

blueprint was born to play the archaeologist, but its structure is so unobtrusive that it fits perfectly inside the source repository: you run `M-x blueprint-init` in a `docs/` folder and the documentation lives next to the code, versioned along with it. From there it becomes a design tool. The markers change meaning without changing weight: a `TBD` is a piece still to be designed, a `QUESTION` is a question to ask the product owner, and the health score tells you how much of the system is still to be decided.

It also goes well with an agile process. Creating a component and describing it at the level of detail blueprint proposes is exactly the documentation you produce from one sprint to the next, and that you hand over to development when it's complete, i.e. when there are no `TBD`s or `QUESTION`s left in the component. In my opinion starting a new project with blueprint brings huge advantages, even though so far I've only properly battle-tested it on assessments.

## With a swarm of agents

blueprint doesn't contain a language model. There's an optional integration with a local Ollama for the odd suggestion, but it's an accessory. What makes it suitable for agents is its shape, the same shape a team of people working in parallel needs: agents are just the extreme case, many and very fast.

### Separate zones

Three files per component, one file for each cross-cutting part, and in every file recognisable sections and tags. One agent takes a component's three files and works on them on its own, another does the same on another component, a third takes care of the glossary and sources. They don't tread on each other's toes because they don't touch the same files, and if two of them really do get their hands on the same file, git notices.

### Everything from the command line

Coding agents live in a shell, and every blueprint function can be called from there, without even opening Emacs:

```bash
emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el \
  --eval '(blueprint-add-component "ordini")'

emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el \
  --eval '(blueprint-add-question "ordini" "Chi autorizza il rimborso?")'
```

### The agent checks itself

Then there are the commands designed for CI, which print the result and exit with a precise code: 0 if all is well, 1 if there are warnings, 2 if there are errors.

```bash
BP="emacs -Q --batch -L /percorso/di/blueprint.el -l blueprint.el"
$BP -f blueprint-ci-lint         # sezioni mancanti, dipendenze appese
$BP -f blueprint-ci-validate     # lint, salute, dipendenze
$BP -f blueprint-ci-export       # il documento finale
$BP -f blueprint-ci-export-json  # rapporto in JSON
```

The last one writes a JSON report with the health score, each component's markers, the dependencies and the linter warnings. For an agent it's a snapshot of the project in a format it reads on the fly.

### The markers say what's missing

A `TBD` tells the agent what's still to be written, a `[DA VALIDARE]` what it wrote without being able to verify it. A `QUESTION`, on the other hand, is the point where the agent stops and the ball goes back to a person: who authorises a refund, which of the two flows is the real one, whether that server is still in scope. Everything else can carry on by itself.

## With or without agents

Even doing everything by hand, blueprint is definitely better than opening Word and starting to type. After all, these are documents that can run to a few hundred pages (I'd remind you that the Italian edition of Dr Jekyll and Mr Hyde runs to just over 300). Word is certainly not the right tool for manuscripts of that size. But even with Emacs and blueprint it still takes an eternity, because the heavy lifting of discovery and writing the text is there regardless of which tool you use.

In my view, with blueprint, the time can even be cut in half, and that alone is enough for me to say it's a good project. Built into the right processes it can make the difference, and it can help do an assessment, which is an ugly job in itself, the way *the good ones* do it.

Tomorrow, when this damned bubble has burst, hopefully in a better world and on an Earth that's still healthy, and AI agents are less available (because they'll finally cost what they should, given that today the companies renting them out to us are doing it *at a loss*), this will still be an organisational structure that works with a team of human beings, both for an after-the-fact assessment and for maintaining the documentation of your own project (the blueprint method works even better on a *green field* project).

## Written with an agent

I wrote blueprint working with an agent, and the repository wears it openly: of the 62 commits made since 22 February 2026, 17 have Claude as the author. Today it's about 9,600 lines of Elisp split across 36 files, plus 29 test files with ERT, the testing framework Emacs already carries in its belly.

The repository also contains everything an agent needs to work on it: an `AGENTS.md` with the commands for running the tests and the project rules, a `CONTEXT.org` with the state of the work, a `PLAN.org` with what's left to do, and the architecture decisions in `docs/adr/`. They're the same files I need to pick the work back up after weeks away, and that's precisely why they work for the agent too.

I'm notoriously someone who treats agents badly: I go from reminding them that they're "damned machines" or "damned pieces of rusty scrap metal" to threatening to switch provider, to pointing out, more often than it's edifying to admit, that I'm the human and they're certified idiots. I don't do it out of sadism (well, maybe a bit, perhaps for fun, like with Eliza when I was little) but because they need correcting and they don't get nuance very well, so you have to be direct, pedantic, explicit. My wife often reminds me that I'm like that, except she does it by pointing out that it's a flaw, and on top of that she's the one in charge at home, like every woman in every home in Italy, so in that case I'd be the harness (but with fewer insults, thankfully).

But with Claude I'm the leader (as Napoleon used to say), so I'm the one who decides when we attack, when its code isn't good enough and when it had better go for a walk because the code it wrote is rubbish.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8" markdown="1">
![Still from The Aristocats. Napoleon, the hound, shot from below in front of a wooden barn door, at night: furrowed brow, muzzle raised, with the look of someone who has just decided it's time to attack.]({% link media/2026-11-15/aristocats-disneyscreencaps.com-2110.webp %}){: .img-fluid }
*"I'm the leader, and I'm the one who decides when we attack. Charge!" Napoleon in the Italian dub of* The Aristocats *(1970), directed by Wolfgang Reitherman, Walt Disney Productions.*
</div>
</div>

## What's missing

The health score is simple on purpose, and anyone looking for a serious metric of documentation quality should look elsewhere. The package is young and I maintain it on my own. Templates and methodology are in Italian, because that's the language I work in: the code and README are in English, but anyone wanting to use it in another language would have to start from the templates.

The repository is on GitHub, under the MIT licence. In the `examples/` folder you'll find a complete assessment of a warehouse management system invented out of thin air, with its diagrams and the ODT export.

## For archaeologists and designers

If you too find yourselves playing the archaeologist on late-'90s code, with a client who wants to know what they've got in the house and nobody who remembers any more, give it a try. And if instead you're starting a new project, try it all the more: one `blueprint-init` in the repository's `docs/` folder, and the documentation grows along with the code instead of having to be rebuilt ten years from now. It also works without agents, by hand, with the menu and the dashboard. In my head the order remains the one I wrote at the start: first the method, then the model, then the software, and only at the very end, maybe, the agents. If you start from the swarm without having understood the model, you end up with a pile of files written in a hurry and no idea what's in them, which is exactly the situation you started from.

I read every bug report and suggestion on GitHub. And if anyone uses it on an assessment of their own, or on a project starting from scratch, I'd genuinely love to hear about it, if only to understand which of my obsessions are useful to everyone and which are just mine.

## Sources

- [blueprint.el](https://github.com/kLeZ/blueprint.el), repository on GitHub, with README and `USAGE.org`.
- [arc42](https://arc42.org/), architectural documentation model.
- [The C4 model](https://c4model.com/) by Simon Brown.
- [UML](https://www.omg.org/spec/UML/), the Object Management Group specification.
- [PlantUML](https://plantuml.com/), diagrams from text.
- [Transient](https://docs.magit.vc/transient/), Magit's menu system.
