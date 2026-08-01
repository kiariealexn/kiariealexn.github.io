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
    <p>CPA candidate. Cloud &amp; network builder. Auditor who ships infrastructure.</p>
  </div>
</div>
<p style="text-align: center; font-size: 1.3em; font-weight: bold; color: #FFFFFF;">
  B.A Economics | Sales | IT Operations
</p>

---

# Hi, I'm Alex Kiarie

IT and finance professional building at the intersection of accounting, sales, and technology — Advanced CPA candidate, AWS Cloud Practitioner, CCNA.

<div class="section-preview-grid">
  <a href="/accounting/" class="section-preview-card">
    <h3>Accounting</h3>
    <p>CPA study notes, finance tooling, and projects at the intersection of accounting and code.</p>
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

**Depreciation Calculator** — professional web tool for asset depreciation analysis. Phase 1 complete; adding Chart.js visualizations next.

## Stack

**Languages:** JavaScript, HTML, CSS
**Cloud & Infra:** AWS (S3, CloudFront, Route 53, EC2, VPC), GitHub Actions
**Networking:** CCNA (Switching, Routing & Wireless Essentials)
**Finance:** CPA candidate (KASNEB), economics background

## Connect

[LinkedIn](https://www.linkedin.com/in/alex-k-4784861a0/) · [GitHub](https://github.com/kiariealexn)
