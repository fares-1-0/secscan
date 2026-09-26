#!/bin/bash
handle_flag(){
case "$1" in
	--help)
	        echo ". mini automated security assessment tool"
	        echo ".. Perform reconnaissance, port scanning, service-specific security checks, find vulnerabilty and make report and summary of target "
        	exit 0
        	;;
    	--version)
        	echo "secscan.sh v1.0"
        	exit 0
        	;;
        --developer)
        	echo "Fares Mohamed A."
        	echo "Contact us: fairsmohamed180@gmail.com"
        	exit 0
        	;;
esac
}
