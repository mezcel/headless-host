#!/bin/bash

##
## A Dialog UI for nmcli
## General guidance: https://docs.fedoraproject.org/en-US/Fedora/25/html/Networking_Guide/sec-Connecting_to_a_Network_Using_nmcli.html
##

## Decorative tty colors
function tput_colors {
	## Foreground Color using ANSI escape

	FG_BLACK=$(tput setaf 0)
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)
	FG_WHITE=$(tput setaf 7)
	FG_NoColor=$(tput sgr0)

	## Background Color using ANSI escape

	BG_BLACK=$(tput setab 0)
	BG_RED=$(tput setab 1)
	BG_GREEN=$(tput setab 2)
	BG_YELLOW=$(tput setab 3)
	BG_BLUE=$(tput setab 4)
	BG_MAGENTA=$(tput setab 5)
	BG_CYAN=$(tput setab 6)
	BG_WHITE=$(tput setab 7)
	BG_NoColor=$(tput sgr0)

	## set mode using ANSI escape

	MODE_BOLD=$(tput bold)
	MODE_DIM=$(tput dim)
	MODE_BEGIN_UNDERLINE=$(tput smul)
	MODE_EXIT_UNDERLINE=$(tput rmul)
	MODE_REVERSE=$(tput rev)
	MODE_ENTER_STANDOUT=$(tput smso)
	MODE_EXIT_STANDOUT=$(tput rmso)

	# clear styles using ANSI escape

	STYLES_OFF=$(tput sgr0)
	FGBG_NoColor=$(tput sgr0)
}

function identify_interfaces {
	myETH0=$(ls /sys/class/net/ | grep -E enp)
	myWL=$(ls /sys/class/net/ | grep -E wl)
}

