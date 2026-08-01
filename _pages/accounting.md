---
layout: archive
title: "Accounting"
permalink: /accounting/
classes: wide
---

<p>CPA study notes, finance tooling, and projects at the intersection of accounting and code.</p>

{% assign section_posts = site.categories.accounting %}
{% for post in section_posts %}
  <div class="log-entry">
    <p class="log-entry__meta">LOG · {{ post.date | date: "%Y-%m-%d" }} · {{ post.categories | join: "/" }}</p>
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  </div>
{% endfor %}
