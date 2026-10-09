# secscan.sh - Bash Security Assessment Tool

## Overview

A mini automated security assessment framework written in Bash. Instead of running each check by hand, this project collects them into a single program that scans a target, enumerates its services, and produces a report.

## Usage

```bash
./secscan.sh <target>
```

## Flags

| Flag | Description |
| ---- | ----------- |
| `--help` | Show usage instructions |
| `--version` | Display the tool version |
| `--developer` | Show developer name and contact information |

## Target

Only scan targets that you own or have explicit permission to test.

- ✅ Allowed: local virtual machines running on your own computer
- ✅ Allowed: CTF / lab environments explicitly authorized for testing
- ❌ Not allowed: random public IP addresses or live websites without authorization

> **Warning:** The lab VMs used for this project are community-contributed and not officially vetted for safety. Always run them in an isolated network (Host-only Adapter) and never on a machine holding sensitive data.

The developer is not responsible for misuse of this tool.

Example VMs: DC-6, VulnOS: 1, SecOS: 1, Metasploitable 2

## Project Structure

```
secscan/
├── secscan.sh          # Main script - orchestrates the full workflow
├── modules/            # Service-specific check modules
│   ├── flags.sh        # --help, --version, --developer handling
│   ├── ftp.sh          # FTP anonymous login check
│   ├── ssh.sh          # SSH version/banner detection
│   ├── smb.sh          # SMB share enumeration
│   ├── smtp.sh         # SMTP user enumeration
│   ├── dns.sh          # DNS zone transfer check
│   └── http.sh         # HTTP headers and robots.txt check
├── report/             # Generated after each scan
│   ├── scan.txt        # Reconnaissance and port scan results
│   ├── finding.txt     # Vulnerabilities with evidence
│   └── summary.txt     # Quick summary of the scan
└── snapshot/           # [write here what this folder contains]
```

## Features

- **Reconnaissance:** host availability check, hostname resolution, network interface and MAC address detection
- **Port & Service Enumeration:** full TCP port scan with service/version detection and structured output
- **Automated Decision-Making:** detects which services are open (FTP, SSH, SMB, SMTP, DNS, HTTP) and runs the matching security check for each
- **Security Checks:** every finding is backed by real evidence, not just a label
- **Report Generation:** automatically produces scan, findings, and summary reports

## Requirements

The following tools must be installed on the system running the script:

| Tool | Used for |
| ---- | -------- |
| `nmap` | Port scanning and service detection |
| `ping` | Host availability check |
| `nmblookup` | NetBIOS hostname resolution |
| `smbclient` | SMB share enumeration |
| `nc` (netcat) | SMTP user enumeration |
| `dig` | DNS zone transfer check |
| `curl` | HTTP headers and robots.txt check |
| `ftp` | FTP anonymous login check |

## Report Output

After each scan, three files are generated in the `report/` directory:

- **scan.txt:** target info, hostname, network details, and all open ports with detected services and versions
- **finding.txt:** every security finding detected, each with supporting evidence
- **summary.txt:** a quick overview with the target, scan date, number of open ports, and number of vulnerabilities found

## What I Implemented Myself

- Designed the workflow: check IP → recon → port and version scan → vulnerability checks → report
- Wrote the scan and enumeration loops
- Wrote the variable declarations and flag handling, for example `ftp_line=$(echo "$open_ports" | grep -i "ftp")`
- Wrote all the flags and functions in the `modules/` directory

I wrote the whole code myself, with help from Claude AI for some commands.

## Author

Fares Mohamed Abd Elaty
