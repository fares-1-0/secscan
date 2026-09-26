#!/bin/bash
for module in ./modules/*.sh; do
    source "$module"
done

mkdir -p local report
log_file='./local/app.log'
scan_file='./report/scan.txt'
finding_file='./report/finding.txt'
summary_file='./report/summary.txt'
: > "$log_file"
: > "$scan_file"
: > "$finding_file"
: > "$summary_file"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}
log_scan_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file" "$scan_file"
}

handle_flag "$1"

if [ $# -ne 1 ];then
	log_message "Usage: $0 <target>"
	exit 1
fi

target=$1
log_scan_message "[*] Scan started for target: $target ..."
is_reachable(){
	(timeout 5 ping -c 3 "$target">/dev/null 2>&1||
	(timeout 7 nmap -sn "$target"| grep -q -i "Host is up") >/dev/null 2>&1)
}
host_or_not(){
	host_name=$(nmblookup -A "$target" | grep '<00>' | grep -v -i 'group' | awk '{print $1}'| head -n 1)
	if [ -n "$host_name" ];then
		log_scan_message "[+] Host name: $host_name"
	else
		log_scan_message "[-] Host name: not found"
	fi	
}
network_info(){
	local nic=$(ip route get "$target" | awk '{print $3}')
	local mac=$(arp -n "$target" | grep -i "$target" | awk '{print $3}')
	if [ -n "$nic" ];then
		log_scan_message "[+] Network interface: $nic"	
	else
		log_scan_message "[-] Network interface: not found"	
	fi
	
	if [ -n "$mac" ];then
		log_scan_message "[+] Pyhsical address: $mac"	
	else
		log_scan_message "[-] Pyhsical address: not found"
	fi
}

if ! command -v nmap >/dev/null;then
	log_message "[-] nmap is not installed" 
	exit 1
fi

if ! is_reachable;then
	log_message "[-] Target is unreachable"
	exit 1
fi
host_or_not "$target"
network_info "$target"
			#	END OF RECONNAISSANCE

test_ports(){
	log_scan_message "[*] Starting port and service scan on $target..." 
	open_ports=$(nmap -sT -sV -T4 -p- "$target" | grep -i 'open' | 
		     awk '{ line = $1 " - " $2 " - " $3 " - " 
		     for(i=4;i<=NF;i++) {
		     	line = line $i " "
		     }
		     	print line}'
		    ) 
	if [ -n "$open_ports" ];then
		log_scan_message "[+] Open ports found:"
		echo "$open_ports" | while read  -r line ;do
			log_scan_message "	  $line"
		done
	else
		log_scan_message "[-] No open ports found"
	fi
}
test_ports
# 			End Port & Service Enumeration
check_and_enum(){
	#flags
	ftp_line=$(echo "$open_ports" | grep -i "ftp")
	ssh_line=$(echo "$open_ports" | grep -i "ssh")
	smb_line=$(echo "$open_ports" | grep -iE "netbios|microsoft-ds")
	smtp_line=$(echo "$open_ports" | grep -i "smtp")
	dns_line=$(echo "$open_ports" | grep -i "domain")
	http_line=$(echo "$open_ports" | grep -i "http")
	# check and enum some services
	check_and_enum_ftp
        check_and_enum_ssh
        check_and_enum_smb
        check_and_enum_smtp
        check_and_enum_dns
        check_and_enum_http
}
check_and_enum

generate_report(){
	grep -E "\[!\]|Evidence:" "$log_file" > "$finding_file"
}
generate_report

generate_summary(){
	{
	echo "Target: "$target""
	echo "Scan Date: $(date '+%Y-%m-%d %H:%M:%S')"
	echo "Open Ports Found: $(echo "$open_ports" | grep -c '/tcp')"
	echo "Vulnerabilities Found: $(grep -c '\[!\]' "$finding_file")"
	} >"$summary_file"
}
generate_summary
generate_html_report
# finish
