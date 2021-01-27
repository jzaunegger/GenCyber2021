#!/bin/bash

# GenCyber Configuration Shell 0.2
# Author: Daniel Saylor
# git clone https://github.com/slayersec/GenCyber2021
# Usage: sudo ./gencyber-setup.sh

# changed, logname does not exist on this distro
finduser=$(who | head -1 | awk '{print$1}')

connectid=""
password=""

check_for_root () {
	if [ "$EUID" -ne 0 ]
	 then echo -e "\n\n Script must be run with sudo ./gencyber-setup.sh or as root \n"
	 exit
	fi
	}

check_distro() {
   	distro=$(cat /etc/os-release | grep -i -c "Raspbian GNU/Linux") # distro check
	if [ $distro -ne 2 ]
	 then echo -e "\n Sorry I only work on Raspbian GNU/Linux \n"; exit  # false
	fi
	}

install_tools() {
	apt update	
	apt -y reinstall wireshark
	apt -y reinstall ghex 
	apt -y reinstall ghex --fix-missing
	apt -y reinstall binwalk
	apt -y reinstall gedit
	apt -y reinstall steghide
	apt -y reinstall outguess
	apt -y reinstall foremost
	echo "Operation completed!"
	}

start_teamviewer_service() {
	systemctl enable teamviewerd
        systemctl start teamviewerd
	}

stop_teamviewer_service () {
	systemctl disable teamviewerd 
        systemctl stop teamviewerd 
	}

install_teamviewer() {
	echo -e "Stopping any teamviewerd service if it exists, ignore any error here "        
	stop_teamviewer_service
     	wget https://download.teamviewer.com/download/linux/teamviewer-host_armhf.deb -O /tmp/teamviewer-host_armhf.deb
	dpkg -i /tmp/teamviewer-host_armhf.deb 
	apt --fix-broken install
	echo Setting random password...
	sleep 2
	/usr/bin/teamviewer --passwd "$password" > /dev/null 2>&1
	start_teamviewer_service 	
	rm -f /tmp/teamviewer-host_armhf.deb
	}


setup_environment() {
	# THESE 2 LINES COULD BE ONE rm -rf /home/$finduser/Desktop/GencyberSteganography/
	cd /home/$finduser/Desktop
	rm -rf GencyberSteganography/
	# GIT CLONE COULD BE REDIRECTED TO SPECIFIC DIR
	git clone https://github.com/slayersec/GencyberSteganography

	chown -R $finduser:$finduser /home/$finduser/Desktop/GencyberSteganography

	echo -e "\n\n\n Operations completed! You can begin the lab by going to your desktop"
	echo -e "\n A folder is there named 'GencyberSteganography.' Check there to begin!"
	}

generate_password() {
	#Generate a random string to use as a password.
	#This password is not a secure method of generation and is only meant for temporary use.
	#Do not share this password with anyone other then campus staff.
	chars=abcdefghijklmnopqrstuvwxyz123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
	symbolsonly=!@$*
	password+=${symbolsonly:RANDOM%${#symbolsonly}:1}
	for i in {1..7} ; do
		password+=${chars:RANDOM%${#chars}:1}
	done
	password+=${symbolsonly:RANDOM%${#symbolsonly}:1}
	echo $password
	}

display_connect_info() {
	echo -e "\nPlease wait... Setting up software\n "
	sleep 5
	#Retrieves connection information for students
	#	
	# CHANGE THIS GREP -I "CLIENTID" to "CLIENT" your global.conf says ClientIC not ID
	#
	connectid=$(cat /home/$finduser/.config/teamviewer/client.conf | grep -i "ClientIDOfTSUser" | cut -d " " -f4)
        echo -e "      Your Teamviewer ID: $connectid \nYour Teamviewer Password: $password"
	echo -e "      Your Teamviewer ID: $connectid \nYour Teamviewer Password: $password" > /home/$finduser/.stegolab_teamviewer
	chown $finduser:$finduser /home/$finduser/.stegolab_teamviewer
	}

configure_quick_help() {
	#quickly display connect information when "getHelp" is typed into console
	check_user_bashrc=$(cat /home/$finduser/.bashrc | grep -c gethelp)
	if [ $check_user_bashrc -ne 0 ] 	
	 then
	  echo "The command 'gethelp' can be entered at any time to retrieve connection information."
	 else
	  echo "alias gethelp='cat /home/$finduser/.stegolab_teamviewer'" >> /home/$finduser/.bashrc
	  chown $finduser:$finduser /home/$finduser/.bashrc
	  echo "You can use gethelp on the command line to display this information."
	fi	
	}
			



check_for_root
check_distro
install_tools
setup_environment
generate_password
install_teamviewer
display_connect_info
configure_quick_help
