#!/bin/bash

# GenCyber Configuration Shell 0.1
# Author: Daniel Saylor
# git clone https://github.com/slayersec/GenCyber2021
# Usage: sudo ./Configure

check_for_root () {
	if [ "$EUID" -ne 0 ]
		then echo -e "\n\n Script must be run with sudo ./Configure or as root \n"
		exit
	fi
	}

install_tools() {
	sudo apt-get -y install wireshark
	sudo apt-get -y install ghex -fix-missing
	sudo apt-get -y install binwalk
	sudo apt-get -y install gedit
	sudo apt-get -y install steghide
	sudo apt-get -y install Outguess
	sudo apt-get -y install foremost
}

check_for_root


echo "Operation completed!"
