---
layout: page
title: Contact
permalink: /contatti/
lang: en
locale: en
source_sha: 0933fab5cb22ea48
---

You can contact me on any of the accounts I have - it doesn't matter which, and I reckon it will mainly depend on what you want.

You have at your disposal:
{: .m-0 .p-0 }
{% assign available_networks = site.data.author.social | where_exp: "item", "item.readonly != true" %}
{% include social-vertical.html networks=available_networks %}

If you ever want to drop me a line of praise or disdain, I'd be grateful.  
Feel free to write even to spark a discussion - I'm always open to constructive dialogue.

Thanks.
