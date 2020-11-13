#!/bin/bash

## #############################################################################
## About:        This script will prompt the user to connect to a wireless
##               network ssid and make a launcher script to
##                  log into known wpa_supplicant ssid configurations.
## Instructions: Run this script in the root account to make a new
##                  wpa_supplicant account profile.
##               Run this script in a user account to generate a script which
##                  logs in/out of known ssids.
## Source Code:  https://github.com/mezcel/headless-host/my_iwconfig.sh
## Dependency:   Requires wpa_supplicant and net-tools on Debian
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

        read -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        printf "$STYLES_OFF\n"
        sleep 1
    }
}

function greeting {
    ttyCenteredHeader "Generate a wpa_supplicant launcher script" "░" "$FG_MAGENTA"
    ttyNestedString "This script will prompt the user to connect to a wireless network ssid and make a launcher script to manage existing wpa_supplicant ssid configurations." "$FG_MAGENTA"
}

function driver_information {
    ttyHighlightRow "Existing Network Drivers" "$BG_YELLOW"
    netDrivers=$(lspci -vnn | grep Network)
    ethDrivers=$(lspci -vnn | grep Ethernet)
    sleep 1s
    ttyNestedString "$netDrivers" "$FG_YELLOW"
    ttyNestedString "$ethDrivers" "$FG_YELLOW"
}

function turn_on_wifi {

    ## read the laptop's available wlan interface name
    myInterface=$(sudo iw dev | grep Interface | awk '{print $2}')

    echo -e "\n${FG_CYAN}(step 1 of 4)${FG_NoColor}\tDetect Wifi Hardware Interface:\t\t${MODE_BOLD}$myInterface${FG_NoColor}\n"
    sleep 2s

    ## turn on wifi hardware
    echo -e "${FG_CYAN}(step 2 of 4)${FG_NoColor}\tSwitch ON the Wifi hardware ...\t\t${FG_GREEN}processing ...${FG_NoColor}\n"

    echo -e "\t\tip link set $myInterface down ..."
    sudo ip link set $myInterface down && sleep 2s

    echo -e "\t\tip link set $myInterface up ...\n"
    sudo ip link set $myInterface up && sleep 3s

}

function select_ssid {

    ## list available SSID's
    echo -e "${FG_CYAN}(step 3 of 4)${FG_NoColor}\tIdentify available Wifi SSIDs ...\t${FG_GREEN}processing ...${FG_NoColor}\n"

    ssidArr=()
    ssidArr=($(ps -u | sudo iw dev $myInterface scan | grep SSID | awk '{print $2}'))
    sleep 3s

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

    read -p "${promptTab}Enter the number representing the desired SSID? [ 0 - $(( ${#ssidArr[@]} - 1 )) ]: " ssidNo

    echo ""
    ssidName=${ssidArr[$ssidNo]}
    if [ ${#ssidName} -gt 1 ]; then
        read -e -p "${promptTab}Connect to ${MODE_BOLD}$ssidName${FG_NoColor} ? [ Y/n ]: " -i "yes" yn
    else
        echo "Aborted script. Bad SSID selection."
        ttyCenteredHeader "Aborted script" "░" "$FG_RED"
        ttyNestedString "Script terminated because of a bad SSID name." "$FG_RED"
        exit
    fi

    case $yn in
        [Yy]* )
            myssid=${ssidArr[$ssidNo]}
            ;;
        * )
            ## abort script
            ttyCenteredHeader "Aborted script" "░" "$FG_RED"
            exit
            ;;
    esac
}