function nmcli_wifi_connect {
	nmcli networking on

	dialogBackTitle="nmcli-menu"
	dialogTitle="Connect to Wifi Access Point"

	nmcli device wifi rescan

	declare -a nmcliArray
	nmcliArray=($(nmcli -c no -m tabular -f SSID dev wifi))

	declare -a menuArray
	for ((i=1; i<${#nmcliArray[@]}; i+=1)); do
		rawVal=${nmcliArray[$i]}
		cleanedVal=${rawVal// /}
		menuArray+=("$(($i))" "$cleanedVal" )
	done

	selectedWifi=$(dialog 2>&1 >/dev/tty \
		--backtitle "$dialogBackTitle" \
		--title "$dialogTitle" \
		--menu "wifi list" \
			12 50 ${#nmcliArray[@]} \
			${menuArray[@]}
			) || return

	ssidName=$(echo "${nmcliArray[$(($selectedWifi))]}" | xargs)

	wifiPassword=$(dialog 2>&1 >/dev/tty \
		--backtitle "$dialogBackTitle" \
		--title "$dialogTitle" \
		--insecure --passwordbox "Wifi Password:" 10 50 "yourpassword" ) || return

	myTerminalAlias=$(whoami)@$(hostname)

	dialog \
		--backtitle "Network Connection" \
		--title "Attemting to log in" \
		--infobox "Process running:\n\n$myTerminalAlias:\nnmcli device wifi connect $ssidName password \$wifiPassword\n\nPlease just wait... its going to happen..." 11 80

	# nmcli networking on

	# nmcli device wifi connect $ssidName password $wifiPassword
	nmcli device wifi connect $ssidName password $wifiPassword
	#clear
	echo -e "$FG_GREEN\nnmcli device wifi connect $ssidName\nwait delay... $FGBG_NoColor"; sleep 5s

	nmcli connection up $ssidName

	echo -e "$FG_GREEN\nnmcli connection up $ssidName\n $FGBG_NoColor"

	read -e -p "Do you want to START or ENABLE this connection? [ start/enable ]: " -i "enable" startEnable
	if [ $startEnable == "enable" ]; then
		netctl enable $ssidName
		netctl start $ssidName
	else
		netctl start $ssidName
	fi

}

function new_access_point {
	#identify_interfaces

	myWL=$(ls /sys/class/net/ | grep -E wl)
    myInterfaceList=$(ls /sys/class/net/)

    editConnection=$(dialog 2>&1 >/dev/tty \
        --backtitle "WI-FI, Hotspot, Internet Connection Settings (NetworkManager)" \
        --title "CONNECTION ACCESS POINT SETUP" \
        --form "\n  Network Interfaces: $myInterfaceList" \
         0 0 0 \
            "SSID:"	1	1	"A_Ssid_Connection_Name"	1 30 40 0 \
            "Mode: (wifi/ethernet)"	2	1	"wifi"	2 30 40 0 \
            "Device HWaddr ifname:"	3	1	"$myWL"	3 30 40 0 \
            "Automatically connect:"	4	1	 "yes"	4 30 40 0 \
            "IPv4 Method: (shared/manual)"	5	1	"shared"	5 30 40 0 \
            "Password:"	6	1	"password1234"    6 30 40 0 \
            "ipv4.addresses: * ethernet *"	7	1	"192.168.0.100/24"	7 30 40 0 \
            "ipv4.gateway: * ethernet *"	8	1	"192.168.0.1"	8 30 40 0 )


    selectedSubMenuItem1=($editConnection)
    myconshow=($(nmcli device))

    if [[ " ${myconshow[@]} " =~ "${selectedSubMenuItem1[0]}" ]]; then
        dialog \
            --infobox "The SSID \"${selectedSubMenuItem1[0]}\", which you defined, already exists.\n\nOnly make a NEW connection that is NEW to your system." 10 40

        #sleep 3
        read -t 3

    else
        echo "perform_connection_setup, wait delay..."; sleep 5s
        perform_connection_setup
    fi

}

function perform_connection_setup {
	## Template
	## nmcli con add type "wifi" ifname "wlp1s0" con-name "mylocalSSIDname" autoconnect yes ssid "theRouterSSIDname"
	## nmcli con modify "mylocalSSIDname" 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method "shared"
	## nmcli con modify "mylocalSSIDname" wifi-sec.key-mgmt wpa-psk
	## nmcli con modify "mylocalSSIDname" wifi-sec.psk "mypassword"
	## nmcli con modify "mylocalSSIDname" ipv4.addresses "192.168.0.22/16"
	## nmcli con modify "mylocalSSIDname" ipv4.gateway "192.168.0.1"
	##
	## OR
	## cp /etc/netctl/examples/wireless-wpa /etc/netctl/"mylocalSSIDname"
	## echo "Interface=wlp1s0" >> /etc/netctl/"mylocalSSIDname"
	## echo "Connection=wireless" >> /etc/netctl/"mylocalSSIDname"
	## echo "Security=wpa" >> /etc/netctl/"mylocalSSIDname"
	## echo "ESSID=routerssid" >> /etc/netctl/"mylocalSSIDname"
	## echo "IP=dhcp" >> /etc/netctl/"mylocalSSIDname"
	## echo "Key=mypassword" >> /etc/netctl/"mylocalSSIDname"

    ## involves password and radio
    if [[ "${selectedSubMenuItem1[1]}" == "wifi" ]]; then
        # Mode is wifi
        nmcli con add type ${selectedSubMenuItem1[1]} ifname ${selectedSubMenuItem1[2]} con-name ${selectedSubMenuItem1[0]} autoconnect ${selectedSubMenuItem1[3]} ssid ${selectedSubMenuItem1[0]}
        nmcli con modify ${selectedSubMenuItem1[0]} 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method ${selectedSubMenuItem1[4]}
        nmcli con modify ${selectedSubMenuItem1[0]} wifi-sec.key-mgmt wpa-psk
        nmcli con modify ${selectedSubMenuItem1[0]} wifi-sec.psk ${selectedSubMenuItem1[5]}
        nmcli radio on
    fi

    ## involves ip's
    if [[ "${selectedSubMenuItem1[1]}" == "ethernet" ]]; then
        # Mode is ethernet
        nmcli con add type ${selectedSubMenuItem1[1]} ifname ${selectedSubMenuItem1[2]} con-name ${selectedSubMenuItem1[0]} autoconnect ${selectedSubMenuItem1[3]}
        nmcli con modify ${selectedSubMenuItem1[0]} ipv4.method ${selectedSubMenuItem1[4]}
        nmcli con modify ${selectedSubMenuItem1[0]} ipv4.addresses ${selectedSubMenuItem1[6]}
        nmcli con modify ${selectedSubMenuItem1[0]} ipv4.gateway ${selectedSubMenuItem1[7]}
    fi

    nmcli con up ${selectedSubMenuItem1[0]}
    echo -e "$FG_CYAN\n\tnmcli con up ${selectedSubMenuItem1[0]} $FGBG_NoColor"
	echo -e "\t1/2 wait delay..."; sleep 5s

    nmcli networking on
    # netctl start
    echo -e "$FG_CYAN\tnmcli networking on $FGBG_NoColor"
	echo -e "\t2/2 wait delay...\n"; sleep 5s
}

function sshd_service {
	dialogBackTitle="SSH Server"
	dialogTitle="SSHD Options"
	selectedSSHMenu=$(dialog 2>&1 >/dev/tty \
		--backtitle "$dialogBackTitle" \
		--title "$dialogTitle" \
		--cancel-label "Back" \
		--menu "SSHD Options:" 0 0 0 \
			"1"	"systemctl start sshd" \
			"2"	"systemctl enable sshd" \
			"3"	"systemctl stop sshd" \
			"4"	"systemctl restart sshd" ) || return

	if [[ $selectedSSHMenu == 1 ]]; then
		clear
		systemctl start sshd
	fi

	if [[ $selectedSSHMenu == 2 ]]; then
		clear
		systemctl enable sshd
		systemctl start sshd
	fi

	if [[ $selectedSSHMenu == 3 ]]; then
		clear
		systemctl stop sshd
	fi

	if [[ $selectedSSHMenu == 4 ]]; then
		clear
		systemctl restart sshd
	fi

}

function start_ssh_client {
	clear
	echo ""
	read -p "Enter Port: " mySSHport
	read -p "Enter host (ex: user@server-address): " mySSHhost
	echo "## ssh -p port user@server-address"
	echo "##################################"
	ssh -p $mySSHport $mySSHhost
	echo ""
}

function dissconnect_accesspoint {

	dialogBackTitle="nmcli-menu"
	dialogTitle="Disconnect from Wifi Accesspoint"

	declare -a nmcliArray
	nmcliArray=($(nmcli -c no -m tabular -f SSID dev wifi))

	declare -a menuArray
	for ((i=1; i<${#nmcliArray[@]}; i+=1)); do
		rawVal=${nmcliArray[$i]}
		cleanedVal=${rawVal// /}
		menuArray+=("$(($i))" "$cleanedVal" )
	done

	selectedWifi=$(dialog 2>&1 >/dev/tty \
		--backtitle "$dialogBackTitle" \
		--title "$dialogTitle" \
		--menu "wifi list" \
			12 50 ${#nmcliArray[@]} \
			${menuArray[@]}
			) || return

	ssidName=$(echo "${nmcliArray[$(($selectedWifi))]}" | xargs)

	nmcli connection down $ssidName
}

function delete_accesspoint {
	## nmcli connection delete id <connection name>
	#echo ""
	#echo "Delete access point not implemented."
	#echo "If NetworkManager is installed check /etc/NetworkManager/system-connections/."
	#echo -e "# Use nmcli to delete connection:\n\t# nmcli connection delete id <connection name>\n"
	#echo ""

    echo -e "$BG_YELLOW \nAvailable connections:\n $FGBG_NoColor"
    nmcli con show
    echo -e "$BG_YELLOW \nEnter the full connection name to delete it.\n\tLeave blank to \"dont delete\" anything.\n $FGBG_NoColor"

    read -p "Enter name: " access_con_name
    sudo nmcli con down $access_con_name

    echo -e "$FG_YELLOW\tTurned off $access_con_name $FGBG_NoColor"
    sleep 2s
    sudo nmcli con del $access_con_name
    echo -e "$FG_YELLOW\tDeleted $access_con_name $FGBG_NoColor"
    sleep 2s

}

function go_offline {
	echo -e "\n# systemctl stop ssh\n#################"
	systemctl stop ssh

	echo -e "\n# nmcli radio off\n#################"
	nmcli radio off

	echo -e "\n# nmcli networking off\n#################"
	nmcli networking off

	echo -e "\n# systemctl stop NetworkManager\n#################"
	systemctl stop NetworkManager
}

function exit_summary {
	## Display Network State
	clear
	echo "exit_summary, wait delay..."; sleep 5s
	clear
	#reset

	# ip a
	echo -e "$BG_YELLOW--- Display networking state --- \n $FGBG_NoColor"

	echo -e "\n## nmcli dev wifi\n#################"
	nmcli dev wifi

	echo -e "\n## nmcli dev status\n#################"
	nmcli dev status

	echo -e "\n## nmcli radio\n#################"
	nmcli radio

	echo -e "\n## systemctl status sshd\n#################"
	systemctl status sshd

	echo -e "\n## nmcli con show\n#################"
	nmcli con show

	echo "## cat /etc/NetworkManager/system-connections/Network to view and mod your connections points "

	command -v netctl &>/dev/null
	isNetctl=$?
	if [ $isNetctl -eq 0 ]; then
		echo ""
		sudo systemctl status netctl
		echo ""
	fi

    echo -e "$FG_YELLOW\nNote:\n\tReview your /etc/ssh/sshd_config.\n\tThis script did not automate anything on that page.\n $FGBG_NoColor"
	read -p "press ENTER to continue ..." exitVar

	## clear user defined bash vars and history
	#exec bash
	exit
}

function main_connection_menu {

	# sudo systemctl start NetworkManager

	dialogBackTitle="Network Manager"
	dialogTitle="Access Point Options"
	selectedMenuItem=$(dialog 2>&1 >/dev/tty \
		--backtitle "$dialogBackTitle" \
		--title "$dialogTitle" \
		--cancel-label "Back" \
		--menu "Select network option:" 0 0 0 \
			"1"	"Connect to SSID" \
			"2"	"New Access Point" \
			"3"	"SSH Server" \
			"4"	"Start SSH Client" \
			"5"	"Dissconnect Access Point" \
			"6"	"Delete Access Point" \
			"7"	"Go Offline" \
			"8"	"Display Network State" ) || return

	case $selectedMenuItem in
		1)
			clear
			nmcli_wifi_connect
			;;
		2)
			clear
			new_access_point
			;;
		3)
			clear
			sshd_service
			systemctl status sshd
			;;
		4)
			clear
			start_ssh_client
			;;
		5)
			clear
			dissconnect_accesspoint
			;;
		6)
			clear
			delete_accesspoint
			;;
		7)
			clear
			go_offline
			;;
		8)
			clear
			exit_summary
			;;
	esac
}

function network_dependency {

    fix_interface_names

    sudo apt install dialog dhcpcd5 network-manager

    isDialog=$(command -v dialog)
    if [ $isDialog -ne 0 ]; then
        echo -e "$FG_Red Exited.\n\tThe dialog software is required to use the cli menu. $FGBG_NoColor\n"
        exit
    fi

    isDhcpcd=$(command -v dhcpcd)
    if [ $isDialog -ne 0 ]; then
        echo -e "$FG_Red Exited.\n\tThe dhcpcd software is required. $FGBG_NoColor\n"
        exit
    fi

    isNetworkmanager=$(command -v NetworkManager)
    if [ $isDialog -ne 0 ]; then
        echo -e "$FG_Red Exited.\n\tThe NetworkManager software bundle is required. $FGBG_NoColor\n"
        exit
    fi


	clear

	echo -e "$BG_MAGENTA\n## NetworkManager state:\n########################\n $FGBG_NoColor"

	if [ -f "/etc/debian_version" ]; then
		apt-cache show network-manager
		if [ $? -ne 0 ]; then
			sudo apt install wireless-tools wpasupplicant network-manager
		fi
	fi

    echo -e "\n $FG_GREEN"
	read -e -p "Do you want to START or ENABLE NetworkManager? [ start/enable ]: " -i "enable" startEnable
    echo "$FGBG_NoColor"

	if [ $startEnable == "enable" ]; then
		sudo systemctl enable NetworkManager
		sudo systemctl start NetworkManager
	else
		sudo systemctl start NetworkManager
	fi

	echo "$FG_CYAN NetworkManager, wait delay... $FGBG_NoColor"; sleep 5s

    echo -e "\n $FG_GREEN"
	read -e -p "Do you want to START or ENABLE dhcpcd.service? [ start/enable ]: " -i "enable" startEnable
    echo "$FGBG_NoColor"

	if [ $startEnable == "enable" ]; then
		sudo systemctl enable dhcpcd.service
		sudo systemctl start dhcpcd.service
        dhcpcd
	else
		sudo systemctl start dhcpcd.service
        dhcpcd
	fi
	echo "$FG_CYAN dhcpcd.service, wait delay... $FGBG_NoColor"; sleep 5s

}

function fix_interface_names {
    ## Make wifi = wlan0, and ethernet=eth0 instead of however else the kernel decided to name them.

    echo "$FGBG_NoColor---"
    echo "$FG_YELLOW"
    echo -e "Do you want to update grub to recognize Wifi and Ethernet interfaces as \"wlan\" and \"eth0\", instead of however else the kernel decided to name them by default?\n\tNote:\n\t\tComputer will reboot.\n $FGBG_NoColor"

    read -e -p "Update the /etc/default/grub file? [ y/N ] : " -i "n" yn

    case $yn in
		[Yy]* )
            echo -e "\nEditing the /etc/default/grub file ...\n"

            sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%d%b%Y_%H%M%S)
            sleep 1s

            ## replace the line:
            ## GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
            ## with
            ## GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"

            sudo sed '/quiet/c\GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"' /etc/default/grub > /tmp/grub.temp
            sleep 1s

            sudo mv /tmp/grub.temp /etc/default/grub
            sleep 1s

            sudo update-grub
            sudo reboot
            ;;

		* )
            echo -e "\n\tcontinuing without editing the interface names...\n"
            ;;
    esac
}

tput_colors
network_dependency
main_connection_menu
exit_summary
exit
