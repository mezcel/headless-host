#!/bin/bash

##
## 0.0-Apt-Repository.sh
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
        width=80
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

        width=80
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
        ttyMaxCols=79

        charCount=0
        isFrstLine=1

        printf "$tputFgColor"
        for i in "${strArray[@]}"; do
            charCount=$(($charCount+${#i}+1))

            if [ $isFrstLine -ne 1 ]; then
                ttyMaxCols=79
                ttyMaxCols=$(($ttyMaxCols-4))
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

    function ttyPromptInput {
        promptTitle=$1
        promptString=$2
        defaultAnswer=$3
        tputFgColor=$4
        tputBgColor=$5

        width=80
        promptTitleLength=${#promptTitle}

        titleLength=${#promptTitle}
        highlightLength=$(( 79-$titleLength ))

        printf "$tputBgColor$FG_BLACK $promptTitle"
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor "
        done
        printf "$STYLES_OFF\n"

        read -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        printf "$STYLES_OFF\n"
        sleep 1
    }

}

function personal_repo {

    debRepo=$1

    repoListName=$(basename -- $debRepo).list

    indexZip=Packages.gz

    customSourceList=/etc/apt/sources.list.d/$repoListName

    if [ -f $debRepo/$indexZip ]; then
        echo "$FG_YELLOW"
        echo -e "Removing previous $debRepo/$indexZip ... $FGBG_NoColor"

        sudo rm $debRepo/$indexZip
        sleep 2s
    fi

    echo "$FG_GREEN"
    echo -e "Indexing the $debRepo/$indexZip local off line Debian mirror repository. \n\tThis will take \"a moment\" to \"a while\" ... $FGBG_NoColor\n"

    sudo dpkg-scanpackages $debRepo | gzip > $debRepo/$indexZip
    sleep 2s

    if [ -f $debRepo/$indexZip ]; then
        echo "$FG_YELLOW"
        echo -e "Overwriting existing $customSourceList, and writing a new one. $FGBG_NoColor \n"
        sleep 1s

        ## Write file
        sudo echo "deb [trusted=yes] file:/// $debRepo/" > $customSourceList
        sleep 2s
    fi

    ## Copy my personally defined list which has my mirrors commented out
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
    sudo cp scripts/extra_drivers/sources.list /etc/apt/sources.list
    sleep 1s

    sudo apt update

    #cd $currentDir
}

function setup_apt_repo {

    pingIp=google.com
    sudo ping -c3 $pingIp &>/dev/null

    pingTest=$?
    if [ $pingTest -ne 0 ]; then
        ## No Internet
        ttyNestedString "Ping test on $pingIp, failed.$STYLES_OFF Internet is not required in setting up an Apt repository." "$FG_RED"
        ttyNestedString "* For an online Apt repo, connect to the internet and have it's url ready." "$FG_BLUE"
        ttyNestedString "* For a USB Apt repo, ensure it is mounted before continuing." "$FG_BLUE"
        ttyNestedString "* For a local Apt repo, make sure you have it's full path from the computer's \"file system\" root \"/\" directory." "$FG_BLUE"

        if [ "$( ls -A /etc/apt/sources.list.d )" ]; then
            promptString="Do you want to initialize and apply your personal repository mirror link source? [ y/N ]: "
            readInput=no
        else
            promptString="Do you want to initialize and apply your personal repository mirror link source? [ Y/n ]: "
            readInput=yes
        fi

        ttyPromptInput "Personal Apt Mirror Repository:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            [Yy]* )
                echo ""
                readInput=/downloaded-debs

                promptString="Enter the full repository mirror link path? [ $downloadedDebs ]: "
                ttyPromptInput "Personal Apt Mirror Repository:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

                if [ ! -d $readInput ]; then
                    ttyNestedString "$downloadedDebs is not a directory. Exiting now. Check everything and try again." "$FG_RED"
                    Exit
                else
                    personal_repo $readInput
                fi
                ;;
            [Nn]* )
                ttyNestedString "Canceled importing an additional custom off line Apt mirror repository." "$FG_RED"
                sleep 1
                ;;
            * )
                ttyNestedString "You did not enter a \"y\" or \"n\" response. Exited. Done." "$FG_RED"
                exit
                ;;
        esac
    else
        ## Yes Internet

        promptString="${FG_YELLOW}Overwrite existing sources.list with a USA Debian mirror? [ Y/n ]: "
        ttyPromptInput "Mirror link source:" "$promptString" "yes" "$FG_YELLOW" "$BG_YELLOW"

        case $readInput in
            [Yy]* )
                if [ -f /etc/apt/sources.list ]; then
                    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
                fi

                sudo cp $(dirname $)/scripts/extra_drivers/sources.list /etc/apt/sources.list
                sudo apt update
                ;;
        esac

        echo -e ""
        promptString="Manually edit sources.list in Vi? [ y/N ]: "
        ttyPromptInput "Mirror link source:" "$promptString" "no" "$FG_YELLOW" "$BG_YELLOW"

        case $readInput in
            [Yy]* )
                sudo vi /etc/apt/sources.list
                sleep 1s
                sudo apt update
                ;;
        esac

    fi
}

function set_personal_repo {
    ttyCenteredHeader "Mounting a personally curated APT repository." "#" "$FG_CYAN"
    sleep 1s

    me=$(whoami)
    if [ $me == "root" ]; then
        ## Personally curated repo
        setup_apt_repo
    fi
}

## #####################################################################################################################
## Personal repository

Decorative_Formatting
Tput_Colors

ttyCenteredHeader "Import a personally curated Apt repository of Deb's" "#" "$FG_MAGENTA"
sleep 1s

#set_personal_repo
setup_apt_repo
