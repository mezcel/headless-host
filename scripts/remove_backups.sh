#!/bin/bash

## Remove all the stray backup files and directories created by the headless host installation.

function Tput_Colors {
    ## Foreground Color using ANSI escape provided through tput

    FG_BLACK=$(tput setaf 0)
    FG_RED=$(tput setaf 1)
    FG_GREEN=$(tput setaf 2)
    FG_YELLOW=$(tput setaf 3)
    FG_BLUE=$(tput setaf 4)
    FG_MAGENTA=$(tput setaf 5)
    FG_CYAN=$(tput setaf 6)
    FG_WHITE=$(tput setaf 7)
    FG_NoColor=$(tput sgr0)

    ## Background Color using ANSI escape provided through tput

    BG_BLACK=$(tput setab 0)
    BG_RED=$(tput setab 1)
    BG_GREEN=$(tput setab 2)
    BG_YELLOW=$(tput setab 3)
    BG_BLUE=$(tput setab 4)
    BG_MAGENTA=$(tput setab 5)
    BG_CYAN=$(tput setab 6)
    BG_WHITE=$(tput setab 7)
    BG_NoColor=$(tput sgr0)

    ## set mode using ANSI escape provided through tput

    MODE_BOLD=$(tput bold)
    MODE_DIM=$(tput dim)
    MODE_BEGIN_UNDERLINE=$(tput smul)
    MODE_EXIT_UNDERLINE=$(tput rmul)
    MODE_REVERSE=$(tput rev)
    MODE_ENTER_STANDOUT=$(tput smso)
    MODE_EXIT_STANDOUT=$(tput rmso)

    # clear styles using ANSI escape provided through tput

    STYLES_OFF=$(tput sgr0)
    FGBG_NoColor=$(tput sgr0)
}


function remove_dir {
    dirName=$1
    if [ -d $dirName ]; then
        sudo rm -rf $dirName
        echo "$FG_YELLOW Removed the $dirName backup directory. $STYLES_OFF"
    fi
}

function remove_file {
    fileName=$1
    if [ -f $fileName ]; then
        sudo rm $fileName
        echo "$FG_YELLOW Removed the $fileName backup file. $STYLES_OFF"
    fi

}

Tput_Colors

echo "${MODE_BOLD}Deleting Backup Directories: $STYLES_OFF"
remove_dir ~/.vim.backup*
remove_dir ~/terminalsexy.backup*
remove_dir ~/suckless.backup*


echo "${MODE_BOLD}Deleting Backup Files: $STYLES_OFF"
remove_file ~/.vimrc.backup*
remove_file ~/.tmux.conf.backup*
remove_file ~/.bashrc.backup*
remove_file ~/.toprc.backup*
remove_file ~/.xinitrc.backup*

remove_file /etc/issue.backup*
remove_file /etc/motd.backup*
remove_file /etc/network/interface.backup*
remove_file /etc/apt/sources.list.backup*
remove_file /etc/network/interfaces.d/setup.backup*

echo -e "done.\n"
