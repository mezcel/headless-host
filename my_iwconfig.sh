#!/bin/bash

## #####################################################################################################################
## About:        This script will prompt the user to connect to a wireless network ssid and make a launcher script to 
##                  log into known wpa_supplicant ssid configurations.
## Instructions: Run this script in the root account to make a new wpa_supplicant account profile.
##               Run this script in a user account to generate a script which logs in/out of known ssids.
## Source Code:  https://raw.githubusercontent.com/mezcel/headless-host/master/my_iwconfig.sh
## Dependency:   Requires the net-tools .deb package on Debian
## #####################################################################################################################

function tput_color_variables {
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

    ## no text formatting

    FGBG_NoColor=$(tput sgr0)
    STYLES_OFF=$(tput sgr0)
}

function greeting {
    echo "$FG_MAGENTA"
    echo "## ##########################################################################################################"
    echo "## About:        This script will prompt the user to connect to a wireless network ssid and make a launcher"
    echo "##                   script to log into known wpa_supplicant ssid configurations."
    echo "##"
    echo "## Instructions: Run this script in the root account to make a new wpa_supplicant account profile."
    echo "##               Run this script in a user account to generate a script which logs in/out of known ssids."
    echo "##"
    echo "## Source Code:  https://raw.githubusercontent.com/mezcel/headless-host/master/my_iwconfig.sh"
    echo "## Dependency:   Requires the net-tools .deb package for Debian"
    echo "## ##########################################################################################################"
    echo "$FG_NoColor"
}

function driver_information {
    echo -e "${FG_YELLOW}## Network Drivers\nlspci:"
    lspci -vnn | grep Network
    lspci -vnn | grep Ethernet
    echo -e "$FG_NoColor"
}

function turn_on_wifi {

    ## read the laptop's available wlan interface name
    myInterface=$(sudo iw dev | grep Interface | awk '{print $2}')

    echo -e "\n${FG_CYAN}(step 1 of 4)${FG_NoColor}\tDetect Wifi Hardware Interface:\t\t${MODE_BOLD}$myInterface${FG_NoColor}\n"
    sleep 2s

    ## turn on wifi hardware
    echo -e "${FG_CYAN}(step 2 of 4)${FG_NoColor}\tSwitch ON the Wifi hardware ...\t\t${FG_GREEN}processing ...${FG_NoColor}\n"
    
    echo -e "\t\tip link set $myInterface down ..."
    sudo ip link set $myInterface down
    sleep 3s

    echo -e "\t\tip link set $myInterface up ...\n"
    sudo ip link set $myInterface up
    sleep 2s

    sleep 2s
}

function select_ssid {

    ## list available SSID's
    echo -e "${FG_CYAN}(step 3 of 4)${FG_NoColor}\tIdentify available Wifi SSIDs ...\t${FG_GREEN}processing ...${FG_NoColor}\n"

    ssidArr=($(ps -u | sudo iw dev $myInterface scan | grep SSID | awk '{print $2}'))
    sleep 2s

    echo -e "\t\t${MODE_BEGIN_UNDERLINE}List of available SSID's:${MODE_EXIT_UNDERLINE}"
    count=0
    for i in "${ssidArr[@]}"
    do
        :
        echo -e "\t\t $count.\t$i"
        count=$((count+1))
    done

    ## Select which SSID to connect to
    echo -e "\n${FG_CYAN}(step 4 of 4)${FG_NoColor}\tSelecting an SSID ...\t\t\t${FG_GREEN}user input ...${FG_NoColor}\n"
    promptTab=$(echo -e "\t\t")
    read -p "${promptTab}Enter the number representing the desired SSID? [0 - $(( ${#ssidArr[@]} - 1 ))]: " ssidNo

    echo ""
    read -e -p "${promptTab}Connect to ${MODE_BOLD}${ssidArr[$ssidNo]}${FG_NoColor} ? [Y/n]: " -i "yes" yn

    case $yn in
        [Yy]* )
            myssid=${ssidArr[$ssidNo]}
            ;;
        * )
            ## abort script
            echo -e "\n${FG_RED}Aborted script.\nDone.${FG_NoColor} "
            exit
            ;;
    esac
}

