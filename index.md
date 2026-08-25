---
layout: splash
author_profile: true
title: false
classes: wide
permalink: /
---

<div class="matrix-hero">
  {% include matrix-rain.html %}
  <div class="matrix-hero__content">
    <h1>Alex Kiarie</h1>
    <p>Economics Grad .CPA .Cloud Practitioner .CCNA .Cybersec</p>
  </div>
</div>

---

<div class="section-preview-grid">
  <a href="/accounting/" class="section-preview-card">
    <h3>Accounting</h3>
    <p>Finance tooling and projects at the intersection of accounting and code.</p>
  </a>
  <a href="/networking/" class="section-preview-card">
    <h3>Networking</h3>
    <p>CCNA labs, router troubleshooting, and cloud/network infrastructure projects.</p>
  </a>
</div>

## Recent Log Entries

{% assign recent_posts = site.posts | slice: 0, 4 %}
{% for post in recent_posts %}
  <div class="log-entry">
    <p class="log-entry__meta">LOG · {{ post.date | date: "%Y-%m-%d" }} · {{ post.categories | join: "/" }}</p>
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  </div>
{% endfor %}

[View all posts →](/posts/)

## Currently Building

**Depreciation Calculator** - professional web tool for asset depreciation analysis. 

## Stack

**Finance:** CPA(KASNEB), Economics background
**Languages:** JavaScript, HTML, CSS
**Cloud & Infrastructure:** AWS (S3, CloudFront, Route 53, EC2, VPC), GitHub Actions
**Networking:** CCNA (Enterprise Networking, Security, and Automation)


## Connect

[LinkedIn](https://www.linkedin.com/in/alex-k-4784861a0/) · [GitHub](https://github.com/kiariealexn)
