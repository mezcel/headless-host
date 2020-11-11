#!/bin/bash

## This is just an easy access readme/help/launcher for the "headless-host" configuration.

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
        width=$(($width - 1))

        strLength=${#str}

        highlightLength=$(( $width-$strLength ))

        printf "$tputBgColor$FG_BLACK $str"
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor "
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

function Alias_Arguments {
    function ttyAliasDescription {
        boldChars="${MODE_BOLD}$1${STYLES_OFF}"
        normalChars="${FG_CYAN}$2${STYLES_OFF}"
        descChars="${FG_YELLOW}${MODE_BOLD}$3${STYLES_OFF}"

        if [ -z  $4 ]; then
            pathChars=" "
        else
            pathChars="$4"
        fi

        nameLength=$(( ${#1} + ${#2} ))
        if [ $nameLength -le 3 ]; then
            aliasName="${FG_CYAN}hh ${boldChars}${normalChars}\t"
        else
            aliasName="${FG_CYAN}hh ${boldChars}${normalChars}"
        fi
        descString="${descChars}"

        echo -e " $aliasName\t$descString"

        if [ ${#pathChars} -gt 1 ]; then
            echo -e "\t\t\t${FG_MAGENTA}$pathChars$STYLES_OFF"
        fi
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

    function show_additional_alias {
        ## get a list of pre-existing aliases in ~/.bashrc
        ## alias vars exist between "\ " and "=" after the "^alias " string
        aliasArray=($(cat ~/.bashrc | grep "^alias " | awk -F[\ =] '{print $2}'))

        ttyNestedString "All aliases defined in ~/.bashrc" "$FG_YELLOW"
        echo -e "\t${FG_CYAN}${MODE_BOLD}${aliasArray[*]}${STYLES_OFF}"
    }

    function about {
        clear

        ttyCenteredHeader "headless-host" "#" "$FG_CYAN"
        ttyNestedString "\"hh\" is a ~/.bashrc alias used to launch commonly used server administrative tasks. Enter \"hh\" followed by a shortcut letter or auto complete argument." "$FG_GREEN"

        boldLetter1=${FG_CYAN}${MODE_BOLD}
        boldLetter2=${STYLES_OFF}${FG_CYAN}
        brightDesc=${FG_YELLOW}${MODE_BOLD}

        aliasPath=$(cat ~/.bashrc | grep "alias hh=\"bash " | awk '{print $3}' | sed 's/"//g')

        defaultWifi=$(find ~/ -maxdepth 1 -name "launch_*.sh")

        musicPlaylist=~/Music/myRadio.pls

        echo ""
        ttyHighlightRow "hh alias':" "${BG_CYAN}"

        ttyAliasDescription "m" "ount" "mount\t/dev/sdb1" " "
        ttyAliasDescription "um" "ount" "umount\t/dev/sdb1" " "
        ttyAliasDescription "u" "p" "connect to wifi as defined by wpa_supplicant" "$defaultWifi"
        ttyAliasDescription "d" "own" "disconnect wifi" " "
        ttyAliasDescription "r" "eset" "restart wifi" " "
        ttyAliasDescription "n" "vlc" "launch nvlc playlst" "$musicPlaylist"
        ttyAliasDescription "a" "lsamixer" "launch alsamixer" " "
        ttyAliasDescription "b" "attery" "view tlp battery state" " "
        ttyAliasDescription "e" "dit" "edit the \"hh\" script in Vim." "$aliasPath"
        ttyAliasDescription "off" " " "go offline & shutdown computer" " "
        echo ""

        ttyHighlightRow "~/.bashrc alias':" "${BG_CYAN}"
        show_additional_alias

        ## make an auto complete list in case one doesn't exist
        complete -W 'up down restart mount umount off edit alsamixer nvlc' hh

        ttyHR "#" "$FG_CYAN"
        echo ""
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
            #sudo chmod 777 $aliasPath
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
        echo -e "${MODE_BOLD}${FG_MAGENTA}${FG_WHITE}\ntlp-stat | grep \"+++ Battery\" -A 11  ... ${STYLES_OFF}"
        sleep 1

        command -v tlp-stat &>/dev/null
        isTlp=$?

        if [ $isTlp -eq 0 ]; then
            echo "${STYLES_OFF}${FG_MAGENTA}${MODE_BOLD}"
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
}


## #############################################################################
## Headless Host alias arguments
## #############################################################################

## Initialize

Decorative_Formatting
Tput_Colors
Alias_Arguments

## RUN

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
