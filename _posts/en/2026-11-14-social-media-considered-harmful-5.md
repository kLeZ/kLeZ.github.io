---
title: "Social media considered harmful. Maybe... (5/5): Who governs and who pays"
series: social-media-considered-harmful
date: 2026-11-14 08:46:05+00:00
source_sha: 1c46780b16a530b3
---

In February 2025 IFTAS, the non-profit organisation that provided the Fediverse with shared safety and moderation tools, announced that it no longer had even a single guaranteed source of funding, and over the following weeks it shut down most of its services. It hadn't got anything wrong technically. It lived on donations and grants, and when the money ran out, the work it did for everyone was left with nobody to pay for it. For the whole of 2025 it needed about 1.2 million dollars. Meta spends about 10 million euros a year in Brussels having its ego massaged by lawmakers, and the safety of an entire network died for a sum that covers Meta for little more than a month.

In the previous instalments I told you that [they knew]({% link _posts/en/2026-10-18-social-media-considered-harmful-1.md %}), that those who tried to [stop them]({% link _posts/en/2026-10-23-social-media-considered-harmful-2.md %}) barely managed it, that to [survive]({% link _posts/en/2026-11-01-social-media-considered-harmful-3.md %}) today the work falls on the people who use them, and what a [human social network]({% link _posts/en/2026-11-07-social-media-considered-harmful-4.md %}) might look like. In this last instalment I try to answer the question IFTAS makes concrete: who pays for a social network like that, and who stops the people running it from becoming yet another master.

{% include more.html %}

## One wall is not enough

Every limit, taken on its own, can be got round. A cap on advertising gets got round by whoever controls the software that enforces it, a licence by whoever has the lawyers to interpret it, a set of statutes by whoever buys the majority of the voters. The history of the platforms is full of rules respected to the letter and hollowed out in substance, and of CEOs who whimper live in front of the US Congress, with the face of a kicked puppy (or of a reptilian robot), and then, as their own internal documents tell us, go back to the office to kill every fix that might make engagement drop. A motivated player, with enough money at stake, always finds the weak spot in an isolated defence.

That's why the idea I built this part on is a ring of limits that hold each other up: the legal form, the rules, the software and good faith that can be verified, arranged so that each one props up the others. It works like quicksand, where the harder you push on one point, the deeper you sink everywhere else, and anyone trying to force one of them to make the capital grow would find themselves having to break all the ones around it too. It's also the part that cost me the most, because every choice in this instalment demanded two more so as not to leave a hole, and some ideas that seemed good to me I had to throw away.

## Who writes the software

The software would be written and maintained by a European non-profit foundation, under the AGPL, the licence that obliges anyone who modifies the program and makes it available over a network to publish their changes.

My first idea was a different one, and it wasn't a good idea. I wanted a purpose-written licence that would allow you to install an instance only by paying the foundation a percentage of your takings, that would forbid any modification not accepted into the official software (a rejected change had to be removed), that would forbid reusing the code elsewhere, and that would grant rights for a limited period, to be renewed. On paper it protected the project from everything, forks included, those copies of the software that a group of people carry on with by themselves. In practice it handed all the power to the foundation, and turned it into the one point to conquer, because whoever seized it, with a bought board or a changed law, would have the entire network in their hands, with nobody able to leave and take the code with them. A licence like that, on top of everything, wouldn't even have been free.

With the AGPL, forking would always remain possible, and that is precisely the way out if the foundation were captured. Control, instead of sitting in copyright, would move to certification, that is to a trademark and a contract. Anyone could take the code and do whatever they liked with it, but only those running the official software, or modifications accepted into the official software, could call themselves certified, appear first in the station and host young people. The fork would remain legal, just outside certification.

## Who certifies

Certification would be issued by a body separate from the foundation, which would own the trademark. Two structures to maintain instead of one is an extra headache, but it's the price of not putting the people who write the rules and the people who check they're followed in the same hands.

