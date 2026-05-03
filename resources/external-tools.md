# External Tools & References

---

## Web Pentest Toolkit

### hackkit.dev

Browser-based toolkit for web pentest and bug hunting — no install required.

**Useful modules:**
- JWT forge and attack suite
- XXE payload generator
- Google Dork builder
- SSRF bypass payloads
- SAML forge
- XSS lab

Good for quick payload generation and testing web-layer vulnerabilities without spinning up a local tool.

---

## AV / EDR Evasion

### amsi.fail

Generates obfuscated PowerShell snippets that break or disable AMSI for the current process. Each generated payload is randomized to avoid static signatures.

**Usage:** Paste the generated snippet at the top of a PowerShell session before running tools that would otherwise get flagged.

---

### PowerJoker

Python-based dynamic PowerShell reverse shell generator. Produces unique payloads with different output on each execution to avoid signature detection. Includes AMSI bypass.

**Repo:** https://github.com/Adkali/PowerJoker

---

### DynWin32 Shellcode Process Hollowing

PowerShell script that uses dynamically looked-up Win32 API calls to execute shellcode via process hollowing, bypassing Defender static detection.

**Gist:** https://gist.githubusercontent.com/qtc-de/1ecc57264c8270f869614ddd12f2f276/raw/c5810a377af12b21629f25cd60b2e9c42713b8e8/DynWin32-ShellcodeProcessHollowing.ps1

**How it works:** Instead of calling Win32 APIs directly (which Defender hooks), it resolves them dynamically at runtime — hollow a target process and inject shellcode without triggering static signatures.

**Seen used on:** HTB Ghost