function set_ethernet_connection {
    ttyNestedString "Setting ethernet port to automatically connect to available wired networks (hotplug) ..." "$MODE_BOLD$FG_GREEN"
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
    read -e -p "${promptTab}Enter SSID: [ ${FG_CYAN}$myssid${FG_NoColor} ]: " -i "$myssid" myssid

    ttyCenteredHeader "Writing wpa_supplicant launcher script" "-" "$FG_GREEN"

    if [ -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
        promptString="$myssid has a wpa_supplicant.conf, overwrite it? [ y/N ]: "
        readInput=no
        ttyPromptInput "Overwrite duplicate SSID Configs" "$promptString" "$readInput" "$FG_RED" "$BG_RED"

        case $readInput in
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

function package_manager_reminder {
    ttyHighlightRow "(Reminder) Apt package manager mirror list" "$BG_BLUE"

    ttyNestedString "Update \"/etc/apt/sources.list\" as necessary." "$MODE_BOLD$FG_BLUE"
    ttyNestedString "Example:" "$MODE_BOLD$FG_BLUE"
    ttyNestedString "\"deb http://ftp.us.debian.org/debian/ buster main contrib non-free\" >> /etc/apt/sources.list" "$FG_BLUE"
    ttyNestedString "\"deb-src http://ftp.us.debian.org/debian/ buster main contrib non-free\" >> /etc/apt/sources.list" "$FG_BLUE"
    echo ""
}

function make_launcher_script {
    ## Write a wpa_supplicant connection manager script in the ~/ directory.

    laucherSriptName=~/launch_$myInterface_$myssid.sh

    echo -e "${FG_CYAN}"
    echo -e "(Finishing)${FG_NoColor}\tMaking a wifi launcher script ...\t${FG_GREEN}$laucherSriptName"
    echo -e "${FG_NoColor}"

    echo '
#!/bin/bash

inputFlag=$1
thisFile=`basename $0`

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

        read -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        printf "$STYLES_OFF\n"
        sleep 1
    }
}

function Conn_Controlls {
    function tryAgain {
        ttyCenteredHeader "INPUT ERROR" "-" "$FG_RED"
        ttyNestedString "You entered: ${STYLES_OFF}${MODE_BOLD}$inputFlag" "$FG_RED"
        ttyNestedString "Type ( \"up\" or \"down\" or \"restart\" ), after the executable file name." "$FG_YELLOW"
        echo ""
        exit
    }

    function wifiON {
        ttyCenteredHeader "Enabling an SSID wifi connection through wpa_supplicant." "-" "$FG_MAGENTA"
        ttyNestedString "Launching dhclient with the wpa_supplicant configuration file: /etc/wpa_supplicant/wpa_supplicant_MY_SSID.conf" "$FG_YELLOW"
        ttyHighlightRow "Activating MY_WLAN" "$BG_GREEN"
        ttyNestedString "ip link set MY_WLAN up ..." "$MODE_BOLD$FG_GREEN"

        sudo ip link set MY_WLAN up
        sleep 1s

        ttyNestedString "performing wpa_supplicant ..." "$MODE_BOLD$FG_GREEN"
        sudo wpa_supplicant -B -c /etc/wpa_supplicant/wpa_supplicant_MY_SSID.conf -i MY_WLAN
        sleep 1s

        ttyNestedString "enabling dhclient with MY_WLAN ..." "$MODE_BOLD$FG_GREEN"
        sudo dhclient MY_WLAN
        sleep 1s

        echo -e "$FG_BLUE $MODE_DIM"
        ping -c3 google.com
        echo -e "$STYLES_OFF"

        if [ $? -ne 0 ]; then
            ttyCenteredHeader "No Internet connection is available." "░" "$FG_GREEN"
        else
            ttyCenteredHeader "You are now connected to (MY_SSID) wifi." "░" "$FG_GREEN"
        fi
        sudo iwconfig MY_WLAN | grep -i --color MY_WLAN
        sudo iwconfig MY_WLAN | grep -i --color signal
    }

    function wifiOFF {
        ttyCenteredHeader "Kill existing wpa_supplicant connection." "-" "$FG_MAGENTA"
        sudo killall wpa_supplicant
        sleep 2s

        ttyNestedString "ip link set MY_WLAN down ..." "$MODE_BOLD$FG_GREEN"
        sudo ip link set MY_WLAN down
        sleep 1s

        sleep 2s
        ttyCenteredHeader "You are now disconnected from (MY_SSID) wifi." "░" "$FG_YELLOW"
    }

    function wifiRESTART {

        ttyCenteredHeader "Restart existing SSID connection." "-" "$FG_MAGENTA"
        ttyNestedString "The network will shutdown from and reconnect to the default wireless ssid (MY_SSID)." "$FG_YELLOW"
        sleep 1s

        wifiOFF
        wifiON
    }

    function dependancy_check {
        if [ ! -f /etc/wpa_supplicant/wpa_supplicant_MY_SSID.conf ]; then

            ttyCenteredHeader "Missing wpa_supplicant file" "-" "$FG_RED"
            ttyNestedString "The wpa_supplicant ssid configuration file: /etc/wpa_supplicant/wpa_supplicant_MY_SSID.conf does not exist." "$FG_YELLOW"
            ttyNestedString "Create that file by using the \"my_iwconfig.sh\" script while logged in from the \"root\" user account." "$FG_YELLOW"
            ttyNestedString "After that script has run, log back into this \"$(whoami)\" account, and run `basename $0`." "$FG_YELLOW"

            echo ""
            exit
        fi
    }

    function about {
        ttyCenteredHeader "wpa_supplicant connection manager" "░" "$FG_CYAN"

        #ttyNestedString "Installing applications focused on terminal productivity" "-" "$FG_CYAN"
        echo -e "${FG_CYAN}${MODE_BOLD} About:\t\t${STYLES_OFF}${FG_CYAN}This script is a wpa_supplicant user interface."
        echo -e "${FG_CYAN}${MODE_BOLD} Instructions: ${STYLES_OFF}"
        echo -e "${FG_CYAN}\t\t${MODE_BEGIN_UNDERLINE}Enable${MODE_EXIT_UNDERLINE}  wifi |\tbash `basename $0` ${MODE_BOLD}up${STYLES_OFF}"
        echo -e "${FG_CYAN}\t\t${MODE_BEGIN_UNDERLINE}Kill${MODE_EXIT_UNDERLINE}    wifi |\tbash `basename $0` ${MODE_BOLD}down${STYLES_OFF}"
        echo -e "${FG_CYAN}\t\t${MODE_BEGIN_UNDERLINE}Restart${MODE_EXIT_UNDERLINE} wifi |\tbash `basename $0` ${MODE_BOLD}restart${STYLES_OFF}"
        echo -e "${FG_CYAN}${MODE_BOLD} Dependency:\n\t\t${STYLES_OFF}${FG_CYAN}wpa_supplicant, net-tools, and the wpa_supplicant config file"
        echo -e "${FG_CYAN}\t\t  ${MODE_BEGIN_UNDERLINE}/etc/wpa_supplicant/wpa_supplicant_MY_SSID.conf${MODE_EXIT_UNDERLINE}"
        echo -e "${FG_CYAN}${MODE_BOLD} Git:\n\t\t${STYLES_OFF}${FG_CYAN}https://github.com/mezcel/headless-host/my_iwconfig.sh"

    }
}

## ##################################################

## Initialize

Decorative_Formatting
Tput_Colors
Conn_Controlls

## RUN

ttyHighlightRow "Login into use the wpa_supplicant connection manager script." "$BG_CYAN"
sudo clear
if [ $? -ne 0 ]; then echo -e "\nAborted script.\n"; exit; fi

about
dependancy_check

if [ -z $inputFlag ]; then
    inputFlag="nothing" ## unset var
    tryAgain
fi

case $inputFlag in
    "up" )
        wifiON
        ;;
    "down" )
        wifiOFF
        ;;
    "restart" )
        wifiRESTART
        ;;
    * )
        ## wrong input
        tryAgain
        ;;
