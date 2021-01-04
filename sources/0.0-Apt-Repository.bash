#!/bin/bash

##
## 0.0-Apt-Repository.sh
##

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

function Configure_Apt {
    function personal_repo {
        debRepo=$1

        repoListName=$(basename -- $debRepo).list
        indexZip=Packages.gz
        customSourceList=/etc/apt/sources.list.d/$repoListName

        if [ -f $debRepo/$indexZip ]; then
            ttyNestedString "Removing previous $debRepo/$indexZip ..." "$MODE_BOLD$FG_YELLOW"
            sleep 1

            sudo rm $debRepo/$indexZip
            sleep 2s
        fi

        ttyNestedString "Indexing the $debRepo/$indexZip local off-line Debian mirror repository. This will take \"a moment\" up to \"a while\" ..." "$MODE_BOLD$FG_GREEN"
        sleep 1

        sudo dpkg-scanpackages $debRepo | gzip > $debRepo/$indexZip
        sleep 2s

        if [ -f $debRepo/$indexZip ]; then
            ttyNestedString "Overwriting existing $customSourceList, and writing a new one ..." "$MODE_BOLD$FG_YELLOW"
            sleep 1s

            ## Write file
            sudo echo "deb [trusted=yes] file:/// $debRepo/" > $customSourceList
            sleep 2s
        fi

        ## Copy my personally defined list which has my mirrors commented out
        ttyNestedString "Backing up /etc/apt/sources.list ..." "$MODE_DIM$FG_YELLOW"
        sleep 1s
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)

        ttyNestedString "Writing /etc/apt/sources.list ..." "$MODE_BOLD$FG_GREEN"
        sleep 1s
        sudo cp scripts/extra_drivers/sources.list /etc/apt/sources.list
        sleep 1s

        sudo apt update
    }

    function setup_apt_repo {

        ttyCenteredHeader "Import a directory of personally curated Apt mirror repository .deb's" "-" "$FG_MAGENTA"
        sleep 2

        pingIp=google.com
        sudo ping -c3 $pingIp &>/dev/null

        pingTest=$?
        if [ $pingTest -ne 0 ]; then
            ## No Internet
            ttyNestedString "Ping test on $pingIp, failed.$STYLES_OFF Internet is not required in setting up an Apt repository." "$FG_RED"
            ttyNestedString "- For an online Apt repo, connect to the internet and have it's url ready." "$FG_BLUE"
            ttyNestedString "- For a USB Apt repo, ensure it is mounted before continuing." "$FG_BLUE"
            ttyNestedString "- For a local Apt repo, make sure you have it's full path from the computer's \"file system\" root \"/\" directory." "$FG_BLUE"
            echo ""
            if [ "$( ls -A /etc/apt/sources.list.d )" ]; then
                promptString="Initialize and apply your personal repository mirror? [ y/N ]: "
                readInput=no
            else
                promptString="Initialize and apply your personal repository mirror? [ Y/n ]: "
                readInput=yes
            fi

            ttyPromptInput "Personal Apt Mirror Repository:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"
            sleep 1

            case $readInput in
                [Yy]* )
                    echo ""
                    readInput=/downloaded-debs

                    promptString="Full directory path? [ $readInput ]: "
                    ttyPromptInput "Personal Apt Repository Repository:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

                    if [ ! -d $readInput ]; then
                        ttyNestedString "$readInput is not a directory. Exiting now. Check everything and try again." "$MODE_BOLD$FG_RED"
                        Exit
                    else
                        personal_repo $readInput
                    fi
                    ;;
                [Nn]* )
                    ttyNestedString "Canceled importing off-line Apt mirror." "$MODE_BOLD$FG_RED"
                    sleep 1
                    ;;
                * )
                    ttyNestedString "You did not enter a \"y\" or \"n\" response. Exited. Done." "$MODE_BOLD$FG_RED"
                    sleep 1
                    exit
                    ;;
            esac
        else
            ## Yes Internet

            readInput=yes
            promptString="Overwrite existing sources.list with a USA Debian mirror? [ Y/n ]: "
            ttyPromptInput "Mirror link source:" "$promptString" "$readInput" "$FG_YELLOW" "$BG_YELLOW"

            case $readInput in
                [Yy]* )
                    if [ -f /etc/apt/sources.list ]; then
                        ttyNestedString "Backing up /etc/apt/sources.list ..." "$MODE_DIM$FG_YELLOW"
                        sleep 1s

                        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
                        sleep 1s
                    fi

                    ttyNestedString "Writing /etc/apt/sources.list ..." "$MODE_BOLD$FG_GREEN"
                    sleep 1s

                    sudo cp $(dirname $)/scripts/extra_drivers/sources.list /etc/apt/sources.list
                    sleep 1s

                    sudo apt update
                    ;;
            esac

            echo -e ""
            readInput=no
            promptString="Manually edit sources.list in Vi? [ y/N ]: "
            ttyPromptInput "Mirror link source:" "$promptString" "$readInput" "$FG_YELLOW" "$BG_YELLOW"

            case $readInput in
                [Yy]* )
                    sudo vi /etc/apt/sources.list
                    sleep 1s

                    sudo apt update
                    ;;
            esac

        fi
    }
}

## #############################################################################
## Personal repository
## #############################################################################

## Initialize

Decorative_Formatting
Tput_Colors
Configure_Apt

## RUN

clear
ttyCenteredHeader "Setup an Apt Mirror Repository" "░" "$FG_MAGENTA"
sleep 2s

setup_apt_repo