function set_ethernet_connection {
    echo -e "\t\tEthernet port is set to automatically connect to a network\n"
    myEthernetInterface=$(ls /sys/class/net/ | grep -E enp)

    #sudo ifdown $myEthernetInterface

    if [ -f /etc/network/interface ]; then
        sudo cp /etc/network/interface /etc/network/interface.backup.$(date +%d%b%Y_%H%M%S)
    fi

    tempFile=~/tempConfig.tmp
    configFile=/etc/network/interface

    echo 'source /etc/network/interfaces.d/*' > $tempFile
    echo "auto lo $myEthernetInterface" >> $tempFile
    echo 'iface lo inet loopback' >> $tempFile

    sudo mv $tempFile $configFile

    #sudo ifup $myEthernetInterface

    sleep 2s
}

function define_wpa_credentials {

    ## define ssid permission
    echo ""
    read -e -p "${promptTab}Enter SSID: [ $myssid ]: " -i "$myssid" myssid

    if [ -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
        promptString="${promptTab}$myssid already has a wpa_supplicant.conf, do you want to overwrite it? [ Y/n ]: "
        read -e -p "$promptString" -i "yes" yn
        case $yn in
            [Yy]* )
                sudo cp /etc/wpa_supplicant/wpa_supplicant_$myssid.conf /etc/wpa_supplicant/wpa_supplicant_$myssid.conf.backup.$(date +%d%b%Y_%H%M%S)
                
                read -p "${promptTab}Enter Wifi password: " mypw
                echo ""

                ## make a config file
                ## note: must be root to read wpa_supplicant directory
                if [ -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
                    sudo cp /etc/wpa_supplicant/wpa_supplicant_$myssid.conf /etc/wpa_supplicant/wpa_supplicant_$myssid.conf.backup.$(date +%d%b%Y_%H%M%S)
                fi

                sudo sh -c "wpa_passphrase $myssid $mypw > /etc/wpa_supplicant/wpa_supplicant_$myssid.conf"
                sleep 1s

                ## associate config file with computer
                wifidriver=wext
                sudo wpa_supplicant -B -i $myInterface -c /etc/wpa_supplicant/wpa_supplicant_$myssid.conf -D $wifidriver
                sleep 1s
                ;;
        esac
    else
        read -p "${promptTab}Enter Wifi password: " mypw
        echo ""

        ## make a config file
        ## note: must be root to read wpa_supplicant directory
        if [ -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
            sudo cp /etc/wpa_supplicant/wpa_supplicant_$myssid.conf /etc/wpa_supplicant/wpa_supplicant_$myssid.conf.backup.$(date +%d%b%Y_%H%M%S)
        fi

        sudo sh -c "wpa_passphrase $myssid $mypw > /etc/wpa_supplicant/wpa_supplicant_$myssid.conf"
        sleep 1s

        ## associate config file with computer
        wifidriver=wext
        sudo wpa_supplicant -B -i $myInterface -c /etc/wpa_supplicant/wpa_supplicant_$myssid.conf -D $wifidriver
        sleep 1s
    fi
}

function connect_to_network {
    ## Do the do

    sudo dhclient $myInterface
    echo ""
    sleep 1s

    ## echo verify connectivity
    sudo iw dev $myInterface link
    echo ""

    command -v ping &>/dev/null
    if [ $? -eq 0 ]; then
        sudo ping -c3 google.com
    fi
    echo ""
}

function package_manager_reminder {
    echo -e "$FG_MAGENTA\n### Package Manager Repository Lists ###\n"
    echo -e "Debian:\n\tDependancy: net-tools \n\tUpdate \"/etc/apt/sources.list\" as necessary.\n\tExample: echo \"deb http://ftp.us.debian.org/debian/ buster main contrib non-free\" >> /etc/apt/sources.list\n\tExample: echo \"deb-src http://ftp.us.debian.org/debian/ buster main contrib non-free\" >> /etc/apt/sources.list"
    echo "$FGBG_NoColor"
}

function make_launcher_script {

    ## #########################################################################
    ## wifi launcher script name
    ## #########################################################################

    laucherSriptName=launch_$myInterface_$myssid

    echo -e "${FG_CYAN}"
    echo -e "(Finishing)${FG_NoColor}\tMaking a wifi launcher script ...\t${FG_GREEN}~/$laucherSriptName.sh"
    echo -e "${FG_NoColor}"

    ## #########################################################################
    ## shebang
    ## #########################################################################

    echo '#!/bin/bash' > ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## input args
    ## #########################################################################

    echo 'inputFlag=$1' >> ~/$laucherSriptName.sh
    echo 'thisFile=`basename $0`' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## function tput_colors
    ## #########################################################################

    echo 'function tput_colors {' >> ~/$laucherSriptName.sh
    echo '     ## Foreground Color using ANSI escape' >> ~/$laucherSriptName.sh

    echo '     FG_BLACK=$(tput setaf 0)' >> ~/$laucherSriptName.sh
    echo '     FG_RED=$(tput setaf 1)' >> ~/$laucherSriptName.sh
    echo '     FG_GREEN=$(tput setaf 2)' >> ~/$laucherSriptName.sh
    echo '     FG_YELLOW=$(tput setaf 3)' >> ~/$laucherSriptName.sh
    echo '     FG_BLUE=$(tput setaf 4)' >> ~/$laucherSriptName.sh
    echo '     FG_MAGENTA=$(tput setaf 5)' >> ~/$laucherSriptName.sh
    echo '     FG_CYAN=$(tput setaf 6)' >> ~/$laucherSriptName.sh
    echo '     FG_WHITE=$(tput setaf 7)' >> ~/$laucherSriptName.sh
    echo '     FG_NoColor=$(tput sgr0)' >> ~/$laucherSriptName.sh

    echo '     ## Background Color using ANSI escape' >> ~/$laucherSriptName.sh

    echo '     BG_BLACK=$(tput setab 0)' >> ~/$laucherSriptName.sh
    echo '     BG_RED=$(tput setab 1)' >> ~/$laucherSriptName.sh
    echo '     BG_GREEN=$(tput setab 2)' >> ~/$laucherSriptName.sh
    echo '     BG_YELLOW=$(tput setab 3)' >> ~/$laucherSriptName.sh
    echo '     BG_BLUE=$(tput setab 4)' >> ~/$laucherSriptName.sh
    echo '     BG_MAGENTA=$(tput setab 5)' >> ~/$laucherSriptName.sh
    echo '     BG_CYAN=$(tput setab 6)' >> ~/$laucherSriptName.sh
    echo '     BG_WHITE=$(tput setab 7)' >> ~/$laucherSriptName.sh
    echo '     BG_NoColor=$(tput sgr0)' >> ~/$laucherSriptName.sh

    echo '     ## set mode using ANSI escape' >> ~/$laucherSriptName.sh

    echo '     MODE_BOLD=$(tput bold)' >> ~/$laucherSriptName.sh
    echo '     MODE_DIM=$(tput dim)' >> ~/$laucherSriptName.sh
    echo '     MODE_BEGIN_UNDERLINE=$(tput smul)' >> ~/$laucherSriptName.sh
    echo '     MODE_EXIT_UNDERLINE=$(tput rmul)' >> ~/$laucherSriptName.sh
    echo '     MODE_REVERSE=$(tput rev)' >> ~/$laucherSriptName.sh
    echo '     MODE_ENTER_STANDOUT=$(tput smso)' >> ~/$laucherSriptName.sh
    echo '     MODE_EXIT_STANDOUT=$(tput rmso)' >> ~/$laucherSriptName.sh

    echo '     # clear styles using ANSI escape' >> ~/$laucherSriptName.sh

    echo '     STYLES_OFF=$(tput sgr0)' >> ~/$laucherSriptName.sh
    echo '     FGBG_NoColor=$(tput sgr0)' >> ~/$laucherSriptName.sh
    echo '}' >> ~/$laucherSriptName.sh

    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## function tryAgain
    ## #########################################################################

    echo 'function tryAgain {' >> ~/$laucherSriptName.sh

    echo '    echo "$FG_RED"' >> ~/$laucherSriptName.sh
    echo '    echo -e "\n!!! INPUT ERROR !!!\nYou entered: $inputFlag\n\tTry again."' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh
    echo '    echo "$FG_YELLOW"' >> ~/$laucherSriptName.sh
    echo '    echo -e "\tType ( \"up\" or \"down\" or \"restart\" ), after the executable file name.\n\t\tExample: ./`basename $0` up\n\t\tExample: ./`basename $0` down\n\t\tExample: ./`basename $0` restart\n"' >> ~/$laucherSriptName.sh

    echo '    echo "$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '    exit' >> ~/$laucherSriptName.sh
    echo '}' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## function wifiON
    ## #########################################################################

    echo 'function wifiON {' >> ~/$laucherSriptName.sh
    echo '    echo -e "${BG_CYAN}${FG_BLACK}\nEnable SSID connection though wpa_supplicant.$FG_NoColor"' >> ~/$laucherSriptName.sh

    echo '    echo -e "${FG_YELLOW}"' >> ~/$laucherSriptName.sh
    echo "    echo -e \"\tLaunching dhclient with the wpa_supplicant configuration file: /etc/wpa_supplicant/wpa_supplicant_$myssid.conf\""  >> ~/$laucherSriptName.sh
    echo '     echo -e "$FG_NoColor $FG_CYAN"' >> ~/$laucherSriptName.sh

    echo "    echo -e \"\tactivating $myInterface ...\"" >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo "    echo -e \"\tip link set $myInterface up ...\"" >> ~/$laucherSriptName.sh
    echo "    sudo ip link set $myInterface up" >> ~/$laucherSriptName.sh
    echo '    sleep 1s' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '    echo -e "${FG_CYAN}\tperform wpa_supplicant ... $FG_NoColor \n"' >> ~/$laucherSriptName.sh
    echo "    sudo wpa_supplicant -B -c /etc/wpa_supplicant/wpa_supplicant_$myssid.conf -i $myInterface" >> ~/$laucherSriptName.sh
    echo '    sleep 1s' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '    echo $FG_CYAN' >> ~/$laucherSriptName.sh
    echo "    echo -e \"\tenable dhclient with $myInterface ... \"" >> ~/$laucherSriptName.sh
    echo '    echo $FG_NoColor' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo "    sudo dhclient $myInterface" >> ~/$laucherSriptName.sh

    echo '    sleep 1s' >> ~/$laucherSriptName.sh
    echo '    echo -e "$FG_CYAN $MODE_DIM"' >> ~/$laucherSriptName.sh
    echo '    ping -c3 google.com' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '    if [ $? -ne 0 ]; then' >> ~/$laucherSriptName.sh
    echo '        echo "$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '        echo -e "${BG_RED}${FG_BLACK}No Internet connection is available. $FG_NoColor"' >> ~/$laucherSriptName.sh
    echo "        ## iw dev $myInterface station dump -v" >> ~/$laucherSriptName.sh
    echo "        sudo iwconfig $myInterface | grep -i --color $myInterface" >> ~/$laucherSriptName.sh
    echo "        sudo iwconfig $myInterface | grep -i --color signal" >> ~/$laucherSriptName.sh
    echo '    else' >> ~/$laucherSriptName.sh
    echo '        echo "$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '        echo -e "${BG_GREEN}${FG_BLACK}You are now connected to wifi. $(date).$FG_NoColor\n"' >> ~/$laucherSriptName.sh
    echo "        ## iw dev $myInterface station dump -v" >> ~/$laucherSriptName.sh
    echo "        sudo iwconfig $myInterface | grep -i --color $myInterface" >> ~/$laucherSriptName.sh
    echo "        sudo iwconfig $myInterface | grep -i --color signal" >> ~/$laucherSriptName.sh
    echo '    fi' >> ~/$laucherSriptName.sh

    echo '}' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## function wifiOFF
    ## #########################################################################

    echo 'function wifiOFF {' >> ~/$laucherSriptName.sh
    echo '    echo -e "${BG_RED}${FG_BLACK}\nKill existing wpa_supplicant connection.$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '    sudo killall wpa_supplicant' >> ~/$laucherSriptName.sh
    echo '    sleep 2s' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '    echo "${FG_RED}"' >> ~/$laucherSriptName.sh
    echo "    echo -e \"\tip link set $myInterface down ...\"" >> ~/$laucherSriptName.sh
    echo '    echo "$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo "    sudo ip link set $myInterface down" >> ~/$laucherSriptName.sh
    echo '    sleep 1s' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '    sleep 2s' >> ~/$laucherSriptName.sh
    echo '    echo -e "${FG_GREEN}\tdisconnected from wifi ...\n\twifi is off ... $FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '}' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ## function wifiRESTART
    ## #########################################################################

    echo 'function wifiRESTART {' >> ~/$laucherSriptName.sh
    echo '    echo -e "${BG_MAGENTA}${FG_BLACK}Restart existing SSID connection.$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '    echo -e "${FG_MAGENTA}\n\tThe network will shutdown and then startup again, connecting to the default wireless ssid.$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '    wifiOFF' >> ~/$laucherSriptName.sh
    echo '    wifiON' >> ~/$laucherSriptName.sh
    echo '}' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh
    
    ## #########################################################################
    ##  Dependency Check
    ## #########################################################################

    echo 'function dependancy_check {' >> ~/$laucherSriptName.sh
    echo "    if [ ! -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then" >> ~/$laucherSriptName.sh
    echo '        echo -e "${FG_RED}"' >> ~/$laucherSriptName.sh
    echo "        echo -e \"The wpa_supplicant ssid configuration file: /etc/wpa_supplicant/wpa_supplicant_$myssid.conf does not exist.\"" >> ~/$laucherSriptName.sh
    echo '        echo -e "Create it using the my_iwconfig.sh script from the \"root\" account."' >> ~/$laucherSriptName.sh
    echo '        echo -e "Then come back to this account and run my_iwconfig.sh again."' >> ~/$laucherSriptName.sh
    echo '        echo -e "Then finally you can use this `basename $0` script in a user account."' >> ~/$laucherSriptName.sh
    echo '        echo -e "$FG_NoColor"' >> ~/$laucherSriptName.sh
    echo '        exit' >> ~/$laucherSriptName.sh
    echo '    fi' >> ~/$laucherSriptName.sh
    echo '}' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    ## #########################################################################
    ##  Main Run: Wifi launcher Script
    ## #########################################################################

    echo "## #######################" >> ~/$laucherSriptName.sh
    echo "##  Run" >> ~/$laucherSriptName.sh
    echo "## #######################" >> ~/$laucherSriptName.sh
    echo "sudo clear" >> ~/$laucherSriptName.sh
    echo "tput_colors" >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo '## Log into a known SSID' >> ~/$laucherSriptName.sh
    echo '## launch dhclient with a predefined wpa_supplicant' >> ~/$laucherSriptName.sh
    echo "##    /etc/wpa_supplicant/wpa_supplicant_$myssid.conf" >> ~/$laucherSriptName.sh

    echo 'echo "$FG_CYAN"' >> ~/$laucherSriptName.sh
    echo 'echo "## ##########################################################################################################"' >> ~/$laucherSriptName.sh
    echo 'echo "## About:        This script is a wpa_supplicant user interface."' >> ~/$laucherSriptName.sh
    echo 'echo "##               It was generated by:"' >> ~/$laucherSriptName.sh
    echo 'echo "##                   https://raw.githubusercontent.com/mezcel/headless-host/master/my_iwconfig.sh"' >> ~/$laucherSriptName.sh
    echo "echo \"##               This script depends on /etc/wpa_supplicant/wpa_supplicant_$myssid.conf\"" >> ~/$laucherSriptName.sh
    echo 'echo "##"' >> ~/$laucherSriptName.sh
    echo 'echo "## Instructions: Enable  wifi | bash `basename $0` up"' >> ~/$laucherSriptName.sh
    echo 'echo "##               Kill    wifi | bash `basename $0` down"' >> ~/$laucherSriptName.sh
    echo 'echo "##               Restart wifi | bash `basename $0` restart"' >> ~/$laucherSriptName.sh
    echo 'echo "##"' >> ~/$laucherSriptName.sh
    echo 'echo "## Dependency:   Requires wpa_supplicant & the net-tools .deb package for Debian"' >> ~/$laucherSriptName.sh
    echo 'echo "## ##########################################################################################################"' >> ~/$laucherSriptName.sh
    echo 'echo "$FG_CYAN"' >> ~/$laucherSriptName.sh

    echo "" >> ~/$laucherSriptName.sh
    echo 'dependancy_check' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo 'if [ -z $inputFlag ]; then' >> ~/$laucherSriptName.sh
    echo '    inputFlag="nothing" ## unset var' >> ~/$laucherSriptName.sh
    echo '    tryAgain' >> ~/$laucherSriptName.sh
    echo 'fi' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo 'case $inputFlag in' >> ~/$laucherSriptName.sh
    echo '    "up" )' >> ~/$laucherSriptName.sh
    echo '        wifiON' >> ~/$laucherSriptName.sh
    echo '        ;;' >> ~/$laucherSriptName.sh
    echo '    "down" )' >> ~/$laucherSriptName.sh
    echo '        wifiOFF' >> ~/$laucherSriptName.sh
    echo '        ;;' >> ~/$laucherSriptName.sh
    echo '    "restart" )' >> ~/$laucherSriptName.sh
    echo '        wifiRESTART' >> ~/$laucherSriptName.sh
    echo '        ;;' >> ~/$laucherSriptName.sh
    echo '    * )' >> ~/$laucherSriptName.sh
    echo '        ## wrong input' >> ~/$laucherSriptName.sh
    echo '        tryAgain' >> ~/$laucherSriptName.sh
    echo '        ;;' >> ~/$laucherSriptName.sh
    echo 'esac' >> ~/$laucherSriptName.sh
    echo "" >> ~/$laucherSriptName.sh

    echo 'echo -e "\ndone."' >> ~/$laucherSriptName.sh

    chmod +x ~/$laucherSriptName.sh

    
    ## turn wifi back off
    sleep 5
    bash ~/$laucherSriptName.sh down
}

## #####################################################################################################################
## Main
## #####################################################################################################################

function main {
    tput_color_variables
    greeting

    me=$(whoami)

    ## show network divers
    driver_information

    ## wifi and ssid
    turn_on_wifi
    select_ssid

    ## wpa_supplicant configs

    define_wpa_credentials
    connect_to_network
    package_manager_reminder

    if [ ! -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
        ## Warning
        echo -e "${FG_RED}\tWARNING: \
        \n\t\tThe file /etc/wpa_supplicant/wpa_supplicant_$myssid.conf does not exist. \
        \n\t\tRemidy this by running the `basename "$0"` while logged in from the \"root\" account.$FG_NoColor"
    fi

    ## quick launch script
    make_launcher_script

    ## debian ethernet
    if [ -f /etc/apt/sources.list ]; then set_ethernet_connection; fi
}


################################################################################
## Run
################################################################################

main
