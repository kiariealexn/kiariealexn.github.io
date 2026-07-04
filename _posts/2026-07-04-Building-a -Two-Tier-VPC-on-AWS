---
layout: post
title: "Building a Two-Tier VPC on AWS: Public/Private Subnets, NAT Gateway, and a Bastion Host"
date: 2026-07-04
categories: [networking, cloud, ccna]
tags: [aws, vpc, nat-gateway, networking, ccna]
---

## Why I Built This

I'm currently working through CCNA Course 3 (ENSA), and a lot of it - subnetting, default routes, NAT - reads fine on paper but doesn't fully click until you've watched it actually move traffic. With $100 in AWS credits sitting unused, I decided to rebuild the classic "public subnet / private subnet" enterprise pattern from scratch in the AWS Console, rather than using a one-click VPC wizard, specifically so I'd have to reason through every routing decision myself.

The result: a small, fully functional two-tier network that mirrors what you'd find behind most production web applications - a public-facing server, a private backend server with zero direct internet exposure, and a bastion-host pattern for reaching it.

## The Architecture

```
                Internet
                    |
             [Internet Gateway]
                    |
        ┌───────────┴───────────┐
        │      lab-vpc (10.0.0.0/16)
        │
        │  public-subnet (10.0.1.0/24)
        │  ├── public-server (EC2, public IP)
        │  └── NAT Gateway (Elastic IP)
        │
        │  private-subnet (10.0.2.0/24)
        │  └── private-server (EC2, no public IP)
        │
        └───────────────────────┘
```

- **public-subnet** routes `0.0.0.0/0` → Internet Gateway
- **private-subnet** routes `0.0.0.0/0` → NAT Gateway (which itself lives in the public subnet)

That distinction - NAT Gateway physically sitting in the public subnet while serving the private one - was the first thing that didn't fully make sense until I'd actually wired it up.

## Build Steps

**1. VPC and subnetting**
Created a `/16` VPC and carved out two `/24` subnets in the same AZ - one public, one private. Straightforward CIDR math, but a useful reminder that "public" and "private" in AWS aren't inherent properties of a subnet - they're just a consequence of which route table gets attached to them.

**2. Internet Gateway + route table**
Attached an IGW to the VPC, then created a route table with a default route (`0.0.0.0/0` → IGW) and associated it with the public subnet only. This is the AWS equivalent of a default route pointing at your ISP's next hop - the private subnet, using a *different* route table with no such route, is effectively unreachable from and to the internet by default.

**3. Public EC2 instance**
Launched an Amazon Linux instance into the public subnet. The security group here is doing the actual firewall work: it allows inbound SSH (port 22) with the source locked to my own IP address rather than `0.0.0.0/0` - no reason to expose SSH to the entire internet for a lab box, and connected via PuTTY.

**4. NAT Gateway + private route table**
This is the core of the lab. Created a NAT Gateway (with its own Elastic IP) inside the public subnet, then built a second route table for the private subnet pointing `0.0.0.0/0` at the NAT Gateway instead of the IGW.

**5. Private EC2 instance + bastion access**
Launched a second instance into the private subnet with **no public IP assigned at all**. Its security group only allows inbound SSH from the public subnet's CIDR range (`10.0.1.0/24`) - not from my laptop's IP, and not from the internet at large. That single rule is what actually enforces the "unreachable except through the bastion" behavior; without it, having no public IP alone wouldn't be enough of a guarantee inside a more complex network.

Since there's no public IP, PuTTY on my laptop can't reach it directly - I had to hop through the public server first, the classic bastion/jump-host pattern:

1. Loaded `lab-key.ppk` into **Pageant** (PuTTY's SSH agent) on my laptop
2. On the PuTTY session config for the *public* server, enabled **"Allow agent forwarding"** under Connection → SSH → Auth
3. Connected to the public server as usual
4. From inside that session, ran `ssh ec2-user@<10.0.2.1>` - and because Pageant was forwarding my key through the connection, it authenticated without the private key ever having to exist as a file on the public server

That last point matters: the private key never touches the bastion's disk. If the public server were ever compromised, there's no key sitting on it for an attacker to steal and reuse.

## The Payoff Moment

Running `curl ifconfig.me` from each box told the whole story:

- From the **public server**: returned the instance's own public IP
- From the **private server**: returned the **NAT Gateway's Elastic IP** instead

The private instance has full outbound internet access - it could update packages, hit an external API, whatever - but nothing on the internet could have opened a connection *to* it. That's the exact pattern behind why databases and internal services sit in private subnets in real deployments: outbound access without inbound exposure.

## Cost Management

NAT Gateway is the one resource in this build that actually costs money - roughly $0.045/hour plus data processing, whether or not traffic is flowing - so I tore it down and released its Elastic IP immediately after testing, keeping the whole exercise under $1.

## Where This Connects

Subnetting and default routing are core CCNA Course material - just expressed here in AWS instead of Packet Tracer. NAT itself is actually Course 3 (ENSA) territory, so this lab ended up previewing a concept slightly ahead of where my coursework currently sits, which was a useful head start. It's also a reminder that the instincts you build doing audit and controls work - tracing exactly what can access what, and why - mapped directly onto network security design. A security group is, in the end, just an access control matrix.

Next step: automating this build with the AWS CLI or Terraform, so the same topology can be spun up and torn down in seconds instead of clicking through the console.
