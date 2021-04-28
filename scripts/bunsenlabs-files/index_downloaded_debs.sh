#!/bin/bash

##
## input the path to the personal repo zip
## Packages.gz
## I like to pout this script into the the repo itself for easy access
## Make Sure to manually change the $debRepo and $customSourceList var strings
##


#indexZip=$1
indexZip=Packages.gz

## My repo folder name
#debRepo=/downloaded-debs
debRepo=$(basename "$(pwd)")

## the name of the list file that points to the repo folder
read -e -p "Give a custom name to the source.list file which APT will use to link your mirror. : " -i "$debRepo" mySourceListName
customSourceList=/etc/apt/sources.list.d/$mySourceListName.list

function tput_colors {

    ## Foreground Color using ANSI escape

	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
    FG_YELLOW=$(tput setaf 3)
    FG_MAGENTA=$(tput setaf 5)
    FG_CYAN=$(tput setaf 6)

    ## Background Color using ANSI escape

    BG_RED=$(tput setab 1)
    BG_GREEN=$(tput setab 2)
    BG_YELLOW=$(tput setab 3)
    BG_MAGENTA=$(tput setab 5)
    BG_CYAN=$(tput setab 6)

    ## Remove color format

	FGBG_NoColor=$(tput sgr0)
}

function modify_sources_list {

	echo "#
## /etc/apt/sources.list 
#

#deb http://ftp.us.debian.org/debian/ buster main contrib non-free
#deb-src http://ftp.us.debian.org/debian/ buster main contrib non-free

#deb http://security.debian.org/debian-security buster/updates main contrib non-free
#deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

## buster-updates, previously known as 'volatile'

#deb http://ftp.us.debian.org/debian/ buster-updates main contrib non-free
#deb-src http://ftp.us.debian.org/debian/ buster-updates main contrib non-free
	" > ~/sources.list.tmp
	
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
	
	sudo mv ~/sources.list.tmp /etc/apt/sources.list 

}

function index_repo {

    if [ -f $debRepo/$indexZip ]; then
        echo -e "$FG_YELLOW\tRemoving previous $debRepo/$indexZip ... $FGBG_NoColor \n"

        sudo rm $debRepo/$indexZip
        sleep 2s
    fi

    echo -e "$FG_GREEN\tIndexing the $debRepo/$indexZip local offline Debian repository. \n\t this will take a moment ... $FGBG_NoColor\n"

    sudo dpkg-scanpackages $debRepo | gzip > $debRepo/$indexZip

    if [ -f $debRepo/$indexZip ]; then
        echo -e "$FG_YELLOW\tBacking up any previous $customSourceList and writing a new one. $FGBG_NoColor \n"

        ## Write file
        sudo echo "deb [trusted=yes] file:/// $debRepo/" > $customSourceList
        sleep 2s
    fi
}

###############
## run
###############

tput_colors
modify_sources_list
index_repo
sudo apt update