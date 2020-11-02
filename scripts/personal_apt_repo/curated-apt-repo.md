# curated-apt-repo

## 1.0 About

Personally curated .deb's for a dedicated and targeted server.

## 2.0 Instructions

Overview:

1. Make a dedicated repo directory
2. Populate that directory with *.deb packages
3. Index packages
4. Tell Apt where to pull your repo from
5. Update Apt

## 3.0 Steps

### 3.1 Make a dedicated repo directory
* For this demo I will use ```/MyIndividualDebs```
* For easy universal access i will use the Linux root
    * But a USB, hard drive partition, or another hard drive is a sane way to do it too.
    ```bash
    ## Make Directory containing individual debs
    sudo mkdir -p /MyIndividualDebs
    ```
### 3.2 Populate that directory with *.deb packages

#### 3.2.1 Get Debs

* I am a fan of [wickerscripts.git](https://github.com/yusuphwickama/wickerscripts) to get dependencies for a package application.
    * Everything is just automated and done.
* The oldschool way it to go package "scavenger hunting" on the Debian website.
* I also like to take a "freshly" installed "Live" Debian and populate it even more with all the installed apps I want using Apt install .
    * This way all or any mystery dependencies I need will be contained within a known system.
* Then I make a list of all installed packages on that system
    ```bash
    ## Save the installed packages in a text file
    dpkg -l | grep ^ii | awk '{print $2}' > /MyIndividualDebs/mylist.txt
    ```
* Then I download each one individually using Apt.
    ```bash
    cd /MyIndividualDebs

    ## Download from the package list
    sudo apt download $(cat /MyIndividualDebs/mylist.txt)
    ```

### 3.3 Index packages in directory
* Use dpkg to build a repo index db for this directory of .debs
* In this case the index/repo is called ```Packages.gz```
    ```bash
    dpkg-scanpackages /MyIndividualDebs | gzip > /MyIndividualDebs/Packages.gz
    ```

### 3.4 Tell Apt on the Destination server where to pull your repo from
* I just "sneakernet" the ```MyIndividualDebs``` directory to the target destination server.
* Now create a file with extension .list in ```/etc/apt/sources.list.d/``` on the target destination server.
* I named the repo list ```myRepo.list```
    ```bash
    echo "deb [trusted=yes] file:/// MyIndividualDebs/" >> /etc/apt/sources.list.d/myRepo.list
    ```
    * Note:
        * If my repo was somewhere else like a mounted USB use a directory path that reflects that.
        ```bash
        ## Example:
        sudo mount /dev/sdb1 /mnt

        echo "deb [trusted=yes] file:///mnt MyIndividualDebs/" >> /etc/apt/sources.list.d/myRepo.list
        ```
### Update Apt

* The hard part is done. Just update and enjoy.
    ```bash
    sudo apt update

    ## test it out
    sudo apt install vim
    ```
---

## Harvesting Packages

### Online / harvesting computer

#### Wickerscript

* Sneakernet the vim dependencies
    ```bash
    mkdir -p ~/Downloads/myVim
    cd ~/Downloads/myVim

    ./pkgdownload vim

    tar xvfz vim*.vim
    ```

#### My wonky script

* Sneakernet the vim dependencies
    ```bash
    sudo apt update

    function mini_installer {
        problemPackage=$1

        dependantsArray=1
        dependantsArray=$(apt-cache depends $problemPackage | grep "Depends:" | awk  '{print $2"*.deb"}')

        if [ -z $dependantsArray -ne 1 ]; then
            dpkg -i $dependantsArray
        fi

        dpkg -i $problemPackage
    }

    mkdir -p ~/Downloads/myVim
    cd ~/Downloads/myVim
    mini_installer vim
    ```

### Bundle directory (tar reminder)
* ```mypackageZip.tar.gz```

    ```bash
    ## Make a .tar.gz
    tar -zcvf mypackageZip.tar.gz mypackageDir/

    ## unzip .tar.gz
    tar xvfz mypackageZip.tar.gz
    ```