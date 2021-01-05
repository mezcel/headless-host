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


function Decorative_Formatting {
    ## Decorative tty colors
    function Tput_Colors {
        ## Foreground Color using ANSI escape provided through tput

        FG_BLACK=$(tput setaf 0)
        FG_RED=$(tput setaf 1)
        FG_GREEN=$(tput setaf 2)
        FG_YELLOW=$(tput setaf 3)
        FG_BLUE=$(tput setaf 4)
        FG_MAGENTA=$(tput setaf 5)
        FG_CYAN=$(tput setaf 6)
        FG_WHITE=$(tput setaf 7)
        FG_NoColor=$(tput sgr0)

        ## Background Color using ANSI escape provided through tput

        BG_BLACK=$(tput setab 0)
        BG_RED=$(tput setab 1)
        BG_GREEN=$(tput setab 2)
        BG_YELLOW=$(tput setab 3)
        BG_BLUE=$(tput setab 4)
        BG_MAGENTA=$(tput setab 5)
        BG_CYAN=$(tput setab 6)
        BG_WHITE=$(tput setab 7)
        BG_NoColor=$(tput sgr0)

        ## set mode using ANSI escape provided through tput

        MODE_BOLD=$(tput bold)
        MODE_DIM=$(tput dim)
        MODE_BEGIN_UNDERLINE=$(tput smul)
        MODE_EXIT_UNDERLINE=$(tput rmul)
        MODE_REVERSE=$(tput rev)
        MODE_ENTER_STANDOUT=$(tput smso)
        MODE_EXIT_STANDOUT=$(tput rmso)

        # clear styles using ANSI escape provided through tput

        STYLES_OFF=$(tput sgr0)
        FGBG_NoColor=$(tput sgr0)
    }

    function ttyCenter {
        str="$1"
        tputFgColor=$2

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi

        strLength=${#str}
        centerCol=$(( ( width/2 )-( strLength / 2 ) ))

        for (( i=0; i<=$centerCol; i++ ))
        do
           printf " "
        done
        printf "$MODE_BOLD$tputFgColor$str$STYLES_OFF\n"
    }

    function ttyHR {
        hrChar=$1
        tputFgColor=$2

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi

        for (( i=0; i<$width; i++ ))
        do
           printf "$tputFgColor$hrChar"
        done
        printf "$STYLES_OFF\n"
    }

    function ttyNestedString {
        str=$1
        tputFgColor=$2

        strArray=($str)
        lineArray=()

        strLength="${#str}"
        preString=" "

        ttyMaxCols=$( tput cols )
        if [ $ttyMaxCols -gt 80 ]; then ttyMaxCols=80; fi
        ttyMaxCols=$(($ttyMaxCols-1))

        charCount=0
        isFrstLine=1

        printf "$tputFgColor"
        for i in "${strArray[@]}"; do
            charCount=$(($charCount+${#i}+1))

            if [ $isFrstLine -ne 1 ]; then
                ttyMaxCols=$( tput cols )
                if [ $ttyMaxCols -gt 80 ]; then ttyMaxCols=80; fi
                ttyMaxCols=$(($ttyMaxCols-5))

                preString="    "
            else
                preString=" "
            fi

            if [ $charCount -lt $ttyMaxCols ]; then
                ## append lineArray
                lineArray+=("$i")
            else
                echo "$preString${lineArray[*]}"

                isFrstLine=0
                lineArray=()
                lineArray+=("$i")
                charCount=${#i}
            fi
        done

        if [ $isFrstLine -ne 1 ]; then
            preString="    "
        else
            preString=" "
        fi

        printf "$preString${lineArray[*]}\n$STYLES_OFF"
    }

    function ttyCenteredHeader {
        str=$1
        borderChar=$2
        tputFgColor=$3

        ttyHR "$borderChar" "$tputFgColor"
        ttyCenter "$str" "$tputFgColor"
        ttyHR "$borderChar" "$tputFgColor"
    }

    function ttyHighlightRow {
        str=$1
        tputBgColor=$2

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi
        width=$(($width - 3))

        strLength=${#str}

        highlightLength=$(( $width-$strLength ))

        printf "$tputBgColor$FG_BLACK= $str "
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor="
        done
        printf "$STYLES_OFF\n"
    }

    function ttyPromptInput {
        promptTitle=$1
        promptString=$2
        defaultAnswer=$3
        tputFgColor=$4
        tputBgColor=$5

        ttyHighlightRow "$promptTitle" "$tputBgColor"

        case $defaultAnswer in
            [Nn]* )
                readWait='-t 10'
                ;;
            * )
                readWait=""
                ;;
        esac

        read $readWait -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        if [ $? -ne 0 ]; then echo ""; fi

        printf "$STYLES_OFF\n"
        sleep 1
    }
}

function Configure_Router {
    function About_Message {
        ## Cover page about information
        ttyCenteredHeader "About" "-" "$FG_GREEN"
        ttyNestedString "- This script intended to setup Debian server as a wireless sshd acces point. This script will write config scripts for: Hostapd, Dnsmasq, SSH Server, Network interface names and IP" "$FG_GREEN"
        ttyNestedString "- Official Debian Guidance: https://www.debian.org/doc/manuals/debian-reference/ch05.en.html" "$FG_CYAN"

        thisFileName=`basename "$0"`
        ttyNestedString "- Inspect this script before running it: $(pwd)/$thisFileName" "$FG_YELLOW"

        promptString="Commence configuring server? [ y/N ]: "
        readInput=no
        ttyPromptInput "Run Installer:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            [Yy]* )
                ## continue with setup
                ttyNestedString "Commencing the Hostapd, Dnsmasq, SSH Server, Ad-hoc Network interface names, and IP setup ..." "${MODE_BOLD}$FG_GREEN"
                ;;
            * )
                ttyNestedString "Exited ad-hoc network configuration." "${MODE_BOLD}$FG_RED"
                exit
            ;;
        esac
        echo ""
    }

    function Accesspoint_Check {
        sudo iw list | grep "Supported interface modes" -A 8 | grep "AP" &>/dev/null
        isAP=$?

        ## Display message indicating AP is not available.
        if [ $isAP -ne 0 ]; then

            ttyCenteredHeader "Incompatible Access Point Hardware" "▞" "$FG_RED"

            ttyNestedString "The current wireless card is not capable of serving a wireless access point. Hostapd will not work through your existing wireless card. Hostapd (Host access point daemon) is a user space software access point capable of turning normal network interface cards into access points and authentication servers. You can continue... but this script is intended to configure a Hotspot for wireless adhoc ssh file sharing between computers." "$STYLES_OFF"
            ttyNestedString "WARNING: Continuing may break/conflict with your existing networking configurations or functionalities. (This option to still continue is for debugging other things.)" "${MODE_BOLD}$FG_YELLOW"

            promptString="Do you want to continue running this script? [ y/N ]: "
            readInput=no
            ttyPromptInput "Continue despite the lack of AP support:" "$promptString" "$readInput" "$FG_RED" "$BG_RED"

            case $readInput in
                [Nn]* )
                    ttyNestedString "Exited ad-hoc network configuration." "${MODE_BOLD}$FG_RED"
                    exit
            esac
        fi
    }

    function Write_Grub_Defaults {
        ## Make wifi = wlan0, and ethernet=eth0 instead of however else the kernel decided to name them.

        ttyCenteredHeader "GRUB Network Interface Names" "+" "$FG_CYAN"

        ttyNestedString "You can update grub to recognize Wifi and Ethernet interfaces as \"wlan0\" and \"eth0\", instead of however else the kernel decided to name them by default. The computer will need to reboot after any GRUB alterations." "$FG_YELLOW"

        promptString="Update the /etc/default/grub file? [ y/N ]: "
        readInput=no
        ttyPromptInput "GRUB network interface names" "$promptString" "$readInput" "$FG_RED" "$BG_RED"
        sleep 2s

        case $readInput in
            [Yy]* )
                ttyNestedString "Editing the /etc/default/grub file ..." "${MODE_BOLD}$FG_CYAN"

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

                ttyNestedString "Debian will need to restart to reinitialize everything." "${MODE_BOLD}$FG_RED"
                read -p "Press ENTER to reboot..." pauseEnter

                sudo reboot
                ;;

            * )
                ttyNestedString "Continuing without editing the interface names..." "${MODE_BOLD}$FG_GREEN"
                ttyNestedString "Writing a delay script for ethernet connection at boot..." "${MODE_BOLD}$FG_GREEN"
                ;;
        esac
    }

    function Install_Network_Drivers {
        ttyCenteredHeader "Network drivers" "-" "$FG_CYAN"
        sleep 2s

        sudo apt install -y linux-image-$(uname -r)
        sudo apt install -y linux-headers-$(uname -r)

        sudo apt install -y firmware-linux-free
        sudo apt install -y firmware-linux-nonfree
        sudo apt install -y firmware-iwlwifi

        ## Detect and/or Display the wireless driver Chipset

        lspci | grep "Broadcom" &>/dev/null
        isBroadcom=$?

        if [ $isBroadcom -eq 0 ]; then

            ttyCenteredHeader "Broadcom Wifi" "+" "$FG_YELLOW"
            ttyNestedString "If you choose to install Broadcom drivers, the computer will restart after installation. You will need to run this script again if you want to complete the rest of the installation." "$FG_YELLOW"

            ## check if driver is already installed
            sudo dpkg-query --list broadcom-sta-dkms firmware-brcm80211 &>/dev/null

            yn=$?
            if [ $yn -eq 0 ]; then
                promptString="Install the brcm80211 Broadcom wifi drivers? [ y/N ]: "
                readInput=no
            else
                promptString="Install the brcm80211 Broadcom wifi drivers? [ Y/n ]: "
                readInput=yes
            fi

            ttyPromptInput "Broadcom wifi drivers:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

            case $readInput in
                [Yy]* )
                    sudo apt install -y firmware-brcm80211
                    sudo apt install -y broadcom-sta-dkms

                    ttyNestedString "I recommend restarting the computer now." "$FG_RED"
                    ttyNestedString "Note: You will need to run the installer again. On the next pass the option to install brcm80211 will be default to \"no\" for convenience." "$FG_RED"

                    readInput=yes
                    promptString="Restart the computer now? [ Y/n ]: "
                    ttyPromptInput "Restart:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

                    case $readInput in
                        [Yy]* )
                            sudo reboot
                        ;;
                    esac
                    ;;
            esac

        fi
    }

    function Install_Packages {
        ttyCenteredHeader "Installing applications focused on sshd access point configuration" "-" "$FG_CYAN"
        sleep 2s

        sudo apt update
        sudo apt --fix-broken install
        sudo apt update

        ## Install network drivers
        Install_Network_Drivers

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

        ttyCenteredHeader "Network Interface IPs" "-" "$FG_CYAN"
        sleep 2s

        tempFile=~/interfaces
        #destinationFile=/etc/network/interfaces
        destinationFile=/etc/network/interfaces.d/setup

        echo -e "## $destinationFile \
        \n \
        \n## #############################################################################\
        \n## Class network addresses           net mask      net mask/bits  # of subnets\
        \n## A     10.x.x.x                    255.0.0.0     /8             1\
        \n## B     172.16.x.x — 172.31.x.x     255.255.0.0   /16            16\
        \n## C     192.168.0.x — 192.168.255.x 255.255.255.0 /24            256\
        \n## #############################################################################\
        \n## Note:\
        \n## If one of these addresses is assigned to a host, then that host must not\
        \n## access the Internet directly but must access it through a gateway that acts\
        \n## as a proxy for individual services\
        \n## #############################################################################\
        \n \
        \nauto lo\
        \niface lo inet loopback\
        \n \
        \nauto $myeth\
        \n#allow-auto $myeth\
        \n#allow-hotplug $myeth\
        \niface $myeth inet dhcp\
        \n#iface $myeth inet static\
        \n#    address 192.168.1.100\
        \n#    netmask 255.255.255.0\
        \n#    broadcast 192.168.1.255\
        \n#    gateway 192.168.1.1\
        \n#    #dns-domain localhost\
        \n#    #dns-nameservers 192.168.1.2\
        \n \
        \nauto $mywlan\
        \niface $mywlan inet static\
        \n    address 10.42.0.1\
        \n    netmask 255.0.0.0\
        \n    wireless-channel 1\
        \n    wireless-mod ad-hoc\
        \n \
        \n    ## Wifi using the wpasupplicant package\
        \n    #wpa-ssid ATT123\
        \n    #wpa-psk MYPASSPHRASE" > $tempFile

        cat $tempFile

        promptString="Apply the above network interface config file? [ Y/n ]: "
        readInput=yes
        ttyPromptInput "Configure $destinationFile" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
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

        ttyCenteredHeader "Hostapd Wireless Access Point" "-" "$FG_CYAN"
        sleep 2s

        tempFile=~/hostapd.conf
        destinationFile=/etc/hostapd/hostapd.conf

        echo -e "## $destinationFile\
        \n \
        \ninterface=$mywlan\
        \ndriver=nl80211\
        \nssid=$myssid\
        \nhw_mode=g\
        \nchannel=1\
        \nmacaddr_acl=0\
        \nauth_algs=1\
        \nignore_broadcast_ssid=0\
        \nwpa=2\
        \n#wpa=3\
        \nwpa_passphrase=$mypassword\
        \nwpa_key_mgmt=WPA-PSK\
        \nwpa_pairwise=TKIP\
        \nrsn_pairwise=CCMP" > $tempFile

        cat $tempFile

        promptString="Apply the above access point configuration file? [ Y/n ]: "
        readInput=yes
        ttyPromptInput "Configure $destinationFile" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
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

        ttyCenteredHeader "Dnsmasq" "-" "$FG_CYAN"

        tempFile=~/dnsmasq.conf
        destinationFile=/etc/dnsmasq.conf

        echo -e "## $destinationFile \
        \n \
        \ninterface=$mywlan\
        \n \
        \n## Ip range for clients\
        \n#dhcp-range=10.42.0.0,10.42.0.8,12h\
        \ndhcp-range=$mywlan,10.42.0.1,10.42.0.24,12h\
        \n \
        \n## Router ip\
        \n#dhcp-option=3,10.42.0.1 " > $tempFile

        cat $tempFile

        promptString="Apply the above dnsmasq configuration file? [ Y/n ]: "
        readInput=yes
        ttyPromptInput "Configure $destinationFile" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
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

        ttyCenteredHeader "Initialize Hotspot Interfaces" "-" "$FG_CYAN"

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
        ttyCenteredHeader "Customize SSH Configuration" "-" "$FG_CYAN"
        sleep 3s

        promptString="Edit the ssh config file, sshd_config? [ Y/n ] : "
        readInput=yes
        ttyPromptInput "Customize /etc/ssh/sshd_config" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        myListenAddresses=$( ip -o -4 addr show | awk '{print $4}' | cut -d/ -f1 | awk '{print "ListenAddress "$1}' )
        sleep 1s

        case $readInput in
            [Yy]* )
                sudo systemctl stop sshd

                ## Listen address
                ttyCenteredHeader "SSHD Listen address candidates" "+" "$FG_YELLOW"
                echo -e "${FG_YELLOW}"
                ip -o -4 addr show
                echo "${STYLES_OFF}${FG_CYAN}"
                read -e -p " ListenAddress ( 10.42.0.1 ) : " -i "10.42.0.1" myListenAddress
                read -e -p " Port ( 22 ) : " -i "22" myPort

                read -e -p " PermitRootLogin ( no ) : " -i "no" myPermitRootLogin
                read -e -p " AllowUsers ( mezcel ) : " -i "mezcel" myAllowUsers
                read -e -p " AuthorizedKeysFile ( .ssh/authorized_keys ) : " -i ".ssh/authorized_keys" myAuthorizedKeysFile
                read -e -p " ChallengeResponseAuthentication ( no ) : " -i "no" myChallengeResponseAuthentication
                read -e -p " UsePAM ( yes ) : " -i "yes" myUsePAM
                read -e -p " PrintMotd ( no ) : " -i "no" myPrintMotd
                read -e -p " Subsystem ( sftp    /usr/lib/ssh/sftp-server ) : " -i "sftp /usr/lib/ssh/sftp-server" mySubsystem
                #read -e -p "X11Forwarding ( yes ) : " -i "yes" myX11Forwarding
                #read -e -p "X11UseLocalhost ( yes ) : " -i "yes" myX11UseLocalhost

                if [ -f /etc/ssh/sshd_config ]; then
                    sudo cp /etc/hostname /etc/hostname.backup.$(date +%d%b%Y_%H%M%S)
                fi

                temporaryConfig=~/sshd_config.temp
                echo -e "## /etc/ssh/sshd_config\n" >  $temporaryConfig
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
                    echo ""
                    ttyNestedString "Writing /etc/ssh/sshd_config ..." "${MODE_BOLD}$FG_MAGENTA"
                    sudo mv $temporaryConfig /etc/ssh/sshd_config
                    sleep 3s

                    ## Preview Sshd Configs

                    ttyHighlightRow "Your SSHD Config." "$BG_MAGENTA"
                    echo ""

                    sudo cat /etc/ssh/sshd_config
                    echo ""

                    ttyHighlightRow "Take note of the SSHD Listen Addresses." "$BG_MAGENTA"
                    read -p "Done. Press Enter to continue ..." pauseEnter
                fi
                ;;
            * )
                echo -e ""
                ;;

        esac

        echo "$STYLES_OFF"
    }

    function Delay_SSHD_Interface {
        ttyCenteredHeader "SSHD Boot Delay Script" "-" "$FG_CYAN"
        sleep 1

        ## Workaround to prevent errors related to sshd.service starting before a network is available
        ## sudo systemctl edit sshd
        sudo mkdir -p /etc/systemd/system/ssh.service.d

        temporaryConfig=~/wait_conf.temp

        echo '[Unit]' > $temporaryConfig
        echo 'Wants=network-online.target' >> $temporaryConfig
        echo 'After=network-online.target' >> $temporaryConfig

        if [ -f $temporaryConfig ]; then
            ttyNestedString "Writing /etc/systemd/system/ssh.service.d/wait.conf ..." "${MODE_BOLD}$FG_GREEN"
            sudo mv $temporaryConfig /etc/systemd/system/ssh.service.d/wait.conf
            sleep 3s

            ttyNestedString "Writing daemon-reload ..." "${MODE_BOLD}$FG_GREEN"
            sudo systemctl daemon-reload
            sleep 3s
        fi
    }

    function Write_Configs {
        ttyCenteredHeader "Write Configuration Scripts" "-" "$FG_CYAN"
        ttyNestedString "Current interface names and ip's:" "$FG_YELLOW"
        echo -e "$FG_YELLOW"
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

        ttyHighlightRow "Verify or Customize Interface names for the Host SSID." "$BG_GREEN"

        promptString="Enter eth interface name. [ ${FG_GREEN}$myeth${STYLES_OFF} ]: "
        read -e -p "$promptString" -i "$myeth" myeth

        ## wireless interface name
        mywlan=$(ls /sys/class/net | grep -E "wl")

        if [ -z $mywlan ]; then
            mywlan=wlan0
        fi

        promptString="Enter wlan interface name. [ ${FG_GREEN}$mywlan${STYLES_OFF} ]: "
        read -e -p "$promptString" -i "$mywlan" mywlan

        myssid=$(hostname)-hostapd

        promptString="Enter a hotspot SSID name. [ ${FG_GREEN}$myssid${STYLES_OFF} ]: "
        read -e -p "$promptString" -i "$myssid" myssid

        mypassword=password1234
        promptString="Enter a SSID password for $myssid. [ ${FG_GREEN}$mypassword${STYLES_OFF} ]: "
        read -e -p "$promptString" -i "$mypassword" mypassword

        ######

        Write_Network_Interfaces $mywlan $myeth

        Write_Hostapd_Conf $mywlan $myssid $mypassword

        Write_Dnsmasq_Conf $mywlan $myeth

        Init_Hotspot_Interfaces $mywlan

        Customize_HostSshd
        #Delay_SSHD_Interface
    }
}

function MAIN_SCRIPT {
    ## Main script

    About_Message

    Accesspoint_Check

    Write_Grub_Defaults

    Install_Packages

    Write_Configs
}

## #############################################################################
## Configure Adhoc Wifi
## #############################################################################

## Initialize

Decorative_Formatting
Tput_Colors
Configure_Router

clear
ttyCenteredHeader "Wireless Adhoc SSHD Server Access Point" "░" "$FG_MAGENTA"
sleep 2

## RUN

uname -v | grep "Debian" --color
isDebian=$?

if [ $isDebian -eq 0 ]; then
    MAIN_SCRIPT
else
    ## Cancel
    echo ""
    ttyCenteredHeader "Canceling Installation/Configuration" "░" "$FG_YELLOW"
    ttyNestedString "This script was intended for dedicated Debian linux server machines. This script makes assumptions appropriate for systems which installed the debian-live-10.x.x-amd64-standard.iso" "$FG_YELLOW"
    echo ""
    read -p "[Press ENTER to continue ...]" pauseEnter
fi
