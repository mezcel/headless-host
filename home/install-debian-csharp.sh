#/bin/bash

function InstallCsharp {

    ## Install the .NET SDK or the .NET Runtime on Debian
    ## https://docs.microsoft.com/en-us/dotnet/core/install/linux-debian

    ## Microsoft package signing key to your list of trusted keys and add the package repository.

    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb &&
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
}

function DisableTelemetry {
    ## Disable telemetry
    export DOTNET_CLI_TELEMETRY_OPTOUT=1

    ## Disable telemetry
    echo "~/.bashrc" | grep "DOTNET_CLI_TELEMETRY_OPTOUT=1"
    if [ $? -ne 0 ]; ;then
        echo -e "\n## Disable telemetry\nexport DOTNET_CLI_TELEMETRY_OPTOUT=1" >> ~/.bashrc
    fi
}

function main {
    DisableTelemetry
    InstallCsharp
    DisableTelemetry
}

thisDir=$(pwd)
mkdir -p ~/Downloads/
cd ~/Downloads/

main

cd $thisDir