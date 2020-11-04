#!/bin/bash

## This is just an easy access readme/help/launcher for the "headless-host" configuration.

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

function wifi_up {
    sleep 1
    defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")
    if [ -f $defaultWifi ]; then
        bash $defaultWifi up
    else
        echo -e "${FG_YELLOW}\nscript file is missing. nothing happened.\n$STYLES_OFF"
    fi
}

function wifi_down {
    sleep 1
    defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")
    if [ -f $defaultWifi ]; then
        bash $defaultWifi down
    else
        echo -e "${FG_YELLOW}\nscript file is missing. nothing happened.\n$STYLES_OFF"
    fi
}

function wifi_restart {
    sleep 1
    defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")
    if [ -f $defaultWifi ]; then
        bash $defaultWifi restart
    else
        echo -e "${FG_YELLOW}\nscript file is missing. nothing happened.\n$STYLES_OFF"
    fi
}

function about {
    clear
    echo -e "${BG_BLUE}${FG_WHITE}headless-host${STYLES_OFF}\n"
    echo -e "${FG_GREEN}${MODE_BOLD}\t\"hh\" is a ~/.bashrc alias used to perform the following: ${STYLES_OFF}\n"

    boldLetter1=${FG_CYAN}${MODE_BOLD}
    boldLetter2=${STYLES_OFF}${FG_CYAN}
    brightDesc=${FG_YELLOW}${MODE_BOLD}

    aliasPath=$(cat ~/.bashrc | grep "alias hh=\"bash " | awk '{print $3}' | sed 's/"//g')

    defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")

    musicPlaylist=~/Music/myRadio.pls

    echo -e "\t${FG_CYAN}${MODE_BEGIN_UNDERLINE}Alias input:${MODE_EXIT_UNDERLINE}${STYLES_OFF}\n \
        \n\t${boldLetter2}hh ${boldLetter1}m${boldLetter2}ount\t${brightDesc}mount\t/dev/sdb1 \
        \n\t${boldLetter2}hh ${boldLetter1}um${boldLetter2}ount\t${brightDesc}umount\t/dev/sdb1 \
        \n\t${boldLetter2}hh ${boldLetter1}u${boldLetter2}p\t\t${brightDesc}connect to wifi \n\t\t\t\t${FG_MAGENTA}$defaultWifi\
        \n\t${boldLetter2}hh ${boldLetter1}d${boldLetter2}own\t\t${brightDesc}disconnect wifi \
        \n\t${boldLetter2}hh ${boldLetter1}r${boldLetter2}estart\t${brightDesc}restart wifi \
        \n\t${boldLetter2}hh ${boldLetter1}n${boldLetter2}vlc\t\t${brightDesc}launch nvlc playlst \
        \n\t\t\t\t${FG_MAGENTA}$musicPlaylist\
        \n\t${boldLetter2}hh ${boldLetter1}a${boldLetter2}lsa\t\t${brightDesc}launch alsamixer \
        \n\t${boldLetter2}hh ${boldLetter1}b${boldLetter2}attery\t${brightDesc}view tlp battery state \
        \n\t${boldLetter2}hh ${boldLetter1}e${boldLetter2}dit\t\t${brightDesc}edit the hh controls \
        \n\t\t\t\t${FG_MAGENTA}$aliasPath \
        \n\t${boldLetter2}hh ${boldLetter1}off${boldLetter2}\t\t${brightDesc}shutdown computer"
    echo -e "${STYLES_OFF}"

    ## make an auto complete list in case one doesn't exist
    complete -W 'up down restart mount umount off edit alsamixer nvlc' hh
}

function streaming_radio {
    sleep 1
    command -v vlc &>/dev/null

    if [ $? -eq 0 ]; then
        musicPlaylist=~/Music/myRadio.pls

        if [ -f $musicPlaylist ]; then
            nvlc $musicPlaylist
        fi
    fi
}

function launch_alsamixer {
    sleep 1
    command -v alsamixer &>/dev/null

    if [ $? -eq 0 ]; then
        alsamixer
    fi
}

function edit_hh_alias {
    sleep 1
    aliasPath=$(cat ~/.bashrc | grep "alias hh=\"bash " | awk '{print $3}' | sed 's/"//g')

    if [ -f $aliasPath ]; then
        sudo chmod 777 $aliasPath
        command -v vim &>/dev/null

        if [ $? -eq 0 ]; then
            vim $aliasPath
        else
            vi $aliasPath
        fi
    fi
}

function computer_off {
    sleep 1
    ## close wireless and shutdown computer
    defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")

    bash $defaultWifi down
    sudo shutdown now
}

