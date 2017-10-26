#!/bin/bash

#text to user
PS3='Think twice, enter once: '

#input optiopns
options=("1-Upgrade-Standard" "2-Upgrade-Dist" "3-Upgrade-Headers" "4-Video-Drivers-Install" "5-Video-Test" "6-Keyboard-Install" "7-VPN-Install" "8-Startup-Settings" "9-Exit")

#function to display optiosn nice
function optionsClean() {
	for item in ${options[*]}; do
		printf "   %s\n" $item
	done
}

printf "\033[1;47m  Version 0.9.0 - pin3Kal\033[1;m\n\033[1;46m  Created by Philip Kohn | https://www.philipkohn.com | @pin3c0n3  \033[1;m\n"

#define what to do for each option
select opt in "${options[@]}"
do
	case $opt in
		"1-Upgrade-Standard")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get upgrade...\x1b[0m\n\n"
		apt-get upgrade -y
		optionsClean
		;;
		"2-Upgrade-Dist")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get dist-upgrade...\x1b[0m\n\n"
		apt-get dist-upgrade -y
		optionsClean
		;;
		"3-Upgrade-Headers")
		printf "\033[1;41m Starting apt-get update...\x1b[0m\n\n"
		apt-get update
		printf "\033[1;41m Starting apt-get install -y linux-headers-$(uname -r)...\x1b[0m\n\n"
		apt-get install -y linux-headers-$(uname -r)
		optionsClean
		;;
		"4-Video-Drivers-Install")
		printf "\033[1;41m Blacklisting nouveau...\x1b[0m\n\n"
		echo "Blacklisting nouveau..."
		echo '"blacklist nouveau" >>/etc/modprobe.d/nouveau-blacklist.conf'
		printf "\033[1;41m Video driver install round #1...\x1b[0m\n\n"
		apt-get install -y nvidia-kernel-dkms nvidia-xconfig nvidia-settings
		printf "\033[1;41m Video driver install round #2...\x1b[0m\n\n"
		apt-get install -y nvidia-vdpau-driver vdpau-va-driver mesa-utils
		printf "\033[1;41m Video driver install round #3...\x1b[0m\n\n"
		apt-get install -y install bumblebee-nvidia
		echo "Downloading VirtualGL"
		printf "\033[1;41m DownloadingVirtualGL...\x1b[0m\n\n"
		wget -P ~/Downloads "https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl_2.5.2_amd64.deb"
		printf "\033[1;41m Video driver install round #4...\x1b[0m\n\n"
		apt install -y ~/Downloads/virtualgl*.deb
		printf "\033[1;41m You need to reboot now!!...\x1b[0m\n\n"
		break
		;;
		"5-Video-Test")
		printf "\033[1;41m Starting bumblebeed service...\x1b[0m\n\n"
		service bumblebeed start
		printf "\033[1;41m Launching a video test...\x1b[0m\n\n"
		optirun -v glxgears
		optionsClean
		;;
		"6-Keyboard-Install")
		printf "\033[1;41m Installing keyboard...\x1b[0m\n\n"
		apt-get install -y msi-keyboard
		optionsClean
		;;
		"7-VPN-Install")
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
		"8-Startup-Settings")
		printf "\033[1;41m Telling the system to load a startup script...\x1b[0m\n\n"
		mkdir .config/autostart
		printf "[Desktop Entry]\nName=Startup\nGenericName=Stuff to do at Startup\nComment=Crap\nExec=/root/startup_scripts/my_startup_script.sh\nTerminal=false\nType=Application\nX-GNOME-Autostart-enabled=true" > .config/autostart/my_script.desktop
		printf "\033[1;41m Setting what to start...\x1b[0m\n\n"
		mkdir /root/startup_scripts
		printf "#!/bin/bash\n\n#Make the keyboard do stuffs\nmsi-keyboard -m normal -c left,sky,high -c middle,sky,high -c right,sky,high\n" > /root/startup_scripts/my_startup_script.sh
		printf "\033[1;41m Making the script executable...\x1b[0m\n\n"
		chmod +x /root/startup_scripts/my_startup_script.sh
		;;
		"9-Exit")
		break
		;;
		*) Invalid option ;;
	esac
done
