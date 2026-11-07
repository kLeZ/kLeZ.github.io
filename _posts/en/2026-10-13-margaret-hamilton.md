---
title: "Margaret Hamilton. What she brought to engineering, and why she matters (and not because she was a woman)"
tags:
  - ingegneria-del-software
  - informatica
  - storia
  - società
date: 2026-10-13 13:24:31+02:00
source_sha: 98393b4cd4965cb0
---

Margaret Hamilton died on 30 September, aged 90. MIT announced it a week later, and since then that photo has been doing the rounds again: her, young, big glasses, standing next to a stack of paper as tall as she is. The caption usually stuck on it says that this is the code that put man on the Moon, and that she wrote it.

The photo is real. The caption much less so, and the real version is a better story. I'm a software architect, and a good part of my job consists of taking for granted that sooner or later somebody will get it wrong (me first). That idea has a precise origin, and her name is on it. I owe her a piece done properly, with sources, including the ones that don't flatter her.

It goes out today, 13 October, and the date couldn't be better if I'd planned it, as we'd say where I'm from. The second Tuesday of October is *Ada Lovelace Day*, the day that since 2009 has celebrated the work of women in science and technology (Suw Charman-Anderson came up with it, because there weren't many female role models to be seen). Usually on these occasions people swap holy cards. I'd rather write.

{% include more.html %}

## That stack holds the work of hundreds of people

{: .text-center }
![Margaret Hamilton in 1969, standing next to a stack of printed listings of the Apollo onboard software, as tall as she is]({% link /media/2026-10-13/margaret-hamilton-listati-apollo-1969.jpg %}){: .img-fluid }

*Margaret Hamilton in 1969 next to the listings of the Apollo onboard software. Photo by the Draper Laboratory, restored by Adam Cuerden, public domain, via Wikimedia Commons.*

I'll start with the paper. The MIT caption, and MIT has the photo in its archive, says these are the *listings* of the software of the two onboard teams, the lunar module one and the command module one, photographed in 1969. Don Eyles, one of the authors of the landing code, recalls that the listing of a single program was often around fifteen centimetres thick. You do the maths on how many programs and how many revisions fit into a stack like that.

So she didn't write all of it. As an architect, I know this part well: I write far more documents than code, and the software that comes out of my team is still my stuff, for better and especially for worse. If she was leading that work, that stack is hers. Whether she typed a hundredth of it or half makes little difference.

One detail, while we're at it. That code was handwritten in the most literal sense:

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> We would write things by hand on coding sheets, then we would give them to keypunchers who would punch them.

I'll come back to who punched the cards later.

Feeling ownership of code written by others happens to anyone who, by trade, designs more than they program. Designing means describing how something should work and handing that description to whoever will build it (it's clearer with buildings: the architect doesn't lay a single brick of the block).

It happened to me years ago, on a job whose name and client I can't mention. There was an old desktop program, left without maintenance, that had to be rebuilt. I was handed a folder of black-and-white screenshots, unnumbered and with no documentation, plus a lad fresh out of the box: "You've got to redo it in three months, he'll help you." For three months I was trainer, designer, programmer and the bloke who goes to meetings to work out what the client really wants (spoiler: neither does the client). We delivered on time. The code was mostly written by him, I corrected it, and there was probably less than 30% of the lines in there that were mine. It was still my stuff.

The stack in the photo was hers in the same way. Except mine didn't have to put anyone on the Moon.

## She started where a mistake set the sirens off

She was born in Paoli, Indiana, in 1936. She graduated in maths, with philosophy as a minor, from Earlham College in 1958. She never studied computer science, for the excellent reason that there was nothing to study.

In 1959 she arrives at MIT and ends up working with the meteorologist Edward Lorenz on an LGP-30, a valve computer the size of a desk and as noisy as a propeller plane. When she had to fix a program she would unroll the punched tape down the corridor and modify it with a sharpened pencil: a hole to make a 1, a bit of sticky tape to make a 0. Lorenz found this highly amusing.

In 1961 she moves to Lincoln Laboratory, on the SAGE air defence system. That's where the thing happens that, in my view, explains everything else. When a program crashed the computer, the machine let the whole building know with sirens and foghorn noises. Operators and programmers came running to see *whose* program it was. She tells the story herself, and adds that it was no secret who the culprit was, seeing as they were standing in front of the console.

Try picturing your last production bug announced like that.

## She held everybody's code together

In 1965 she joins the MIT Instrumentation Laboratory, which holds the NASA contract for the Apollo onboard software. Her first assignment is given to her because she's the newest arrival: write the program that kicks in if an uncrewed mission aborts, which it never will anyway. She calls it *ForgetIt*. The mission aborts, the program runs, and she becomes, in her words, an expert overnight.

From there she moves on to what they called *systems software*. And this is where the story starts to sound familiar. The two vehicles, the command module and the lunar module, had two separate programs, but part of the code was shared: the scheduler, restarts, alarms, the routines that handle the astronaut's display. In the Apollo 11 source, which now lives on GitHub, I counted 49 modules with the same name in both programs. In 25 of them, comments stripped out, less than one line in ten differs, and the scheduler and display routines are 98% identical or more. One of them contains documentation for whoever has to use it, and that someone is called *the user*.

A library, basically, with its own manual. And anyone who maintains a library everybody uses knows how that ends.

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> The systems software was shared by the command module software and the LEM software. [...] Everybody went through it.

Her team was about 100 people. Around them were another 300 or 400, guidance and navigation engineers delivering their own piece, whom she called *guests* (in private, she specifies). The guests thought about their own algorithm and nothing else: they didn't care whether their priority trod on someone else's toes, or whether they were using the same memory as somebody else at the same moment. That was her problem.

Once she put one of her changes to the systems area straight into the day's release and broke everyone's programs. She found them queuing outside her door. From that mistake she drew two rules: changes get tested first in a separate version, and every day a memo goes out saying what went into the release. Those memos still exist. One, dated 2 May 1968, begins like this:

> citation "M. Hamilton, COLOSSUS Memo #56, 2 maggio 1968" [https://www.ibiblio.org/apollo/Documents/COL56.pdf]
> Revision 200 was BAD.

Twenty numbered changes follow. Anyone who has ever written a changelog will recognise the genre.

Then there's the code. In the command module listing that flew on Apollo 11, next to the flag that governs *priority displays*, the alerts that override any other screen, the comment points to a person:

```
PDSPFLAG	=	063D		# CAN'T INTERRUPT	SEE M. HAMILTON
					# PRIORITY DISPLAY
```

It's in the [`ERASABLE_ASSIGNMENTS`](https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/ERASABLE_ASSIGNMENTS.agc) file of Comanche 055. The two columns say what the flag means when set and what it means when clear. For the second case, the documentation is: ask her.

The powered-flight navigation cycle of the same program carries the header `MOD NO. 00 BY M.HAMILTON DEC.12, 1966`. And the approvals page, dated 28 March 1969, lists her as *Colossus Programming Leader*, responsible for programming the command module.

On one point her memory and the paperwork don't match, and I'll note it for the record. She recalls taking over all the onboard software, lander included, around Apollo 8, so at the end of 1968 (and she says so explicitly: she doesn't remember absolute dates, only relative ones). The papers from March and July 1969 still mention only the command module. In 1971 she signs as director of all flight programming. Somewhere between those dates the responsibility became entirely hers, and honestly I can't tell you the day.

## Her daughter found the bug before the astronauts did

She worked nights and weekends, and brought along her daughter Lauren, still a child. Lauren watched her playing astronaut on the simulator and wanted a go too. One day she presses some keys and the simulated mission goes down.

She had selected `P01`, the prelaunch program, mid-flight. Two programs had started using the same memory.

Hamilton asks to add a check: if someone selects `P01` in flight, the software refuses. The answer is no. The astronauts are trained, they'll never make that mistake. She's granted a note in the documentation.

December 1968, Apollo 8, the first time a crew goes around the Moon. Jim Lovell selects `P01` in flight. The navigation data vanishes. In Cambridge three people are hunched over the listings trying to work out what happened, and she says it's Lauren's bug. It was Lauren's bug. The fix goes in from the next mission onwards.

Of the whole story, this is the most solid part and the one that concerns me most. Designing on the assumption that the user will get it wrong, even if they're the best-trained test pilot on the planet, is a truism today. In 1968 it was a proposal from a programmer, shot down by the bosses.

{: .text-center }
![Meme: a woman at a microphone, captioned "Me explaining how to use the program", looks at a second woman, labelled "User", who is licking the outside of a mug labelled "the program"]({% link /media/2026-10-13/meme-utente-e-programma.png %}){: .img-fluid }

## On 20 July she didn't save the mission single-handed

You know the scene. A few minutes before landing, the lunar module computer throws an alarm, 1202, and then four more. Houston gives the go, Armstrong lands.

The heroic version says Hamilton's software saved the mission. I'll go through it in order, because what's left standing at the end is more than enough for her.

The computer was overloaded because something was stealing about 13% of its processing time. Eyles reconstructed the cause in a 2004 essay: an interface document between the MIT guidance system and a piece of Grumman kit required two power supplies to have the same frequency and forgot to require the same phase. The defect had been spotted in testing, noted down and left there. Hamilton, in 1971 and again in 2009, attributes it to an error in the astronauts' procedure. On this, Eyles is right, and he has the documents.

The computer didn't keel over for two reasons. The first is the priority scheduler, which is Hal Laning's: Eyles writes that he designed it with no example to draw on, and it's still a good design. The second is *restart protection*: the software resumed from the last safe point and dropped the less urgent tasks. It had been designed for power glitches, and it worked against overload partly by accident, as Eyles himself admits.

The go was given by Steve Bales and Jack Garman in Houston, together with Russ Larson, MIT's man in the room. Cambridge had no time to say anything. Hamilton was in the lab's link-up room, listening.

So what's she got to do with it? Here I have to apply to her the same yardstick I apply to everyone else.

Hamilton always said that on that day the alarms reached the crew as *priority displays*, and priority displays were her mechanism. That they were hers is documented: the lab's memo index lists one under her name, dated 27 February 1968, titled "COLOSSUS Priority Displays" (sadly I couldn't find the text online, but the archive index lists it with number, date and author, so I've included it), the display routines sit in the code shared by both vehicles, and in the command module listing the relevant flag points to her. Also hers, as she tells it, was the solution to the subtlest problem: how does the astronaut know which screen they're answering, if a new one pops up under their fingers? Before pressing, count to five.

That on 20 July the alarms went through that route, on the other hand, I couldn't find. Eyles says the `PROG` light came on and it was Aldrin who asked for the code, keying verb 5 noun 9. And in the lunar module listing the routine that fires in that case, `BAILOUT`, lights the lamp and restarts the software. The comment says the alarm turns the light on *but displays nothing*. The priority display is a different path, and reading that code, it isn't taken for the 1202. I'm no expert in that assembly, so take it as the reading of someone in the trade, not an expert report.

That leaves the restart, which is what kept the computer up and which lived in the systems area, that is, on her turf. Who wrote which lines can't be worked out from the sources I've read. MIT's official history of the software, from 1971, in nearly three hundred pages never names Hamilton, Laning or Eyles.

## The myth handed her other people's work

This is where things get odd, because Hamilton has been badly treated twice, in two opposite directions.

The first time, they took things away from her. The work with Lorenz, the tape-and-pencil work, is the work chaos theory was born from. Lorenz thanked her in his papers, just as he thanked Ellen Fetter, the programmer Hamilton had hired and trained to replace her: "Special thanks are due to Miss Ellen Fetter for handling the many numerical computations". One line, with *Miss* in front. Those who told the story of chaos over the following fifty years cut even that. The two resurfaced in 2017, when an MIT geophysicist reread the acknowledgements and wondered who on earth Ellen Fetter was.

With Apollo it went the same way. The software history written by MIT in 1971 names neither her, nor Laning, nor Eyles, and closes with an even-handed "whatever kudos are due belong to us all". NASA's from 1988, in the pages on Apollo software I read, cites the Houston controllers and none of the three. In 2003, when NASA finally gives her an award, the official who nominated her says he was astonished to discover nobody had ever done it before.

The second time, they gave her things, and gave her things that weren't hers. When the photo went viral, compensation in bulk kicked in: she wrote the Moon code, she invented the priority scheduler, she coined the phrase *software engineering*. The citation for the Presidential Medal of Freedom, in 2016, speaks of her writing "the code that helped America set foot on the moon". Wikipedia, as I write, still says she coined the term.

She didn't. It appears in adverts in a trade magazine in June 1965, Anthony Oettinger uses it in the ACM President's letter of August 1966, and the 1968 NATO conference puts it into circulation.

The remarkable thing is that she never claimed it. She's more cautious than all her admirers:

> citation "Margaret Hamilton, storia orale, Computer History Museum, 2017" [https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf]
> It was a term that had not been heard about at Draper. Had it been heard about in Russia or somewhere else? Who knows.

The colleagues did their bit too. Eyles, in fifty-nine thousand characters on the landing, never mentions her. She, in three hours of interview, never mentions him, nor Laning. I honestly went looking for a feud, because it seemed they'd fallen out, and didn't find one. I found two people telling the same feat each from inside their own team: he remembers his algorithm, she remembers the system that held everyone else's algorithms together. Integration work has this flaw: when it works, it leaves nothing to tell.

## Software engineering was a joke

At the lab there were the real engineers, the hardware and aeronautics people, and then there were *the programmers*. The word didn't carry the weight it does today. It meant the people who took the engineers' decisions and made them run on a machine, much as *computers*, twenty years earlier, meant the women who did the calculations. She puts it bluntly: we were second-class citizens.

Working on the simulations, she notices that her team's problems and the hardware ones look alike, and that there's a slice of work, who interrupts whom and with what priority, that the engineers don't deal with. She proposes calling the two parts *hardware engineering* and *software engineering*. The engineers find it a good joke. "There's Margaret again with her software engineering."

Then, at a packed meeting, one of the hardware gurus stands up and says Margaret's right, that what the programmers do is engineering just as much as theirs, and it's time to formalise it. In the interview, fifty years on, when she gets to this point she starts to cry.

What she did afterwards is consistent to the point of stubbornness. Two companies, Higher Order Software in 1976 and Hamilton Technologies ten years later, and a modelling language, USL, all built on the same idea: errors are kept out of the system by how the system is defined, before you even go looking for them with tests. As far as I know she didn't conquer the market. The idea, on the other hand, is inside every code review, every input check, every system that degrades instead of falling over: that is, inside my everyday work.

## She was a woman in a men's lab

Everything I've written so far happens in a precise place and time, and without them you can't understand why there's so much confusion around her.

She joins the lab in 1965. The federal equal pay law is two years old, the civil rights one is one. In 1963 there are about 240 women in the whole of MIT, 120 of them undergraduates, and the campus's first women's hall of residence has just opened. Until 1974 a bank can legally ask a woman for her husband's signature before granting her a loan.

Under her signature, on the program that goes to the Moon, there are six approvals. Six men. "All guys", she says, and all engineers.

She discovers some colleagues earn twice what the women do, and when she asks why, she's told that women get married and their husbands support them. One of her team goes to the MIT credit union for a loan and is asked for her spouse's signature. Hamilton goes in person and asks whether they'd ask a man for his wife's signature. The rule, which was a bollocks rule even for those years, gets changed. Ironically, the men on the committee side with her, while a couple of women object that in their view the husband ought to approve. Just to feel part of the patriarchy a bit longer.

And then there's the person who punched her cards. A Black woman, with one or two children, who while punching the code even found errors in it. Hamilton says she later went on to study and became a doctor, or a lawyer. She doesn't give her name. In 1967, the first year for which the figure exists, a Black woman working full time in the United States earned 43 cents for every dollar paid to a white man. That woman was, in effect, doing code review on Apollo.

I have to be honest about one thing, because she was. Hamilton never told her story as a victim. She says the distinction was felt less back then than people think, that if you did good work they gave you more responsibility, and that in some ways it's worse today, because the bullying is anonymous and you don't know who to answer. Her daughter remembers getting from her the certainty that there were no barriers. I believe her, partly because hers was an all-in-all privileged environment, educated, full of brilliant minds, less given to certain brutish ideas. And I also believe that a person can walk through a rigged system with their head held high without the system ceasing to be rigged.

It's not an isolated case, and the others are well known. In 1946 ENIAC is presented to the press without a word about the six women who had programmed it. Lise Meitner explains nuclear fission and the 1944 Nobel goes to Otto Hahn alone. Chien-Shiung Wu demonstrates parity violation in the lab and the 1957 Nobel goes to the two theorists who had hypothesised it. Rosalind Franklin's Photo 51 ends up in front of Watson without her knowing a thing, and a study out just a few days ago shows she had already worked out the helix structure from photo 49, which had a smudge. The famous 51 was the *fair copy*, made on purpose.

From them, credit was simply taken away. From Hamilton it was taken, then given back with interest, wrongly twice over in my view. In both cases someone else decided what history ought to say about her.

## What we owe her

She spent sixty years saying one single thing: people make mistakes, all of them, and a serious system anticipates the error and prevents it. Astronauts make mistakes. Programmers make mistakes, her included, with the queue outside the door. Whoever writes the specs makes mistakes and forgets to mention *the phase*.

I'll add that whoever writes history makes mistakes too, out of laziness when they erase it and out of too much affection when they inflate it.

Margaret Hamilton matters because of the work she did. Not because of a photo, and not because she was a woman.

## Sources

- [MIT obituary, 7 October 2026](https://news.mit.edu/2026/margaret-hamilton-computing-pioneer-dies-1007)
- [Oral history of Margaret Hamilton, Computer History Museum, interviewed by David C. Brock, 13 April 2017](https://archive.computerhistory.org/resources/access/text/2022/03/102738243-05-01-acc.pdf)
- [Apollo 11 source, Comanche 055 and Luminary 099](https://github.com/chrislgarry/Apollo-11)
- [Comanche 055 approvals page, 28 March 1969](https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/CONTRACT_AND_APPROVALS.agc)
- [COLOSSUS Memo #56, 2 May 1968](https://www.ibiblio.org/apollo/Documents/COL56.pdf) and [Virtual AGC project document archive](https://www.ibiblio.org/apollo/links.html)
- [Margaret H. Hamilton, "What the Errors Tell Us", IEEE Software, 2018](https://wehackthemoon.com/sites/default/files/2019-07/what-the-errors-tell-us-3%20%281%29.pdf)
- [MIT News, "Recalling the 'Giant Leap'", 2009](https://news.mit.edu/2009/apollo-vign-0717)
- [Don Eyles, "Tales from the Lunar Module Guidance Computer", 2004](https://www.doneyles.com/LM/Tales.html)
- [R-700, "MIT's Role in Project Apollo", vol. V, "The Software Effort", 1971](https://www.ibiblio.org/apollo/hrst/archive/1137.pdf)
- [James Tomayko, "Computers in Spaceflight: The NASA Experience", ch. 2, 1988](https://web.archive.org/web/2020/https://history.nasa.gov/computers/Ch2-6.html)
- [NASA press release on the 2003 award](https://nasa.gov/wp-content/uploads/static/history/alsj/a11/a11Hamilton.html)
- [Joshua Sokol, "The Hidden Heroines of Chaos", Quanta Magazine, 2019](https://www.quantamagazine.org/hidden-heroines-of-chaos-ellen-fetter-and-margaret-hamilton-20190520/)
- [Bertrand Meyer, "The origin of 'software engineering'"](https://bertrandmeyer.com/2013/04/04/the-origin-of-software-engineering/)
- [Paul Ceruzzi, "The 'Rope Mother' Margaret Hamilton", National Air and Space Museum, 2016](https://airandspace.si.edu/stories/editorial/rope-mother-margaret-hamilton)
- [MIT, October 1963 press release on women students](https://cdn.libraries.mit.edu/dissemination/diponline/AC0069_NewReleases/NewsRelease_1960/AC0069_1963/AC0069_196310_020.pdf)
- [Census Bureau, 1967 income](https://www.census.gov/library/publications/1969/demo/p60-60.html) and [National Women's Law Center](https://nwlc.org/?p=80733) for the 43 cents figure
- [IEEE Spectrum, the ENIAC programmers](https://spectrum.ieee.org/untold-history-of-ai-invisible-woman-programmed-americas-first-electronic-computer)
- [APS News, Lee, Yang and Wu](https://www.aps.org/apsnews/2022/09/lee-yang-parity)
- [Embryo Project, "Photograph 51"](https://embryo.asu.edu/pages/photograph-51-rosalind-franklin-1952) and [King's College London, 9 October 2026, on photo 49](https://www.kcl.ac.uk/news/rosalind-franklin-deliberately-created-photo-51-after-earlier-photograph-revealed-dnas-structure)
- [Equal Pay Act of 1963](https://www.eeoc.gov/statutes/equal-pay-act-1963), [Title VII of the Civil Rights Act of 1964](https://www.eeoc.gov/statutes/title-vii-civil-rights-act-1964) and [Smithsonian, on the Equal Credit Opportunity Act of 1974](https://www.smithsonianmag.com/blogs/smithsonian-american-womens-history-museum/2024/10/28/voices-on-independence-four-oral-histories-about-building-womens-economic-power/)
- [Ada Lovelace Day, date and origin](https://www.timeanddate.com/holidays/fun/ada-lovelace-day)
- [The photo on Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Margaret_Hamilton_-_restoration.jpg)
