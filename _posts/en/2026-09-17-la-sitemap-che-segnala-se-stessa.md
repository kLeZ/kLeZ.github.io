---
lang: en
title: The sitemap that reports itself
tags:
- security
- osint
- scam
- hacking
date: 2026-09-17 10:20:00+02:00
locale: en
source_sha: 0117e3a10f730e32
---

On Saturday 12 September, after dinner, I opened my inbox and found an email that had arrived at 22:39. Subject `Medium Risk: Sensitive Paths Disclosed via Sitemap on https://klez.me`, sender "White Hat 66" (`hsafe240@gmail.com`). Inside was a security report about my blog, complete with *severity*, *bug name*, *PoC URL*, *impact* and *suggested fix*, and at the bottom a request for a reward. My first reaction was a defiant grin, and the urge to track the guy down and give him a piece of my mind.

{% include more.html %}

## The bug does not exist

According to the report, my `sitemap.xml` contains URLs for areas that *appear* to be administrative, internal or otherwise not meant for the public. That *appear* is the most honest word in the whole email. Which areas, the email doesn't say. There isn't a single path in the report, and the proof offered is a link to the sitemap itself.

I built the blog myself, with Jekyll, a static site generator: pages are generated once and GitHub Pages serves them as they are, with no application code running and no login of any kind. There is no admin panel, and nowhere for one to live. The sitemap lists the posts, `/about/`, `/cv/`, `/contatti/`, `/privacy/` and a few course slides under `/lf/`, which is to say public pages listed on purpose so that search engines can find them, which is the reason a sitemap exists ([protocol on sitemaps.org](https://www.sitemaps.org/protocol.html)).

The *impact* section claims the file "directly points attackers to non-public or sensitive areas". Put that next to the total absence of paths and you can see how the report was born. Someone, or more likely something, found `klez.me/sitemap.xml` and logged the file's existence as a vulnerability, without reading it. A tool that treats the mere existence of a sitemap as a bug is a mediocre tool, and whoever uses it to ask for money didn't even reread what it spat out. Opening the source of the home page would have been enough, since it says `<meta name="generator" content="Jekyll v3.9.3" />` in plain text.

The prose reads as if it came out of a language model, every field in its place and not one detail that actually concerns my site. The signature, White Hat 66, has all the gravitas of a *gamertag*. At the end, under "White Hat Note", comes the request:

> citation "White Hat 66"
> We would appreciate hearing about reward or acknowledgment you may offer.

## Beg bounty, not bug bounty

Troy Hunt calls it a [*beg bounty*](https://www.troyhunt.com/beg-bounties/). You take any old configuration detail, in his examples a missing DMARC record or an absent security header, wrap it in the language of a *vulnerability disclosure* and send it to someone who has no bug bounty programme, hoping they'll pay to make it go away. According to [NWS Digital](https://www.nwsdigital.com/Blog/Is-that-Scary-Website-Security-Warning-Email-Legit) the people doing this target small organisations, where there is often nobody able to tell a vulnerability from a public file.

It is attempted fraud. Article 640 of the Italian Criminal Code:

> citation "Italian Criminal Code, art. 640(1), translated" [https://www.brocardi.it/codice-penale/libro-secondo/titolo-xiii/capo-ii/art640.html]
> Whoever, by artifice or deception, leading someone into error, procures an unjust profit for themselves or others to another's detriment is punished with imprisonment from six months to three years and a fine from 51 to 1,032 euros.

And article 56:

> citation "Italian Criminal Code, art. 56(1), translated" [https://www.brocardi.it/codice-penale/libro-primo/titolo-iii/capo-i/art56.html]
> Whoever performs acts that are suitable and unequivocally directed at committing an offence is liable for an attempted offence, if the action is not completed or the result does not occur.

The invented report is the artifice, the reward for a vulnerability that doesn't exist is the unjust profit. It didn't work on me, and that is exactly why the fraud stays *attempted*.

I didn't pay and I didn't reply. A reply, even just to say no, would have confirmed that someone reads that address, which makes it an address worth trying again.

## The infrastructure behind the address

That night, without a hoodie, I sat down to read the headers.

SPF, DKIM and DMARC all check out for `gmail.com`, so the message really was sent from an authenticated Gmail account and it isn't spoofing. The `Message-Id` is `<6aa5b897.e862d496.39e5c9.6c94@mx.google.com>`, the submission to `smtp.gmail.com` happened at 20:39:51 UTC (22:39 in Italy) and ProtonMail received the email seven seconds later.

The first of the three `Received` headers, the one at the bottom, shows the address of the client that authenticated with Gmail:

```text
Received: from [192.168.100.57] ([153.117.18.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33ea4fsm15029442f8f.21.2026.09.12.13.39.50
        for <klez@pm.me>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 13:39:51 -0700 (PDT)
```

`192.168.100.57` is the machine's private address, behind a NAT; `153.117.18.172` is the public address it went out on. The APNIC registry assigns that block to Cyber Internet Services Pvt Ltd, a Pakistani provider known as Cybernet, and the `153.117.18.0/24` prefix is announced by AS9541. According to ip-api.com the address doesn't belong to a VPN, a proxy or a hosting service, and geolocation puts it in Karachi (with all the precision geolocation usually has).

At the time I checked, the IP wasn't listed on Spamhaus ZEN, SpamCop or Barracuda, but that says little. Those lists are fed largely by what incoming mail servers see, and this email reached the destination servers from Google's IPs.

I stopped there, at IP, provider and autonomous system.

## What I did

During the night the plan I liked best was a different one: open a few throwaway inboxes on Guerrilla Mail and rough him up a bit (he's a criminal, so it seemed like a very good idea, and I still don't hate it). Then I went to bed, and the next morning I settled on this post and two reports.

The first went to Cybernet's *abuse desk*, `noc-abuse@cyber.net.pk`, the address APNIC lists for that block, with the date and time of sending, the `Message-Id`, the `Received` line above and an offer to forward the full message. The second went to Google through the Gmail abuse reporting form, because the account is theirs. I don't know whether anyone will read them.

If you get a similar email, these are the signs:

```text
Subject:  "<Severity> Risk: Sensitive Paths Disclosed via Sitemap on <domain>"
Claim:    sitemap.xml exposes administrative or internal areas
PoC:      the URL of sitemap.xml, without a single sensitive path named
Ask:      "reward or acknowledgment" in the closing note
```

## The same script at the W3C

The W3C's public mailing list archives hold a thread from December 2024 with the same structure. In October a Gmail sender had filed a "Vulnerability Report" about *email spoofing* on `w3.org`, with the usual advice on DMARC and SPF, and in December came back asking for confirmation "about the reported vulnerability and its bounty reward". A different vulnerability and a different name in the signature, but the same request, and a DMARC record to fix is one of Troy Hunt's own examples.

## Hackers, crackers and hats

In 1983 *WarGames* comes out, with a teenager who reaches a military system from the computer in his bedroom, and in the same year a group of Milwaukee teenagers, the 414s, makes the news for breaking into several systems, including the one at Memorial Sloan Kettering in New York. One of them ends up on the cover of Newsweek. For much of the American public it is the first time they hear about *hackers*, and the word arrives already carrying the meaning it still has on the evening news, where in the meantime the kid has put his hood up.

Inside the scene, *hacker* meant something else. RFC 1392 from 1993, a glossary for Internet users, defines a hacker as "a person who delights in having an intimate understanding of the internal workings of a system", someone who enjoys understanding how a machine works from the inside. Around the mid-1980s, to defend themselves against the way the press used the word, hackers had coined *cracker*, a word specifically for people who break into other people's systems without permission, and that one made it into the glossary too.

*Cracker* never caught on. Outside the scene nobody uses it, and in Italian the word lands on the crackers you eat with cheese long before it lands on someone breaking into your server. A word that smells of snack food doesn't work in headlines.

A different image won, taken from westerns, where the good guy wears a white hat and the bad guy a black one. *White hat* and *black hat* entered the vocabulary of people who work in security, and later *grey hat* was added for those who break in without permission but without criminal intent, and often tell you afterwards. Today, outside the industry, the word for a "good hacker" is white hat, and everyone understands it.

The white hat also served to give a job a presentable name. A company is reluctant to let a *hacker* in the door, but it will put a *white hat* on contract. Bug bounties predate the hats: in 1983 Hunter & Ready promised a Volkswagen Beetle to anyone who found a bug in its VRTX operating system ("Get a bug if you find a bug"), and on 10 October 1995 Netscape started paying people who found security holes in the Navigator 2.0 beta. Today's bug bounty programmes grew out of that, with platforms acting as intermediaries between companies and researchers, and written rules.

Anyone who puts on that hat accepts those rules. You look for vulnerabilities where someone has given you permission to look, within a written *scope*, you rate what you find by *severity* and you report it through coordinated *disclosure*. If there is a programme you get paid on its terms, usually only for valid findings nobody else has reported first. If there is no programme you can still report, but you don't ask for money.

## The hat on White Hat 66

Asking for money over a sitemap is petty fraud, the windscreen washer at the traffic lights who cleans your glass unasked and then holds out a hand. What makes me far angrier is the signature.

White Hat 66 has put on a lifeguard's uniform to walk among the beach towels lifting wallets. The name he pins on himself is the one that got a whole profession out of the crime pages, and he breaks precisely the rule that separates a white hat from a fraudster: nobody asked him for anything, he found no vulnerability, and he wants to be paid all the same.

He took the shape of a bug bounty programme, removed the programme and kept the *invoice*.

To a small-time fraudster one name is as good as another, I know. Except that it took decades to make that name respectable, and every email like this one devalues it a little, because *white hat* and *bounty* become *counterfeit currency* in the hands of someone spending them to get paid for a sitemap.

## The part that hurts

I don't care about the sitemap, it's an XML file a script generates for me. What I'm defending is the word, and what sits underneath it. [In 2010](/2010/03/29/lfs-ovvero-come-crearsi-la-propria-distro-gnulinux-da-zero/) I was compiling a distro from scratch with LFS to understand what happens when you press the power button, and [in February](/2026/02/03/il-software-che-non-puoi-smontare/) I went back to it, when LFS stopped documenting System V. Take things apart to understand them, and leave what you build open to being taken apart: everything else follows from there, free licences included.

On that ground, a bloke with a Gmail account is the least of the problems. The same words get taken by companies with a legal department and a communications budget, and they hollow them out at their leisure. *Open source* has become a phase of the commercial life cycle: Elastic moved from Apache 2.0 to SSPL and the Elastic License in January 2021, HashiCorp from MPL to the Business Source License in August 2023, Redis from BSD to RSALv2 and SSPL in March 2024. The stated reason is always the same, cloud providers reselling other people's work without giving anything back, and it isn't made up. The outcome is always the same as well: the community redoes the work from outside, with OpenSearch, OpenTofu and Valkey.

Redis, to its credit, wrote it plainly:

> citation "Redis, 20 March 2024" [https://redis.io/blog/redis-adopts-dual-source-available-licensing/]
> First, we openly acknowledge that this change means Redis is no longer open source under the OSI definition.

Software freedom has become a parameter you adjust when revenue requires it. *Hacker*, meanwhile, has ended up in job titles: *growth hacker*, a term Sean Ellis coined in 2010 for someone whose true north is signup growth. Same root, meaning flipped, and nobody bats an eyelid.

What gets lost along the way is the philosophical part, which was the engine of the whole thing: the idea that understanding how something works is a right, and that software should open the way a car bonnet opens. Hollow that out and what's left is a services market with a few vintage words kept on for the marketing.

An email like White Hat 66's is funny for ten minutes, then it's infuriating, and in the end it hurts, because it's the cut-price version of a theft somebody else is carrying out wholesale, with paid lawyers and press releases.

White Hat 66, if you're reading: the hat was never your size. But other people had already had it altered, long before you came along.

## Sources

- Sitemaps.org, [the sitemap XML protocol](https://www.sitemaps.org/protocol.html)
- Troy Hunt, [Beg Bounties](https://www.troyhunt.com/beg-bounties/), 8 November 2021
- NWS Digital, [Is that Scary Website Security Warning Email Legit?](https://www.nwsdigital.com/Blog/Is-that-Scary-Website-Security-Warning-Email-Legit), 29 December 2021
- Italian Criminal Code, [art. 640](https://www.brocardi.it/codice-penale/libro-secondo/titolo-xiii/capo-ii/art640.html) and [art. 56](https://www.brocardi.it/codice-penale/libro-primo/titolo-iii/capo-i/art56.html), text on Brocardi
- APNIC, [RDAP for 153.117.18.172](https://rdap.apnic.net/ip/153.117.18.172), and RIPE Stat, [prefix overview for the same address](https://stat.ripe.net/data/prefix-overview/data.json?resource=153.117.18.172)
- W3C, [public thread from December 2024](https://lists.w3.org/Archives/Public/public-website-redesign/2024Dec/0003.html)
- Alex Orlando, [The Story of the 414s](https://www.discovermagazine.com/the-story-of-the-414s-the-milwaukee-teenagers-who-became-hacking-pioneers-41882), Discover Magazine, 10 October 2020
- [RFC 1392, Internet Users' Glossary](https://www.rfc-editor.org/rfc/rfc1392.txt), January 1993, and [Wikipedia, Security hacker](https://en.wikipedia.org/wiki/Security_hacker), quoting the Jargon File entry for "cracker"
- Cadre, [Winning Bug Wars: From Volkswagen Beetles to Million Dollar Bug Bounties](https://blog.cadre.net/winning-bug-wars-from-volkswagen-beetles-to-million-dollar-bug-bounties), 27 August 2020, and Esben Friis-Jensen, [The History of Bug Bounty Programs](https://www.cobalt.io/blog/the-history-of-bug-bounty-programs), Cobalt, 11 April 2014
- Shay Banon, [Doubling down on open, Part II](https://www.elastic.co/blog/licensing-change), Elastic, 14 January 2021
- HashiCorp, [HashiCorp adopts Business Source License](https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license), 10 August 2023
- Redis, [Redis Adopts Dual Source-Available Licensing](https://redis.io/blog/redis-adopts-dual-source-available-licensing/), 20 March 2024
- Sean Ellis, [Find a Growth Hacker for Your Startup](https://www.startup-marketing.com/where-are-all-the-growth-hackers/), 26 July 2010
