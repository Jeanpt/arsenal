# Kerberoasting Detection

**MITRE ATT&CK:** [T1558.003 - Steal or Forge Kerberos Tickets: Kerberoasting](https://attack.mitre.org/techniques/T1558/003/)  
**Platform:** Splunk + SOAR  
**Fidelity:** Medium-High (baselined per user)

---

## What It Detects

Kerberoasting is an offline credential attack where an attacker requests Kerberos service tickets (TGS) for accounts with SPNs, then cracks them offline to recover plaintext passwords. The attack is stealthy because requesting service tickets is a normal part of Kerberos — the signal is in the volume and pattern, not a single event.

This detection catches the reconnaissance phase: a user requesting an abnormally high number of service tickets in a short window, particularly for accounts they don't typically interact with.

---

## Detection Logic

Built as a Splunk correlation search over Windows Security Event logs.

**Key event:** `EventCode=4769` — A Kerberos service ticket was requested.

The search:
1. Aggregates TGS requests per user over a rolling time window
2. Compares current volume against a per-user historical baseline
3. Flags users whose request count exceeds a threshold deviation from their baseline
4. Filters on `Ticket Encryption Type = 0x17` (RC4-HMAC) — the encryption type Kerberoasting tools request because RC4 hashes crack faster than AES

```spl
index=windows EventCode=4769 Ticket_Encryption_Type=0x17
| bucket _time span=1h
| stats count as ticket_requests by _time, Account_Name, Service_Name
| eventstats avg(ticket_requests) as baseline stdev(ticket_requests) as stddev by Account_Name
| where ticket_requests > (baseline + (3 * stddev))
| table _time, Account_Name, Service_Name, ticket_requests, baseline
```

> Threshold is 3 standard deviations above the user's own baseline. Tuned per environment — lower threshold in low-noise environments, higher in noisy ones.

---

## Why RC4 Filter Matters

Modern environments configured for AES Kerberos will almost never legitimately request RC4 tickets. Filtering on `0x17` sharply reduces noise and is a strong indicator of tooling (Rubeus, Impacket, etc.) rather than organic user behavior.

---

## SOAR Response Playbook

On alert trigger:

1. **Enrich** — pull account details, group memberships, recent auth history, and associated host from AD
2. **Verify** — check if the source host is a known pentest or red team asset (suppresses if so)
3. **Contain** — if confirmed anomalous, disable the account in AD and revoke active sessions
4. **Notify** — page the SOC with alert context, enrichment summary, and containment actions taken
5. **Ticket** — auto-create an incident ticket with full timeline attached

Containment is automated but reversible — account re-enablement requires analyst approval.

---

## False Positive Considerations

- **Service accounts running scheduled jobs** that legitimately request many tickets — these should be baselined and excluded by SPN or account name
- **Applications doing broad SPN lookups** on startup — identify and allowlist
- **Red team / pentest activity** — coordinate with the team and suppress by source IP or asset tag during engagements

---

## References

- [MITRE T1558.003](https://attack.mitre.org/techniques/T1558/003/)
- [Microsoft - Event 4769](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4769)