The real problem was something else. In the [second instalment]({% link _posts/en/2026-10-23-social-media-considered-harmful-2.md %}) I criticised the audits in the *Digital Services Act*, which Article 37 makes the platforms themselves pay for, because an auditor paid by the party being audited has every interest in not upsetting it. It's like letting the home side pick and pay the referee, and then feigning surprise when the penalties always go the same way. In Italy we have a name for this sort of thing, and it isn't "independent audit". A certifier paid by the instances it certifies would have exactly the same conflict. That's why, in my design, whoever judges would collect nothing from whoever is judged. Instances would pay a single contribution to the foundation, as a condition of the certification contract, and the foundation would pass a fixed share of its revenue to the certifier, written into the statutes and guaranteed for several years, with no power to cut it at will. The certifier's board would not be appointed by the foundation, otherwise the separation would exist only on paper.

Here too I had first thought of another solution, a certifier "semi-controlled" by the foundation, with a reference operator inside it, namely the main instance on the network, acting as a counterweight. That was a mistake, because a single operator with a guaranteed seat becomes the only one you need to buy to get that power, and it hands the biggest instance a privilege written into the statutes, the opposite of a station where no train counts more than the others.

The certifier, moreover, shouldn't trust paperwork alone. The code would be open, and that was the condition I asked for to make a serious audit possible. Today's platforms show their code to auditors roughly the way a casino lets punters take the slot machines apart to check whether they're rigged. The strongest guarantee, though, would come from somewhere else. Ads would travel in the protocol, and would be displayed by open-source apps that could count them. An instance that exceeded the daily cap for a user would be caught by that user's app, which could reject the excess ads and report it. That way no instance could crank up the advertising for a few months, cash in and dial it back just before an inspection, because the inspection would be carried out, every day, by the phone of whoever uses it. The cap itself would be locked down too, because operators could adjust how many ads to show and when, but only downwards, and the software would refuse to run above the limit.

## Quis custodiet ipsos custodes?

What stops the foundation and the certifier from colluding, or someone from buying one and strangling the other by cutting its funding?

My answer is a guarantor, a disinterested third party that collects nothing from the network and has only one power: a veto over a handful of clauses in the statutes, the entrenched ones. These would be the clauses that hold the whole ring together: the share that funds the certifier, the cap on advertising, the parameters of the contribution formula, the minimum age and the definition of an active user. Whoever took control of the foundation could change everything else, but not these, without its consent. It's a mechanism company law has known for a long time under the name of *golden share*, and here the golden share would be held by someone who, by design, has no economic interest in the network. A rare species, I know, especially around Silicon Valley, where even the board that rules on Meta's content decisions is paid for by Meta, which is the Californian way of asking the barman whether the beer is any good.

Alongside the guarantor I'd put a college of operators, with a say on the certification criteria and on the formula, because the people running the instances know better than anyone what moderation costs and how heavy an obligation is. The college, however, would never vote on the certification of an individual instance, neither its own nor a competitor's, otherwise we'd be back to the conflict we've just removed from the certifier.

## The obligations of those who moderate

In the last instalment I wrote that moderation would be done by people. Certification would have to turn that principle into precise obligations, and there would be five of them.

The first is having moderators in proportion to users, with a minimum ratio set in the certification criteria, because an instance with a hundred thousand members moderated by two volunteers in the evening is, in practice, an unmoderated instance. The second concerns reports, which would have to be handled within a maximum time, with a reasoned decision and the right to appeal. The third requires public rules, written in advance, the same for everyone, so that nobody gets punished under a rule invented after the fact. The fourth is the coordinated isolation of instances hosting abuse, through a service shared by the whole network, exactly the kind of work IFTAS used to do. The fifth protects those left homeless, because an instance that shuts down would have to warn its users in good time, and let everyone take their contacts and content to another instance.

