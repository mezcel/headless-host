#!/bin/bash

## #############################################################################
## ABOUT:
##      This script will configure wifi ad-hoc network using hostapd and dnsmasq
##      This script will write config scripts for:
##      *   Hostapd
##      *   Dnsmasq
##      *   SSH Server
##      *   Network interface names and IP
##
## Post installation feature:
##      Use a remote client to ssh into this Debian server.
##
## Guidance:
##  https://www.debian.org/doc/manuals/debian-reference/ch05.en.html
## #############################################################################

function Tput_Colors {
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

function About_Message {
    ## Cover page about information
    clear
    echo -e "$FG_YELLOW $MODE_BOLD
## #############################################################################
## ABOUT:
##      This script will configure wifi ad-hoc network using hostapd and dnsmasq
##      This script will write config scripts for:
##      *   Hostapd
##      *   Dnsmasq
##      *   SSH Server
##      *   Network interface names and IP
##
## Post installation feature:
##      Use a remote client to ssh into this Debian server.
##
## Guidance:
##  https://www.debian.org/doc/manuals/debian-reference/ch05.en.html
## #############################################################################
$STYLES_OFF"

    read -p "Press enter to continue ..." pauseEnter
    echo ""

}

function Write_Grub_Defaults {
    ## Make wifi = wlan0, and ethernet=eth0 instead of however else the kernel decided to name them.

    echo "$FGBG_NoColor---"
    echo "$FG_YELLOW"
    echo -e "Do you want to update grub to recognize Wifi and Ethernet interfaces as \"wlan0\" and \"eth0\", instead of however else the kernel decided to name them by default?\n\tNote:\n\t\tComputer will reboot.\n $FGBG_NoColor"

    read -e -p "Update the /etc/default/grub file? [ Y/n ]: " -i "n" yn

    case $yn in
        [Yy]* )
            echo -e "\nEditing the /etc/default/grub file ...\n"

            if [ -f /etc/default/grub ]; then
                sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%d%b%Y_%H%M%S)
                sleep 3s
            fi

            ## replace the line:
            ## GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
            ## with
            ## GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"

            sudo sed '/quiet/c\GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"' /etc/default/grub > /tmp/grub.temp
            sleep 3s

            sudo mv /tmp/grub.temp /etc/default/grub
            sleep 3s

            sudo update-grub

            echo -e "\nDebian will need to restart to reinitialize everything.\n"
            read -p "Press ENTER to reboot..."

            sudo reboot
            ;;

        * )
            echo -e "\n$FG_MAGENTA\tContinuing without editing the interface names... \
            \n\tWriting a delay script for ethernet connection at boot.$STYLES_OFF"
            ;;
    esac
}

function Install_Packages {

    sudo apt install -y firmware-linux-free
    sudo apt install -y firmware-linux-nonfree
    sudo apt install -y firmware-iwlwifi

    sudo apt install -y resolvconf

    sudo apt install -y dnsmasq
    sudo apt install -y iptables
    sudo apt install -y hostapd
    sudo apt install -y ifplugd

    sudo apt install -y openssh-server

}

