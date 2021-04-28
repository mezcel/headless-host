#!/bin/bash

function Tput_Colors {
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

	## clear styles using ANSI escape

	STYLES_OFF=$(tput sgr0)
	FGBG_NoColor=$(tput sgr0)
}

function About {
	clear
	echo -e "$FG_YELLOW
## #####################################################################################################################
##
## ${MODE_BOLD}ABOUT: ${STYLES_OFF}${FG_YELLOW}
##
##  This script is used in preparing a personally curated Debian repository based on existing installed packages.
##
## ${MODE_BOLD}BACKGROUND: ${STYLES_OFF}${FG_YELLOW}
##
## This is generally a 2 step process.
##
##  * STEP 1: Install fully working packages.
##            This will ensure all dependencies are installed.
##            \"sudo apt depends\" will list package dependencies, but the dependency list is not always complete.
##
##  * STEP 2: Download individual *.deb packages.
##            Many *.deb packages require additional dependencies, and dependents have dependents.
##
## ${MODE_BOLD}SCRIPT FUNCTION: ${STYLES_OFF}${FG_YELLOW}
##
## The user will be prompted 2 questions:
##
##  1. Make a list of installed Debian packages?
##      - This will make both a list of installed packages, and an installer script based on that list.
##
##  2. Download individual .debs from generated package list?
##      - This will commence downloading the individual *.deb packages from the download script.
##      - A text file will be generated to list the contents of downloaded *.deb files in the downloaded directory.
##
## ${MODE_BEGIN_UNDERLINE}Generated Resources: ${MODE_EXIT_UNDERLINE}
##
##  * Offline repository:            $PackageDownloads
##  * List of pre-existing packages: $Dpkg_List
##  * Download script:               $Download_List
##  * Debian packages:               $PackageDownloads/*.deb
##  * Repository contents:           $Contents_List
##
##  Once everything is done, move/copy the $PackageDownloads directory to a USB, CD, or drive partition.
##
## #####################################################################################################################
$STYLES_OFF "

}

function InitDirVariables {
	nowDate=$(date +%d%b%Y_%H%M%S)

	## make a directory
	PackageDownloads=~/Downloads/PackageDownloads_$nowDate

	## change destination directory option
	echo -e "${$FG_YELLOW}\nThe default *.deb repo download directory is:\n\t$PackageDownloads ${STYLES_OFF}"
	read -e -p "Change download destination directory? [ y/N ]: " -i "N" yn
	case $yn in
		[Yy]* )
			prompt="Enter new directory name. [ $PackageDownloads ]: "
			read -e -p "$prompt" -i "$PackageDownloads" PackageDownloads
			echo -e "\n\tYou entered: $PackageDownloads\n"

			read -e -p "${$FG_YELLOW}Press ENTER to continue, or <Ctrl-C> to abort this script.${STYLES_OFF}"
			;;
	esac

	Dpkg_List=$PackageDownloads/Dpkg_List.txt
	Download_List=$PackageDownloads/Download_List.sh

	Contents_List=$PackageDownloads/Contents_List.txt
}

function Package_List {

	echo "$FG_GREEN "
	read -e -p "Make a list of installed Debian packages? [ Y/n ]: " -i "y" yn
	echo "$STYLES_OFF "

	case $yn in
		[Yy]* )
			mkdir -p $PackageDownloads

			## prevent warning: "Download is performed unsandboxed as root"
			#sudo chown -R _apt:root $PackageDownloads

			sleep 1

			## list installed package names and remove any occurrence of ":amd64"
			echo -e "${FG_CYAN}\tWriting $Dpkg_List ... $STYLES_OFF"
			dpkg -l | grep ^ii | awk '{print $2}' | cut -d: -f1 > $Dpkg_List

			## prepend "sudo apt download" on every line
			echo -e "${FG_CYAN}\tWriting $Download_List ... $STYLES_OFF"
			echo '#!/bin/bash' > $Download_List
			echo "" >> $Download_List
			sed 's/^/sudo apt download /g' $Dpkg_List >> $Download_List

			echo -e "\tDone making lists\n"
			;;
	esac
}

function Download_Debs {

	echo "$FG_GREEN "
	read -e -p "Download individual .debs from a generated package list? [ y/N ]: " -i "n" yn
	echo "$STYLES_OFF "

	case $yn in
		[Yy]* )
			mkdir -p $PackageDownloads

			## prevent warning: "Download is performed unsandboxed as root"
			#sudo chown -R _apt:root $PackageDownloads

			sleep 1
			cd $PackageDownloads

			sudo apt update

			bash $Download_List

			## render confirmation list
			ls *.deb > $Contents_List

			echo -e "\nDone.\n${FG_CYAN}\tMove/copy the $PackageDownloads directory to a USB, CD, or drive partition.\n $STYLES_OFF"
			;;
	esac
}

function MAIN {
	InitDirVariables
	About

	Package_List
	Download_Debs
}

## #############################################################################
## RUN
## #############################################################################

Tput_Colors
MAIN
