#!/bin/bash

## Win10 CMD
exePath=/mnt/c/Windows/System32/cmd.exe
taskKillPath=/mnt/c/Windows/System32/taskkill.exe

xset q &>/dev/null
if [ $? -eq 0  ]; then
    echo -e "\n(vcxsrv/XLaunch) is on.\n"
    read -e -p "Kill (vcxsrv/XLaunch) now? [y/n]: " -i "y" yn
    if [ $yn == "y" ]; then

        echo -e "\nKill my typical applications:"
        killall slstatus
        killall feh
        killall vim
        killall geany
        killall top
        killall htop
        tmux kill-server
        killall tmux
        killall pcmanfm
        killall firefox
        sleep 1s

        echo -e "\npstree:\n$(pstree)\nps:\n$(ps)\n"
        read -e -p "Kill a specific PID? [y/n]: " -i "n" yn
        if [ $yn == "y" ]; then
            echo -e "\npstree:"
            pstree
            echo -e "\nps:"
            ps
            #echo -e "\npidof bash:\n$(pidof bash)\n"
            read -p "Enter PID number ($$ is this script): " myPIDno
            kill pid $myPIDno
        fi
        ## Kill Win10 XLaunch
        $exePath $taskKillPath /f /im vcxsrv.exe
    fi
else
    echo -e "\n(vcxsrv/XLaunch) is off.\n"
    read -e -p "Launch (vcxsrv/XLaunch) now? [y/n]: " -i "y" yn
    if [ $yn == "y" ]; then

        if [ ! -f /mnt/c/Users/$(whoami)/XLaunch.lnk ]; then
            ##cd "/mnt/c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/VcXsrv/"
            ##cp XLaunch.lnk /mnt/c/Users/$(whoami)/
            xlaunchSource      = "/mnt/c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/VcXsrv/XLaunch.lnk"
            xlaunchDestination = "/mnt/c/Users/$(whoami)/"
            if [ -f $xlaunchSource ]; then
                cp $xlaunchSource $xlaunchDestination
            else
                echo -e "\n$xlaunchSource was not found. Try running the VcXsrv app, and a .lnk is generated by default.\nThen try to \"startx\" again. "
            fi
        fi
        sleep 1s

        ## launch Xlaunch
        read -e -p "launch DWM? [y/n]: " -i "y" ynDwm
        if [ -f /mnt/c/Users/$(whoami)/XLaunch.lnk ]; then
            $exePath /mnt/c/Users/$(whoami)/XLaunch.lnk
            echo -e "\nvcxsrv is running.\n\tYou can run Gtk apps and/or a desktop manager with it.\n"

            if [ -f ~/.Xresources ]; then
                xrdb -merge -I$HOME ~/.Xresources
            fi

            if [ $ynDwm == "y" ]; then
                exec slstatus &
                sleep .5s
                bash ~/.fehbg &
                sleep .5s
                exec dwm &
                xrdb -merge ~/.Xresources
            else
                echo -e "\tGtk apps will launch in their own dedicated windows.\n"
            fi

        else
            echo -e "\nCheck to see if vcxsrv/XLaunch is installed.\n\thttps://sourceforge.net/p/vcxsrv/wiki/Home/\n"
        fi
    fi
fi