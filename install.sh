#!/bin/bash

function Decorative_Formatting {
    ## Decorative tty colors
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

    function ttyCenter {
        str="$1"
        tputFgColor=$2

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi

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

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi

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

        ttyMaxCols=$( tput cols )
        if [ $ttyMaxCols -gt 80 ]; then ttyMaxCols=80; fi
        ttyMaxCols=$(($ttyMaxCols-1))

        charCount=0
        isFrstLine=1

        printf "$tputFgColor"
        for i in "${strArray[@]}"; do
            charCount=$(($charCount+${#i}+1))

            if [ $isFrstLine -ne 1 ]; then
                ttyMaxCols=$( tput cols )
                if [ $ttyMaxCols -gt 80 ]; then ttyMaxCols=80; fi
                ttyMaxCols=$(($ttyMaxCols-5))

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

        width=$( tput cols )
        if [ $width -gt 80 ]; then width=80; fi
        width=$(($width - 3))

        strLength=${#str}

        highlightLength=$(( $width-$strLength ))

        printf "$tputBgColor$FG_BLACK= $str "
        for (( i=0; i<$highlightLength; i++ ))
        do
           printf "$tputBgColor="
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

function Install_Configurations {
    function Set_Sudo_User {
        me=$(whoami)

        if [ $me == "root" ]; then
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
        else
            sudo cat /etc/sudoers | grep "$me" &>/dev/null
            isSudo=$?

            if [ $isSudo -ne 0 ]; then
                ttyCenteredHeader "The $me profile is not a member of the sudo group" "-" "$FG_RED"
                ttyNestedString "The current user profile, \"$me\", may not have the appropriate \"sudo\" permissions yet. If you know this account does not have sudo privileges, login as \"root\" and manually edit the /etc/sudoers file to elevate this profile's permissions." "$FG_RED"
                ttyNestedString "This script will terminate now so you can take the corrective actions to elevate this user profile's permissions privileges to sudo." "$MODE_BOLD$FG_RED"
                sleep 3s

                exit
            else
                ttyNestedString "The \"$me\" user account is recognized as a member of the sudo group." "$MODE_BOLD$FG_GREEN"
            fi
        fi
    }

    function Decorate_MotdIssue {

        uname -v | grep "Debian" &>/dev/null
        isDebian=$?

        if [ $isDebian -eq 0 ]; then
            ttyCenteredHeader "Decorating issue and motd" "-" "$FG_CYAN"

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
            ttyNestedString "Backing up $issueFile ..." "$MODE_DIM$FG_YELLOW"
            sleep 1s

            sudo cp $issueFile $issueFile.backup_$(date +%d%b%Y%H%S) &>/dev/null
            sleep 1s

            ## customize issue
            ttyNestedString "Decorating $issueFile ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp $issueFile $issueTemp &>/dev/null
            sleep 1s

            ## Decorate /etc/issue
            #echo -en "\
            #\n${bakred}${bldwht}# Headless Host                                              ${txtrst}\
            #\n${txtwht}${bakred}- A Debian server respin by mezcel                           ${txtrst}\
            #\n${txtwht}${bakred}- github: https://github.com/mezcel/headless-host.git        ${txtrst}\
            #\n${txtrst}\
            #\n" >> $issueTemp

            ## Decorate /etc/issue
            echo -en "\
            \n${bakred}${bldwht}# Headless Host                                            $txtblk░$txtred░$txtgrn░$txtylw░$txtblu░$txtpur░$txtcyn░$txtwht░${bakred}    ${txtrst}\
            \n${txtwht}${bakred}- A Debian server respin by mezcel                         $bldblk░$bldred░$bldgrn░$bldylw░$bldblu░$bldpur░$bldcyn░$bldwht░${bakred}    ${txtrst}\
            \n${txtwht}${bakred}- github: https://github.com/mezcel/headless-host.git      $bakblk░$bakred░$bakgrn░$bakylw░$bakblu░$bakpur░$bakcyn░$bakwht░${bakred}    ${txtrst}\
            \n${txtrst}\
            \n" >> $issueTemp

            sleep 1s

            sudo mv $issueTemp $issueFile &>/dev/null
            sleep 1s

            ## /etc/motd
            ttyNestedString "Decorating /etc/issue ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            motdTemp=~/motd.temp
            motdFile=/etc/motd

            ## make a safety backup of /etc/motd
            ttyNestedString "Backing up $motdFile ..." "$MODE_DIM$FG_YELLOW"
            sleep 1s

            sudo cp $motdFile $motdFile.backup_$(date +%d%b%Y%H%S) &>/dev/null
            sleep 1s

            ## customize issue
            ttyNestedString "Decorating $motdFile ..." "$MODE_BOLD$FG_GREEN"
            sleep 1s

            sudo cp $motdFile $motdTemp &>/dev/null
            sleep 1s

            ## Clear motd file
            sudo echo -e "" > $motdTemp &>/dev/null
            sleep 1

            sudo mv $motdTemp $motdFile &>/dev/null
            sleep 1s
        fi
    }

    function Make_Bashrc_Alias {

        uname -v | grep "Debian" &>/dev/null
        isDebian=$?

        if [ $isDebian -eq 0 ]; then
            aliasVar=$1
            autocompleteString=$2
            bashFile=$3
            bashFilePath=$4
            homeBash=~/$bashFile
            sleep 1s

            ttyCenteredHeader "Adding the \"hh\" alias to ~/.bashrc" "░" "$FG_GREEN"

            ## make executable bash in home dir
            cp $bashFilePath $homeBash
            sudo chmod +x $homeBash

            origianlBashrc=~/.bashrc
            backupBashrc=$origianlBashrc.backup_$(date +%d%b%Y%H%S)
            tempBashrc=$origianlBashrc.temp

            ## make a safety backup of ~/.bashrc
            ttyNestedString "Backing up $origianlBashrc ..." "$MODE_DIM$FG_YELLOW"
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
            ttyNestedString "Writing the new $origianlBashrc ..." "$MODE_BOLD$FG_GREEN"
            sudo mv $tempBashrc $origianlBashrc
            sleep 1

            ## apply the new ~/.bashrc
            source $origianlBashrc
        fi
    }

    function Optional_Alias {

        uname -v | grep "Debian" &>/dev/null
        isDebian=$?

        if [ $isDebian -eq 0 ]; then
            ## Option to add an alias to the (.bashrc) or .profile
            ## It is just an info display commemorating the headless-host install
            ## It will link to a bash script which will provide further options to take.

            ttyCenteredHeader "Create the \"hh\" alias." "+" "$FG_YELLOW"
            ttyNestedString "I made a bash script to quickly launch common process from the terminal." "$FG_YELLOW"
            ttyNestedString "If you want, I will put the \"headless-host-alias.bash\" file into ~/ and make an \"hh\" alias in the ~/.bashrc" "$FG_YELLOW"

            promptString="Add the \"hh\" alias ? [ Y/n ]: "
            ttyPromptInput "Bash alias:" "$promptString" "yes" "$FG_GREEN" "$BG_GREEN"

            case $readInput in
                [Yy]* )
                    aliasVar=hh
                    autocompleteString="alsamixer battery down edit mount nvlc off ping restart umount up"
                    bashFile=headless-host-alias.bash
                    bashFilePath=$(pwd)/sources/headless-host-alias.bash

                    if [ -f $bashFilePath ]; then
                        Make_Bashrc_Alias $aliasVar "$autocompleteString" $bashFile $bashFilePath
                    else
                        ttyNestedString "The \"hh\" alias requires a $bashFilePath script. That file path was not detected." "$FG_RED"
                    fi
                    ;;
            esac
        fi
    }

    function Skel_HeadlessHost {
        ## Copy headless-host into the /etc/skel directory
        ## Newly created users will have a copy of the installer scripts and configuration options.
        ## Manually add headless host to any preexisting users created before the /etc/skel recieve headless-host
        uname -v | grep "Debian" &>/dev/null
        isDebian=$?

        if [ $isDebian -eq 0 ]; then
            me=$(whoami)

            if [ $me == "root" ]; then
                ttyCenteredHeader "Shared Resources" "-" "$FG_Cyan"

                skellDir=/etc/skel/headless-host

                mkdir -p $skellDir

                cp -rf --no-preserve=mode . $skellDir
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
                        echo $demoUser
                        readInput=$(echo $demoUser | awk '{print $1}')
                        sleep 1s

                        promptSting="Enter the name of a desired preexisting user? [ $readInput ]: "
                        ttyPromptInput "Copy headless-host repo to user:" "$promptSting" "$readInput" "$FG_GREEN" "$BG_GREEN"

                        if [ -d /home/$readInput ]; then
                            ## check if the user already has headless-host
                            find /home/$readInput -name "headless-host*" | grep "headless-host" &>/dev/null
                            isUserHH=$?

                            if [ $isUserHH -ne 0 ]; then
                                cp -rf --no-preserve=mode $skellDir /home/$readInput/headless-host
                                sleep 1
                                sudo chmod -R 777 /home/$readInput/headless-host
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
            else
                ttyCenteredHeader "Skel directory was not edited" "." "$FG_RED"
                ttyNestedString "This script will only edit the /etc/skel directory if this script is ran from the \"root\" account." "$FG_RED"
                sleep 2s
            fi
        fi
    }
}

function Install_Home {
    function Welcome_Header {
        ttyCenteredHeader "headless-host ( A distro installer and server setup script )" "░" "$FG_CYAN"
        echo -e "$FG_CYAN \
        \n${MODE_BOLD}About:${STYLES_OFF} \
        \n\t${FG_CYAN}This package will configure the following on a Debian (Buster) +10.5. \
        \n\t* Personal Apt mirror repo, Adhoc wifi, TTY and desktop environments. \
        \n${MODE_BOLD}Source:$STYLES_OFF \
        \n\t${FG_CYAN}https://github.com/mezcel/headless-host.git $STYLES_OFF"
        #ttyHR "░" "$FG_CYAN"
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

        echo ""
        ttyCenteredHeader "DONE" "░" "$FG_GREEN"
        ttyNestedString "Finished running: $selectionString" "$FG_CYAN"
    }

    function Home_Menu_Prompt {
        uname -v | grep "Debian" &>/dev/null
        isDebian=$?

        if [ $isDebian -eq 0 ]; then
            readInput=3
            higlightedOption="\n  ${FG_MAGENTA}${MODE_BOLD}2.${STYLES_OFF} ${FG_MAGENTA}Install a TTY environment ${MODE_BOLD} \n  ${FG_MAGENTA}${MODE_BOLD}3. ${FG_MAGENTA}Install a TTY environment with a minimally themed Desktop environment. ${STYLES_OFF}$FG_MAGENTA"
        else
            readInput=2
            higlightedOption="\n  ${FG_MAGENTA}${MODE_BOLD}2. ${FG_MAGENTA}Install a TTY environment ${MODE_BOLD} \n  ${FG_MAGENTA}${MODE_BOLD}3.${STYLES_OFF} ${FG_MAGENTA}Install a TTY environment with a minimally themed Desktop environment. ${STYLES_OFF}$FG_MAGENTA"
        fi

        ttyCenteredHeader "Installer Menu" "-" "$FG_MAGENTA"
        echo -e "${MODE_BOLD}${FG_MAGENTA}${MODE_BEGIN_UNDERLINE}Select a menu item number:${MODE_EXIT_UNDERLINE} \
        \n ${STYLES_OFF}\
        \n  ${FG_MAGENTA}${MODE_BOLD}1.${STYLES_OFF} ${FG_MAGENTA}Import a personally curated Apt repository of Deb's \
        $higlightedOption \
        \n  ${FG_MAGENTA}${MODE_BOLD}4.${STYLES_OFF} ${FG_MAGENTA}Install a TTY with configured SSH server and Ad-hoc wifi. \
        \n     ${FG_RED}WARNING: My networking configurations may break existing connectivity.$FG_MAGENTA \
        \n  ${FG_MAGENTA}${MODE_BOLD}5.${STYLES_OFF} ${FG_MAGENTA}Perform 1, 2, & 4  ( TUI with Networking Ad-hoc Sshd ) \
        \n  ${FG_MAGENTA}${MODE_BOLD}6.${STYLES_OFF} ${FG_MAGENTA}Perform All \
        \n  ${FG_MAGENTA}${MODE_BOLD}q.${STYLES_OFF} ${FG_MAGENTA}Quit.\n $STYLES_OFF"

        ttyPromptInput "Installer Scripts:" "Select a menu number? [ 1-6 ]: " "$readInput" "$FG_GREEN" "$BG_GREEN"

        case $readInput in
            1 ) ## 1. Import a personally curated Apt repository of Deb's
                me=$(whoami)
                if [ $me == "root" ]; then
                    source ./sources/0.0-Apt-Repository.bash
                    Optional_Alias
                else
                    echo ""
                    ttyCenteredHeader "Canceled making custom APT mirror." "░" "$FG_YELLOW"
                    ttyNestedString "- Since APT repositories effect the system as a whole, special sudo permission must be considered. Bear in mind that though some packages are install-able offline, they are designed to be install online." "$FG_RED"
                    ttyNestedString "- For best results, go offline, log into the \"root\" account, and then run this script." "$FG_RED"
                    echo -e "\n"
                    read -p "Press [Enter] to continue ..." enterKey

                fi

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
            * ) ## Quit installer
                ttyCenteredHeader "Exited Installer" "▞" "$FG_RED"
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

    Tput_Colors
    ttyHighlightRow "Login into the headless-host installer ..." "$BG_CYAN"

    sudo clear
    if [ $? -ne 0 ]; then echo "login failed"; exit; fi

    ## Prompts

    Welcome_Header
    Home_Menu_Prompt
}

## RUN

main
echo -e "\nDone"
