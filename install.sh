#!/bin/bash

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

################################################################################
## Main
################################################################################

function Welcome_Header {
    echo -e "$FG_CYAN \
    \n##################################################################################################### \
    \n## headless-host ( A distro installer and server setup script )                                    ## \
    \n##################################################################################################### \
    \n##                                                                                                 ## \
    \n## About:                                                                                          ## \
    \n##    This package will facilitate respinning Debian (Buster) +10.5.                               ## \
    \n##    This project was built around a niche cellphone battery powered mini-pc computer.            ## \
    \n##                                                                                                 ## \
    \n## source:                                                                                         ## \
    \n##     https://github.com/mezcel/headless-host.git                                                 ## \
    \n##                                                                                                 ## \
    \n#####################################################################################################"
    echo -e "$STYLES_OFF"
    sleep 1s
}

function Menu_Prompt {
    Welcome_Header

    echo -e "${BG_MAGENTA}${FG_WHITE}\
#####################################################################################################
## Installer Menu                                                                                  ##
#####################################################################################################"
    echo -e "$STYLES_OFF"

    echo -e "${FG_MAGENTA}Select a menu item: \
    \n \
    \n  1. Import a personally curated Apt repository of Deb's \
    \n  2. Install a TTY environment ${MODE_BOLD} \
    \n  3. Install a TTY environment with a minimally themed Desktop environment. ${FGBG_NoColor}$FG_MAGENTA \
    \n  4. Install a TTY with configured SSH server and Ad-hoc wifi. \
    \n     ${FG_RED}WARNING: My networking configurations may break existing connectivity.$FG_MAGENTA \
    \n\n  --- combination scripts bundles ---
    \n  5. Perform 1, 2, & 4  ( TUI with Networking Ad-hoc Sshd ) \
    \n  6. Perform All \
    \n \
    \n  q. Quit. \
    \n $FGBG_NoColor"

    echo -e "${FG_YELLOW}Note:"
    echo -e "\tThis menu will load \"source\" script from the ./sources/ directory. $FGBG_NoColor"

}

function Set_Sudo_User {
    if [ $(whoami) == "root" ]; then
        adduser mezcel sudo
        usermod -aG sudo mezcel


        promtString="${FG_RED}Edit the sudoers configuration file? [ Y/n ]: $FGBG_NoColor"
        yn=yes
        echo ""
        read -e -p "$promtString" -i "$yn" yn
        echo ""
        case $yn in
            [Yy]* )
                echo -e "${FG_YELLOW}"
                echo -e "Edit the /etc/sudoers file using Vi.\
                \n\tConsider setting specific user/group privileges. \
                \n\tEditing will be done through the Vi text editor, not Vim. \n "
                echo -e "$FGBG_NoColor"

                read -p "Press ENTER key to continue ..." pauseEnter

                #visudo
                sudo vi /etc/sudoers +/root\\tALL=\(ALL:ALL\)
                sleep 1s
                ;;
        esac
    fi
}

function Decorate_MotdIssue {
    ## ANSI Escape Sequence: Terminal Color Codes

    txtblk='\e[0;30m' # Black - Regular
    txtred='\e[0;31m' # Red
    txtgrn='\e[0;32m' # Green
    txtylw='\e[0;33m' # Yellow
    txtblu='\e[0;34m' # Blue
    txtpur='\e[0;35m' # Purple
    txtcyn='\e[0;36m' # Cyan
    txtwht='\e[0;37m' # White

    bldblk='\e[1;30m' # Black - Bold
    bldred='\e[1;31m' # Red
    bldgrn='\e[1;32m' # Green
    bldylw='\e[1;33m' # Yellow
    bldblu='\e[1;34m' # Blue
    bldpur='\e[1;35m' # Purple
    bldcyn='\e[1;36m' # Cyan
    bldwht='\e[1;37m' # White

    unkblk='\e[4;30m' # Black - Underline
    undred='\e[4;31m' # Red
    undgrn='\e[4;32m' # Green
    undylw='\e[4;33m' # Yellow
    undblu='\e[4;34m' # Blue
    undpur='\e[4;35m' # Purple
    undcyn='\e[4;36m' # Cyan
    undwht='\e[4;37m' # White

    bakblk='\e[40m'   # Black - Background
    bakred='\e[41m'   # Red
    bakgrn='\e[42m'   # Green
    bakylw='\e[43m'   # Yellow
    bakblu='\e[44m'   # Blue
    bakpur='\e[45m'   # Purple
    bakcyn='\e[46m'   # Cyan
    bakwht='\e[47m'   # White

    txtrst='\e[0m'    # Text Reset

    ## /etc/issue

    issueTemp=~/issue.temp
    issueFile=/etc/issue

    ## make a safety backup of /etc/issue
    sudo cp $issueFile $issueFile.backup_$(date +%d%b%Y%H%S)

    ## customize issue
    sudo cp $issueFile $issueTemp

    echo -en "\
    \n${bakred}${bldwht}# Headless Host                                              ${txtrst}\
    \n${txtwht}${bakred}- A Debian server respin by mezcel                           ${txtrst}\
    \n${txtwht}${bakred}- github: https://github.com/mezcel/headless-host.git        ${txtrst}\
    \n${txtrst}\
    \n" >> $issueTemp

    ## \n \
    ## \n> ${bldylw}Use the alias \"${bldcyn}hh${bldylw}\" to launch a helper script from the tty.\

    sudo mv $issueTemp $issueFile

    ## /etc/motd

    motdTemp=~/motd.temp
    motdFile=/etc/motd

    ## make a safety backup of /etc/motd
    sudo cp $motdFile $motdFile.backup_$(date +%d%b%Y%H%S)

    ## customize issue
    sudo cp $motdFile $motdTemp

    echo -e "" > $motdTemp

    sudo mv $motdTemp $motdFile
}

