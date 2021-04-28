#!/bin/bash

## Installation via Direct Download - Debian 10
## Download the tar.gz package powershell-7.1.3-linux-x64.tar.gz from the releases page onto the Debian machine.

## https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1#debian-10

function direct_dl {

    ## https://github.com/PowerShell/PowerShell/releases/tag/v7.1.3
    ## https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/powershell_7.1.3-1.debian.10_amd64.deb

    sudo apt-get update
    # install the requirements
    sudo apt-get install -y \
        less \
        locales \
        ca-certificates \
        libicu63 \
        libssl1.1 \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust0 \
        libstdc++6 \
        zlib1g \
        curl

    # Download the powershell '.tar.gz' archive
    curl -L  https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/powershell-7.1.3-linux-x64.tar.gz -o /tmp/powershell.tar.gz

    # Create the target folder where powershell will be placed
    sudo mkdir -p /opt/microsoft/powershell/7

    # Expand powershell to the target folder
    sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

    # Set execute permissions
    sudo chmod +x /opt/microsoft/powershell/7/pwsh

    # Create the symbolic link that points to pwsh
    sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

    # Start PowerShell
    pwsh
}

function aptPackage {
    cd ~/Downloads/

    ## Download the Microsoft repository GPG keys
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb &&

    ## Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb

    ## Update the list of products
    sudo apt-get update

    ## Install PowerShell
    sudo apt-get install -y powershell

    ## Start PowerShell
    #pwsh
}


thisDir=$(pwd)
mkdir -p ~/Downloads/
cd ~/Downloads/

aptPackage

cd $thisDir