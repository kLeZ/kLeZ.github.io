---
lang: en
title: "Slop, trust, and a three-line patch"
tags:
- open-source
- ai-slop
- trust
- maintainership
date: 2026-06-28 02:46:01+02:00
description: "A real bug, a three-line fix, and a one-line rejection: what reaching for 'AI slop' as a reflex gets wrong about verification, scale, and trust in open source."
---

A maintainer closed my patch with one sentence: "Sorry, but this sounds like AI slop." The patch was three lines of Go. It fixed a real authentication bug, it shipped with a debug log that pinned the cause, and a week later a stranger running a different account setup cloned my fork, built it, and reported back that it worked. None of that counted. What counted was the smell.

{% include more.html %}

Now the dull context, which is the whole point. I back ProtonMail's mail through a small open-source bridge called hydroxide, because I don't pay for Proton's own bridge and hydroxide is what I have. Accounts with two-factor authentication can't finish logging in: the password step and the TOTP step both succeed, and then the very next call, the one that fetches the key salts, comes back 401. Proton invalidates the access token once you clear the second factor and hands you a fresh scope, and the client keeps presenting the old token. I found this by turning on the debug log and reading the request trace. I confirmed it against the behaviour of Proton's own web client. The fix is to ask for a new token after the second factor and use it for the rest of the login. Three lines, gated so single-factor users never touch the new path.

I'll be precise about how I worked, because the precision is what the rejection got wrong. I used a language model to read the codebase faster: it was someone else's Go, I had never seen it, and I wanted a map before I started digging. Read-only. The notes it produced never reached a commit; I deleted them once I understood the code. I wrote the fix by hand. Then, because I was out of time and patience, I described my own change to a model and had it draft the issue and the pull request text. The code was mine; the prose was not. I disclosed nothing about this in the description, which, as I'll get to, is the part everyone has decided to fight about.

## The part where I concede everything

Slop is real. I want to say that before I say anything else, because the people sounding the alarm are not imagining the fire.

The clearest case on record is curl. Through 2025 Daniel Stenberg watched AI-generated vulnerability reports flood the project's bug bounty until roughly one in five submissions was slop and the rate of reports describing a real vulnerability fell below one in twenty. Seven people on the security team, three or four of them needed to read each report, thirty minutes to three hours apiece to conclude it was nothing. One submission described an HTTP/3 exploit complete with debugger sessions and register dumps, all of it referencing a function that does not exist in curl. Stenberg called it DDoSing open source and shut the bounty down.

What that describes is a resource attack, and it has a name older than the chatbots. Alberto Brandolini's bullshit asymmetry principle says the effort to refute nonsense is an order of magnitude larger than the effort to produce it. Language models industrialise the cheap side of that asymmetry and leave the expensive side exactly where it was: on a human who has to read, reproduce, and decide. A maintainer facing that inflow is not paranoid. He is doing triage in a building that is genuinely on fire, and a wall is a reasonable thing to want.

The worry behind my rejection is legitimate. It was aimed at the wrong layer.

## The wrong axis

Read Stenberg carefully and the complaint is never really about who or what wrote the report. He says outright that it makes no difference whether a submission came from a human or a machine if it carries no real finding and only burns reviewer time. He runs three AI review bots on his own pull requests, at two in the morning when no human is awake. When the models improved in early 2026 curl reopened the bounty, because the slop had thinned out even as the volume kept climbing. His axis is verification. Does the thing check out, and what does it cost me to find out.

"This sounds like AI slop" is a different axis. It is authorship, detected by smell. And smell is cheap, which is exactly why it tempts you when you are tired. You stop reading for whether the claim is true and start reading for whether the prose feels synthetic. The trouble is that the two axes come apart in precisely the case that matters. The smell test fires on the contributor who used a model for the boring half and did the real work by hand, and it fires hardest on people whose English is a second language and who reach for a model to sound fluent. In my case the classifier worked perfectly and was useless: it correctly detected that the prose was machine-drafted, and from that it convicted the code, which was mine and which was correct. The signal it caught was real; the inference it drew was garbage.

## The double bind

There is a trap inside this that almost nobody names, and it is worth sitting with.

The same projects that fear slop ask contributors to disclose AI use. hydroxide's contributing guide is explicit: if a model helped, say so, add an `Assisted-by` line. Honesty is the rule. Then read James Bach, who has written one of the sharper arguments against AI in writing, and who tells you to do the opposite. Never admit you used a model, Bach says, because the moment you do he will treat your work as slop or spam, and so will every serious professional. In his frame disclosure is a confession of laziness; he compares letting a model draft your prose to taking a helicopter to the summit and claiming you climbed.

Hold both at once. One norm orders you to disclose. The other promises to punish you for disclosing. The honest contributor, code by hand and prose by machine and forthright about which is which, loses under both. No disclosure satisfies the rule-followers and the rule-skeptics together, so the incentive the system actually teaches is to hide: write the prose yourself, badly, or launder the model's prose through enough edits that nobody can tell. A rule that punishes honest disclosure destroys the very signal it was built to collect. That is not a stable place to stand.

## The market for lemons

George Akerlof won a Nobel for describing what happens next, in a 1970 paper about used cars. When a buyer cannot tell a good car from a bad one, he will only pay the price of an average car. Owners of genuinely good cars cannot get a fair price, so they leave. Average quality drops, the price drops with it, and the market can keep unravelling until mostly lemons remain. Information asymmetry does more than annoy buyers. It selects against the honest sellers and degrades the whole pool.

