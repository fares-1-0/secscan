							# secscan.sh - Bash Security Assessment Tool

									## Overview ##
This is mini automated security assessment framework in Bash 
It is a mini project make an automatic securit check instead of write bash code and the framework for collect all of this itno one program

## Usage
'''bash
./secscan.sh <target> 
'''
									## Flags ##
'--help':     Show usage instructions like '## Usage'
'--version':  Display the tool version
'--developer': Show developer name and contact information

## Target
Only scan targets that you own or have explicit permission to test
[+] Allowed — Local virtual machines running on your own computer
[+] Allowed — CTF / lab environments explicitly authorized for testing
[-] Not allowed — Random public IP addresses or live websites without authorization
[!] Lab VMs used for this project are community-contributed and not officially vetted for safety. Always run them in an isolated network (Host-only Adapter) and never on a machine holding sensitive data.
Warning the developers is not reponsible for bad using
Examples VMs allowed [DC-6, VulnOS: 1, SecOS:1 , Metasploitable	2]

								## Project Structure ##
secscan/
├── secscan.sh          # Main script - orchestrates the full workflow
├── modules/            # Service-specific check modules
│   ├── flags.sh        # --help, --version, --developer handling
│   ├── ftp.sh           # FTP anonymous login check
│   ├── ssh.sh           # SSH version/banner detection
│   ├── smb.sh           # SMB share enumeration
│   ├── smtp.sh          # SMTP user enumeration
│   ├── dns.sh           # DNS zone transfer check
│   └── http.sh          # HTTP headers and robots.txt check
├── local/
│   └── app.log          # Full execution log (raw)
└── report/
    ├── scan.txt          # Reconnaissance and port scan results
    ├── finding.txt        # Vulnerabilities with evidence
    └── summary.txt        # Quick summary of the scan

								## Features ##
- **Reconnaissance**: Host availability check, hostname resolution, network interface and MAC address detection
- **Port & Service Enumeration**: Full TCP port scan with service/version detection, structured output
- **Automated Decision-Making**: Detects which services are open (FTP, SSH, SMB, SMTP, DNS, HTTP) and runs the matching security check for each
- **Security Checks**: Every finding is backed by real evidence, not just a label
- **Report Generation**: Automatically produces scan, findings, and summary reports

								## Requirements ##
The following tools must be installed on the system running the script:
'nmap' - port scanning and service detection
'ping' - host availability check
'nmblookup' - NetBIOS hostname resolution
'smbclient - SMB share enumeration
'nc' - (netcat) - SMTP user enumeration
'dig' - DNS zone transfer check
'curl' - HTTP headers and robots.txt check
'ftp' - FTP anonymous login check

								## Report Output ##
After each scan, three files are generated in the 'report/' directory:
**scan.txt**: Target info, hostname, network details, and all open ports with detected services and versions
**finding.txt**: Every security finding detected, each with supporting evidence
**summary.txt**: A quick overview — target, scan date, number of open ports, and number of vulnerabilities found

							## What I Implemented Myself ##
I designed a workflow for project split into [check ip -> recon.-> check ports and its versions -> found vulnerabities -> exploit the vulnerabity -> make a report]
Stage of scan and enum loops in it specially written by developer .
Declaration flags and assignment it like this 'ftp_line=$(echo "$open_ports" | grep -i "ftp")'.
Writed all the flags and functions in directory './modules '.
In short I Write the whole code but helped by Cloude AI in some commands.

									## Author ##
Fares Mohamed Abd Elaty
