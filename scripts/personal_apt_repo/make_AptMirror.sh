#!/bin/bash


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

function Mirror_Location {

    localUsbRepo=/downloaded-debs
    liveUsbRepo=/usr/lib/live/mount/medium/downloaded-debs
    liveMxUsb=/home/demo/Live-usb-storage/downloaded-debs

	echo -e "$FG_YELLOW"
    echo -e "\nMy goto repo locations:"
    echo -e " ( 1. Host machine    ) $localUsbRepo"
    echo -e " ( 2. Generic Live    ) $liveUsbRepo"
    echo -e " ( 3. MX Linux Live   ) $liveMxUsb"
    echo -e " ( <your custom path> ) Type in a directory path not listed above."

	echo "$FG_GREEN "
	read -e -p "Where is your local Repo? [ 1, 2, or 3 ]: " -i "3" repoNo
	echo "$STYLES_OFF "

	case $repoNo in
        1 )
            mirrorPath=$localUsbRepo
            ;;
        2 )
            mirrorPath=$liveUsbRepo
            ;;
        3 )
            mirrorPath=$liveMxUsb
            ;;
        * )
			mirrorPath=$repoNo
			;;
    esac

	## Make dir
	if [ ! -d $mirrorPath ]; then
		sudo mkdir -p $mirrorPath
	fi

	sleep 2s

	## Double check directory
	if [ ! -d $mirrorPath ]; then
		echo -e "\nThe $mirrorPath does not exist.\n\tScript exited.\n"
		exit
	fi

}

function Make_Download_Script {
	sudo mkdir -p $mirrorPath
	cd $mirrorPath

	dpkgList=$mirrorPath/dpkg_List.txt
	dlScript=$mirrorPath/download-deb-script.sh
    sleep 2s

	dpkg -l | grep ^ii | awk '{print $2}' | cut -d: -f1 > $dpkgList

	echo '#!/bin/bash' > $dlScript
	echo "" >> $dlScript
	sed 's/^/sudo apt download /g' $dpkgList >> $dlScript

	cd $mirrorPath
	sudo chmod +x download-deb-script.sh
}

function Download_Debs {
	sudo mkdir -p $mirrorPath
	cd $mirrorPath
	if [ -f $dlScript ]; then
		bash $dlScript
	else
		echo -e "\n\t$dlScript does not exist"
		exit
	fi
}

function Make_Packages_Gz {

    ## Dependancy:
    ## The dpkg-dev package is required to run dpkg-scanpackages
	sudo apt install dpkg-dev

	##cd $mirrorPath

    if [ -f $mirrorPath/Packages.gz ]; then
        sudo rm $mirrorPath/Packages.gz
        sleep 2s
    fi

	if [ -d $mirrorPath ] ; then
		sudo dpkg-scanpackages $mirrorPath | gzip > $mirrorPath/Packages.gz
		sleep 2s
	fi

}

function Make_SourcesMirror_List {
	#cd $mirrorPath

	mirrorLink=/etc/apt/sources.list.d/myRepoMirror.list

    if [ -f $mirrorPath/Packages.gz ]; then
        ## Write file
        mkdir -p /etc/apt/sources.list.d/

        ## Live Usb Repo
        echo "deb [trusted=yes] file://$mirrorPath ./" > $mirrorLink
        sleep 2s
		sudo apt update
    fi
}

function LazyPrompt {

	echo -e "$FG_YELLOW"
	echo -e "\nThe following qustions will be asked:"
	echo -e "\tMake a package list of existing packages?"
	echo -e "\tDownload debs for a new Mirror Repo?"
	echo -e "\tMake Packages.gz?"
	echo -e "\tUpdate local sources.list?"
	echo -e "\n"

	#Mirror_Location

	echo "$FG_GREEN "
	promptString="Make a package list and package dpwnloader? [ ${FG_CYAN}Y/n $FG_GREEN]: "
	read -e -p "$promptString" -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_Download_Script
			echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
			;;
	esac

	echo "$FG_GREEN "
	promptString="Download debs for a new Mirror Repo? [ ${FG_CYAN}Y/n $FG_GREEN]: "
	read -e -p "$promptString" -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Download_Debs
			echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
			;;
	esac

	echo "$FG_GREEN "
	promptString="Make Packages.gz? [ ${FG_CYAN}Y/n $FG_GREEN]: "
	read -e -p "$promptString" -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_Packages_Gz
			echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
			;;
	esac

	echo "$FG_GREEN "
	promptString="Update local sources.list? [ ${FG_CYAN}y/Nn $FG_GREEN]: "
	read -e -p "$promptString" -i "n" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_SourcesMirror_List
			echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
			;;
	esac
}

function main {
	Tput_Colors

	clear
	echo ""
	lsblk
	echo ""
	pwd
	echo ""

	Mirror_Location
	LazyPrompt
}

## Run
main