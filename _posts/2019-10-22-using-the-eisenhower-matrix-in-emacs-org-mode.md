---
title: "Using The Eisenhower Matrix In Emacs Org-Mode"
tags: 
date: 2019-10-22 16:18:35+02:00
---

Riporto integralmente l'articolo di Tom Purl che parla dell'integrazione della matrice di Eisenhower in Emacs Org-Mode.

Purtroppo Tom ha rimosso l'articolo dal suo sito ma sono riuscito comunque a trovarlo tramite la [Wayback Machine](https://web.archive.org/web/).

Di seguito (in inglese) l'articolo integrale. Forse (**forse**) porterò una traduzione di questo articolo nel blog, a imperitura memoria, soprattutto per chi non mastica granché l'inglese.

{% include more.html %}

I just finished reading the [The Procrastination Matrix] article on the [Wait But Why] blog and it really spoke to me. I'm a big fan of using [Org-Mode] in Emacs to organize all of my tasks, and I wondered if I could make both of these systems work together. Naturally, Org-Mode makes it really easy, and here's how I did it.

## Easy Tagging

First, I need to be able to categorize my TODO's as being urgent, important, or both. The easiest way to do this in Org-Mode is to use tags that looks something like this:

```
** TODO Pay bills                                                    :urgent:
```

You can easily add tags using the `C-c C-c` command, but I like to make things even easier by using the `org-tag-alist` variable:

```elisp
(setq org-tag-alist '(("important" . ?i)
                    ("urgent"    . ?u)))
```

Now when I tag a TODO item, I simply need to type `i` or `u` to tag it as important and/or urgent.

## Canned Searches

Now that my TODO's are tagged I would like to be able to look at all 4 quadrants quickly and easily. I can do this in Org-Mode by setting the value of the `org-agenda-custom-commands` variable. Here's what I have:

```elisp
(setq org-agenda-custom-commands
   '(("1" "Q1" tags-todo "+important+urgent")
     ("2" "Q2" tags-todo "+important-urgent")
     ("3" "Q3" tags-todo "-important+urgent")
     ("4" "Q4" tags-todo "-important-urgent")))
```

Q1 stands for "quadrant 1" and contains all TODO's that are tagged as both important and urgent. Q2 contains all of the TODO's that are tagged as important but not urgent. And the rest should be pretty self explanatory.

Now when I press `C-c a` I see my usual agenda search dialog with the following lines at the bottom:

```
1    Q1        : +important+urgent
2    Q2        : +important-urgent
3    Q3        : -important+urgent
4    Q4        : -important-urgent
```

I can then see all of the tasks for a given quadrant by pressing the corresponding number.

## That's It!

Once again Org-Mode has proven itself to be very easy to customize. It literally does everything for me but complete my tasks and show the [Instant Gratification Monkey] who's boss.


[The Procrastination Matrix]: https://waitbutwhy.com/2015/03/procrastination-matrix.html
[Wait But Why]: https://waitbutwhy.com/
[Org-Mode]: https://orgmode.org/
[Instant Gratification Monkey]: https://waitbutwhy.com/2013/10/why-procrastinators-procrastinate.html
