#!/bin/bash

# GenCyber Configuration Shell 0.1
# Author: Daniel Saylor
# git clone https://github.com/slayersec/GenCyber2021
# Usage: sudo ./gencyber-setup.sh
# Test Change

finduser=$(logname)
check_for_root () {
	if [ "$EUID" -ne 0 ]
		then echo -e "\n\n Script must be run with sudo ./gencyber-setup.sh or as root \n"
		exit
	fi
	}

install_tools() {
	apt update	
	apt -y install wireshark
	apt -y install ghex 
	apt -y install ghex --fix-missing
	apt -y install binwalk
	apt -y install gedit
	apt -y install steghide
	apt -y install outguess
	apt -y install foremost
	echo "Operation completed!"
	}

setup_environment() {
	cd /home/$finduser/Desktop
	rm -rf GencyberSteganography/
	git clone https://github.com/slayersec/GencyberSteganography
	chown -R $finduser:$finduser GencyberSteganography
	echo -e "\n\n\n Operations completed! You can begin the lab by going to your desktop"
	echo -e "\n A folder is there named 'GencyberSteganography.' Check there to start the lab!"
	}


check_for_root
install_tools
setup_environment



