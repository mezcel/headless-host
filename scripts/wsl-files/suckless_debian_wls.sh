#!/bin/bash

## For use with Debian WLS
## I prefer the (Suckless) Dynamic Windows Manager

thisDir=$(pwd)

function tput_color_variables {
    FG_RED=$(tput setaf 1)
    FG_GREEN=$(tput setaf 2)
    FG_YELLOW=$(tput setaf 3)
    FG_BLUE=$(tput setaf 4)
    FG_MAGENTA=$(tput setaf 5)
    FG_CYAN=$(tput setaf 6)
    BG_NoColor=$(tput sgr0)
}

function github_themes {

    ## My DWM & GTK & CLI theme
    git clone https://github.com/mezcel/nordic-respin.git ~/github/mezcel/nordic-respin
    #bash ~/github/mezcel/nordic-respin/install.sh

    ## additional gtk color themes
    mkdir -p ~/.themes
    git clone https://github.com/EliverLara/Nordic.git ~/.themes/Nordic

    ## extra Nano styles
    git clone https://github.com/scopatz/nanorc.git ~/github/scopatz/nanorc
    mkdir -p ~/.config/nano/
    sleep 2s
    echo "include ~/github/scopatz/nanorc/*.nanorc" >> ~/.config/nano/nanorc

    ## icon theme
    git clone https://github.com/Bonandry/adwaita-plus.git ~/github/Bonandry/adwaita-plus
    sleep 2s
    cd ~/github/Bonandry/adwaita-plus/
    ./install.sh
}

function setup_git {
    FG_RED=$(tput setaf 1)
    FG_GREEN=$(tput setaf 2)
    FG_NoColor=$(tput sgr0)

    echo "$FG_GREEN"
    echo -e "Enter your Github user profile.\n\tYou need this in order to push changes to Github\n\n"
    echo "# git config --global user.name"
    read -p "github user name: " githubusername
    echo ""
    echo "# git config --global user.email"
    read -p "github user email: " githubuseremail

    echo "---"
    git config --global user.name $githubusername
    git config --global user.email $githubuseremail

    echo "Done. $FG_NoColor"
}

function debian_desktop_apt {
    sudo apt update
    sudo apt install -y build-essential
    sudo apt install -y man
    sudo apt install -y gcc
    sudo apt install -y gdb
    sudo apt install -y git
    sudo apt install -y wget
    sudo apt install -y sed
    sudo apt install -y perl
    sudo apt install -y ruby
    sudo apt install -y curl
    sudo apt install -y elinks
    sudo apt install -y w3m
    sudo apt install -y tmux
    sudo apt install -y vim

    sudo apt install -y libx11-dev
    sudo apt install -y libxft-dev
    sudo apt install -y libxinerama-dev
    sudo apt install -y xclip
    sudo apt install -y xvkbd
    sudo apt install -y libgcr-3-dev
    sudo apt install -y suckless-tools
    sudo apt install -y dmenu
    sudo apt install -y st
    sudo apt install -y dwm

    sudo apt install -y rofi
    sudo apt install -y xterm
    sudo apt install -y geany
    sudo apt install -y geany-plugins
    sudo apt install -y fonts-inconsolata
    sudo apt install -y ttf-liberation
    sudo apt install -y psmisc
    sudo apt install -y pcmanfm
    sudo apt install -y xarchiver
    sudo apt install -y gvfs
    sudo apt install -y tumbler
    sudo apt install -y ffmpegthumbnailer
    sudo apt install -y evince
    sudo apt install -y udiskie
    sudo apt install -y lxappearance
    sudo apt install -y arc-theme
    sudo apt install -y python-all-dev
    sudo apt install -y python-pip
    sudo apt install -y python-gtkspellcheck
    sudo apt install -y python-gtkspellcheck-doc
    sudo apt install -y python3-gtkspellcheck
    sudo apt install -y python3-pip

    sudo apt install -y pandoc
    sudo apt install -y aspell
    sudo apt install -y tree
    sudo apt install -y htop
    sudo apt install -y feh

    sudo apt install -y man-db

    echo -e "\n${FG_MAGENTA}Finished installing apt packages${BG_NoColor}\n"
    sleep 2s
}

