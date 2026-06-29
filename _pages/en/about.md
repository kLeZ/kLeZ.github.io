---
layout: page
title: About me
permalink: /about/
lang: en
locale: en
source_sha: 7a242d792f256e99
---

{% capture incl_about %}{% include_relative includes/about.md %}{% endcapture %}
{{ incl_about | markdownify }}
