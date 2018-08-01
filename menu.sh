#!/bin/bash

#text to user
PS3='Think twice, enter once: '

#input optiopns
options=("1-Upgrade-Standard" "2-Upgrade-Dist" "3-Upgrade-Headers" "4-Sources-Update" "5-Video-Drivers-Install" "6-Video-Test" "7-Keyboard-Install" "8-VPN-Install" "9-Startup-Settings" "10-OpenVAS-Install" "11-Burp-Plugins" "12-Conky-Install" "13-Exit")

#function to display optiosn nice
function optionsClean() {
	for item in ${options[*]}; do
		printf "   %s\n" $item
	done
}

printf "\033[1;47m  Version 0.9.6 - pin3Kal\033[1;m\n\033[1;46m  Created by Philip Kohn | https://www.philipkohn.com | @pin3c0n3  \033[1;m\n"

#define what to do for each option
select opt in "${options[@]}"
do
	case $opt in
		"1-Upgrade-Standard")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get upgrade...\x1b[0m\n\n"
		apt-get upgrade -y
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"2-Upgrade-Dist")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get dist-upgrade...\x1b[0m\n\n"
		apt-get dist-upgrade -y
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"3-Upgrade-Headers")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get install -y linux-headers-$(uname -r)...\x1b[0m\n\n"
		apt-get install -y linux-headers-$(uname -r)
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"4-Sources-Update")
		printf "\033[1;41m Setting sources.list to use https...\x1b[0m\n\n"
		sed -i 's/http:/https:/g' /etc/apt/sources.list
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"5-Video-Drivers-Install")
		printf "\033[1;41m Blacklisting nouveau...\x1b[0m\n\n"
		echo "Blacklisting nouveau..."
		echo '"blacklist nouveau" >>/etc/modprobe.d/nouveau-blacklist.conf'
		printf "\033[1;41m Video driver install round #1...\x1b[0m\n\n"
		apt-get install -y nvidia-kernel-dkms nvidia-xconfig nvidia-settings
		printf "\033[1;41m Video driver install round #2...\x1b[0m\n\n"
		apt-get install -y nvidia-vdpau-driver vdpau-va-driver mesa-utils
		printf "\033[1;41m Video driver install round #3...\x1b[0m\n\n"
		apt-get install -y bumblebee-nvidia
		echo "Downloading VirtualGL"
		printf "\033[1;41m DownloadingVirtualGL...\x1b[0m\n\n"
		wget -P ~/Downloads "https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl_2.5.2_amd64.deb"
		printf "\033[1;41m Video driver install round #4...\x1b[0m\n\n"
		apt install -y ~/Downloads/virtualgl*.deb
		printf "\033[1;41m You need to reboot now!!...\x1b[0m\n\n"
		break
		;;
		"6-Video-Test")
		printf "\033[1;41m Starting bumblebeed service...\x1b[0m\n\n"
		service bumblebeed start
		sleep 3
		printf "\033[1;41m Launching a video test...\x1b[0m\n\n"
		optirun -v glxgears
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"7-Keyboard-Install")
		printf "\033[1;41m Installing keyboard...\x1b[0m\n\n"
		apt-get install -y msi-keyboard
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"8-VPN-Install")
		printf "\033[1;41m Installing VPN modules...\x1b[0m\n\n"
		apt-get install -y network-manager-openvpn-gnome network-manager-pptp network-manager-pptp-gnome network-manager-strongswan network-manager-vpnc network-manager-vpnc-gnome
		printf "\033[1;41m Update the network manager...\x1b[0m\n\n"
		sed -i 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf
		printf "\033[1;41m Restarting network services...\x1b[0m\n\n"
		service network-manager restart && service networking restart
		printf "\033[1;41m Create an openvpn directory...\x1b[0m\n\n"
		mkdir ~/openvpn
		printf "\033[1;41m Download openvpn certs from PIA...\x1b[0m\n\n"
		wget -P ~/openvpn "https://www.privateinternetaccess.com/openvpn/openvpn.zip"
		printf "\033[1;41m Unzipping the files...\x1b[0m\n\n"
		unzip -o ~/openvpn/openvpn.zip -d ~/openvpn
		printf "\033[1;41m Import connections...\x1b[0m\n\n"
		nmcli connection import type openvpn file ~/openvpn/US\ East.ovpn
		nmcli connection import type openvpn file ~/openvpn/US\ Midwest.ovpn
		nmcli connection import type openvpn file ~/openvpn/US\ Chicago.ovpn
		nmcli connection import type openvpn file ~/openvpn/US\ New\ York\ City.ovpn
		nmcli connection import type openvpn file ~/openvpn/US\ Florida.ovpn
		printf "\033[1;41m Open each connection and enter username & password...\x1b[0m\n\n"
		optionsClean
		;;
		"9-Startup-Settings")
		printf "\033[1;41m Telling the system to load a startup script...\x1b[0m\n\n"
		mkdir /root/.config/autostart
		printf "[Desktop Entry]\nName=Startup\nGenericName=Stuff to do at Startup\nComment=Crap\nExec=/root/startup_scripts/my_startup_script.sh\nTerminal=false\nType=Application\nX-GNOME-Autostart-enabled=true" > /root/.config/autostart/my_script.desktop
		printf "\033[1;41m Setting what to start...\x1b[0m\n\n"
		mkdir /root/startup_scripts
		printf "#!/bin/bash\n\n#Make the keyboard do stuffs\nmsi-keyboard -m normal -c left,sky,high -c middle,sky,high -c right,sky,high\n" > /root/startup_scripts/my_startup_script.sh
		printf "\033[1;41m Making the script executable...\x1b[0m\n\n"
		chmod +x /root/startup_scripts/my_startup_script.sh
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"10-OpenVAS-Install")
		printf "\033[1;41m Installing OpenVAS...\x1b[0m\n\n"
		apt-get install -y openvas
		printf "\033[1;41m Setting up OpenVAS...\x1b[0m\n\n"
		openvas-setup
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"11-Burp-Plugins")
		printf "\033[1;41m Making a BurpSuite Folder...\x1b[0m\n\n"
		mkdir /root/burp
		printf "\033[1;41m Setting UP git...\x1b[0m\n\n"
		git init
		printf "\033[1;41m Downloading Airachnid...\x1b[0m\n\n"
		git clone https://github.com/SpiderLabs/Airachnid-Burp-Extension.git /root/burp/airachnid
		printf "\033[1;41m Downloading Autorize...\x1b[0m\n\n"
                git clone https://github.com/Quitten/Autorize.git /root/burp/autorize
                printf "\033[1;41m Downloading Burplay...\x1b[0m\n\n"
                git clone https://github.com/SpiderLabs/burplay.git /root/burp/burplay
		printf "\033[1;41m Downloading HUNT...\x1b[0m\n\n"
                git clone https://github.com/bugcrowd/HUNT.git /root/burp/hunt
		optionsClean
		;;
		"12-Conky-Install")
		printf "\033[1;41m Installing lm-sensors...\x1b[0m\n\n"
		apt-get install -y lm-sensors
		printf "\033[1;41m Detecting sensors...type yes to all questions...\x1b[0m\n\n"
		sensors-detect
		printf "\033[1;41m Testing detected sensors...\x1b[0m\n\n"
		sensors
		read -n 1 -s -r -p "Press any key to continue"
		printf "\033[1;41m Installing conky...\x1b[0m\n\n"
		apt-get install -y conky conky-all acpi
		printf "\033[1;41m Copying some files...\x1b[0m\n\n"
		cp conky/conkyrc ~/.conkyrc
		cp -r conky/conky_scripts/ /root/startup_scripts/ 
		printf "\033[1;41m Adding conky to startup...\x1b[0m\n\n"
		printf "\n#Start Conky \nconky\n" >> /root/startup_scripts/my_startup_script.sh
		printf "\033[1;41m Done!\x1b[0m\n\n"
		optionsClean
		;;
		"13-Exit")
		break
		;;
		*) Invalid option ;;
	esac
done