function my_home {
    if [ -f ~/.bashrc ]; then
        ## backup existing .bashrc
        cp ~/.bashrc ~/.bashrc.backup.$(date +%d%b%Y_%H%M%S)
    fi

    ## Append ~/.bashrc
    echo "" >> ~/.bashrc
    echo "#" >> ~/.bashrc
    echo "# My Appended Script" >> ~/.bashrc
    echo "#" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo '## Vim as my default terminal text editor and viewer' >> ~/.bashrc
    echo 'VISUAL=vim' >> ~/.bashrc
    echo 'export VISUAL EDITOR=vim' >> ~/.bashrc
    echo 'export EDITOR' >> ~/.bashrc
    echo '## remove folder highlighting in tty' >> ~/.bashrc
    echo 'LS_COLORS=$LS_COLORS:"ow=1;34:"; export LS_COLORS' >> ~/.bashrc
    echo '####################################################' >> ~/.bashrc
    echo '##  Launch GUI apps from WLS terminal in XLaunch  ##' >> ~/.bashrc
    echo '####################################################' >> ~/.bashrc
    echo 'pgrep -x dwm &>/dev/null' >> ~/.bashrc
    echo 'if [ $? -eq 0 ]; then' >> ~/.bashrc
    echo '  ## Xorg is running with DWM running' >> ~/.bashrc
    echo "  bash ~/welcome_message.sh" >> ~/.bashrc
    echo 'else' >> ~/.bashrc
    echo '  ## Xorg is not running' >> ~/.bashrc
    echo '  if [ ! -d /mnt/c/Program\ Files/VcXsrv ]; then' >> ~/.bashrc
    echo '      echo "VcXsrv (XLaunch) was not detected in the default installation directory."' >> ~/.bashrc
    echo '      echo -e "\tDefault Installation Dir: \"C:\\Program\\ Files\\VcXsvr\\ "' >> ~/.bashrc
    echo '      echo -e "\tAbout Wiki: https://sourceforge.net/p/vcxsrv/wiki/Home/ "' >> ~/.bashrc
    echo '  else' >> ~/.bashrc
    echo '      echo "Xlaunch is installed."' >> ~/.bashrc
    echo '  fi' >> ~/.bashrc
    echo '  # Is the Win10 Debian terminal running' >> ~/.bashrc
    echo '  if [[ $(tty) == /dev/tty* ]] ; then' >> ~/.bashrc
    echo '        # Set Xorg display path' >> ~/.bashrc
    echo '      export DISPLAY=:0.0' >> ~/.bashrc
    echo '      echo "Win10 WLS Debian Salsa terminal is running."' >> ~/.bashrc
    echo '      # Is Xorg running' >> ~/.bashrc
    echo '      xset q &>/dev/null' >> ~/.bashrc
    echo '      if [ $? -eq 0  ]; then' >> ~/.bashrc
    echo '          exec slstatus &' >> ~/.bashrc
    echo '          #wallpaperFile=~/Pictures/wallpapers/gnome-frost.png' >> ~/.bashrc
    echo '          #feh --bg-fill $wallpaperFile &' >> ~/.bashrc
    echo '          exec dwm &' >> ~/.bashrc
    echo '          if [ -d ~/terminalsexy/Xresources ]; then' >> ~/.bashrc
    echo '              xrdb ~/terminalsexy/Xresources/myNord.light' >> ~/.bashrc
    echo '          fi' >> ~/.bashrc
    echo '      echo -e "This terminal launched DWM on a Win10 Xorg\n!!! Closing this terminal will terminate DWM from outside of DWM !!!" ' >> ~/.bashrc
    echo '      else' >> ~/.bashrc
    echo '          echo "Xorg is off."' >> ~/.bashrc
    echo '      fi' >> ~/.bashrc
    echo '  fi' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc

    ## Copy over my dot config files

    mkdir -p ~/Downloads/
    mkdir -p ~/.backup/
    mkdir -p ~/.swp/
    mkdir -p ~/.undo/

    #cp -rf $thisDir/home/.config/geany ~/.config/

    cp $thisDir/home/.vimrc_debain ~/.vimrc
    cp $thisDir/home/.tmux.conf ~/
    cp $thisDir/home/welcome_message ~/
    cp $thisDir/home/XLaunch.sh ~/

    ranger --copy-config=all
}

function my_git_repos {
    ## my bonzai tree Github hosted apps
    mkdir -p  ~/github/mezcel/
    mkdir -p  ~/gist.github/mezcel/

    git clone https://github.com/mezcel/electron-container.git ~/github/mezcel/electron-container.git
    git clone https://github.com/mezcel/printf-time.git ~/github/mezcel/printf-time.git
    git clone https://github.com/mezcel/jq-tput-terminal.git ~/github/mezcel/jq-tput-terminal.git
    git clone https://github.com/mezcel/python-curses.git ~/github/mezcel/python-curses.git

    ## Gists Notes
    git clone https://gist.github.com/eab7764d1f9e67d051fd59ec7ce3e066.git ~/gist.github/mezcel/git-notes.git
    git clone https://gist.github.com/4bd3ec48c0f3d9c27e33fc6943a29903.git ~/gist.github/mezcel/keyboard-trainer.git
}

function main {
    mkdir -p ~/.config/
    mkdir -p ~/Downloads/
    mkdir -p ~/Pictures/

    ## Vim cache
    mkdir -p ~/.backup/
    mkdir -p ~/.swp/
    mkdir -p ~/.undo/

    tput_color_variables
    debian_desktop_apt
    github_themes
    setup_git
    my_home
    my_git_repos

    sudo apt autoremove
}

main
