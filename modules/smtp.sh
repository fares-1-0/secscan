#! /bin/bash
check_and_enum_smtp(){
	if  [ -n "$smtp_line" ];then
        	echo
		log_message "[+] SMTP detected"
            	log_message "[*] Starting SMTP enumeration..."
            	smtp_enum=$(printf "VRFY root\nVRFY nonexistentuser_xyz123\nquit\n" | nc -w 10 "$target" 25)
		if echo "$smtp_enum" | grep -q "252" && echo "$smtp_enum" | grep -q "550" ;then
            		log_message "[!] SMTP user enumeration: VULNERABLE"
            		log_message "Evidence: $smtp_enum"
            	else
            		log_message "[+] SMTP user enumeration not detected"
          	fi 
        fi
}
