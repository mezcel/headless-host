#!/bin/bash

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
    echo -e "Indexing the $debRepo/$indexZip local offline Debian repository. \n\t this will take a moment ... $FGBG_NoColor\n"

    sudo dpkg-scanpackages $debRepo | gzip > $debRepo/$indexZip
    sleep 2s

    if [ -f $debRepo/$indexZip ]; then
        echo "$FG_YELLOW"
        echo -e "Backing up any previous $customSourceList and writing a new one. $FGBG_NoColor \n"

        ## Write file
        sudo echo "deb [trusted=yes] file:/// $debRepo/" > $customSourceList
        sleep 2s
    fi

    cp scripts/etc/apt/sources.list /etc/apt/sources.list

    sudo apt update
}

function setup_apt_repo {

    pingIp=google.com
    sudo ping -c3 $pingIp &>/dev/null
    pingTest=$?
    if [ $pingTest -ne 0 ]; then
        ## No Internet
        echo -e "$FG_RED \n$pingIp ping failed. $FGBG_NoColor\n"
        echo -e "$FG_YELLOW\tTry entering a directory/url path to a dedicated apt repo directory."
        echo -e "\tNow would be a good time to \"Ctrl-C\" to exit this wizard, connect do what you go to do, and come back with a repo link ready.\n $FGBG_NoColor"

		read -e -p "Do you have a your own repo link source? [ y/N ]: " -i "n" yn

		case $yn in
			[Yy]* )
                read -e -p "Enter full repo link path: [ /downloaded-debs ] " -i "/downloaded-debs" downloadedDebs

                if [ ! -d $downloadedDebs ]; then
                    echo -e "$FG_RED \n$downloadedDebs is not a directory.\n\tExiting now.\n\tCheck everything and try again. $FGBG_NoColor"
                    Exit
                else
                    personal_repo $downloadedDebs
                fi
				;;
			[Nn]* )
                echo -e "$FG_GREEN \nExited.\nDone.\n $FGBG_NoColor"
				#exit
                continue
				;;
			* )
                echo -e "$FG_GREEN \nExited.\nDone.\n $FGBG_NoColor"
				#exit
                continue
				;;
		esac
    else
        ## Yes Internet
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
        sudo cp $(dirname $)/scripts/etc/apt/sources.list /etc/apt/sources.list
        sudo apt update
    fi
}

function set_personal_repo {

    echo -e "$FG_CYAN\n\tMounting a personally curated APT repository...\n $FGBG_NoColor"

    me=$(whoami)
    if [ $me == "root" ]; then
        ## Personally curated repo
        setup_apt_repo
    fi
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


modify_sources_list
set_personal_repo