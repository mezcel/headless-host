#!/bin/bash

## STEP 1
## PACKAGES
## Required Packages:
## Dependencies are installed during respin installation.
## Download respin or use git to clone the latest respin.
## Sourceforge: https://sourceforge.net/projects/respin/files/
## Gitlab:
## https://gitlab.com/remastersys/LinuxRespin
## Note: mkisofs deprecated – uses genisoimage instead

## STEP 2
## INSTALL PACKAGES
## Install dependencies/packages needed for respin (as root).
## Install git
## Install respin
## apt-get -y install git
## git clone https://gitlab.com/remastersys/LinuxRespin
## dpkg -i 4.0.0-2_all.deb

function InstallDependencies {
	apt install -y git
	apt install -y dialog
	apt install -y memtest86+
	apt install -y mkisofs
	apt install -y genisoimage
	apt install -y grub.pc
	apt install -y xorriso
	apt install -y syslinux
	apt install -y os-prober
	apt install -y squashfs-tools
	apt install -y live-config-sysvinit
	apt install -y cdfs
	apt install -y man-db
	
	apt --fix-broken install
	apt autoremove
}

function InstallLinuxRespin {
	if [ ! -d ~/Downloads/LinuxRespin ]; then
		git clone https://gitlab.com/remastersys/LinuxRespin ~/Downloads/LinuxRespin
	else
		cd ~/Downloads/LinuxRespin
		#dpkg -i 4.0.0-2_all.deb
		dpkg -i respin_4.0.0-2_all.deb
		#dpkg -i *4.0.0-2_all.deb
	fi
}

mkdir -p ~/Downloads/
cd ~/Downloads

apt update
apt --fix-broken install
apt autoremove

apt install -y build-essential vim tmux

InstallDependencies
InstallLinuxRespin

#respin dist iso mynewiso.iso
