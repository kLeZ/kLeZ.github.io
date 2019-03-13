---
layout: page
title: Contatti
permalink: /contatti/
---

Puoi contattarmi su uno qualsiasi degli account di cui dispongo, non è importante quale, e penso che dipenderà soprattutto dal tuo scopo.

A disposizione hai:
{: .m-0 .p-0 }
{% assign available_networks = site.data.author.social | where_exp: "item", "item.readonly != true" %}
{% include social-vertical.html networks=available_networks %}
