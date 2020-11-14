#!/bin/bash

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

function Make_Directories {
    ## My Git project directories
    existingUser=$(cat ~/.gitconfig | grep "name" | awk '{print $4}')
    if [ -z $existingUser ]; then
        existingUser=mezcel
    fi

    githubDirectory=~/github/$existingUser
	promptString="${FG_GREEN}Where should Github directories be stored? [ ${FG_CYAN}$githubDirectory${FG_GREEN} ]: ${STYLES_OFF}"

    read -e -p "$promptString" -i "$githubDirectory" githubDirectory

    gistDirectory=~/gist.github/$existingUser
	promptString="${FG_GREEN}Where should Gist directories be stored? [ ${FG_CYAN}$gistDirectory${FG_GREEN} ]: ${STYLES_OFF}"

    read -e -p "$promptString" -i "$gistDirectory" gistDirectory

    mkdir -p  $githubDirectory
    mkdir -p  $gistDirectory
}

function Pull_Repos {
    ## Pull any existing Github repos

    echo -e "${MODE_BOLD}${BG_MAGENTA}${FG_WHITE}\nPull Gist repos\n $STYLES_OFF"
    for filename in ~/github/mezcel/*
    do
        echo Pulling $filename
        cd $filename
        git pull
        cd ../
    done

    ## Pull any existing Gist repos

    echo -e "${MODE_BOLD}${BG_MAGENTA}${FG_WHITE}\nPull Github repos\n $STYLES_OFF"
    for filename in ~/gist.github/mezcel/*
    do
        echo Pulling $filename
        cd $filename
        git pull
        cd ../
    done
}

function Clone_Repos {

    ## #########################################################################
    ## Github Repositories ( https://github.com/mezcel )
    ##

    echo -e "${MODE_BOLD}${BG_MAGENTA}${FG_WHITE}\nClone Github repos\n $STYLES_OFF"

    git clone https://github.com/mezcel/electron-container.git ~/github/mezcel/electron-container.git
    git clone https://github.com/mezcel/printf-time.git ~/github/mezcel/printf-time.git
    git clone https://github.com/mezcel/jq-tput-terminal.git ~/github/mezcel/jq-tput-terminal.git
    #git clone https://github.com/mezcel/carousel-score.git ~/github/mezcel/carousel-score.git
    git clone https://github.com/mezcel/python-curses.git ~/github/mezcel/python-curses.git
    #git clone https://github.com/mezcel/catechism-scrape.git ~/github/mezcel/catechism-scrape.git
    #git clone https://github.com/mezcel/wicked-curse.git ~/github/mezcel/wicked-curse.git
    git clone https://github.com/mezcel/simple-respin.git ~/github/mezcel/simple-respin.git
    git clone https://github.com/mezcel/terminal-profile.git ~/github/mezcel/terminal-profile.git
    git clone https://github.com/mezcel/keyboard-layout.git ~/github/mezcel/keyboard-layout.git
    git clone https://github.com/mezcel/bookmark-renderer.git ~/github/mezcel/bookmark-renderer.git
    git clone https://github.com/mezcel/struct-fmt.git ~/github/mezcel/struct-fmt.git
    git clone https://github.com/mezcel/fs-path.git  ~/github/mezcel/fs-path.git
    git clone https://github.com/mezcel/headless-host.git  ~/github/mezcel/headless-host.git

    ## hidden repos

    #git clone https://github.com/mezcel/scrapy-spider.git ~/github/mezcel/scrapy-spider
    #git clone https://github.com/mezcel/adeptus-mechanicus-stc.git ~/github/mezcel/drone-rpg

    ## #########################################################################
    ## Gist Repositories ( https://gist.github.com/mezcel )
    ##

    echo -e "${MODE_BOLD}${BG_MAGENTA}${FG_WHITE}\nClone Gist repos\n $STYLES_OFF"

    git clone https://gist.github.com/eab7764d1f9e67d051fd59ec7ce3e066.git ~/gist.github/mezcel/git-notes.gist
    #git clone https://gist.github.com/64db9afd5419e557c0ee53ed935d516e.git ~/gist.github/mezcel/my-screen-gama
    #git clone https://gist.github.com/8ac1119e0bb94c581128184d332beee4.git ~/gist.github/mezcel/scrapy-help
    git clone https://gist.github.com/c90ce696785821d1921f8c2104fb60d3.git ~/gist.github/mezcel/stations.gist
    git clone https://gist.github.com/72730d0c2f8cd8b7e0491188df6fa0f0.git ~/gist.github/mezcel/tmux-notes.gist
    git clone https://gist.github.com/7293290230cda8dc69d1ad0a67ad4250.git ~/gist.github/mezcel/vim-notes.gist
    git clone https://gist.github.com/7bf48505cc0440f7a5ff08340ecb24bd.git ~/gist.github/mezcel/atomio-notes.gist
    git clone https://gist.github.com/62f85669d9d901d364f3779198e1f5b6.git ~/gist.github/mezcel/c-snipits.gist
    git clone https://gist.github.com/f374a42c197ba9d2d41cd1d6b95f9496.git ~/gist.github/mezcel/tmp-gist.gist
    git clone https://gist.github.com/2cc404f78d2488f02394c81d30047b2d.git ~/gist.github/mezcel/nodejs-notes.gist
    git clone https://gist.github.com/fa9f298a0e02ff8f7afa02b05f2804f8.git ~/gist.github/mezcel/python-notes.gist
    git clone https://gist.github.com/34895a5ae768873a26e762e068394a84.git ~/gist.github/mezcel/powershell-notes.gist
    git clone https://gist.github.com/4be2de2cb400dd7f781c721c19e3b99b.git ~/gist.github/mezcel/vscode-notes.gist
    git clone https://gist.github.com/b6be6bd5bd78d20bbd51af94af4d6ad4.git ~/gist.github/mezcel/golang-notes.gist
    git clone https://gist.github.com/22682a865a4e9d8a2c02877cf1cb7374.git ~/gist.github/mezcel/ProjectEuler.gist
    git clone https://gist.github.com/ff833a444f2671879b22e76aa4ed61c5.git ~/gist.github/mezcel/alpine-notes.gist
    git clone https://gist.github.com/c8d4759203ce958692fc960b92eda960.git ~/gist.github/mezcel/tc-notes.gist
    git clone https://gist.github.com/82b46eb373ab49815bf5a516c43a85b7.git ~/gist.github/mezcel/notepadpp-notes.gist
    git clone https://gist.github.com/4de4493be820be7529efe75d89bf9176.git ~/gist.github/mezcel/99-cents.gist
    git clone https://gist.github.com/b4ce7f783597fb0ee97dfe66a9239175.git ~/gist.github/mezcel/terminal-profile-extras.gist
	git clone https://gist.github.com/508c384d9200933761fa8ecbc4f4698c.git ~/gist.github/mezcel/cache-todo.gist
}

function Set_Git_User {
    ## Set ~/.gitconfig

    if [ ! -f ~/.gitconfig ]; then

        echo -e "$BG_CYAN${FG_BLACK}\nConfigure Git for Github: \n$STYLES_OFF${FG_CYAN}"

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

        echo -e "${FG_MAGENTA}Existing Git User:\n\tgit config --global user.name ${FG_CYAN}$githubusername\n\t${FG_MAGENTA}git config --global user.email ${FG_CYAN}$githubuseremail $STYLES_OFF\n"
    fi
}

function Greeter {
	echo ""
	echo -e "## ################################################################"
	echo -e "## Clone repositories hosted on Github."
	echo -e "##\thttps://github.com/mezcel"
	echo -e "##\thttps://gist.github.com/mezcel"
	echo -e "## ################################################################"
	echo ""
}

function Main {
    ## Primary function

    command -v git &>/dev/null

    if [ $? -eq 0 ]; then
        Set_Git_User
        Make_Directories
        Pull_Repos
        Clone_Repos

        echo -e "$FG_GREEN${MODE_BOLD}\nDone. $STYLES_OFF"
    else
        echo -e "${MODE_BOLD}${BG_YELLOW}${FG_RED} \nScript exited.\n\tGit is not installed. $STYLES_OFF"
    fi
}

## #############################################################################
## Run
## #############################################################################

Tput_Colors
Greeter
Main

#echo -e "$STYLES_OFF"