function Optional_Alias {
    ## Option to add an alias to the (.bashrc) or .profile
    ## It is just an info display commemorating the headless-host install
    ## It will link to a bash script which will provide further options to take.

    echo -e "---\n${FG_YELLOW}Create the \"hh\" alias. \
    \n\tI made a bash script to quickly launch common process from the terminal. \
    \n\tIf you want, I will put the \"headless-host-alias.bash\" file into ~/ and make an \"hh\" alias in the ~/.bashrc \
    \n$STYLES_OFF"

    promtString="${FG_GREEN}Add the \"hh\" alias ? [ Y/n ]: $STYLES_OFF"
    yn=yes
    read -e -p "$promtString" -i "$yn" yn
    echo "$FGBG_NoColor"

    case $yn in
        [Yy]* )
            ## path of the ctodo.bash file
            headlesshostPath=$(pwd)/sources/headless-host-alias.bash

            origianlBashrc=~/.bashrc
            backupBashrc=$origianlBashrc.backup_$(date +%d%b%Y%H%S)
            tempBashrc=$origianlBashrc.temp

            ## copy headless-host-alias.bash to home dir
            sudo cp $headlesshostPath ~/
            sleep 1

            ## update permission and executablity
            sudo chmod 777 ~/headless-host-alias.bash
            sudo chmod +x ~/headless-host-alias.bash

            headlesshostPath=~/headless-host-alias.bash

            ## make a safety backup of ~/.bashrc
            cp $origianlBashrc $backupBashrc
            cp $origianlBashrc $tempBashrc

            ## Make a temporary .bashrc file to edit
            ## Delete previous line reference to headless-host-alias.bash
            sed -i "/headless-host-alias.bash/d" $tempBashrc
            sleep 1s

            ## Delete previous line reference to headless-host-alias autocomplete
            autocompleteString='alsamixer battery down edit mount nvlc off restart unmount up'
            sed -i "/$autocompleteString/d" $tempBashrc
            sleep 1s

            aliasautoString="\
            \n## Alias for $headlesshostPath \
            \nalias hh=\"bash $headlesshostPath\" \
            \n## hh alias autocomplete \
            \ncomplete -W \"$autocompleteString\" hh \
            \n"

            echo -e "$aliasautoString" $tempBashrc

            ## Make the temp file the ~/.bashrc file
            sudo mv $tempBashrc $origianlBashrc
            sleep 1

            ## apply the new ~/.bashrc
            source $origianlBashrc

            ;;
    esac
}

function Skel_HeadlessHost {
    ## Copy headless-host into the /etc/skel directory
    ## Newly created users will have a copy of the installer scripts and configuration options.
    ## Manually add headless host to any preexisting users created before the /etc/skel recieve headless-host

    me=$(whoami)
    if [ $me == "root" ]; then
        skellDir=/etc/skel/headless-host

        mkdir -p $skellDir
        chmod -R 777 $skellDir

        cp -rf . $skellDir
        sleep 1
        chmod -R 777 $skellDir

        ## make a headless-hot skel
        echo -e "${BG_RED}${FG_WHITE}\n!!! A fresh headless-host directory was placed in /etc/skel !!! $STYLES_OFF"

        ## prompt to manually add headless-host to a preexisting user
        echo ""
        promptSting="${FG_GREEN}Do you want to add the headless-host directory to a preexisting user's ~/ ? [ y/N ]:$STYLES_OFF "
        yn=no
        read -e -p "$promptSting" -i "$yn" yn
        echo ""

        case $yn in
            [Yy]* )
                echo -e "${FG_MAGENTA}## Preexisting users:\n${FG_CYAN}\n$(ls /home)\n$STYLES_OFF"
                #demoUser=mezcel
                demoUser=$(ls /home)
                demoUser=$(echo $demoUser | awk '{print $1}')
                sleep 1s

                promptSting="${FG_GREEN}Enter the name of a desired preexisting user? [ ${FG_CYAN}$demoUser${FG_GREEN} ]: $STYLES_OFF"
                read -e -p "$promptSting" -i "$demoUser" demoUser
                echo ""

                if [ -d /home/$demoUser ]; then
                    ## check if the user already has headless-host
                    find /home/$demoUser -name "headless-host*" | grep "headless-host" &>/dev/null
                    isUserHH=$?

                    if [ $isUserHH -ne 0 ]; then
                        cp -rf $skellDir /home/$demoUser/headless-host
                        sleep 1
                        chmod -R 777 /home/$demoUser/headless-host
                        echo -e "\t${BG_RED}${FG_WHITE}!!! /home/$demoUser/headless-host was created !!! $STYLES_OFF"
                    else
                        echo -e "${FG_YELLOW}\t\"headless-host\" appears to exist somewhere in the \"$demoUser\" account.\n\tNothing new was added to /home/$demoUser $STYLES_OFF"
                    fi

                else
                    echo -e "\n${BG_RED}/home/$demoUser does not exist.\n $STYLES_OFF"
                fi
                ;;
        esac

    fi
}

