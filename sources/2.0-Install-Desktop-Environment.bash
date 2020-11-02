#!/bin/bash

##
## 2.0-Install-Desktop-Environment.sh
##

## Decorative tty colors
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

    # clear styles using ANSI escape

    STYLES_OFF=$(tput sgr0)
    FGBG_NoColor=$(tput sgr0)
}

function Install_DWM {

    echo -e "$FG_CYAN\n\tInstalling DWM ...\n $FGBG_NoColor"
    sleep 2s

    ## variable used to cd back to the directory
    thisScriptPath=$(pwd)

    cd ~/suckless/st
    sudo make clean install && cd ~/suckless/dmenu
    sudo make clean install && cd ~/suckless/dwm
    sudo make clean install && cd $thisScriptPath
    sleep 5s
}

function Suckless_Patches {

    echo -e "$FG_CYAN\n\tInstalling suckless dependencies...\n $FGBG_NoColor"
    sleep 2s

    sudo apt update
    sudo apt --fix-broken install
    sudo apt update

    sudo apt install -y build-essential
    sudo apt install -y git

    ## If Not WLS
    if [ $(uname -r | grep Microsoft &> /dev/null; echo $?) -ne 0 ]; then
        sudo apt install -y xorg
        sudo apt install -y xinit
        sudo apt install -y arandr
    fi

    ## dwm requirements
    sudo apt install -y libx11-dev
    sudo apt install -y libxft-dev
    sudo apt install -y libxinerama-dev
    sudo apt install -y xclip
    sudo apt install -y xvkbd
    sudo apt install -y libgcr-3-dev
    sudo apt install -y suckless-tools

    sudo cp -rf ./suckless ~/
    sudo chmod -R 777 ~/suckless/*
    #sudo cp -rf ./home/terminalsexy ~/

    ## Original DWM Source
    #git clone git://git.suckless.org/dwm ~/suckless/factory-default/dwm
    #git clone git://git.suckless.org/st ~/suckless/factory-default/st
    #git clone https://git.suckless.org/slstatus ~/suckless/factory-default/slstatus

    echo -e "feh --bg-fill ~/.config/openbox/wcrr.png \n" > ~/.fehbg

    if [ -f ~/.xinitrc ]; then
        cp ~/.xinitrc ~/.xinitrc.backup.$(date +%d%b%Y_%H%M%S)
    fi

    echo -e "bash ~/.fehbg &\nexec ~/suckless/dwm/dwm" > ~/.xinitrc
    echo -e "bash ~/.fehbg & \nexec ~/suckless/dwm/dwm" > ~/.xinitrc_dwm
    echo "exec openbox-session" > ~/.xinitrc_openbox

    ## Build DWM
    Install_DWM
}

function Optional_Openbox {
    sudo apt install -y openbox
    sudo apt install -y tint2
    sudo apt install -y conky
}

function Desktop_Applications {

    echo -e "$FG_CYAN\n\tInstalling gtk and other desktop environment tools...\n $FGBG_NoColor"
    sleep 2s

    ## Xorg DE apps

    sudo apt update
    sudo apt --fix-broken install
    sudo apt update

    sudo apt install -y build-essential

    sudo apt install -y libvte-dev
    sudo apt install -y geany
    sudo apt install -y geany-plugins
    sudo apt install -y mousepad
    sudo apt install -y zathura

    sudo apt install -y pcmanfm
    sudo apt install -y libfm-tools
    sudo apt install -y libusbmuxd-tools
    sudo apt install -y udiskie
    sudo apt install -y xarchiver
    sudo apt install -y gvfs
    sudo apt install -y tumbler
    sudo apt install -y ffmpegthumbnailer

    ## Openbox backup
    sudo apt install -y xterm
    sudo apt install -y openbox
    sudo apt install -y tint2
    sudo apt install -y conky
    sudo apt install -y feh

    sudo apt install -y gparted

    ## light weight screensaver
    # sudo apt install xfishtank

    ## If Not WLS
    if [ $(uname -r | grep Microsoft &> /dev/null; echo $?) -ne 0 ]; then
        sudo apt install -y iceweasel
        sudo apt install -y firefox-esr
    fi

    sudo apt install -y gimp
}

function Home_Directory {
    ## Home Directory Configs
    ## This function assumes the script is running as source when launched from the headless-host root directory.

    echo -e "${BG_MAGENTA}$FG_BLACK\n\tPopulating home Directory Configs and dot files ...\n $FGBG_NoColor"
    sleep 2s

    sudo cp -rf ./home/.config ~/
    #sudo chmod -R 777 ~/.config/*
    sudo chmod 777 ~/.config/geany/geany.conf
    sudo chmod 777 ~/.config/gtk-2.0/*
    sudo chmod 777 ~/.config/gtk-3.0/*
    sudo chmod 777 ~/.config/openbox/*
    sudo chmod 777 ~/.config/tint2/*

    if [ -f ~/.bashrc ]; then
        if [ -f ~/terminalsexy/Xresources/myNord.light ]; then
            cp ~/terminalsexy/Xresources/myNord.light ~/.Xresources
            echo '' >> ~/.bashrc
            echo '## xterm color scheme ' >> ~/.bashrc
            echo 'pgrep -x Xorg &>/dev/null ' >> ~/.bashrc
            echo 'isXorg=$?' >> ~/.bashrc
            echo 'if [ $isXorg -eq 0 ]; then' >> ~/.bashrc
            echo -e "\txrdb -merge ~/.Xresources" >> ~/.bashrc
            echo 'fi' >> ~/.bashrc
            echo '' >> ~/.bashrc
        fi
    fi

    sudo chmod +x ./my_iwconfig.sh
    sudo chmod +x ./install.sh
    sudo chmod +x ./home/dl-my-repos.sh

    mkdir -p ~/Downloads

    ## Vim cache
    mkdir -p ~/.backup/
    mkdir -p ~/.swp/
    mkdir -p ~/.undo/
}

function Desktop_Audio {

    #sudo dpkg-query --list alsa-utils pavucontrol vlc libdvd-pkg libdvd-pkg
    command -v pulseaudio &>/dev/null
    isPulse=$?

    command -v alsamixer &>/dev/null
    isAlsa=$?

    command -v vlc &>/dev/null
    isVlc=$?

    if [ $isPulse -ne 0 ]; then
        promptString="${BG_GREEN}${FG_BLACK}Install VLC Media Player and its dependencies? [ Y/n ]$FGBG_NoColor: "
        yn=yes
    elif [ $isAlsa -ne 0 ]; then
        promptString="${BG_GREEN}${FG_BLACK}Install VLC Media Player and its dependencies? [ Y/n ]$FGBG_NoColor: "
        yn=yes
    elif [ $isVlc -ne 0 ]; then
        promptString="${BG_GREEN}${FG_BLACK}Install VLC Media Player and its dependencies? [ Y/n ]$FGBG_NoColor: "
        yn=yes
    else
        promptString="${BG_YELLOW}${FG_BLACK}Install VLC Media Player and its dependencies? [ y/N ]$FGBG_NoColor: "
        yn=no
    fi

    echo ""
    read -e -p "$promptString" -i "$yn" yn
    echo ""

    case $yn in
        [Yy]* )
            if [ $(uname -r | grep Microsoft &> /dev/null; echo $?) -ne 0 ]; then
                ## Debian 10.5 live iso comes with audio driver stuff. Or maybe it is just bundled in the package now.

                sudo apt install -y alsa-utils
                sudo apt install -y pavucontrol
                #sudo apt install -y mplayer
                sudo apt install -y vlc
                ## play protected dvd movies
                sudo apt install -y libdvd-pkg
                sudo dpkg-reconfigure libdvd-pkg
            fi

            sleep 2s
            ;;
    esac
}

Tput_Colors

echo ""
titleColors=${BG_MAGENTA}${FG_WHITE}
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo "${titleColors}## Desktop Environment                                                                             ##$STYLES_OFF"
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo ""
sleep 1s

Desktop_Applications
Optional_Openbox
Home_Directory
Desktop_Audio

Suckless_Patches
