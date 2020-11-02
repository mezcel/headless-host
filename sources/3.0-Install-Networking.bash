#!/bin/bash

##
## 3.0-Install-Networking.sh
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

function Ask4NetworkManager {
    echo -e ""
    promptString="${FG_RED}Do you want to install NetworkManager? [ y/N ]: $STYLES_OFF"
    read -e -p "$promptString" -i "NoThanks" yn
    echo -e "$FGBG_NoColor"

    case $yn in
        [Yy]* )
            sudo apt install -y network-manager
            #sudo apt install -y xrdp
            ;;
    esac

}

function Install_Network_Drivers {
    sudo apt install -y linux-image-$(uname -r)
    sudo apt install -y linux-headers-$(uname -r)

    sudo apt install -y firmware-linux-free
    sudo apt install -y firmware-linux-nonfree
    sudo apt install -y firmware-iwlwifi

    ## Detect and/or Display the wireless driver Chipset

    lspci | grep "Broadcom" &>/dev/null
    isBroadcom=$?

    if [ $isBroadcom -eq 0 ]; then
        echo -e "${BG_CYAN}${FG_BLACK}\nBroadcom Wifi Driver: ${STYLES_OFF}\n"
        echo -e "${FG_CYAN}\tIf you choose to install Broadcom drivers, the computer will restart after installation."
        echo -e "${STYLES_OFF}"

        ## check if driver is already installed
        sudo dpkg-query --list broadcom-sta-dkms firmware-brcm80211 &>/dev/null

        yn=$?
        if [ $yn -eq 0 ]; then
            promptString="Install the brcm80211 Broadcom wifi drivers? [ y/N ]: "
            yn=no
        else
            promptString="Install the brcm80211 Broadcom wifi drivers? [ Y/n ]: "
            yn=yes
        fi

        read -e -p "$promptString" -i "$yn" yn
        echo ""

        case $yn in
            [Yy]* )
                sudo apt install -y firmware-brcm80211
                sudo apt install -y broadcom-sta-dkms

                echo -e "$FG_YELLOW"
                echo -e "\nI recommend restarting the computer now. \
                \n\tNote: You will need to run the installer again. \
                \n\tOn the next pass the option to install brcm80211 will be default to \"no\" for convenience.\n"
                echo -e "${STYLES_OFF}"

                promptString="Restart the computer now? [ Y/n ]: "
                sleep 2s
                ynRestart=yes
                read -e -p "$promptString" -i "$ynRestart" ynRestart
                echo ""
                case $yn in
                    [Yy]* )
                        sudo reboot
                    ;;
                esac
                ;;
        esac

    fi
}

function networking_applications {

    echo -e "$FG_CYAN\n\tInstalling applications focused on telecommunications  ...\n $FGBG_NoColor"

    sudo apt update
    sudo apt --fix-broken install
    sudo apt update

    ## Install network drivers
    Install_Network_Drivers

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
    promptString="${FG_GREEN}Do you want to connect to an available external Wireless WPA2 SSID access point using wpa_supplicant? [y/N]:${STYLES_OFF} "
    echo ""
    read -e -p "$promptString" -i "not_now" yn
    echo ""
    case $yn in
        [Yy]* )
            bash my_iwconfig.sh
            ;;
    esac
}

tput_colors

echo ""
titleColors=${BG_MAGENTA}${FG_WHITE}
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo "${titleColors}## Networking packages                                                                             ##$STYLES_OFF"
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo ""
sleep 1s

networking_applications
Ask4NetworkManager
Set_WpaSupplicant

