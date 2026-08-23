---
layout: archive
title: "Accounting"
permalink: /accounting/
classes: wide
---

CPA journey, finance tooling and projects at the intersection of accounting and code.

{% assign section_posts = site.posts | where_exp: "post", "post.categories contains 'Accounting'" %}
{% for post in section_posts %}
  <article>
    <h2>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </h2>
    <p class="page__meta">
      <i class="far fa-calendar"></i> <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time>
    </p>
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
    <a href="{{ post.url }}" class="btn btn--primary">Read more</a>
  </article>
{% endfor %}