None of this is invented from scratch. Since 2019 Mastodon, on its official page, has listed only servers that sign up to a commitment, the *Mastodon Server Covenant*, which asks for four things: active moderation against racism, sexism, homophobia and transphobia, daily backups, at least one other person with emergency access to the server, and at least three months' notice before closure. It's certification in embryo, with no separate body, no audits and no money, but it shows the idea holds up even in a network that distrusts any centre.

The difference from IFTAS would be the money, because the isolation service would live on a fixed share of what the network takes in.

## Who pays

Instances would sustain themselves, and each would freely choose how, with one or more sources mixed together. There would be paid instances with extra services, including, for example, no advertising. There would be free instances paid for by public bodies, such as those of a town council or a university, which in my view should be the most common, because a social network is the square where public opinion is formed, the agora of Magna Graecia where people argued about politics but also about the price of bread and fish, and a square is paid for by the community. And there would be free private instances, supported by donations and advertising.

The advertising would be the kind from the last instalment: never profiled, always declared and under a daily cap per user. Companies would also have their own profile, with posts that reach only those who've chosen to follow them, and could pay for a boost, a push similar to YouTube's *hype*, whereby a post is also shown to people who don't follow it. Every boost received would count as an ad, within the recipient's cap, and whoever boosts would have a limit of their own too, a few boosts per period, so that it stays a rare gesture.

The per-user cap is what makes everything else possible. Once the daily threshold is passed, every extra minute spent on the social network would bring in not a penny, and an instance's revenue would grow only with the number of its users. That's why, if you want to stop an instance becoming another Meta, you have to make growth cost something. Meta, after all, is the company that took the urge to find your old school friends and turned it into a daily auction of our attention, with us as the meat on the counter and not even a cut of the sale.

## A formula for those who grow too much

Every certified instance would pay the foundation a contribution calculated on its takings, at a rate that rises with the number of users. An instance with no revenue, like that of an association living on members' fees, would pay nothing. A small one would pay little, a big one much more, and from a certain point onwards every new member would cost the instance more than it earns it. No rule would forbid growing further, but growth would stop paying.

