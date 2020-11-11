#!/bin/bash

##
## 3.0-Install-Networking.sh
##

function Decorative_Formatting {
    ## Decorative tty colors
    function Tput_Colors {
        ## Foreground Color using ANSI escape provided though tput

        FG_BLACK=$(tput setaf 0)
        FG_RED=$(tput setaf 1)
        FG_GREEN=$(tput setaf 2)
        FG_YELLOW=$(tput setaf 3)
        FG_BLUE=$(tput setaf 4)
        FG_MAGENTA=$(tput setaf 5)
        FG_CYAN=$(tput setaf 6)
        FG_WHITE=$(tput setaf 7)
        FG_NoColor=$(tput sgr0)

        ## Background Color using ANSI escape provided though tput

        BG_BLACK=$(tput setab 0)
        BG_RED=$(tput setab 1)
        BG_GREEN=$(tput setab 2)
        BG_YELLOW=$(tput setab 3)
        BG_BLUE=$(tput setab 4)
        BG_MAGENTA=$(tput setab 5)
        BG_CYAN=$(tput setab 6)
        BG_WHITE=$(tput setab 7)
        BG_NoColor=$(tput sgr0)

        ## set mode using ANSI escape provided though tput

        MODE_BOLD=$(tput bold)
        MODE_DIM=$(tput dim)
        MODE_BEGIN_UNDERLINE=$(tput smul)
        MODE_EXIT_UNDERLINE=$(tput rmul)
        MODE_REVERSE=$(tput rev)
        MODE_ENTER_STANDOUT=$(tput smso)
        MODE_EXIT_STANDOUT=$(tput rmso)

        # clear styles using ANSI escape provided though tput

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

        printf "$tputBgColor$FG_BLACK═ $str "
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor═"
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

function Get_Networking_Applications {
    function Ask4NetworkManager {
        promptString="${FG_RED}Do you want to install NetworkManager? [ y/N ]: "
        ttyPromptInput "NetworkManager" "$promptString" "NoThanks" "$FG_RED" "$BG_RED"

        case $readInput in
            [Yy]* )
                sudo apt install -y network-manager
                #sudo apt install -y xrdp
                ;;
        esac
    }

    function Install_Network_Drivers {
        ttyCenteredHeader "Networking drivers" "┅" "$FG_CYAN"
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

            ttyCenteredHeader "Broadcom Wifi" "┅" "$FG_YELLOW"
            ttyNestedString "If you choose to install Broadcom drivers, the computer will restart after installation." "$FG_YELLOW"

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

                    promptString="Restart the computer now? [ Y/n ]: "
                    ttyPromptInput "Restart:" "$promptString" "yes" "$FG_GREEN" "$BG_GREEN"

                    case $readInput in
                        [Yy]* )
                            sudo reboot
                        ;;
                    esac
                    ;;
            esac

        fi
    }

    function networking_applications {
        sudo apt update
        sudo apt --fix-broken install
        sudo apt update

        ## Install network drivers
        Install_Network_Drivers

        ttyCenteredHeader "Networking application packages" "╌" "$FG_CYAN"
        sleep 2s

        sudo apt install -y resolvconf

        sudo apt install -y build-essential
        sudo apt install -y util-linux
        sudo apt remove nano

        sudo apt install -y elinks
        sudo apt install -y w3m
        sudo apt install -y git
        sudo apt install -y curl
        sudo apt install -y iputils-ping
    }

    function Set_WpaSupplicant {
        promptString="Connect to an available wireless network? [ y/N ]: "
        ttyPromptInput "Wifi SSID Connection (wpa_supplicant):" "$promptString" "not_now" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            [Yy]* )
                bash my_iwconfig.sh
                ;;
        esac
    }
}

## Initialize

Decorative_Formatting
Tput_Colors
Get_Networking_Applications

## RUN

ttyCenteredHeader "Networking packages" "░" "$FG_MAGENTA"
sleep 2s

networking_applications
Ask4NetworkManager
Set_WpaSupplicant

