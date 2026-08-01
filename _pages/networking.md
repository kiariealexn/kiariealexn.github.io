---
layout: archive
title: "Networking"
permalink: /networking/
classes: wide
---

<p>CCNA labs, router troubleshooting, and cloud/network infrastructure projects.</p>

{% assign section_posts = site.categories.networking %}
{% for post in section_posts %}
  <div class="log-entry">
    <p class="log-entry__meta">LOG · {{ post.date | date: "%Y-%m-%d" }} · {{ post.categories | join: "/" }}</p>
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  </div>
{% endfor %}
