#! /bin/bash
check_and_enum_dns(){
	if  [ -n "$dns_line" ];then
        	echo
		log_message "[+] DNS detected"
            	log_message "[*] Starting DNS enumeration..."
            	dns_enum=$(dig axfr @"$target" "$host_name")
            	if echo "$dns_enum" | grep -qi "xfr size";then
            		log_message "[!] DNS zone transfer enumeration: VULNERABLE"
            		log_message "Evidence: $dns_enum"
            	else
            		log_message "[+] DNS zone transfer enumeration not detected"
          	fi 
        fi
}