I wanted a single formula, however complex, that takes the numbers and returns the amount owed, not a list of brackets and exceptions fit for an accountant. Bracketed tables create thresholds where it pays to stop just below (just ask any Italian sole trader on the flat-rate scheme how keen they are to work in December, when they're a whisker away from 85,000 euros), whereas a continuous function has no steps to exploit. It isn't as odd an idea as it may sound. In Germany income tax is written into the law as a series of formulas, polynomials giving the tax due in each income band, and in public economics there's a line of research, starting with Heathcote, Storesletten and Violante, that describes an entire progressive tax system with one function and just two parameters.

In words, it would work like this. Each instance would pay a percentage of its takings, and that percentage would depend only on how many users it has. For a small instance it would be minimal, the same for all, just enough to keep the foundation going. As users grow it would rise, slowly at first and then faster and faster, without ever reaching 100%.

{% katexmm %}

In the formulas, $R$ is the instance's annual takings and $U$ its active users, both counted across the entire group that controls it. $a_{\min}$ is the base rate, the one a tiny instance pays. $U_0$ is a reference size, expressed as a number of users, which sets the scale of the curve. $k$, a number greater than 1, says how steep the climb is: the higher it is, the longer small instances stay close to the base rate, and the sharper the wall when it comes. The letter $e$ is Euler's number, the base of exponentials, and here it only serves to draw a curve that starts flat, rises and then flattens out again below 100%. The average rate, that is the percentage of takings to be paid, would be

$$a(U) = a_{\min} + (1 - a_{\min})\left(1 - e^{-(U/U_0)^k}\right)$$

The bit inside the big round brackets is zero when there are no users and approaches one when there are many more than $U_0$. Multiplied by $1 - a_{\min}$, that is by what the base rate is short of 100%, it takes the rate from $a_{\min}$ almost to 100%, without ever touching it. The contribution owed is simply takings times rate, and written out in full it's the main formula of the whole mechanism, the one that takes takings and users and returns the amount to pay:

$$F(R, U) = R \cdot a(U) = R \left[ a_{\min} + (1 - a_{\min})\left(1 - e^{-(U/U_0)^k}\right) \right]$$

The formula has a few properties I like. If takings are zero, the contribution is zero. For small instances the rate stays close to the base rate, and then accelerates. It never exceeds 100% of takings, so nobody pays more than they take in.

What matters more, though, is another quantity, the marginal rate, that is how much of the takings brought in by one extra user goes on the contribution. It's higher than the average rate, because when one extra user pushes the rate up, the new rate applies to all of the instance's takings, including those from the users who were already there. If every user brings in, on average, the same takings, and with the per-user advertising cap that's a reasonable approximation, the marginal rate is the derivative, that is the speed at which the product of users and average rate grows with each extra user:

$$m(U) = \frac{d}{dU}\bigl[U \cdot a(U)\bigr]$$

At some point the marginal rate goes above 100%. From there on a new user raises the contribution more than it raises takings, and growing means losing money. In practice the wall comes even earlier, when the marginal rate reaches the margin the instance makes on each user. To give you an idea, with a base rate of 2% and $k = 2$, the numbers would be these (size is in fractions of $U_0$, so 0.5 means half of $U_0$):

| Users, in fractions of $U_0$ | Average rate | Marginal rate |
| ---------------------------: | -----------: | ------------: |
|                          0.1 |         3.0% |          4.9% |
|                          0.2 |         5.8% |         13.4% |
|                          0.3 |        10.4% |         26.6% |
|                          0.5 |        23.7% |         61.8% |
|                          0.7 |        40.0% |         98.8% |
|                            1 |        63.9% |        136.1% |

With $k = 2$ growth stops paying at about seven tenths of $U_0$, to be exact at $U_0/\sqrt{2}$, and this point depends only on $k$, not on the base rate. With $k = 3$ small instances would be spared for longer (at 0.3 the average rate would be 4.6%) and the wall would be steeper. I'm not writing down the real values because it should be the statutes that set them, together with the definition of an active user. For the same reason $R$ and $U$ would have to be calculated across the entire group controlling an instance, otherwise you could just split into ten formally separate instances and pay like ten small ones.

<div class="row d-flex justify-content-center">
<div class="col col-12 col-xl-8" markdown="1">
![Chart as a function of users, in fractions of U0, with a base rate of 2% and k equal to 2. The average rate rises slowly towards 100% without reaching it. The marginal rate rises faster and crosses 100% at about 0.71, the wall, marked with a red dot from which a dashed line drops to the axis. The per-instance refund weight grows to about 0.42 right at the wall and then falls, while the per-user refund weight falls from the start.]({% link media/2026-11-14/formula-contributo.svg %}){: .img-fluid }
</div>
</div>

The chart was made with LabPlot, a free KDE program for data analysis and plotting, which runs on Linux, Windows and macOS. You can [download]({% link media/2026-11-14/formula-contributo.lml %}) the project and open it with LabPlot 2.12 or later. The parameters are in the "parametri" sheet, and by changing the number at the start of the formula in the `amin` and `k` columns the curves recalculate themselves, so you can see where the wall moves to. The wall point and the maximum line also come from the parameters, so they move along with the curves.

That leaves deciding what happens to the extra money. The foundation would have a budget fixed by the statutes, $B$, which includes the certifier's share. If instances pay in more than that budget, part of the surplus would fund shared services, such as the abuse-isolation one, and the rest would go back to the instances, in proportion to their users, because servers, electricity and moderators cost in proportion to users. The surplus would be

$$S = \max\Bigl(0, \sum_i F_i - B\Bigr)$$

where $F_i$ is the contribution of the individual instance $i$, the sum $\sum_i$ adds them all up, and the maximum of zero and the difference simply says that, if contributions stay below the budget, there's nothing to redistribute. Each instance would receive a share of the surplus proportional to a weight $w_i$, that is its users, each counted for what the instance keeps after the rate, $1 - a(U_i)$, almost in full for small instances and a bit less for big ones:

$$q_i = S \cdot \frac{w_i}{\sum_j w_j}, \qquad w_i = U_i \bigl(1 - a(U_i)\bigr)$$

At the end of the year, what each instance actually pays is the contribution minus the refund:

$$N_i = F(R_i, U_i) - q_i$$

Dividing by the sum of all instances' weights, $\sum_j w_j$, is only there to make sure the shares, added together, come to exactly the surplus. The weight grows with users, as costs do, but per user it's a little higher in small instances, and since big ones pay a higher rate and get back a bit less per user, on balance they'd shoulder part of the small ones' bill. It's a form of welfare between instances, where the stronger support the weaker. A federated network lives on its small instances, the village festival committee, the association, the school, and keeping them going is in the big ones' interest too, since without them they'd just be yet another centralised social network under another name. The weight has another useful property as well. It stops growing exactly where the marginal rate hits 100%, and falls from there on, so the refund helps an instance cover its costs while it grows healthily, but barely shifts the point beyond which growing no longer pays. It's a progressive tax applied to size instead of income, and all the calculations would be pure functions, which anyone can redo with the same numbers and get the same result.

{% endkatexmm %}

## Who tried before

I'm not the first to think of a different social network, and those who tried before left useful lessons, even when things went badly.

App.net was born in August 2012 as an ad-free alternative to Twitter, paid for by user and developer subscriptions, with a crowdfunding campaign that passed 750,000 dollars from more than 11,000 backers. In 2013 it went free with paid services, and in January 2017 it announced its closure because, as TechCrunch put it, it simply wasn't making money. Co-founder Dalton Caldwell observed that plenty of people say they want more privacy and more control, but "few are willing to pay for it". The business model was honest, but a social network is worth as many people as there are in it, and asking for money from people who can't yet find anyone to talk to is a brutal uphill climb.

Caldwell's line, read from this side of the Atlantic, says far more than he meant it to. For him privacy is an extra, which those who care about it buy at a premium, and it's the same logic by which Apple has turned it into a selling point for expensive products, an option on the price list, like heated seats in a car, which those with money buy and everyone else can whistle for. It matters as a consumer good, not as a right. In Europe the protection of personal data is a fundamental right, written into the Union's Charter of Fundamental Rights alongside respect for private life, and paying to have it would be like paying to be treated in A&E. In the United States, where you have to pay just to avoid snuffing it on the pavement, they evidently have no instinct for self-preservation.

The American jurist James Whitman, as far back as 2004, described two cultures of privacy, a European one founded on dignity and an American one founded on freedom from the State, and the gap shows in the courts. The EU Court of Justice has struck down two agreements on data transfers to the United States, in 2015 and in 2020, and the third, upheld at first instance in 2025, is back before the Court. In April 2025 the Commission fined Meta 200 million euros because its "pay or consent" model didn't give users a real alternative to profiling. For a company that turned over 164 billion dollars in 2024 that's less than half a day's takings, the kind of sum that in Menlo Park doesn't even get the accountant out of his chair, they find it down the back of the sofa, but at least the principle has been put in writing.

In my view the gap is cultural before it's commercial, and that's why no agreement will close it. It's also why in this social network privacy wouldn't be for sale, because advertising would be unprofiled for everyone, and paying would let you remove the ads, not buy confidentiality. It's Proton's model, the Swiss email service that encrypts end-to-end even free accounts, with "the same level of encryption as any of our paid plans", and charges for space and extra services.

Diaspora in 2010 was the dream of four students at New York University, a distributed, privacy-respecting social network. On Kickstarter they asked for 10,000 dollars, reached it in twelve days, and ended up raising about 200,000 from almost 6,500 backers. Diaspora still exists, it's looked after by a foundation today, and yet it's always stayed niche. In my view it stayed there because it was hard to use, and those who got there didn't find their friends. The principles were right, and it fell on exactly the two things I put before everything else: ease of use and people.

Orkut died another way, by decision of its owner. It was Google's social network, in 2008 among the most visited sites in Brazil and India, and in 2014 Google shut it down, explaining that other communities of its own, such as YouTube, Blogger and Google+, were growing faster. And Google+, the great promise worth sacrificing Orkut for, met the same fate less than five years later, which in Mountain View is roughly the life expectancy of anything that doesn't become an advertising machine. An owner with other priorities is exactly the governance problem that the foundation, certifier and guarantor would be there to prevent.

Minds, finally, is the example of how not to do it. Born as a "free" alternative to Facebook, in 2018 it moved to a token on the Ethereum blockchain, with which it rewarded users for content and engagement, and which could be spent to give your own posts more visibility. Paying people to interact more is engagement maximisation written into the business model, with the token in place of the slot machine. They took the machine from the first instalment and bolted a blockchain on top of it, as if it didn't already do enough damage to the brain on its own, and to me it's simply shameful.

And then there's IFTAS, where I started, which teaches that the services the whole network needs can't depend on someone's generosity, because sooner or later generosity runs out.

## Who would put up the first money

Everything I've described would sustain itself once up and running, but at the start someone would have to pay for the software, the station and the first shared services, before a single instance exists to pay a contribution. That's the moment when projects like this die, or end up in the hands of the first investor who asks for growth at any cost in return.

One route, at least as a trial, already exists in Europe. In November 2026 the pilot of a European fund for free technologies got under way, the *EU Sovereign Tech Fund*, led by Germany's Sovereign Tech Agency within the Digital Commons EDIC, the European consortium for digital commons, and co-funded by the Union. From spring 2027 it should select a first small group of projects to fund. The fund, as described today, targets the infrastructure other software depends on, not applications, so the social network as a whole wouldn't qualify. The pieces that act as infrastructure for everyone, though, would: the protocol, the station or the shared anti-abuse service.

It would also be the most consistent choice for a Europe that doesn't just want to regulate other people's platforms, but to take an active stance and build. It's not the Europe we have now, I know, but that's partly what elections are for.

## What I can't solve

Some problems I haven't solved.

The first is the law. A European foundation can enforce a certification contract in Europe, but an instance in a country that doesn't recognise that contract would have the loss of the trademark as its only brake. For most instances that would be enough; for a player determined to ignore it, no.

The second is the definition of an active user, on which the whole formula depends. Counting accounts is easy and useless, because an abandoned account costs nothing, and counting those who log in every day pushes precisely towards what the project wants to avoid. An honest definition exists, I think, but it needs writing with care, and anyone with an interest in rigging it would have an enormous one.

The third is capture. I've set the foundation, certifier, guarantor and college to watch over one another, but a guarantor who is disinterested today can become interested tomorrow. All it takes is a well-paid appointment at the right moment, and the [second instalment]({% link _posts/en/2026-10-23-social-media-considered-harmful-2.md %}) has a name and surname to tell the story. I don't know of a mechanism that prevents it for ever. I can only make it expensive.

The fourth is the risk that certified instances become an enclosure, a closed club that uses certification to keep competition out. Public criteria and an ever-possible fork make that hard, not impossible.

And then, none of this exists. It's the description of a piece of software, and between a well-described idea and a social network that works lies the work of many people over many years.

## Maybe

This series is called "considered harmful. Maybe..." for a reason. Social networks as they're built today, as I described them in the first three instalments, do more harm than good in my view, and they know it too. The "maybe" lies entirely in the last two, because a social network that serves people instead of exploiting them could be built, but it means giving up growth at any cost, and accepting a design and governance effort that today's platforms have never wanted to make, because the opposite suited them. And when the opposite suits them, over there, ethics becomes a press release, written by marketing, polished by the lawyers and contradicted by the next quarterly report.

## Sources

- [IFTAS, "Funding challenges and the future of our work", 6 February 2025](https://about.iftas.org/2025/02/06/funding-challenges-and-the-future-of-our-work/)
- [IFTAS, 2024-2025 overview, with the projected 2025 budget](https://about.iftas.org/wp-content/uploads/2025/02/2024-2025-IFTAS-Overview.pdf)
- [Euronews, on big tech spending on lobbying in Brussels, 29 October 2025](https://www.euronews.com/2025/10/29/big-tech-spending-on-brussels-lobbying-hits-record-high-report-claims)
- [GNU Affero General Public License, version 3](https://www.gnu.org/licenses/agpl-3.0.html)
- [Regulation (EU) 2022/2065, Digital Services Act, Article 37](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2065)
- [Mastodon Server Covenant](https://joinmastodon.org/covenant)
- [Einkommensteuergesetz, § 32a, income tax schedule](https://www.gesetze-im-internet.de/estg/__32a.html)
- [Heathcote, Storesletten, Violante, "Optimal Tax Progressivity: An Analytical Framework", NBER Working Paper 19899, 2014, later Quarterly Journal of Economics, 2017](https://www.nber.org/papers/w19899)
- [App.net, Wikipedia](https://en.wikipedia.org/wiki/App.net)
- [TechCrunch, the closure of App.net, 12 January 2017](https://techcrunch.com/2017/01/12/app-net-the-ambitious-project-to-build-a-better-twitter-is-finally-dead)
- [Charter of Fundamental Rights of the European Union, Articles 7 and 8](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:12012P/TXT)
- [James Q. Whitman, "The Two Western Cultures of Privacy: Dignity Versus Liberty", Yale Law Journal, 113(6), 2004](https://yalelawjournal.org/article/the-two-western-cultures-of-privacy-dignity-versus-liberty)
- [heise online, the challenge to the Data Privacy Framework reaches the Court of Justice](https://heise.de/-10965203)
- [European Commission, "Commission finds Apple and Meta in breach of the Digital Markets Act", 23 April 2025](https://digital-markets-act.ec.europa.eu/commission-finds-apple-and-meta-breach-digital-markets-act-2025-04-23_en)
- [Meta, fourth quarter and full year 2024 results, 29 January 2025](https://investor.atmeta.com/investor-news/press-release-details/2025/Meta-Reports-Fourth-Quarter-and-Full-Year-2024-Results/default.aspx)
- [Oversight Board, "Securing Ongoing Funding for the Oversight Board", on Meta's funding of the board](https://oversightboard.com/?p=5008)
- [Apple, the privacy page](https://www.apple.com/privacy/)
- [Proton Mail, plans and pricing](https://proton.me/mail/pricing)
- [Diaspora, Wikipedia](https://en.wikipedia.org/wiki/Diaspora_%28social_network%29)
- [Orkut, Wikipedia](https://en.wikipedia.org/wiki/Orkut)
- [TechCrunch, "Google+ for consumers will shut down on April 2nd", 30 January 2019](https://techcrunch.com/2019/01/30/google-for-consumers-will-shut-down-on-april-2nd)
- [CoinDesk, "Blockchain Social Network Minds Is Migrating to Ethereum for Launch", 13 August 2018](https://coindesk.com/markets/2018/08/13/blockchain-social-network-minds-is-migrating-to-ethereum-for-launch/)
- [Fortune, on Minds and its token, 16 September 2021](https://fortune.com/2021/09/16/minds-social-network-crypto-balance-sheet-ethereum-bitcoin-usd-coin/)
- [Sovereign Tech Agency, EU Sovereign Tech Fund](https://www.sovereign.tech/programs/eu-sovereign-tech-fund)
- [LabPlot, free KDE software for data analysis and visualisation](https://labplot.org/)
