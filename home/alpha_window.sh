#!/bin/bash

inputFlag=$1
thisFile=`basename $0`

echo "
#########################################
# Make a target Xorg window transparent #
#########################################
"

if [ -d /etc/pacman.d ]; then
	## Archlinux
	## Requires: transset-df and xcompmgr

	if [ ! -z $inputFlag ]; then
		if [ $inputFlag == "kill" ]; then
			if pgrep -x "xcompmgr" &>/dev/null
			then
				echo "killall xcompmgr"
				killall xcompmgr
			fi
			echo "window transparency is off"
		else
			echo "\n!!! Bad input !!! Use \"kill\" of leave blank.\n"
		fi
	else
		if ! pgrep -x "xcompmgr" &>/dev/null
		then
			echo "xcompmgr -c"
			xcompmgr -c &
			echo ""
		fi

		echo -e "Click on a target window to toggle its Alpha property.\n"
		transset-df
		sleep 2s

		echo -e "\nTo kill all alpha/compositor processes:\n\tbash $(pwd)/$thisFile \"kill\".\n"
	fi
fi
