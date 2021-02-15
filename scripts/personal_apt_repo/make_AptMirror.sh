#!/bin/bash

function Mirror_Location {

    localUsbRepo=/downloaded-debs/
    liveUsbRepo=/usr/lib/live/mount/medium/downloaded-debs/
    liveMxUsb=/home/demo/Live-usb-storage/downloaded-debs/

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
	if [ -f $mirrorPath ]; then
		bash $dlScript
	else
		echo -e "\n\t$dlScript does not exist"
		exit
	fi
}

function Make_Packages_Gz {

    ## Dependancy:
    ## The dpkg-dev package is required to run dpkg-scanpackages

	##cd $mirrorPath

    if [ -f $mirrorPath/Packages.gz ]; then
        sudo rm $mirrorPath/Packages.gz
        sleep 2s
    fi

	if [ ! -d $mirrorPath ] ; then
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

	echo -e "\nThe following qustions will be asked:"
	echo -e "\tMake a package list of existing packages?"
	echo -e "\tDownload debs for a new Mirror Repo?"
	echo -e "\tMake Packages.gz?"
	echo -e "\tUpdate local sources.list?"
	echo -e "\n"

	Mirror_Location

	echo "$FG_GREEN "
	read -e -p "Make a package list? [ Y/n ]: " -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_Download_Script
			;;
	esac

	echo "$FG_GREEN "
	read -e -p "Download debs for a new Mirror Repo? [ Y/n ]: " -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Download_Debs
			;;
	esac

	echo "$FG_GREEN "
	read -e -p "Make Packages.gz? [ Y/n ]: " -i "y" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_Packages_Gz
			;;
	esac

	echo "$FG_GREEN "
	read -e -p "Update local sources.list? [ y/N ]: " -i "n" yn
	echo "$STYLES_OFF "
	case $yn in
		[Yy]* )
			Make_SourcesMirror_List
			;;
	esac
}

function main {
	clear
	lsblk
	echo ""

	Mirror_Location
	LazyPrompt
}

main