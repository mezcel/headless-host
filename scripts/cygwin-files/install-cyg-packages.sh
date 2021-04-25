#!/bin/bash

## https://cygwin.com/packages/
## https://cygwin.com/setup-x86_64.exe
## https://mirrors.kernel.org

## list installed packages
cygcheck -c

## Wget must be installed 

function install_apt_cyg {
	## apt-cyg
	## terminal package manager

	if [ ! -f ~/apt-cyg ]; then
	
		command -v wget
		
		if [ $? -ne 0 ]; then
			echo -e "\n# wget is not installed to download https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg\n"
			exit
		else
			wget -O ~/apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
		fi
		
		sleep 1s
	fi

	if [ -f ~/apt-cyg ]; then
		chmod +x ~/apt-cyg
		sleep 1s
	fi
}

function AptCyg {
	packageName=$1
	bash ~/apt-cyg install $packageName
	sleep 2s
	
}

function install_packages {

	AptCyg gcc-core
	AptCyg automake
	AptCyg bash 
	AptCyg binutils 
	AptCyg cygwin 
	AptCyg cygwin-devel 
	AptCyg libatomic1 
	AptCyg libgcc1 
	AptCyg libgmp10 
	AptCyg libgomp1 
	AptCyg libiconv2 
	AptCyg libintl8 
	AptCyg libisl22 
	AptCyg libmpc3 
	AptCyg libmpfr6 
	AptCyg libquadmath0 
	AptCyg libzstd1 
	AptCyg w32api-headers 
	AptCyg w32api-runtime 
	AptCyg windows-default-manifest 
	AptCyg zlib0
	AptCyg unzip
	AptCyg zip
	
	AptCyg cygutils-extra
	AptCyg cygwin-debuginfo

	## apps
	AptCyg dos2unix
	AptCyg wget 
	AptCyg git
	AptCyg tmux
	AptCyg highlight-common
	AptCyg aspell
	AptCyg vim
	AptCyg vim-clang-format
	AptCyg vim-cmake
	AptCyg vim-common
	AptCyg vim-debuginfo
	AptCyg vim-doc
	AptCyg vim-minimal

	## python
	#apt-cyg install python
	AptCyg python-pip 
	AptCyg python3 
	AptCyg python3-pip
	
	AptCyg mc
	
	## vifm depends
	## https://wiki.vifm.info/index.php/Obtaining_Vifm#Cygwin
	## There are no prebuild Cygwin packages for Vifm, so one needs to build it from sources.
	AptCyg make
	AptCyg gcc-core
	AptCyg ncurses
	AptCyg libncurses-devel
	AptCyg ncurses-debuginfo
	AptCyg libncurses++w10
	AptCyg libncursesw10
	AptCyg mingw64-x86_64-ncurses
	
	#mkdir -p ~/Downloads/
	#wget -O ~/Downloads/vifm-0.11.tar.bz2 http://prdownloads.sourceforge.net/vifm/vifm-0.11.tar.bz2?download
	
	#git clone https://github.com/vifm/vifm.git ~/Downloads/vifm.git
	#rm -rf ~/.config/vifm/colors
	#git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
	
	##./configure --sysconfdir=/etc
	##make
	##make install
	
	## printf-time.git depends
	AptCyg libjson-c-devel
	AptCyg libjson-devel
	AptCyg libjson-c2
	
	AptCyg json-c-debuginfo
	
	## MinGw Extras
	AptCyg mingw64-x86_64-binutils
	AptCyg mingw64-x86_64-freetype2
	AptCyg mingw64-x86_64-gcc-core
	AptCyg mingw64-x86_64-gcc-debuginfo
	AptCyg mingw64-x86_64-gcc-g++
	AptCyg mingw64-x86_64-gcc-objc
	
}

command -v wget
isWget=$?

if [ $isWget -eq 0 ]; then
	install_apt_cyg 
	install_packages 
	
	## list installed packages
	cygcheck -c
else
	echo -e "\nWget, which is not installed, is required to use this script.\n"
fi


