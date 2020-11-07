#!/bin/bash

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

    function ttyPromptInput {
        promptTitle=$1
        promptString=$2
        defaultAnswer=$3
        tputFgColor=$4
        tputBgColor=$5

        width=80
        promptTitleLength=${#promptTitle}

        titleLength=${#promptTitle}
        highlightLength=$(( 79-$titleLength ))

        printf "$tputBgColor$FG_BLACK $promptTitle"
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor "
        done
        printf "$STYLES_OFF\n"

        read -e -p " $tputFgColor$promptString$STYLES_OFF" -i "$defaultAnswer" readInput
        printf "$STYLES_OFF\n"
        sleep 1
    }

}

function Install_Configurations {

    function Set_Sudo_User {
        if [ $(whoami) == "root" ]; then
            adduser mezcel sudo
            usermod -aG sudo mezcel

            ttyPromptInput "Super User Permission:" "Edit the sudoers configuration file? [ Y/n ]: " "yes" "$FG_RED" "$BG_RED"

            case $readInput in
                [Yy]* )
                    ttyCenteredHeader "visudo" "*" "$FG_CYAN"
                    ttyNestedString "Edit the /etc/sudoers file using Vi. Consider setting specific user/group privileges. Editing will be done through the Vi text editor, not Vim." "$FG_CYAN"

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

    function make_bashrc_alias {
        aliasVar=$1
        autocompleteString=$2
        bashFile=$3
        bashFilePath=$4
        homeBash=~/$bashFile
        sleep 1s

        ## make executable bash in home dir
        cp $bashFilePath $homeBash
        sudo chmod +x $homeBash

        origianlBashrc=~/.bashrc
        backupBashrc=$origianlBashrc.backup_$(date +%d%b%Y%H%S)
        tempBashrc=$origianlBashrc.temp

        ## make a safety backup of ~/.bashrc
        cp $origianlBashrc $backupBashrc
        cp $origianlBashrc $tempBashrc

        ## Make a temporary .bashrc file to edit
        ## Delete previous line reference to bash file
        sed -i "/$bashFile/d" $tempBashrc
        sleep 1s

        ## Delete previous line reference to bash file autocomplete
        sed -i "/$autocompleteString/d" $tempBashrc
        sleep 1s

        aliasautoString="\
        \n## Alias for $bashFilePath \
        \nalias $aliasVar=\"bash $homeBash\" \
        \n## $aliasVar alias autocomplete \
        \ncomplete -W \"$autocompleteString\" $aliasVar \
        \n"

        ## Append ~/.bashrc with alias and it's auto complete argv
        echo -e "$aliasautoString" >> $tempBashrc

        ## Make the temp file the ~/.bashrc file
        sudo mv $tempBashrc $origianlBashrc
        sleep 1

        ## apply the new ~/.bashrc
        source $origianlBashrc
    }

    function Optional_Alias {
        ## Option to add an alias to the (.bashrc) or .profile
        ## It is just an info display commemorating the headless-host install
        ## It will link to a bash script which will provide further options to take.

        ttyCenteredHeader "Create the \"hh\" alias." "." "$FG_YELLOW"
        ttyNestedString "I made a bash script to quickly launch common process from the terminal." "$FG_YELLOW"
        ttyNestedString "If you want, I will put the \"headless-host-alias.bash\" file into ~/ and make an \"hh\" alias in the ~/.bashrc" "$FG_YELLOW"

        promptString="Add the \"hh\" alias ? [ Y/n ]: "
        ttyPromptInput "Bash alias:" "$promptString" "yes" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            [Yy]* )
                aliasVar=hh
                autocompleteString="alsamixer battery down edit mount nvlc off restart umount up"
                bashFile=headless-host-alias.bash
                bashFilePath=$(pwd)/sources/headless-host-alias.bash

                if [ -f $bashFilePath ]; then
                    make_bashrc_alias $aliasVar "$autocompleteString" $bashFile $bashFilePath
                else
                    ttyNestedString "The \"hh\" alias requires a $bashFilePath script. That file path was not detected." "$FG_RED"
                fi
                ;;
        esac
    }

    function Skel_HeadlessHost {
        ## Copy headless-host into the /etc/skel directory
        ## Newly created users will have a copy of the installer scripts and configuration options.
        ## Manually add headless host to any preexisting users created before the /etc/skel recieve headless-host

        me=$(whoami)
        if [ $me == "root" ]; then
            ttyCenteredHeader "Shared Resources" "-" "$FG_Cyan"

            skellDir=/etc/skel/headless-host

            mkdir -p $skellDir
            chmod -R 777 $skellDir

            cp -rf . $skellDir
            sleep 1
            chmod -R 777 $skellDir

            ## make a headless-hot skel
            ttyNestedString "A fresh headless-host directory was placed in /etc/skel." "$FG_YELLOW"

            ## prompt to manually add headless-host to a preexisting user
            echo ""
            promptSting="Add the headless-host repo to an existing user's ~/ ? [ y/N ]: "
            ttyPromptInput "/etc/skel file:" "$promptSting" "yes" "$FG_GREEN" "$BG_GREEN"

            case $readInput in
                [Yy]* )
                    ttyNestedString "Preexisting users:" "$FG_MAGENTA"
                    #demoUser=mezcel
                    demoUser=$(ls /home)
                    demoUser=$(echo $demoUser | awk '{print $1}')
                    sleep 1s

                    promptSting="Enter the name of a desired preexisting user? [ $demoUser ]: "
                    ttyPromptInput "Copy headless-host repo to user:" "$promptSting" "$demoUser" "$FG_GREEN" "$BG_GREEN"

                    if [ -d /home/$readInput ]; then
                        ## check if the user already has headless-host
                        find /home/$demoUser -name "headless-host*" | grep "headless-host" &>/dev/null
                        isUserHH=$?

                        if [ $isUserHH -ne 0 ]; then
                            cp -rf $skellDir /home/$readInput/headless-host
                            sleep 1
                            chmod -R 777 /home/$readInput/headless-host
                            ttyNestedString "/home/$readInput/headless-host was created." "$FG_YELLOW"
                        else
                            ttyNestedString "\t\"headless-host\" appears to exist somewhere in the \"$readInput\" account." "$MODE_DIM$FG_YELLOW"
                            ttyNestedString "\tNothing new was added to /home/$readInput " "$MODE_DIM$FG_YELLOW"
                        fi

                    else
                        ttyNestedString "/home/$demoUser does not exist." "$FG_RED"
                    fi
                    ;;
            esac

        fi
    }

}

