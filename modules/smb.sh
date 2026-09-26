#! /bin/bash
check_and_enum_smb(){
	if  [ -n "$smb_line" ];then
        	echo
		log_message "[+] SMB detected"
            	log_message "[*] Starting SMB enumeration..."
            	smb_output=$(smbclient -L //"$target" -N)
            	evd=$(echo "$smb_output" | grep -i "Anonymous login successful")
            	if [ -n "$evd" ];then
            		log_message "[!] Anonymous SMB login: VULNERABLE"
            		log_message "SMB Share enumeration detected"
            		log_message "Evidence: $smb_output"
            	else
            		log_message "[+] SMB Share enumeration not detected"
          	fi  		
        fi
}
