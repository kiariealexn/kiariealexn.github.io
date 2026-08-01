---
title: "Repurposing a Huawei HG8546M: ISP Locks, Privilege Tiers, and Why the External AP Won"
date: 2026-07-09
categories: [networking, home-lab]
tags: [networking, home-lab, ccna, huawei, troubleshooting]
layout: single
---

# Repurposing a Huawei HG8546M: ISP Locks, Privilege Tiers, and Why the External AP Won

## The Goal

My home network runs on a main router that handles DHCP and routing for the whole house. I had a Huawei HG8546M - a GPON ONT originally provisioned by my ISP - sitting unused after a router upgrade, and I wanted to repurpose it rather than let it gather dust. The plan: turn it into a wired LAN extension, fed by an Ethernet cable from the main router, with its own Wi-Fi radio extending coverage to another part of the house.

In theory, this is a well-understood pattern: disable the secondary device's routing and DHCP functions, give it a static IP within the main network's range, and let it act as a "dumb" access point sitting on the same subnet as everything else.

In practice, it surfaced a firmware-level limitation I hadn't run into before - and the workaround ended up being more interesting than the original plan.

## Setting Up the Wired Bridge

The first phase went smoothly and is worth documenting as the baseline approach for anyone doing this with similar hardware:

1. **Connect via LAN.** The HG8546M has no dedicated WAN/Internet port - all four of its physical ports are LAN ports. LAN1 connects to the main router; LAN2–4 are then free for downstream devices (APs, switches, wired clients).
2. **Assign a static management IP, outside the main router's DHCP pool.** I trimmed my main router's DHCP range to `.5–.250`, leaving the edges free for static assignments like this one.
3. **Disable the HG8546M's own DHCP server.** This is the step that turns it from "a second router" into "a bridge." Skipping it means two DHCP servers fighting over the same network - a classic source of intermittent, hard-to-diagnose connectivity issues.
4. **Leave WAN disabled.** No PON/internet uplink needed here; the main router already handles that.

One early gotcha worth flagging: the order of operations matters. Set the static IP *before* disabling DHCP, not after - otherwise the device can fall back to a default address outside your main subnet, locking you out of its admin panel until you manually adjust your own machine's IP to get back in. Also note that once the static IP is saved and the device reboots, the old default login address (e.g. `192.168.100.1`) no longer works - you'll need to browse to the new static IP (e.g. `192.168.100.3`) to get back into the admin UI from that point on.

With this done, wired devices plugged into the HG8546M's remaining LAN ports correctly pulled addresses from the main router. So far, so good.

## Where It Broke: The Wireless Side

This is where the plan met a wall. Devices connecting to the HG8546M's own Wi-Fi radio either failed to associate entirely, or connected but received a self-assigned APIPA address (`169.254.x.x`) - meaning no DHCP response ever arrived.

An APIPA address is the OS saying "I sent a DHCP discover broadcast and nobody answered, so I self-assigned a fallback address." It's not a routing problem or a DNS problem - it means the DHCP discover broadcast timed out with no response before reaching the main router's DHCP server. That distinction matters because it immediately rules out a whole class of fixes (static routes, port forwarding, DNS config) and points squarely at Layer 2 bridging between the WLAN interface and the wired LAN ports.

The diagnostic process ruled out the usual suspects one at a time:

- **AP/client isolation** - not present in this firmware at all.
- **VLAN or service-binding mismatch** - no configuration table exposed in the UI.
- **DHCP relay** - enabling it made no difference.
- **Security/handshake issues** - the SSID was visible and password correct, but association still failed for some devices.

The decisive test was plugging a separate, known-good access point into LAN2 on the HG8546M. That AP's Wi-Fi worked immediately - clients associated and received proper addresses from the main router. Since the wired switching fabric clearly worked, and an external AP riding on top of it worked, the only broken link was the HG8546M's own internal WLAN-to-LAN bridge.

## The Privilege Tier Discovery

At this point I'd concluded it was a firmware-level restriction - until I realised I'd been logging into the admin UI as `root` the entire time, rather than the higher-privilege `telecomadmin` account. These are two distinct login tiers on Huawei ONT firmware: `root` handles day-to-day config (LAN IP, DHCP, SSID settings), while `telecomadmin` unlocks ISP-provisioning level settings that `root` simply doesn't render in the UI at all.

Logging in as `telecomadmin` revealed a previously invisible **WAN configuration page**, including a service profile entry:

```
Connection Name:  1_INTERNET_B_VID_
Protocol:         IPv4
WAN Mode:         Bridge WAN
Service Type:     INTERNET
Binding Options:  LAN1  LAN2  LAN3  LAN4
                  SSID1 SSID2 SSID3 SSID4
```

