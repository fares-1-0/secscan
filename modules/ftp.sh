#! /bin/bash
check_and_enum_ftp(){
	if  [ -n "$ftp_line" ];then
		echo
		log_message "[+] FTP detected"
            	log_message "[*] Starting FTP enumeration..."
            	ftp_output=$(printf "user anonymous \"\"\nls\nbye\n" | ftp -inv "$target")
		if echo "$ftp_output" | grep -q "Login successful"; then
        		log_message "[!] Anonymous FTP login: VULNERABLE"
        		log_message "Evidence: FTP $target -> login as anonymous succeeded"
        		log_message "$ftp_output"
    		else
        		log_message "[+] Anonymous FTP login: not allowed"
    		fi	
        fi
}
