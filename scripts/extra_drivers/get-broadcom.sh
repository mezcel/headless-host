#!/bin/bash

##
## Use a wired lan to install broadcom wifi driver
## Used for potato erra broadcom wireless
##

function Step1 {
    lspci -nn | grep Network
}

function Step2 {
    sudo apt install -y dkms
    sudo apt install -y wireless-tools
    #sudo apt install -y network-manager-gnome
    #sudo apt install -y network-manager
    sudo apt install -y wpasupplicant
}

function Step3 {
    ##sudo vim /etc/apt/sources.list
    ##(main contrib non-free)
	
	echo "
#
## /etc/apt/sources.list 
#

deb http://ftp.us.debian.org/debian/ buster main contrib non-free
deb-src http://ftp.us.debian.org/debian/ buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

## buster-updates, previously known as 'volatile'
#deb http://ftp.us.debian.org/debian/ buster-updates main contrib non-free
#deb-src http://ftp.us.debian.org/debian/ buster-updates main contrib non-free
	" > ~/sources.list.tmp
	
	sudo cp /etc/apt/sources.list  /etc/apt/sources.list.backup.$(date +%d%b%Y_%H%M%S)
	
	sudo mv ~/sources.list.tmp /etc/apt/sources.list 
}

function Step4 {
    sudo apt-get update
    sudo apt-get dist-upgrade

    #reboot the computer
    echo -e "\n\nAfter wireless and other networking tools are installed, rebooting will help insure the system components know what it has and does not have."
    echo -e "\n\nDo you want to shutdown now or continue.?\n"

    read -e -p "Shutdown now? [ y/n ]: " -i "y" yn
    case $yn in
        [Yy]* )
            sudo shutdown now
            break
            ;;
        * )
            echo "Continuing install ..."
            ;;
    esac

}

function Step5 {
    sudo apt install -y linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,')

    sudo apt install -y linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')

    sudo apt install broadcom-sta-dkms
}

function Step6 {
    sudo modprobe -r b44 b43 b43legacy ssb brcmsmac bcma

    sudo modprobe wl
}

#####################

Step1
Step2
#Step3
Step4
Step5
Step6

read -e -p "Reboot now? [ y/n ]: " -i "y" yn
case $yn in
    [Yy]* )
        sudo restart
        break
        ;;
    * )
        echo -e "\nDone."
        ;;
esac