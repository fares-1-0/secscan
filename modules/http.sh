#! /bin/bash
check_and_enum_http(){
	if  [ -n "$http_line" ];then
        	echo
		log_message "[+] HTTP detected"
            	log_message "[*] Starting HTTP enumeration..."
            	http_head=$(curl -sI http://"$target")
            	http_robot=$(curl -s http://"$target"/robots.txt)
            	if [ -n "$http_head" ]; then
    			log_message "[!] HTTP headers detected"
    			log_message "Evidence: $http_head"
		else
    			log_message "[-] HTTP headers not retrieved"
		fi
            	if ! echo "$http_robot" | grep -iq "<title>404 Not Found</title>";then
            		log_message "[!] robots.txt found"
            		log_message "Evidence: $http_robot"
            		echo "$http_robot"
            	else
            		log_message "[+] robots.txt not found (404)"
            	fi
        fi
}
