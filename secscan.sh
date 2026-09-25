#!/bin/bash
mkdir -p local report
Log_file='./local/app.log'
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$Log_file"
}

if [ $# -ne 1 ];then
	log_message "Usage: $0 <target>"
	exit 1
fi

target=$1
is_reachable(){
	(timeout 5 ping -c 3 "$target">/dev/null 2>&1||
	(timeout 7 nmap -sn "$target"| grep -q -i "Host is up") >/dev/null 2>&1)
}
host_or_not(){
	local host_name=$(nmblookup -A "$target" | grep '<00>' | grep -v -i 'group' | awk '{print $1}'| head -n 1)
	if [ -n "$host_name" ];then
		log_message "[+] Host name: $host_name"
	else
		log_message "[-] Host name: not found"
	fi	
}
network_info(){
	local nic=$(ip route get "$target" | awk '{print $3}')
	local mac=$(arp -n "$target" | grep -i "$target" | awk '{print $3}')
	if [ -n "$nic" ];then
		log_message "[+] Network interface: $nic"	
	else
		log_message "[-] Network interface: not found"	
	fi
	
	if [ -n "$mac" ];then
		log_message "[+] Pyhsical address: $mac"	
	else
		log_message "[-] Pyhsical address: not found"
	fi
}

log_message "[*] Scan started for target: $target ..."
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
	log_message "[*] Starting port and service scan on $target..." 
	open_ports=$(nmap -sT -sV -T4 -p 21,2121 "$target" | grep -i 'open' | 
		     awk '{ line = $1 " - " $2 " - " $3 " - " 
		     for(i=4;i<=NF;i++) {
		     	line = line $i " "
		     }
		     	print line}'
		    ) 
	if [ -n "$open_ports" ];then
		log_message "[+] Open ports found:"
		echo "$open_ports" | while read  -r line ;do
			log_message "	  $line"
		done
	else
		log_message "[-] No open ports found"
	fi
}
test_ports
# 			End Port & Service Enumeration
decide_check(){
	ftp_lines=$(echo "$open_ports" | grep -i "ftp")
	if  [ -n "$ftp_lines" ];then
		log_message "[+] FTP detected"
            	log_message "[*] Starting FTP enumeration..."
        fi
	
}
decide_check

