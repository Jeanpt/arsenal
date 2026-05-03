# Darknet / Honeypot Subnet Detection

**MITRE ATT&CK:** [T1046 - Network Service Discovery](https://attack.mitre.org/techniques/T1046/), [T1595 - Active Scanning](https://attack.mitre.org/techniques/T1595/)  
**Platform:** Network tap / SIEM (Splunk)  
**Fidelity:** Near-zero false positives by design

---

## What It Detects

An intentionally unused subnet (darknet) deployed inside the network. No legitimate services run on it, no legitimate traffic should ever reach it. Any packet destined for this subnet is inherently anomalous — it can only come from misconfiguration, a worm scanning indiscriminately, or an attacker conducting reconnaissance.

Because the alert condition is binary (traffic exists or it doesn't), there is no threshold tuning, no baseline to maintain, and almost no false positive risk. High fidelity by construction.

---

## How It Works

A subnet is carved out of internal IP space and left entirely dark — no hosts, no routes advertised to end users, no services. A network sensor (span port, tap, or host-based agent) passively captures all traffic destined for the range.

Any hit generates an immediate alert. The detection does not need to correlate events or apply statistical analysis — a single packet is enough.

**What it catches:**
- Port scanners sweeping the internal range (nmap, masscan, Angry IP Scanner)
- Worms and malware using internal subnet propagation
- Misconfigured applications hitting the wrong IP range (rare, but investigable)
- Attackers who have already gained a foothold and are mapping the network

---

## Why This Works as a Detection Strategy

Network reconnaissance is almost always a prerequisite to lateral movement. Attackers need to discover live hosts and services before they can move. A darknet subnet forces them to reveal themselves during that phase — before they reach production systems.

The key property: **legitimate users have no reason to reach an unused subnet.** This removes the hardest part of detection work — distinguishing malicious behavior from normal behavior — entirely. There's no normal to baseline against.

---

## Alert Design

```
Source IP:       <internal host>
Destination:     <darknet subnet range>
Action:          ALERT — Immediate investigation required
Severity:        High
False positive:  Near-zero
```

Alert fires on first packet. No volume threshold. Any traffic is an incident.

---

## SOAR Response Playbook

On alert trigger:

1. **Capture** — log full packet metadata (src IP, dst IP, port, protocol, timestamp)
2. **Enrich** — identify the source host (hostname, owner, OS, last login, AD group memberships)
3. **Triage** — check if source is a known scanner, pentest asset, or monitoring tool
4. **Escalate** — if not suppressed, page the SOC and open a P1 incident
5. **Isolate (optional)** — if the source host shows additional indicators, trigger network isolation via EDR

---

## Deployment Notes

- Choose a subnet that fits naturally into existing IP space but has never been assigned — avoids accidental conflicts
- Ensure the subnet is not advertised in DNS or DHCP
- Document it internally so infrastructure teams don't accidentally assign it later
- Review suppression list periodically — legitimate scanners (vulnerability scanners, asset discovery tools) should be explicitly allowlisted by IP, not silently excluded

---

## References

- [MITRE T1046 - Network Service Discovery](https://attack.mitre.org/techniques/T1046/)
- [MITRE T1595 - Active Scanning](https://attack.mitre.org/techniques/T1595/)
