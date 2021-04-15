#!/bin/bash

## https://cygwin.com/packages/

## apt-cyg
## terminal package manager

function install_apt_cyg {
	if [ ! -f ~/apt-cyg ]; then
		wget -O ~/apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
	fi

	if [ -f ~/apt-cyg ]; then
		chmod +x ~/apt-cyg
	fi
}


function install_packages {
	## gcc-core
	apt-cyg install bash 
	apt-cyg install binutils 
	apt-cyg install cygwin 
	apt-cyg install cygwin-devel 
	apt-cyg install libatomic1 
	apt-cyg install libgcc1 
	apt-cyg install libgmp10 
	apt-cyg install libgomp1 
	apt-cyg install libiconv2 
	apt-cyg install libintl8 
	apt-cyg install libisl22 
	apt-cyg install libmpc3 
	apt-cyg install libmpfr6 
	apt-cyg install libquadmath0 
	apt-cyg install libzstd1 
	apt-cyg install w32api-headers 
	apt-cyg install w32api-runtime 
	apt-cyg install windows-default-manifest 
	apt-cyg install zlib0

	## apps
	apt-cyg install dos2unix 
	apt-cyg install vim 
	apt-cyg install wget 
	apt-cyg install git
	apt-cyg install tmux

	## python
	#apt-cyg install python
	apt-cyg install python-pip 
	apt-cyg install python3 
	apt-cyg install python3-pip

	## Misc
	apt-cyg install libjson-c-devel
	apt-cyg install libjson-devel
	apt-cyg install libjson-c2
}

install_apt_cyg 
install_packages 