function Write_Network_Interfaces {

    mywlan=$1
    myeth=$2

    tempFile=~/interfaces
    #destinationFile=/etc/network/interfaces
    destinationFile=/etc/network/interfaces.d/setup

    echo "## $destinationFile

## #############################################################################
## Class network addresses           net mask      net mask/bits  # of subnets
## A     10.x.x.x                    255.0.0.0     /8             1
## B     172.16.x.x — 172.31.x.x     255.255.0.0   /16            16
## C     192.168.0.x — 192.168.255.x 255.255.255.0 /24            256
## #############################################################################
## Note:
## If one of these addresses is assigned to a host, then that host must not
## access the Internet directly but must access it through a gateway that acts
## as a proxy for individual services
## #############################################################################

auto lo
iface lo inet loopback

auto $myeth
#allow-auto $myeth
#allow-hotplug $myeth
iface $myeth inet dhcp
#iface $myeth inet static
#   address 192.168.1.100
#   netmask 255.255.255.0
#   broadcast 192.168.1.255
#   gateway 192.168.1.1
#   #dns-domain localhost
#   #dns-nameservers 192.168.1.2

auto $mywlan
iface $mywlan inet static
    address 10.42.0.1
    netmask 255.0.0.0
    wireless-channel 1
    wireless-mod ad-hoc

    ## Wifi using the wpasupplicant package
    #wpa-ssid ATT123
    #wpa-psk MYPASSPHRASE" > $tempFile

    echo "$FG_CYAN"
    echo -e "\n##\n## $tempFile\n##"
    cat $tempFile
    echo -e "\n $STYLES_OFF"

    read -e -p "Apply config file $tempFile to $destinationFile? [ y/N ]: " -i "n" yn

    case $yn in
        [Yy]* )
            if [ -f $destinationFile ]; then
                sudo cp $destinationFile $destinationFile.backup.$(date +%d%b%Y_%H%M%S)
            fi

            sudo mv $tempFile $destinationFile
            ;;
    esac

}

function Write_Hostapd_Conf {
    ## https://wiki.debian.org/hostap

    ## aptitude install hostap-utils wireless-tools

    mywlan=$1
    myssid=$2
    mypassword=$3

    tempFile=~/hostapd.conf
    destinationFile=/etc/hostapd/hostapd.conf

    echo "## $destinationFile

interface=$mywlan
driver=nl80211
ssid=$myssid
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$mypassword
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > $tempFile

    echo "$FG_CYAN"
    echo -e "\n##\n## $tempFile\n##"
    cat $tempFile
    echo -e "\n $STYLES_OFF"

    read -e -p "Apply config file $tempFile to $destinationFile? [ y/N ]: " -i "n" yn

    case $yn in
        [Yy]* )
            if [ -f $destinationFile ]; then
                sudo cp $destinationFile $destinationFile.backup.$(date +%d%b%Y_%H%M%S)
            fi

            sudo mv $tempFile $destinationFile
            ;;
    esac

}

function Write_Dnsmasq_Conf {
    ## https://wiki.debian.org/dnsmasq

    ## apt-get install dnsmasq

    mywlan=$1
    myeth=$2

    tempFile=~/dnsmasq.conf
    destinationFile=/etc/dnsmasq.conf

    echo "## $destinationFile

interface=$mywlan

## Ip range for clients
#dhcp-range=10.42.0.0,10.42.0.8,12h
dhcp-range=$mywlan,10.42.0.1,10.42.0.24,12h

## Router ip
#dhcp-option=3,10.42.0.1
    " > $tempFile

    echo "$FG_CYAN"
    echo -e "\n##\n## $tempFile\n##"
    cat $tempFile
    echo -e "\n $STYLES_OFF"

    read -e -p "Apply config file $tempFile to $destinationFile? [ y/N ]: " -i "n" yn

    case $yn in
        [Yy]* )
            if [ -f $destinationFile ]; then
                sudo cp $destinationFile $destinationFile.backup.$(date +%d%b%Y_%H%M%S)
                sudo cp /etc/default/hostapd /etc/default/hostapd.backup.$(date +%d%b%Y_%H%M%S)
            fi

            sudo mv $tempFile $destinationFile

            sudo sed '/DAEMON_CONF=""/c\DAEMON_CONF="/etc/hostapd/hostapd.conf"' /etc/default/hostapd > ~/default_hostapd

            if [ -f ~/init_d_hostapd ]; then
                sudo mv ~/default_hostapd /etc/default/hostapd
            fi
            ;;
    esac

}

function Init_Hotspot_Interfaces {

    mywlan=$1

    sudo ip link set $mywlan up

    sudo systemctl stop dnsmasq

    sudo systemctl stop hostapd
    sudo systemctl unmask hostapd
    sudo systemctl enable hostapd
    sudo systemctl restart hostapd

    sudo systemctl enable dnsmasq
    sudo systemctl restart dnsmasq

}

