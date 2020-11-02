#!/bin/bash

##
## 1.0-Install-Tty-Environment.sh
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

    ## clear styles using ANSI escape

    STYLES_OFF=$(tput sgr0)
    FGBG_NoColor=$(tput sgr0)
}

function Set_User_Permission {
    me=$(whoami)

    if [ $me == "root" ]; then
        echo ""
        promptString="${FG_GREEN}Give a user (sudo/sudoer) privilege? [ y/N ]:${FGBG_NoColor} "
        read -e -p "$promptString" -i "no"  yn
        echo ""

        case $yn in
            [Yy]* )
                echo ""
                read -e -p "Enter a user name: " -i "mezcel" myname
                echo ""
                sudo adduser $myname sudo
                sudo usermod -a -G sudo $myname
                ;;
        esac
    fi
}

function Install_Network_Drivers {
    sudo apt install -y linux-image-$(uname -r)
    sudo apt install -y linux-headers-$(uname -r)

    sudo apt install -y firmware-linux-free
    sudo apt install -y firmware-linux-nonfree
    sudo apt install -y firmware-iwlwifi

    ## Detect and/or Display the wireless driver Chipset

    lspci | grep "Broadcom" &>/dev/null
    isBroadcom=$?

    if [ $isBroadcom -eq 0 ]; then
        echo -e "${BG_CYAN}${FG_BLACK}\nBroadcom Wifi Driver: ${STYLES_OFF}\n"
        echo -e "${FG_CYAN}\tIf you choose to install Broadcom drivers, the computer will restart after installation."
        echo -e "${STYLES_OFF}"

        ## check if driver is already installed
        sudo dpkg-query --list broadcom-sta-dkms firmware-brcm80211 &>/dev/null

        yn=$?
        if [ $yn -eq 0 ]; then
            promptString="Install the brcm80211 Broadcom wifi drivers? [ y/N ]: "
            yn=no
        else
            promptString="Install the brcm80211 Broadcom wifi drivers? [ Y/n ]: "
            yn=yes
        fi

        read -e -p "$promptString" -i "$yn" yn
        echo ""

        case $yn in
            [Yy]* )
                sudo apt install -y firmware-brcm80211
                sudo apt install -y broadcom-sta-dkms

                echo -e "$FG_YELLOW"
                echo -e "\nI recommend restarting the computer now. \
                \n\tNote: You will need to run the installer again. \
                \n\tOn the next pass the option to install brcm80211 will be default to \"no\" for convenience.\n"
                echo -e "${STYLES_OFF}"

                promptString="Restart the computer now? [ Y/n ]: "
                sleep 2s
                ynRestart=yes
                read -e -p "$promptString" -i "$ynRestart" ynRestart
                echo ""
                case $yn in
                    [Yy]* )
                        sudo reboot
                    ;;
                esac
                ;;
        esac

    fi
}

function Terminal_Applications {

    echo -e "$FG_CYAN\n\tInstalling applications focused on terminal productivity ...\n $FGBG_NoColor"
    sleep 2s

    sudo apt update
    sudo apt --fix-broken install
    sudo apt update

    ## Network drivers
    Install_Network_Drivers

    sudo apt install -y resolvconf

    sudo apt install -y build-essential
    sudo apt install -y debianutils
    sudo apt install -y util-linux

    sudo apt install -y bash
    sudo apt install -y bash-completion
    sudo apt install -y vim
    sudo apt install -y tmux
    sudo apt install -y ranger
    sudo apt install -y vifm
    sudo apt install -y htop
    sudo apt install -y aspell
    sudo apt install -y wget
    sudo apt install -y curl
    sudo apt install -y elinks
    sudo apt install -y bc
    sudo apt install -y dos2unix
    sudo apt install -y unzip
    sudo apt install -y dialog
    sudo apt install -y highlight

    sudo apt install -y udiskie

    sudo apt install -y fonts-ubuntu-family-console
    sudo apt install -y ttf-ubuntu-font-family
    sudo apt install -y fonts-inconsolata

    sudo apt install -y pandoc

    #sudo apt install -y git
    sudo apt install -y tlp
    echo -e "\n\n"
    sudo apt remove -y network-manager
    sudo apt -y autoremove

    #ranger --copy-config=all
    #ranger --clean

    ## Vim cache
    mkdir -p ~/.backup/
    mkdir -p ~/.swp/
    mkdir -p ~/.undo/

    echo -e "\n\n"
    sudo apt remove -y nano
    sudo apt purge -y nano
    sudo apt -y autoremove
}

function Setup_Git {
    sudo apt install -y git

    command -v git &>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "$BG_CYAN${FG_BLACK}\nConfigure Git for Github:$FGBG_NoColor${FG_CYAN}\n"

        ## Set ~/.gitconfig
        if [ ! -f ~/.gitconfig ]; then
            githubusername=$(whoami)
            promptString="${STYLES_OFF}${FG_CYAN}Enter your github user.name [ ${FG_GREEN}$githubusername${FG_CYAN} ]: ${STYLES_OFF}"

            read -e -p "$promptString" -i "$githubusername" githubusername

            githubuseremail=$githubusername@hotmail.com
            promptString="${STYLES_OFF}${FG_CYAN}Enter github user.email [ ${FG_GREEN}$githubuseremail${FG_CYAN} ]: ${STYLES_OFF}"

            read -e -p "$promptString" -i "$githubuseremail" githubuseremail

            git config --global user.name $githubusername
            git config --global user.email $githubuseremail
        else
            githubusername=$(cat ~/.gitconfig | grep "name" | awk '{print $3}')
            githubuseremail=$(cat ~/.gitconfig | grep "email" | awk '{print $3}')

            echo -e "${FG_MAGENTA}Existing Git User: \
            \n\tgit config --global user.name ${FG_CYAN}$githubusername \
            \n\t${FG_MAGENTA}git config --global user.email ${FG_CYAN}$githubuseremail $STYLES_OFF\n"

            read -p "Press ENTER key to continue ... " pauseEnter
        fi

    fi
}

