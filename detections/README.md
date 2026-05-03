# Detections

Threat detections I've built and deployed, documented with enough detail to understand the logic, the implementation, and the response workflow. Covers both the attack technique being detected and the design decisions behind the detection itself.

Built in Splunk with automated response playbooks in SOAR.

---

## Detections

| File | Technique | Platform |
|---|---|---|
| [kerberoasting-T1558.003.md](kerberoasting-T1558.003.md) | Kerberoasting — abnormal service ticket requests | Splunk + SOAR |
| [darknet-subnet.md](darknet-subnet.md) | Network reconnaissance via darknet/honeypot subnet | Network tap + Splunk |