function Customize_HostSshd {
    sleep 4s
    clear

    echo "$FG_CYAN"
    echo "Customize SSH Configuration: "
    echo ""
    echo "Customize /etc/ssh/sshd_config or use defaults?"
    echo '  "y" to manually customize'
    echo '  "n" to use preset defaults'
    echo ""
    read -e -p "Edit the ssh config file, sshd_config? [y/N] : " -i "y" yn

    myListenAddresses=$(ip -o -4 addr show | awk '{print $4}' | cut -d/ -f1 | awk '{print "ListenAddress "$1}' )

    case $yn in
        [Yy]* )
            sudo systemctl stop sshd

            read -e -p "Port ( 22 ) : " -i "22" myPort

            ## Listen address
            echo -e "${FG_RED}${MODE_BOLD}SSHD Listen address candidates:\n"
            ip -o -4 addr show
            echo "${STYLES_OFF}${FG_CYAN}"
            read -e -p "ListenAddress ( 10.42.0.1 ) : " -i "10.42.0.1" myListenAddress

            read -e -p "PermitRootLogin ( no ) : " -i "no" myPermitRootLogin
            read -e -p "AllowUsers ( mezcel ) : " -i "mezcel" myAllowUsers
            read -e -p "AuthorizedKeysFile ( .ssh/authorized_keys ) : " -i ".ssh/authorized_keys" myAuthorizedKeysFile
            read -e -p "ChallengeResponseAuthentication (no) : " -i "no" myChallengeResponseAuthentication
            read -e -p "UsePAM ( yes ) : " -i "yes" myUsePAM
            read -e -p "PrintMotd ( no ) : " -i "no" myPrintMotd
            read -e -p "Subsystem ( sftp    /usr/lib/ssh/sftp-server ) : " -i "sftp /usr/lib/ssh/sftp-server" mySubsystem
            #read -e -p "X11Forwarding ( yes ) : " -i "yes" myX11Forwarding
            #read -e -p "X11UseLocalhost ( yes ) : " -i "yes" myX11UseLocalhost

            if [ -f /etc/ssh/sshd_config ]; then
                sudo cp /etc/hostname /etc/hostname.backup.$(date +%d%b%Y_%H%M%S)
            fi

            temporaryConfig=~/sshd_config.temp

            echo "Port  $myPort" >> $temporaryConfig
            echo "## Added localhost just incase sshd was started without a network infrastructure." >> $temporaryConfig
            #echo "ListenAddress  127.0.0.1" >> $temporaryConfig
            #echo "#ListenAddress  192.168.0.100" >> $temporaryConfig
            #echo "#ListenAddress  10.42.0.1" >> $temporaryConfig
            echo -e "$myListenAddresses" >> $temporaryConfig
            echo "ListenAddress  $myListenAddress" >> $temporaryConfig
            echo "PermitRootLogin   $myPermitRootLogin" >> $temporaryConfig
            echo "AllowUsers   $myAllowUsers" >> $temporaryConfig
            echo "AuthorizedKeysFile    $myAuthorizedKeysFile" >> $temporaryConfig
            echo "ChallengeResponseAuthentication  $myChallengeResponseAuthentication" >> $temporaryConfig
            echo "UsePAM  $myUsePAM" >> $temporaryConfig
            echo "PrintMotd  $myPrintMotd" >> $temporaryConfig
            echo "Subsystem  $mySubsystem" >> $temporaryConfig
            #echo "X11Forwarding  $myX11Forwarding" >> $temporaryConfig
            #echo "X11UseLocalhost  $myX11UseLocalhost" >> $temporaryConfig
            echo "#MaxAuthTries  4" >> $temporaryConfig
            echo "#ClientAliveInterval  180" >> $temporaryConfig

            if [ -f $temporaryConfig ]; then
                echo -e "$FG_MAGENTA\tWriting /etc/ssh/sshd_config ... $STYLES_OFF"
                sudo mv $temporaryConfig /etc/ssh/sshd_config
                sleep 3s

                ## Preview Sshd Configs
                echo "$BG_MAGENTA"
                echo -n "## Your SSHD Config.\n\tTake note of the Listen Addresses.\n $MODE_BOLD"
                sudo cat /etc/ssh/sshd_config
                echo "$STYLES_OFF"
                read -p "Press Enter to continue ..." pauseEnter
            fi
            ;;
        * )
            echo -e ""
            ;;

    esac

    echo "$STYLES_OFF"
}

