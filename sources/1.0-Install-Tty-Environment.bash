#!/bin/bash

##
## 1.0-Install-Tty-Environment.sh
##

function Decorative_Formatting {
    ## Decorative tty colors
    function Tput_Colors {
        ## Foreground Color using ANSI escape provided though tput

        FG_BLACK=$(tput setaf 0)
        FG_RED=$(tput setaf 1)
        FG_GREEN=$(tput setaf 2)
        FG_YELLOW=$(tput setaf 3)
        FG_BLUE=$(tput setaf 4)
        FG_MAGENTA=$(tput setaf 5)
        FG_CYAN=$(tput setaf 6)
        FG_WHITE=$(tput setaf 7)
        FG_NoColor=$(tput sgr0)

        ## Background Color using ANSI escape provided though tput

        BG_BLACK=$(tput setab 0)
        BG_RED=$(tput setab 1)
        BG_GREEN=$(tput setab 2)
        BG_YELLOW=$(tput setab 3)
        BG_BLUE=$(tput setab 4)
        BG_MAGENTA=$(tput setab 5)
        BG_CYAN=$(tput setab 6)
        BG_WHITE=$(tput setab 7)
        BG_NoColor=$(tput sgr0)

        ## set mode using ANSI escape provided though tput

        MODE_BOLD=$(tput bold)
        MODE_DIM=$(tput dim)
        MODE_BEGIN_UNDERLINE=$(tput smul)
        MODE_EXIT_UNDERLINE=$(tput rmul)
        MODE_REVERSE=$(tput rev)
        MODE_ENTER_STANDOUT=$(tput smso)
        MODE_EXIT_STANDOUT=$(tput rmso)

        # clear styles using ANSI escape provided though tput

        STYLES_OFF=$(tput sgr0)
        FGBG_NoColor=$(tput sgr0)
    }

    function ttyCenter {
        str="$1"
        tputFgColor=$2
        width=80
        strLength=${#str}
        centerCol=$(( ( width/2 )-( strLength / 2 ) ))

        for (( i=0; i<=$centerCol; i++ ))
        do
           printf " "
        done
        printf "$MODE_BOLD$tputFgColor$str$STYLES_OFF\n"
    }

    function ttyHR {
        hrChar=$1
        tputFgColor=$2

        width=80
        for (( i=0; i<$width; i++ ))
        do
           printf "$tputFgColor$hrChar"
        done
        printf "$STYLES_OFF\n"
    }

    function ttyNestedString {
        str=$1
        tputFgColor=$2

        strArray=($str)
        lineArray=()

        strLength="${#str}"
        preString=" "
        ttyMaxCols=79

        charCount=0
        isFrstLine=1

        printf "$tputFgColor"
        for i in "${strArray[@]}"; do
            charCount=$(($charCount+${#i}+1))

            if [ $isFrstLine -ne 1 ]; then
                ttyMaxCols=79
                ttyMaxCols=$(($ttyMaxCols-4))
                preString="    "
            else
                preString=" "
            fi

            if [ $charCount -lt $ttyMaxCols ]; then
                ## append lineArray
                lineArray+=("$i")
            else
                echo "$preString${lineArray[*]}"

                isFrstLine=0
                lineArray=()
                lineArray+=("$i")
                charCount=${#i}
            fi
        done

        if [ $isFrstLine -ne 1 ]; then
            preString="    "
        else
            preString=" "
        fi

        printf "$preString${lineArray[*]}\n$STYLES_OFF"
    }

    function ttyCenteredHeader {
        str=$1
        borderChar=$2
        tputFgColor=$3

        ttyHR "$borderChar" "$tputFgColor"
        ttyCenter "$str" "$tputFgColor"
        ttyHR "$borderChar" "$tputFgColor"
    }

    function ttyHighlightRow {
        str=$1
        tputBgColor=$2

        width=79
        strLength=${#str}

        highlightLength=$(( $width-$strLength ))

        printf "$tputBgColor$FG_BLACK $str"
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor "
        done
        printf "$STYLES_OFF\n"
    }

    function ttyPromptInput {
        promptTitle=$1
        promptString=$2
        defaultAnswer=$3
        tputFgColor=$4
        tputBgColor=$5

        ttyHighlightRow "$promptTitle" "$tputBgColor"

        read -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        printf "$STYLES_OFF\n"
        sleep 1
    }
}

function Configure_Tty_Environment {
    function Set_User_Permission {
        me=$(whoami)

        if [ $me == "root" ]; then
            readInput=yes
            promptString="Give a user (sudo/sudoer) privilege? [ y/N ]: "
            ttyHighlightRow "Edit super user:" "$promptString" "$readInput" "$FG_YELLOW"

            case $yn in
                [Yy]* )
                    readInput=mezcel
                    promptString="Enter a user name? [ $readInput ]: "
                    ttyHighlightRow "Sudo User:" "$promptString" "$readInput" "$FG_GREEN"

                    sudo adduser $readInput sudo
                    sudo usermod -a -G sudo $readInput
                    ;;
            esac
        fi
    }

    function Install_Network_Drivers {
        ttyCenteredHeader "Network drivers" "-" "$FG_CYAN"
        sleep 2s

        sudo apt install -y linux-image-$(uname -r)
        sudo apt install -y linux-headers-$(uname -r)

        sudo apt install -y firmware-linux-free
        sudo apt install -y firmware-linux-nonfree
        sudo apt install -y firmware-iwlwifi

        ## Detect and/or Display the wireless driver Chipset

        lspci | grep "Broadcom" &>/dev/null
        isBroadcom=$?

        if [ $isBroadcom -eq 0 ]; then
            ttyCenteredHeader "Broadcom Wifi" "." "$FG_YELLOW"
            ttyNestedString "If you choose to install Broadcom drivers, the computer will restart after installation." "$FG_YELLOW"

            ## check if driver is already installed
            sudo dpkg-query --list broadcom-sta-dkms firmware-brcm80211 &>/dev/null

            yn=$?
            if [ $yn -eq 0 ]; then
                promptString="Install the brcm80211 Broadcom wifi drivers? [ y/N ]: "
                readInput=no
            else
                promptString="Install the brcm80211 Broadcom wifi drivers? [ Y/n ]: "
                readInput=yes
            fi

            ttyPromptInput "Broadcom wifi drivers:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

            case $readInput in
                [Yy]* )
                    sudo apt install -y firmware-brcm80211
                    sudo apt install -y broadcom-sta-dkms

                    ttyNestedString "I recommend restarting the computer now." "$FG_RED"
                    ttyNestedString "Note: You will need to run the installer again. On the next pass the option to install brcm80211 will be default to \"no\" for convenience." "$FG_RED"

                    promptString="Restart the computer now? [ Y/n ]: "
                    ttyPromptInput "Restart:" "$promptString" "yes" "$FG_GREEN" "$BG_GREEN"

                    case $readInput in
                        [Yy]* )
                            sudo reboot
                        ;;
                    esac
                    ;;
            esac

        fi
    }

    function Terminal_Applications {
        ttyCenteredHeader "Installing applications focused on terminal productivity" "-" "$FG_CYAN"
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

        ttyCenteredHeader "Autoremove network-manager" "." "$FG_CYAN"
        sudo apt remove -y network-manager
        sudo apt -y autoremove

        #ranger --copy-config=all
        #ranger --clean

        ## Vim cache
        mkdir -p ~/.backup/
        mkdir -p ~/.swp/
        mkdir -p ~/.undo/

        ttyCenteredHeader "Autoremove nano" "." "$FG_CYAN"
        sudo apt remove -y nano
        sudo apt purge -y nano
        sudo apt -y autoremove
    }

    function Setup_Git {
        sudo apt install -y git

        command -v git &>/dev/null

        if [ $? -eq 0 ]; then
            ttyCenteredHeader "Git Configuration: ~/.gitconfig" "-" "$FG_CYAN"

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

        ttyCenteredHeader "Audio" "-" "$FG_CYAN"

        #sudo dpkg-query --list alsa-utils pavucontrol
        command -v pulseaudio &>/dev/null
        isPulse=$?

        command -v alsamixer &>/dev/null
        isAlsa=$?

        if [ $isPulse -ne 0 ]; then
            promptString="Install Alsamixer with PulseAudio? [ Y/n ]: "
            readInput=yes
        elif [ $isAlsa -ne 0 ]; then
            promptString="Install Alsamixer with PulseAudio? [ Y/n ]: "
            readInput=yes
        else
            promptString="Install Alsamixer with PulseAudio? [ y/N ]: "
            readInput=no
        fi

        ttyPromptInput "Audio Drivers:" "$promptString" "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $promptString in
            [Yy]* )
                thisKernel=$(uname -r)
                echo $thisKernel | grep Microsoft &>/dev/null
                isMS=$?

                if [ $isMS -ne 0 ]; then
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
        ttyCenteredHeader "NERDTree" "." "$FG_YELLOW"
        sleep 1s

        if [ ! -d ~/.vim/pack/vendor/start/nerdtree ]; then
            ttyNestedString "Importing NERDTree ..." "$MODE_BOLD$FG_GREEN"
            if [ ! -d ./home/.vim/pack/vendor/start/nerdtree ]; then
                ttyNestedString "Cloning https://github.com/preservim/nerdtree.git ..." "$MODE_BOLD$FG_GREEN"
                sleep 1s
                git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
                sleep 2s
            elif [ -d ./home/.vim/pack/vendor/start/nerdtree ]; then
                mkdir -p ~/.vim/pack/vendor/start
                #sudo chmod -R 777 ./home/.vim/pack/vendor/start/nerdtree
                sleep 1s
                
                ttyNestedString "Copying ~/.vim/pack/vendor/start/nerdtree from headless-host.git repo  ..." "$MODE_BOLD$FG_GREEN"
                sleep 1s
                sudo cp -rf --no-preserve=mode ./home/.vim/pack/vendor/start/nerdtree ~/.vim/pack/vendor/start/
                sleep 1s
                sudo chmod -R 777 ~/.vim/pack/vendor/start/
                sleep 1s
            fi
        fi

        ## install vim nerdtree
        if [ -d ~/.vim/pack/vendor/start/nerdtree ]; then
            ttyNestedString "Importing NERDTree ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
            sleep 1s
        fi

        sleep 5s
    }

    function Home_Directory {
        ## Home Directory Configs
        ## This function assumes the script is running as source when launched from the headless-host root directory.
        ## I manually chmod 777 just in case files were transferred from somewhere secure before imported into user's root

        ttyCenteredHeader "Dot Files" "." "$FG_CYAN"
        ttyNestedString "Populating home Directory Configs ..." "$MODE_BOLD$FG_YELLOW"
        sleep 2s

        #sudo cp -rf --no-preserve=mode ./home/.config ~/
        ##sudo chmod 777 ~/.config
        mkdir -p ~/.config

        if [ -d ./home/.config/vifm ]; then
            ttyNestedString "Importing ~/.config/vifm ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo cp -rf --no-preserve=mode ./home/.config/vifm ~/.config/
            sleep 1s
            sudo chmod -R 777 ~/.config/vifm/*
        fi

        if [ -d ./home/Music ]; then
            ttyNestedString "Importing ~/Music ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo cp -rf --no-preserve=mode ./home/Music ~/
            sleep 1s
            sudo chmod -R 777 ~/Music/*
        fi

        if [ -d ./home/Images ]; then
            ttyNestedString "Importing ~/Images ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo cp -rf --no-preserve=mode ./home/Images ~/
            sleep 1s
            sudo chmod -R 777 ~/Images/*
        fi

        if [ -f ./home/.tmux.conf ]; then
            if [ -f ~/.tmux.conf ]; then
                ttyNestedString "Backing up ~/.tmux.conf ..." "$MODE_DIM$FG_YELLOW"
                sleep 1s
                cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%d%b%Y_%H%M%S)
                sleep 1s
            fi
            ttyNestedString "Importing ~/.tmux.conf ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp ./home/.tmux.conf ~/
            sleep 1s

            #sudo chmod 777 ~/.tmux.conf
            sudo dos2unix ~/.tmux.conf
        fi

        if [ -f ./home/.toprc ]; then
            if [ -f ~/.toprc ]; then
                ttyNestedString "Backing up ~/.toprc ..." "$MODE_DIM$FG_YELLOW"
                sleep 1s
                cp ~/.toprc ~/.toprc.backup.$(date +%d%b%Y_%H%M%S)
            fi
            ttyNestedString "Importing ~/.toprc ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp ./home/.toprc ~/
            sleep 1s

            #sudo chmod 777 ~/.toprc
            sudo dos2unix ~/.toprc
        fi

        if [ -f ./home/.vimrc ]; then
            if [ -f ~/.vimrc ]; then
                ttyNestedString "Backing up ~/.vimrc ..." "$MODE_DIM$FG_YELLOW"
                sleep 1s
                cp ~/.vimrc ~/.vimrc.backup.$(date +%d%b%Y_%H%M%S)
            fi
            ttyNestedString "Importing ~/.vimrc ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp ./home/.vimrc ~/
            sleep 1s

            #sudo chmod 777 ~/.vimrc
            sudo dos2unix ~/.vimrc
        fi

        if [ -d ./home/.vim ]; then
            if [ -d ~/.vim ]; then
                ttyNestedString "Backing up ~/.vim ..." "$MODE_DIM$FG_YELLOW"
                sleep 1s
                cp -rf --no-preserve=mode ~/.vim ~/.vim.backup.$(date +%d%b%Y_%H%M%S)
            fi
            ttyNestedString "Importing ~/.vim ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp -rf --no-preserve=mode ./home/.vim ~/
            sleep 1s

            sudo chmod -R 777 ~/.vim/*
            #sudo chmod 777 ~/.vim/colors/*
        fi

        if [ -d ./home/terminalsexy ]; then
            if [ -d ~/terminalsexy ]; then
                ttyNestedString "Backing up ~/terminalsexy ..." "$MODE_DIM$FG_YELLOW"
                sleep 1s
                sudo cp -rf --no-preserve=mode ~/terminalsexy ~/terminalsexy.backup.$(date +%d%b%Y_%H%M%S)
            fi
            ttyNestedString "Importing ~/terminalsexy ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp -rf --no-preserve=mode ./home/terminalsexy ~/
            sleep 1s
            #chmod 777 -R ~/terminalsexy/*
            #sudo chmod 777 ~/terminalsexy/Linux_Console/*
            #sudo chmod 777 ~/terminalsexy/st/*
            #sudo chmod 777 ~/terminalsexy/Xresources/*
        fi

        ## oh-my-bash
        if [ -d ./home/.oh-my-bash ]; then
            ttyNestedString "Importing ~/.oh-my-bash ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo cp -rf --no-preserve=mode ./home/.oh-my-bash ~/
            sleep 1s
            
            ttyNestedString "Importing ~/.oh-my-bash ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s
            sudo chmod -R 777 ~/.oh-my-bash
            sudo cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
        fi

        ## Home Directories
        mkdir -p ~/Downloads

        ## Vim cache
        mkdir -p ~/.backup/
        mkdir -p ~/.swp/
        mkdir -p ~/.undo/

        ttyNestedString "Finished Populating home Directory Configs." "$MODE_BOLD$FG_GREEN"
    }
}

## #############################################################################
## Configure TTY Environment
## #############################################################################

## Initialize

Decorative_Formatting
Tput_Colors
Configure_Tty_Environment

## RUN

ttyCenteredHeader "Install a TTY environment " "#" "$FG_MAGENTA"
sleep 2s

Terminal_Applications

Setup_Git
Terminal_Audio
Set_Nerdtree
Home_Directory
