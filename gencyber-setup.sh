#!/bin/bash

# GenCyber Configuration Shell 0.1
# Author: Daniel Saylor
# git clone https://github.com/slayersec/GenCyber2021
# Usage: sudo ./Configure
# Test Change

check_for_root () {
	if [ "$EUID" -ne 0 ]
		then echo -e "\n\n Script must be run with sudo ./Configure or as root \n"
		exit
	fi
	}

install_tools() {
	sudo apt -y install wireshark
	sudo apt -y install ghex -fix-missing
	sudo apt -y install binwalk
	sudo apt -y install gedit
	sudo apt -y install steghide
	sudo apt -y install Outguess
	sudo apt -y install foremost
}

check_for_root


echo "Operation completed!"