esac

echo -e "\ndone."
    ' > $laucherSriptName
    sleep 2s

    MY_WLAN=$myInterface
    MY_SSID=$ssidName
    sleep 1s

    sed -i "s/MY_SSID/$MY_SSID/g" $laucherSriptName
    sleep 2s

    sed -i "s/MY_WLAN/$MY_WLAN/g" $laucherSriptName
    sleep 2s


}

## #############################################################################
## Main
## #############################################################################

function main {
    Decorative_Formatting
    Tput_Colors

    ttyHighlightRow "Login into use the wpa_supplicant connection script generator." "$BG_BLUE"
    sudo clear
    if [ $? -ne 0 ]; then echo "login failed"; exit; fi
    greeting

    me=$(whoami)

    ## show network divers
    driver_information


    ttyCenteredHeader "Commencing wpa_supplicant script preparation" "-" "$FG_GREEN"

    ## wifi and ssid
    turn_on_wifi
    select_ssid

    ## wpa_supplicant configs

    define_wpa_credentials
    package_manager_reminder

    if [ ! -f /etc/wpa_supplicant/wpa_supplicant_$myssid.conf ]; then
        ## Warning msg
        ttyCenteredHeader "Missing wpa_supplicant config" "-" "$FG_RED"
        ttyNestedString "The file /etc/wpa_supplicant/wpa_supplicant_$myssid.conf does not exist. Remidy this by running the `basename "$0"` while logged in from the \"root\" account." "$FG_RED"

    fi

    ## quick launch script
    make_launcher_script

    ## debian ethernet
    if [ -f /etc/apt/sources.list ]; then set_ethernet_connection; fi
}


## #############################################################################
## Run
## #############################################################################

main