function mountSDB1 {

    echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nmount /dev/sdb1 ...${STYLES_OFF}"
    sleep 1

    command -v udiskie $>/dev/null
    isUdiskie=$?

    if [ $isUdiskie -eq 0 ]; then
        echo -e "${MODE_BOLD}${FG_MAGENTA}"
        udiskie-mount /dev/sdb1
        echo ""
        lsblk
        echo "${STYLES_OFF}"
    else
        mountDestination=/media/$(whoami)

        if [ ! -d $mountDestination ]; then
            sudo mkdir -p $mountDestination
        fi

        if [ ! -d $mountDestination ]; then
            mountDestination=/mnt
        fi

        sudo mount /dev/sdb1 $mountDestination &>/dev/null
        isSuccess=$?

        sleep 1

        if [ $isSuccess -eq 0 ]; then
            echo -e "${MODE_BOLD}${FG_MAGENTA}## $mountDestination/*\n"
            ls -al $mountDestination
            echo "${STYLES_OFF}${FG_MAGENTA}"
            lsblk
            echo "${STYLES_OFF}"
        else
            echo -e "${MODE_BOLD}${FG_RED}## Mount failed${STYLES_OFF}"
            echo "${STYLES_OFF}${FG_MAGENTA}"
            lsblk
            echo "${STYLES_OFF}"
        fi
    fi

}

function unmountSDB1 {
    echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\numount /dev/sdb1 ...${STYLES_OFF}"
    sleep 1

    command -v udiskie $>/dev/null
    isUdiskie=$?

    if [ $isUdiskie -eq 0 ]; then
        echo "${STYLES_OFF}${FG_MAGENTA}"
        udiskie-umount /dev/sdb1 --force --detach
        echo ""
        lsblk
        echo "${STYLES_OFF}"
    else
        sudo umount /dev/sdb1
        echo "${STYLES_OFF}${FG_MAGENTA}"
        lsblk
        echo "${STYLES_OFF}"
    fi

    ## umount again just for safety
    sudo umount /dev/sdb1
}

function tlp_battery {
    echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\ntlp-stat | grep \"+++ Battery\" -A 11  ...${STYLES_OFF}"
    sleep 1

    command -v tlp-stat &>/dev/null
    isTlp=$?

    if [ $isTlp -eq 0 ]; then
        echo "${STYLES_OFF}${FG_MAGENTA}"
        sudo tlp-stat | grep "+++ Battery" -A 11
        echo "${STYLES_OFF}"
    else
        echo -e "${FG_YELLOW}\nTLP is not installed.\n$STYLES_OFF"
    fi
}

function bashrc_fix {
    ## Add ~/.bashrc alias if it is does not exist

    aliasPath=$(cat ~/.bashrc | grep "alias hh=\"bash " | awk '{print $3}' | sed 's/"//g')

    if [ -z $aliasPath ]; then
        thisFile=`basename $0`
        headlesshostPath=$(pwd)/$thisFile

        ## make a safety backup of ~/.bashrc
        cp ~/.bashrc ~/.bashrc.backup_$(date +%d%b%Y%H%S)

        ## Make a temporary .bashrc file to edit
        ## Delete previous reference to headless-host-alias.bash
        sed '/headless-host-alias.bash/c\' ~/.bashrc > ~/.bashrc.temp
        sleep 1s
        sed 'alsamixer battery down edit mount nvlc off restart unmount up/c\' ~/.bashrc > ~/.bashrc.temp
        sleep 1

        echo -e "\n## Alias for headless-host-alias.bash" >> ~/.bashrc.temp
        echo "alias hh=\"bash $headlesshostPath\"" >> ~/.bashrc.temp
        echo "complete -W \"alsamixer battery down edit mount nvlc off restart unmount up\" hh" >> ~/.bashrc.temp

        sudo mv ~/.bashrc.temp ~/.bashrc
        sleep 1

        source ~/.bashrc

        ## alias autocomplete
        ## alsamixer battery down edit mount nvlc off restart unmount up
        complete -W "alsamixer battery down edit mount nvlc off restart unmount up" hh
    fi
}

## #############
## RUN
## #############

tput_colors
bashrc_fix

case "$1" in

    um* ) ## umount
        unmountSDB1
        ;;

    m* ) ## mount
        mountSDB1
        ;;

    u* ) ## up
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nWifi Up ...${STYLES_OFF}"
        wifi_up
        ;;

    d* ) ## down
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nWifi Down ...${STYLES_OFF}"
        wifi_down
        ;;

    r* ) ## restart
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nWifi Restart ...${STYLES_OFF}"
        wifi_restart
        ;;

    n* ) ## nvlc
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nStreaming Radio ...${STYLES_OFF}"
        streaming_radio
        ;;

    a* ) ## alsamixer
        launch_alsamixer
        ;;

    e* ) ## edit
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nEdit alias script ...${STYLES_OFF}"
        edit_hh_alias
        ;;

    b* ) ## battery
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nView tlp battery status ...${STYLES_OFF}"
        tlp_battery
        ;;

    off* ) ## off
        echo -e "${MODE_BOLD}${BG_BLUE}${FG_WHITE}\nShutdown computer ...${STYLES_OFF}"
        computer_off
        ;;
    * ) ## about / help
        about
        exit
        ;;
esac
