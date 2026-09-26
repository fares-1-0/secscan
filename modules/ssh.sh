#! /bin/bash
check_and_enum_ssh(){
	if  [ -n "$ssh_line" ];then
        	echo
		log_message "[+] SSH detected"
            	log_message "[*] Starting SSH enumeration..."
            	log_message "SSH version/banner detected"
            	log_message "Evidence: $ssh_line"
    	else
        	log_message "[+] SSH version/banner not detected"
        fi
}