function Done_Message {
    selectionString=""
    case $1 in
        1 ) selectionString="Option (1) \"Import a personally curated Apt repository of Deb's\"" ;;
        2 ) selectionString="Option (2) \"Install just a Tty environment\"" ;;
        3 ) selectionString="Option (3) \"Install a Tty environment with a minimally themed Desktop environment.\"" ;;
        4 ) selectionString="Option (4) \"Install ad-hoc ssh server features.\"" ;;
        5 ) selectionString="Option (5) \"Perform 1, 2, & 4\"" ;;
        6 ) selectionString="Option (6) \"Perform All\"" ;;
        * ) selectionString="The selected menu item from \"installer.sh\"" ;;
    esac

    echo -e "\n${BG_GREEN}${FG_BLACK}Done. \nFinished running: $selectionString \
        \n\tReboot the machine just for good measure. \
        \n\tIt will likely auto apply miscellaneous changes in the hardware configuration. \n $FGBG_NoColor"
}

function Main_Menu {
    ## Welcome Header prompt
    Menu_Prompt

    echo "$FGBG_NoColor"
    installNo=3
    promptString="${FG_GREEN}Select a menu number? [ 1-6 ]: $FGBG_NoColor"
    read -e -p "$promptString" -i "$installNo" installNo
    echo "$FGBG_NoColor"

    case $installNo in
        1 ) ## 1. Import a personally curated Apt repository of Deb's
            source ./sources/0.0-Apt-Repository.bash
            Done_Message
            ;;
        2 ) ## 2. Install just a Tty environment
            Set_Sudo_User
            source ./sources/0.0-Apt-Repository.bash
            source ./sources/1.0-Install-Tty-Environment.bash

            Optional_Alias
            Decorate_MotdIssue
            Skel_HeadlessHost
            Done_Message $installNo
            ;;
        3 ) ## 3. Install a Tty environment with a minimally themed Desktop environment.
            Set_Sudo_User
            source ./sources/0.0-Apt-Repository.bash
            source ./sources/1.0-Install-Tty-Environment.bash
            source ./sources/2.0-Install-Desktop-Environment.bash
            source ./sources/3.0-Install-Networking.bash

            Optional_Alias
            Decorate_MotdIssue
            Skel_HeadlessHost
            Done_Message $installNo
            ;;
        4 ) ## 4. Install ad-hoc ssh server features.
            Set_Sudo_User
            source ./sources/3.1-Install-Wifi-Adhoc.bash
            source ./sources/1.0-Install-Tty-Environment.bash

            Optional_Alias
            Decorate_MotdIssue
            Skel_HeadlessHost
            Done_Message $installNo
            ;;
        5 ) ## 5. Perform 1, 2, & 4  ( My TUI with Ad-hoc sshd )
            Set_Sudo_User
            source ./sources/0.0-Apt-Repository.bash
            source ./sources/1.0-Install-Tty-Environment.bash
            source ./sources/3.1-Install-Wifi-Adhoc.bash

            Optional_Alias
            Decorate_MotdIssue
            Skel_HeadlessHost
            Done_Message $installNo
            ;;
        6 ) ## 6. Perform All        ( My DE )
            Set_Sudo_User
            source ./sources/0.0-Apt-Repository.bash
            source ./sources/1.0-Install-Tty-Environment.bash
            source ./sources/2.0-Install-Desktop-Environment.bash
            source ./sources/3.0-Install-Networking.bash
            source ./sources/3.1-Install-Wifi-Adhoc.bash

            Optional_Alias
            Decorate_MotdIssue
            Skel_HeadlessHost
            Done_Message $installNo
            ;;
        [Qq]* ) ## Quit installer
            echo -e "\n${FG_RED}\tExited installer. $FGBG_NoColor\n"
            exit
            ;;
        * ) ## Quit installer
            echo -e "\n${FG_RED}\tExited installer. $FGBG_NoColor\n"
            exit
            ;;
    esac
}

function Run {
    clear
    Tput_Colors

    isSudo=$(command -v sudo)

    if [ $isSudo == "/usr/bin/sudo" ]; then
        Main_Menu
    else
        echo -e "$FG_RED\nScript terminated."
        echo -e "\tA lot of sudo will be required and sudo is not installed.\n $FGBG_NoColor"
    fi
}

################################################################################
## Run
################################################################################

Run
