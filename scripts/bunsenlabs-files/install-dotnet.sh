#!/bin/bash

function InstallCsharp {
	currentDir=$(PWD)

	## Install the .NET SDK or the .NET Runtime on Debian
	## https://docs.microsoft.com/en-us/dotnet/core/install/linux-debian

	## Microsoft package signing key to your list of trusted keys and add the package repository.

	mkdir -p ~/Downloads
	cd ~/Downlaods

	## Install an IDE
	sudo apt update
	sudo apt install -y wget build-essential vim tmux vifm aspell bc geany geany-plugins zip unzip

	wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb &&

	## Install the SDK
	## The .NET SDK allows you to develop apps with .NET. If you install the .NET SDK, you don't need to install the corresponding runtime.

	sudo apt-get update; \
	  sudo apt-get install -y apt-transport-https && \
	  sudo apt-get update && \
	  sudo apt-get install -y dotnet-sdk-5.0

	## The ASP.NET Core Runtime allows you to run apps that were made with .NET that didn't provide the runtime. The following commands install the ASP.NET Core Runtime, which is the most compatible runtime for .NET.

	sudo apt-get update; \
	  sudo apt-get install -y apt-transport-https && \
	  sudo apt-get update && \
	  sudo apt-get install -y dotnet-runtime-5.0

	#sudo apt-get install -y aspnetcore-runtime-5.0

	## Disable telemetry
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	echo -e "\n## Disable telemetry\nexport DOTNET_CLI_TELEMETRY_OPTOUT=1" >> ~/.bashrc

	cd $currentDir
}

function InstallVSCodium {
	currentDir=$(PWD)
	mkdir -p ~/Downloads
	cd ~/Downlaods

	## https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo

	read -e -p "Install vscodium texteditor? [y/N]: " -i "N" yn

	case $yn in
		[Yy]* )
			wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
				| gpg --dearmor \
				| sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

			echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
				| sudo tee /etc/apt/sources.list.d/vscodium.list

			sudo apt update
			sudo apt install codium
			;;
	esac

	cd $currentDir
}

function InstallPowershell {

	currentDir=$(PWD)
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
	cd $currentDir
}

function InstallDotNet {
	InstallCsharp
	InstallPowershell

	InstallVSCodium
}

function DLGithubRepos {
	if [ -f ../../home/dl-my-repos.sh ]; then
		bash ../../home/dl-my-repos.sh
	else
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/mezcel/headless-host/main/home/dl-my-repos.sh)"
	fi
}

function AddSoftware {
    sudo apt update
    sudo apt update -y --fix-missing

    sudo apt install -y build-essential
	sudo apt install -y vim
	sudo apt install -y vifm
	sudo apt install -y tmux
	sudo apt install -y git
	sudo apt install -y geany geany-plugins
	sudo apt install -y dpkg-dev
	sudo apt install -y bc
	sudo apt install -y aspell

	InstallDotNet

    #sudo apt -y upgrade
}

function Set_Timezone {
	sudo timedatectl set-timezone America/New_York
}

function CrunchbangStuff {
	sudo apt update

	## Free space
	RemoveSoftware

	## My DotNet IDE
	AddSoftware
}

Set_Timezone
CrunchbangStuff

DLGithubRepos