This is the service-binding table we'd been hunting for - the thing that maps physical/wireless interfaces to internet service. It just lived behind a privilege tier the `root` account couldn't see.

## The WAN Bridge Mode Attempt

With `Bridge WAN` mode visible and `SSID1` being the only checkable binding option (LAN1–4 and SSID2–4 were greyed out - ISP-locked), the approach was:

1. Enable the WAN interface
2. Check SSID1 binding
3. Connect a laptop to SSID1 and test

On first attempt, the laptop got an APIPA address. After forgetting the network and reconnecting fresh - forcing a clean DHCP discover cycle rather than trying to renew a stale lease - the laptop successfully pulled an IP address from the main router's DHCP range. The DHCP path through the bridge was working.

However: **no network connectivity followed**. A ping to the main router (`192.168.100.1`) returned destination host unreachable. The reason: bridge mode requires both ends of the pipe to be bound - SSID1 on the wireless side, and at least one LAN port on the wired side to carry traffic out toward the main router. With LAN port binding ISP-locked and uncheckable, the bridge was open on the wireless end but had no wired uplink to complete the path. Traffic from SSID1 arrived at the bridge interface and had nowhere to go.

It's also worth noting that forcing the greyed-out LAN binding checkboxes via browser DevTools (removing the `disabled` attribute via inspect element) would likely not work either - on router admin UIs, these locks are typically enforced server-side in the firmware's request handler, not just in the HTML. Removing the `disabled` attribute changes what the browser renders, but the firmware would almost certainly reject or ignore the submitted value regardless. That said, this wasn't tested directly - it's based on how Huawei ONT firmware generally handles ISP-provisioned restrictions.

## The Workaround

Rather than fight the firmware further, I changed the plan:

- The **HG8546M now operates purely as a wired switch** - static IP, DHCP off, WAN off, Wi-Fi radio left unused.
- A **separate, dedicated access point** handles all wireless coverage, connected to one of the HG8546M's LAN ports.

This is a cleaner separation of concerns anyway: a switch switches, and an AP - built specifically to support bridging - handles wireless. The external AP auto-configured immediately and has been stable since.

## The Final Architecture

After exhausting every legitimate config path this firmware exposes - even at `telecomadmin` level - the outcome is:

- **HG8546M**: wired switch only. Static IP (`192.168.100.3`), DHCP off, WAN off, Wi-Fi radio unused.
- **External AP on LAN2**: handles all wireless coverage, auto-configured, pulling client addresses correctly from the main router's DHCP pool.

This is a cleaner separation of concerns anyway. A switch switches. An AP - purpose-built to support transparent bridging - handles wireless. The two roles don't need to live on the same device, and forcing them to rarely ends well on ISP-provisioned hardware.

## Takeaways

1. **Login privilege tiers are a real variable.** On Huawei ONT firmware, `root` and `telecomadmin` render different UI surfaces entirely - not just different permissions on the same menus, but whole pages and config tables that simply don't appear at the lower tier. Always verify which account you're using before concluding a setting doesn't exist.

2. **APIPA tells you exactly where to look.** A `169.254.x.x` self-assigned address means a DHCP discover went unanswered - the problem is Layer 2 delivery, not routing, DNS, or any IP-layer config. That narrows the search space immediately and rules out an entire class of fixes (static routes, port forwarding, etc.) before you waste time on them.

3. **Wired and wireless paths on the same device can be completely separate internally**, even after DHCP is disabled globally. "I turned off DHCP" doesn't mean the device is now a transparent bridge - internal service binding controls which interfaces are actually in the same broadcast domain, and that binding can be ISP-locked at a level no UI tweak can reach.

4. **Browser-side workarounds probably don't beat server-side enforcement.** Forcing a greyed-out checkbox via DevTools inspect element changes what the browser renders, but ISP-provisioned firmware typically validates and rejects locked fields server-side regardless of what the browser submits. Worth knowing before spending time on it.

5. **Isolate variables before concluding.** The external-AP-on-LAN2 test was the single most diagnostic step in this whole process - it proved the switching fabric worked, the DHCP path worked, and the only broken link was the HG8546M's own radio. Without that test, the investigation could have gone in circles much longer.

6. **ISP-provisioned hardware has a design ceiling.** The HG8546M's Wi-Fi was built as a managed ISP service, not a general-purpose bridge port. Once you understand that framing, the ISP locks stop feeling like obstacles and start making sense as intentional design - just not design that serves your use case.

This is part of an ongoing home networking project. .
