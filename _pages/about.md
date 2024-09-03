---
layout: page
title: About me
permalink: /about/
---

{% capture incl_about %}{% include_relative includes/about.md %}{% endcapture %}
{{ incl_about | markdownify }}