function Delay_SSHD_Interface {

    ## Workaround to prevent errors related to sshd.service starting before a network is available
    ## sudo systemctl edit sshd
    sudo mkdir -p /etc/systemd/system/ssh.service.d

    temporaryConfig=~/wait_conf.temp

    echo '[Unit]' > $temporaryConfig
    echo 'Wants=network-online.target' >> $temporaryConfig
    echo 'After=network-online.target' >> $temporaryConfig

    if [ -f $temporaryConfig ]; then
        echo -e "$FG_MAGENTA\tWriting /etc/systemd/system/ssh.service.d/wait.conf ... $STYLES_OFF"
        sudo mv $temporaryConfig /etc/systemd/system/ssh.service.d/wait.conf
        sleep 3s

        echo -e "$FG_MAGENTA\tWriting daemon-reload ... $STYLES_OFF"
        sudo systemctl daemon-reload
        sleep 3s
    fi
}

function Write_Configs {
    clear
    echo -e "\n## Current interface names and ip's ##\n $FG_YELLOW"
    ip a
    echo "$STYLES_OFF"

    ## ethernet interface name
    myeth=$(ls /sys/class/net | grep -E "eth")

    if [ -z $myeth ]; then
        myeth=$(ls /sys/class/net | grep -E "enp")

        if [ -z $myeth ]; then
            myeth=$(ls /sys/class/net | grep -E "en")
        fi
    fi

    if [ -z $myeth ]; then
        myeth=eth0
    fi

    read -e -p "Enter eth interface name. [ $myeth ]: " -i "$myeth" myeth

    ## wireless interface name
    mywlan=$(ls /sys/class/net | grep -E "wl")

    if [ -z $mywlan ]; then
        mywlan=wlan0
    fi

    read -e -p "Enter wlan interface name. [ $mywlan ]: " -i "$mywlan" mywlan

    myssid=$(hostname)-hostapd

    read -e -p "Enter a hotspot SSID name. [ $myssid ]: " -i "$myssid" myssid

    mypassword=password1234

    read -e -p "Enter a SSID password for $myssid. [ $mypassword ]: " -i "$mypassword" mypassword

    ######

    Write_Network_Interfaces $mywlan $myeth

    Write_Hostapd_Conf $mywlan $myssid $mypassword
    Write_Dnsmasq_Conf $mywlan $myeth

    Init_Hotspot_Interfaces $mywlan

    Customize_HostSshd
    #Delay_SSHD_Interface

}

function ShellInABoxD {
    echo ""
    promptQuestion="Do you want to install shellinabox? [ y/N ]: "
    yn=n
    read -e -p "$promptQuestion" -i "$yn" yn
    case $yn in
        [Yy]* )
            echo -e "\n Installing ...\n"
            sleep 1s

            sudo apt install -y shellinabox
            ;;
    esac


    echo ""
    promptQuestion="Do you want to \"enable\" shellinabox? [ y/N ]: "
    yn=n
    read -e -p "$promptQuestion" -i "$yn" yn
    case $yn in
        [Yy]* )
            echo -e "\n Enabling ...\n"
            sleep 1s

            sudo systemctl enable shellinabox.service

            echo -e "\nNOTE: \
                    \n\tThe default shellinabox url will be at port 4200. \
                    \n\tExample: https://10.42.0.1:4200 \n"
            read -p "Press ENTER to continue ..." pauseEnter
            ;;
    esac

}

function MAIN_SCRIPT {
    ## Main script

    About_Message

    Write_Grub_Defaults
    Install_Packages
    Write_Configs

}

## #############################################################################
## RUN
## #############################################################################

Tput_Colors
MAIN_SCRIPT
ShellInABoxD