function Install_Home {

    function Welcome_Header {
        ttyCenteredHeader "headless-host ( A distro installer and server setup script )" "#" "$FG_CYAN"
        echo -e "$MODE_BOLD $FG_CYAN \
        \nAbout: \
        \n\tThis package will configure the following on a Debian (Buster) +10.5. \
        \n\t* Personal Apt mirror repo, Adhoc wifi, TTY and desktop environments. \
        \nSource: \
        \n\thttps://github.com/mezcel/headless-host.git $STYLES_OFF"
        ttyHR "#" "$FG_CYAN"
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

        ttyCenteredHeader "DONE" "#" "$FG_GREEN"
        ttyNestedString "Finished running: $selectionString" "$FG_CYAN"
    }

    function Home_Menu_Prompt {
        ttyCenteredHeader "Installer Menu" "-" "$FG_MAGENTA"
        echo -e "${FG_MAGENTA}${MODE_BEGIN_UNDERLINE}Select a menu item:${MODE_EXIT_UNDERLINE} \
        \n \
        \n  1. Import a personally curated Apt repository of Deb's \
        \n  2. Install a TTY environment ${MODE_BOLD} \
        \n  3. Install a TTY environment with a minimally themed Desktop environment. ${STYLES_OFF}$FG_MAGENTA \
        \n  4. Install a TTY with configured SSH server and Ad-hoc wifi. \
        \n     ${FG_RED}WARNING: My networking configurations may break existing connectivity.$FG_MAGENTA \
        \n  5. Perform 1, 2, & 4  ( TUI with Networking Ad-hoc Sshd ) \
        \n  6. Perform All \
        \n  q. Quit. \
        \n $STYLES_OFF"

        ttyPromptInput "Installer Scripts:" "Select a menu number? [ 1-6 ]: " "3" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            1 ) ## 1. Import a personally curated Apt repository of Deb's
                source ./sources/0.0-Apt-Repository.bash
                Optional_Alias
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
}

function main {
    ## Initialize

    Decorative_Formatting
    Install_Configurations
    Install_Home

    ## Prompts

    Tput_Colors
    clear
    Welcome_Header
    Home_Menu_Prompt
}

## RUN

main
echo -e "\nDone"
