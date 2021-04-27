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
#main

## Crunchbang post install setup
sudo apt -y update --fix-missing
#sudo apt -y upgrade
sudo apt install -y build-essential vim vifm tmux git firefox-esr
sudo apt remove -y nano

echo "This is just a file for easy access notes." >> ~/note.txt
#echo -e "#!/bin/bash\nmkdir -p ~/Downloads\nwget -c \"https://raw.githubusercontent.com/mezcel/headless-host/main/home/dl-my-repos.sh\" -P ~/Downloads" > myRepoScript.sh
echo -e "#!/bin/bash \nsh -c \"$(curl -fsSL https://raw.githubusercontent.com/mezcel/headless-host/main/home/dl-my-repos.sh)\"" > myRepoScript.sh

