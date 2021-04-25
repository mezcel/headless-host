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
	#liveRufus=/media/user/persistence/downloaded-debs
	liveRufus=/mnt/downloaded-debs

	echo -e "$MODE_BOLD $FG_YELLOW"
    echo -e "\nMy goto repo locations:"
    echo -e " ( 1. Host machine      ) $localUsbRepo"
    echo -e " ( 2. Generic Live      ) $liveUsbRepo"
    echo -e " ( 3. MX Linux Live     ) $liveMxUsb"
    #echo -e " ( 4. Rufus Persistence ) $liveRufus"
    echo -e " ( 4. Generic /mnt      ) $liveRufus"
    echo -e " ( <your custom path>   ) Type in your own file path."
    echo -e "                           example: /media/user/USB-Name/downloaded-debs"

	echo "$FG_GREEN "
	promptString="Where is your local Repo? [ ${FG_CYAN}1-4 $FG_GREEN]:$STYLES_OFF "
	read -e -p "$promptString" -i "4" repoNo

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
		4 )
            mirrorPath=$liveRufus
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
		echo -e "$MODE_BOLD $FG_RED \nRepo miror directory: \"$mirrorPath\".  does not exist. $STYLES_OFF \nScript exited."
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

    ## Dependency:
    ## The dpkg-dev package is required to run dpkg-scanpackages
	sudo apt install dpkg-dev

	##cd $mirrorPath

    if [ -f $mirrorPath/Packages.gz ]; then
        sudo rm $mirrorPath/Packages.gz
        sleep 2s
    fi

	if [ -d $mirrorPath ] ; then
		echo -e "$FG_YELLOW Making $mirrorPath/Packages.gz ... $STYLES_OFF"

		sudo dpkg-scanpackages $mirrorPath | gzip > $mirrorPath/Packages.gz
		sleep 2s
	fi

}

function Make_SourcesMirror_List {
	#cd $mirrorPath

	mirrorLink=/etc/apt/sources.list.d/myRepoMirror.list

    if [ -f $mirrorPath/Packages.gz ]; then
        ## Write file
        sudo mkdir -p /etc/apt/sources.list.d/

        ## Live Usb Repo
		## rm 1st char
		mirrorPath=${mirrorPath#?}
        echo "deb [trusted=yes] file:/// $mirrorPath/" > ~/tmpMirror 
	sudo mv ~/tmpMirror $mirrorLink
        sleep 2s
		sudo apt update
    fi
}

function Set_My_Timezone {
	sudo timedatectl set-timezone America/New_York
}

function LazyPrompt {

	echo -e "$MODE_BOLD $FG_YELLOW"
	echo -e "\nOptions:"
	echo -e "\t( 1. ) Make a new offline mirror from current distro."
	echo -e "\t( 2. ) Import an offline repo."
	echo -e "$STYLES_OFF"

	echo "$FG_GREEN "
	promptString="Pick an option? [ ${FG_CYAN}2 $FG_GREEN]:$STYLES_OFF "
	read -e -p "$promptString" -i "2" mirrorOption

	case $mirrorOption in
		1 )
			echo "$FG_GREEN "
			promptString="Make a package list and package downloader? [ ${FG_CYAN}Y/n $FG_GREEN]:$STYLES_OFF "
			read -e -p "$promptString" -i "y" yn

			case $yn in
				[Yy]* )
					echo -e "$MODE_BOLD ${FG_PURPLE}Making a downloader script.$STYLES_OFF \n"
					Make_Download_Script
					echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
					;;
			esac

			echo "$FG_GREEN "
			promptString="Download debs for a new Mirror Repo? [ ${FG_CYAN}Y/n $FG_GREEN]:$STYLES_OFF "
			read -e -p "$promptString" -i "y" yn

			case $yn in
				[Yy]* )
					echo -e "$MODE_BOLD ${FG_PURPLE}Downloading Debs.$STYLES_OFF \n"
					Download_Debs
					echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
					;;
			esac

			echo "$FG_GREEN "
			promptString="Make Packages.gz? [ ${FG_CYAN}Y/n $FG_GREEN]:$STYLES_OFF "
			read -e -p "$promptString" -i "y" yn

			case $yn in
				[Yy]* )
					echo -e "$MODE_BOLD ${FG_PURPLE}Making Packages.gz .$STYLES_OFF \n"
					Make_Packages_Gz
					echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
					;;
			esac

			;;

		2 )
			echo "$FG_GREEN "
			promptString="Update local sources.list? [ ${FG_CYAN}Y/n $FG_GREEN]:$STYLES_OFF "
			read -e -p "$promptString" -i "y" yn

			case $yn in
				[Yy]* )
					echo -e "$MODE_BOLD ${FG_PURPLE}Updating source mirror.$STYLES_OFF \n"
					Make_SourcesMirror_List
					echo -e "${FG_PURPLE}DONE.$STYLES_OFF \n"
					;;
			esac
			;;
	esac

}

function main {
	Tput_Colors
	Set_My_Timezone

	clear
	echo -e "Current mounted blocks:"
	lsblk
	echo -e "\nCurrent PWD:"
	pwd
	echo ""

	Mirror_Location
	LazyPrompt
}

function updatePw {
	## MXLinux's default live usb password = "demo"
	## Bunsenlabs Crunchbang's default live usb password = "live"
	
	inxi -F | grep "MX" 2> /dev/null
	isMXLinux=$?
	if [ $isMXLinux -eq 0 ]; then
		defaultLivePw=demo
	else
		defaultLivePw=live
	fi
	
	echo -e "Password change sould only be done once.\n\tSkip this if this is your +2nd time running this script.\n\tUse \"passwd\" instead or restart the live usb.\n"
	echo "## MXLinux's default live usb password = \"demo\""
	echo "## Bunsenlabs Crunchbang's default live usb password = \"live\""
	echo ""
	
	read -e -p "Update passwd? [y]: " -i "y" yn
	
	if [ $yn == "y" ]; then 
		mypassword=$defaultLivePw
		
		read -e -p "Enter New Password for root and user: " -i "mypassword" mypassword
		
		(echo -e "$defaultLivePw"; echo -e "$mypassword"; echo -e "$mypassword";) | passwd
		(echo -e "$mypassword"; echo -e "$mypassword";) | sudo passwd
	fi
	
	read -p "press enter to continue" pauseEnter
}

## Run
updatePw 
main

## Crunchbang post install setup
sudo apt -y update --fix-missing
sudo apt -y upgrade
sudo apt install -y build-essential vim vifm tmux git firefox-esr
sudo apt remove -y nano

echo "This is just a file for easy access notes." >> ~/note.txt
#echo -e "#!/bin/bash\nmkdir -p ~/Downloads\nwget -c \"https://raw.githubusercontent.com/mezcel/headless-host/main/home/dl-my-repos.sh\" -P ~/Downloads" > myRepoScript.sh
echo -e "#!/bin/bash \nsh -c \"$(curl -fsSL https://raw.githubusercontent.com/mezcel/headless-host/main/home/dl-my-repos.sh)\"" > myRepoScript.sh