Open-source contribution is now a lemon market. A maintainer who cannot cheaply tell a real patch from a plausible one rationally applies a blanket discount: assume slop, close on sight. The cost of that discount lands on the contributors who did real work, because they are the ones with something to lose. They get treated as the average, the average is assumed to be junk, and so they leave. I will not be sending hydroxide another patch. The bug is still open. Multiply that by every competent person waved off with a one-line smell verdict, and the blanket discount manufactures the exact future it was meant to prevent: a contribution pool with the good actors filtered out. Each rejection is individually rational. The sum is a project pricing itself toward lemons.

## Scale is the whole argument

Here is where I have to be fair to curl and hard on the imitation of curl.

curl earns its walls. Hundreds of millions of installations, a seven-person volunteer team, real money on the table that drew people brute-forcing the bounty with chatbots. At that scale the expected value of a random unsolicited submission really is near zero, verifying it really is expensive, and a high prior of slop is correct Bayesian reasoning, not panic. Stenberg is rationing the only finite resource he has, which is attention; his wife has started asking him about his hours.

hydroxide is not curl. By its own maintainer's account it is casually maintained, kept alive mostly so he can send kernel patches, sitting on a few dozen open issues with no bounty and no crowd. The population of people who install a niche ProtonMail bridge, hit a two-factor bug, read Go they have never seen, isolate the cause, and write a fix is small and heavily self-selected. The base rate of slop in that population is low. Verifying three gated lines costs minutes. Importing curl's prior into that situation is a base-rate error wearing the costume of prudence: you have adopted the threat model of a project a thousand times your size and applied it to a contributor who, by the sheer cost of getting that far, was almost certainly not your problem.

The maintainer is within his rights. I am questioning the judgment, not the right to make the call. It is his project, his time, and he owes me nothing; I said as much to him, in those words. Rights were never what I was arguing about.

## Trust is not a one-way audit

The word everyone reached for in the thread was trust, and they used it as though it ran one way: the contributor earns the maintainer's trust, the maintainer adjudicates. But trust in a commons is something both sides spend. I spent mine. I installed it, used it, found the bug, read the trace, read a stranger's code until I understood it, opened an issue that pointed at the exact fault, wrote the patch, and signed it off, all in time I do not have, toward a project I wanted to keep working. A reviewer who closes on a smell spends none of that and discards all of mine.

The repair was cheap. The whole thing was avoidable for the price of one sentence: did you understand this code, and is the description AI-written? The honest answer rebuilds in one line the thing the smell test set on fire. Asking would have cost less than the closing did.

I did not make that easy, and I should own it. When I told the maintainer he "deserved" the broken project and that I would wait for him to fix the bug himself, I handed him the edge he needed to slide the conversation off the code and onto my attitude, which is a more comfortable place for a rejection to live. The structural point survives my bad manners. Closing a reproduced fix on authorship-smell, at a project where verification costs minutes, spends trust that a volunteer commons cannot easily refill.

## What it actually costs

I want to keep the stakes the right size. This is not the end of anything; it is a small bridge and a small patch.

But notice who is not harmed by any of it. The closed and the corporate scale fine. They have headcount, process, and money; a slop flood is a line item, and so is review. The thing that runs on nothing but trust between strangers is the small, weird, volunteered long tail: the niche bridge, the one-maintainer tool, the patch from someone you have never met. That is exactly where the blanket-slop posture does the most damage relative to the real threat. The towers protect the projects that least need protecting and price out the collaboration that has nothing else holding it together.

Slop is a tax on attention. The paranoia is a tax on trust. The first is the louder problem and the more obvious one, and it is real. The second is quieter and worse, because attention can be bought back with tooling and money, and the curl story is partly the story of that recovery. Trust between strangers does not recover on that schedule. Once a community's default reading of a good-faith contribution is "probably a machine, probably junk," you do not get the default back by upgrading a model. You get it back, if at all, the slow way, one honest exchange at a time, which is the same way it was built and the same way it is now being spent.

The bug, by the way, is still open. The fix still works. Somebody will merge it eventually, by hand, written by a person, the way it was the first time.

## Sources

- hydroxide pull request and the linked issue: [PR #346](https://github.com/emersion/hydroxide/pull/346), [issue #345](https://github.com/emersion/hydroxide/issues/345)
- The contributing policy referenced in the thread: [emersion/.github CONTRIBUTING.md](https://github.com/emersion/.github/blob/main/CONTRIBUTING.md)
- James Bach, *Public Service Announcement: Don't Say You Use AI for Writing*: [satisfice.com](https://www.satisfice.com/blog/archives/488148)
- Daniel Stenberg on AI slop and curl's bug bounty (primary): [daniel.haxx.se/blog](https://daniel.haxx.se/blog/); secondary coverage with the figures cited here: [The New Stack](https://thenewstack.io/curls-daniel-stenberg-ai-is-ddosing-open-source-and-fixing-its-bugs/)
- George A. Akerlof, "The Market for Lemons: Quality Uncertainty and the Market Mechanism", *Quarterly Journal of Economics* 84, no. 3 (1970)
- Alberto Brandolini, the bullshit asymmetry principle (Brandolini's law), 2013
