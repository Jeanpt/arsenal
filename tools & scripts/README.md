# Tools & Scripts

Custom scripts for recon and utility tasks. These are small, focused tools — nothing that replaces nmap or burp, just things that fill specific gaps or automate repetitive steps.

---

## scanner.py

A concurrent TCP port scanner that checks all 65535 ports using Python threads.

**Usage:**
```
python3 scanner.py <target>
```

Where `<target>` is a hostname or IP address. The script resolves hostnames automatically.

Each port gets its own thread, so the full scan runs fast. Open ports are printed as they're found. Output includes a timestamp at the start so you know when the scan ran.

**Dependencies:** Python 3 standard library only (socket, threading, datetime).

---

## git-merger.sh

Merges all text-based files from a dumped Git repository into a single output file with labeled section headers. Useful for reviewing exposed `.git` directories where you've recovered the source tree and want to read it as one file rather than browsing each file individually.

**Usage:**
```
git-merger.sh <git_repo_path> [output_file] [--txt]
```

By default, output is wrapped in PHP comment blocks and saved as a `.php` file (convenient for reviewing PHP source). Pass `--txt` to use plain comment headers instead.

**Examples:**
```
git-merger.sh dumped_repo                    # -> merged_dumped_repo.php
git-merger.sh dumped_repo out.txt --txt      # -> out.txt
```

The script skips binary files and will not overwrite an existing output file.

**Dependencies:** bash, `file` command (standard on Linux/macOS).