function Terminal_Audio {

    #sudo dpkg-query --list alsa-utils pavucontrol
    command -v pulseaudio &>/dev/null
    isPulse=$?

    command -v alsamixer &>/dev/null
    isAlsa=$?

    if [ $isPulse -ne 0 ]; then
        promptString="${BG_GREEN}${FG_BLACK}Install Alsamixer with PulseAudio? [ Y/n ]$FGBG_NoColor: "
        yn=yes
    elif [ $isAlsa -ne 0 ]; then
        promptString="${BG_GREEN}${FG_BLACK}Install Alsamixer with PulseAudio? [ Y/n ]$FGBG_NoColor: "
        yn=yes
    else
        promptString="${BG_YELLOW}${FG_BLACK}Install Alsamixer with PulseAudio? [ y/N ]$FGBG_NoColor: "
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
                sudo apt install -y vorbis-tools
                sudo apt install -y mplayer
                #sudo apt install -y vlc
                ## play protected dvd movies
                #sudo apt install -y libdvd-pkg
                #sudo dpkg-reconfigure libdvd-pkg

                sleep 2s
            fi
            ;;
    esac
}

function Set_Nerdtree {

    if [ ! -d ~/.vim/pack/vendor/start/nerdtree ]; then
        if [ ! -d ./home/.vim/pack/vendor/start/nerdtree ]; then
            git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
            sleep 1s
        elif [ -d ./home/.vim/pack/vendor/start/nerdtree ]; then
            sudo mkdir -p ~/.vim/pack/vendor/start
            sudo chmod -R 777 ./home/.vim/pack/vendor/start/nerdtree
            sudo cp -rf ./home/.vim/pack/vendor/start/nerdtree ~/.vim/pack/vendor/start/
            sleep 1s
        fi
    fi

    ## install vim nerdtree
    if [ -d ~/.vim/pack/vendor/start/nerdtree ]; then
        sudo vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
    fi

}

function Home_Directory {
    ## Home Directory Configs
    ## This function assumes the script is running as source when launched from the headless-host root directory.
    ## I manually chmod 777 just in case files were transferred from somewhere secure before imported into user's root

    echo -e "$FG_CYAN\n\tPopulating home Directory Configs ...\n $FGBG_NoColor"
    sleep 2s

    #sudo cp -rf ./home/.config ~/
    #sudo chmod 777 ~/.config
    mkdir -p ~/.config
    sudo cp -rf ./home/.config/vifm ~/.config/
    sudo chmod -R 777 ~/.config/vifm/*

    sudo cp -rf ./home/Music ~/
    sudo chmod -R 777 ~/Music/*

    sudo cp -rf ./home/Images ~/
    sudo chmod -R 777 ~/Images/*

    if [ -f ~/.tmux.conf ]; then
        cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%d%b%Y_%H%M%S)
    fi
    sudo cp ./home/.tmux.conf ~/
    sudo chmod 777 ~/.tmux.conf
    sudo dos2unix ~/.tmux.conf

    if [ -f ~/.toprc ]; then
        cp ~/.toprc ~/.toprc.backup.$(date +%d%b%Y_%H%M%S)
    fi
    sudo cp ./home/.toprc ~/
    sudo chmod 777 ~/.toprc
    sudo dos2unix ~/.toprc

    if [ -f ~/.vimrc ]; then
        cp ~/.vimrc ~/.vimrc.backup.$(date +%d%b%Y_%H%M%S)
    fi
    sudo cp ./home/.vimrc ~/
    sudo chmod 777 ~/.vimrc
    sudo dos2unix ~/.vimrc

    if [ -d ~/.vim ]; then
        cp -rf ~/.vim ~/.vim.backup.$(date +%d%b%Y_%H%M%S)
    fi
    sudo cp -rf ./home/.vim ~/
    sudo chmod -R 777 ~/.vim/*
    sudo chmod 777 ~/.vim/colors/*

    if [ -d ~/terminalsexy ]; then
        sudo cp -rf ~/terminalsexy ~/terminalsexy.backup.$(date +%d%b%Y_%H%M%S)
    fi
    sudo cp -rf ./home/terminalsexy ~/
    #chmod 777 -R ~/terminalsexy/*
    sudo chmod 777 ~/terminalsexy/Linux_Console/*
    sudo chmod 777 ~/terminalsexy/st/*
    sudo chmod 777 ~/terminalsexy/Xresources/*

    sudo chmod +x ./my_iwconfig.sh
    sudo chmod +x ./install.sh
    sudo chmod +x ./home/dl-my-repos.sh

    ## oh-my-bash
    if [ -d ./home/.oh-my-bash ]; then
        sudo cp -rf ./home/.oh-my-bash ~/
        sudo chmod -R 777 ~/.oh-my-bash
        sudo cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
    fi

    ## Home Directories

    mkdir -p ~/Downloads

    ## Vim cache
    mkdir -p ~/.backup/
    mkdir -p ~/.swp/
    mkdir -p ~/.undo/

}

## ##########################
## Run
## ##########################

Tput_Colors

echo ""
titleColors=${BG_MAGENTA}${FG_WHITE}
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo "${titleColors}## Install a TTY environment                                                                       ##$STYLES_OFF"
echo "${titleColors}## ##################################################################################################$STYLES_OFF"
echo ""
sleep 1s

Terminal_Applications

Setup_Git
Terminal_Audio
Home_Directory
Set_Nerdtree
