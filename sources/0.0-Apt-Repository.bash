#!/bin/bash

##
## 0.0-Apt-Repository.sh
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
        echo -e "Overwriting a previous $customSourceList, and writing a new one. $FGBG_NoColor \n"
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
        echo -e "${FG_RED}\nPing test on $pingIp, failed. $FGBG_NoColor Internet is not required in setting up an Apt repository."
        echo -e "$FG_BLUE \
        \n\tFor an online Apt repo, connect to the internet and have it's url ready. \
        \n\tFor a USB Apt repo, ensure it is mounted before continuing. \
        \n\tFor a local Apt repo, make sure you have it's full path from the computer's \"file system\" root \"/\" directory. $FGBG_NoColor"

        if [ "$( ls -A /etc/apt/sources.list.d )" ]; then
            promptString="Do you want to initialize and apply your personal repository mirror link source? [ y/N ]: "
            yn=no
        else
            promptString="Do you want to initialize and apply your personal repository mirror link source? [ Y/n ]: "
            yn=yes
        fi

        echo ""
        read -e -p "$promptString" -i "$yn" yn
        echo ""

        case $yn in
            [Yy]* )
                echo ""
                downloadedDebs=/downloaded-debs
                promptString="${FG_GREEN}Enter the full repository mirror link path? [ ${FG_CYAN}$downloadedDebs${FG_GREEN} ]:${STYLES_OFF} "
                read -e -p "$promptString" -i "$downloadedDebs" downloadedDebs
                echo ""

                if [ ! -d $downloadedDebs ]; then
                    echo -e "$FG_RED \
                    \n$downloadedDebs is not a directory. \
                    \n\tExiting now. \
                    \n\tCheck everything and try again. $FGBG_NoColor"
                    Exit
                else
                    personal_repo $downloadedDebs
                fi
                ;;
            [Nn]* )
                echo -e "$FG_RED\nCanceled importing an additional custom off line Apt mirror repository.\n $FGBG_NoColor"
                sleep 1
                ;;
            * )
                echo -e "$FG_RED \nYou did not enter a y or n response. \nExited. \nDone.\n $FGBG_NoColor"
                exit
                ;;
        esac
    else
        ## Yes Internet

        echo -e ""
        promptString="${FG_YELLOW}Overwrite the existing sources.list with a regional USA Debian mirror? [ Y/n ]: $FGBG_NoColor"
        read -e -p "$promptString" -i "yes" yn
        echo -e ""

        case $yn in
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
        read -e -p "$promptString" -i "no" yn
        echo -e ""

        case $yn in
            [Yy]* )
                sudo vi /etc/apt/sources.list
                sleep 1s
                sudo apt update
                ;;
        esac

    fi
}

function set_personal_repo {

    echo -e "$BG_CYAN${FG_BLACK} \
    \n## Mounting a personally curated APT repository. ## $FGBG_NoColor"
    sleep 1s

    me=$(whoami)
    if [ $me == "root" ]; then
        ## Personally curated repo
        setup_apt_repo
    fi
}

## #####################################################################################################################
## Personal repository

tput_colors

echo ""
titleColors=${BG_MAGENTA}${FG_WHITE}
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo "${titleColors}## Import a personally curated Apt repository of Deb's                                             ##$STYLES_OFF"
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo ""
sleep 1s

#set_personal_repo
setup_apt_repo
