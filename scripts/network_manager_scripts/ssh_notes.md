# SSH Notes

## Install OpenShh

### Debian

```sh
## client
sudo apt install openssh-client

## server
sudo apt install openssh-server
```

## Configure Server Machine:

### Debian

```sh
ssh localhost
sudo service ssh start
sudo service ssh stop
sudo service ssh restart
sudo service ssh enable
sudo service ssh status
```

---

## Use SSH

### Connect to a SSH Server from an SSH Client:

- known_ip1=192.168.1.100
- known_ip2=192.168.1.101
- known_hostname=mezcel
- known_port=22

connect to an ssh server
```sh
ssh mezcel@192.168.1.100 -p 22
```

---

## Transfer files via ssh

Single file
```sh
## know your server/client ips
## ip a, or ifconfig, or ipconfig

## copy local to remote
scp ~/my_local_file.txt mezcel@192.168.1.101:~/RemoteDir

## copy remote to local
scp mezcel@192.168.1.100:~/Downloads/my_remote_file.txt ~/LocalDir/

## note:
## if the ip user destination is "mezcel"
## instead of '~/', use '/home/mezcel/' instead
```

Directory folders
```sh
## create a zip file
zip myZipFile.zip ~/DesiredDir

## unzip zip file
unzip -x myZipFile.zip
```

### Git Trasfer

source server computer
```sh
mkdir myProjDir
cd myProjDir
git init

## start git server
git daemon --verbose --export-all
```

clone to computer
```sh
cd <desired directory>
git clone git://<server ip>/<source repo path>

## example:
## git clone git://10.42.0.1/home/mezcel/github/myRepo
```

---

## Clearing old connections

* Used when multiple users all have the same ip, username, and ps
* mostly for debugging

```sh
cp ~/.ssh/known_hosts ~/.ssh/known_hosts.old
```
---

## Setting up a network

* When I use SSH, I prefer to use ```NetworkManager``` on an **Archlinux** ssh server.
	* I made [nmcli-sshd.sh](https://github.com/mezcel/simple-respin/blob/master/arch-files/network_manager_scripts/nmcli-sshd.sh) to automate the ```NetworkManager``` nmcli ethernet server configurations.

* When I am not using ssh, I revert to ```netctl``` in Archlinux or ```net-tools``` in Debian 10 or ```Win10's``` network configurations in WLS.
